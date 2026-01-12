@tool
extends BTCondition
class_name BTCheckNeedSatisfied
## Checks if a survival need is above the threshold.

@export_enum("warmth", "energy", "hunger", "health", "morale") var need: String = "warmth"
@export var threshold: float = 80.0

func _generate_name() -> String:
	return "Check %s >= %.0f" % [need, threshold]


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent or not "stats" in agent or not agent.stats:
		return FAILURE

	var value: float = agent.stats.get(need)
	if value >= threshold:
		return SUCCESS
	return FAILURE
