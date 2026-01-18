@tool
extends Control
## Terrain Parameters Dock - Editor UI for tweaking terrain generation.
## Saves/loads TerrainConfig resource to res://terrain/terrain_params.tres

const TerrainConfig := preload("res://src/terrain/terrain_config.gd")
const IslandShape := preload("res://src/terrain/island_shape.gd")
const HeightmapGenerator := preload("res://src/terrain/heightmap_generator.gd")
const CONFIG_PATH := "res://terrain/terrain_params.tres"

## Preview configuration
const PREVIEW_SIZE: int = 256  # Low res for 2D preview
const PREVIEW_3D_SIZE: int = 192  # 192x192 = ~37K vertices - good detail
const PREVIEW_DEBOUNCE_SEC: float = 0.15  # 150ms delay after slider stops
const MESH_HEIGHT_SCALE: float = 0.15  # Vertical exaggeration for 3D view (increased for visibility)

var _config: Resource = null
var _preview_texture: TextureRect = null
var _preview_timer: Timer = null
var _sliders: Dictionary = {}  # param_name -> HSlider
var _value_labels: Dictionary = {}  # param_name -> Label
var _checkboxes: Dictionary = {}  # param_name -> CheckBox

## 3D Preview components
var _is_3d_preview: bool = false
var _3d_toggle_btn: Button = null
var _3d_container: SubViewportContainer = null
var _subviewport: SubViewport = null
var _camera: Camera3D = null
var _mesh_instance: MeshInstance3D = null
var _light: DirectionalLight3D = null

## Camera orbit state
var _camera_distance: float = 8.0  # Closer default for larger preview
var _camera_yaw: float = 0.5  # Radians (horizontal rotation)
var _camera_pitch: float = 0.7  # Radians (vertical tilt - higher for better overhead view)
var _is_dragging: bool = false
var _last_mouse_pos: Vector2 = Vector2.ZERO

## Cache heightmap for 3D mesh generation
var _cached_heightmap: Image = null

## Popup window for larger preview
var _popup_window: Window = null
var _popup_3d_container: SubViewportContainer = null
var _popup_subviewport: SubViewport = null
var _popup_camera: Camera3D = null
var _popup_mesh_instance: MeshInstance3D = null
var _popup_light: DirectionalLight3D = null

## Tooltips explaining each parameter's effect on terrain generation
const TOOLTIPS := {
	# Ridge parameters
	"ridge_amplitude": "Height of ridge features on mountains. Lower values create smoother peaks, higher values create sharper ridges. Reduce to fix 'castle wall' artifacts.",
	"ridge_frequency": "How often ridge patterns repeat. Lower = wider ridges, higher = more frequent narrow ridges.",
	"valley_cut_strength": "How deep valleys cut between ridges. Higher values create more pronounced V-shaped valleys.",
	"use_ridged_noise": "Enable ridged noise for alpine-style peaks. Disable for smoother, dome-shaped mountains.",
	# Cliff parameters
	"cliff_frequency": "How often cliff formations appear. Higher = more frequent cliff bands.",
	"coastal_cliff_strength": "Height of cliffs along coastlines. Higher = more dramatic coastal cliffs.",
	"mountain_cliff_strength": "Cliff intensity in mountain regions. Creates rugged mountain terrain.",
	"midland_cliff_strength": "Cliff intensity in midland areas. Keep low for navigable terrain between coast and mountains.",
	# Height constraints
	"max_mountain_height": "Maximum elevation of mountain peaks in meters.",
	"max_hill_height": "Maximum elevation of rolling hills in meters.",
	"base_terrain_amplitude": "Gentle undulation of base terrain everywhere on the island.",
	# Regional parameters
	"mountain_band_center": "North-south position of mountain band (0=north, 1=south). Controls where mountains concentrate.",
	"mountain_band_width": "How wide the mountain region spreads. Larger = mountains cover more of island.",
	"midland_start": "Where the navigable midland corridor begins (from north). Area between mountains and plains.",
	"flat_plains_start": "Where flat southern plains begin. Everything south of this is mostly flat.",
	"midland_hill_smoothing": "How much to smooth hills in midlands. Higher = flatter midland terrain for easier navigation.",
	# Noise frequencies
	"base_frequency": "Base terrain noise frequency. Lower = broader terrain features.",
	"hill_frequency": "Hill noise frequency. Controls the 'wavelength' of rolling hills.",
	"mountain_frequency": "Mountain noise frequency. Affects the scale of mountain features.",
	# Inlet parameters
	"inlet_width_pixels": "Width of the ship landing cove in pixels (~2.5m per pixel).",
	"inlet_length_pixels": "How far the cove extends into the island in pixels.",
	# Peak parameters
	"peak_1_enabled": "Enable/disable the first mountain peak.",
	"peak_1_x": "East-west position of peak 1 (0=west, 1=east).",
	"peak_1_y": "North-south position of peak 1 (0=north, 1=south).",
	"peak_1_height": "Maximum height of peak 1 in meters.",
	"peak_1_radius": "Size/spread of peak 1. Larger = wider mountain.",
	"peak_2_enabled": "Enable/disable the second mountain peak.",
	"peak_2_x": "East-west position of peak 2 (0=west, 1=east).",
	"peak_2_y": "North-south position of peak 2 (0=north, 1=south).",
	"peak_2_height": "Maximum height of peak 2 in meters.",
	"peak_2_radius": "Size/spread of peak 2. Larger = wider mountain.",
	"peak_3_enabled": "Enable/disable the third mountain peak.",
	"peak_3_x": "East-west position of peak 3 (0=west, 1=east).",
	"peak_3_y": "North-south position of peak 3 (0=north, 1=south).",
	"peak_3_height": "Maximum height of peak 3 in meters.",
	"peak_3_radius": "Size/spread of peak 3. Larger = wider mountain.",
}


func _ready() -> void:
	_load_config()
	_build_ui()


func _load_config() -> void:
	if ResourceLoader.exists(CONFIG_PATH):
		_config = load(CONFIG_PATH)
		if _config:
			print("[TerrainParams] Loaded config from %s" % CONFIG_PATH)
			return

	# Create default config
	_config = TerrainConfig.new()
	print("[TerrainParams] Created default config")


func _save_config() -> void:
	if not _config:
		return
	var err := ResourceSaver.save(_config, CONFIG_PATH)
	if err == OK:
		print("[TerrainParams] Config saved to %s" % CONFIG_PATH)
	else:
		push_error("[TerrainParams] Failed to save config: %d" % err)


func _build_ui() -> void:
	# Main vertical layout: sticky preview on top, scrollable settings below
	var main_vbox := VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 4)
	add_child(main_vbox)

	# ===== STICKY TOP SECTION (Preview + Buttons) =====
	var top_section := VBoxContainer.new()
	top_section.add_theme_constant_override("separation", 4)
	main_vbox.add_child(top_section)

	# Title
	var title := Label.new()
	title.text = "TERRAIN PARAMETERS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top_section.add_child(title)

	# Preview - always visible at top (2D grayscale)
	_preview_texture = TextureRect.new()
	_preview_texture.custom_minimum_size = Vector2(400, 400)  # 4x larger preview
	_preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_preview_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	top_section.add_child(_preview_texture)

	# 3D Preview container (hidden by default)
	_setup_3d_preview()
	top_section.add_child(_3d_container)

	# Preview control buttons row
	var preview_btn_row := HBoxContainer.new()
	preview_btn_row.add_theme_constant_override("separation", 8)
	preview_btn_row.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	top_section.add_child(preview_btn_row)

	# Toggle 2D/3D button
	_3d_toggle_btn = Button.new()
	_3d_toggle_btn.text = "Switch to 3D"
	_3d_toggle_btn.pressed.connect(_on_toggle_3d_preview)
	preview_btn_row.add_child(_3d_toggle_btn)

	# Pop out to larger window button
	var popup_btn := Button.new()
	popup_btn.text = "Pop Out (3D)"
	popup_btn.pressed.connect(_on_popup_preview)
	preview_btn_row.add_child(popup_btn)

	# Debounce timer for preview updates
	_preview_timer = Timer.new()
	_preview_timer.one_shot = true
	_preview_timer.wait_time = PREVIEW_DEBOUNCE_SEC
	_preview_timer.timeout.connect(_generate_preview)
	add_child(_preview_timer)

	# Action buttons
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 8)
	top_section.add_child(btn_row)

	var save_btn := Button.new()
	save_btn.text = "Save Config"
	save_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	save_btn.pressed.connect(_save_config)
	btn_row.add_child(save_btn)

	var reset_btn := Button.new()
	reset_btn.text = "Reset Defaults"
	reset_btn.pressed.connect(_on_reset_defaults)
	btn_row.add_child(reset_btn)

	top_section.add_child(HSeparator.new())

	# ===== SCROLLABLE SETTINGS SECTION =====
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(scroll)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_bottom", 8)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(vbox)

	# ============== RIDGE PARAMETERS ==============
	_add_section_header(vbox, "RIDGE PARAMETERS (Castle Wall Fix)")
	_add_slider(vbox, "ridge_amplitude", "Ridge Amplitude", 0.0, 1.0, 0.05)
	_add_slider(vbox, "ridge_frequency", "Ridge Frequency", 0.001, 0.02, 0.001)
	_add_slider(vbox, "valley_cut_strength", "Valley Cut Strength", 0.0, 0.5, 0.05)
	_add_checkbox(vbox, "use_ridged_noise", "Use Ridged Noise")

	vbox.add_child(HSeparator.new())

	# ============== CLIFF PARAMETERS ==============
	_add_section_header(vbox, "CLIFF PARAMETERS")
	_add_slider(vbox, "cliff_frequency", "Cliff Frequency", 0.001, 0.02, 0.001)
	_add_slider(vbox, "coastal_cliff_strength", "Coastal Cliff Strength", 0.0, 1.0, 0.05)
	_add_slider(vbox, "mountain_cliff_strength", "Mountain Cliff Strength", 0.0, 1.0, 0.05)
	_add_slider(vbox, "midland_cliff_strength", "Midland Cliff Strength", 0.0, 0.5, 0.05)

	vbox.add_child(HSeparator.new())

	# ============== HEIGHT CONSTRAINTS ==============
	_add_section_header(vbox, "HEIGHT CONSTRAINTS")
	_add_slider(vbox, "max_mountain_height", "Max Mountain Height", 100.0, 500.0, 10.0)
	_add_slider(vbox, "max_hill_height", "Max Hill Height", 50.0, 200.0, 5.0)
	_add_slider(vbox, "base_terrain_amplitude", "Base Terrain Amp", 5.0, 50.0, 1.0)

	vbox.add_child(HSeparator.new())

	# ============== REGIONAL PARAMETERS ==============
	_add_section_header(vbox, "REGIONAL PARAMETERS")
	_add_slider(vbox, "mountain_band_center", "Mountain Band Center", 0.2, 0.6, 0.05)
	_add_slider(vbox, "mountain_band_width", "Mountain Band Width", 0.1, 0.5, 0.05)
	_add_slider(vbox, "midland_start", "Midland Start (NY)", 0.2, 0.5, 0.05)
	_add_slider(vbox, "flat_plains_start", "Flat Plains Start", 0.5, 0.8, 0.05)
	_add_slider(vbox, "midland_hill_smoothing", "Midland Smoothing", 0.0, 1.0, 0.1)

	vbox.add_child(HSeparator.new())

	# ============== NOISE FREQUENCIES ==============
	_add_section_header(vbox, "NOISE FREQUENCIES")
	_add_slider(vbox, "base_frequency", "Base Frequency", 0.001, 0.01, 0.001)
	_add_slider(vbox, "hill_frequency", "Hill Frequency", 0.001, 0.01, 0.001)
	_add_slider(vbox, "mountain_frequency", "Mountain Frequency", 0.001, 0.01, 0.001)

	vbox.add_child(HSeparator.new())

	# ============== INLET PARAMETERS ==============
	_add_section_header(vbox, "INLET PARAMETERS")
	_add_slider(vbox, "inlet_width_pixels", "Inlet Width (px)", 40.0, 200.0, 10.0)
	_add_slider(vbox, "inlet_length_pixels", "Inlet Length (px)", 100.0, 600.0, 50.0)

	vbox.add_child(HSeparator.new())

	# ============== PEAK 1 ==============
	_add_section_header(vbox, "MOUNTAIN PEAK 1")
	_add_checkbox(vbox, "peak_1_enabled", "Peak 1 Enabled")
	_add_slider(vbox, "peak_1_x", "Peak 1 X", 0.1, 0.9, 0.05)
	_add_slider(vbox, "peak_1_y", "Peak 1 Y", 0.1, 0.9, 0.05)
	_add_slider(vbox, "peak_1_height", "Peak 1 Height", 100.0, 400.0, 10.0)
	_add_slider(vbox, "peak_1_radius", "Peak 1 Radius", 0.05, 0.3, 0.01)

	vbox.add_child(HSeparator.new())

	# ============== PEAK 2 ==============
	_add_section_header(vbox, "MOUNTAIN PEAK 2")
	_add_checkbox(vbox, "peak_2_enabled", "Peak 2 Enabled")
	_add_slider(vbox, "peak_2_x", "Peak 2 X", 0.1, 0.9, 0.05)
	_add_slider(vbox, "peak_2_y", "Peak 2 Y", 0.1, 0.9, 0.05)
	_add_slider(vbox, "peak_2_height", "Peak 2 Height", 100.0, 400.0, 10.0)
	_add_slider(vbox, "peak_2_radius", "Peak 2 Radius", 0.05, 0.3, 0.01)

	vbox.add_child(HSeparator.new())

	# ============== PEAK 3 ==============
	_add_section_header(vbox, "MOUNTAIN PEAK 3")
	_add_checkbox(vbox, "peak_3_enabled", "Peak 3 Enabled")
	_add_slider(vbox, "peak_3_x", "Peak 3 X", 0.1, 0.9, 0.05)
	_add_slider(vbox, "peak_3_y", "Peak 3 Y", 0.1, 0.9, 0.05)
	_add_slider(vbox, "peak_3_height", "Peak 3 Height", 100.0, 400.0, 10.0)
	_add_slider(vbox, "peak_3_radius", "Peak 3 Radius", 0.05, 0.3, 0.01)

	# Sync sliders with config values
	_sync_sliders_from_config()

	# Generate initial preview
	_generate_preview()


func _add_section_header(parent: Control, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	parent.add_child(label)


func _add_slider(parent: Control, param_name: String, display_name: String,
		min_val: float, max_val: float, step_val: float) -> void:
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)
	parent.add_child(hbox)

	var name_label := Label.new()
	name_label.text = display_name
	name_label.custom_minimum_size.x = 140
	# Add tooltip to label
	if param_name in TOOLTIPS:
		name_label.tooltip_text = TOOLTIPS[param_name]
		hbox.tooltip_text = TOOLTIPS[param_name]
	hbox.add_child(name_label)

	var slider := HSlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = step_val
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(_on_slider_changed.bind(param_name))
	if param_name in TOOLTIPS:
		slider.tooltip_text = TOOLTIPS[param_name]
	hbox.add_child(slider)
	_sliders[param_name] = slider

	var value_label := Label.new()
	value_label.custom_minimum_size.x = 50
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hbox.add_child(value_label)
	_value_labels[param_name] = value_label


func _add_checkbox(parent: Control, param_name: String, display_name: String) -> void:
	var checkbox := CheckBox.new()
	checkbox.text = display_name
	checkbox.toggled.connect(_on_checkbox_toggled.bind(param_name))
	# Add tooltip
	if param_name in TOOLTIPS:
		checkbox.tooltip_text = TOOLTIPS[param_name]
	parent.add_child(checkbox)
	_checkboxes[param_name] = checkbox


func _sync_sliders_from_config() -> void:
	if not _config:
		return

	for param_name in _sliders:
		var slider: HSlider = _sliders[param_name]
		if param_name in _config:
			var value = _config.get(param_name)
			slider.value = value
			if param_name in _value_labels:
				_value_labels[param_name].text = _format_value(param_name, value)

	for param_name in _checkboxes:
		var checkbox: CheckBox = _checkboxes[param_name]
		if param_name in _config:
			checkbox.button_pressed = _config.get(param_name)


func _on_slider_changed(value: float, param_name: String) -> void:
	if not _config:
		return
	_config.set(param_name, value)
	if param_name in _value_labels:
		_value_labels[param_name].text = _format_value(param_name, value)
	_request_preview_update()


func _on_checkbox_toggled(pressed: bool, param_name: String) -> void:
	if not _config:
		return
	_config.set(param_name, pressed)
	_request_preview_update()


func _format_value(param_name: String, value: float) -> String:
	if "frequency" in param_name:
		return "%.4f" % value
	elif "pixels" in param_name:
		return "%d px" % int(value)
	elif "height" in param_name and value > 10:
		return "%.0f m" % value
	elif value < 1.0:
		return "%.2f" % value
	else:
		return "%.1f" % value


func _on_reset_defaults() -> void:
	if _config and _config.has_method("reset_to_defaults"):
		_config.reset_to_defaults()
		_sync_sliders_from_config()
		_generate_preview()
		print("[TerrainParams] Reset to defaults")


## Request a preview update (debounced to avoid spam while dragging sliders)
func _request_preview_update() -> void:
	if _preview_timer:
		_preview_timer.start()


## Generate the heightmap preview (2D or 3D depending on mode)
func _generate_preview() -> void:
	if not _config:
		return

	# Generate island mask at preview resolution using fixed seed for consistency
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345  # Fixed seed so preview is consistent

	# Use smaller resolution for 3D to keep performance acceptable
	var size := PREVIEW_3D_SIZE if _is_3d_preview else PREVIEW_SIZE

	var island_mask := IslandShape.generate_mask(size, size, rng)

	# Generate heightmap at preview resolution
	var height_rng := RandomNumberGenerator.new()
	height_rng.seed = 12345
	var heightmap := HeightmapGenerator.generate_heightmap(
		size, size, island_mask, height_rng, _config
	)

	# Cache heightmap for 3D mesh generation
	_cached_heightmap = heightmap

	# Update the appropriate preview
	if _is_3d_preview:
		_generate_3d_mesh()
	else:
		var gray_image := _heightmap_to_grayscale(heightmap)
		var texture := ImageTexture.create_from_image(gray_image)
		_preview_texture.texture = texture

	# Also update popup if it's open
	if _popup_window and is_instance_valid(_popup_window) and _popup_mesh_instance:
		_generate_popup_mesh()


## Convert a FORMAT_RF heightmap to grayscale (white = high, black = low)
func _heightmap_to_grayscale(heightmap: Image) -> Image:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	# Find min/max heights for normalization
	var min_h := INF
	var max_h := -INF
	for y in range(height):
		for x in range(width):
			var h: float = heightmap.get_pixel(x, y).r
			min_h = minf(min_h, h)
			max_h = maxf(max_h, h)

	var range_h := max_h - min_h
	if range_h < 0.01:
		range_h = 1.0  # Avoid division by zero

	# Create grayscale image (FORMAT_L8 for efficiency)
	var gray := Image.create(width, height, false, Image.FORMAT_L8)
	for y in range(height):
		for x in range(width):
			var h: float = heightmap.get_pixel(x, y).r
			var normalized := (h - min_h) / range_h
			var byte_val := int(clampf(normalized * 255.0, 0.0, 255.0))
			gray.set_pixel(x, y, Color8(byte_val, byte_val, byte_val))

	return gray


# ============== 3D PREVIEW FUNCTIONS ==============

## Set up the 3D preview SubViewport and scene
func _setup_3d_preview() -> void:
	# Create SubViewportContainer (displays the SubViewport)
	_3d_container = SubViewportContainer.new()
	_3d_container.custom_minimum_size = Vector2(400, 400)  # 4x larger preview
	_3d_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_3d_container.stretch = true
	_3d_container.visible = false  # Hidden by default (2D mode)

	# Create SubViewport with its own World3D
	_subviewport = SubViewport.new()
	_subviewport.size = Vector2i(512, 512)  # Higher res for quality
	_subviewport.transparent_bg = false
	_subviewport.own_world_3d = true
	_3d_container.add_child(_subviewport)

	# Add directional light for terrain visibility
	_light = DirectionalLight3D.new()
	_light.rotation_degrees = Vector3(-45, 45, 0)
	_light.light_energy = 1.2
	_subviewport.add_child(_light)

	# Add ambient light via WorldEnvironment
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.15, 0.18, 0.22)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.4, 0.45, 0.5)
	env.ambient_light_energy = 0.5
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	_subviewport.add_child(world_env)

	# Add camera
	_camera = Camera3D.new()
	_update_camera_position()
	_subviewport.add_child(_camera)

	# Add mesh instance (empty mesh initially)
	_mesh_instance = MeshInstance3D.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.85, 0.85, 0.8)
	mat.roughness = 0.9
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED  # Render both sides
	_mesh_instance.material_override = mat
	_subviewport.add_child(_mesh_instance)


## Toggle between 2D and 3D preview modes
func _on_toggle_3d_preview() -> void:
	_is_3d_preview = not _is_3d_preview
	_preview_texture.visible = not _is_3d_preview
	_3d_container.visible = _is_3d_preview
	_3d_toggle_btn.text = "Switch to 2D" if _is_3d_preview else "Switch to 3D"

	# Regenerate preview for the new mode
	_generate_preview()


## Update camera position based on orbit parameters
func _update_camera_position() -> void:
	if not _camera or not _camera.is_inside_tree():
		return
	# Orbit around center using spherical coordinates
	var center := Vector3(0, 0, 0)
	var x := sin(_camera_yaw) * cos(_camera_pitch) * _camera_distance
	var y := sin(_camera_pitch) * _camera_distance
	var z := cos(_camera_yaw) * cos(_camera_pitch) * _camera_distance
	_camera.position = center + Vector3(x, y, z)
	_camera.look_at(center, Vector3.UP)


## Handle mouse input for camera orbit (only in 3D mode)
func _gui_input(event: InputEvent) -> void:
	if not _is_3d_preview or not _3d_container or not _3d_container.visible:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_is_dragging = event.pressed
			_last_mouse_pos = event.position
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_camera_distance = maxf(3.0, _camera_distance - 0.5)  # Allow closer zoom
			_update_camera_position()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_camera_distance = minf(15.0, _camera_distance + 0.5)  # Faster zoom
			_update_camera_position()

	elif event is InputEventMouseMotion and _is_dragging:
		var delta: Vector2 = event.position - _last_mouse_pos
		_camera_yaw += delta.x * 0.01
		_camera_pitch = clampf(_camera_pitch + delta.y * 0.01, 0.1, 1.4)
		_last_mouse_pos = event.position
		_update_camera_position()


## Generate 3D mesh from cached heightmap
func _generate_3d_mesh() -> void:
	if not _cached_heightmap or not _mesh_instance:
		return

	var mesh := _heightmap_to_mesh(_cached_heightmap)
	_mesh_instance.mesh = mesh

	# Center the mesh (must match scale_xz in _heightmap_to_mesh)
	var size := float(_cached_heightmap.get_width())
	var scale_xz := 0.04  # Must match _heightmap_to_mesh
	_mesh_instance.position = Vector3(-size * 0.5 * scale_xz, -2.0, -size * 0.5 * scale_xz)


## Convert heightmap Image to ArrayMesh for 3D rendering
func _heightmap_to_mesh(heightmap: Image) -> ArrayMesh:
	var width := heightmap.get_width()
	var height := heightmap.get_height()
	var scale_xz := 0.04  # Horizontal scale (slightly smaller for larger preview)

	# Find min/max height for proper normalization
	var min_h := INF
	var max_h := -INF
	for y in range(height):
		for x in range(width):
			var h: float = heightmap.get_pixel(x, y).r
			min_h = minf(min_h, h)
			max_h = maxf(max_h, h)

	# Calculate height range and proper scale
	var height_range := max_h - min_h
	if height_range < 1.0:
		height_range = 1.0  # Prevent division by zero

	# Scale Y so the mesh has good visible height variation
	# Target: mesh height should be ~3-4 units for good visual
	var target_mesh_height := 4.0
	var scale_y := target_mesh_height / height_range

	# Generate vertices with proper height normalization
	var vertices := PackedVector3Array()
	vertices.resize(width * height)
	for y in range(height):
		for x in range(width):
			var raw_h: float = heightmap.get_pixel(x, y).r
			# Normalize to 0-1 range, then scale
			var normalized_h := (raw_h - min_h) / height_range
			var h: float = normalized_h * target_mesh_height
			vertices[y * width + x] = Vector3(x * scale_xz, h, y * scale_xz)

	# Generate indices (two triangles per quad)
	# Winding order: counterclockwise when viewed from above (+Y) so normals point UP
	var indices := PackedInt32Array()
	indices.resize((width - 1) * (height - 1) * 6)
	var idx := 0
	for y in range(height - 1):
		for x in range(width - 1):
			var i0 := y * width + x        # top-left
			var i1 := i0 + 1               # top-right
			var i2 := i0 + width           # bottom-left
			var i3 := i2 + 1               # bottom-right
			# Triangle 1: i0 -> i1 -> i2 (counterclockwise from above)
			indices[idx] = i0
			idx += 1
			indices[idx] = i1
			idx += 1
			indices[idx] = i2
			idx += 1
			# Triangle 2: i1 -> i3 -> i2 (counterclockwise from above)
			indices[idx] = i1
			idx += 1
			indices[idx] = i3
			idx += 1
			indices[idx] = i2
			idx += 1

	# Generate normals for proper lighting
	var normals := PackedVector3Array()
	normals.resize(width * height)
	for i in range(normals.size()):
		normals[i] = Vector3.ZERO

	# Calculate face normals and accumulate to vertices
	# Using the same winding as indices: i0->i1->i2 (counterclockwise from above)
	for y in range(height - 1):
		for x in range(width - 1):
			var i0 := y * width + x
			var i1 := i0 + 1
			var i2 := i0 + width
			var i3 := i2 + 1
			var v0 := vertices[i0]
			var v1 := vertices[i1]
			var v2 := vertices[i2]
			var v3 := vertices[i3]
			# Normal for triangle 1 (i0, i1, i2)
			var edge1 := v1 - v0
			var edge2 := v2 - v0
			var normal1 := edge2.cross(edge1).normalized()  # Cross order for CCW winding
			normals[i0] += normal1
			normals[i1] += normal1
			normals[i2] += normal1
			# Normal for triangle 2 (i1, i3, i2)
			var edge3 := v3 - v1
			var edge4 := v2 - v1
			var normal2 := edge4.cross(edge3).normalized()
			normals[i1] += normal2
			normals[i3] += normal2
			normals[i2] += normal2

	# Normalize accumulated normals
	for i in range(normals.size()):
		normals[i] = normals[i].normalized()

	# Create mesh
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	arrays[Mesh.ARRAY_NORMAL] = normals

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


# ============== POPUP WINDOW FUNCTIONS ==============

## Open a larger popup window with 3D preview
func _on_popup_preview() -> void:
	# Close existing popup if open
	if _popup_window and is_instance_valid(_popup_window):
		_popup_window.queue_free()
		_popup_window = null

	# Create popup window
	_popup_window = Window.new()
	_popup_window.title = "Terrain 3D Preview"
	_popup_window.size = Vector2i(800, 700)
	_popup_window.min_size = Vector2i(400, 400)
	_popup_window.close_requested.connect(_on_popup_closed)
	add_child(_popup_window)

	# Main container in popup
	var popup_vbox := VBoxContainer.new()
	popup_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup_vbox.add_theme_constant_override("separation", 8)
	_popup_window.add_child(popup_vbox)

	# Create SubViewportContainer for 3D rendering (fills most of the window)
	_popup_3d_container = SubViewportContainer.new()
	_popup_3d_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_popup_3d_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_popup_3d_container.stretch = true
	popup_vbox.add_child(_popup_3d_container)

	# Create SubViewport
	_popup_subviewport = SubViewport.new()
	_popup_subviewport.size = Vector2i(800, 600)
	_popup_subviewport.transparent_bg = false
	_popup_subviewport.own_world_3d = true
	_popup_3d_container.add_child(_popup_subviewport)

	# Add directional light
	_popup_light = DirectionalLight3D.new()
	_popup_light.rotation_degrees = Vector3(-45, 45, 0)
	_popup_light.light_energy = 1.2
	_popup_subviewport.add_child(_popup_light)

	# Add ambient light via WorldEnvironment
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.15, 0.18, 0.22)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.4, 0.45, 0.5)
	env.ambient_light_energy = 0.5
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	_popup_subviewport.add_child(world_env)

	# Add camera
	_popup_camera = Camera3D.new()
	_popup_camera.position = Vector3(5, 6, 8)
	_popup_camera.look_at(Vector3.ZERO, Vector3.UP)
	_popup_subviewport.add_child(_popup_camera)

	# Add mesh instance
	_popup_mesh_instance = MeshInstance3D.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.85, 0.85, 0.8)
	mat.roughness = 0.9
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED  # Render both sides
	_popup_mesh_instance.material_override = mat
	_popup_subviewport.add_child(_popup_mesh_instance)

	# Bottom bar with instructions and controls
	var bottom_bar := HBoxContainer.new()
	bottom_bar.add_theme_constant_override("separation", 16)
	popup_vbox.add_child(bottom_bar)

	# Instructions label
	var instructions := Label.new()
	instructions.text = "Drag to orbit | Scroll to zoom"
	instructions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_bar.add_child(instructions)

	# Always on top toggle button
	var always_on_top_btn := Button.new()
	always_on_top_btn.text = "Pin on Top"
	always_on_top_btn.toggle_mode = true
	always_on_top_btn.toggled.connect(_on_always_on_top_toggled)
	bottom_bar.add_child(always_on_top_btn)

	# Generate the mesh for popup (higher resolution)
	_generate_popup_mesh()

	# Connect mouse input for camera control
	_popup_3d_container.gui_input.connect(_on_popup_gui_input)

	# Show the window
	_popup_window.popup_centered()


## Handle popup window close
func _on_popup_closed() -> void:
	if _popup_window:
		_popup_window.queue_free()
		_popup_window = null


## Generate higher resolution mesh for popup
func _generate_popup_mesh() -> void:
	if not _config or not _popup_mesh_instance:
		return

	# Generate at higher resolution for popup
	var size := 256  # Higher res for popup

	var rng := RandomNumberGenerator.new()
	rng.seed = 12345

	var island_mask := IslandShape.generate_mask(size, size, rng)

	var height_rng := RandomNumberGenerator.new()
	height_rng.seed = 12345
	var heightmap := HeightmapGenerator.generate_heightmap(size, size, island_mask, height_rng, _config)

	var mesh := _heightmap_to_mesh(heightmap)
	_popup_mesh_instance.mesh = mesh

	# Center the mesh
	var scale_xz := 0.04
	_popup_mesh_instance.position = Vector3(-size * 0.5 * scale_xz, -2.0, -size * 0.5 * scale_xz)


## Handle mouse input in popup window for camera orbit
func _on_popup_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_is_dragging = event.pressed
			_last_mouse_pos = event.position
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_camera_distance = maxf(3.0, _camera_distance - 0.5)
			_update_popup_camera()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_camera_distance = minf(15.0, _camera_distance + 0.5)
			_update_popup_camera()

	elif event is InputEventMouseMotion and _is_dragging:
		var delta: Vector2 = event.position - _last_mouse_pos
		_camera_yaw += delta.x * 0.01
		_camera_pitch = clampf(_camera_pitch + delta.y * 0.01, 0.1, 1.4)
		_last_mouse_pos = event.position
		_update_popup_camera()


## Update popup camera position based on orbit parameters
func _update_popup_camera() -> void:
	if not _popup_camera:
		return
	var center := Vector3(0, 0, 0)
	var x := sin(_camera_yaw) * cos(_camera_pitch) * _camera_distance
	var y := sin(_camera_pitch) * _camera_distance
	var z := cos(_camera_yaw) * cos(_camera_pitch) * _camera_distance
	_popup_camera.position = center + Vector3(x, y, z)
	_popup_camera.look_at(center, Vector3.UP)


## Toggle always-on-top for popup window
func _on_always_on_top_toggled(pressed: bool) -> void:
	if _popup_window and is_instance_valid(_popup_window):
		_popup_window.always_on_top = pressed
