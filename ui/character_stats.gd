extends Control
## UI panel that displays a selected character's name, survival stats, and skills.
## Three panels: Name (top), Stats (middle), Skills (bottom).
## Positions itself above the selected character in screen space.

signal closed

# Panel references
@onready var name_panel: Panel = $Name
@onready var stats_panel: Panel = $Stats
@onready var skills_panel: Panel = $Stats/Skills

# Name label
var name_label: Label

# Stats progress bars
var health_bar: ProgressBar
var energy_bar: ProgressBar
var hunger_bar: ProgressBar
var warmth_bar: ProgressBar
var morale_bar: ProgressBar

# Skills progress bars
var hunting_bar: ProgressBar
var construction_bar: ProgressBar
var medical_bar: ProgressBar
var navigation_bar: ProgressBar
var survival_bar: ProgressBar

var _current_unit: ClickableUnit = null
var _camera: Camera3D = null

## Height offset above character's position (in world units)
@export var world_height_offset: float = 4.0
## Screen space offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)


func _ready() -> void:
	# Get name label reference
	name_label = $Name/MarginContainer/CenterContainer/Label

	# Get references to stats progress bars
	var stats_vbox: VBoxContainer = $Stats/MarginContainer/CenterContainer/VBoxContainer
	health_bar = stats_vbox.get_node("Health/ProgressBar")
	energy_bar = stats_vbox.get_node("Energy/ProgressBar")
	hunger_bar = stats_vbox.get_node("Hunger/ProgressBar")
	warmth_bar = stats_vbox.get_node("Body Temperature/ProgressBar")
	morale_bar = stats_vbox.get_node("Morale/ProgressBar")

	# Get references to skills progress bars
	var skills_vbox: VBoxContainer = $"Stats/Skills/MarginContainer/CenterContainer/VBoxContainer"
	hunting_bar = skills_vbox.get_node("Health/ProgressBar")
	construction_bar = skills_vbox.get_node("Energy/ProgressBar")
	medical_bar = skills_vbox.get_node("Hunger/ProgressBar")
	navigation_bar = skills_vbox.get_node("Body Temperature/ProgressBar")
	survival_bar = skills_vbox.get_node("Morale/ProgressBar")

	# Override skill bars to show value instead of percentage
	_configure_skill_bar(hunting_bar)
	_configure_skill_bar(construction_bar)
	_configure_skill_bar(medical_bar)
	_configure_skill_bar(navigation_bar)
	_configure_skill_bar(survival_bar)

	# Start hidden
	visible = false


func _configure_skill_bar(bar: ProgressBar) -> void:
	## Configure skill progress bars to show raw value instead of percentage.
	bar.show_percentage = false


func _process(_delta: float) -> void:
	# Update panel position to follow character
	if visible and _current_unit and _camera:
		_update_panel_position()


func _input(event: InputEvent) -> void:
	# Close panel on Escape
	if visible:
		if event.is_action_pressed("ui_cancel"):
			hide_panel()
			get_viewport().set_input_as_handled()


func show_for_unit(unit: ClickableUnit, camera: Camera3D = null) -> void:
	## Display stats for the given unit, positioned above them.
	if not unit or not unit.stats:
		return

	# Disconnect from previous unit
	if _current_unit and _current_unit.stats_changed.is_connected(_on_stats_changed):
		_current_unit.stats_changed.disconnect(_on_stats_changed)

	_current_unit = unit
	_current_unit.stats_changed.connect(_on_stats_changed)

	# Get camera reference
	if camera:
		_camera = camera
	else:
		_camera = get_viewport().get_camera_3d()

	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the stats panel.
	if _current_unit and _current_unit.stats_changed.is_connected(_on_stats_changed):
		_current_unit.stats_changed.disconnect(_on_stats_changed)
	_current_unit = null
	visible = false
	closed.emit()


func _on_stats_changed() -> void:
	## Called when the current unit's stats change.
	_update_display()


func _update_panel_position() -> void:
	## Position all panels above the character in screen space.
	## Uses the stats panel as the center reference point.
	if not _current_unit or not _camera:
		return

	# Get world position above character's head
	var world_pos: Vector3 = _current_unit.global_position + Vector3(0, world_height_offset, 0)

	# Check if position is in front of camera
	if not _camera.is_position_in_frustum(world_pos):
		visible = false
		return

	# Convert to screen position
	var screen_pos: Vector2 = _camera.unproject_position(world_pos)

	# Position the Control node so stats panel centers on the target position
	# The panels are pre-arranged in the scene relative to this Control
	var panel_size: Vector2 = stats_panel.size
	position = screen_pos - panel_size / 2.0 + screen_offset

	# Clamp to screen bounds (accounting for all panels)
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var total_height: float = name_panel.size.y + stats_panel.size.y + skills_panel.size.y + 4.0
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, total_height / 2.0, viewport_size.y - total_height / 2.0)


func _update_display() -> void:
	## Update name, stats, and skills displays.
	if not _current_unit:
		return

	# Update name
	name_label.text = _current_unit.unit_name

	# Update stats progress bars
	if _current_unit.stats:
		var stats: SurvivorStats = _current_unit.stats

		health_bar.value = stats.health
		energy_bar.value = stats.energy
		hunger_bar.value = stats.hunger
		warmth_bar.value = stats.warmth
		morale_bar.value = stats.morale

		# Update skills progress bars
		hunting_bar.value = stats.hunting_skill
		construction_bar.value = stats.construction_skill
		medical_bar.value = stats.medicine_skill
		navigation_bar.value = stats.navigation_skill
		survival_bar.value = stats.survival_skill
