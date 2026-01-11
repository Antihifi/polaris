@tool
class_name BTMoveToTarget extends BTAction
## Moves unit to position stored in blackboard.
## Returns RUNNING while moving, SUCCESS on arrival, FAILURE if no target.
## Includes stuck detection - returns SUCCESS after timeout to allow behavior to continue.

@export var target_var: StringName = &"move_target"
@export var arrival_distance: float = 3.5  # Increased from 1.5 to prevent crowding at targets

var _moving: bool = false
var _move_timeout: float = 0.0

## Max seconds to wait for arrival before timing out (stuck detection)
const MAX_MOVE_TIME: float = 8.0


func _generate_name() -> String:
	return "MoveToTarget: %s" % target_var


func _enter() -> void:
	_moving = false
	_move_timeout = 0.0


func _tick(delta: float) -> Status:
	var target_pos: Variant = blackboard.get_var(target_var)
	if target_pos == null or not target_pos is Vector3:
		return FAILURE

	var unit: ClickableUnit = blackboard.get_var(&"unit")
	if not unit:
		return FAILURE

	var distance: float = unit.global_position.distance_to(target_pos)

	if distance <= arrival_distance:
		_moving = false
		_move_timeout = 0.0
		unit.stop()
		return SUCCESS

	# Stuck detection: if moving for too long, timeout and return SUCCESS
	# This allows the behavior to continue (warming/resting at current position)
	_move_timeout += delta
	if _move_timeout >= MAX_MOVE_TIME:
		_moving = false
		_move_timeout = 0.0
		if unit.has_method("stop"):
			unit.stop()
		print("[BTMoveToTarget] Timeout after %.1fs, stopping at dist=%.1fm" % [MAX_MOVE_TIME, distance])
		return SUCCESS

	if not _moving:
		unit.move_to(target_pos)
		_moving = true

	return RUNNING


func _exit() -> void:
	# Stop the unit if we were actively moving and task is interrupted
	if _moving:
		var unit: ClickableUnit = blackboard.get_var(&"unit")
		if unit and unit.has_method("stop"):
			unit.stop()
	_moving = false
	_move_timeout = 0.0
