extends Node

const TerrainGenerator := preload("res://src/terrain/terrain_generator.gd")

var _panel: Control = null
var _is_open: bool = false
var _snow_controller: SnowController = null
var _dynamic_weather_controller: Node = null
var _seed_input: LineEdit = null
var _progress_label: Label = null
var _new_game_btn: Button = null
var _is_generating: bool = false

# Temperature controls
var _temp_label: Label = null
var _temp_override_check: CheckBox = null
var _temp_slider: HSlider = null
var _temp_value_label: Label = null

# Weather status display
var _weather_status_label: Label = null

# Camera controls
var _camera_constraint_check: CheckBox = null
var _camera_original_max_distance: float = 300.0
var _camera_original_zoom_max: float = 50.0
var _camera_original_speed: float = 20.0
var _camera_original_zoom_speed: float = 20.0

# Stat override controls
var _stat_sliders: Dictionary = {}  # stat_name -> HSlider
var _stat_value_labels: Dictionary = {}  # stat_name -> Label

# Scene mode detection
var _is_procedural_mode: bool = false
var _debug_override_unlocked: bool = false
var _override_input: LineEdit = null
var _override_container: Control = null
var _debug_content_container: Control = null
const OVERRIDE_CODE: String = "1111"


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Detect if we're in procedural mode (not main.tscn)
	_is_procedural_mode = _detect_procedural_mode()


func _detect_procedural_mode() -> bool:
	## Returns true if we're in a procedural game scene, false for main.tscn.
	var scene := get_tree().current_scene
	if not scene:
		return false
	# Check scene filename
	var scene_path: String = scene.scene_file_path
	if scene_path.ends_with("main.tscn"):
		return false
	# Check for ProceduralGameController node/script
	if scene.get_script() and "procedural" in scene.get_script().resource_path.to_lower():
		return true
	# Check by name
	if "procedural" in scene.name.to_lower():
		return true
	return true  # Default to procedural (limited menu) for unknown scenes


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_toggle_menu()
		get_viewport().set_input_as_handled()


func _toggle_menu() -> void:
	if _is_open:
		_close_menu()
	else:
		_open_menu()


func _open_menu() -> void:
	if not _panel:
		_create_panel()
	_panel.visible = true
	_is_open = true
	get_tree().paused = true
	# Pause Sky3D time progression
	if has_node("/root/TimeManager"):
		get_node("/root/TimeManager").pause()
	# Update displays
	_update_temp_label()
	_update_weather_status()
	_sync_temp_override_state()
	_sync_camera_constraint_state()


func _close_menu() -> void:
	if _panel:
		_panel.visible = false
	_is_open = false
	get_tree().paused = false
	# Resume Sky3D time progression
	if has_node("/root/TimeManager"):
		get_node("/root/TimeManager").unpause()


func _create_panel() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 100
	canvas.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(canvas)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.process_mode = Node.PROCESS_MODE_ALWAYS
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Don't block clicks when panel hidden
	canvas.add_child(center)

	_panel = PanelContainer.new()
	_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	# Smaller panel for procedural mode (pause menu)
	if _is_procedural_mode and not _debug_override_unlocked:
		_panel.custom_minimum_size = Vector2(300, 200)
	else:
		_panel.custom_minimum_size = Vector2(400, 600)
	# Limit max height to 80% of viewport
	_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	center.add_child(_panel)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(280, 0) if (_is_procedural_mode and not _debug_override_unlocked) else Vector2(380, 0)
	_panel.add_child(scroll)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(vbox)

	# Different content based on mode
	if _is_procedural_mode and not _debug_override_unlocked:
		_create_pause_menu_content(vbox)
	else:
		_create_full_debug_content(vbox)

	_find_snow_controller()


func _create_pause_menu_content(vbox: VBoxContainer) -> void:
	## Create simplified pause menu for procedural mode.
	var title := Label.new()
	title.text = "PAUSED"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	vbox.add_child(HSeparator.new())

	_add_button(vbox, "Resume", _close_menu)

	var quit_btn := Button.new()
	quit_btn.text = "Quit to Main Menu"
	quit_btn.pressed.connect(_on_quit_to_menu)
	vbox.add_child(quit_btn)

	vbox.add_child(HSeparator.new())

	# Override code section (hidden/subtle)
	_override_container = VBoxContainer.new()
	_override_container.add_theme_constant_override("separation", 5)
	vbox.add_child(_override_container)

	var override_label := Label.new()
	override_label.text = "Enter Override Code:"
	override_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	override_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	_override_container.add_child(override_label)

	var override_hbox := HBoxContainer.new()
	override_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_override_container.add_child(override_hbox)

	_override_input = LineEdit.new()
	_override_input.placeholder_text = "****"
	_override_input.secret = true
	_override_input.custom_minimum_size.x = 80
	_override_input.max_length = 4
	_override_input.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_override_input.text_submitted.connect(_on_override_submitted)
	override_hbox.add_child(_override_input)

	var hint := Label.new()
	hint.text = "Press ESC to close"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	vbox.add_child(hint)


func _create_full_debug_content(vbox: VBoxContainer) -> void:
	## Create full debug menu content.
	var title := Label.new()
	title.text = "DEBUG MENU"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	vbox.add_child(HSeparator.new())

	# New Game section
	var new_game_label := Label.new()
	new_game_label.text = "NEW GAME"
	new_game_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(new_game_label)

	# Seed input
	var seed_hbox := HBoxContainer.new()
	vbox.add_child(seed_hbox)

	var seed_label := Label.new()
	seed_label.text = "Seed:"
	seed_hbox.add_child(seed_label)

	_seed_input = LineEdit.new()
	_seed_input.placeholder_text = "Random"
	_seed_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_seed_input.tooltip_text = "Enter hex seed or leave blank for random"
	seed_hbox.add_child(_seed_input)

	_new_game_btn = Button.new()
	_new_game_btn.text = "Generate Terrain"
	_new_game_btn.pressed.connect(_on_new_game)
	vbox.add_child(_new_game_btn)

	_progress_label = Label.new()
	_progress_label.text = ""
	_progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_progress_label.add_theme_color_override("font_color", Color(0.7, 0.9, 0.7))
	vbox.add_child(_progress_label)

	vbox.add_child(HSeparator.new())

	# Weather controls
	var weather_label := Label.new()
	weather_label.text = "WEATHER"
	weather_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(weather_label)

	# Weather status display
	_weather_status_label = Label.new()
	_weather_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_weather_status_label.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))
	_weather_status_label.text = "Loading..."
	vbox.add_child(_weather_status_label)

	# Force weather buttons
	_add_button(vbox, "Force Clear Weather", _on_force_clear)
	_add_button(vbox, "Force Very Light Snow", _on_force_very_light)
	_add_button(vbox, "Force Light Snow", _on_light_snow)
	_add_button(vbox, "Force Medium Snow", _on_force_medium)
	_add_button(vbox, "Force Heavy Blizzard", _on_heavy_blizzard)
	_add_button(vbox, "Stop Snow (Fade)", _on_stop_fade)

	vbox.add_child(HSeparator.new())

	# Temperature controls
	var temp_header := Label.new()
	temp_header.text = "TEMPERATURE"
	temp_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(temp_header)

	# Current temperature display
	_temp_label = Label.new()
	_temp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_update_temp_label()
	vbox.add_child(_temp_label)

	# Override checkbox
	_temp_override_check = CheckBox.new()
	_temp_override_check.text = "Override Temperature"
	_temp_override_check.toggled.connect(_on_temp_override_toggled)
	vbox.add_child(_temp_override_check)

	# Slider row
	var slider_hbox := HBoxContainer.new()
	vbox.add_child(slider_hbox)

	_temp_slider = HSlider.new()
	_temp_slider.min_value = -60.0
	_temp_slider.max_value = 10.0
	_temp_slider.step = 1.0
	_temp_slider.value = -20.0
	_temp_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_temp_slider.editable = false  # Disabled until override is checked
	_temp_slider.value_changed.connect(_on_temp_slider_changed)
	slider_hbox.add_child(_temp_slider)

	_temp_value_label = Label.new()
	_temp_value_label.text = "-20°C"
	_temp_value_label.custom_minimum_size.x = 50
	slider_hbox.add_child(_temp_value_label)

	vbox.add_child(HSeparator.new())

	# Camera controls
	var camera_header := Label.new()
	camera_header.text = "CAMERA"
	camera_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(camera_header)

	_camera_constraint_check = CheckBox.new()
	_camera_constraint_check.text = "Free Camera (no unit constraint)"
	_camera_constraint_check.toggled.connect(_on_camera_constraint_toggled)
	vbox.add_child(_camera_constraint_check)

	vbox.add_child(HSeparator.new())

	# Survivor stats controls
	var stats_header := Label.new()
	stats_header.text = "SURVIVOR STATS (ALL UNITS)"
	stats_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(stats_header)

	_add_stat_slider(vbox, "hunger", "Hunger")
	_add_stat_slider(vbox, "warmth", "Warmth")
	_add_stat_slider(vbox, "health", "Health")
	_add_stat_slider(vbox, "morale", "Morale")
	_add_stat_slider(vbox, "energy", "Energy")

	vbox.add_child(HSeparator.new())

	_add_button(vbox, "RESUME", _close_menu)

	# Add Quit to Main Menu button for procedural mode with override unlocked
	if _is_procedural_mode and _debug_override_unlocked:
		var quit_btn := Button.new()
		quit_btn.text = "Quit to Main Menu"
		quit_btn.pressed.connect(_on_quit_to_menu)
		vbox.add_child(quit_btn)

	var hint := Label.new()
	hint.text = "Press ESC to close"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	vbox.add_child(hint)


func _add_button(parent: Control, text: String, callback: Callable) -> void:
	var btn := Button.new()
	btn.text = text
	btn.pressed.connect(callback)
	parent.add_child(btn)


func _on_override_submitted(code: String) -> void:
	## Check if the entered code unlocks the full debug menu.
	if code == OVERRIDE_CODE:
		_debug_override_unlocked = true
		print("[DebugMenu] Override code accepted - full debug menu unlocked")
		# Rebuild the panel with full debug content
		_rebuild_panel()
	else:
		# Wrong code - clear the input and flash red
		if _override_input:
			_override_input.text = ""
			_override_input.add_theme_color_override("font_color", Color.RED)
			# Reset color after a moment
			get_tree().create_timer(0.5).timeout.connect(func():
				if _override_input:
					_override_input.remove_theme_color_override("font_color")
			)


func _on_quit_to_menu() -> void:
	## Quit to main menu - unpause and change scene.
	get_tree().paused = false
	# Resume TimeManager if it exists
	if has_node("/root/TimeManager"):
		get_node("/root/TimeManager").unpause()
	# Change to main menu scene
	get_tree().change_scene_to_file("res://scenes/menu_screen/menu_screen.tscn")


func _rebuild_panel() -> void:
	## Destroy and recreate the panel (used when override is unlocked).
	if _panel:
		_panel.get_parent().get_parent().queue_free()  # Free the CanvasLayer
		_panel = null
	# Reset control references
	_seed_input = null
	_progress_label = null
	_new_game_btn = null
	_temp_label = null
	_temp_override_check = null
	_temp_slider = null
	_temp_value_label = null
	_weather_status_label = null
	_camera_constraint_check = null
	_stat_sliders.clear()
	_stat_value_labels.clear()
	_override_input = null
	_override_container = null
	# Recreate with new content
	_create_panel()
	_panel.visible = true
	# Update displays
	_update_temp_label()
	_update_weather_status()
	_sync_temp_override_state()
	_sync_camera_constraint_state()


func _find_snow_controller() -> void:
	await get_tree().process_frame
	var root := get_tree().current_scene
	if root:
		# Find SnowController
		var nodes := root.find_children("*", "SnowController", true, false)
		if nodes.size() > 0:
			_snow_controller = nodes[0]

		# Find DynamicWeatherController
		var dyn_nodes := root.find_children("*", "DynamicWeatherController", true, false)
		if dyn_nodes.size() > 0:
			_dynamic_weather_controller = dyn_nodes[0]
			print("[DebugMenu] Found DynamicWeatherController")


func _on_force_clear() -> void:
	if _dynamic_weather_controller and _dynamic_weather_controller.has_method("force_weather"):
		_dynamic_weather_controller.force_weather("Clear")
		_update_weather_status()
	elif _snow_controller:
		_snow_controller.stop_snow()


func _on_force_very_light() -> void:
	if _dynamic_weather_controller and _dynamic_weather_controller.has_method("force_weather"):
		_dynamic_weather_controller.force_weather("Very Light")
		_update_weather_status()
	elif _snow_controller:
		# Fallback: Very Light maps to Light in basic SnowController
		_snow_controller.start_snow(SnowController.SnowIntensity.LIGHT)


func _on_light_snow() -> void:
	if _dynamic_weather_controller and _dynamic_weather_controller.has_method("force_weather"):
		_dynamic_weather_controller.force_weather("Light")
		_update_weather_status()
	elif _snow_controller:
		_snow_controller.start_snow(SnowController.SnowIntensity.LIGHT)


func _on_force_medium() -> void:
	if _dynamic_weather_controller and _dynamic_weather_controller.has_method("force_weather"):
		_dynamic_weather_controller.force_weather("Medium")
		_update_weather_status()
	elif _snow_controller:
		# Fallback: Medium maps to Heavy in basic SnowController
		_snow_controller.start_snow(SnowController.SnowIntensity.HEAVY)


func _on_heavy_blizzard() -> void:
	if _dynamic_weather_controller and _dynamic_weather_controller.has_method("force_weather"):
		_dynamic_weather_controller.force_weather("Heavy")
		_update_weather_status()
	elif _snow_controller:
		_snow_controller.start_snow(SnowController.SnowIntensity.HEAVY)


func _on_stop_fade() -> void:
	if _dynamic_weather_controller and _dynamic_weather_controller.has_method("force_clear_weather"):
		_dynamic_weather_controller.force_clear_weather()
		_update_weather_status()
	elif _snow_controller:
		_snow_controller.stop_snow()


func _on_new_game() -> void:
	if _is_generating:
		return

	_is_generating = true
	_new_game_btn.disabled = true
	_progress_label.text = "Initializing..."

	# Parse seed from input (hex string to int)
	var seed_value: int = 0
	var seed_text := _seed_input.text.strip_edges()
	if not seed_text.is_empty():
		# Try to parse as hex
		if seed_text.is_valid_hex_number(true):
			seed_value = seed_text.hex_to_int()
		elif seed_text.is_valid_int():
			seed_value = seed_text.to_int()
		else:
			_progress_label.text = "Invalid seed format"
			_new_game_btn.disabled = false
			_is_generating = false
			return

	# Initialize seed in GameManager
	GameManager.initialize_seed(seed_value)
	_seed_input.text = GameManager.get_seed_string()

	# Create and run terrain generator
	var generator := TerrainGenerator.new()
	generator.name = "TerrainGenerator"
	add_child(generator)

	generator.generation_progress.connect(_on_generation_progress)
	generator.generation_completed.connect(_on_generation_completed.bind(generator))
	generator.generation_failed.connect(_on_generation_failed.bind(generator))

	# Run generation (game stays paused during this)
	generator.generate(GameManager.seed_manager)


func _on_generation_progress(stage: String, percent: float) -> void:
	if _progress_label:
		_progress_label.text = "%s (%.0f%%)" % [stage, percent * 100]


func _on_generation_completed(pois: Dictionary, generator: Node) -> void:
	GameManager.set_poi_locations(pois)

	# Get ship position from POIs
	var ship_pos: Vector3 = pois.get("ship", Vector3.ZERO)
	print("[DebugMenu] POIs received: %s" % str(pois.keys()))
	print("[DebugMenu] Ship position from POIs: %s" % ship_pos)

	var scene := get_tree().current_scene

	# Move captain to ship position
	var captain := scene.get_node_or_null("Captain")
	if captain:
		# Query actual terrain height at ship position for accurate Y
		var terrain_height := _get_terrain_height(ship_pos)
		if terrain_height > -100.0:  # Valid height found
			ship_pos.y = terrain_height + 1.0  # 1m above ground
		else:
			ship_pos.y = maxf(ship_pos.y, 5.0) + 1.0  # Fallback

		# Snap to nearest NavMesh point to ensure valid pathfinding start position
		var nav_map := NavigationServer3D.get_maps()[0] if NavigationServer3D.get_maps().size() > 0 else RID()
		if nav_map.is_valid():
			var snapped_pos := NavigationServer3D.map_get_closest_point(nav_map, ship_pos)
			var snap_dist := ship_pos.distance_to(snapped_pos)
			print("[DebugMenu] Snapping captain from %s to NavMesh point %s (dist: %.2f)" % [ship_pos, snapped_pos, snap_dist])
			if snap_dist < 100.0:  # Only snap if reasonably close (within 100m)
				ship_pos = snapped_pos
				ship_pos.y += 0.1  # Tiny offset above NavMesh surface
			else:
				print("[DebugMenu] WARNING: Snap distance too large, using original position")

		captain.global_position = ship_pos
		print("[DebugMenu] Moved captain to: %s" % captain.global_position)

		# Ensure NavigationAgent is using the correct map
		var nav_agent := captain.get_node_or_null("NavigationAgent3D") as NavigationAgent3D
		if nav_agent and nav_map.is_valid():
			nav_agent.set_navigation_map(nav_map)
			print("[DebugMenu] Captain NavigationAgent map updated")

		# Focus camera on new position
		var camera := scene.get_node_or_null("RTScamera")
		if camera and camera.has_method("focus_on"):
			camera.focus_on(captain, true)
			print("[DebugMenu] Camera focused on captain")
	else:
		push_warning("[DebugMenu] Captain node not found!")

	# Move existing containers to ship position
	# This handles containers that were spawned at the original captain position before terrain generation
	_relocate_containers_to_ship(scene, ship_pos)

	_progress_label.text = "Complete! Seed: %s" % GameManager.get_seed_string()
	_new_game_btn.disabled = false
	_is_generating = false

	generator.queue_free()


## Query terrain height at a world position
func _get_terrain_height(world_pos: Vector3) -> float:
	# Find Terrain3D in scene
	var scene := get_tree().current_scene
	if not scene:
		return -999.0

	# Search for Terrain3D node
	var terrain_nodes := get_tree().get_nodes_in_group("terrain")
	for node in terrain_nodes:
		if node.get_class() == "Terrain3D" or "Terrain3D" in node.name:
			if "data" in node and node.data and node.data.has_method("get_height"):
				var height: float = node.data.get_height(world_pos)
				print("[DebugMenu] Terrain height at %s: %.2f" % [world_pos, height])
				return height

	# Fallback: search by name
	var terrain := scene.find_child("*Terrain3D*", true, false)
	if terrain and "data" in terrain and terrain.data:
		if terrain.data.has_method("get_height"):
			return terrain.data.get_height(world_pos)

	push_warning("[DebugMenu] Could not find Terrain3D to query height")
	return -999.0


func _on_generation_failed(reason: String, generator: Node) -> void:
	_progress_label.text = "FAILED: %s" % reason
	_new_game_btn.disabled = false
	_is_generating = false

	generator.queue_free()


## Relocate all containers to the ship position after terrain generation
## Containers are spawned at the captain's initial position before terrain is generated,
## so we need to move them to the actual ship inlet position afterwards.
func _relocate_containers_to_ship(scene: Node, ship_pos: Vector3) -> void:
	# Find ObjectSpawner which manages containers
	var object_spawner := scene.get_node_or_null("ObjectSpawner")
	if not object_spawner:
		print("[DebugMenu] No ObjectSpawner found - skipping container relocation")
		return

	# Get all container children (barrels and crates)
	var containers: Array[Node] = []
	for child in object_spawner.get_children():
		if child.has_method("open"):  # StorageContainer has open()
			containers.append(child)

	if containers.is_empty():
		print("[DebugMenu] No containers found to relocate")
		return

	print("[DebugMenu] Relocating %d containers to ship position..." % containers.size())

	# Calculate spawn radius (same as used in object_spawner)
	var spawn_radius := 30.0  # Default from main_controller.gd
	if "spawn_radius" in object_spawner:
		spawn_radius = object_spawner.spawn_radius

	var rng := RandomNumberGenerator.new()
	rng.seed = GameManager.seed_manager.current_seed ^ 0xC047A1E5

	for container in containers:
		# Random offset within spawn radius
		var angle := rng.randf() * TAU
		var distance := rng.randf_range(5.0, spawn_radius)
		var offset := Vector3(cos(angle) * distance, 0.0, sin(angle) * distance)

		var new_pos := ship_pos + offset
		# Get terrain height at new position
		var terrain_height := _get_terrain_height(new_pos)
		if terrain_height > -100.0:
			new_pos.y = terrain_height + 0.1  # Slightly above ground
		else:
			new_pos.y = ship_pos.y

		container.global_position = new_pos
		print("[DebugMenu] Relocated %s to %s" % [container.name, new_pos])

	print("[DebugMenu] Container relocation complete")


# --- Temperature Controls ---

func _update_temp_label() -> void:
	if not _temp_label:
		return
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager:
		var temp: float = time_manager.get_current_temperature()
		var override_str := " (OVERRIDE)" if time_manager.is_temperature_override_enabled() else ""
		_temp_label.text = "Current: %.0f°C%s" % [temp, override_str]
	else:
		_temp_label.text = "Current: --°C"


func _on_temp_override_toggled(enabled: bool) -> void:
	_temp_slider.editable = enabled
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager:
		if enabled:
			time_manager.set_temperature_override(true, _temp_slider.value)
		else:
			time_manager.set_temperature_override(false)
		_update_temp_label()


func _on_temp_slider_changed(value: float) -> void:
	_temp_value_label.text = "%.0f°C" % value
	if _temp_override_check and _temp_override_check.button_pressed:
		var time_manager := get_node_or_null("/root/TimeManager")
		if time_manager:
			time_manager.set_temperature_override(true, value)
			_update_temp_label()


func _sync_temp_override_state() -> void:
	## Sync UI controls with current TimeManager override state.
	if not _temp_override_check or not _temp_slider or not _temp_value_label:
		return
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager:
		var is_override: bool = time_manager.is_temperature_override_enabled()
		_temp_override_check.set_pressed_no_signal(is_override)
		_temp_slider.editable = is_override
		if is_override:
			var override_val: float = time_manager.get_temperature_override_value()
			_temp_slider.set_value_no_signal(override_val)
			_temp_value_label.text = "%.0f°C" % override_val


# --- Weather Status ---

func _update_weather_status() -> void:
	## Update weather status label with current weather info.
	if not _weather_status_label:
		return

	# Try to find DynamicWeatherController if not cached
	if not _dynamic_weather_controller:
		var root := get_tree().current_scene
		if root:
			var dyn_nodes := root.find_children("*", "DynamicWeatherController", true, false)
			if dyn_nodes.size() > 0:
				_dynamic_weather_controller = dyn_nodes[0]

	if _dynamic_weather_controller and _dynamic_weather_controller.has_method("get_weather_status"):
		var status: Dictionary = _dynamic_weather_controller.get_weather_status()
		var event_name: String = status.get("event_name", "Unknown")
		var wind_speed: float = status.get("wind_speed", 0.0)
		var wind_dir: String = status.get("wind_direction", "?")
		var fog_density: float = status.get("fog_density", 0.0)
		var time_remaining: float = status.get("time_remaining", 0.0)

		_weather_status_label.text = "Event: %s\nWind: %.1f m/s from %s\nFog: %.3f\nRemaining: %.0fs" % [
			event_name,
			wind_speed,
			wind_dir,
			fog_density,
			time_remaining
		]
	elif _snow_controller:
		# Fallback to SnowController info
		var intensity: String = "Unknown"
		match _snow_controller.current_intensity:
			0: intensity = "None"
			1: intensity = "Light"
			2: intensity = "Heavy"

		_weather_status_label.text = "Event: %s (SnowController)" % intensity
	else:
		_weather_status_label.text = "Weather system not found"


# --- Camera Controls ---

func _on_camera_constraint_toggled(enabled: bool) -> void:
	## Toggle free camera mode: no constraint, extended zoom, faster movement.
	var camera := get_viewport().get_camera_3d()
	if not camera:
		return

	if enabled:
		# Store original values
		if "max_distance_from_units" in camera:
			_camera_original_max_distance = camera.max_distance_from_units
		if "camera_zoom_max" in camera:
			_camera_original_zoom_max = camera.camera_zoom_max
		if "camera_speed" in camera:
			_camera_original_speed = camera.camera_speed
		if "camera_zoom_speed" in camera:
			_camera_original_zoom_speed = camera.camera_zoom_speed

		# Apply free camera settings
		if "max_distance_from_units" in camera:
			camera.max_distance_from_units = 0.0
		if "camera_zoom_max" in camera:
			camera.camera_zoom_max = 500.0  # Much further zoom out
		if "camera_speed" in camera:
			camera.camera_speed = 160.0  # 8x faster WASD
		if "camera_zoom_speed" in camera:
			camera.camera_zoom_speed = 200.0  # 10x faster scroll
	else:
		# Restore original values
		if "max_distance_from_units" in camera:
			camera.max_distance_from_units = _camera_original_max_distance
		if "camera_zoom_max" in camera:
			camera.camera_zoom_max = _camera_original_zoom_max
		if "camera_speed" in camera:
			camera.camera_speed = _camera_original_speed
		if "camera_zoom_speed" in camera:
			camera.camera_zoom_speed = _camera_original_zoom_speed


func _sync_camera_constraint_state() -> void:
	## Sync checkbox with current camera state.
	if not _camera_constraint_check:
		return
	var camera := get_viewport().get_camera_3d()
	if camera and "max_distance_from_units" in camera:
		var is_free: bool = camera.max_distance_from_units <= 0.0
		_camera_constraint_check.set_pressed_no_signal(is_free)


# --- Survivor Stats Controls ---

func _add_stat_slider(parent: Control, stat_name: String, display_name: String) -> void:
	## Add a slider + apply button row for a survivor stat.
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 5)
	parent.add_child(hbox)

	var label := Label.new()
	label.text = display_name + ":"
	label.custom_minimum_size.x = 60
	hbox.add_child(label)

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 100.0
	slider.step = 1.0
	slider.value = 100.0
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(_on_stat_slider_changed.bind(stat_name))
	hbox.add_child(slider)
	_stat_sliders[stat_name] = slider

	var value_label := Label.new()
	value_label.text = "100"
	value_label.custom_minimum_size.x = 30
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hbox.add_child(value_label)
	_stat_value_labels[stat_name] = value_label

	var apply_btn := Button.new()
	apply_btn.text = "Apply"
	apply_btn.custom_minimum_size.x = 50
	apply_btn.pressed.connect(_apply_stat_to_all_units.bind(stat_name))
	hbox.add_child(apply_btn)


func _on_stat_slider_changed(value: float, stat_name: String) -> void:
	if stat_name in _stat_value_labels:
		_stat_value_labels[stat_name].text = "%.0f" % value


func _apply_stat_to_all_units(stat_name: String) -> void:
	## Apply the slider value to all survivors in the game.
	if stat_name not in _stat_sliders:
		return

	var value: float = _stat_sliders[stat_name].value
	var survivors := get_tree().get_nodes_in_group("survivors")
	var count: int = 0

	for survivor in survivors:
		# Check for stats property (could be SurvivorStats resource or direct properties)
		if "stats" in survivor and survivor.stats:
			var stats: SurvivorStats = survivor.stats
			match stat_name:
				"hunger":
					stats.hunger = value
				"warmth":
					stats.warmth = value
				"health":
					stats.health = value
				"morale":
					stats.morale = value
				"energy":
					stats.energy = value
			# Trigger UI update
			if survivor.has_signal("stats_changed"):
				survivor.stats_changed.emit()
			count += 1

	print("[DebugMenu] Set %s to %.0f on %d survivors" % [stat_name, value, count])
