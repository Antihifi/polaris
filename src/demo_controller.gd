extends Node
## Controller for demo / quickplay game mode.
## Creates a 2x2km procedural island with automated ship destruction.
## Win: get a built sled to open water. Lose: all survivors die.

## Scenes
var _captain_scene: PackedScene = preload("res://src/characters/captain.tscn")
var _camera_scene: PackedScene = preload("res://src/camera/rts_camera.tscn")
var _hud_scene: PackedScene = preload("res://ui/game_hud.tscn")
var _inventory_hud_scene: PackedScene = preload("res://ui/inventory_hud.tscn")
var _sled_panel_scene: PackedScene = preload("res://ui/sled_panel.tscn")
var _workbench_panel_scene: PackedScene = preload("res://ui/workbench_panel.tscn")
var _ship_resource_panel_scene: PackedScene = preload("res://ui/ship_resource_panel.tscn")
var _construction_site_panel_scene: PackedScene = preload("res://ui/construction_site_panel.tscn")
var _tent_panel_scene: PackedScene = preload("res://ui/tent_panel.tscn")
var _butcher_panel_scene: PackedScene = preload("res://ui/butcher_panel.tscn")
var _fragmented_ship_scene: PackedScene = preload("res://objects/erebus4/erebus_physics_ready.tscn")
var _simplified_ship_scene: PackedScene = preload("res://objects/erebus2/errebus_simplified_pre_destruction_meshes_test3.tscn")
var _resource_nodes_scene: PackedScene = preload("res://objects/ship1/resource_nodes.tscn")
var _sky3d_scene: PackedScene = preload("res://sky_3d.tscn")
var _snow_controller: PackedScene = preload("res://src/systems/weather/snow_controller.tscn")
var _scenario_panel_scene: PackedScene = preload("res://ui/scenario_panel.tscn")
var _tutorial_panel_scene: PackedScene = preload("res://ui/tutorial_panel.tscn")
var _terrain_config_scene: PackedScene = preload("res://terrain/procedural_terrain_config.tscn")
var _water_scene: PackedScene = preload("res://terrain/water.tscn")
var _aurora_controller_scene: PackedScene = preload("res://src/effects/aurora_controller.tscn")
var _ui_theme: Theme = preload("res://ui/MinimalUI.tres")


## Demo terrain constants (2x2km island)
const TERRAIN_RESOLUTION: int = 2048
const WORLD_SIZE_METERS: float = 2048.0
const VERTEX_SPACING: float = WORLD_SIZE_METERS / float(TERRAIN_RESOLUTION)
const METERS_PER_PIXEL: float = VERTEX_SPACING

## Ship model placement offset for the fragmented (destructible) ship.
## Matches erebus_physics_test.tscn where ErebusFragmentedV1 is at Y=11.55
## with ground at Y=0. The simplified ship model sits at Y=0 (origin).
const SHIP_MODEL_Y_OFFSET: float = 11.55

## Island shape params (scaled for 2km)
const ICE_BORDER_METERS: float = 80.0
const NORTH_ICE_BORDER_METERS: float = 100.0

## References
var terrain: Node = null
var runtime_nav_baker: RuntimeNavBaker = null
var captain: Node3D = null
var ship: Node3D = null
var rts_camera: Camera3D = null
var sled_panel: Control = null
var workbench_panel: Control = null
var ship_resource_panel: Control = null
var construction_site_panel: Control = null
var tent_panel: Control = null
var tent_placement_manager: TentPlacementManager = null
var butcher_panel: Control = null
var _input_handler: Node = null
var _seed_manager = null
var character_spawner: Node = null
var scenario_panel: ScenarioPanel = null
var tutorial_panel: TutorialPanel = null
var game_hud: CanvasLayer = null
var inventory_hud: CanvasLayer = null
var score_manager: DemoScoreManager = null
var destruction_scheduler: DemoShipDestructionScheduler = null
var _simplified_ship_node: Node3D = null
var _ship_terrain_y: float = 0.0
var _ship_pos_cache: Vector3 = Vector3.ZERO

## Generated data
var _heightmap: Image = null
var _island_mask: Image = null
var _pois: Dictionary = {}


## Loading UI
var _loading_label: Label = null
var _loading_detail_label: Label = null
var _loading_canvas: CanvasLayer = null
var _progress_bar: ProgressBar = null

## Demo spawn configuration (smaller than procedural)
@export var spawn_radius: float = 20.0
@export var barrel_count: int = 4
@export var crate_count: int = 4
@export var fire_count: int = 1

## Smaller crew for demo
@export var officer_count_min: int = 1
@export var officer_count_max: int = 2
@export var men_count_min: int = 8
@export var men_count_max: int = 12

## Additional perpendicular offset (meters) for resource nodes towards port side
@export var resource_node_offset: float = 6.5

## Errant groups (closer for 2km map)
@export var errant_group_count_min: int = 1
@export var errant_group_count_max: int = 2
@export var errant_men_min: int = 2
@export var errant_men_max: int = 4
@export var errant_officer_chance: float = 0.4
@export var errant_max_distance: float = 900.0
@export var errant_min_distance: float = 500.0

## Object spawner reference
var object_spawner: Node = null

var _temp_camera: Camera3D = null
var _errant_unit_refs: Array[Node] = []


func _ready() -> void:
	_temp_camera = Camera3D.new()
	_temp_camera.name = "TempCamera"
	_temp_camera.current = true
	add_child(_temp_camera)

	_create_basic_lighting()
	_create_loading_ui()
	_update_loading("Initializing", "", 0)

	_seed_manager = SeedManager.new()
	_seed_manager.generate_random_seed()
	print("[DemoGame] Starting with seed: %s" % _seed_manager.get_seed_string())

	_generate_game.call_deferred()


func _generate_game() -> void:
	var start_time := Time.get_ticks_msec()

	# Stage 1: Island mask
	_update_loading("Generating Island", "Creating 2km landmass shape", 5)
	await get_tree().process_frame
	_generate_island_mask()
	await get_tree().process_frame

	# Stage 2: Heightmap
	_update_loading("Generating Heightmap", "Creating terrain elevations", 15)
	await get_tree().process_frame
	_generate_heightmap()
	await get_tree().process_frame

	# Stage 3: Carve inlet
	_update_loading("Carving Inlet", "Creating ship approach", 25)
	await get_tree().process_frame
	var inlet_info := _carve_inlet()

	# Stage 3b: Flatten ship area to Y=0 for proper ship placement
	_flatten_ship_area(inlet_info)

	# Stage 3c: Break up ice-water boundary at south map edges
	_break_ice_water_boundary()

	# Stage 4: Create Terrain3D
	_update_loading("Creating Terrain", "Initializing Terrain3D node", 35)
	await get_tree().process_frame
	await _create_terrain()
	await get_tree().process_frame

	# Stage 5: Import terrain data
	_update_loading("Importing Terrain Data", "Generating control map", 45)
	await get_tree().process_frame
	await _import_terrain()

	# Stage 6: Navigation
	_update_loading("Setting Up Navigation", "Preparing navigation system", 55)
	await get_tree().process_frame
	_setup_navigation()

	# Stage 7: POIs
	_update_loading("Placing Points of Interest", "Determining key locations", 60)
	await get_tree().process_frame
	_place_pois(inlet_info.position)

	# Stage 8: Find spawn, spawn ship, bake NavMesh
	_update_loading("Finding Spawn Location", "Searching for gentle terrain", 65)
	var ship_pos: Vector3 = _pois.get("ship", Vector3.ZERO)
	var spawn_pos := _find_navigable_spawn(ship_pos)

	if terrain and "data" in terrain and terrain.data:
		var actual_height: float = terrain.data.get_height(Vector3(spawn_pos.x, 0, spawn_pos.z))
		if not is_nan(actual_height):
			spawn_pos.y = actual_height

	# Spawn ship BEFORE NavMesh bake so its collision is included
	_spawn_fragmented_ship(ship_pos)

	_update_loading("Baking Navigation Mesh", "Baking initial chunk at spawn...", 70)
	runtime_nav_baker.enabled = true
	runtime_nav_baker.force_bake_at(spawn_pos)
	await runtime_nav_baker.bake_finished
	await get_tree().process_frame

	# Stage 9: Spawn entities
	_update_loading("Spawning Entities", "Creating captain and supplies", 85)
	await get_tree().process_frame
	_spawn_entities_at(spawn_pos, ship_pos)

	# Stage 10: Setup open water win area + water mesh
	_update_loading("Setting Up Demo", "Creating win condition area", 90)
	await get_tree().process_frame
	_setup_open_water_area()
	_spawn_water_mesh()

	# Stage 11: Override sled build time for demo pacing
	_override_sled_build_time()

	# Stage 12: Setup UI
	_update_loading("Setting Up UI", "Configuring game interface", 95)
	await get_tree().process_frame
	_setup_game_ui()

	# Done
	if _progress_bar:
		_progress_bar.value = 100
	var elapsed := (Time.get_ticks_msec() - start_time) / 1000.0
	print("[DemoGame] Generation complete in %.1fs" % elapsed)
	print("[DemoGame] Seed: %s" % _seed_manager.get_seed_string())

	_hide_loading()
	_show_scenario_screen()


# === TERRAIN GENERATION ===

func _generate_island_mask() -> void:
	var shape_rng: RandomNumberGenerator = _seed_manager.get_shape_rng()
	_island_mask = IslandShape.generate_mask(
		TERRAIN_RESOLUTION, TERRAIN_RESOLUTION, shape_rng,
		WORLD_SIZE_METERS, ICE_BORDER_METERS, NORTH_ICE_BORDER_METERS
	)
	var fjord_rng: RandomNumberGenerator = _seed_manager.get_shape_rng()
	fjord_rng.seed = _seed_manager.current_seed ^ 0x24681357
	IslandShape.add_fjords(_island_mask, fjord_rng, 1)  # Fewer fjords for 2km


func _generate_heightmap() -> void:
	var height_rng: RandomNumberGenerator = _seed_manager.get_height_rng()
	var config := _create_demo_terrain_config()
	_heightmap = HeightmapGenerator.generate_heightmap(
		TERRAIN_RESOLUTION, TERRAIN_RESOLUTION,
		_island_mask, height_rng, config
	)


func _create_demo_terrain_config() -> TerrainConfig:
	## Create scaled terrain config for 2km demo island.
	var config := TerrainConfig.new()
	config.max_mountain_height = 80.0
	config.max_hill_height = 30.0
	config.base_terrain_amplitude = 10.0
	config.detail_amplitude = 2.0
	config.beach_height = -5.0
	config.beach_start = 0.80

	# Slightly higher frequencies for smaller map (more detail per meter)
	config.base_frequency = 0.006
	config.hill_frequency = 0.005
	config.mountain_frequency = 0.003
	config.detail_frequency = 0.025

	# Smaller peaks for 2km island
	config.peak_1_enabled = true
	config.peak_1_height = 80.0
	config.peak_1_radius = 0.12
	config.peak_2_enabled = true
	config.peak_2_height = 60.0
	config.peak_2_radius = 0.10
	config.peak_3_enabled = false

	# Inlet sized for ship (~60m long, inlet ~50m wide)
	config.inlet_width_pixels = 50
	config.inlet_length_pixels = 200
	config.inlet_blend_radius = 25

	return config


func _carve_inlet() -> Dictionary:
	var inlet_rng: RandomNumberGenerator = _seed_manager.get_inlet_rng()
	return HeightmapGenerator.carve_inlet(
		_heightmap, _island_mask, inlet_rng,
		METERS_PER_PIXEL, 50, 200
	)


func _flatten_ship_area(inlet_info: Dictionary) -> void:
	## Flatten the terrain around the ship position to Y=0 (sea level).
	## Creates a flat ice/frozen sea surface for the ship to sit on.
	## Uses soft edges to blend into surrounding terrain.
	var ship_pixel: Vector2i = inlet_info.pixel_position
	var img_w := _heightmap.get_width()
	var img_h := _heightmap.get_height()

	# Area large enough for the ~60m ship plus margin (at 1m/px)
	var half_length: int = 55  # Along channel
	var half_width: int = 35   # Across channel

	var min_x := maxi(0, ship_pixel.x - half_width)
	var max_x := mini(img_w - 1, ship_pixel.x + half_width)
	var min_y := maxi(0, ship_pixel.y - half_length)
	var max_y := mini(img_h - 1, ship_pixel.y + half_length)

	var pixels_modified: int = 0
	for py in range(min_y, max_y + 1):
		for px in range(min_x, max_x + 1):
			var dist_x := absf(float(px - ship_pixel.x)) / float(half_width)
			var dist_y := absf(float(py - ship_pixel.y)) / float(half_length)
			var dist := maxf(dist_x, dist_y)

			var current: float = _heightmap.get_pixel(px, py).r

			if dist < 0.6:
				# Core area: force to 0.0 (sea level)
				_heightmap.set_pixel(px, py, Color(0.0, 0.0, 0.0, 1.0))
				pixels_modified += 1
			elif dist < 1.0:
				# Blend zone: smooth transition from 0.0 to current height
				var blend := (dist - 0.6) / 0.4
				# Smoothstep for gradual transition
				blend = blend * blend * (3.0 - 2.0 * blend)
				var new_h := lerpf(0.0, current, blend)
				_heightmap.set_pixel(px, py, Color(new_h, 0.0, 0.0, 1.0))
				pixels_modified += 1

	print("[DemoGame] Flattened ship area: %d pixels set to Y=0 around (%d, %d)" % [
		pixels_modified, ship_pixel.x, ship_pixel.y])


func _break_ice_water_boundary() -> void:
	## Create organic ice-floe breakup in the bottom ~5% of the map (full width).
	## Uses noise iso-contours — NO grids, NO rectangular stamps.
	##   • A noise-warped BLEND ZONE transitions existing terrain → frozen sea level
	##   • South of that, noise iso-contours create ice-floe plateaus at Y=-2
	##   • Gaps between floes descend to Y=-15 (below water mesh)
	## The water mesh fills the gaps, producing a natural pack-ice edge.
	var img_w := _heightmap.get_width()
	var img_h := _heightmap.get_height()

	# --- Base zone start (before noise warping) ---
	var base_zone_start: float = float(img_h) * 0.88
	var zone_end_y: int = img_h - 1
	if base_zone_start >= float(zone_end_y):
		return

	# --- Blend zone: smooth transition from terrain to ice floes ---
	var blend_rows: int = int(float(img_h) * 0.05)
	var process_start_y: int = maxi(0, int(base_zone_start) - blend_rows)

	# --- Edge noise: warps the boundary so it isn't ruler-straight ---
	var edge_noise := FastNoiseLite.new()
	edge_noise.seed = _seed_manager.current_seed ^ 0xED6E0001
	edge_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	edge_noise.frequency = 0.008  # broad undulations (~125px features)
	edge_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	edge_noise.fractal_octaves = 2
	edge_noise.fractal_gain = 0.5
	edge_noise.fractal_lacunarity = 2.0

	# --- Floe noise for organic ice shapes ---
	var floe_noise := FastNoiseLite.new()
	floe_noise.seed = _seed_manager.current_seed ^ 0x1CEF100E
	floe_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	floe_noise.frequency = 0.025  # ~40 m features
	floe_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	floe_noise.fractal_octaves = 3
	floe_noise.fractal_gain = 0.5
	floe_noise.fractal_lacunarity = 2.0

	var plateau_h: float = -2.0   # Must match FROZEN_SEA_HEIGHT (-2.0) for seamless join
	var deep_h: float = -15.0     # Ocean floor between floes
	var frozen_sea_h: float = -2.0  # Must match FROZEN_SEA_HEIGHT (-2.0) for seamless join

	var pixels_modified: int = 0

	for py in range(process_start_y, zone_end_y + 1):
		for px in range(0, img_w):
			# Per-column boundary warp (sample at fixed Y for consistent boundary curve)
			var warp_offset: float = edge_noise.get_noise_2d(float(px), base_zone_start) * float(blend_rows) * 0.5
			var warped_start: float = base_zone_start + warp_offset

			# Distance into the floe zone (negative = in blend zone or north of it)
			var dist_into_zone: float = float(py) - warped_start

			if dist_into_zone < -float(blend_rows):
				continue  # North of blend zone — keep existing terrain

			if dist_into_zone < 0.0:
				# BLEND ZONE: smoothly transition existing terrain → frozen sea level
				var blend_t: float = (float(blend_rows) + dist_into_zone) / float(blend_rows)
				blend_t = clampf(blend_t, 0.0, 1.0)
				blend_t = blend_t * blend_t * (3.0 - 2.0 * blend_t)  # smoothstep

				var existing_h: float = _heightmap.get_pixel(px, py).r
				var new_h: float = lerpf(existing_h, frozen_sea_h, blend_t)
				_heightmap.set_pixel(px, py, Color(new_h, 0.0, 0.0, 1.0))
				pixels_modified += 1
			else:
				# FLOE ZONE: ice-floe breakup with descending gaps
				var zone_depth: float = float(zone_end_y) - warped_start
				if zone_depth < 1.0:
					zone_depth = 1.0
				var raw_t: float = clampf(dist_into_zone / zone_depth, 0.0, 1.0)
				var t: float = raw_t * raw_t * (3.0 - 2.0 * raw_t)  # smoothstep

				var base_h: float = lerpf(frozen_sea_h, deep_h, t)
				var threshold: float = lerpf(0.25, 0.75, t)

				var noise_val: float = (floe_noise.get_noise_2d(float(px), float(py)) + 1.0) * 0.5

				var new_h: float
				if noise_val > threshold:
					new_h = plateau_h  # Ice floe surface
				else:
					new_h = base_h     # Descending gap (water fills above)

				_heightmap.set_pixel(px, py, Color(new_h, 0.0, 0.0, 1.0))
				pixels_modified += 1

	print("[DemoGame] Ice-water boundary: %d pixels modified (blend + noise-contour floes, rows %d–%d)" % [
		pixels_modified, process_start_y, zone_end_y])


func _create_terrain() -> void:
	var config: Node3D = _terrain_config_scene.instantiate()
	var assets_holder: Node = config.get_node("Terrain3DAssetsHolder")
	var terrain_assets = assets_holder.get_meta("terrain_assets") if assets_holder else null

	terrain = ClassDB.instantiate("Terrain3D")
	terrain.name = "Terrain3D"
	add_child(terrain, true)
	terrain.owner = get_tree().get_current_scene()
	terrain.add_to_group("terrain")

	terrain.vertex_spacing = VERTEX_SPACING
	terrain.region_size = Terrain3D.SIZE_1024
	terrain.collision_mode = 3  # FULL_GAME

	if terrain.has_method("set_camera") and _temp_camera:
		terrain.set_camera(_temp_camera)

	if terrain.material:
		terrain.material.world_background = Terrain3DMaterial.NONE
		if "auto_shader" in terrain.material:
			terrain.material.auto_shader = true

		if terrain.material.has_method("set_shader_param"):
			terrain.material.set_shader_param("blend_sharpness", 0.5)
			terrain.material.set_shader_param("enable_macro_variation", true)
			terrain.material.set_shader_param("enable_projection", true)
			terrain.material.set_shader_param("projection_threshold", 0.8)
			terrain.material.set_shader_param("bias_distance", 256.0)

	if terrain_assets:
		terrain.assets = terrain_assets.duplicate()
	else:
		push_warning("[DemoGame] Could not load terrain assets from config scene")

	config.queue_free()
	print("[DemoGame] Created Terrain3D with vertex_spacing=%.2f" % VERTEX_SPACING)


func _import_terrain() -> void:
	if not terrain or not "data" in terrain:
		push_error("[DemoGame] No terrain to import into!")
		return

	var half_img: float = float(_heightmap.get_width()) / 2.0
	var offset := Vector3(-half_img, 0, -half_img)

	var texture_rng: RandomNumberGenerator = _seed_manager.get_texture_rng()
	var control_map: Image = TexturePainter.generate_control_map_for_import(
		_heightmap, _island_mask, texture_rng
	)

	var images: Array[Image] = []
	images.resize(3)
	images[0] = _heightmap
	images[1] = control_map
	images[2] = null

	terrain.data.import_images(images, offset, 0.0, 1.0)

	await get_tree().process_frame
	await get_tree().process_frame

	terrain.data.calc_height_range(true)
	if terrain.data.has_method("update_maps"):
		terrain.data.update_maps()

	print("[DemoGame] Terrain imported")


func _setup_navigation() -> void:
	runtime_nav_baker = RuntimeNavBaker.new()
	runtime_nav_baker.name = "RuntimeNavBaker"
	runtime_nav_baker.terrain = terrain
	# Smaller chunks for 2km world
	runtime_nav_baker.chunk_size = Vector3(128, 256, 128)
	runtime_nav_baker.check_interval = 0.5
	runtime_nav_baker.enabled = false
	add_child(runtime_nav_baker)
	print("[DemoGame] RuntimeNavBaker created")


func _place_pois(inlet_position: Vector3) -> void:
	var poi_rng: RandomNumberGenerator = _seed_manager.get_poi_rng()
	_pois = POIPlacer.place_pois(_heightmap, _island_mask, inlet_position, poi_rng)
	print("[DemoGame] POIs placed:")
	for key in _pois.keys():
		print("  %s: %s" % [key, _pois[key]])


# === ENTITY SPAWNING ===

func _spawn_entities_at(spawn_pos: Vector3, ship_pos: Vector3) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	# Create spawners
	character_spawner = preload("res://src/systems/character_spawner.gd").new()
	character_spawner.name = "CharacterSpawner"
	character_spawner.spawn_radius = spawn_radius
	add_child(character_spawner)

	object_spawner = preload("res://src/systems/object_spawner.gd").new()
	object_spawner.name = "ObjectSpawner"
	object_spawner.spawn_radius = spawn_radius
	add_child(object_spawner)

	# Captain
	captain = _captain_scene.instantiate()
	captain.name = "Captain"
	captain.rank = ClickableUnit.UnitRank.CAPTAIN
	add_child(captain)
	captain.global_position = spawn_pos
	captain.movement_speed = 5.0
	print("[DemoGame] Captain spawned at %s" % captain.global_position)

	# Officers
	var officer_count := rng.randi_range(officer_count_min, officer_count_max)
	var officers: Array[Node] = character_spawner.spawn_officers(officer_count, spawn_pos)
	print("[DemoGame] Spawned %d officers" % officers.size())

	# Men
	var men_count := rng.randi_range(men_count_min, men_count_max)
	var men: Array[Node] = character_spawner.spawn_survivors(men_count, spawn_pos)
	print("[DemoGame] Spawned %d men" % men.size())

	# Ship already spawned before NavMesh bake (see _generate_game)

	# Containers near ship
	var container_spawn_center := ship_pos + Vector3(50.0, 0, 0)
	_spawn_containers(container_spawn_center)

	# Workbench near containers
	var workbench_spawn_pos := container_spawn_center + Vector3(0, 0, -10.0)
	object_spawner.spawn_workbench(workbench_spawn_pos)

	# NO sled spawn - player must build one

	# Errant groups
	_spawn_errant_groups(rng, ship_pos)

	# Finalize captain setup
	_finalize_captain_setup.call_deferred()


func _spawn_fragmented_ship(ship_pos: Vector3) -> void:
	## Spawn the SIMPLIFIED (undamaged) ship first. The fragmented (destructible)
	## model is swapped in on the first destruction event via _swap_to_fragmented_ship().
	## Resource nodes are parented to scene root on the PORT side at Y=0.

	_ship_pos_cache = ship_pos

	ship = Node3D.new()
	ship.name = "Ship1"
	add_child(ship)

	# Place ship parent at terrain level (flattened to Y=0 by _flatten_ship_area)
	_ship_terrain_y = 0.0
	if terrain and "data" in terrain and terrain.data:
		var terrain_height: float = terrain.data.get_height(Vector3(ship_pos.x, 0, ship_pos.z))
		if not is_nan(terrain_height):
			_ship_terrain_y = terrain_height

	ship.global_position = Vector3(ship_pos.x, _ship_terrain_y - 3.0, ship_pos.z)

	# Random list (roll) and pitch for realistic frozen-in-ice appearance
	var ship_rng := RandomNumberGenerator.new()
	ship_rng.randomize()
	ship.rotation.z = deg_to_rad(ship_rng.randf_range(-5.0, 5.0))  # Port/starboard list
	ship.rotation.x = deg_to_rad(ship_rng.randf_range(-5.0, 5.0))  # Fore/aft pitch

	# Simplified (non-destructible) ship model - the ONLY model at start
	_simplified_ship_node = _simplified_ship_scene.instantiate()
	_simplified_ship_node.name = "Errebus_Simplified_Pre_Destruction_Meshes"
	_simplified_ship_node.position = Vector3.ZERO
	ship.add_child(_simplified_ship_node)

	# Resource nodes on PORT side (+X), parented to scene root (won't sink with ship)
	var resource_nodes: Node3D = _resource_nodes_scene.instantiate()
	resource_nodes.name = "ResourceNodes"
	resource_nodes.transform = Transform3D.IDENTITY
	resource_nodes.rotation.y = -PI / 2.0
	add_child(resource_nodes)
	# With -PI/2 rotation, baked local Z=-6.5 maps to world +X (port/East).
	# Add extra +X offset to clear the hull.
	resource_nodes.global_position = Vector3(
		ship_pos.x + resource_node_offset, 0.0, ship_pos.z
	)

	# Add DemolitionTestController (needs to exist for scheduler, finds erebus on demand)
	var demolition := Node.new()
	var demo_script: Script = preload("res://tools/demolition_test_controller.gd")
	demolition.set_script(demo_script)
	demolition.name = "DemolitionTestController"
	ship.add_child(demolition)
	demolition.set_process_unhandled_input(false)

	# Add RiggingCleanupManager
	var rigging_mgr := Node.new()
	var rigging_script: Script = preload("res://tools/rigging_cleanup_manager.gd")
	rigging_mgr.set_script(rigging_script)
	rigging_mgr.name = "RiggingCleanupManager"
	rigging_mgr.set("ground_y", _ship_terrain_y - 5.0)
	ship.add_child(rigging_mgr)

	# Add DemoShipDestructionScheduler - connect swap signal
	destruction_scheduler = DemoShipDestructionScheduler.new()
	destruction_scheduler.name = "DemoShipDestructionScheduler"
	ship.add_child(destruction_scheduler)
	destruction_scheduler.demolition_controller = demolition
	destruction_scheduler.ship_swap_requested.connect(_swap_to_fragmented_ship)

	print("[DemoGame] Simplified ship spawned at %s" % ship.global_position)
	print("[DemoGame]   ResourceNodes on port side at Y=0 (offset: %.1fm)" % resource_node_offset)


func _swap_to_fragmented_ship() -> void:
	## Called on the first destruction event. Removes the simplified ship model
	## and instantiates the fragmented (destructible) model in its place.
	if not ship:
		return

	# Remove simplified model
	if is_instance_valid(_simplified_ship_node):
		_simplified_ship_node.queue_free()
		_simplified_ship_node = null

	# Instantiate fragmented model - raised to match physics test
	var erebus: Node3D = _fragmented_ship_scene.instantiate()
	erebus.name = "ErebusFragmentedV1"
	erebus.position = Vector3(0, SHIP_MODEL_Y_OFFSET, 0)
	ship.add_child(erebus)

	# Add ShipResourceComponent (on the erebus node, like ship_1.tscn)
	var resource_comp := ShipResourceComponent.new()
	resource_comp.name = "ShipResourceComponent"
	erebus.add_child(resource_comp)

	# Initialize demolition controller now that ship_root exists
	var demolition := ship.get_node_or_null("DemolitionTestController")
	if demolition:
		demolition.ship_root = erebus
		if not demolition.rigging_manager:
			demolition.rigging_manager = ship.get_node_or_null("RiggingCleanupManager")
		if demolition.auto_fix_collision:
			demolition._fix_collision_layers()
		demolition._store_initial_transforms()
		demolition._cache_hull_deck_fragments()
		demolition._init_state()

	print("[DemoGame] Swapped to fragmented ship (Y offset: %.2f)" % SHIP_MODEL_Y_OFFSET)


func _spawn_containers(center: Vector3) -> void:
	if object_spawner:
		object_spawner.spawn_containers(barrel_count, crate_count, fire_count, center)


func _spawn_errant_groups(rng: RandomNumberGenerator, ship_pos: Vector3) -> void:
	var group_count := rng.randi_range(errant_group_count_min, errant_group_count_max)
	print("[DemoGame] Spawning %d errant groups..." % group_count)

	for i in range(group_count):
		var camp_pos := _find_north_coast_position(rng, i, group_count, ship_pos)
		if camp_pos == Vector3.INF:
			push_warning("[DemoGame] Could not find valid position for errant group %d" % i)
			continue

		var fire: Node3D = object_spawner.spawn_campfire(camp_pos, true)
		var group_barrels := rng.randi_range(1, 2)
		var group_crates := rng.randi_range(1, 2)
		object_spawner.spawn_containers(group_barrels, group_crates, 0, camp_pos)

		var men_in_group := rng.randi_range(errant_men_min, errant_men_max)
		var has_officer := rng.randf() < errant_officer_chance
		var units: Array[Node] = character_spawner.spawn_errant_group(
			camp_pos, men_in_group, has_officer, 20.0
		)

		# Track errant unit references for score manager
		for unit in units:
			_errant_unit_refs.append(unit)

		print("[DemoGame] Errant group %d at %s: %d men, %s officer" % [
			i + 1, camp_pos, men_in_group, "1" if has_officer else "no"])


func _find_north_coast_position(rng: RandomNumberGenerator, group_index: int, total_groups: int, ship_pos: Vector3) -> Vector3:
	if not _island_mask:
		return Vector3.INF

	var img_width := _island_mask.get_width()
	var img_height := _island_mask.get_height()
	var search_y_max := int(img_height * 0.30)
	var search_y_min := int(img_height * 0.05)
	var section_width := img_width / total_groups
	var section_start := group_index * section_width + int(section_width * 0.1)
	var section_end := (group_index + 1) * section_width - int(section_width * 0.1)

	for attempt in range(50):
		var px := rng.randi_range(section_start, section_end)
		var py := rng.randi_range(search_y_min, search_y_max)

		var mask_value: float = _island_mask.get_pixel(px, py).r
		if mask_value < 0.3:
			continue

		var half_size := float(img_width) / 2.0
		var world_x := (float(px) - half_size) * METERS_PER_PIXEL
		var world_z := (float(py) - half_size) * METERS_PER_PIXEL

		var world_y := 0.0
		if terrain and "data" in terrain and terrain.data:
			var height: float = terrain.data.get_height(Vector3(world_x, 0, world_z))
			if not is_nan(height):
				world_y = height

		var world_pos := Vector3(world_x, world_y, world_z)
		var dist_to_ship := world_pos.distance_to(ship_pos)
		if dist_to_ship < errant_min_distance or dist_to_ship > errant_max_distance:
			continue

		return world_pos

	return Vector3.INF


# === DEMO-SPECIFIC SETUP ===

func _setup_open_water_area() -> void:
	## Create an Area3D at the south coast for the win condition.
	## The south coast is determined from the island mask.

	var south_coast_pos := _find_south_coast_position()
	if south_coast_pos == Vector3.INF:
		push_warning("[DemoGame] Could not find south coast - using fallback position")
		var half := WORLD_SIZE_METERS / 2.0
		south_coast_pos = Vector3(0, 0, half - 50.0)

	# Create open water detection area (wide strip along south coast)
	var open_water := Area3D.new()
	open_water.name = "OpenWaterArea"
	add_child(open_water)
	open_water.global_position = south_coast_pos

	var col_shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(WORLD_SIZE_METERS * 0.6, 50.0, 100.0)  # Wide strip
	col_shape.shape = box
	open_water.add_child(col_shape)

	# Setup score manager
	score_manager = DemoScoreManager.new()
	score_manager.name = "DemoScoreManager"
	add_child(score_manager)
	score_manager.setup(open_water)

	# Register errant units after spawning
	if not _errant_unit_refs.is_empty():
		score_manager.register_errant_units(_errant_unit_refs)

	# Connect score signals
	score_manager.demo_won.connect(_on_demo_won)
	score_manager.demo_lost.connect(_on_demo_lost)

	print("[DemoGame] Open water area created at %s" % south_coast_pos)


func _spawn_water_mesh() -> void:
	## Instantiate the water mesh at the south coast to create open ocean visuals.
	## The water plane sits at Y≈-0.5 (wave troughs dip below 0, crests rise above).
	## The terrain at the south coast descends below Y=0, so the water covers it.
	## Reference: world_map.tscn places water at Y=-0.43 with Y-scale 2.253.
	var south_pos := _find_south_coast_position()
	if south_pos == Vector3.INF:
		push_warning("[DemoGame] Could not find south coast for water mesh")
		return

	var water: MeshInstance3D = _water_scene.instantiate()
	water.name = "Water"
	add_child(water)

	# Position: centered on south coast, slightly below Y=0 for wave effect
	# The PlaneMesh is 768x256 units. Scale to cover the demo world width.
	var water_scale_x: float = WORLD_SIZE_METERS / 768.0 * 1.5  # 1.5x coverage for edge overlap
	var water_scale_z: float = 1.5  # Extend ocean depth southward
	var water_y_scale: float = 2.253  # Match world_map.tscn wave height scaling

	water.transform = Transform3D(
		Basis(
			Vector3(water_scale_x, 0, 0),
			Vector3(0, water_y_scale, 0),
			Vector3(0, 0, water_scale_z)
		),
		Vector3(0.0, -2.5, south_pos.z + 50.0)
	)

	print("[DemoGame] Water mesh spawned at Z=%.1f (scale: %.2f x %.2f x %.2f)" % [
		south_pos.z + 50.0, water_scale_x, water_y_scale, water_scale_z])


func _find_south_coast_position() -> Vector3:
	## Find the south coast position from the island mask.
	if not _island_mask:
		return Vector3.INF

	var img_width := _island_mask.get_width()
	var img_height := _island_mask.get_height()
	var center_x := img_width / 2

	# Scan from bottom up to find where land starts
	var coastline_y := img_height - 1
	for y in range(img_height - 1, 0, -1):
		var value: float = _island_mask.get_pixel(center_x, y).r
		if value > 0.3:
			coastline_y = y
			break

	# Place area slightly south of coastline (in the water)
	var area_y := coastline_y + 30
	if area_y >= img_height:
		area_y = img_height - 10

	var half_size := float(img_width) / 2.0
	var world_x := (float(center_x) - half_size) * METERS_PER_PIXEL
	var world_z := (float(area_y) - half_size) * METERS_PER_PIXEL

	var world_y := -2.0  # Below sea level
	return Vector3(world_x, world_y, world_z)


func _override_sled_build_time() -> void:
	## Override sled recipe to 3 days for demo pacing (normally 10 days).
	var sled_recipe: BuildRecipe = BuildRecipes.get_recipe(&"sled")
	if sled_recipe:
		sled_recipe.construction_days = 3
		print("[DemoGame] Sled build time overridden: 3 days (was 10)")
	else:
		push_warning("[DemoGame] Could not find sled recipe to override")


func _on_demo_won(score: Dictionary) -> void:
	print("[DemoGame] === DEMO WON ===")
	print("[DemoGame] Total Score: %d" % score.get("total", 0))
	print("[DemoGame]   Survivors: %d (%d pts)" % [score.get("survivors_alive", 0), score.get("survivor_points", 0)])
	print("[DemoGame]   Good condition: %d (%d pts)" % [score.get("good_condition", 0), score.get("condition_points", 0)])
	print("[DemoGame]   Errant found: %d (%d pts)" % [score.get("errant_found", 0), score.get("errant_points", 0)])
	print("[DemoGame]   Tents: %d (%d pts)" % [score.get("tents_built", 0), score.get("tent_points", 0)])
	print("[DemoGame]   Food: %d (%d pts)" % [score.get("food_items", 0), score.get("food_points", 0)])


func _on_demo_lost(reason: String) -> void:
	print("[DemoGame] === DEMO LOST === %s" % reason)


# === UI SETUP ===

func _setup_game_ui() -> void:
	rts_camera = _camera_scene.instantiate()
	rts_camera.name = "RTScamera"
	add_child(rts_camera)

	# Smaller bounds for 2km map
	rts_camera.camera_zoom_max = 80.0
	rts_camera.max_distance_from_units = 40.0
	rts_camera.terrain_collision_enabled = true

	if terrain and terrain.has_method("set_camera"):
		terrain.set_camera(rts_camera)

	if _temp_camera:
		_temp_camera.queue_free()
		_temp_camera = null

	if captain and rts_camera.has_method("focus_on"):
		rts_camera.focus_on(captain, true)

	# Input handler
	var input_handler := preload("res://src/control/rts_input_handler.gd").new()
	input_handler.name = "RTSInputHandler"
	input_handler.camera = rts_camera
	add_child(input_handler)
	_input_handler = input_handler

	# HUD (hidden until scenario dismissed)
	game_hud = _hud_scene.instantiate()
	add_child(game_hud)
	game_hud.visible = false

	inventory_hud = _inventory_hud_scene.instantiate()
	add_child(inventory_hud)
	inventory_hud.visible = false

	if input_handler.has_signal("container_clicked"):
		input_handler.container_clicked.connect(func(container):
			container.open()
			inventory_hud.open_container(container)
		)

	sled_panel = _sled_panel_scene.instantiate()
	add_child(sled_panel)
	if input_handler.has_signal("sled_clicked"):
		input_handler.sled_clicked.connect(func(sled):
			if sled_panel.has_method("show_for_sled"):
				var selected: Array[Node] = input_handler.get_selected_units()
				if not selected.is_empty():
					sled_panel.show_for_sled(sled, selected, rts_camera)
		)

	workbench_panel = _workbench_panel_scene.instantiate()
	add_child(workbench_panel)
	if input_handler.has_signal("workbench_clicked"):
		input_handler.workbench_clicked.connect(func(workbench):
			if workbench_panel.has_method("show_for_workbench"):
				workbench_panel.show_for_workbench(workbench, rts_camera)
		)

	ship_resource_panel = _ship_resource_panel_scene.instantiate()
	add_child(ship_resource_panel)
	if input_handler.has_signal("ship_clicked"):
		input_handler.ship_clicked.connect(func(clicked_ship):
			if ship_resource_panel.has_method("show_for_ship"):
				ship_resource_panel.show_for_ship(clicked_ship)
		)

	construction_site_panel = _construction_site_panel_scene.instantiate()
	add_child(construction_site_panel)
	if input_handler.has_signal("construction_site_clicked"):
		input_handler.construction_site_clicked.connect(func(site):
			if construction_site_panel.has_method("show_for_site"):
				construction_site_panel.show_for_site(site, rts_camera)
		)

	# Tent interaction panel and placement manager
	tent_panel = _tent_panel_scene.instantiate()
	add_child(tent_panel)
	if input_handler.has_signal("tent_clicked"):
		input_handler.tent_clicked.connect(func(tent):
			if tent_panel.has_method("show_for_tent"):
				tent_panel.show_for_tent(tent, rts_camera)
		)

	tent_placement_manager = TentPlacementManager.new()
	tent_placement_manager.name = "TentPlacementManager"
	add_child(tent_placement_manager)

	# Butcher confirmation panel
	butcher_panel = _butcher_panel_scene.instantiate()
	add_child(butcher_panel)
	if input_handler.has_signal("corpse_clicked"):
		input_handler.corpse_clicked.connect(func(corpse: Node):
			if not corpse or not is_instance_valid(corpse):
				return
			# If already butchered, open corpse inventory directly.
			var corpse_inv: Inventory = corpse.get_node_or_null("CorpseInventory")
			if corpse_inv:
				_open_corpse_inventory(corpse, corpse_inv)
				return
			var selected: Array[Node] = input_handler.get_selected_units()
			var butcher_unit: Node = selected[0] if not selected.is_empty() else null
			var has_axe: bool = butcher_unit and butcher_unit.has_method("has_item_by_id") and butcher_unit.has_item_by_id("hatchet")
			butcher_panel.show_for_corpse(corpse, has_axe, rts_camera)
		)
	butcher_panel.butcher_confirmed.connect(func(corpse: Node3D):
		_on_butcher_confirmed(corpse)
	)

	# Connect inventory item action (e.g. Place Tent from crate, Carve body parts)
	var container_panel: InventoryPanel = inventory_hud.get_node_or_null("%ContainerPanel")
	if container_panel:
		container_panel.item_action_requested.connect(func(item: InventoryItem, action: String):
			if action == "place" and tent_placement_manager:
				inventory_hud.close_container()
				tent_placement_manager.start_tent_placement(item)
			elif action == "carve":
				_handle_carve(item)
		)

	# Also connect unit panel so carving works from unit inventory
	var unit_panel: InventoryPanel = inventory_hud.get_node_or_null("%UnitPanel")
	if unit_panel:
		unit_panel.item_action_requested.connect(func(item: InventoryItem, action: String):
			if action == "place" and tent_placement_manager:
				inventory_hud.close_container()
				tent_placement_manager.start_tent_placement(item)
			elif action == "carve":
				_handle_carve(item)
		)

	# Enable carve button when unit inventory opens (check if unit has knife)
	inventory_hud.unit_inventory_opened.connect(func(unit: ClickableUnit):
		var up: InventoryPanel = inventory_hud.get_node_or_null("%UnitPanel")
		if up and unit:
			var has_knife: bool = unit.has_method("has_item_by_id") and unit.has_item_by_id("knife")
			up.set_carve_enabled(has_knife)
	)

	print("[DemoGame] UI setup complete")


# === LOADING UI ===

func _create_loading_ui() -> void:
	_loading_canvas = CanvasLayer.new()
	_loading_canvas.layer = 100
	add_child(_loading_canvas)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.theme = _ui_theme
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

	_loading_label = Label.new()
	_loading_label.text = "Loading..."
	_loading_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_loading_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(_loading_label)

	_loading_detail_label = Label.new()
	_loading_detail_label.text = ""
	_loading_detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_loading_detail_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1.0))
	vbox.add_child(_loading_detail_label)

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
	print("[DemoGame] %s" % text + ((" - " + detail) if detail else ""))


func _update_loading_detail(detail: String) -> void:
	if _loading_detail_label:
		_loading_detail_label.text = detail


func _hide_loading() -> void:
	if _loading_canvas:
		_loading_canvas.queue_free()
		_loading_canvas = null
	_loading_label = null
	_loading_detail_label = null
	_progress_bar = null


# === SCENARIO SCREEN ===

func _show_scenario_screen() -> void:
	scenario_panel = _scenario_panel_scene.instantiate()
	add_child(scenario_panel)

	tutorial_panel = _tutorial_panel_scene.instantiate()
	add_child(tutorial_panel)

	scenario_panel.game_started.connect(_on_scenario_begin)
	scenario_panel.tutorial_requested.connect(_on_tutorial_requested)
	tutorial_panel.back_requested.connect(_on_tutorial_back)

	scenario_panel.show_scenario()

	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and "paused" in time_manager:
		time_manager.paused = true
	get_tree().paused = true

	var snow_ctrl := _find_snow_controller()
	if snow_ctrl and snow_ctrl.has_method("stop_snow"):
		snow_ctrl.stop_snow()

	print("[DemoGame] Scenario screen displayed (game paused)")


func _on_scenario_begin() -> void:
	if game_hud:
		game_hud.visible = true
	if inventory_hud:
		inventory_hud.visible = true

	get_tree().paused = false
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and "paused" in time_manager:
		time_manager.paused = false

	_start_random_weather()
	print("[DemoGame] Game started!")


func _on_tutorial_requested() -> void:
	scenario_panel.hide_scenario()
	tutorial_panel.show_tutorial()


func _on_tutorial_back() -> void:
	tutorial_panel.hide_tutorial()
	scenario_panel.show_scenario()


# === UTILITY ===

func _create_basic_lighting() -> void:
	var sky3d_node = _sky3d_scene.instantiate()
	add_child(sky3d_node)

	var snow_ctrl = _snow_controller.instantiate()
	add_child(snow_ctrl)

	var dynamic_weather := DynamicWeatherController.new()
	dynamic_weather.name = "DynamicWeatherController"
	add_child(dynamic_weather)

	var aurora_ctrl: Node = _aurora_controller_scene.instantiate()
	add_child(aurora_ctrl)

	var time_manager = get_node_or_null("/root/TimeManager")
	if time_manager and time_manager.has_method("refresh_sky3d"):
		time_manager.refresh_sky3d()

	print("[DemoGame] Sky3D, SnowController, DynamicWeatherController, and AuroraController added")


func _find_navigable_spawn(center: Vector3) -> Vector3:
	if not terrain or not "data" in terrain or not terrain.data:
		return center

	var best_pos := center
	var best_slope := 90.0

	# Start at 80m+ from ship center (~50m from hull edge since ship is ~60m long)
	for radius in [80.0, 100.0, 120.0, 150.0, 200.0]:
		for angle_deg in range(0, 360, 30):
			var angle_rad := deg_to_rad(float(angle_deg))
			var test_pos := center + Vector3(cos(angle_rad) * radius, 0, sin(angle_rad) * radius)

			var h_center: float = terrain.data.get_height(test_pos)
			if is_nan(h_center):
				continue

			var sample_dist := 5.0
			var h_north: float = terrain.data.get_height(test_pos + Vector3(0, 0, sample_dist))
			var h_south: float = terrain.data.get_height(test_pos + Vector3(0, 0, -sample_dist))
			var h_east: float = terrain.data.get_height(test_pos + Vector3(sample_dist, 0, 0))
			var h_west: float = terrain.data.get_height(test_pos + Vector3(-sample_dist, 0, 0))

			if is_nan(h_north) or is_nan(h_south) or is_nan(h_east) or is_nan(h_west):
				continue

			var dh_ns := absf(h_north - h_south) / (2.0 * sample_dist)
			var dh_ew := absf(h_east - h_west) / (2.0 * sample_dist)
			var max_gradient := maxf(dh_ns, dh_ew)
			var slope_deg := rad_to_deg(atan(max_gradient))

			if slope_deg < 30.0 and slope_deg < best_slope:
				best_slope = slope_deg
				best_pos = test_pos
				if slope_deg < 15.0:
					return best_pos

	return best_pos


func _finalize_captain_setup() -> void:
	for i in range(10):
		await get_tree().physics_frame

	if not captain:
		return

	var nav_agent: NavigationAgent3D = captain.get_node_or_null("NavigationAgent3D")
	if nav_agent and runtime_nav_baker:
		var baker_map := runtime_nav_baker.get_navigation_map()
		if baker_map.is_valid():
			NavigationServer3D.map_force_update(baker_map)
			await get_tree().physics_frame

	print("[DemoGame] Captain setup finalized at %s" % captain.global_position)


func _start_random_weather() -> void:
	var dynamic_weather := _find_dynamic_weather_controller()
	if dynamic_weather:
		print("[DemoGame] DynamicWeatherController active")
		return

	var snow_ctrl := _find_snow_controller()
	if not snow_ctrl:
		return

	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var roll := rng.randf()
	if roll < 0.4:
		pass  # Clear
	elif roll < 0.8:
		snow_ctrl.start_snow(1)
	else:
		snow_ctrl.start_snow(2)


func _find_snow_controller() -> Node:
	var nodes := get_tree().get_nodes_in_group("weather")
	if nodes.size() > 0:
		return nodes[0]
	return get_tree().current_scene.find_child("SnowController", true, false)


func _find_dynamic_weather_controller() -> Node:
	var nodes := get_tree().current_scene.find_children("*", "DynamicWeatherController", true, false)
	if nodes.size() > 0:
		return nodes[0]
	return null


# === BUTCHERING ===

const BUTCHER_MULTIPLIER: float = 1.0  ## Stub: will be replaced by unit's butchering skill.

func _on_butcher_confirmed(corpse: Node3D) -> void:
	## Create corpse inventory with body parts after butcher confirmation.
	if not corpse or not is_instance_valid(corpse):
		return
	var protoset: JSON = load("res://data/items_protoset.json")
	var corpse_inv := Inventory.new()
	corpse_inv.name = "CorpseInventory"
	corpse_inv.protoset = protoset
	corpse.add_child(corpse_inv)

	var grid := GridConstraint.new()
	grid.name = "GridConstraint"
	grid.size = Vector2i(8, 6)
	corpse_inv.add_child(grid)

	corpse_inv.create_and_add_item("human_head")
	corpse_inv.create_and_add_item("human_arm")
	corpse_inv.create_and_add_item("human_arm")
	corpse_inv.create_and_add_item("human_leg")
	corpse_inv.create_and_add_item("human_leg")
	corpse_inv.create_and_add_item("human_torso")

	corpse.add_to_group("butchered")
	_open_corpse_inventory(corpse, corpse_inv)

	var corpse_name: String = corpse.unit_name if "unit_name" in corpse else "unit"
	print("[DemoGame] Butchered %s — body parts created" % corpse_name)


func _open_corpse_inventory(corpse: Node, corpse_inv: Inventory) -> void:
	var container_panel: InventoryPanel = inventory_hud.get_node_or_null("%ContainerPanel")
	if not container_panel:
		return
	var corpse_name: String = corpse.unit_name if "unit_name" in corpse else "Corpse"
	container_panel.show_inventory(corpse_inv, "REMAINS OF %s" % corpse_name.to_upper())
	var selected: Array[Node] = _input_handler.get_selected_units() if _input_handler else []
	var butcher_unit: Node = selected[0] if not selected.is_empty() else null
	var has_knife: bool = butcher_unit and butcher_unit.has_method("has_item_by_id") and butcher_unit.has_item_by_id("knife")
	container_panel.set_carve_enabled(has_knife)


func _handle_carve(item: InventoryItem) -> void:
	if not item or not is_instance_valid(item):
		return
	var inv: Inventory = item.get_inventory()
	if not inv:
		return
	var meat_yield: int = int(item.get_property("meat_yield", 1))
	var total_meat: int = int(floorf(meat_yield * BUTCHER_MULTIPLIER))
	inv.remove_item(item)
	for i in range(total_meat):
		inv.create_and_add_item("human_meat")
	print("[DemoGame] Carved body part into %d human meat" % total_meat)
