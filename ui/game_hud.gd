extends CanvasLayer
## Main game HUD manager.
## Contains time display (always visible) and multi-panel stats system.
## Single-click selects, double-click opens stats panel.
## Multiple stats panels can be open simultaneously.
## Add this as a CanvasLayer to your main scene.

@onready var time_hud: Control = $TimeHUD
@onready var character_stats: Control = $CharacterStats
@onready var men_status: MenStatus = $MenStatus

var _selected_unit: ClickableUnit = null
var _input_handler: Node = null
var _panel_manager: UnitPanelManager = null


func _ready() -> void:
	# Create panel manager for multi-panel support
	_panel_manager = UnitPanelManager.new()
	_panel_manager.name = "UnitPanelManager"
	add_child(_panel_manager)
	_panel_manager.setup(self)

	# Hide the static CharacterStats node (panels are now spawned dynamically)
	if character_stats:
		character_stats.visible = false

	# Connect to input handler for double-click events
	call_deferred("_connect_to_input_handler")
	# Connect to units for deselection
	call_deferred("_connect_to_units")
	# Connect to character spawner for unit count updates
	call_deferred("_connect_to_spawner")


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


func _connect_to_spawner() -> void:
	## Connect to character spawner to refresh unit list when new units spawn.
	var spawner := get_node_or_null("../CharacterSpawner")
	if spawner and spawner.has_signal("survivors_spawned"):
		spawner.survivors_spawned.connect(_on_survivors_spawned)
		print("[GameHUD] Connected to CharacterSpawner for unit count updates")


func _on_survivors_spawned(_count: int) -> void:
	## Refresh unit list when new survivors are spawned.
	if men_status:
		men_status.refresh()
	# Also reconnect to new units for deselection signals
	_connect_to_units()


func _on_unit_double_clicked(unit: ClickableUnit) -> void:
	## Open or focus stats panel for the double-clicked unit.
	_selected_unit = unit
	_panel_manager.open_stats_for_unit(unit)


func _on_unit_deselected(unit: ClickableUnit) -> void:
	## Track deselection but do NOT close panels.
	## With multi-panel support, panels persist until explicitly closed.
	if unit == _selected_unit:
		_selected_unit = null


func _get_selected_unit() -> ClickableUnit:
	## Get the currently selected unit for C key toggle.
	if _selected_unit and is_instance_valid(_selected_unit):
		return _selected_unit
	# Fallback: query input handler
	if _input_handler and _input_handler.has_method("has_selection") and _input_handler.has_selection():
		var selected: Array = _input_handler.get_selected_units()
		if not selected.is_empty() and selected[0] is ClickableUnit:
			return selected[0] as ClickableUnit
	# Fallback: SelectionManager
	var selection_mgr := get_node_or_null("/root/SelectionManager")
	if selection_mgr and selection_mgr.has_method("has_selection") and selection_mgr.has_selection():
		var unit: Node = selection_mgr.get_first_selected()
		if unit is ClickableUnit:
			return unit as ClickableUnit
	return null


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return

	var key := event as InputEventKey
	match key.keycode:
		KEY_SPACE:
			_toggle_pause()
		KEY_1:
			_set_time_scale(1.0)
		KEY_2:
			_set_time_scale(2.0)
		KEY_3:
			_set_time_scale(4.0)
		KEY_C:
			# Toggle stats panel for the currently selected unit
			var unit: ClickableUnit = _get_selected_unit()
			if unit:
				_panel_manager.toggle_stats_for_unit(unit)
		KEY_ESCAPE:
			# Close the most recently focused panel
			if _panel_manager.has_any_panel_open():
				_panel_manager.close_topmost()
				get_viewport().set_input_as_handled()


func _toggle_pause() -> void:
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and time_manager.has_method("toggle_pause"):
		time_manager.toggle_pause()


func _set_time_scale(scale: float) -> void:
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and time_manager.has_method("set_time_scale"):
		time_manager.set_time_scale(scale)
