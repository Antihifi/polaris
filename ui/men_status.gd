class_name MenStatus extends Control
## UI panel showing crew status. Click "Men" to expand full crew list.
## Shows name and current action for each unit with stat tooltips.

signal unit_clicked(unit: Node)

@onready var men_button: Button = $MenButton
@onready var crew_panel: PanelContainer = $CrewPanel
@onready var scroll_container: ScrollContainer = $CrewPanel/ScrollContainer
@onready var crew_list: VBoxContainer = $CrewPanel/ScrollContainer/CrewList

var _is_expanded: bool = false
var _unit_rows: Dictionary = {}  # unit -> HBoxContainer
var _row_backgrounds: Dictionary = {}  # unit -> ColorRect (for selection highlight)
var _update_timer: float = 0.0
const UPDATE_INTERVAL: float = 0.5  # Update twice per second, not every frame
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 1.0, 0.15)  # Semi-transparent white highlight


func _ready() -> void:
	men_button.pressed.connect(_on_men_button_pressed)
	crew_panel.visible = false

	# Initial population
	call_deferred("_populate_crew_list")
	# Connect to unit selection signals
	call_deferred("_connect_to_unit_selections")


func _process(delta: float) -> void:
	# Throttled updates when expanded (0.5s interval, not every frame)
	if _is_expanded:
		_update_timer += delta
		if _update_timer >= UPDATE_INTERVAL:
			_update_timer = 0.0
			_update_actions()


func _input(event: InputEvent) -> void:
	# Close panel on ESC
	if _is_expanded and event.is_action_pressed("ui_cancel"):
		_collapse()
		get_viewport().set_input_as_handled()


func _on_men_button_pressed() -> void:
	if _is_expanded:
		_collapse()
	else:
		_expand()


func _expand() -> void:
	_is_expanded = true
	crew_panel.visible = true
	_populate_crew_list()


func _collapse() -> void:
	_is_expanded = false
	crew_panel.visible = false


func _populate_crew_list() -> void:
	## Rebuild the crew list from current units.
	## Only shows discovered units (errant groups hidden until found).
	# Clear existing
	for child in crew_list.get_children():
		child.queue_free()
	_unit_rows.clear()
	_row_backgrounds.clear()

	# Get all survivors/selectable units
	var units: Array[Node] = []
	units.append_array(get_tree().get_nodes_in_group("survivors"))
	units.append_array(get_tree().get_nodes_in_group("selectable_units"))

	# Remove duplicates and filter to discovered units only
	var unique_units: Array[Node] = []
	for unit in units:
		if unit not in unique_units and is_instance_valid(unit):
			# Only show discovered units in roster
			var is_discovered := true
			if "is_discovered" in unit:
				is_discovered = unit.is_discovered
			if is_discovered:
				unique_units.append(unit)

	# Sort by name if available
	unique_units.sort_custom(func(a, b):
		var name_a: String = a.unit_name if "unit_name" in a else a.name
		var name_b: String = b.unit_name if "unit_name" in b else b.name
		return name_a < name_b
	)

	# Create row for each unit
	for unit in unique_units:
		_add_unit_row(unit)

	# Update the "Units" button to show count
	men_button.text = "Units (%d)" % unique_units.size()


func _add_unit_row(unit: Node) -> void:
	## Add a row for a unit showing name and action.
	## Uses a container with background for selection highlighting.

	# Create a container to hold background and row content
	var container := Control.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.custom_minimum_size.y = 20

	# Create background ColorRect for selection highlight (starts hidden)
	var bg := ColorRect.new()
	bg.color = HIGHLIGHT_COLOR
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.visible = false
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(bg)
	_row_backgrounds[unit] = bg

	# Create the row content
	var row := HBoxContainer.new()
	row.set_anchors_preset(Control.PRESET_FULL_RECT)
	row.add_theme_constant_override("separation", 10)
	row.mouse_filter = Control.MOUSE_FILTER_STOP

	# Determine rank color (Captain = navy blue, Officer = olive green, Men = default)
	var name_color := Color(0.9, 0.9, 0.9)  # Default for Men
	if unit is ClickableUnit:
		if unit.rank == ClickableUnit.UnitRank.CAPTAIN:
			name_color = Color(0.5, 0.6, 0.85)  # Desaturated navy blue
		elif unit.rank == ClickableUnit.UnitRank.OFFICER:
			name_color = Color(0.6, 0.7, 0.45)  # Desaturated olive green

	# Name label
	var name_label := Label.new()
	var unit_name: String = unit.unit_name if "unit_name" in unit else unit.name
	name_label.text = unit_name
	name_label.custom_minimum_size.x = 120
	name_label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	name_label.add_theme_font_size_override("font_size", 11)
	name_label.add_theme_color_override("font_color", name_color)
	row.add_child(name_label)

	# Action label
	var action_label := Label.new()
	action_label.text = _get_unit_action(unit)
	action_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	action_label.add_theme_font_size_override("font_size", 11)
	action_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	action_label.name = "ActionLabel"
	row.add_child(action_label)

	container.add_child(row)

	# Store reference for updates
	_unit_rows[unit] = row

	# Set tooltip with stats
	row.tooltip_text = _build_stats_tooltip(unit)

	# Make row clickable
	row.gui_input.connect(_on_row_input.bind(unit))

	crew_list.add_child(container)

	# Check if unit is already selected and highlight if so
	if unit is ClickableUnit and unit.is_selected:
		bg.visible = true


func _get_unit_action(unit: Node) -> String:
	## Get the current action string for a unit.
	if unit.has_method("get_current_action"):
		return unit.get_current_action()

	# Try AI controller
	var ai_controller: Node = unit.get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("get_current_action"):
		return ai_controller.get_current_action()

	return "Idle"


func _build_stats_tooltip(unit: Node) -> String:
	## Build a tooltip showing unit's survival stats.
	if not "stats" in unit or not unit.stats:
		return ""

	var stats = unit.stats
	var lines: Array[String] = []

	var unit_name: String = unit.unit_name if "unit_name" in unit else unit.name
	lines.append(unit_name.to_upper())
	lines.append("")

	if "health" in stats:
		lines.append("Health: %.0f%%" % stats.health)
	if "energy" in stats:
		lines.append("Energy: %.0f%%" % stats.energy)
	if "hunger" in stats:
		lines.append("Hunger: %.0f%%" % stats.hunger)
	if "warmth" in stats:
		lines.append("Warmth: %.0f%%" % stats.warmth)
	if "morale" in stats:
		lines.append("Morale: %.0f%%" % stats.morale)

	return "\n".join(lines)


func _update_actions() -> void:
	## Update action labels and tooltips for all units.
	for unit in _unit_rows:
		if not is_instance_valid(unit):
			continue
		var row: HBoxContainer = _unit_rows[unit]
		var action_label: Label = row.get_node_or_null("ActionLabel")
		if action_label:
			action_label.text = _get_unit_action(unit)
		# Update tooltip with current stats
		row.tooltip_text = _build_stats_tooltip(unit)


func _on_row_input(event: InputEvent, unit: Node) -> void:
	## Handle clicks on unit rows.
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			unit_clicked.emit(unit)
			# Focus camera on unit
			var camera := get_viewport().get_camera_3d()
			if camera and camera.has_method("focus_on"):
				camera.focus_on(unit)
			# Select unit via input handler
			var input_handler := get_tree().current_scene.get_node_or_null("RTSInputHandler")
			if input_handler and input_handler.has_method("_deselect_all"):
				input_handler._deselect_all()
				if input_handler.has_method("_add_to_selection"):
					input_handler._add_to_selection(unit)


func refresh() -> void:
	## Public method to refresh unit list and count.
	## Call this when new units are spawned or discovered.
	_populate_crew_list()
	_connect_to_unit_selections()


func _connect_to_unit_selections() -> void:
	## Connect to unit selected/deselected signals for highlighting.
	var units := get_tree().get_nodes_in_group("selectable_units")
	for unit in units:
		if unit is ClickableUnit:
			if not unit.selected.is_connected(_on_unit_selected):
				unit.selected.connect(_on_unit_selected.bind(unit))
			if not unit.deselected.is_connected(_on_unit_deselected):
				unit.deselected.connect(_on_unit_deselected.bind(unit))


func _on_unit_selected(unit: Node) -> void:
	## Highlight the unit's row when selected.
	_set_row_highlighted(unit, true)


func _on_unit_deselected(unit: Node) -> void:
	## Remove highlight from unit's row when deselected.
	_set_row_highlighted(unit, false)


func _set_row_highlighted(unit: Node, highlighted: bool) -> void:
	## Set the highlight state for a unit's row.
	if unit not in _row_backgrounds:
		return
	var bg: ColorRect = _row_backgrounds[unit]
	if is_instance_valid(bg):
		bg.visible = highlighted
