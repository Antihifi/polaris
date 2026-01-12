extends Node
## ManAIController - Controls autonomous AI behavior for enlisted men using LimboAI.
## Attach as a child of ClickableUnit (men.tscn).
## Loads behavior tree from man_bt.tres resource file.

signal action_changed(action_name: String)

@export var behavior_tree: BehaviorTree
@export var enabled: bool = true

var _unit: Node = null
var _bt_player: BTPlayer = null
var _blackboard: Blackboard = null


func _ready() -> void:
	_unit = get_parent()
	if not _unit:
		push_error("[ManAIController] Must be child of ClickableUnit")
		return

	if not behavior_tree:
		# Try to load default behavior tree
		behavior_tree = load("res://ai/man_bt.tres")
		if not behavior_tree:
			push_error("[ManAIController] No behavior tree assigned or found at res://ai/man_bt.tres")
			return

	# Wait a frame for unit to initialize
	await get_tree().process_frame
	_setup_behavior_tree()


func _setup_behavior_tree() -> void:
	# Create BTPlayer
	_bt_player = BTPlayer.new()
	_bt_player.name = "BTPlayer"

	# Set scene root hint BEFORE adding to tree (required for dynamic BTPlayer creation)
	# This tells LimboAI which node is the scene root for path resolution
	_bt_player.set_scene_root_hint(_unit)

	# Agent defaults to parent (".."), but we're a child of ManAIController,
	# so we need to point to the unit (grandparent)
	_bt_player.agent_node = NodePath("../..")

	# Assign the behavior tree BEFORE adding to tree
	_bt_player.behavior_tree = behavior_tree

	# Add to scene tree - this triggers initialization
	add_child(_bt_player)

	# Wait for scene to be fully ready before BT tasks resolve paths
	await get_tree().physics_frame

	# Get the blackboard from the BTPlayer after initialization
	_blackboard = _bt_player.blackboard

	# Initialize blackboard variables
	_blackboard.set_var(&"player_command_active", false)
	_blackboard.set_var(&"current_action", "Idle")
	_blackboard.set_var(&"target_position", Vector3.INF)
	_blackboard.set_var(&"target_node", null)
	_blackboard.set_var(&"target_marker", null)

	# Start the behavior tree
	_bt_player.update_mode = BTPlayer.UpdateMode.PHYSICS
	_bt_player.active = enabled

	print("[ManAIController] AI initialized for: ", _unit.name)


# --- Public API ---

func get_current_action() -> String:
	if _blackboard:
		return _blackboard.get_var(&"current_action", "Idle")
	return "Idle"


func set_player_command_active(active: bool) -> void:
	if _blackboard:
		_blackboard.set_var(&"player_command_active", active)
		if active:
			_blackboard.set_var(&"current_action", "Following orders")


func is_player_command_active() -> bool:
	if _blackboard:
		return _blackboard.get_var(&"player_command_active", false)
	return false


func set_enabled(value: bool) -> void:
	enabled = value
	if _bt_player:
		_bt_player.active = value


func get_blackboard() -> Blackboard:
	return _blackboard
