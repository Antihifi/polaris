@tool
extends BTCondition
class_name BTCheckDead
## Returns SUCCESS if agent is dead (health <= 0), FAILURE otherwise.
## Use as first child of death handling sequence.

func _generate_name() -> String:
	return "CheckDead"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Check if agent has stats and is dead
	if "stats" in agent and agent.stats:
		if agent.stats.is_dead():
			return SUCCESS

	return FAILURE
