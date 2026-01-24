@tool
extends BTCondition
class_name BTCheckIdle
## Returns SUCCESS if agent is idle (not moving, not animation locked, not dead).
## Use as guard to prevent passive behaviors during player commands or other actions.


func _generate_name() -> String:
	return "CheckIdle"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Fail if moving (player gave movement command)
	if "is_moving" in agent and agent.is_moving:
		return FAILURE

	# Fail if animation locked (sitting, sleeping, or other stationary behavior)
	if "is_animation_locked" in agent and agent.is_animation_locked:
		return FAILURE

	# Fail if dead
	if "is_dead" in agent and agent.is_dead:
		return FAILURE

	return SUCCESS
