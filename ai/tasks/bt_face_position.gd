@tool
extends BTAction
class_name BTFacePosition
## Rotates agent to face a target (Node3D or Vector3) from blackboard.

@export var target_var: StringName = &"target_node"

func _generate_name() -> String:
	return "FacePosition [%s]" % target_var


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target = blackboard.get_var(target_var, null)
	if target == null:
		return FAILURE

	# Support both Node3D and Vector3 targets
	var target_pos: Vector3
	if target is Node3D:
		target_pos = target.global_position
	elif target is Vector3:
		target_pos = target
	else:
		return FAILURE

	var direction := (target_pos - agent.global_position).normalized()
	direction.y = 0

	if direction.length_squared() > 0.001:
		agent.rotation.y = atan2(direction.x, direction.z)

	return SUCCESS
