@tool
class_name BTWander extends BTAction
## Idle wandering behavior - picks random nearby point and moves there.

@export var wander_radius: float = 10.0
@export var min_wait_time: float = 2.0
@export var max_wait_time: float = 5.0
@export var target_var: StringName = &"move_target"

var _state: int = 0  # 0 = picking target, 1 = moving, 2 = waiting
var _wait_timer: float = 0.0


func _generate_name() -> String:
	return "Wander (%.0fm)" % wander_radius


func _enter() -> void:
	_state = 0
	_wait_timer = 0.0


func _tick(delta: float) -> Status:
	var unit: Node = blackboard.get_var(&"unit")
	if not unit:
		return FAILURE

	match _state:
		0:  # Pick random target
			var unit_pos: Vector3 = blackboard.get_var(&"unit_position", Vector3.ZERO)
			var random_offset := Vector3(
				randf_range(-wander_radius, wander_radius),
				0.0,
				randf_range(-wander_radius, wander_radius)
			)
			var target_pos: Vector3 = unit_pos + random_offset
			blackboard.set_var(target_var, target_pos)

			# Start moving
			if unit.has_method("move_to"):
				unit.move_to(target_pos)
			_state = 1
			return RUNNING

		1:  # Moving to target
			if unit.has_method("is_moving") or "is_moving" in unit:
				if not unit.is_moving:
					# Reached destination, start waiting
					_wait_timer = randf_range(min_wait_time, max_wait_time)
					_state = 2
			return RUNNING

		2:  # Waiting
			_wait_timer -= delta
			if _wait_timer <= 0.0:
				# Done waiting - return SUCCESS so tree re-evaluates
				# This allows needs checks to run between wander cycles
				return SUCCESS
			return RUNNING

	return RUNNING


func _exit() -> void:
	_state = 0
	_wait_timer = 0.0
