extends Node
## Simple dialog/bark system for flavor text.
## Displays short lines above unit heads (Kenshi-style barks).
##
## Categories:
## - idle: Random chit-chat between men
## - affirmation: Officer responses ("Aye, captain")
## - cold: Reactions to freezing temperatures
## - darkness: Reactions to night/polar darkness
## - discovery: When finding lost crew members
## - hunger: Reactions to low food
## - exhaustion: Reactions to low energy
## - morale_low: Despair, hopelessness
## - morale_high: Optimism, encouragement

signal bark_started(unit: Node, text: String)
signal bark_finished(unit: Node)

## Bark popup scene (themed 2D Control)
var _bark_scene: PackedScene = preload("res://ui/bark_popup.tscn")

## Bark data loaded from JSON
var _bark_data: Dictionary = {}

## Active barks per unit (to prevent spam)
var _active_barks: Dictionary = {}  # unit_id -> popup_node

## Track unit references for position updates
var _bark_units: Dictionary = {}  # unit_id -> unit_node

## Cooldown tracking per unit
var _cooldowns: Dictionary = {}  # unit_id -> timestamp

## Minimum seconds between barks for same unit
@export var bark_cooldown: float = 10.0

## Default bark duration in seconds
@export var default_duration: float = 3.0

## Maximum barks visible at once (oldest removed if exceeded)
@export var max_concurrent_barks: int = 5

## Maximum distance (meters) from camera to show barks
@export var max_bark_distance: float = 50.0


func _ready() -> void:
	_load_bark_data()
	_connect_to_survivors.call_deferred()
	_connect_to_animals.call_deferred()


func _process(_delta: float) -> void:
	_update_bark_positions()


func _load_bark_data() -> void:
	## Load bark lines from JSON file.
	var file := FileAccess.open("res://data/bark_data.json", FileAccess.READ)
	if file:
		var json := JSON.new()
		var error := json.parse(file.get_as_text())
		if error == OK:
			_bark_data = json.data
			print("[BarkManager] Loaded %d bark categories" % _bark_data.size())
		else:
			push_error("[BarkManager] Failed to parse bark_data.json: %s" % json.get_error_message())
	else:
		push_warning("[BarkManager] bark_data.json not found, using empty data")
		_bark_data = {}


func bark(unit: Node, category: String, duration: float = -1.0) -> bool:
	## Show a random bark from category above the unit.
	## Returns false if on cooldown or no lines available.
	if not is_instance_valid(unit):
		return false

	var unit_id := unit.get_instance_id()

	# Check cooldown
	if _is_on_cooldown(unit_id):
		return false

	# Get random line from category
	var text := _get_random_line(category, unit)
	if text.is_empty():
		return false

	# Use default duration if not specified
	if duration < 0:
		duration = default_duration

	# Show the bark
	_show_bark(unit, text, duration)
	_set_cooldown(unit_id)

	return true


func bark_specific(unit: Node, text: String, duration: float = -1.0) -> bool:
	## Show a specific bark text (bypasses category lookup).
	## Still respects cooldown.
	if not is_instance_valid(unit):
		return false

	var unit_id := unit.get_instance_id()

	if _is_on_cooldown(unit_id):
		return false

	if duration < 0:
		duration = default_duration

	_show_bark(unit, text, duration)
	_set_cooldown(unit_id)

	return true


func bark_immediate(unit: Node, text: String, duration: float = -1.0) -> void:
	## Show bark immediately, ignoring cooldown.
	## Use sparingly for important events (discovery, death nearby, etc.)
	if not is_instance_valid(unit):
		return

	if duration < 0:
		duration = default_duration

	# Cancel existing bark if any (also done in _show_bark, but explicit here)
	var unit_id := unit.get_instance_id()
	if _active_barks.has(unit_id):
		var old_popup: Node = _active_barks[unit_id]
		if is_instance_valid(old_popup):
			old_popup.queue_free()
		_active_barks.erase(unit_id)
		_bark_units.erase(unit_id)

	_show_bark(unit, text, duration)


func _show_bark(unit: Node, text: String, duration: float) -> void:
	## Internal: create and animate themed bark popup.
	var camera := unit.get_viewport().get_camera_3d()
	if not camera:
		return

	# Skip barks from units too far from camera
	if camera.global_position.distance_to(unit.global_position) > max_bark_distance:
		return

	# Enforce max concurrent barks
	_enforce_bark_limit()

	var unit_id := unit.get_instance_id()

	# Cancel existing bark for this unit
	if _active_barks.has(unit_id):
		var old_popup: Node = _active_barks[unit_id]
		if is_instance_valid(old_popup):
			old_popup.queue_free()

	# Create popup from themed scene
	var popup: Control = _bark_scene.instantiate()

	# Set text (PanelContainer > Label)
	var label: Label = popup.get_node_or_null("Panel/Label")
	if label:
		label.text = text

	# Add to scene tree
	unit.get_tree().current_scene.add_child(popup)
	_active_barks[unit_id] = popup
	_bark_units[unit_id] = unit

	# Position above unit head
	var world_pos: Vector3 = unit.global_position + Vector3(0, 2.5, 0)
	var screen_pos := camera.unproject_position(world_pos)

	var panel: Control = popup.get_node_or_null("Panel")
	if panel:
		# Wait a frame for label to size itself
		await unit.get_tree().process_frame
		# Guard against popup being freed during await (race with _enforce_bark_limit)
		if not is_instance_valid(popup) or not is_instance_valid(panel):
			return
		panel.position = screen_pos - panel.size / 2.0

	# Popup may have been freed if panel was null or during await
	if not is_instance_valid(popup):
		return

	bark_started.emit(unit, text)

	# Animate: fade in, hold, fade out
	popup.modulate.a = 0.0
	var tween := popup.create_tween()

	# Fade in
	tween.tween_property(popup, "modulate:a", 1.0, 0.2)

	# Hold
	var hold_time := maxf(0.1, duration - 0.7)
	tween.tween_interval(hold_time)

	# Fade out
	tween.tween_property(popup, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)

	# Cleanup
	tween.tween_callback(func():
		_active_barks.erase(unit_id)
		_bark_units.erase(unit_id)
		bark_finished.emit(unit)
		popup.queue_free()
	)


func _get_random_line(category: String, unit: Node) -> String:
	## Get random line from category, with variable substitution.
	if not _bark_data.has(category):
		return ""

	var lines: Array = _bark_data[category]
	if lines.is_empty():
		return ""

	var line: String = lines[randi() % lines.size()]

	# Variable substitution
	if "{name}" in line and "unit_name" in unit:
		line = line.replace("{name}", unit.unit_name)
	if "{rank}" in line and "rank" in unit:
		var rank_names := ["", "Lieutenant ", "Captain "]
		var rank_idx: int = unit.rank if unit.rank < rank_names.size() else 0
		line = line.replace("{rank}", rank_names[rank_idx])

	return line


func _is_on_cooldown(unit_id: int) -> bool:
	## Check if unit is on bark cooldown.
	if not _cooldowns.has(unit_id):
		return false
	var last_bark: float = _cooldowns[unit_id]
	return Time.get_ticks_msec() / 1000.0 - last_bark < bark_cooldown


func _set_cooldown(unit_id: int) -> void:
	## Set cooldown timestamp for unit.
	_cooldowns[unit_id] = Time.get_ticks_msec() / 1000.0


func _enforce_bark_limit() -> void:
	## Remove oldest barks if exceeding limit.
	# Clean up invalid references first
	var valid_barks: Dictionary = {}
	for unit_id: int in _active_barks:
		var popup: Node = _active_barks[unit_id]
		if is_instance_valid(popup):
			valid_barks[unit_id] = popup
		else:
			_bark_units.erase(unit_id)
	_active_barks = valid_barks

	# Remove oldest if over limit (simple approach: remove first)
	while _active_barks.size() >= max_concurrent_barks:
		var first_key: int = _active_barks.keys()[0]
		var oldest: Node = _active_barks[first_key]
		if is_instance_valid(oldest):
			oldest.queue_free()
		_active_barks.erase(first_key)
		_bark_units.erase(first_key)


func _update_bark_positions() -> void:
	## Update all bark popups to track their units each frame.
	if _active_barks.is_empty():
		return

	var camera := get_viewport().get_camera_3d()
	if not camera:
		return

	for unit_id: int in _active_barks:
		var popup: Control = _active_barks[unit_id]
		var unit: Node = _bark_units.get(unit_id)

		if not is_instance_valid(popup) or not is_instance_valid(unit):
			continue

		var panel: Control = popup.get_node_or_null("Panel")
		if panel:
			var world_pos: Vector3 = unit.global_position + Vector3(0, 2.5, 0)
			var screen_pos := camera.unproject_position(world_pos)
			panel.position = screen_pos - panel.size / 2.0


# ============================================================================
# UTILITY: Trigger barks from game events
# ============================================================================

func trigger_cold_bark(unit: Node) -> void:
	## Trigger when unit warmth drops below threshold.
	bark(unit, "cold")


func trigger_hunger_bark(unit: Node) -> void:
	## Trigger when unit hunger drops below threshold.
	bark(unit, "hunger")


func trigger_exhaustion_bark(unit: Node) -> void:
	## Trigger when unit energy drops below threshold.
	bark(unit, "exhaustion")


func trigger_discovery_bark(discoverer: Node, found_unit: Node) -> void:
	## Trigger when a unit is discovered.
	## Both discoverer and found unit may bark.
	var found_name: String = found_unit.unit_name if "unit_name" in found_unit else "someone"
	var rank_prefix := ""
	if "rank" in found_unit:
		match found_unit.rank:
			1: rank_prefix = "Lt. "
			2: rank_prefix = "Captain "

	bark_immediate(discoverer, "It's %s%s! We're saved!" % [rank_prefix, found_name], 4.0)


func trigger_affirmation_bark(unit: Node) -> void:
	## Trigger officer/man acknowledgment.
	bark(unit, "affirmation")


func trigger_idle_bark(unit: Node) -> void:
	## Trigger random idle chatter.
	bark(unit, "idle")


func trigger_health_bark(unit: Node) -> void:
	## Trigger when unit health drops below threshold.
	if "health" in unit and unit.health < 15.0:
		bark(unit, "health_critical")
	else:
		bark(unit, "health_low")


func trigger_blizzard_bark(unit: Node) -> void:
	## Trigger during blizzard conditions.
	bark(unit, "blizzard")


func trigger_warming_bark(unit: Node) -> void:
	## Trigger when unit gets near fire.
	bark(unit, "warming_up")


func trigger_eating_bark(unit: Node) -> void:
	## Trigger when unit eats food.
	bark(unit, "eating")


func trigger_resting_bark(unit: Node) -> void:
	## Trigger when unit sits/rests.
	bark(unit, "resting")


func trigger_work_start_bark(unit: Node) -> void:
	## Trigger when unit starts a work task.
	bark(unit, "work_start")


func trigger_death_nearby_bark(unit: Node) -> void:
	## Trigger when another unit dies nearby.
	bark_immediate(unit, _get_random_line("death_nearby", unit), 4.0)


# ============================================================================
# SIGNAL CONNECTIONS: Auto-connect to survivor/animal events
# ============================================================================

## Connected units (to avoid duplicate connections)
var _connected_units: Dictionary = {}  # unit_id -> true
var _connected_animals: Dictionary = {}  # animal_id -> true


func _connect_to_survivors() -> void:
	## Connect to all survivors' combat signals.
	## Runs periodically to catch late-spawned units (groups aren't set when
	## node_added fires, so a one-shot scan + signal approach misses them).
	while true:
		await get_tree().create_timer(1.0).timeout
		var survivors := get_tree().get_nodes_in_group("survivors")
		for unit: Node in survivors:
			_connect_unit_signals(unit)


func _connect_to_animals() -> void:
	## Connect to all animals' combat signals.
	## Same periodic approach as survivors.
	while true:
		await get_tree().create_timer(2.0).timeout
		var animals := get_tree().get_nodes_in_group("animals")
		for animal: Node in animals:
			_connect_animal_signals(animal)


func _connect_unit_signals(unit: Node) -> void:
	## Connect a single unit's signals.
	var unit_id := unit.get_instance_id()
	if _connected_units.has(unit_id):
		return
	_connected_units[unit_id] = true

	if unit.has_signal("combat_started"):
		unit.combat_started.connect(_on_unit_combat_started.bind(unit))
	if unit.has_signal("took_damage"):
		unit.took_damage.connect(_on_unit_took_damage.bind(unit))

	# Connect to died signal via CombatComponent
	var combat: Node = unit.get_node_or_null("CombatComponent")
	if combat and combat.has_signal("died"):
		combat.died.connect(_on_unit_died.bind(unit))

	# Connect to dismemberment signal
	var dismember: Node = unit.get_node_or_null("DismembermentComponent")
	if dismember and dismember.has_signal("limb_dismembered"):
		dismember.limb_dismembered.connect(_on_unit_dismembered.bind(unit))


func _connect_animal_signals(animal: Node) -> void:
	## Connect to an animal's CombatComponent signals for death detection.
	var animal_id := animal.get_instance_id()
	if _connected_animals.has(animal_id):
		return
	_connected_animals[animal_id] = true

	# Animals emit combat signals via their CombatComponent
	var combat: Node = animal.get_node_or_null("CombatComponent")
	if combat:
		combat.died.connect(_on_animal_died.bind(animal))
		combat.combat_started.connect(_on_animal_started_combat.bind(animal))


func _on_unit_combat_started(target: Node3D, unit: Node) -> void:
	## Unit started combat - bark if target is an animal (50% chance).
	if not is_instance_valid(target):
		return
	if target.is_in_group("animals") and randf() < 0.5:
		bark(unit, "combat_start", 2.0)


func _on_unit_took_damage(_amount: float, attacker: Node3D, unit: Node) -> void:
	## Unit took damage - context-sensitive bark based on attacker type.
	if not is_instance_valid(attacker):
		if randf() < 0.3:
			bark(unit, "took_hit", 1.5)
		return

	# Being attacked by animal (bear) - more dramatic
	if attacker.is_in_group("animals"):
		# Check if fleeing (being chased) vs in melee combat
		if "is_fleeing" in unit and unit.is_fleeing:
			# Being chased - terrified barks
			if randf() < 0.5:
				bark_immediate(unit, _get_random_line("fleeing_terror", unit), 2.0)
		else:
			# Being mauled in melee - horrific barks
			if randf() < 0.7:
				bark_immediate(unit, _get_random_line("being_mauled", unit), 2.0)
		return

	# Regular damage (from other sources)
	if randf() < 0.3:
		bark(unit, "took_hit", 1.5)


func _on_animal_died(animal: Node) -> void:
	## Animal killed - find nearest survivor to celebrate (50% chance).
	if randf() < 0.5:
		return

	var survivors := get_tree().get_nodes_in_group("survivors")
	var closest: Node = null
	var closest_dist: float = 30.0  # Max range to react

	for unit: Node in survivors:
		if "is_dead" in unit and unit.is_dead:
			continue
		var dist: float = unit.global_position.distance_to(animal.global_position)
		if dist < closest_dist:
			closest = unit
			closest_dist = dist

	if closest:
		bark(closest, "killed_animal", 2.5)


func _on_animal_started_combat(target: Node3D, animal: Node) -> void:
	## Animal attacked someone - victim screams, nearby survivors warn.
	if not is_instance_valid(target):
		return

	# VICTIM barks in terror (high chance - being attacked is terrifying)
	if target.is_in_group("survivors") and randf() < 0.8:
		bark_immediate(target, _get_random_line("being_mauled", target), 2.0)

	# Nearby survivors warn (lower chance to avoid bark spam)
	if randf() < 0.4:
		var survivors := get_tree().get_nodes_in_group("survivors")
		for unit: Node in survivors:
			if unit == target:
				continue
			if "is_dead" in unit and unit.is_dead:
				continue
			var dist: float = unit.global_position.distance_to(animal.global_position)
			if dist < 25.0:
				bark(unit, "animal_attacking", 2.0)
				break  # Only one warning


func _on_unit_died(unit: Node) -> void:
	## A survivor died - nearby survivors react (excludes the killer).
	var survivors := get_tree().get_nodes_in_group("survivors")
	var death_pos: Vector3 = unit.global_position

	for other: Node in survivors:
		if other == unit:
			continue
		if "is_dead" in other and other.is_dead:
			continue
		# Skip the killer — they don't mourn their own victim
		if _is_fighting(other, unit):
			continue
		var dist: float = other.global_position.distance_to(death_pos)
		if dist < 20.0:
			# Stagger reactions slightly so they don't all bark at once
			var delay: float = randf_range(0.5, 2.0)
			_schedule_death_reaction(other, delay)
			break  # Only one reaction bark


func _schedule_death_reaction(unit: Node, delay: float) -> void:
	## Delayed death reaction bark.
	get_tree().create_timer(delay).timeout.connect(func() -> void:
		if is_instance_valid(unit) and not ("is_dead" in unit and unit.is_dead):
			bark_immediate(unit, _get_random_line("death_nearby", unit), 3.0)
	)


# ============================================================================
# DISMEMBERMENT BARKS
# ============================================================================

func _on_unit_dismembered(part: int, _position: Vector3, _limb: RigidBody3D, unit: Node) -> void:
	## Victim lost a limb - immediate traumatic bark + witness reactions.
	# Get attacker reference before anything clears it
	var attacker: Node3D = null
	var is_animal_attack := false
	var combat: Node = unit.get_node_or_null("CombatComponent")
	if combat and is_instance_valid(combat.combat_target):
		attacker = combat.combat_target
		is_animal_attack = attacker.is_in_group("animals")

	# Head = instant death, no victim bark (they're dead)
	if part == 0:  # BodyPart.HEAD
		_trigger_witness_dismemberment(unit, attacker)
		return

	# Pick bark category based on limb + attacker type
	var category := _get_dismemberment_category(part, is_animal_attack)
	bark_immediate(unit, _get_random_line(category, unit), 3.0)

	# Nearby witness reactions (excludes attacker)
	_trigger_witness_dismemberment(unit, attacker)


func _get_dismemberment_category(part: int, is_animal: bool) -> String:
	## Map body part enum + attacker type to bark category.
	match part:
		1, 2:  # LEFT_ARM, RIGHT_ARM
			return "dismember_arm_animal" if is_animal else "dismember_arm_human"
		3, 4:  # LEFT_LEG, RIGHT_LEG
			return "dismember_leg_animal" if is_animal else "dismember_leg_human"
		5, 6:  # LEFT_HAND, RIGHT_HAND
			return "dismember_hand"
		7, 8:  # LEFT_FOOT, RIGHT_FOOT
			return "dismember_foot"
		_:
			return "dismember_generic"


func _trigger_witness_dismemberment(victim: Node, attacker: Node3D = null) -> void:
	## Nearby survivors react to witnessing dismemberment (staggered).
	## Excludes anyone fighting the victim — they're the ones doing it, not witnessing it.
	var survivors := get_tree().get_nodes_in_group("survivors")
	var witness_count: int = 0

	for unit: Node in survivors:
		if unit == victim or unit == attacker:
			continue
		if "is_dead" in unit and unit.is_dead:
			continue
		# Skip anyone whose combat target is the victim (they're an attacker)
		if _is_fighting(unit, victim):
			continue
		if unit.global_position.distance_to(victim.global_position) < 20.0:
			var delay: float = randf_range(1.0, 4.0)
			_schedule_witness_bark(unit, delay)
			witness_count += 1
			if witness_count >= 2:
				break  # Max 2 witnesses to avoid bark spam


func _schedule_witness_bark(unit: Node, delay: float) -> void:
	## Delayed witness reaction to dismemberment.
	get_tree().create_timer(delay).timeout.connect(func() -> void:
		if is_instance_valid(unit) and not ("is_dead" in unit and unit.is_dead):
			bark_immediate(unit, _get_random_line("witness_dismemberment", unit), 3.0)
	)


func _is_fighting(unit: Node, target: Node) -> bool:
	## Check if unit is actively in combat with target.
	var combat: Node = unit.get_node_or_null("CombatComponent")
	if not combat:
		return false
	return combat.is_in_combat and is_instance_valid(combat.combat_target) and combat.combat_target == target
