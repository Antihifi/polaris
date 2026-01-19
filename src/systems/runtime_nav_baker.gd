class_name RuntimeNavBaker extends Node
## Dynamic NavMesh baker that follows the player.
## Adapted from Terrain3D demo's RuntimeNavigationBaker.gd
## Bakes NavMesh in chunks around the player for efficient runtime navigation.

signal bake_finished

@export var enabled: bool = true : set = set_enabled
@export var enter_cost: float = 0.0 : set = set_enter_cost
@export var travel_cost: float = 1.0 : set = set_travel_cost
@export_flags_3d_navigation var navigation_layers: int = 1 : set = set_navigation_layers
@export var template: NavigationMesh : set = set_template

## Reference to Terrain3D node (set by controller after terrain creation)
var terrain: Node = null

## Node to track for NavMesh baking (usually the captain/player)
@export var player: Node3D

## Size of NavMesh chunk to bake (256x512x256 = 256m wide, 512m tall, 256m deep)
@export var mesh_size := Vector3(256, 512, 256)

## Minimum distance player must move before re-baking
@export var min_rebake_distance: float = 64.0

## Cooldown between bakes to prevent spam
@export var bake_cooldown: float = 1.0

@export_group("Debug")
@export var log_timing: bool = true  # Enable timing logs by default for debugging

var _scene_geometry: NavigationMeshSourceGeometryData3D
var _current_center := Vector3(INF, INF, INF)

var _bake_task_id: int = -1
var _bake_task_timer: float = 0.0
var _bake_cooldown_timer: float = 0.0
var _nav_region: NavigationRegion3D


func _ready() -> void:
	add_to_group("nav_baker")  # For clickable_unit to find us

	_nav_region = NavigationRegion3D.new()
	_nav_region.name = "DynamicNavRegion"
	_nav_region.navigation_layers = navigation_layers
	_nav_region.enabled = enabled
	_nav_region.enter_cost = enter_cost
	_nav_region.travel_cost = travel_cost

	# Demo uses edge_connections = false to avoid performance hitches during rebakes.
	# Edge connections cause the main thread to compare every edge when navmesh updates.
	_nav_region.use_edge_connections = false

	add_child(_nav_region)

	# Create default template if not provided - MATCH DEMO EXACTLY
	# See tmp/demo/CodeGeneratedDemo.tscn NavigationMesh_vs6am
	if not template:
		template = NavigationMesh.new()
		# Use STATIC_COLLIDERS since we add terrain faces manually via add_faces()
		template.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
		template.agent_height = 2.0
		template.agent_max_slope = 30.0  # Demo default (not 45)

	# MUST update map cell size AFTER template is set
	_update_map_cell_size()

	print("[RuntimeNavBaker] Initialized with cell_size=%.2f, cell_height=%.2f, slope=%.0f, edge_connections=%s" % [
		template.cell_size, template.cell_height, template.agent_max_slope, _nav_region.use_edge_connections])

	# Parse existing scene geometry after scene is ready
	parse_scene.call_deferred()


func set_enabled(p_value: bool) -> void:
	enabled = p_value
	if _nav_region:
		_nav_region.enabled = enabled
	set_process(enabled and template)


func set_enter_cost(p_value: float) -> void:
	enter_cost = p_value
	if _nav_region:
		_nav_region.enter_cost = enter_cost


func set_travel_cost(p_value: float) -> void:
	travel_cost = p_value
	if _nav_region:
		_nav_region.travel_cost = travel_cost


func set_navigation_layers(p_value: int) -> void:
	navigation_layers = p_value
	if _nav_region:
		_nav_region.navigation_layers = navigation_layers


func set_template(p_value: NavigationMesh) -> void:
	template = p_value
	set_process(enabled and template)
	_update_map_cell_size()


func parse_scene() -> void:
	_scene_geometry = NavigationMeshSourceGeometryData3D.new()
	NavigationServer3D.parse_source_geometry_data(template, _scene_geometry, self)


func _update_map_cell_size() -> void:
	# Match demo: just set cell size/height, nothing else
	if get_viewport() and template:
		var map := get_viewport().find_world_3d().navigation_map
		NavigationServer3D.map_set_cell_size(map, template.cell_size)
		NavigationServer3D.map_set_cell_height(map, template.cell_height)


func _process(p_delta: float) -> void:
	if _bake_task_id != -1:
		_bake_task_timer += p_delta

	if not player or _bake_task_id != -1:
		return

	if _bake_cooldown_timer > 0.0:
		_bake_cooldown_timer -= p_delta
		return

	var track_pos := player.global_position
	if player is CharacterBody3D:
		# Center on where the player is likely _going to be_:
		track_pos += player.velocity * bake_cooldown

	if track_pos.distance_squared_to(_current_center) >= min_rebake_distance * min_rebake_distance:
		_current_center = track_pos
		_rebake(_current_center)


func _rebake(p_center: Vector3) -> void:
	if not template:
		push_error("[RuntimeNavBaker] No template NavigationMesh!")
		return
	_bake_task_id = WorkerThreadPool.add_task(_task_bake.bind(p_center), false, "RuntimeNavBaker")
	_bake_task_timer = 0.0
	_bake_cooldown_timer = bake_cooldown


func _task_bake(p_center: Vector3) -> void:
	var nav_mesh: NavigationMesh = template.duplicate()
	nav_mesh.filter_baking_aabb = AABB(-mesh_size * 0.5, mesh_size)
	nav_mesh.filter_baking_aabb_offset = p_center
	var source_geometry: NavigationMeshSourceGeometryData3D
	if _scene_geometry:
		source_geometry = _scene_geometry.duplicate()
	else:
		source_geometry = NavigationMeshSourceGeometryData3D.new()

	var faces_added := 0
	if terrain and terrain.has_method("generate_nav_mesh_source_geometry"):
		var aabb: AABB = nav_mesh.filter_baking_aabb
		aabb.position += nav_mesh.filter_baking_aabb_offset
		print("[RuntimeNavBaker] Requesting faces for AABB: pos=%s, size=%s" % [aabb.position, aabb.size])
		# CRITICAL: Second param MUST be false for procedural terrain!
		# true  = only generates geometry for terrain painted navigable in editor (0 faces for procedural!)
		# false = generates geometry for ENTIRE terrain regardless of paint
		# The editor baker (addons/terrain_3d/menu/baker.gd) uses single-param because
		# editor terrain has painted nav areas. We MUST use false for procedural.
		var faces: PackedVector3Array = terrain.generate_nav_mesh_source_geometry(aabb, false)
		faces_added = faces.size()
		source_geometry.add_faces(faces, Transform3D.IDENTITY)

		# Debug: Check height of first few faces (terrain transform check removed - thread unsafe)
		if faces.size() >= 3:
			var face_y_min := INF
			var face_y_max := -INF
			for i in range(mini(faces.size(), 30)):  # Check first 10 triangles
				face_y_min = minf(face_y_min, faces[i].y)
				face_y_max = maxf(face_y_max, faces[i].y)
			print("[RuntimeNavBaker] Face Y range (sample): %.2f to %.2f" % [face_y_min, face_y_max])

		print("[RuntimeNavBaker] Added %d terrain faces at center %s" % [faces_added, p_center])
	else:
		print("[RuntimeNavBaker] WARNING: No terrain or missing generate_nav_mesh_source_geometry method!")

	if source_geometry.has_data():
		# Debug: Show bake center height vs actual terrain height
		print("[RuntimeNavBaker] Bake center: %s" % p_center)
		NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)
		_bake_finished.call_deferred(nav_mesh)
	else:
		print("[RuntimeNavBaker] WARNING: No source geometry data!")
		_bake_finished.call_deferred(null)


func _bake_finished(p_nav_mesh: NavigationMesh) -> void:
	if log_timing:
		print("[RuntimeNavBaker] Bake took %.3fs" % _bake_task_timer)

	_bake_task_timer = 0.0
	_bake_task_id = -1

	if p_nav_mesh:
		# DISCOVERY #1 FIX (2026-01-12): Apply post-processing from editor baker
		# See: addons/terrain_3d/menu/baker.gd lines 225-242
		# This fixes Godot issue #85548 where navigation fails despite having polygons
		var before_polys := p_nav_mesh.get_polygon_count()
		_postprocess_nav_mesh(p_nav_mesh)
		var after_polys := p_nav_mesh.get_polygon_count()
		print("[RuntimeNavBaker] Post-processing: %d -> %d polygons" % [before_polys, after_polys])

		# DISCOVERY #1 FIX (2026-01-12): Null-reassign trick from editor baker
		# See: addons/terrain_3d/menu/baker.gd lines 213-215
		# Forces NavigationServer to properly re-register the mesh
		_nav_region.navigation_mesh = null
		_nav_region.navigation_mesh = p_nav_mesh

		var polygon_count := p_nav_mesh.get_polygon_count()
		var vertices := p_nav_mesh.get_vertices()
		print("[RuntimeNavBaker] NavMesh ready: %d polygons, %d vertices (after post-processing)" % [polygon_count, vertices.size()])

		# Debug: Log vertex height range
		if vertices.size() > 0 and log_timing:
			var min_y := INF
			var max_y := -INF
			for v in vertices:
				min_y = minf(min_y, v.y)
				max_y = maxf(max_y, v.y)
			print("[RuntimeNavBaker] Vertex Y range: %.2f to %.2f" % [min_y, max_y])

		# DEBUG: Check which navigation map the region is on
		var region_map := _nav_region.get_navigation_map()
		var world_map := get_viewport().find_world_3d().navigation_map if get_viewport() else RID()
		print("[RuntimeNavBaker] Region map=%s, World map=%s, SAME=%s" % [region_map, world_map, region_map == world_map])
		print("[RuntimeNavBaker] Region enabled=%s, layers=%d" % [_nav_region.enabled, _nav_region.navigation_layers])

		# DEBUG: Check if NavMesh has valid cell sizes
		print("[RuntimeNavBaker] NavMesh cell_size=%.3f, cell_height=%.3f" % [p_nav_mesh.cell_size, p_nav_mesh.cell_height])

		# DEBUG: Query the map directly to see if region is registered
		var map_regions := NavigationServer3D.map_get_regions(region_map)
		print("[RuntimeNavBaker] Map has %d regions total" % map_regions.size())
	else:
		print("[RuntimeNavBaker] WARNING: Bake returned null NavMesh!")

	bake_finished.emit()


## Force an immediate bake at the given position
func force_bake_at(position: Vector3) -> void:
	_current_center = position
	_rebake(position)


## Get the NavigationRegion3D for agents to use
func get_nav_region() -> NavigationRegion3D:
	return _nav_region


## Get the navigation map RID
func get_navigation_map() -> RID:
	if _nav_region:
		return _nav_region.get_navigation_map()
	return RID()


## Ensure NavMesh coverage at target position (called by units on move command)
## Triggers rebake if target is significantly outside current NavMesh coverage.
func ensure_coverage(target_position: Vector3) -> void:
	var nav_map := get_navigation_map()
	if not nav_map.is_valid():
		return
	# Skip if a bake is already in progress
	if _bake_task_id != -1:
		return
	var closest := NavigationServer3D.map_get_closest_point(nav_map, target_position)
	var snap_dist := target_position.distance_to(closest)
	if snap_dist > 10.0:  # More than 10m outside NavMesh
		print("[RuntimeNavBaker] Target %.1fm outside coverage at %s, rebaking..." % [snap_dist, target_position])
		force_bake_at(target_position)


# ============================================================================
# POST-PROCESSING FUNCTIONS
# DISCOVERY #1 FIX (2026-01-12): Copied from addons/terrain_3d/menu/baker.gd
# These fix Godot issue #85548 where NavMesh shows polygons but navigation fails
# ============================================================================

func _postprocess_nav_mesh(p_nav_mesh: NavigationMesh) -> void:
	## Post-process the nav mesh to work around Godot issue #85548
	## Copied from addons/terrain_3d/menu/baker.gd lines 225-242

	# Round all vertices to nearest cell_size/cell_height so mesh doesn't
	# contain edges shorter than cell_size/cell_height (one cause of #85548)
	var vertices: PackedVector3Array = _postprocess_round_vertices(p_nav_mesh)

	# Rounding can collapse edges to 0 length. Remove empty polygons.
	var polygons: Array[PackedInt32Array] = _postprocess_remove_empty_polygons(p_nav_mesh, vertices)

	# Another cause of #85548 is overlapping polygons. Remove these.
	_postprocess_remove_overlapping_polygons(p_nav_mesh, vertices, polygons)

	p_nav_mesh.clear_polygons()
	p_nav_mesh.set_vertices(vertices)
	for polygon in polygons:
		p_nav_mesh.add_polygon(polygon)


func _postprocess_round_vertices(p_nav_mesh: NavigationMesh) -> PackedVector3Array:
	## Round vertices to cell_size/cell_height grid
	## Copied from addons/terrain_3d/menu/baker.gd lines 245-259
	assert(p_nav_mesh != null)
	assert(p_nav_mesh.cell_size > 0.0)
	assert(p_nav_mesh.cell_height > 0.0)

	var cell_size: Vector3 = Vector3(p_nav_mesh.cell_size, p_nav_mesh.cell_height, p_nav_mesh.cell_size)

	# Round harder to avoid floating point errors with non-power-of-two cell sizes
	var round_factor := cell_size * 1.001

	var vertices: PackedVector3Array = p_nav_mesh.get_vertices()
	for i in range(vertices.size()):
		vertices[i] = (vertices[i] / round_factor).floor() * round_factor
	return vertices


func _postprocess_remove_empty_polygons(p_nav_mesh: NavigationMesh, p_vertices: PackedVector3Array) -> Array[PackedInt32Array]:
	## Remove polygons that became empty after vertex rounding
	## Copied from addons/terrain_3d/menu/baker.gd lines 262-283
	var polygons: Array[PackedInt32Array] = []

	for i in range(p_nav_mesh.get_polygon_count()):
		var old_polygon: PackedInt32Array = p_nav_mesh.get_polygon(i)
		var new_polygon: PackedInt32Array = []

		# Remove duplicate vertices (from rounding) from polygon
		var polygon_vertices: PackedVector3Array = []
		for index in old_polygon:
			var vertex: Vector3 = p_vertices[index]
			if polygon_vertices.has(vertex):
				continue
			polygon_vertices.push_back(vertex)
			new_polygon.push_back(index)

		# If we removed vertices, polygon might be degenerate
		if new_polygon.size() <= 2:
			continue
		polygons.push_back(new_polygon)

	return polygons


func _postprocess_remove_overlapping_polygons(p_nav_mesh: NavigationMesh, p_vertices: PackedVector3Array, p_polygons: Array[PackedInt32Array]) -> void:
	## Remove overlapping polygons that cause navigation failures
	## Copied from addons/terrain_3d/menu/baker.gd lines 286-336
	##
	## Detects and removes overlapping polygons:
	## - 'overlap' = edge shared by 3+ polygons
	## - 'bad polygon' = polygon with 2+ overlaps
	## Removing bad polygons fixes navigation without creating holes.

	var cell_size: Vector3 = Vector3(p_nav_mesh.cell_size, p_nav_mesh.cell_height, p_nav_mesh.cell_size)

	# Map edges (vertex pairs) to polygons containing that edge
	var edges: Dictionary = {}

	for polygon_index in range(p_polygons.size()):
		var polygon: PackedInt32Array = p_polygons[polygon_index]
		for j in range(polygon.size()):
			var vertex: Vector3 = p_vertices[polygon[j]]
			var next_vertex: Vector3 = p_vertices[polygon[(j + 1) % polygon.size()]]

			# Use cell coords (Vector3i) as key to avoid float errors
			# Sort because shared edges can have vertices in different order
			var edge_key: Array = [Vector3i(vertex / cell_size), Vector3i(next_vertex / cell_size)]
			edge_key.sort()

			if not edges.has(edge_key):
				edges[edge_key] = []
			edges[edge_key].push_back(polygon_index)

	var overlap_count: Dictionary = {}
	for connections in edges.values():
		if connections.size() <= 2:
			continue
		for polygon_index in connections:
			overlap_count[polygon_index] = overlap_count.get(polygon_index, 0) + 1

	var bad_polygons: Array = []
	for polygon_index in overlap_count.keys():
		if overlap_count[polygon_index] >= 2:
			bad_polygons.push_back(polygon_index)

	bad_polygons.sort()
	for i in range(bad_polygons.size() - 1, -1, -1):
		p_polygons.remove_at(bad_polygons[i])
