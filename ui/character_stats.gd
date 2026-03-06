extends Control
## UI panel that displays a selected character's name, survival stats, and skills.
## Panels: Name (always shown), Stats (always shown), Skills (toggle), Effects (toggle).
## Positions itself above the selected character in screen space.

signal closed

# Panel references
@onready var name_panel: Panel = $Name
@onready var action_panel: Panel = $Action
@onready var stats_panel: Panel = $Stats
@onready var skills_panel: Panel = $Stats/Skills
@onready var effects_panel: Panel = $Stats/Effects
@onready var flourish_top1: Panel = $FlourishTop1
@onready var flourish_top2: Panel = $FlourishTop2
@onready var flourish_bottom1: Panel = $FlourishTop3
@onready var flourish_bottom2: Panel = $FlourishTop4

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

# Close button (inside header HBoxContainer)
@onready var _close_button: Button = $Name/MarginContainer/HBoxContainer/CloseButton

# Unstuck button (added by user in editor, optional)
var _unstuck_button: Button = null

# Drag-to-detach support
var _dragger: PanelDragger = PanelDragger.new()
var is_detached: bool:
	get: return _dragger.is_detached

## Height offset above character's position (in world units)
@export var world_height_offset: float = 4.0
## Screen space offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)


func _ready() -> void:
	# Get TimeManager reference for real-time daylight checks
	_time_manager = get_node_or_null("/root/TimeManager")

	# Get name label reference
	name_label = $Name/MarginContainer/HBoxContainer/Label

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

	# Collect effect labels from container (Label, Label2, Label3, etc.)
	for child in effects_container.get_children():
		if child is Label:
			_effect_labels.append(child)

	# Start with Skills and Effects panels hidden, FlourishTop1 shown
	skills_panel.visible = false
	effects_panel.visible = false
	skills_button.button_pressed = false
	effects_button.button_pressed = false
	flourish_top1.visible = true
	flourish_top2.visible = false
	flourish_bottom1.visible = true
	flourish_bottom2.visible = false
	_set_panel_width(false)

	# Connect drag handles: flourishes and name panel
	flourish_top1.gui_input.connect(_on_drag_input)
	flourish_top2.gui_input.connect(_on_drag_input)
	name_panel.gui_input.connect(_on_drag_input)

	# Start hidden
	visible = false

	# Find optional UNSTUCK button (user adds in editor)
	_unstuck_button = get_node_or_null("Stats/MarginContainer/CenterContainer/VBoxContainer/UnstuckButton")
	if _unstuck_button:
		_unstuck_button.pressed.connect(_on_unstuck_pressed)


func _set_panel_width(skills_open: bool) -> void:
	## Align name and action panels to match stats area.
	## Mode 1 (default): -100 to 100 matching Stats panel.
	## Mode 2 (skills):  -100 to 298 matching Stats + Skills.
	var left: float = -100.0
	var right: float = 298.0 if skills_open else 100.0
	var width: float = right - left
	name_panel.offset_left = left
	name_panel.offset_right = right
	name_panel.custom_minimum_size.x = width
	action_panel.offset_left = left
	action_panel.offset_right = right
	action_panel.custom_minimum_size.x = width
	# Push close button to right edge when expanded
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL


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

	# Blizzard penalty
	if _time_manager and _time_manager.has_method("is_blizzard") and _time_manager.is_blizzard():
		if _current_unit.is_in_shelter():
			trend -= 0.25
		else:
			trend -= 1.0

	# Butchering horror extra drain
	if _current_unit.has_method("is_butchering_horrified") and _current_unit.is_butchering_horrified():
		trend -= 2.0

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
	# Swap flourish panels: narrow for default view, wide for skills view
	flourish_top1.visible = not pressed
	flourish_top2.visible = pressed
	flourish_bottom1.visible = not pressed
	flourish_bottom2.visible = pressed
	# Resize name/action panels: wider in skills view
	_set_panel_width(pressed)
	# If hiding skills, also hide effects (since effects button is in skills panel)
	if not pressed:
		effects_panel.visible = false
		effects_button.button_pressed = false


func _on_effects_toggled(pressed: bool) -> void:
	## Toggle effects panel visibility when button pressed.
	effects_panel.visible = pressed


func _on_close_button_pressed() -> void:
	## Close the character stats panel.
	hide_panel()


func _on_drag_input(event: InputEvent) -> void:
	## Handle drag on flourish or name panel to detach from auto-follow.
	_dragger.handle_input(event, self)



func _on_unstuck_pressed() -> void:
	## Manual unstuck button pressed - nudge the current unit.
	if _current_unit and _current_unit.has_method("nudge"):
		_current_unit.nudge(true)  # Aggressive nudge for manual button


func _process(_delta: float) -> void:
	if not visible or not _current_unit or not _camera:
		return
	if not _dragger.is_detached:
		_update_panel_position()
	# Always update action label in real-time
	_update_action()


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
	flourish_top1.visible = true
	flourish_top2.visible = false
	flourish_bottom1.visible = true
	flourish_bottom2.visible = false
	_set_panel_width(false)

	# Hide skills button for Men (only Officers and Captain can view skills)
	var is_officer_or_captain: bool = _current_unit.rank != ClickableUnit.UnitRank.MAN
	skills_button.visible = is_officer_or_captain

	# Show UNSTUCK button only for Officers/Captain (Men use BT-based stuck recovery)
	if _unstuck_button:
		_unstuck_button.visible = is_officer_or_captain

	_dragger.reset()
	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the stats panel and clean up.
	_dragger.reset()
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

	# Dynamically add labels if we need more than the scene provides
	while _effect_labels.size() < effects.size():
		var new_label := Label.new()
		new_label.add_theme_font_size_override("font_size", 10)
		new_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if _effect_labels.size() > 0:
			new_label.theme = _effect_labels[0].theme
		effects_container.add_child(new_label)
		_effect_labels.append(new_label)

	# Update effect labels (hide unused ones)
	for i in range(_effect_labels.size()):
		if i < effects.size():
			_effect_labels[i].visible = true
			_effect_labels[i].text = effects[i]
		else:
			_effect_labels[i].visible = false


func _get_active_effects() -> Array[String]:
	## Returns list of ALL active buffs and debuffs for the current unit.
	var effects: Array[String] = []

	if not _current_unit:
		return effects

	var stats: SurvivorStats = _current_unit.stats if _current_unit.stats else null

	# --- Positive effects (buffs) ---

	# Shelter
	if _current_unit.is_in_shelter():
		var shelter_type: int = _current_unit.get_shelter_type()
		match shelter_type:
			0:  effects.append("In Tent (+2 warmth/hr)")
			1:  effects.append("In Ship (+3 warmth/hr)")
			2:  effects.append("In Cave (+1 warmth/hr)")

	# Fire warmth
	if _current_unit.is_near_fire():
		effects.append("Near a decent fire (+5 warmth/hr)")

	# Captain aura
	if _current_unit.is_near_captain():
		effects.append("My captain is nearby (+1 morale/hr)")

	# Personable/well-liked aura
	if _current_unit.is_near_personable():
		effects.append("Near a well liked crew member (+0.5 morale/hr)")

	# Aurora morale buff
	if _current_unit.has_method("is_aurora_buffed") and _current_unit.is_aurora_buffed():
		effects.append("The majesty of the Aurora inspires me (+25 morale)")

	# High morale work bonus
	if stats and stats.morale >= 85.0:
		effects.append("Spirits are high (+25% work efficiency)")
	elif stats and stats.morale >= SurvivorStats.COMFORTABLE_THRESHOLD:
		effects.append("In good spirits (+10% work efficiency)")

	# --- Negative effects (debuffs) ---

	# Butchering horror
	if _current_unit.has_method("is_butchering_horrified") and _current_unit.is_butchering_horrified():
		effects.append("The horror of what I witnessed... (-2 morale/hr)")

	# Darkness penalty
	if not _is_in_daylight():
		effects.append("The darkness dwells on me... (-0.5 morale/hr)")

	# Hunger states
	if stats:
		if stats.is_starving():
			effects.append("Starving (-1 morale/hr, health declining)")
		elif stats.is_hungry():
			effects.append("Hungry (-30% work efficiency)")

	# Cold states
	if stats:
		if stats.is_freezing():
			effects.append("Freezing (-1 morale/hr, health declining)")
		elif stats.is_cold():
			effects.append("Cold (-25% work efficiency)")

	# Energy states
	if stats:
		if stats.is_exhausted():
			effects.append("Exhausted (-80% work efficiency)")
		elif stats.is_tired():
			effects.append("Tired (-40% work efficiency)")

	# Low morale
	if stats:
		if stats.morale <= SurvivorStats.CRITICAL_THRESHOLD:
			effects.append("On the verge of breaking... (-30% work efficiency)")
		elif stats.is_depressed():
			effects.append("Losing hope (-30% work efficiency)")

	# Health states
	if stats:
		if stats.is_critically_injured():
			effects.append("Gravely wounded")
		elif stats.is_injured():
			effects.append("Wounded")

	# Dying condition
	if stats and stats.is_dying():
		effects.append("Dying (health draining rapidly)")

	# Blizzard (check via TimeManager)
	if _time_manager and _time_manager.has_method("is_blizzard") and _time_manager.is_blizzard():
		if _current_unit.is_in_shelter():
			effects.append("Blizzard raging outside (-0.25 morale/hr)")
		else:
			effects.append("Exposed to blizzard! (-1 morale/hr)")

	return effects
