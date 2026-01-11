extends Node

const TerrainGenerator := preload("res://src/terrain/terrain_generator.gd")

var _panel: Control = null
var _is_open: bool = false
var _snow_controller: SnowController = null
var _seed_input: LineEdit = null
var _progress_label: Label = null
var _new_game_btn: Button = null
var _is_generating: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


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
	canvas.add_child(center)

	_panel = PanelContainer.new()
	_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	_panel.custom_minimum_size = Vector2(350, 500)
	center.add_child(_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

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

	_add_button(vbox, "Light Snow", _on_light_snow)
	_add_button(vbox, "Heavy Blizzard", _on_heavy_blizzard)
	_add_button(vbox, "Stop Snow (Fade)", _on_stop_fade)
	_add_button(vbox, "Stop Snow (Immediate)", _on_stop_immediate)

	vbox.add_child(HSeparator.new())

	_add_button(vbox, "RESUME", _close_menu)

	var hint := Label.new()
	hint.text = "Press ESC to close"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	vbox.add_child(hint)

	_find_snow_controller()


func _add_button(parent: Control, text: String, callback: Callable) -> void:
	var btn := Button.new()
	btn.text = text
	btn.pressed.connect(callback)
	parent.add_child(btn)


func _find_snow_controller() -> void:
	await get_tree().process_frame
	var root := get_tree().current_scene
	if root:
		var nodes := root.find_children("*", "SnowController", true, false)
		if nodes.size() > 0:
			_snow_controller = nodes[0]


func _on_light_snow() -> void:
	if _snow_controller:
		_snow_controller.start_snow(SnowController.SnowIntensity.LIGHT)


func _on_heavy_blizzard() -> void:
	if _snow_controller:
		_snow_controller.start_snow(SnowController.SnowIntensity.HEAVY)


func _on_stop_fade() -> void:
	if _snow_controller:
		_snow_controller.stop_snow()


func _on_stop_immediate() -> void:
	if _snow_controller:
		_snow_controller.set_snow_immediate(SnowController.SnowIntensity.NONE)


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

	# Move captain to ship position
	var captain := get_tree().current_scene.get_node_or_null("Captain")
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
		var camera := get_tree().current_scene.get_node_or_null("RTScamera")
		if camera and camera.has_method("focus_on"):
			camera.focus_on(captain, true)
			print("[DebugMenu] Camera focused on captain")
	else:
		push_warning("[DebugMenu] Captain node not found!")

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
