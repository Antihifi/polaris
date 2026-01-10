@tool
class_name BTCheckPlayerOverride extends BTCondition
## Checks if player has issued a manual command that should override AI.
## Returns SUCCESS if player override is active (AI should pause).
## Returns FAILURE if AI can proceed normally.


func _generate_name() -> String:
	return "CheckPlayerOverride"


func _tick(_delta: float) -> Status:
	var player_override: bool = blackboard.get_var(&"player_override", false)
	return SUCCESS if player_override else FAILURE
