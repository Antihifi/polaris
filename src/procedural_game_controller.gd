extends Node
## Controller for procedural terrain game mode.
## Creates terrain FROM SCRATCH (like Terrain3D demo CodeGenerated.gd).
## Spawns entities AFTER terrain and NavMesh are ready.

## Scenes to instantiate
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
var _sled_scene: PackedScene = preload("res://objects/sled1/sled_1.tscn")
var _fragmented_ship_scene: PackedScene = preload("res://objects/erebus4/erebus_physics_ready.tscn")
var _simplified_ship_scene: PackedScene = preload("res://objects/erebus2/errebus_simplified_pre_destruction_meshes_test3.tscn")
var _resource_nodes_scene: PackedScene = preload("res://objects/ship1/resource_nodes.tscn")
var _sky3d_scene: PackedScene = preload("res://sky_3d.tscn")
var _snow_controller: PackedScene = preload("res://src/systems/weather/snow_controller.tscn")
var _scenario_panel_scene: PackedScene = preload("res://ui/scenario_panel.tscn")
var _tutorial_panel_scene: PackedScene = preload("res://ui/tutorial_panel.tscn")
var _water_scene: PackedScene = preload("res://terrain/water.tscn")
var _aurora_controller_scene: PackedScene = preload("res://src/effects/aurora_controller.tscn")


## Load terrain texture configuration (dedicated scene for procedural generation)
## Contains Terrain3DAssets with 4 textures: snow (0), rock (1), gravel (2), ice (3)
var _terrain_config_scene: PackedScene = preload("res://terrain/procedural_terrain_config.tscn")
## Terrain generation parameters (erosion, heights, etc.) - edited via TerrainParamsDock
var _terrain_config: TerrainConfig = preload("res://terrain/terrain_params.tres")
var _ui_theme: Theme = preload("res://ui/MinimalUI.tres")

## Terrain configuration (matches terrain_generator.gd)
const TERRAIN_RESOLUTION: int = 4096
const WORLD_SIZE_METERS: float = 10240.0
const VERTEX_SPACING: float = WORLD_SIZE_METERS / float(TERRAIN_RESOLUTION)
const METERS_PER_PIXEL: float = VERTEX_SPACING

## Ship model placement offset for the fragmented (destructible) ship.
const SHIP_MODEL_Y_OFFSET: float = 11.55

## References
var terrain: Node = null  # Terrain3D (dynamically created)
var runtime_nav_baker: RuntimeNavBaker = null
var captain: Node3D = null
var ship: Node3D = null  # The frozen ship
var destruction_scheduler: DemoShipDestructionScheduler = null
var _simplified_ship_node: Node3D = null
var _ship_terrain_y: float = 0.0
var _ship_pos_cache: Vector3 = Vector3.ZERO
var rts_camera: Camera3D = null
var sled_panel: Control = null  # Sled interaction UI
var workbench_panel: Control = null  # Workbench crafting UI
var ship_resource_panel: Control = null  # Ship resource display UI
var construction_site_panel: Control = null  # Construction site UI
var tent_panel: Control = null  # Tent interaction UI
var tent_placement_manager: TentPlacementManager = null
var butcher_panel: Control = null  # Butcher confirmation UI
var _input_handler: Node = null
var _seed_manager = null  # SeedManager instance
var character_spawner: Node
var scenario_panel: ScenarioPanel = null  # Intro screen
var tutorial_panel: TutorialPanel = null  # Tutorial screen
var game_hud: CanvasLayer = null  # Main game HUD
var inventory_hud: CanvasLayer = null  # Inventory HUD
var score_manager: DemoScoreManager = null  # Win/lose tracking
var _errant_unit_refs: Array[Node] = []  # Errant units for score manager

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

## Ship complement configuration (GDD values)
@export var officer_count_min: int = 2
@export var officer_count_max: int = 4
@export var men_count_min: int = 15
@export var men_count_max: int = 20

## Errant group configuration (GDD values)
@export var errant_group_count_min: int = 2
@export var errant_group_count_max: int = 3
@export var errant_men_min: int = 3
@export var errant_men_max: int = 5
@export var errant_officer_chance: float = 0.4  # 40% chance per group
@export var errant_max_distance: float = 1000.0  # Max distance from ship for errant camps
@export var errant_min_distance: float = 200.0  # Min distance from ship for errant camps

## Additional perpendicular offset (meters) for resource nodes towards port side
@export var resource_node_offset: float = 6.5

## Object spawner reference
var object_spawner: Node = null


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

	_update_loading("Carving Inlet", "Creating deadly ice traps", 25)
	await get_tree().process_frame
	var inlet_info := _carve_inlet()

	# Flatten ship area to Y=0 for proper ship placement
	_update_loading_detail("Flattening ship placement area")
	_flatten_ship_area(inlet_info)

	# Break up ice-water boundary at south map edges
	_update_loading_detail("Creating ice-floe breakup at south coast")
	_break_ice_water_boundary()
	await get_tree().process_frame

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

	# Spawn ship BEFORE NavMesh bake so its collision is included
	_spawn_fragmented_ship(ship_pos)

	# Bake initial NavMesh chunk at spawn location
	# Chunk system will automatically bake more chunks as units move around
	_update_loading("Baking Navigation Mesh", "Baking initial chunk at spawn...", 70)
	runtime_nav_baker.enabled = true
	runtime_nav_baker.force_bake_at(spawn_pos)
	await runtime_nav_baker.bake_finished
	_update_loading_detail("Initial NavMesh chunk ready - more will bake as needed")
	await get_tree().process_frame

	# Stage 7: NOW spawn entities (after terrain + NavMesh ready)
	_update_loading("Spawning Entities", "Creating captain and supplies", 85)
	await get_tree().process_frame
	_spawn_entities_at(spawn_pos, ship_pos)

	# Stage 8: Setup south coast open water and win condition
	_update_loading("Setting Up South Coast", "Creating open water and ice boundary", 90)
	await get_tree().process_frame
	_setup_open_water_area()
	_spawn_water_mesh()

	# Stage 9: Setup camera and UI
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

	# Show scenario intro screen (game waits for player to click "Let's Begin")
	_show_scenario_screen()


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
		_island_mask, height_rng, _terrain_config
	)

	# Post-processing: smooth steep slopes FIRST (creates nav-passable gaps)
	HeightmapGenerator.smooth_steep_slopes(_heightmap, _island_mask, METERS_PER_PIXEL, 35.0, 80)

	# Apply hydraulic erosion AFTER smoothing using GPU compute shader
	GPUErosion.apply_hydraulic_erosion_gpu(_heightmap, _island_mask, _terrain_config, METERS_PER_PIXEL)

	# Eliminate sugarloaf peaks on north coast (aggressive smoothing)
	HeightmapGenerator.smooth_by_latitude(_heightmap, _island_mask, 0.0, 0.35, 3)

	# Smooth southern flatlands for easier navigation
	HeightmapGenerator.smooth_by_latitude(_heightmap, _island_mask, 0.65, 1.0, 2)


func _carve_inlet() -> Dictionary:
	var inlet_rng: RandomNumberGenerator = _seed_manager.get_inlet_rng()
	return HeightmapGenerator.carve_inlet(_heightmap, _island_mask, inlet_rng)


func _flatten_ship_area(inlet_info: Dictionary) -> void:
	## Flatten the terrain around the ship position to Y=0 (sea level).
	## Creates a flat ice/frozen sea surface for the ship to sit on.
	## Uses soft edges to blend into surrounding terrain.
	## Ship dimensions are in meters, converted to pixels via METERS_PER_PIXEL.
	var ship_pixel: Vector2i = inlet_info.pixel_position
	var img_w := _heightmap.get_width()
	var img_h := _heightmap.get_height()

	# Ship is ~60m long — use 55m half-length + 35m half-width in meters,
	# then convert to pixel counts for this resolution.
	var half_length: int = int(55.0 / METERS_PER_PIXEL)  # Along channel
	var half_width: int = int(35.0 / METERS_PER_PIXEL)   # Across channel

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

	print("[ProceduralGame] Flattened ship area: %d pixels set to Y=0 around (%d, %d)" % [
		pixels_modified, ship_pixel.x, ship_pixel.y])


func _break_ice_water_boundary() -> void:
	## Create organic ice-floe breakup in the bottom ~5% of the map (full width).
	## Uses noise iso-contours — NO grids, NO rectangular stamps.
	##   - A noise-warped BLEND ZONE transitions existing terrain -> frozen sea level
	##   - South of that, noise iso-contours create ice-floe plateaus at Y=-2
	##   - Gaps between floes descend to Y=-15 (below water mesh)
	## The water mesh fills the gaps, producing a natural pack-ice edge.
	## Noise frequencies are scaled by METERS_PER_PIXEL to maintain consistent
	## world-space feature sizes across different terrain resolutions.
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
	# Scale frequency by METERS_PER_PIXEL to keep ~125m world-space undulations
	var edge_noise := FastNoiseLite.new()
	edge_noise.seed = _seed_manager.current_seed ^ 0xED6E0001
	edge_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	edge_noise.frequency = 0.008 * METERS_PER_PIXEL
	edge_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	edge_noise.fractal_octaves = 2
	edge_noise.fractal_gain = 0.5
	edge_noise.fractal_lacunarity = 2.0

	# --- Floe noise for organic ice shapes ---
	# Scale frequency by METERS_PER_PIXEL to keep ~40m world-space features
	var floe_noise := FastNoiseLite.new()
	floe_noise.seed = _seed_manager.current_seed ^ 0x1CEF100E
	floe_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	floe_noise.frequency = 0.025 * METERS_PER_PIXEL
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
				# BLEND ZONE: smoothly transition existing terrain -> frozen sea level
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

	print("[ProceduralGame] Ice-water boundary: %d pixels modified (blend + noise-contour floes, rows %d-%d)" % [
		pixels_modified, process_start_y, zone_end_y])


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
	terrain.collision_mode = 3  # FULL_GAME - generates all collision at load, prevents fall-through

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
	## Setup RuntimeNavBaker - chunk-based system that bakes around ALL units

	runtime_nav_baker = RuntimeNavBaker.new()
	runtime_nav_baker.name = "RuntimeNavBaker"
	runtime_nav_baker.terrain = terrain
	# Chunk size: 256x512x256 (256m wide, 512m tall, 256m deep)
	runtime_nav_baker.chunk_size = Vector3(256, 512, 256)
	runtime_nav_baker.check_interval = 0.5  # Check for new chunks every 0.5s
	runtime_nav_baker.enabled = false  # Don't auto-bake yet
	add_child(runtime_nav_baker)

	print("[ProceduralGame] RuntimeNavBaker created (chunk-based, all units tracked)")


func _place_pois(inlet_position: Vector3) -> void:
	var poi_rng: RandomNumberGenerator = _seed_manager.get_poi_rng()
	_pois = POIPlacer.place_pois(_heightmap, _island_mask, inlet_position, poi_rng)

	print("[ProceduralGame] POIs placed:")
	for key in _pois.keys():
		print("  %s: %s" % [key, _pois[key]])


func _spawn_entities_at(spawn_pos: Vector3, ship_pos: Vector3) -> void:
	## Spawn full ship complement and errant groups as per GDD.
	## spawn_pos is pre-calculated to be on gentle terrain where NavMesh works.
	## ship_pos comes from POI placement (inlet center).

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

	# === SHIP COMPLEMENT (GDD: 1 captain, 2-4 officers, 15-20 men) ===

	# Spawn captain
	captain = _captain_scene.instantiate()
	captain.name = "Captain"
	captain.rank = ClickableUnit.UnitRank.CAPTAIN
	add_child(captain)
	captain.global_position = spawn_pos
	captain.movement_speed = 5.0
	print("[ProceduralGame] Captain spawned at %s" % captain.global_position)

	# Spawn officers (player-controlled)
	var officer_count := rng.randi_range(officer_count_min, officer_count_max)
	var officers: Array[Node] = character_spawner.spawn_officers(officer_count, spawn_pos)
	print("[ProceduralGame] Spawned %d officers near captain" % officers.size())

	# Spawn men (AI-controlled)
	var men_count := rng.randi_range(men_count_min, men_count_max)
	var men: Array[Node] = character_spawner.spawn_survivors(men_count, spawn_pos)
	print("[ProceduralGame] Spawned %d men near captain" % men.size())

	# Ship already spawned before NavMesh bake (see _generate_game)

	# Spawn containers 50m EAST of ship (positive X)
	var container_spawn_center := ship_pos + Vector3(50.0, 0, 0)
	_spawn_containers(container_spawn_center)

	# Spawn workbench 10m NORTH of containers (negative Z)
	var workbench_spawn_pos := container_spawn_center + Vector3(0, 0, -10.0)
	object_spawner.spawn_workbench(workbench_spawn_pos)

	# Spawn sled 10m SOUTH of captain (positive Z)
	var sled_spawn_pos := spawn_pos + Vector3(0, 0, 10.0)
	var sled: RigidBody3D = _sled_scene.instantiate()
	sled.name = "Sled1"
	add_child(sled)
	# Get terrain height at sled position, spawn slightly above to avoid clipping
	var sled_height := sled_spawn_pos.y
	if terrain and "data" in terrain and terrain.data:
		var sled_terrain_height: float = terrain.data.get_height(Vector3(sled_spawn_pos.x, 0, sled_spawn_pos.z))
		if not is_nan(sled_terrain_height):
			sled_height = sled_terrain_height + 0.5  # Spawn 0.5m above terrain
	sled.global_position = Vector3(sled_spawn_pos.x, sled_height, sled_spawn_pos.z)
	# Freeze sled temporarily to let terrain collision initialize
	sled.freeze = true
	print("[ProceduralGame] Spawned sled at %s (frozen, 10m S of captain)" % sled.global_position)
	# Unfreeze after 1 second
	get_tree().create_timer(1.0).timeout.connect(func():
		if is_instance_valid(sled):
			sled.freeze = false
			print("[ProceduralGame] Sled unfrozen")
	)

	# === ERRANT GROUPS (GDD: 2-3 groups along north coast) ===
	_spawn_errant_groups(rng, ship_pos)

	# === POLAR BEARS (25 on north coast - reduced for performance) ===
	character_spawner.spawn_polar_bears(25, _island_mask, WORLD_SIZE_METERS, false)

	# Schedule final setup after NavMesh sync
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
	## Spawn barrels and crates around ship position.
	## Uses the object_spawner created in _spawn_entities_at.
	if object_spawner:
		object_spawner.spawn_containers(barrel_count, crate_count, fire_count, center)


func _spawn_fragmented_ship(ship_pos: Vector3) -> void:
	## Spawn the SIMPLIFIED (undamaged) ship first. The fragmented (destructible)
	## model is swapped in on the first destruction event via _swap_to_fragmented_ship().
	## Resource nodes are parented to scene root on the PORT side at Y=0.

	_ship_pos_cache = ship_pos

	ship = Node3D.new()
	ship.name = "Ship1"
	add_child(ship)

	# Place ship parent at terrain level
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

	# Add ShipResourceComponent early so units can gather before ship swap.
	var resource_comp := ShipResourceComponent.new()
	resource_comp.name = "ShipResourceComponent"
	ship.add_child(resource_comp)

	# Resource nodes on PORT side (+X), parented to scene root (won't sink with ship)
	var resource_nodes: Node3D = _resource_nodes_scene.instantiate()
	resource_nodes.name = "ResourceNodes"
	resource_nodes.transform = Transform3D.IDENTITY
	resource_nodes.rotation.y = -PI / 2.0
	add_child(resource_nodes)
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

	var distance_to_captain := captain.global_position.distance_to(ship.global_position) if captain else 0.0
	print("[ProceduralGame] Simplified ship spawned at %s (distance to captain: %.1fm)" % [ship.global_position, distance_to_captain])
	print("[ProceduralGame]   ResourceNodes on port side at Y=0 (offset: %.1fm)" % resource_node_offset)


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

	print("[ProceduralGame] Swapped to fragmented ship (Y offset: %.2f)" % SHIP_MODEL_Y_OFFSET)


func _spawn_errant_groups(rng: RandomNumberGenerator, ship_pos: Vector3) -> void:
	## Spawn errant groups along the north coast.
	## GDD: 2-3 groups, 3-5 men each, 0-1 officer, with supplies and dim fire.

	var group_count := rng.randi_range(errant_group_count_min, errant_group_count_max)
	print("[ProceduralGame] Spawning %d errant groups along north coast..." % group_count)

	for i in range(group_count):
		# Find position on north coast (on island, not frozen sea)
		var camp_pos := _find_north_coast_position(rng, i, group_count, ship_pos)
		if camp_pos == Vector3.INF:
			push_warning("[ProceduralGame] Could not find valid position for errant group %d" % i)
			continue

		# Spawn dim campfire at camp center
		var fire: Node3D = object_spawner.spawn_campfire(camp_pos, true)  # dim=true

		# Spawn supplies around fire
		var group_barrels := rng.randi_range(1, 3)
		var group_crates := rng.randi_range(1, 3)
		object_spawner.spawn_containers(group_barrels, group_crates, 0, camp_pos)

		# Spawn units (undiscovered, leashed to camp)
		var men_in_group := rng.randi_range(errant_men_min, errant_men_max)
		var has_officer := rng.randf() < errant_officer_chance
		var units: Array[Node] = character_spawner.spawn_errant_group(camp_pos, men_in_group, has_officer, 20.0)

		# Track errant unit references for score manager
		for unit in units:
			_errant_unit_refs.append(unit)

		print("[ProceduralGame] Errant group %d at %s: %d men, %s officer, %d barrels, %d crates" % [
			i + 1, camp_pos, men_in_group, "1" if has_officer else "no", group_barrels, group_crates])


func _find_north_coast_position(rng: RandomNumberGenerator, group_index: int, total_groups: int, ship_pos: Vector3) -> Vector3:
	## Find a valid position on the north coast for an errant group.
	## Uses island_mask to ensure position is on solid land (mask >= 0.3).
	## Spreads groups across east-west to avoid clustering.

	if not _island_mask:
		push_error("[ProceduralGame] No island mask available for errant group placement")
		return Vector3.INF

	var img_width := _island_mask.get_width()
	var img_height := _island_mask.get_height()

	# Search in north region (top 30% of image)
	var search_y_max := int(img_height * 0.30)
	var search_y_min := int(img_height * 0.05)  # Avoid very edge

	# Divide east-west into sections for each group
	var section_width := img_width / total_groups
	var section_start := group_index * section_width + int(section_width * 0.1)
	var section_end := (group_index + 1) * section_width - int(section_width * 0.1)

	# Try to find valid position
	var max_attempts := 50
	for attempt in range(max_attempts):
		var px := rng.randi_range(section_start, section_end)
		var py := rng.randi_range(search_y_min, search_y_max)

		# Check island mask - must be solid land (>= 0.3)
		var mask_value: float = _island_mask.get_pixel(px, py).r
		if mask_value < 0.3:
			continue

		# Convert pixel to world position
		var half_size := float(img_width) / 2.0
		var world_x := (float(px) - half_size) * METERS_PER_PIXEL
		var world_z := (float(py) - half_size) * METERS_PER_PIXEL

		# Get terrain height
		var world_y := 0.0
		if terrain and "data" in terrain and terrain.data:
			var height: float = terrain.data.get_height(Vector3(world_x, 0, world_z))
			if not is_nan(height):
				world_y = height

		var world_pos := Vector3(world_x, world_y, world_z)

		# Ensure distance from ship within configured range
		var dist_to_ship := world_pos.distance_to(ship_pos)
		if dist_to_ship < errant_min_distance or dist_to_ship > errant_max_distance:
			continue

		return world_pos

	return Vector3.INF


# === SOUTH COAST SETUP ===

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


func _setup_open_water_area() -> void:
	## Create an Area3D at the south coast for the win condition.
	## The south coast is determined from the island mask.

	var south_coast_pos := _find_south_coast_position()
	if south_coast_pos == Vector3.INF:
		push_warning("[ProceduralGame] Could not find south coast - using fallback position")
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

	print("[ProceduralGame] Open water area created at %s" % south_coast_pos)


func _spawn_water_mesh() -> void:
	## Instantiate the water mesh at the south coast to create open ocean visuals.
	## The water plane sits at Y~-2.5 (wave troughs dip below 0, crests rise above).
	## The terrain at the south coast descends below Y=0, so the water covers it.
	## Reference: world_map.tscn places water at Y=-0.43 with Y-scale 2.253.
	var south_pos := _find_south_coast_position()
	if south_pos == Vector3.INF:
		push_warning("[ProceduralGame] Could not find south coast for water mesh")
		return

	var water: MeshInstance3D = _water_scene.instantiate()
	water.name = "Water"
	add_child(water)

	# PlaneMesh is 768x256 units. Scale to cover full ice floe zone.
	var water_scale_x: float = WORLD_SIZE_METERS / 768.0 * 1.5  # 1.5x coverage for edge overlap
	# Scale Z to cover ~20% of map depth (ice floe zone is ~12%)
	var water_scale_z: float = WORLD_SIZE_METERS / 256.0 * 0.2
	var water_y_scale: float = 2.253  # Match world_map.tscn wave height scaling

	# Position: Shift mesh north to cover ice floe transition zone
	# south_pos.z is at the coastline - move 200m north to cover the pockmarked terrain
	var water_z: float = south_pos.z - 200.0

	water.transform = Transform3D(
		Basis(
			Vector3(water_scale_x, 0, 0),
			Vector3(0, water_y_scale, 0),
			Vector3(0, 0, water_scale_z)
		),
		Vector3(0.0, -2.5, water_z)
	)

	print("[ProceduralGame] Water mesh spawned at Z=%.1f (scale: %.2f x %.2f x %.2f)" % [
		water_z, water_scale_x, water_y_scale, water_scale_z])


func _on_demo_won(score: Dictionary) -> void:
	print("[ProceduralGame] === GAME WON ===")
	print("[ProceduralGame] Total Score: %d" % score.get("total", 0))
	print("[ProceduralGame]   Survivors: %d (%d pts)" % [score.get("survivors_alive", 0), score.get("survivor_points", 0)])
	print("[ProceduralGame]   Good condition: %d (%d pts)" % [score.get("good_condition", 0), score.get("condition_points", 0)])
	print("[ProceduralGame]   Errant found: %d (%d pts)" % [score.get("errant_found", 0), score.get("errant_points", 0)])
	print("[ProceduralGame]   Tents: %d (%d pts)" % [score.get("tents_built", 0), score.get("tent_points", 0)])
	print("[ProceduralGame]   Food: %d (%d pts)" % [score.get("food_items", 0), score.get("food_points", 0)])


func _on_demo_lost(reason: String) -> void:
	print("[ProceduralGame] === GAME LOST === %s" % reason)


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
	_input_handler = input_handler

	# Create HUD (starts hidden until scenario dismissed)
	game_hud = _hud_scene.instantiate()
	add_child(game_hud)
	game_hud.visible = false

	# Create inventory HUD (starts hidden until scenario dismissed)
	inventory_hud = _inventory_hud_scene.instantiate()
	add_child(inventory_hud)
	inventory_hud.visible = false

	# Connect container click to inventory HUD
	if input_handler.has_signal("container_clicked"):
		input_handler.container_clicked.connect(func(container):
			container.open()
			inventory_hud.open_container(container)
		)

	# Create sled interaction panel
	sled_panel = _sled_panel_scene.instantiate()
	add_child(sled_panel)

	# Connect sled click to sled panel
	if input_handler.has_signal("sled_clicked"):
		input_handler.sled_clicked.connect(func(sled):
			if sled_panel.has_method("show_for_sled"):
				var selected: Array[Node] = input_handler.get_selected_units()
				if not selected.is_empty():
					sled_panel.show_for_sled(sled, selected, rts_camera)
		)

	# Create workbench interaction panel
	workbench_panel = _workbench_panel_scene.instantiate()
	add_child(workbench_panel)

	# Connect workbench click to workbench panel
	if input_handler.has_signal("workbench_clicked"):
		input_handler.workbench_clicked.connect(func(workbench):
			if workbench_panel.has_method("show_for_workbench"):
				workbench_panel.show_for_workbench(workbench, rts_camera)
		)

	# Create ship resource panel
	ship_resource_panel = _ship_resource_panel_scene.instantiate()
	add_child(ship_resource_panel)

	# Connect ship click to ship resource panel
	if input_handler.has_signal("ship_clicked"):
		input_handler.ship_clicked.connect(func(clicked_ship):
			if ship_resource_panel.has_method("show_for_ship"):
				ship_resource_panel.show_for_ship(clicked_ship)
		)

	# Create construction site panel
	construction_site_panel = _construction_site_panel_scene.instantiate()
	add_child(construction_site_panel)

	# Connect construction site click to construction site panel
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
	var container_panel: InventoryPanel = inventory_hud.get_container_panel()
	if container_panel:
		container_panel.item_action_requested.connect(func(item: InventoryItem, action: String):
			if action == "place" and tent_placement_manager:
				inventory_hud.close_container()
				tent_placement_manager.start_tent_placement(item)
			elif action == "carve":
				_handle_carve(item)
		)

	# Also connect unit panel so carving works from unit inventory
	var unit_panel: InventoryPanel = null  # Dynamic unit panels handle this now
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
		var up: InventoryPanel = null  # Dynamic unit panels handle this now
		if up and unit:
			var has_knife: bool = unit.has_method("has_item_by_id") and unit.has_item_by_id("knife")
			up.set_carve_enabled(has_knife)
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
	## Create Sky3D, SnowController, and DynamicWeatherController for the procedural scene.
	## Sky3D provides sun/moon lighting, day/night cycle, and atmosphere.
	## SnowController provides weather particle effects.
	## DynamicWeatherController manages procedural weather events.

	var sky3d_node = _sky3d_scene.instantiate()
	add_child(sky3d_node)

	var snow_ctrl = _snow_controller.instantiate()
	add_child(snow_ctrl)

	# Add DynamicWeatherController for procedural weather events
	var dynamic_weather := DynamicWeatherController.new()
	dynamic_weather.name = "DynamicWeatherController"
	add_child(dynamic_weather)

	# Add AuroraController for northern lights effect
	var aurora_ctrl: Node = _aurora_controller_scene.instantiate()
	add_child(aurora_ctrl)

	# Notify TimeManager to find the newly added Sky3D
	# (TimeManager's initial search runs before we create Sky3D)
	var time_manager = get_node_or_null("/root/TimeManager")
	if time_manager and time_manager.has_method("refresh_sky3d"):
		time_manager.refresh_sky3d()
		print("[ProceduralGame] TimeManager refreshed to find Sky3D")

	print("[ProceduralGame] Sky3D, SnowController, DynamicWeatherController, and AuroraController added to scene")


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


func _show_scenario_screen() -> void:
	## Show the scenario introduction screen after generation completes.
	## Player must click "Let's Begin" to start playing.

	# Create scenario panel
	scenario_panel = _scenario_panel_scene.instantiate()
	add_child(scenario_panel)

	# Create tutorial panel (starts hidden)
	tutorial_panel = _tutorial_panel_scene.instantiate()
	add_child(tutorial_panel)

	# Connect signals
	scenario_panel.game_started.connect(_on_scenario_begin)
	scenario_panel.tutorial_requested.connect(_on_tutorial_requested)
	tutorial_panel.back_requested.connect(_on_tutorial_back)

	# Show scenario screen
	scenario_panel.show_scenario()

	# Pause game time and physics while showing scenario
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and "paused" in time_manager:
		time_manager.paused = true
	get_tree().paused = true

	# Ensure snow is off during scenario screen
	var snow_ctrl := _find_snow_controller()
	if snow_ctrl and snow_ctrl.has_method("stop_snow"):
		snow_ctrl.stop_snow()

	print("[ProceduralGame] Scenario screen displayed (game paused)")


func _on_scenario_begin() -> void:
	## Player clicked "Let's Begin" - start the game.

	# Show HUD elements
	if game_hud:
		game_hud.visible = true
	if inventory_hud:
		inventory_hud.visible = true

	# Unpause game tree and time
	get_tree().paused = false
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and "paused" in time_manager:
		time_manager.paused = false

	# Start random weather (after unpause so particles work)
	_start_random_weather()

	print("[ProceduralGame] Game started!")


func _start_random_weather() -> void:
	## Enable dynamic weather system.
	## DynamicWeatherController handles all procedural weather scheduling,
	## respecting time-of-day (no snow at sunrise/sunset) and using
	## weighted random intensity selection with varied parameters.

	var dynamic_weather := _find_dynamic_weather_controller()
	if dynamic_weather:
		# DynamicWeatherController already started with clear weather in _ready()
		# It will automatically schedule the first weather event after clear period
		print("[ProceduralGame] DynamicWeatherController active - procedural weather enabled")
		return

	# Fallback: Use old random weather if DynamicWeatherController not found
	var snow_ctrl := _find_snow_controller()
	if not snow_ctrl:
		print("[ProceduralGame] No weather controller found, skipping weather")
		return

	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var roll := rng.randf()
	if roll < 0.4:
		print("[ProceduralGame] Starting weather: Clear (fallback)")
	elif roll < 0.8:
		snow_ctrl.start_snow(1)  # SnowIntensity.LIGHT = 1
		print("[ProceduralGame] Starting weather: Light snow (fallback)")
	else:
		snow_ctrl.start_snow(2)  # SnowIntensity.HEAVY = 2
		print("[ProceduralGame] Starting weather: BLIZZARD! (fallback)")


func _find_snow_controller() -> Node:
	## Find SnowController node in scene.
	var nodes := get_tree().get_nodes_in_group("weather")
	if nodes.size() > 0:
		return nodes[0]
	# Search by class/name
	return get_tree().current_scene.find_child("SnowController", true, false)


func _find_dynamic_weather_controller() -> Node:
	## Find DynamicWeatherController node in scene.
	var nodes := get_tree().current_scene.find_children("*", "DynamicWeatherController", true, false)
	if nodes.size() > 0:
		return nodes[0]
	return null


func _on_tutorial_requested() -> void:
	## Player clicked "Tutorial" - show tutorial screen.
	scenario_panel.hide_scenario()
	tutorial_panel.show_tutorial()


func _on_tutorial_back() -> void:
	## Player clicked "Back" from tutorial - return to scenario.
	tutorial_panel.hide_tutorial()
	scenario_panel.show_scenario()


# === BUTCHERING ===

const BUTCHER_MULTIPLIER: float = 1.0  ## Stub: will be replaced by unit's butchering skill.

func _on_butcher_confirmed(corpse: Node3D) -> void:
	if not corpse or not is_instance_valid(corpse):
		return
	# Validate: must have a selected unit with a hatchet
	var selected: Array[Node] = _input_handler.get_selected_units() if _input_handler else []
	var butcher_unit: Node = selected[0] if not selected.is_empty() else null
	if not butcher_unit or not butcher_unit.has_method("has_item_by_id") or not butcher_unit.has_item_by_id("hatchet"):
		push_warning("[ProceduralGame] Butcher attempted without selected unit with hatchet!")
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
	print("[ProceduralGame] Butchered %s — body parts created" % corpse_name)


func _open_corpse_inventory(corpse: Node, corpse_inv: Inventory) -> void:
	var container_panel: InventoryPanel = inventory_hud.get_container_panel()
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
	# Validate: must have a selected unit with a knife
	var selected: Array[Node] = _input_handler.get_selected_units() if _input_handler else []
	var carver_unit: Node = selected[0] if not selected.is_empty() else null
	if not carver_unit or not carver_unit.has_method("has_item_by_id") or not carver_unit.has_item_by_id("knife"):
		push_warning("[ProceduralGame] Carve attempted without selected unit with knife!")
		return
	var inv: Inventory = item.get_inventory()
	if not inv:
		return
	var meat_yield: int = int(item.get_property("meat_yield", 1))
	var total_meat: int = int(floorf(meat_yield * BUTCHER_MULTIPLIER))
	inv.remove_item(item)
	for i in range(total_meat):
		inv.create_and_add_item("human_meat")
	print("[ProceduralGame] Carved body part into %d human meat" % total_meat)
