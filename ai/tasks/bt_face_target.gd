@tool
extends BTAction
class_name BTFaceTarget
## Rotates the agent to face toward or away from a target.

@export var target_var: StringName = &"target_position"
@export var face_away: bool = false

func _generate_name() -> String:
	var dir := "away from" if face_away else "toward"
	return "Face %s [%s]" % [dir, target_var]


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target: Vector3 = blackboard.get_var(target_var, Vector3.INF)
	if target == Vector3.INF:
		return FAILURE

	var direction: Vector3 = (target - agent.global_position).normalized()
	var angle: float = atan2(direction.x, direction.z)

	if face_away:
		angle += PI

	agent.rotation.y = angle
	return SUCCESS
