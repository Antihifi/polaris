extends Node

var _panel: Control = null
var _is_open: bool = false
var _snow_controller: SnowController = null


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
	_panel.custom_minimum_size = Vector2(350, 300)
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
