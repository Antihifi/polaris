extends CanvasLayer
## Main game HUD manager.
## Contains time display (always visible) and character stats panel (on double-click).
## Single-click selects, double-click opens stats panel.
## Add this as a CanvasLayer to your main scene.

@onready var time_hud: Control = $TimeHUD
@onready var character_stats: Control = $CharacterStats

var _selected_unit: ClickableUnit = null
var _input_handler: Node = null


func _ready() -> void:
	# Connect to input handler for double-click events
	call_deferred("_connect_to_input_handler")
	# Connect to units for deselection
	call_deferred("_connect_to_units")


func _connect_to_input_handler() -> void:
	## Connect to the RTS input handler for double-click events.
	_input_handler = get_node_or_null("../RTSInputHandler")
	if _input_handler and _input_handler.has_signal("unit_double_clicked"):
		_input_handler.unit_double_clicked.connect(_on_unit_double_clicked)
		print("[GameHUD] Connected to RTSInputHandler for double-click events")
	else:
		print("[GameHUD] WARNING: Could not find RTSInputHandler")


func _connect_to_units() -> void:
	## Connect to all selectable units for deselection signals.
	var units := get_tree().get_nodes_in_group("selectable_units")
	for unit in units:
		if unit is ClickableUnit:
			if not unit.deselected.is_connected(_on_unit_deselected):
				unit.deselected.connect(_on_unit_deselected.bind(unit))
	print("[GameHUD] Connected to ", units.size(), " selectable units")


func _on_unit_double_clicked(unit: ClickableUnit) -> void:
	## Show stats panel when unit is double-clicked.
	_selected_unit = unit
	if character_stats and character_stats.has_method("show_for_unit"):
		character_stats.show_for_unit(unit)


func _on_unit_deselected(unit: ClickableUnit) -> void:
	## Hide stats panel if this was the selected unit.
	if unit == _selected_unit:
		_selected_unit = null
		if character_stats and character_stats.has_method("hide_panel"):
			character_stats.hide_panel()


func _input(event: InputEvent) -> void:
	# Note: ESC/ui_cancel is handled by DebugMenu
	# Space to pause/unpause
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_SPACE:
				_toggle_pause()
			KEY_1:
				_set_time_scale(1.0)
			KEY_2:
				_set_time_scale(2.0)
			KEY_3:
				_set_time_scale(4.0)


func _toggle_pause() -> void:
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and time_manager.has_method("toggle_pause"):
		time_manager.toggle_pause()


func _set_time_scale(scale: float) -> void:
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and time_manager.has_method("set_time_scale"):
		time_manager.set_time_scale(scale)
