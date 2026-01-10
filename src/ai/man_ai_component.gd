class_name ManAIComponent extends Node
## AI component for autonomous "Men" survivors.
## Finds BTPlayer sibling (must be added in scene), populates blackboard, then activates.
## Handles player override: manual move commands pause AI until destination reached.

signal ai_enabled_changed(enabled: bool)

@export var enabled: bool = true:
	set(value):
		enabled = value
		_update_enabled_state()
		ai_enabled_changed.emit(enabled)

const BlackboardSyncScript: GDScript = preload("res://src/ai/blackboard/blackboard_sync.gd")

var _bt_player: BTPlayer
var _unit: ClickableUnit


func _ready() -> void:
	_unit = get_parent() as ClickableUnit
	if not _unit:
		push_error("[ManAIComponent] Parent is not ClickableUnit")
		return

	# Find BTPlayer sibling (must exist in scene with active=false)
	_bt_player = _unit.get_node_or_null("BTPlayer")
	if not _bt_player:
		push_error("[ManAIComponent] BTPlayer not found - add it to scene with active=false")
		return

	# Connect signals
	if _unit.has_signal("reached_destination"):
		_unit.reached_destination.connect(_on_unit_reached_destination)

	# Defer activation to next frame when unit position is valid
	# (During _ready, global_position is 0,0,0 because spawner sets position AFTER instantiate)
	call_deferred("_deferred_activation")


func _deferred_activation() -> void:
	## Called after first frame when unit position is valid.
	if not _bt_player or not _unit:
		return

	# Now position is valid - populate blackboard
	_setup_blackboard()

	# Add BlackboardSync for per-tick updates
	_setup_blackboard_sync()

	# Activate BTPlayer
	if enabled:
		_bt_player.active = true
		print("[ManAIComponent] AI activated for %s at %s" % [_unit.unit_name, _unit.global_position])


func _setup_blackboard() -> void:
	## Populate blackboard with initial values.
	var bb: Blackboard = _bt_player.blackboard
	if not bb:
		push_error("[ManAIComponent] BTPlayer has no blackboard")
		return

	# Static references
	bb.set_var(&"unit", _unit)
	bb.set_var(&"stats", _unit.stats)

	# Initial state values
	bb.set_var(&"unit_position", _unit.global_position)
	bb.set_var(&"player_override", false)
	bb.set_var(&"is_moving", false)
	bb.set_var(&"is_near_fire", _unit.is_near_fire())
	bb.set_var(&"is_in_shelter", _unit.is_in_shelter())
	bb.set_var(&"is_near_captain", _unit.is_near_captain())

	# Initialize target variables to null (prevents moving to 0,0,0)
	bb.set_var(&"move_target", null)
	bb.set_var(&"target_node", null)


func _setup_blackboard_sync() -> void:
	## Add BlackboardSync node for per-tick state updates.
	var sync_node := Node.new()
	sync_node.set_script(BlackboardSyncScript)
	sync_node.name = "BlackboardSync"
	_unit.call_deferred("add_child", sync_node)


func _on_unit_reached_destination() -> void:
	## Clear player override when manual move completes.
	if "player_command_active" in _unit and _unit.player_command_active:
		_unit.player_command_active = false
		print("[ManAIComponent] Player command completed, AI resuming")


func _update_enabled_state() -> void:
	## Enable/disable BT execution.
	if _bt_player:
		_bt_player.active = enabled


func get_bt_player() -> BTPlayer:
	return _bt_player


func get_blackboard() -> Blackboard:
	if _bt_player:
		return _bt_player.blackboard
	return null


func pause_ai() -> void:
	## Temporarily pause AI (e.g., during cutscene).
	if _bt_player:
		_bt_player.active = false


func resume_ai() -> void:
	## Resume AI after pause.
	if _bt_player and enabled:
		_bt_player.active = true


func get_current_action() -> String:
	## Returns human-readable description of current AI action for UI display.
	if not _bt_player or not _bt_player.active:
		return "Idle"

	# BTPlayer doesn't expose running task directly - infer from blackboard state
	var bb: Blackboard = _bt_player.blackboard
	if not bb:
		return "Thinking..."

	# Check if moving to a target
	if _unit.is_moving:
		var target_node: Node = bb.get_var(&"target_node", null)
		if target_node and is_instance_valid(target_node):
			return "Walking to %s" % _get_friendly_target_name(target_node)
		return "Walking"

	# Check player override
	var player_override: bool = bb.get_var(&"player_override", false)
	if player_override:
		return "Following orders"

	# Default to idle/thinking
	return "Thinking..."


func _get_friendly_target_name(target: Node) -> String:
	## Convert node to human-readable name for UI display.
	if not target:
		return "destination"

	# Check node groups for resource types
	if target.is_in_group("heat_sources"):
		return "fire"
	if target.is_in_group("shelters"):
		return "shelter"
	if target.is_in_group("containers"):
		return "supplies"
	if target.is_in_group("water_sources"):
		return "water"

	# Check scene filename patterns
	var scene_path: String = target.scene_file_path if target.scene_file_path else ""
	if scene_path:
		var scene_name: String = scene_path.get_file().to_lower()
		if "campfire" in scene_name or "fire" in scene_name:
			return "campfire"
		if "shelter" in scene_name or "tent" in scene_name:
			return "shelter"
		if "barrel" in scene_name or "crate" in scene_name or "container" in scene_name:
			return "supplies"
		if "ship" in scene_name:
			return "ship"

	# Check node name patterns (fallback)
	var node_name: String = target.name.to_lower()
	if "fire" in node_name or "campfire" in node_name:
		return "campfire"
	if "shelter" in node_name or "tent" in node_name:
		return "shelter"
	if "barrel" in node_name or "crate" in node_name or "container" in node_name:
		return "supplies"
	if "ship" in node_name:
		return "ship"

	# Last resort: clean up the node name
	# Remove @ prefix and numeric suffixes from auto-generated names
	var clean_name: String = target.name
	if clean_name.begins_with("@"):
		clean_name = clean_name.substr(1)
	# Remove trailing @numbers
	var at_pos: int = clean_name.rfind("@")
	if at_pos > 0:
		clean_name = clean_name.substr(0, at_pos)
	# Convert snake_case to readable
	clean_name = clean_name.replace("_", " ").strip_edges()

	return clean_name if clean_name else "destination"
