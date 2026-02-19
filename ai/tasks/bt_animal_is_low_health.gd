@tool
extends BTCondition
class_name BTAnimalIsLowHealth
## Condition: is animal health below flee threshold?


func _generate_name() -> String:
	return "IsLowHealth?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var health: float = agent.health if "health" in agent else 100.0
	var max_health: float = agent.max_health if "max_health" in agent else 100.0
	var threshold: float = agent.flee_threshold if "flee_threshold" in agent else 0.25

	if health / max_health <= threshold:
		return SUCCESS
	return FAILURE
