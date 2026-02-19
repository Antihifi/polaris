@tool
extends BTAction
class_name BTAnimalRoamToTarget
## Navigate to roam_target position. Returns SUCCESS when arrived.

@export var roam_target_var: StringName = &"roam_target"
@export var arrival_distance: float = 2.0


func _generate_name() -> String:
	return "RoamToTarget"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target: Vector3 = blackboard.get_var(roam_target_var, Vector3.INF)
	if target == Vector3.INF:
		return FAILURE

	var dist: float = agent.global_position.distance_to(target)
	if dist <= arrival_distance:
		return SUCCESS

	# Navigate toward target
	if agent.has_method("_move_to"):
		agent._move_to(target)
	elif "navigation_agent" in agent and agent.navigation_agent:
		agent.navigation_agent.target_position = target

	return RUNNING
