class_name BlackboardSync extends Node
## Syncs unit state to behavior tree blackboard each physics tick.
## Attach as child of a unit with BTPlayer sibling.
## Initial blackboard setup is done by ManAIComponent - this only handles per-tick updates.

var _bt_player: BTPlayer
var _unit: ClickableUnit


func _ready() -> void:
	_unit = get_parent() as ClickableUnit
	if not _unit:
		push_error("[BlackboardSync] Parent is not ClickableUnit")
		return

	_bt_player = get_parent().get_node_or_null("BTPlayer")
	if not _bt_player:
		push_error("[BlackboardSync] No BTPlayer sibling found")
		return


func _physics_process(_delta: float) -> void:
	## Sync dynamic state to blackboard each tick.
	if not _bt_player or not _bt_player.blackboard or not _unit:
		return

	var bb: Blackboard = _bt_player.blackboard

	# Position
	bb.set_var(&"unit_position", _unit.global_position)

	# Proximity states (from Area3D event-driven tracking)
	bb.set_var(&"is_near_fire", _unit.is_near_fire())
	bb.set_var(&"is_in_shelter", _unit.is_in_shelter())
	bb.set_var(&"is_near_captain", _unit.is_near_captain())

	# Player override flag
	var player_override: bool = false
	if "player_command_active" in _unit:
		player_override = _unit.player_command_active
	bb.set_var(&"player_override", player_override)

	# Movement state
	bb.set_var(&"is_moving", _unit.is_moving)
