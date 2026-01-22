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

## Bark popup scene
var _bark_scene: PackedScene = preload("res://ui/bark_popup.tscn")

## Bark data loaded from JSON
var _bark_data: Dictionary = {}

## Active barks per unit (to prevent spam)
var _active_barks: Dictionary = {}  # unit_id -> popup_node

## Cooldown tracking per unit
var _cooldowns: Dictionary = {}  # unit_id -> timestamp

## Minimum seconds between barks for same unit
@export var bark_cooldown: float = 10.0

## Default bark duration in seconds
@export var default_duration: float = 3.0

## Maximum barks visible at once (oldest removed if exceeded)
@export var max_concurrent_barks: int = 5


func _ready() -> void:
	_load_bark_data()


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

	# Cancel existing bark if any
	var unit_id := unit.get_instance_id()
	if _active_barks.has(unit_id):
		var old_popup: Node = _active_barks[unit_id]
		if is_instance_valid(old_popup):
			old_popup.queue_free()
		_active_barks.erase(unit_id)

	_show_bark(unit, text, duration)


func _show_bark(unit: Node, text: String, duration: float) -> void:
	## Internal: create and animate bark popup.
	var camera := unit.get_viewport().get_camera_3d()
	if not camera:
		return

	# Enforce max concurrent barks
	_enforce_bark_limit()

	var unit_id := unit.get_instance_id()

	# Cancel existing bark for this unit
	if _active_barks.has(unit_id):
		var old_popup: Node = _active_barks[unit_id]
		if is_instance_valid(old_popup):
			old_popup.queue_free()

	# Create popup
	var popup: Control = _bark_scene.instantiate()

	# Set text
	var label: Label = popup.get_node_or_null("Panel/MarginContainer/Label")
	if label:
		label.text = text

	# Add to scene
	unit.get_tree().current_scene.add_child(popup)
	_active_barks[unit_id] = popup

	# Position above unit head
	var world_pos: Vector3 = unit.global_position + Vector3(0, 2.5, 0)
	var screen_pos := camera.unproject_position(world_pos)

	var panel: Control = popup.get_node_or_null("Panel")
	if panel:
		# Wait a frame for label to size itself
		await unit.get_tree().process_frame
		panel.position = screen_pos - panel.size / 2.0

	bark_started.emit(unit, text)

	# Animate: fade in, hold, fade out (no float - reserved for skill ups/status/discovery)
	popup.modulate.a = 0.0
	var tween := popup.create_tween()

	# Fade in (0.2s)
	tween.tween_property(popup, "modulate:a", 1.0, 0.2)

	# Hold (duration - 0.7s for fade in/out)
	var hold_time := maxf(0.1, duration - 0.7)
	tween.tween_interval(hold_time)

	# Fade out only (0.5s)
	tween.tween_property(popup, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN)

	# Cleanup
	tween.tween_callback(func():
		_active_barks.erase(unit_id)
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
	_active_barks = valid_barks

	# Remove oldest if over limit (simple approach: remove first)
	while _active_barks.size() >= max_concurrent_barks:
		var first_key: int = _active_barks.keys()[0]
		var oldest: Node = _active_barks[first_key]
		if is_instance_valid(oldest):
			oldest.queue_free()
		_active_barks.erase(first_key)


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
