@tool
extends BTCondition
class_name BTCheckPersistence
## Condition: Roll probability to decide if animal continues investigating.
## SUCCESS = continue investigating, FAILURE = give up and return to idle.


func _generate_name() -> String:
	return "CheckPersistence?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Roll persistence check
	if agent.has_method("should_continue_investigating"):
		if agent.should_continue_investigating():
			return SUCCESS  # Keep investigating
		else:
			# Give up - clear investigation state
			if agent.has_method("clear_investigation"):
				agent.clear_investigation()
			return FAILURE

	# No investigation system - default to giving up
	return FAILURE
