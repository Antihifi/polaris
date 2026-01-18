extends Node
## Controller for procedural terrain game mode.
## Creates terrain FROM SCRATCH (like Terrain3D demo CodeGenerated.gd).
## Spawns entities AFTER terrain and NavMesh are ready.

## Scenes to instantiate
var _captain_scene: PackedScene = preload("res://src/characters/captain.tscn")
var _camera_scene: PackedScene = preload("res://src/camera/rts_camera.tscn")
var _hud_scene: PackedScene = preload("res://ui/game_hud.tscn")
var _inventory_hud_scene: PackedScene = preload("res://ui/inventory_hud.tscn")
var _ship_scene: PackedScene = preload("res://objects/ship1/ship_1.tscn")
var _sky3d_scene: PackedScene = preload("res://sky_3d.tscn")
var _snow_controller: PackedScene = preload("res://src/systems/weather/snow_controller.tscn")

	
## Load terrain texture configuration (dedicated scene for procedural generation)
## Contains Terrain3DAssets with 4 textures: snow (0), rock (1), gravel (2), ice (3)
var _terrain_config_scene: PackedScene = preload("res://terrain/procedural_terrain_config.tscn")

## Terrain configuration (matches terrain_generator.gd)
const TERRAIN_RESOLUTION: int = 4096
const WORLD_SIZE_METERS: float = 10240.0
const VERTEX_SPACING: float = WORLD_SIZE_METERS / float(TERRAIN_RESOLUTION)
const METERS_PER_PIXEL: float = VERTEX_SPACING

## References
var terrain: Node = null  # Terrain3D (dynamically created)
var runtime_nav_baker: RuntimeNavBaker = null
var captain: Node3D = null
var ship: Node3D = null  # The frozen ship
var rts_camera: Camera3D = null
var _seed_manager = null  # SeedManager instance
var character_spawner: Node

## Generated data
var _heightmap: Image = null
var _island_mask: Image = null
var _pois: Dictionary = {}

## Loading UI
var _loading_label: Label = null
var _loading_detail_label: Label = null  # Shows current step details
var _loading_canvas: CanvasLayer = null
var _progress_bar: ProgressBar = null

## Spawn configuration
@export var spawn_radius: float = 30.0
@export var barrel_count: int = 6
@export var crate_count: int = 6
@export var fire_count: int = 2


var _temp_camera: Camera3D = null  # Temp camera to prevent Terrain3D errors during generation

func _ready() -> void:
	# Create temp camera immediately to prevent Terrain3D "Cannot find active camera" error
	_temp_camera = Camera3D.new()
	_temp_camera.name = "TempCamera"
	_temp_camera.current = true
	add_child(_temp_camera)

	# Create basic lighting first (before terrain generation)
	_create_basic_lighting()

	_create_loading_ui()
	_update_loading("Initializing", "", 0)

	# Initialize seed using global class (defined in seed_manager.gd)
	_seed_manager = SeedManager.new()
	_seed_manager.generate_random_seed()
	print("[ProceduralGame] Starting with seed: %s" % _seed_manager.get_seed_string())

	# Start async generation
	_generate_game.call_deferred()


func _generate_game() -> void:
	var start_time := Time.get_ticks_msec()

	# Stage 1: Generate terrain data
	_update_loading("Generating Island", "Creating landmass shape (4096x4096)", 5)
	await get_tree().process_frame
	_generate_island_mask()
	_update_loading_detail("Adding fjords and coastal features")
	await get_tree().process_frame

	_update_loading("Generating Heightmap", "Creating terrain elevations", 15)
	await get_tree().process_frame
	_generate_heightmap()
	_update_loading_detail("Mountains, valleys, and coastline complete")
	await get_tree().process_frame

	_update_loading("Carving Inlet", "Creating ship harbor", 25)
	await get_tree().process_frame
	var inlet_info := _carve_inlet()

	# Stage 2: Create Terrain3D dynamically (like CodeGenerated.gd)
	_update_loading("Creating Terrain", "Initializing Terrain3D node", 35)
	await get_tree().process_frame
	await _create_terrain()
	_update_loading_detail("Terrain node configured with 4 textures")
	await get_tree().process_frame

	# Stage 3: Import terrain data
	_update_loading("Importing Terrain Data", "Generating control map (textures)", 45)
	await get_tree().process_frame
	await _import_terrain()

	# Stage 4: Setup navigation
	_update_loading("Setting Up Navigation", "Preparing navigation system", 55)
	await get_tree().process_frame
	_setup_navigation()

	# Stage 5: Place POIs
	_update_loading("Placing Points of Interest", "Determining key locations", 60)
	await get_tree().process_frame
	_place_pois(inlet_info.position)

	# Stage 6: Find navigable spawn location and bake NavMesh there
	_update_loading("Finding Spawn Location", "Searching for gentle terrain", 65)
	var ship_pos: Vector3 = _pois.get("ship", Vector3.ZERO)

	# Find a navigable spawn position (inlet center has steep slopes)
	var spawn_pos := _find_navigable_spawn(ship_pos)

	# Get actual terrain height at spawn position
	if terrain and "data" in terrain and terrain.data:
		var actual_height: float = terrain.data.get_height(Vector3(spawn_pos.x, 0, spawn_pos.z))
		if not is_nan(actual_height):
			spawn_pos.y = actual_height
			print("[ProceduralGame] Spawn pos terrain height: %.2f" % actual_height)

	# Bake NavMesh at the spawn location (not ship center)
	# DISCOVERY #2 FIX (2026-01-12): Must enable region BEFORE bake, not after!
	_update_loading("Baking Navigation Mesh", "This may take a minute", 70)
	runtime_nav_baker.enabled = true  # Enable BEFORE bake so region is active when mesh assigned
	runtime_nav_baker.force_bake_at(spawn_pos)
	await runtime_nav_baker.bake_finished
	_update_loading_detail("NavMesh baked successfully")
	await get_tree().process_frame

	# Stage 7: NOW spawn entities (after terrain + NavMesh ready)
	_update_loading("Spawning Entities", "Creating captain and supplies", 90)
	await get_tree().process_frame
	_spawn_entities_at(spawn_pos, ship_pos)

	# Stage 8: Setup camera and UI
	_update_loading("Setting Up UI", "Configuring game interface", 95)
	await get_tree().process_frame
	_setup_game_ui()

	# Done!
	if _progress_bar:
		_progress_bar.value = 100
	var elapsed := (Time.get_ticks_msec() - start_time) / 1000.0
	print("[ProceduralGame] Generation complete in %.1fs" % elapsed)
	print("[ProceduralGame] Seed: %s" % _seed_manager.get_seed_string())

	_hide_loading()


func _create_loading_ui() -> void:
	_loading_canvas = CanvasLayer.new()
	_loading_canvas.layer = 100
	add_child(_loading_canvas)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_loading_canvas.add_child(center)

	var panel := PanelContainer.new()
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	# Title label - shows main step with animated ellipsis
	_loading_label = Label.new()
	_loading_label.text = "Loading..."
	_loading_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_loading_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(_loading_label)

	# Detail label - shows sub-steps and progress info
	_loading_detail_label = Label.new()
	_loading_detail_label.text = ""
	_loading_detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_loading_detail_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1.0))
	vbox.add_child(_loading_detail_label)

	# Progress bar
	_progress_bar = ProgressBar.new()
	_progress_bar.min_value = 0
	_progress_bar.max_value = 100
	_progress_bar.value = 0
	_progress_bar.custom_minimum_size = Vector2(300, 20)
	_progress_bar.show_percentage = false
	vbox.add_child(_progress_bar)


func _update_loading(text: String, detail: String = "", progress: float = -1.0) -> void:
	if _loading_label:
		_loading_label.text = text + "..."

	if _loading_detail_label:
		_loading_detail_label.text = detail

	if _progress_bar and progress >= 0:
		_progress_bar.value = progress

	print("[ProceduralGame] %s" % text + ((" - " + detail) if detail else ""))


func _update_loading_detail(detail: String) -> void:
	## Update just the detail text without changing the main loading text
	if _loading_detail_label:
		_loading_detail_label.text = detail
	print("[ProceduralGame]   %s" % detail)


func _hide_loading() -> void:
	if _loading_canvas:
		_loading_canvas.queue_free()
		_loading_canvas = null

	_loading_label = null
	_loading_detail_label = null
	_progress_bar = null


func _generate_island_mask() -> void:
	var shape_rng: RandomNumberGenerator = _seed_manager.get_shape_rng()
	_island_mask = IslandShape.generate_mask(TERRAIN_RESOLUTION, TERRAIN_RESOLUTION, shape_rng)

	var fjord_rng: RandomNumberGenerator = _seed_manager.get_shape_rng()
	fjord_rng.seed = _seed_manager.current_seed ^ 0x24681357
	IslandShape.add_fjords(_island_mask, fjord_rng, 2)


func _generate_heightmap() -> void:
	var height_rng: RandomNumberGenerator = _seed_manager.get_height_rng()
	_heightmap = HeightmapGenerator.generate_heightmap(
		TERRAIN_RESOLUTION, TERRAIN_RESOLUTION,
		_island_mask, height_rng
	)


func _carve_inlet() -> Dictionary:
	var inlet_rng: RandomNumberGenerator = _seed_manager.get_inlet_rng()
	return HeightmapGenerator.carve_inlet(_heightmap, _island_mask, inlet_rng)


func _create_terrain() -> void:
	## Create Terrain3D dynamically with textures from procedural_terrain_config.tscn
	## Texture slots: 0=snow, 1=rock, 2=gravel, 3=ice (all with detiling enabled)

	# Load terrain config to extract Terrain3DAssets
	var config: Node3D = _terrain_config_scene.instantiate()
	var assets_holder: Node = config.get_node("Terrain3DAssetsHolder")
	var terrain_assets = assets_holder.get_meta("terrain_assets") if assets_holder else null

	# Create new Terrain3D node
	terrain = ClassDB.instantiate("Terrain3D")
	terrain.name = "Terrain3D"

	# Add to scene first (like demo does), then configure
	add_child(terrain, true)
	terrain.owner = get_tree().get_current_scene()

	# Add to terrain group for other systems to find
	terrain.add_to_group("terrain")

	# Configure terrain settings BEFORE import
	terrain.vertex_spacing = VERTEX_SPACING
	terrain.region_size = Terrain3D.SIZE_2048

	# Set the temp camera on terrain to prevent "Cannot find active camera" error
	if terrain.has_method("set_camera") and _temp_camera:
		terrain.set_camera(_temp_camera)

	# Set material properties using demo pattern (terrain auto-creates material)
	if terrain.material:
		terrain.material.world_background = Terrain3DMaterial.NONE
		if "auto_shader" in terrain.material:
			terrain.material.auto_shader = true

		# Configure shader parameters for proper texture blending and detiling
		# These settings match world_map.tscn for consistent appearance
		if terrain.material.has_method("set_shader_param"):
			# Texture blending - lower = smoother transitions between textures
			terrain.material.set_shader_param("blend_sharpness", 0.5)

			# Enable macro variation (detiling) - breaks up texture repetition
			terrain.material.set_shader_param("enable_macro_variation", true)
			terrain.material.set_shader_param("macro_variation1", Color(1, 1, 1, 1))
			terrain.material.set_shader_param("macro_variation2", Color(1, 1, 1, 1))
			terrain.material.set_shader_param("macro_variation_slope", 0.333)

			# Noise scales for macro variation
			terrain.material.set_shader_param("noise1_scale", 0.04)
			terrain.material.set_shader_param("noise2_scale", 0.076)
			terrain.material.set_shader_param("noise1_offset", Vector2(0.5, 0.5))

			# Triplanar projection for steep slopes
			terrain.material.set_shader_param("enable_projection", true)
			terrain.material.set_shader_param("projection_threshold", 0.8)

			# Other quality settings
			terrain.material.set_shader_param("bias_distance", 512.0)
			terrain.material.set_shader_param("mipmap_bias", 1.0)

			print("[ProceduralGame] Configured terrain material shader parameters")

		print("[ProceduralGame] Set terrain material properties")
	else:
		push_warning("[ProceduralGame] Terrain3D material not yet created")

	# Copy assets from config scene for textures (snow, rock, gravel, ice)
	if terrain_assets:
		terrain.assets = terrain_assets.duplicate()
		print("[ProceduralGame] Loaded terrain assets: 4 textures (snow, rock, gravel, ice)")
	else:
		push_warning("[ProceduralGame] Could not load terrain assets from config scene")

	# Free the temporary config instance (we only needed its assets)
	config.queue_free()

	print("[ProceduralGame] Created Terrain3D with vertex_spacing=%.2f" % VERTEX_SPACING)


func _import_terrain() -> void:
	if not terrain or not "data" in terrain:
		push_error("[ProceduralGame] No terrain to import into!")
		return

	# Calculate offset to center terrain at world origin (in pixel coords)
	var half_img: float = float(_heightmap.get_width()) / 2.0
	var offset := Vector3(-half_img, 0, -half_img)

	# Generate control map with proper 32-bit packed format BEFORE import
	var texture_rng: RandomNumberGenerator = _seed_manager.get_texture_rng()
	print("[ProceduralGame] Generating control map (textures)...")
	var control_map: Image = TexturePainter.generate_control_map_for_import(
		_heightmap,
		_island_mask,
		texture_rng
	)

	# Get texture distribution stats
	var stats := TexturePainter.get_texture_stats(_heightmap, _island_mask)
	print("[ProceduralGame] Texture distribution: Snow %.1f%%, Rock %.1f%%, Gravel %.1f%%, Ice %.1f%%" % [
		stats.snow_percent,
		stats.rock_percent,
		stats.gravel_percent,
		stats.ice_percent
	])

	# Import heightmap AND control map together
	var images: Array[Image] = []
	images.resize(3)
	images[0] = _heightmap    # Height map (FORMAT_RF)
	images[1] = control_map   # Control map (FORMAT_RF with bit-packed texture IDs)
	images[2] = null          # Color map - not used

	print("[ProceduralGame] Importing terrain with heightmap + control map...")
	print("[ProceduralGame]   Heightmap: %dx%d format=%d" % [
		_heightmap.get_width(), _heightmap.get_height(), _heightmap.get_format()
	])
	print("[ProceduralGame]   Control map: %dx%d format=%d" % [
		control_map.get_width(), control_map.get_height(), control_map.get_format()
	])

	terrain.data.import_images(images, offset, 0.0, 1.0)

	# Wait for terrain to process
	await get_tree().process_frame
	await get_tree().process_frame

	# Recalculate height range
	terrain.data.calc_height_range(true)

	# Update terrain maps to apply texture changes
	if terrain.data.has_method("update_maps"):
		terrain.data.update_maps()
		print("[ProceduralGame] Terrain maps updated")

	# Verify import
	var test_h: float = terrain.data.get_height(Vector3.ZERO)
	print("[ProceduralGame] Terrain imported. Height at origin: %.2f" % test_h)

	# NOTE: We intentionally DON'T call paint_terrain_post_import() here anymore!
	# The control map already contains per-pixel texture data with smooth blending.
	# Calling set_control_base_id() with step=4 was overriding the blend values and
	# creating blocky "digital camo" patterns. The import_images() approach with
	# bit-packed control map is the correct method for smooth texture transitions.


func _setup_navigation() -> void:
	## Setup RuntimeNavigationBaker (like demo)

	runtime_nav_baker = RuntimeNavBaker.new()
	runtime_nav_baker.name = "RuntimeNavBaker"
	runtime_nav_baker.terrain = terrain
	# Use smaller mesh_size for denser navmesh (demo uses 256x512x256)
	runtime_nav_baker.mesh_size = Vector3(256, 512, 256)
	runtime_nav_baker.min_rebake_distance = 64.0  # Rebake more often for better coverage
	runtime_nav_baker.bake_cooldown = 1.0
	runtime_nav_baker.enabled = false  # Don't auto-bake yet
	add_child(runtime_nav_baker)

	print("[ProceduralGame] RuntimeNavBaker created")


func _place_pois(inlet_position: Vector3) -> void:
	var poi_rng: RandomNumberGenerator = _seed_manager.get_poi_rng()
	_pois = POIPlacer.place_pois(_heightmap, _island_mask, inlet_position, poi_rng)

	print("[ProceduralGame] POIs placed:")
	for key in _pois.keys():
		print("  %s: %s" % [key, _pois[key]])


func _spawn_entities_at(spawn_pos: Vector3, ship_pos: Vector3) -> void:
	## Spawn captain at navigable spawn_pos, ship at ship_pos, containers around ship.
	## spawn_pos is pre-calculated to be on gentle terrain where NavMesh works.
	## ship_pos comes from POI placement (inlet center).

	# Create character spawner
	character_spawner = preload("res://src/systems/character_spawner.gd").new()
	character_spawner.name = "CharacterSpawner"
	character_spawner.spawn_radius = spawn_radius
	add_child(character_spawner)

	# Spawn captain
	captain = _captain_scene.instantiate()
	captain.name = "Captain"
	add_child(captain)

	# spawn_pos already has correct Y from caller
	captain.global_position = spawn_pos
	captain.movement_speed = 5.0

	print("[ProceduralGame] Captain spawned at %s" % captain.global_position)

	# Spawn ship at ship_pos (inlet center where it's "trapped in ice")
	ship = _ship_scene.instantiate()
	ship.name = "Ship1"
	add_child(ship)

	# Get terrain height at ship position
	var ship_height := ship_pos.y
	if terrain and "data" in terrain and terrain.data:
		var terrain_height: float = terrain.data.get_height(Vector3(ship_pos.x, 0, ship_pos.z))
		if not is_nan(terrain_height):
			ship_height = terrain_height

	ship.global_position = Vector3(ship_pos.x, ship_height, ship_pos.z)

	# Verify ship is within 500m of captain (GDD requirement)
	var distance_to_captain := captain.global_position.distance_to(ship.global_position)
	print("[ProceduralGame] Ship spawned at %s (distance to captain: %.1fm)" % [ship.global_position, distance_to_captain])
	if distance_to_captain > 500.0:
		push_warning("[ProceduralGame] Ship is %.1fm from captain - exceeds 500m requirement!" % distance_to_captain)

	# Tell RuntimeNavBaker to track captain for auto-rebaking as they move
	runtime_nav_baker.player = captain

	# Spawn containers around ship (they don't need navigation)
	_spawn_containers(ship_pos)

	# Schedule AI and verification after NavMesh sync (needs physics frames)
	_finalize_captain_setup.call_deferred()


func _finalize_captain_setup() -> void:
	## Wait for NavigationServer to sync, then enable AI and verify setup.
	# NavigationServer needs multiple physics frames to fully sync the NavMesh
	for i in range(10):  # Wait 10 physics frames for full sync
		await get_tree().physics_frame

	if not captain:
		return

	# Ensure captain's NavigationAgent uses the same map as RuntimeNavBaker
	var nav_agent: NavigationAgent3D = captain.get_node_or_null("NavigationAgent3D")
	if nav_agent and runtime_nav_baker:
		# Get the navigation map from RuntimeNavBaker's region (this is where our baked NavMesh lives)
		var baker_map := runtime_nav_baker.get_navigation_map()
		if baker_map.is_valid():
			# NavigationAgent uses World3D's navigation map by default
			# The RuntimeNavBaker's region is already registered with this map
			# Force sync to ensure all edge connections are computed
			NavigationServer3D.map_force_update(baker_map)
			print("[ProceduralGame] Forced NavigationServer map update (map=%s)" % baker_map)
			await get_tree().physics_frame

			# Debug: Check path computation directly
			var start := captain.global_position
			var closest_start := NavigationServer3D.map_get_closest_point(baker_map, start)
			var test_target := start + Vector3(20, 0, 20)  # Test 20m away
			var closest_end := NavigationServer3D.map_get_closest_point(baker_map, test_target)
			var path := NavigationServer3D.map_get_path(baker_map, closest_start, closest_end, true)
			print("[ProceduralGame] Test path from %s to %s: %d points" % [closest_start, closest_end, path.size()])

			# CRITICAL DEBUG: Check height differences
			print("[ProceduralGame] Captain Y=%.2f, closest_start Y=%.2f, delta=%.2f" % [
				start.y, closest_start.y, abs(start.y - closest_start.y)])
			print("[ProceduralGame] Target Y=%.2f, closest_end Y=%.2f, delta=%.2f" % [
				test_target.y, closest_end.y, abs(test_target.y - closest_end.y)])

			# Check edge connection margin
			var edge_margin := NavigationServer3D.map_get_edge_connection_margin(baker_map)
			print("[ProceduralGame] Edge connection margin: %.1f" % edge_margin)

			# DEBUG: Check map active state and cell sizes
			var is_active := NavigationServer3D.map_is_active(baker_map)
			var cell_size := NavigationServer3D.map_get_cell_size(baker_map)
			var cell_height := NavigationServer3D.map_get_cell_height(baker_map)
			print("[ProceduralGame] Map active=%s, cell_size=%.3f, cell_height=%.3f" % [is_active, cell_size, cell_height])

			# DEBUG: Check NavigationAgent's map vs baker's map
			var agent_map := nav_agent.get_navigation_map()
			print("[ProceduralGame] Agent map=%s, Baker map=%s, SAME=%s" % [agent_map, baker_map, agent_map == baker_map])

			# DEBUG: Check regions on the map
			var regions := NavigationServer3D.map_get_regions(baker_map)
			print("[ProceduralGame] Map has %d regions" % regions.size())
			for i in range(regions.size()):
				var region_rid: RID = regions[i]
				var region_enabled: bool = NavigationServer3D.region_get_enabled(region_rid)
				print("[ProceduralGame]   Region %d: RID=%s, enabled=%s" % [i, region_rid, region_enabled])

			# DEBUG: Get random point from NavMesh (returns Vector3, not array)
			# map_get_random_point(map: RID, navigation_layers: int, uniformly: bool) -> Vector3
			var random_pt: Vector3 = NavigationServer3D.map_get_random_point(baker_map, 1, true)
			if random_pt != Vector3.ZERO:
				print("[ProceduralGame] Random NavMesh point: %s" % random_pt)
				# Try pathing to random point to verify connectivity
				var path_to_random := NavigationServer3D.map_get_path(baker_map, closest_start, random_pt, true)
				print("[ProceduralGame] Path to random point: %d points" % path_to_random.size())
			else:
				print("[ProceduralGame] WARNING: map_get_random_point returned ZERO!")

			# Check if we can path from start to a very close point (micro-path test)
			var micro_target := closest_start + Vector3(1, 0, 1)
			var micro_closest := NavigationServer3D.map_get_closest_point(baker_map, micro_target)
			var micro_path := NavigationServer3D.map_get_path(baker_map, closest_start, micro_closest, true)
			print("[ProceduralGame] Micro-path (1m away): %d points, from %s to %s" % [micro_path.size(), closest_start, micro_closest])

			# Check distance between start/end - if they snap to same point, path would be empty
			var start_end_dist := closest_start.distance_to(closest_end)
			print("[ProceduralGame] Distance between closest_start and closest_end: %.2f" % start_end_dist)

	# IMPORTANT: Captain is player-controlled (like main.tscn) - NO AI controller
	# The ManAIController is for NPC survivors only, not the player character

	# Verify position
	_verify_captain_position()


func _verify_captain_position() -> void:
	## Verify captain position after initial physics settle.
	if not captain:
		return
	if true:  # Scope for readability
		print("[ProceduralGame] Captain settled at %s" % captain.global_position)

		# Check navigation map status
		var nav_agent: NavigationAgent3D = captain.get_node_or_null("NavigationAgent3D")
		if nav_agent:
			var nav_map := nav_agent.get_navigation_map()
			if nav_map.is_valid():
				var regions := NavigationServer3D.map_get_regions(nav_map)
				var closest := NavigationServer3D.map_get_closest_point(nav_map, captain.global_position)
				print("[ProceduralGame] NavMap has %d regions, closest point to captain: %s (dist: %.2f)" % [
					regions.size(), closest, captain.global_position.distance_to(closest)])


func _spawn_containers(center: Vector3) -> void:
	## Spawn barrels and crates around ship position
	var object_spawner := preload("res://src/systems/object_spawner.gd").new()
	object_spawner.name = "ObjectSpawner"
	object_spawner.spawn_radius = spawn_radius
	add_child(object_spawner)

	object_spawner.spawn_containers(barrel_count, crate_count, fire_count, center)


func _setup_game_ui() -> void:
	## Setup camera and HUD

	# Create RTS camera
	rts_camera = _camera_scene.instantiate()
	rts_camera.name = "RTScamera"
	add_child(rts_camera)

	# Configure camera for larger procedural terrain
	rts_camera.camera_zoom_max = 100.0  # Allow zooming out further
	rts_camera.max_distance_from_units = 50.0  # Larger movement bounds
	rts_camera.terrain_collision_enabled = true  # Enable terrain collision for proceduwral terrain

	# Tell Terrain3D about the camera (fixes "Cannot find the active camera" error)
	if terrain and terrain.has_method("set_camera"):
		terrain.set_camera(rts_camera)
		print("[ProceduralGame] Set Terrain3D camera")

	# Clean up temp camera now that real camera is active
	if _temp_camera:
		_temp_camera.queue_free()
		_temp_camera = null

	# Focus on captain
	if captain and rts_camera.has_method("focus_on"):
		rts_camera.focus_on(captain, true)

	# Create input handler
	var input_handler := preload("res://src/control/rts_input_handler.gd").new()
	input_handler.name = "RTSInputHandler"
	input_handler.camera = rts_camera
	add_child(input_handler)

	# Create HUD
	var game_hud := _hud_scene.instantiate()
	add_child(game_hud)

	# Create inventory HUD
	var inventory_hud := _inventory_hud_scene.instantiate()
	add_child(inventory_hud)

	# Connect container click to inventory HUD
	if input_handler.has_signal("container_clicked"):
		input_handler.container_clicked.connect(func(container):
			container.open()
			inventory_hud.open_container(container)
		)

	print("[ProceduralGame] UI setup complete")


func _add_ai_controller(unit: Node) -> void:
	## Add ManAIController component to a unit for behavior tree AI.
	if not unit:
		return
	var ai_script: Script = preload("res://ai/man_ai_controller.gd")
	var ai_controller: Node = ai_script.new()
	ai_controller.name = "ManAIController"
	ai_controller.behavior_tree = preload("res://ai/man_bt.tres")
	unit.add_child(ai_controller)


func _create_basic_lighting() -> void:
	## Create Sky3D and SnowController for the procedural scene.
	## Sky3D provides sun/moon lighting, day/night cycle, and atmosphere.
	## SnowController provides weather particle effects.

	var sky3d_node = _sky3d_scene.instantiate()
	add_child(sky3d_node)

	var snow_ctrl = _snow_controller.instantiate()
	add_child(snow_ctrl)

	print("[ProceduralGame] Sky3D and SnowController added to scene")


func _find_navigable_spawn(center: Vector3) -> Vector3:
	## Find a spawn position with gentle slope that NavMesh can cover.
	## The inlet carves steep slopes at center, so we search outward.
	## Returns a position ~50m from center where slope is <30 degrees.

	if not terrain or not "data" in terrain or not terrain.data:
		return center

	# Sample terrain heights to find gentle slope
	# Check points radiating outward from center
	var best_pos := center
	var best_slope := 90.0  # Start with worst case

	# Search in a spiral pattern outward
	for radius in [50.0, 75.0, 100.0, 150.0, 200.0]:
		for angle_deg in range(0, 360, 30):  # Check 12 directions
			var angle_rad := deg_to_rad(float(angle_deg))
			var test_pos := center + Vector3(cos(angle_rad) * radius, 0, sin(angle_rad) * radius)

			# Get height at test position and nearby points to calculate slope
			var h_center: float = terrain.data.get_height(test_pos)
			if is_nan(h_center):
				continue

			# Sample nearby points to calculate slope
			var sample_dist := 5.0  # 5m sample distance
			var h_north: float = terrain.data.get_height(test_pos + Vector3(0, 0, sample_dist))
			var h_south: float = terrain.data.get_height(test_pos + Vector3(0, 0, -sample_dist))
			var h_east: float = terrain.data.get_height(test_pos + Vector3(sample_dist, 0, 0))
			var h_west: float = terrain.data.get_height(test_pos + Vector3(-sample_dist, 0, 0))

			if is_nan(h_north) or is_nan(h_south) or is_nan(h_east) or is_nan(h_west):
				continue

			# Calculate max slope from height differences
			var dh_ns := absf(h_north - h_south) / (2.0 * sample_dist)
			var dh_ew := absf(h_east - h_west) / (2.0 * sample_dist)
			var max_gradient := maxf(dh_ns, dh_ew)
			var slope_deg := rad_to_deg(atan(max_gradient))

			# Accept if slope is under NavMesh limit (35 deg) with some margin
			if slope_deg < 30.0 and slope_deg < best_slope:
				best_slope = slope_deg
				best_pos = test_pos
				print("[ProceduralGame] Found navigable spawn at radius %.0f, angle %d, slope %.1f deg" % [radius, angle_deg, slope_deg])

				# Good enough - return immediately for slopes under 15 degrees
				if slope_deg < 15.0:
					return best_pos

	if best_slope >= 30.0:
		print("[ProceduralGame] WARNING: Could not find gentle slope, using center (slope=%.1f)" % best_slope)

	return best_pos

func _unhandled_input(event: InputEvent) -> void:
	# Debug key bindings
	if event is InputEventKey and event.pressed:
		var key := event as InputEventKey

		# F5: Spawn 10 more survivors
		if key.keycode == KEY_F5:
			var spawn_center := captain.global_position if captain else Vector3.ZERO
			character_spawner.spawn_survivors(10, spawn_center)
			print("[MainController] Spawned 10 more survivors (F5)")

		# F6: Spawn 30 more survivors
		elif key.keycode == KEY_F6:
			var spawn_center := captain.global_position if captain else Vector3.ZERO
			character_spawner.spawn_survivors(30, spawn_center)
			print("[MainController] Spawned 30 more survivors (F6)")

		# F7: Print survivor summary
		elif key.keycode == KEY_F7:
			character_spawner.print_survivor_summary()

		# F8: Despawn all spawned survivors
		elif key.keycode == KEY_F8:
			character_spawner.despawn_all()
			print("[MainController] Despawned all survivors (F8)")
