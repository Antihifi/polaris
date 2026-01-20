extends Control
## UI panel that displays a selected character's name, survival stats, and skills.
## Panels: Name (always shown), Stats (always shown), Skills (toggle), Effects (toggle).
## Positions itself above the selected character in screen space.

signal closed

# Panel references
@onready var name_panel: Panel = $Name
@onready var stats_panel: Panel = $Stats
@onready var skills_panel: Panel = $Stats/Skills
@onready var effects_panel: Panel = $Stats/Effects

# Toggle buttons
@onready var skills_button: Button = $"Stats/MarginContainer/CenterContainer/VBoxContainer/Button"
@onready var effects_button: Button = $"Stats/Skills/MarginContainer/CenterContainer/VBoxContainer/ACTIVE EFFECTS"

# Special trait display
@onready var special_trait_container: HBoxContainer = $"Stats/Skills/MarginContainer/CenterContainer/VBoxContainer/SpecialTrait"
@onready var special_trait_label: Label = $"Stats/Skills/MarginContainer/CenterContainer/VBoxContainer/SpecialTrait/Label"

# Effects container and labels (vertical log format)
@onready var effects_container: VBoxContainer = $"Stats/Effects/MarginContainer/VBoxContainer"
var _effect_labels: Array[Label] = []

# Name label
var name_label: Label

# Action label
var action_label: Label

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
var strength_bar: ProgressBar

var _current_unit: ClickableUnit = null
var _camera: Camera3D = null
var _time_manager: Node = null

# Trend indicator ColorRects (1px lines at end of progress bars)
var _health_trend: ColorRect
var _energy_trend: ColorRect
var _hunger_trend: ColorRect
var _warmth_trend: ColorRect
var _morale_trend: ColorRect

## Height offset above character's position (in world units)
@export var world_height_offset: float = 4.0
## Screen space offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)

# Double-click tracking for name panel close
var _last_name_click_time: int = 0
const DOUBLE_CLICK_THRESHOLD_MS: int = 400


func _ready() -> void:
	# Get TimeManager reference for real-time daylight checks
	_time_manager = get_node_or_null("/root/TimeManager")

	# Get name label reference
	name_label = $Name/MarginContainer/CenterContainer/Label

	# Get action label reference
	action_label = $Action/MarginContainer/CenterContainer/Label

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
	strength_bar = skills_vbox.get_node("Strength/ProgressBar")

	# Override skill bars to show value instead of percentage
	_configure_skill_bar(hunting_bar)
	_configure_skill_bar(construction_bar)
	_configure_skill_bar(medical_bar)
	_configure_skill_bar(navigation_bar)
	_configure_skill_bar(survival_bar)
	_configure_skill_bar(strength_bar)

	# Create trend indicators for stat bars
	_health_trend = _create_trend_indicator(health_bar)
	_energy_trend = _create_trend_indicator(energy_bar)
	_hunger_trend = _create_trend_indicator(hunger_bar)
	_warmth_trend = _create_trend_indicator(warmth_bar)
	_morale_trend = _create_trend_indicator(morale_bar)

	# Connect toggle buttons
	skills_button.toggled.connect(_on_skills_toggled)
	effects_button.toggled.connect(_on_effects_toggled)

	# Connect name panel double-click to close
	name_panel.gui_input.connect(_on_name_panel_input)

	# Collect effect labels from container (Label, Label2, Label3, etc.)
	for child in effects_container.get_children():
		if child is Label:
			_effect_labels.append(child)

	# Start with Skills and Effects panels hidden
	skills_panel.visible = false
	effects_panel.visible = false
	skills_button.button_pressed = false
	effects_button.button_pressed = false

	# Start hidden
	visible = false


func _configure_skill_bar(bar: ProgressBar) -> void:
	## Configure skill progress bars to show raw value instead of percentage.
	bar.show_percentage = false


func _is_in_daylight() -> bool:
	## Check if unit is in daylight using TimeManager for real-time updates.
	## Returns false if in shelter (no sunlight indoors) or if night time.
	if _current_unit and _current_unit.is_in_shelter():
		return false
	if _time_manager and _time_manager.has_method("is_daytime"):
		return _time_manager.is_daytime()
	return true  # Default to daytime if TimeManager unavailable


func _create_trend_indicator(bar: ProgressBar) -> ColorRect:
	## Create a 1px wide ColorRect as trend indicator for a progress bar.
	var indicator := ColorRect.new()
	indicator.custom_minimum_size = Vector2(1, 0)
	indicator.size_flags_vertical = Control.SIZE_FILL
	indicator.visible = false
	bar.add_child(indicator)
	return indicator


func _update_trend_indicator(indicator: ColorRect, bar: ProgressBar, trend: float) -> void:
	## Update trend indicator position and color based on predicted trend.
	## trend > 0 = increasing (green), trend < 0 = decreasing (red), trend == 0 = hidden
	if absf(trend) < 0.001:
		indicator.visible = false
		return

	indicator.visible = true

	# Set color based on direction
	if trend > 0:
		indicator.color = Color.GREEN
	else:
		indicator.color = Color.RED

	# Position at the end of the filled portion of the progress bar
	var bar_width: float = bar.size.x
	var fill_ratio: float = bar.value / bar.max_value
	var fill_width: float = bar_width * fill_ratio

	indicator.position = Vector2(fill_width - 1, 0)
	indicator.size = Vector2(1, bar.size.y)


func _get_hunger_trend() -> float:
	## Predict hunger trend based on current conditions.
	## Hunger always decays, but rate varies.
	if not _current_unit or not _current_unit.stats:
		return 0.0
	# Hunger always decreases (negative trend)
	return -1.0


func _get_warmth_trend() -> float:
	## Predict warmth trend based on fire, shelter, and environment.
	if not _current_unit:
		return 0.0

	var trend: float = 0.0

	# Positive effects
	if _current_unit.is_near_fire():
		trend += 5.0
	if _current_unit.is_in_shelter():
		var shelter_type: int = _current_unit.get_shelter_type()
		match shelter_type:
			0: trend += 2.0  # TENT
			1: trend += 3.0  # IMPROVED_SHELTER
			2: trend += 1.0  # CAVE
	if _current_unit.is_in_sunlight():
		trend += 1.0

	# Cold effect (ambient temperature is usually negative in arctic)
	# Assume cold is draining warmth unless near fire/shelter
	trend -= 3.0  # Base cold drain assumption

	return trend


func _get_energy_trend() -> float:
	## Predict energy trend based on movement/work state.
	if not _current_unit:
		return 0.0

	# Check if unit is moving (velocity > 0 means working/moving)
	var velocity: Vector3 = _current_unit.velocity
	if velocity.length_squared() > 0.1:
		return -1.0  # Moving = energy drain

	# Resting = energy recovery (faster in shelter)
	if _current_unit.is_in_shelter():
		return 6.0
	return 3.0


func _get_morale_trend() -> float:
	## Predict morale trend based on auras and conditions.
	if not _current_unit or not _current_unit.stats:
		return 0.0

	var trend: float = 0.0

	# Base morale decay
	trend -= _current_unit.stats.morale_decay_rate

	# Positive effects from auras
	if _current_unit.is_near_captain():
		trend += 1.0
	if _current_unit.is_near_personable():
		trend += 0.5

	# Darkness penalty (use real-time check)
	if not _is_in_daylight():
		trend -= 0.5

	# Suffering penalties
	if _current_unit.stats.is_starving() or _current_unit.stats.is_freezing():
		trend -= 1.0

	return trend


func _get_health_trend() -> float:
	## Predict health trend based on critical conditions.
	if not _current_unit or not _current_unit.stats:
		return 0.0

	var stats: SurvivorStats = _current_unit.stats

	# Dying = rapid health loss
	if stats.is_dying():
		return -SurvivorStats.DYING_HEALTH_DRAIN

	var trend: float = 0.0

	# Critical conditions damage health
	if stats.is_starving():
		trend -= 2.0
	if stats.is_freezing():
		trend -= 3.0

	# Health is stable if not in critical condition
	return trend


func _on_skills_toggled(pressed: bool) -> void:
	## Toggle skills panel visibility when button pressed.
	skills_panel.visible = pressed
	# If hiding skills, also hide effects (since effects button is in skills panel)
	if not pressed:
		effects_panel.visible = false
		effects_button.button_pressed = false


func _on_effects_toggled(pressed: bool) -> void:
	## Toggle effects panel visibility when button pressed.
	effects_panel.visible = pressed


func _on_name_panel_input(event: InputEvent) -> void:
	## Handle double-click on name panel to close.
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			var current_time := Time.get_ticks_msec()
			var time_diff := current_time - _last_name_click_time
			if time_diff <= DOUBLE_CLICK_THRESHOLD_MS:
				hide_panel()
			_last_name_click_time = current_time


func _process(_delta: float) -> void:
	# Update panel position to follow character
	if visible and _current_unit and _camera:
		_update_panel_position()
		# Update action label in real-time (AI action changes frequently)
		_update_action()


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

	# Disconnect from previous unit (defensive: check is_instance_valid)
	if _current_unit and is_instance_valid(_current_unit):
		if _current_unit.stats_changed.is_connected(_on_stats_changed):
			_current_unit.stats_changed.disconnect(_on_stats_changed)

	_current_unit = unit
	# Only connect if not already connected (prevents duplicate connections)
	if not _current_unit.stats_changed.is_connected(_on_stats_changed):
		_current_unit.stats_changed.connect(_on_stats_changed)

	# Get camera reference
	if camera:
		_camera = camera
	else:
		_camera = get_viewport().get_camera_3d()

	# Reset toggle states - start with only Name and Stats visible
	skills_panel.visible = false
	effects_panel.visible = false
	skills_button.button_pressed = false
	effects_button.button_pressed = false

	# Hide skills button for Men (only Officers and Captain can view skills)
	var is_officer_or_captain: bool = _current_unit.rank != ClickableUnit.UnitRank.MAN
	skills_button.visible = is_officer_or_captain

	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the stats panel.
	if _current_unit and is_instance_valid(_current_unit):
		if _current_unit.stats_changed.is_connected(_on_stats_changed):
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

	# Calculate total height based on visible panels
	var total_height: float = name_panel.size.y + stats_panel.size.y + 4.0
	if skills_panel.visible:
		total_height += skills_panel.size.y
	if effects_panel.visible:
		total_height += effects_panel.size.y

	# Clamp to screen bounds
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, total_height / 2.0, viewport_size.y - total_height / 2.0)


func _update_display() -> void:
	## Update name, stats, skills, special trait, and effects displays.
	if not _current_unit:
		return

	# Update name
	name_label.text = _current_unit.unit_name

	# Update current action
	_update_action()

	# Update stats progress bars
	if _current_unit.stats:
		var stats: SurvivorStats = _current_unit.stats

		health_bar.value = stats.health
		energy_bar.value = stats.energy
		hunger_bar.value = stats.hunger
		warmth_bar.value = stats.warmth
		morale_bar.value = stats.morale

		# Update trend indicators based on predicted trends
		_update_trend_indicator(_health_trend, health_bar, _get_health_trend())
		_update_trend_indicator(_energy_trend, energy_bar, _get_energy_trend())
		_update_trend_indicator(_hunger_trend, hunger_bar, _get_hunger_trend())
		_update_trend_indicator(_warmth_trend, warmth_bar, _get_warmth_trend())
		_update_trend_indicator(_morale_trend, morale_bar, _get_morale_trend())

		# Update stat tooltips
		_update_stat_tooltips(stats)

		# Update skills progress bars
		hunting_bar.value = stats.hunting_skill
		construction_bar.value = stats.construction_skill
		medical_bar.value = stats.medicine_skill
		navigation_bar.value = stats.navigation_skill
		survival_bar.value = stats.survival_skill

		# Update strength bar (absolute 0-100 scale, shows current strength)
		strength_bar.value = stats.current_strength

	# Update special trait visibility and text
	_update_special_trait()

	# Update active effects
	_update_effects()


func _update_stat_tooltips(_stats: SurvivorStats) -> void:
	## Update tooltips for all stat progress bars with gameplay guidance.
	health_bar.tooltip_text = "HEALTH\nPhysical condition deteriorates from\nstarvation and freezing. Rest and eat\nwell to recover."

	energy_bar.tooltip_text = "ENERGY\nStamina for work and travel. Rest to\nrecover - shelter speeds recovery.\nMaximum energy is limited by health."

	hunger_bar.tooltip_text = "HUNGER\nFood satisfaction. Keep well-fed to\nmaintain strength. Cold weather and\nhard work increase food needs."

	warmth_bar.tooltip_text = "WARMTH\nBody temperature. Seek shelter, stay\nnear fires, and keep well-fed to\nstay warm in the arctic cold."

	morale_bar.tooltip_text = "MORALE\nMental state and will to survive.\nCompanionship, leadership, and\ndaylight help maintain spirits."


func _update_special_trait() -> void:
	## Show special trait only if character has a morale aura.
	if _current_unit.has_morale_aura():
		special_trait_container.visible = true
		var aura_name: String = _current_unit.get_morale_aura_name()
		var aura_radius: float = _current_unit.get_morale_aura_radius()
		special_trait_label.text = "%s (%dm)" % [aura_name, int(aura_radius)]
	else:
		special_trait_container.visible = false


func _update_action() -> void:
	## Update the action label with current AI action.
	if not _current_unit:
		action_label.text = ""
		return

	# Try get_current_action() method on unit first (added to clickable_unit.gd)
	if _current_unit.has_method("get_current_action"):
		action_label.text = _current_unit.get_current_action()
	else:
		# Fallback: try to find ManAIController directly
		var ai_controller: Node = _current_unit.get_node_or_null("ManAIController")
		if ai_controller and ai_controller.has_method("get_current_action"):
			action_label.text = ai_controller.get_current_action()
		else:
			action_label.text = "Idle"


func _update_effects() -> void:
	## Update active effects display and button visibility.
	var effects: Array[String] = _get_active_effects()

	# Show effects button only if there are active effects
	effects_button.visible = effects.size() > 0

	# Update effect labels in grid (hide unused ones)
	for i in range(_effect_labels.size()):
		if i < effects.size():
			_effect_labels[i].visible = true
			_effect_labels[i].text = effects[i]
		else:
			_effect_labels[i].visible = false


func _get_active_effects() -> Array[String]:
	## Returns list of active effect names for the current unit.
	var effects: Array[String] = []

	if not _current_unit:
		return effects

	# Check shelter status
	if _current_unit.is_in_shelter():
		var shelter_type: int = _current_unit.get_shelter_type()
		match shelter_type:
			0:  # TENT
				effects.append("In Tent (+2 warmth/hr)")
			1:  # IMPROVED_SHELTER
				effects.append("In Ship (+3 warmth/hr)")
			2:  # CAVE
				effects.append("In Cave (+1 warmth/hr)")

	# Check fire warmth
	if _current_unit.is_near_fire():
		effects.append("I'm near a decent fire (+5 warmth/hr)")

	# Check captain aura
	if _current_unit.is_near_captain():
		effects.append("My captain is nearby (+1 morale/hr)")

	# Check personable/well-liked aura
	if _current_unit.is_near_personable():
		effects.append("I'm near a well liked crew member (+0.5 morale/hr)")

	# Check sunlight/darkness (use real-time check)
	if not _is_in_daylight():
		effects.append("The darkness starts to dwell on me... (-0.5 morale/hr)")

	return effects
