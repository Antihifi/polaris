@tool
class_name BTMoveToTarget extends BTAction
## Moves unit to position stored in blackboard.
## Returns RUNNING while moving, SUCCESS on arrival, FAILURE if no target.

@export var target_var: StringName = &"move_target"
@export var arrival_distance: float = 1.5

var _moving: bool = false


func _generate_name() -> String:
	return "MoveToTarget: %s" % target_var


func _tick(_delta: float) -> Status:
	var target_pos: Variant = blackboard.get_var(target_var)
	if target_pos == null or not target_pos is Vector3:
		return FAILURE

	var unit: ClickableUnit = blackboard.get_var(&"unit")
	if not unit:
		return FAILURE

	var distance: float = unit.global_position.distance_to(target_pos)

	if distance <= arrival_distance:
		_moving = false
		unit.stop()
		return SUCCESS

	if not _moving:
		unit.move_to(target_pos)
		_moving = true

	return RUNNING


func _exit() -> void:
	_moving = false
