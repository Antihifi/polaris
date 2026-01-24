extends Node
class_name PassiveAIController
## PassiveAIController - Non-intrusive AI for player-controlled units.
## Handles self-care behaviors (eating from inventory) that run alongside player commands.
## Does NOT control movement - only triggers when unit is idle.

signal action_changed(action_name: String)

@export var behavior_tree: BehaviorTree
@export var enabled: bool = true

var _unit: Node = null
var _bt_player: BTPlayer = null
var _blackboard: Blackboard = null


func _ready() -> void:
	_unit = get_parent()
	if not _unit:
		push_error("[PassiveAIController] Must be child of ClickableUnit")
		return

	if not behavior_tree:
		behavior_tree = load("res://ai/passive_bt.tres")
		if not behavior_tree:
			push_warning("[PassiveAIController] No behavior tree at res://ai/passive_bt.tres - passive AI disabled")
			return

	# Wait a frame for unit to initialize
	await get_tree().process_frame
	_setup_behavior_tree()


func _setup_behavior_tree() -> void:
	_bt_player = BTPlayer.new()
	_bt_player.name = "BTPlayer"

	# Set scene root hint BEFORE adding to tree (required for dynamic BTPlayer creation)
	_bt_player.set_scene_root_hint(_unit)

	# Agent defaults to parent (".."), but we're a child of PassiveAIController,
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

	# Initialize blackboard variables (simpler than ManAIController - no movement vars)
	_blackboard.set_var(&"current_action", "Idle")

	# Use IDLE mode (runs in _process) to avoid interfering with physics
	_bt_player.update_mode = BTPlayer.UpdateMode.IDLE
	_bt_player.active = enabled

	print("[PassiveAIController] Passive AI initialized for: ", _unit.name)


# --- Public API ---

func get_current_action() -> String:
	if _blackboard:
		return _blackboard.get_var(&"current_action", "Idle")
	return "Idle"


func set_enabled(value: bool) -> void:
	enabled = value
	if _bt_player:
		_bt_player.active = value


func get_blackboard() -> Blackboard:
	return _blackboard
