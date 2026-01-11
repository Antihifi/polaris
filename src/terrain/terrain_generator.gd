class_name TerrainGenerator
extends Node
## Main orchestrator for procedural terrain generation.
## Coordinates all generation stages and emits progress signals.

## Signals for UI integration
signal generation_started
signal generation_progress(stage: String, percent: float)
signal generation_completed(pois: Dictionary)
signal generation_failed(reason: String)

## Terrain resolution (pixels)
const TERRAIN_RESOLUTION: int = 1024

## Meters per pixel in heightmap
const METERS_PER_PIXEL: float = 10.0

## NavMesh baking timeout (seconds)
const NAVMESH_TIMEOUT: float = 180.0

## References
var _terrain: Node = null  # Terrain3D node
var _nav_region: NavigationRegion3D = null
var _seed_manager: SeedManager = null

## Generated data (kept for debugging/save)
var _island_mask: Image = null
var _heightmap: Image = null
var _inlet_info: Dictionary = {}
var _pois: Dictionary = {}


## Main generation entry point
## Call this to generate terrain from a seed
func generate(seed_manager: SeedManager) -> void:
	_seed_manager = seed_manager
	generation_started.emit()

	print("[TerrainGenerator] ========================================")
	print("[TerrainGenerator] Starting generation with seed: %s" % _seed_manager.get_seed_string())
	print("[TerrainGenerator] ========================================")

	var start_time := Time.get_ticks_msec()

	# Find terrain nodes in scene
	if not _find_terrain_nodes():
		var error := "Could not find Terrain3D node in scene"
		push_error("[TerrainGenerator] %s" % error)
		generation_failed.emit(error)
		return

	# Stage 1: Generate island shape mask
	generation_progress.emit("Generating island shape...", 0.05)
	await get_tree().process_frame
	_generate_island_mask()

	# Stage 2: Generate heightmap
	generation_progress.emit("Generating heightmap...", 0.15)
	await get_tree().process_frame
	_generate_heightmap()

	# Debug: Save heightmap for inspection
	if _heightmap:
		var debug_path := "user://debug_heightmap.png"
		# Convert to visible format for debugging (normalize to 0-255)
		var debug_img := Image.create(_heightmap.get_width(), _heightmap.get_height(), false, Image.FORMAT_L8)
		var stats := HeightmapGenerator.get_height_stats(_heightmap)
		var height_range: float = stats.max - stats.min
		if height_range < 0.01:
			height_range = 1.0  # Prevent division by zero
		for y in range(_heightmap.get_height()):
			for x in range(_heightmap.get_width()):
				var h: float = _heightmap.get_pixel(x, y).r
				var normalized: float = (h - stats.min) / height_range
				var byte_val: int = int(clampf(normalized * 255.0, 0.0, 255.0))
				debug_img.set_pixel(x, y, Color8(byte_val, byte_val, byte_val))
		debug_img.save_png(debug_path)
		print("[TerrainGenerator] Debug heightmap saved to: %s" % debug_path)

	# Stage 3: Carve inlet for ship
	generation_progress.emit("Carving ship inlet...", 0.25)
	await get_tree().process_frame
	_carve_inlet()

	# Stage 4: Import to Terrain3D
	generation_progress.emit("Importing terrain data...", 0.35)
	await get_tree().process_frame
	if not await _import_to_terrain():
		generation_failed.emit("Failed to import terrain data")
		return

	# Wait for terrain to fully update (Terrain3D needs time to process import)
	await get_tree().process_frame
	await get_tree().process_frame

	# Verify terrain was imported by querying a height
	_verify_terrain_import()

	# Stage 5: Paint textures
	generation_progress.emit("Painting terrain textures...", 0.45)
	await get_tree().process_frame
	_paint_textures()

	# Stage 6: Update terrain
	generation_progress.emit("Updating terrain maps...", 0.55)
	await get_tree().process_frame
	_update_terrain_maps()

	# Stage 7: Bake NavMesh (slow)
	generation_progress.emit("Baking navigation mesh (this may take a minute)...", 0.60)
	await get_tree().process_frame
	await _bake_navigation_mesh()

	# Stage 8: Place POIs
	generation_progress.emit("Placing points of interest...", 0.90)
	await get_tree().process_frame
	_place_pois()

	# Stage 9: Validate POIs
	generation_progress.emit("Validating accessibility...", 0.95)
	await get_tree().process_frame
	_validate_pois()

	var elapsed := (Time.get_ticks_msec() - start_time) / 1000.0
	print("[TerrainGenerator] ========================================")
	print("[TerrainGenerator] Generation complete in %.1f seconds" % elapsed)
	print("[TerrainGenerator] Seed: %s" % _seed_manager.get_seed_string())
	print(POIPlacer.get_poi_summary(_pois, _pois.get("ship", Vector3.ZERO)))
	print("[TerrainGenerator] ========================================")

	generation_progress.emit("Complete!", 1.0)
	generation_completed.emit(_pois)


## Find Terrain3D and NavigationRegion3D nodes in scene
func _find_terrain_nodes() -> bool:
	var scene := get_tree().current_scene

	# First, check terrain group
	var terrain_nodes := get_tree().get_nodes_in_group("terrain")
	if terrain_nodes.size() > 0:
		for node in terrain_nodes:
			if node.get_class() == "Terrain3D" or "Terrain3D" in node.name:
				_terrain = node
				break

	# Fallback: search by class name
	if not _terrain:
		_terrain = _find_node_by_class(scene, "Terrain3D")

	if not _terrain:
		push_error("[TerrainGenerator] Terrain3D node not found!")
		return false

	# Find NavigationRegion3D (should be parent of Terrain3D)
	var parent := _terrain.get_parent()
	if parent is NavigationRegion3D:
		_nav_region = parent
	else:
		# Search for NavigationRegion3D in scene
		_nav_region = _find_node_by_class(scene, "NavigationRegion3D") as NavigationRegion3D

	if not _nav_region:
		push_warning("[TerrainGenerator] NavigationRegion3D not found - NavMesh baking will be skipped")

	print("[TerrainGenerator] Found Terrain3D: %s" % _terrain.name)
	if _nav_region:
		print("[TerrainGenerator] Found NavigationRegion3D: %s" % _nav_region.name)

	return true


## Recursively find a node by class name
func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	if node.get_class() == class_name_str:
		return node

	# Check if node name contains the class (for custom nodes)
	if class_name_str in node.name:
		return node

	for child in node.get_children():
		var found := _find_node_by_class(child, class_name_str)
		if found:
			return found

	return null


## Stage 1: Generate island shape mask
func _generate_island_mask() -> void:
	print("[TerrainGenerator] Generating island mask...")
	var shape_rng := _seed_manager.get_shape_rng()
	_island_mask = IslandShape.generate_mask(TERRAIN_RESOLUTION, TERRAIN_RESOLUTION, shape_rng)

	# Optionally add fjords for more interesting coastline
	var fjord_rng := _seed_manager.get_shape_rng()
	fjord_rng.seed = _seed_manager.current_seed ^ 0x24681357
	IslandShape.add_fjords(_island_mask, fjord_rng, 2)

	print("[TerrainGenerator] Island mask generated: %dx%d" % [
		_island_mask.get_width(),
		_island_mask.get_height()
	])


## Stage 2: Generate heightmap
func _generate_heightmap() -> void:
	print("[TerrainGenerator] Generating heightmap...")
	var height_rng := _seed_manager.get_height_rng()
	_heightmap = HeightmapGenerator.generate_heightmap(
		TERRAIN_RESOLUTION,
		TERRAIN_RESOLUTION,
		_island_mask,
		height_rng
	)

	var stats := HeightmapGenerator.get_height_stats(_heightmap)
	print("[TerrainGenerator] Height range: %.1f to %.1f meters (avg: %.1f)" % [
		stats.min,
		stats.max,
		stats.average
	])


## Stage 3: Carve inlet for ship spawn
func _carve_inlet() -> void:
	print("[TerrainGenerator] Carving ship inlet...")
	var inlet_rng := _seed_manager.get_inlet_rng()
	_inlet_info = HeightmapGenerator.carve_inlet(_heightmap, _island_mask, inlet_rng)

	print("[TerrainGenerator] Inlet carved at: %s (%s side)" % [
		_inlet_info.position,
		"east" if _inlet_info.east_side else "west"
	])


## Stage 4: Import heightmap to Terrain3D
## CRITICAL: import_images() does NOT create regions - it only imports INTO existing regions.
## We must use add_region_blankp() to create regions at runtime, then set_height() to apply data.
func _import_to_terrain() -> bool:
	print("[TerrainGenerator] Creating terrain regions and importing heights...")

	if not _terrain or not "data" in _terrain:
		push_error("[TerrainGenerator] No Terrain3D!")
		return false

	var terrain_data = _terrain.data
	if not terrain_data:
		push_error("[TerrainGenerator] No terrain data!")
		return false

	# Debug: Print heightmap stats before import
	var stats := HeightmapGenerator.get_height_stats(_heightmap)
	print("[TerrainGenerator] Heightmap stats - Min: %.2f, Max: %.2f, Avg: %.2f" % [
		stats.min, stats.max, stats.average
	])

	# Clear data_directory to start fresh (no disk-loaded regions)
	if "data_directory" in _terrain:
		var old_dir: String = _terrain.data_directory
		if not old_dir.is_empty():
			print("[TerrainGenerator] Clearing data_directory (was: %s)" % old_dir)
			_terrain.data_directory = ""

	# Re-fetch terrain_data after clearing (may have been recreated)
	terrain_data = _terrain.data
	if not terrain_data:
		push_error("[TerrainGenerator] Terrain data null after clearing!")
		return false

	# Remove any existing regions
	if terrain_data.has_method("get_regions_active"):
		var regions = terrain_data.get_regions_active()
		print("[TerrainGenerator] Clearing %d existing regions..." % regions.size())
		for region in regions:
			if terrain_data.has_method("remove_region"):
				terrain_data.remove_region(region, false)

	# Set vertex spacing BEFORE creating regions
	# This is CRITICAL - affects region size in world units
	if "vertex_spacing" in _terrain:
		_terrain.vertex_spacing = METERS_PER_PIXEL  # 10.0
		print("[TerrainGenerator] Set vertex_spacing to %.1f" % METERS_PER_PIXEL)
	else:
		push_warning("[TerrainGenerator] Could not set vertex_spacing!")

	# Re-fetch terrain_data after changing vertex_spacing
	terrain_data = _terrain.data
	if not terrain_data:
		push_error("[TerrainGenerator] Terrain data null after setting vertex_spacing!")
		return false

	# Calculate terrain bounds
	var terrain_size := float(TERRAIN_RESOLUTION) * METERS_PER_PIXEL  # 1024 * 10 = 10240m
	var half_size := terrain_size / 2.0  # 5120m

	# Get region size (default is 1024 vertices, so 1024 * vertex_spacing meters)
	var region_size_vertices: int = 1024
	if _terrain.has_method("get_region_size"):
		region_size_vertices = _terrain.get_region_size()
	var region_size_meters: float = float(region_size_vertices) * METERS_PER_PIXEL

	print("[TerrainGenerator] Region size: %d vertices = %.0fm" % [region_size_vertices, region_size_meters])
	print("[TerrainGenerator] Terrain size: %.0fm x %.0fm (half: %.0fm)" % [terrain_size, terrain_size, half_size])

	# Create blank regions to cover the entire terrain
	# We need regions from -half_size to +half_size on both X and Z
	var regions_created := 0
	var step := region_size_meters
	var z := -half_size
	while z < half_size:
		var x := -half_size
		while x < half_size:
			var world_pos := Vector3(x + step / 2.0, 0, z + step / 2.0)  # Center of region
			if terrain_data.has_method("add_region_blankp"):
				terrain_data.add_region_blankp(world_pos, false)
				regions_created += 1
			else:
				push_error("[TerrainGenerator] add_region_blankp() method not found!")
				return false
			x += step
		z += step

	print("[TerrainGenerator] Created %d blank regions" % regions_created)

	# Verify regions were created
	var region_count: int = 0
	if terrain_data.has_method("get_region_count"):
		region_count = terrain_data.get_region_count()
	print("[TerrainGenerator] Region count after creation: %d" % region_count)
	if region_count == 0:
		push_error("[TerrainGenerator] Failed to create regions!")
		return false

	# Now set height values from our procedural heightmap
	print("[TerrainGenerator] Applying heightmap data to %d x %d pixels..." % [_heightmap.get_width(), _heightmap.get_height()])
	var width := _heightmap.get_width()
	var height := _heightmap.get_height()
	var half_width := float(width) / 2.0
	var half_height := float(height) / 2.0

	for py in range(height):
		for px in range(width):
			var h: float = _heightmap.get_pixel(px, py).r
			var world_x := (float(px) - half_width) * METERS_PER_PIXEL
			var world_z := (float(py) - half_height) * METERS_PER_PIXEL
			terrain_data.set_height(Vector3(world_x, 0, world_z), h)

		# Progress update every 64 rows
		if py % 64 == 0:
			await get_tree().process_frame
			generation_progress.emit("Applying heights...", 0.35 + 0.15 * (float(py) / float(height)))

	print("[TerrainGenerator] Heightmap data applied")

	# Finalize terrain - order matters!
	# 1. Force terrain to recalculate height range first
	if terrain_data.has_method("calc_height_range"):
		terrain_data.calc_height_range(true)
		print("[TerrainGenerator] Height range recalculated")

	# 2. Update all terrain maps (height, control, color)
	if terrain_data.has_method("update_maps"):
		terrain_data.update_maps()
		print("[TerrainGenerator] Terrain maps updated")

	# 3. Wait for terrain to process the updates
	await get_tree().process_frame
	await get_tree().process_frame

	# 4. Force terrain to rebuild its visual mesh
	if _terrain.has_method("update_aabbs"):
		_terrain.update_aabbs()
		print("[TerrainGenerator] Terrain AABBs updated")

	# 5. Update collider for physics (important for raycasting)
	if _terrain.has_method("update_collider"):
		_terrain.update_collider()
		print("[TerrainGenerator] Collider updated")

	# 6. Wait more frames for terrain mesh to fully rebuild
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	print("[TerrainGenerator] Terrain import complete!")
	return true


## Verify terrain import by querying heights at known locations
func _verify_terrain_import() -> void:
	if not _terrain or not "data" in _terrain or not _terrain.data:
		push_warning("[TerrainGenerator] Cannot verify import - no terrain data")
		return

	var terrain_data = _terrain.data

	# Test multiple positions to verify terrain data is actually applied
	var test_positions: Array[Vector3] = [
		Vector3(0, 0, 0),            # Center
		Vector3(1000, 0, 1000),      # NE quadrant
		Vector3(-1000, 0, -1000),    # SW quadrant
		Vector3(2000, 0, 0),         # East
		Vector3(0, 0, -2000),        # North
	]

	print("[TerrainGenerator] === HEIGHT VERIFICATION ===")
	var all_valid := true
	for pos in test_positions:
		if terrain_data.has_method("get_height"):
			var h: float = terrain_data.get_height(pos)
			var status := "OK" if h > -100.0 and h < 1000.0 and not is_nan(h) else "INVALID"
			print("[TerrainGenerator] Height at %s: %.2f [%s]" % [pos, h, status])
			if status == "INVALID":
				all_valid = false

	# Query height at ship inlet position
	var ship_pos := _inlet_info.get("position", Vector3.ZERO) as Vector3
	if terrain_data.has_method("get_height"):
		var ship_height: float = terrain_data.get_height(ship_pos)
		print("[TerrainGenerator] Height at ship pos %s: %.2f" % [ship_pos, ship_height])

	# Get region info
	if terrain_data.has_method("get_region_count"):
		print("[TerrainGenerator] Final region count: %d" % terrain_data.get_region_count())

	# Check min/max height in terrain data
	if terrain_data.has_method("get_height_range"):
		var height_range: Vector2 = terrain_data.get_height_range()
		print("[TerrainGenerator] Terrain data height range: min=%.2f, max=%.2f" % [height_range.x, height_range.y])

	if not all_valid:
		push_error("[TerrainGenerator] HEIGHT VERIFICATION FAILED - terrain may not be properly imported!")
	else:
		print("[TerrainGenerator] === HEIGHT VERIFICATION PASSED ===")


## Stage 5: Paint textures
func _paint_textures() -> void:
	print("[TerrainGenerator] Painting textures...")

	if not _terrain or not "data" in _terrain:
		push_warning("[TerrainGenerator] Cannot paint textures - no terrain data")
		return

	var texture_rng := _seed_manager.get_texture_rng()
	TexturePainter.paint_terrain(_terrain.data, _heightmap, _island_mask, texture_rng)

	var stats := TexturePainter.get_texture_stats(_heightmap, _island_mask)
	print("[TerrainGenerator] Texture distribution: Snow %.1f%%, Rock %.1f%%, Ice %.1f%%, Gravel %.1f%%" % [
		stats.snow_percent,
		stats.rock_percent,
		stats.ice_percent,
		stats.gravel_percent
	])


## Stage 6: Update terrain maps
func _update_terrain_maps() -> void:
	if not _terrain or not "data" in _terrain:
		return

	var terrain_data = _terrain.data
	if terrain_data.has_method("update_maps"):
		terrain_data.update_maps()
		print("[TerrainGenerator] Terrain maps updated")


## Stage 7: Bake navigation mesh
## IMPORTANT: Standard NavigationRegion3D.bake_navigation_mesh() does NOT work with Terrain3D!
## We must use Terrain3D's generate_nav_mesh_source_geometry() and bake manually.
## See: https://terrain3d.readthedocs.io/en/stable/docs/navigation.html
func _bake_navigation_mesh() -> void:
	if not _nav_region or not _terrain:
		push_warning("[TerrainGenerator] No NavigationRegion3D or Terrain3D - skipping NavMesh bake")
		return

	print("[TerrainGenerator] Starting NavMesh bake using Terrain3D API...")
	var start_time := Time.get_ticks_msec()

	# Wait additional frames to ensure terrain mesh is fully built
	print("[TerrainGenerator] Waiting for terrain mesh to be ready...")
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	# Verify terrain has active regions before attempting to bake
	if "data" in _terrain and _terrain.data:
		var terrain_data = _terrain.data
		if terrain_data.has_method("get_region_count"):
			var region_count: int = terrain_data.get_region_count()
			print("[TerrainGenerator] Terrain has %d active regions" % region_count)
			if region_count == 0:
				push_error("[TerrainGenerator] No terrain regions - cannot bake NavMesh!")
				return

		# Debug: Check if terrain has valid height data
		if terrain_data.has_method("get_height"):
			var test_h: float = terrain_data.get_height(Vector3(0, 0, 0))
			print("[TerrainGenerator] Pre-bake height check at origin: %.2f" % test_h)

		# Debug: Check height range
		if terrain_data.has_method("get_height_range"):
			var hr: Vector2 = terrain_data.get_height_range()
			print("[TerrainGenerator] Pre-bake height range: min=%.2f, max=%.2f" % [hr.x, hr.y])

	# Get or create NavigationMesh
	var nav_mesh: NavigationMesh = _nav_region.navigation_mesh
	if not nav_mesh:
		nav_mesh = NavigationMesh.new()

	# Configure baking area (only island, not infinite ice)
	var half_size := TERRAIN_RESOLUTION * METERS_PER_PIXEL / 2.0
	nav_mesh.filter_baking_aabb = AABB(
		Vector3(-half_size - 500, -50, -half_size - 500),
		Vector3(half_size * 2 + 1000, 500, half_size * 2 + 1000)
	)

	# Agent settings
	nav_mesh.agent_radius = 0.5
	nav_mesh.agent_height = 1.8
	nav_mesh.agent_max_climb = 0.5
	nav_mesh.agent_max_slope = 45.0

	# Cell settings - balance between detail and performance
	# Smaller cells = more accurate NavMesh but slower bake
	# For 10km terrain with 40m grid resolution from heightmap fallback
	nav_mesh.cell_size = 2.0  # Reduced from 4.0 for better accuracy
	nav_mesh.cell_height = 0.5  # Reduced from 1.0

	# Region settings to help with large terrain
	nav_mesh.region_min_size = 8.0  # Minimum region area
	nav_mesh.region_merge_size = 20.0  # Merge small regions

	# Apply to region
	_nav_region.navigation_mesh = nav_mesh

	# Create source geometry data
	var source_geometry := NavigationMeshSourceGeometryData3D.new()

	# Parse existing scene geometry first (non-terrain objects)
	NavigationServer3D.parse_source_geometry_data(nav_mesh, source_geometry, _nav_region)

	# Get terrain geometry using Terrain3D's method
	# This is the KEY difference from standard baking - Terrain3D provides its own geometry
	var aabb: AABB = nav_mesh.filter_baking_aabb
	aabb.position += nav_mesh.filter_baking_aabb_offset
	aabb = _nav_region.global_transform * aabb

	print("[TerrainGenerator] Fetching terrain geometry for AABB: %s" % aabb)
	print("[TerrainGenerator] Terrain vertex_spacing: %s" % str(_terrain.get("vertex_spacing")))
	print("[TerrainGenerator] Terrain visible: %s" % str(_terrain.visible if "visible" in _terrain else "N/A"))

	# Debug: Check terrain's bounding box
	if _terrain.has_method("get_aabb"):
		var terrain_aabb: AABB = _terrain.get_aabb()
		print("[TerrainGenerator] Terrain AABB: %s" % terrain_aabb)

	if _terrain.has_method("generate_nav_mesh_source_geometry"):
		var faces: PackedVector3Array = _terrain.generate_nav_mesh_source_geometry(aabb)
		print("[TerrainGenerator] generate_nav_mesh_source_geometry returned %d vertices (%d faces)" % [faces.size(), faces.size() / 3])
		if not faces.is_empty():
			source_geometry.add_faces(faces, Transform3D.IDENTITY)
			print("[TerrainGenerator] Added %d terrain faces to source geometry" % (faces.size() / 3))
		else:
			push_warning("[TerrainGenerator] No terrain faces generated! NavMesh may be empty.")
			push_warning("[TerrainGenerator] This usually means terrain mesh hasn't been built yet.")
			push_warning("[TerrainGenerator] Terrain regions exist but mesh generation may require more processing time.")

			# Try alternative: manually generate faces from height data
			print("[TerrainGenerator] Attempting fallback: generate faces from height data...")
			faces = _generate_navmesh_faces_from_heightmap()
			if not faces.is_empty():
				source_geometry.add_faces(faces, Transform3D.IDENTITY)
				print("[TerrainGenerator] Fallback: Added %d faces from heightmap" % (faces.size() / 3))
	else:
		push_error("[TerrainGenerator] Terrain3D missing generate_nav_mesh_source_geometry method!")
		return

	# Bake the navmesh using NavigationServer3D
	print("[TerrainGenerator] Baking NavMesh from source geometry...")
	NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)

	# Verify NavMesh has polygons
	var polygon_count := nav_mesh.get_polygon_count()
	var vertex_count := nav_mesh.get_vertices().size()
	print("[TerrainGenerator] NavMesh baked: %d polygons, %d vertices" % [polygon_count, vertex_count])

	if polygon_count == 0:
		push_error("[TerrainGenerator] NavMesh has NO polygons! Pathfinding will fail!")
	else:
		print("[TerrainGenerator] NavMesh looks valid!")
		# Debug: Print actual NavMesh bounds
		var nav_verts := nav_mesh.get_vertices()
		if nav_verts.size() > 0:
			var nav_min := Vector3(INF, INF, INF)
			var nav_max := Vector3(-INF, -INF, -INF)
			for v in nav_verts:
				nav_min.x = minf(nav_min.x, v.x)
				nav_min.y = minf(nav_min.y, v.y)
				nav_min.z = minf(nav_min.z, v.z)
				nav_max.x = maxf(nav_max.x, v.x)
				nav_max.y = maxf(nav_max.y, v.y)
				nav_max.z = maxf(nav_max.z, v.z)
			print("[TerrainGenerator] NavMesh actual bounds: min=%s, max=%s" % [nav_min, nav_max])
			print("[TerrainGenerator] NavMesh actual size: %.0f x %.0f meters" % [nav_max.x - nav_min.x, nav_max.z - nav_min.z])

	# Force navigation region to update (same technique as Terrain3D's baker.gd)
	_nav_region.set_navigation_mesh(null)
	_nav_region.set_navigation_mesh(nav_mesh)

	# CRITICAL: Wait for NavigationServer to process the new NavMesh
	# The NavigationServer updates asynchronously, so we need to wait
	await get_tree().process_frame
	await get_tree().process_frame

	# Force all NavigationAgent3D nodes to re-sync with the updated map
	_refresh_all_navigation_agents()

	var total_time := (Time.get_ticks_msec() - start_time) / 1000.0
	print("[TerrainGenerator] NavMesh bake completed in %.1f seconds" % total_time)


## Refresh all NavigationAgent3D nodes to re-acquire the updated navigation map
## This is necessary because NavMesh changes don't automatically update existing agents
func _refresh_all_navigation_agents() -> void:
	print("[TerrainGenerator] Refreshing navigation agents...")

	# Get the navigation map from the region
	var nav_map := _nav_region.get_navigation_map()
	print("[TerrainGenerator] Navigation map RID: %s" % nav_map)

	# Find all NavigationAgent3D nodes in the scene
	var agents_refreshed := 0
	var scene := get_tree().current_scene
	var nav_agents := _find_all_nodes_of_class(scene, "NavigationAgent3D")

	for agent in nav_agents:
		if agent is NavigationAgent3D:
			# Force agent to re-acquire map by setting navigation_map
			agent.set_navigation_map(nav_map)
			agents_refreshed += 1

			# Debug: Check if agent can now pathfind
			var agent_pos: Vector3 = agent.get_parent().global_position if agent.get_parent() else Vector3.ZERO
			var closest_point := NavigationServer3D.map_get_closest_point(nav_map, agent_pos)
			var distance := agent_pos.distance_to(closest_point)
			print("[TerrainGenerator] Agent '%s' at %s -> closest NavMesh point: %s (dist: %.2f)" % [
				agent.get_parent().name if agent.get_parent() else "unknown",
				agent_pos,
				closest_point,
				distance
			])

	print("[TerrainGenerator] Refreshed %d navigation agents" % agents_refreshed)


## Find all nodes of a specific class in the scene tree
func _find_all_nodes_of_class(node: Node, class_name_str: String) -> Array[Node]:
	var result: Array[Node] = []
	if node.get_class() == class_name_str:
		result.append(node)
	for child in node.get_children():
		result.append_array(_find_all_nodes_of_class(child, class_name_str))
	return result


## Generate NavMesh faces directly from heightmap (fallback when Terrain3D mesh not ready)
## This creates a simple grid mesh from our procedural heightmap data
## Only generates faces for the island (using mask), not the surrounding ice
func _generate_navmesh_faces_from_heightmap() -> PackedVector3Array:
	var faces := PackedVector3Array()

	if not _heightmap:
		push_error("[TerrainGenerator] No heightmap for fallback NavMesh generation!")
		return faces

	if not _island_mask:
		push_warning("[TerrainGenerator] No island mask - generating full terrain NavMesh")

	var width := _heightmap.get_width()
	var height := _heightmap.get_height()
	var half_width := float(width) / 2.0
	var half_height := float(height) / 2.0

	# Use a moderate resolution for NavMesh (every 2nd pixel = ~20m resolution)
	# This balances NavMesh quality with bake performance
	var step := 2
	var nav_res_x := width / step
	var nav_res_z := height / step

	print("[TerrainGenerator] Generating NavMesh grid from heightmap (step=%d)..." % step)

	# Build faces dynamically (can't pre-allocate since we're filtering by mask)
	var temp_faces: Array[Vector3] = []
	var skipped_ice := 0
	var skipped_steep := 0

	for gz in range(nav_res_z - 1):
		for gx in range(nav_res_x - 1):
			# Get heightmap pixel coordinates
			var px0 := gx * step
			var pz0 := gz * step
			var px1 := (gx + 1) * step
			var pz1 := (gz + 1) * step

			# Check island mask - skip if all corners are outside island (ice)
			if _island_mask:
				var m00: float = _island_mask.get_pixel(px0, pz0).r
				var m10: float = _island_mask.get_pixel(px1, pz0).r
				var m01: float = _island_mask.get_pixel(px0, pz1).r
				var m11: float = _island_mask.get_pixel(px1, pz1).r
				var mask_avg := (m00 + m10 + m01 + m11) / 4.0
				if mask_avg < 0.1:  # Skip if mostly outside island
					skipped_ice += 1
					continue

			# Get heights at four corners
			var h00: float = _heightmap.get_pixel(px0, pz0).r
			var h10: float = _heightmap.get_pixel(px1, pz0).r
			var h01: float = _heightmap.get_pixel(px0, pz1).r
			var h11: float = _heightmap.get_pixel(px1, pz1).r

			# Skip very steep areas (slope > 60 degrees over 20m = height diff > 34m)
			var max_height_diff := maxf(maxf(absf(h00 - h10), absf(h00 - h01)),
									   maxf(absf(h10 - h11), absf(h01 - h11)))
			if max_height_diff > 35.0:
				skipped_steep += 1
				continue

			# Convert to world coordinates
			var wx0 := (float(px0) - half_width) * METERS_PER_PIXEL
			var wz0 := (float(pz0) - half_height) * METERS_PER_PIXEL
			var wx1 := (float(px1) - half_width) * METERS_PER_PIXEL
			var wz1 := (float(pz1) - half_height) * METERS_PER_PIXEL

			# Create vertices
			var v00 := Vector3(wx0, h00, wz0)
			var v10 := Vector3(wx1, h10, wz0)
			var v01 := Vector3(wx0, h01, wz1)
			var v11 := Vector3(wx1, h11, wz1)

			# Triangle 1: v00, v01, v10 (counter-clockwise winding for upward-facing)
			temp_faces.append(v00)
			temp_faces.append(v01)
			temp_faces.append(v10)

			# Triangle 2: v10, v01, v11 (counter-clockwise winding)
			temp_faces.append(v10)
			temp_faces.append(v01)
			temp_faces.append(v11)

	# Convert to PackedVector3Array
	faces.resize(temp_faces.size())
	for i in range(temp_faces.size()):
		faces[i] = temp_faces[i]

	print("[TerrainGenerator] Generated %d faces (skipped %d ice, %d steep)" % [
		faces.size() / 3, skipped_ice, skipped_steep
	])

	# Debug: Print bounds of generated mesh
	var min_pos := Vector3(INF, INF, INF)
	var max_pos := Vector3(-INF, -INF, -INF)
	for v in faces:
		min_pos.x = minf(min_pos.x, v.x)
		min_pos.y = minf(min_pos.y, v.y)
		min_pos.z = minf(min_pos.z, v.z)
		max_pos.x = maxf(max_pos.x, v.x)
		max_pos.y = maxf(max_pos.y, v.y)
		max_pos.z = maxf(max_pos.z, v.z)
	print("[TerrainGenerator] NavMesh faces bounds: min=%s, max=%s" % [min_pos, max_pos])
	print("[TerrainGenerator] NavMesh faces size: %.0f x %.0f meters" % [max_pos.x - min_pos.x, max_pos.z - min_pos.z])

	return faces


## Stage 8: Place POIs
func _place_pois() -> void:
	print("[TerrainGenerator] Placing POIs...")
	var poi_rng := _seed_manager.get_poi_rng()

	_pois = POIPlacer.place_pois(
		_heightmap,
		_island_mask,
		_inlet_info.position,
		poi_rng
	)


## Stage 9: Validate POI accessibility
func _validate_pois() -> void:
	if not _nav_region:
		push_warning("[TerrainGenerator] Cannot validate POIs - no NavigationRegion3D")
		return

	# Wait a frame for NavMesh to be fully ready
	await get_tree().process_frame

	var validation := POIPlacer.validate_poi_accessibility(
		_nav_region,
		_pois.get("ship", Vector3.ZERO),
		_pois
	)

	if not validation.all_valid:
		push_warning("[TerrainGenerator] Some POIs are unreachable!")
		for unreachable in validation.unreachable:
			push_warning("  - %s at %s" % [unreachable.name, unreachable.position])


## Get the generated POIs dictionary
func get_pois() -> Dictionary:
	return _pois.duplicate(true)


## Get the ship spawn position
func get_ship_position() -> Vector3:
	return _pois.get("ship", Vector3.ZERO)


## Get the seed string for display
func get_seed_string() -> String:
	if _seed_manager:
		return _seed_manager.get_seed_string()
	return ""


## Save heightmap to file for debugging
func save_heightmap_debug(path: String) -> void:
	if _heightmap:
		_heightmap.save_png(path)
		print("[TerrainGenerator] Heightmap saved to: %s" % path)


## Save mask to file for debugging
func save_mask_debug(path: String) -> void:
	if _island_mask:
		_island_mask.save_png(path)
		print("[TerrainGenerator] Mask saved to: %s" % path)
