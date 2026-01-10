@tool
class_name BTFlee extends BTAction
## Flees away from a threat position stored in the blackboard.

@export var threat_var: StringName = &"threat_position"
@export var flee_distance: float = 20.0
@export var speed_multiplier: float = 1.5

var _fleeing: bool = false
var _original_speed: float = 0.0


func _generate_name() -> String:
	return "Flee (%.0fm)" % flee_distance


func _enter() -> void:
	_fleeing = false
	_original_speed = 0.0


func _tick(_delta: float) -> Status:
	var unit: Node = blackboard.get_var(&"unit")
	var threat_pos: Vector3 = blackboard.get_var(threat_var, Vector3.ZERO)

	if not unit:
		return FAILURE

	var unit_pos: Vector3 = blackboard.get_var(&"unit_position", Vector3.ZERO)

	# Calculate flee direction (away from threat)
	var flee_dir: Vector3 = (unit_pos - threat_pos).normalized()
	flee_dir.y = 0.0  # Keep on ground plane

	if flee_dir.length_squared() < 0.01:
		# Threat is at same position, pick random direction
		flee_dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()

	var flee_target: Vector3 = unit_pos + flee_dir * flee_distance

	if not _fleeing:
		# Store original speed and increase it
		if "move_speed" in unit:
			_original_speed = unit.move_speed
			unit.move_speed = _original_speed * speed_multiplier

		# Start fleeing
		if unit.has_method("move_to"):
			unit.move_to(flee_target)
		_fleeing = true
		return RUNNING

	# Check if still moving
	if "is_moving" in unit:
		if unit.is_moving:
			return RUNNING

	# Done fleeing, restore speed
	if _original_speed > 0.0 and "move_speed" in unit:
		unit.move_speed = _original_speed

	return SUCCESS


func _exit() -> void:
	# Ensure speed is restored on exit
	var unit: Node = blackboard.get_var(&"unit")
	if unit and _original_speed > 0.0 and "move_speed" in unit:
		unit.move_speed = _original_speed
	_fleeing = false
	_original_speed = 0.0
