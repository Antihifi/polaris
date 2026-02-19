@tool
extends BTCondition
class_name BTCheckMentalBreak
## Condition that checks if unit is in a violent mental break state.

@export_enum("any", "berserk", "wendigo") var break_type: String = "any"


func _generate_name() -> String:
	return "MentalBreak? [%s]" % break_type


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	match break_type:
		"berserk":
			if "is_berserk" in agent and agent.is_berserk:
				return SUCCESS
		"wendigo":
			if "is_wendigo" in agent and agent.is_wendigo:
				return SUCCESS
		"any":
			if "is_berserk" in agent and agent.is_berserk:
				return SUCCESS
			if "is_wendigo" in agent and agent.is_wendigo:
				return SUCCESS

	return FAILURE
