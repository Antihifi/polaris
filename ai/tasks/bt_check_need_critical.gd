@tool
extends BTCondition
class_name BTCheckNeedCritical
## Returns SUCCESS if a survival need is BELOW threshold (critical).
## Use this to trigger priority behaviors when stats are low.

@export_enum("warmth", "energy", "hunger", "health", "morale") var need: String = "warmth"
@export var threshold: float = 25.0

func _generate_name() -> String:
	return "Check %s < %.0f" % [need, threshold]


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent or not "stats" in agent or not agent.stats:
		return FAILURE

	var value: float = agent.stats.get(need)
	if value < threshold:
		return SUCCESS
	return FAILURE
