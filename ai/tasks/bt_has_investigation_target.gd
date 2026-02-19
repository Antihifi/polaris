@tool
extends BTCondition
class_name BTHasInvestigationTarget
## Condition: check if animal has detected a target to investigate.
## The detection happens via Area3D body_entered signal in Animal class.

@export var investigation_target_var: StringName = &"investigation_target"
@export var investigation_position_var: StringName = &"investigation_position"


func _generate_name() -> String:
	return "HasInvestigationTarget?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Get investigation target from animal (set by Area3D signal)
	var target: Node3D = null
	if agent.has_method("get_investigation_target"):
		target = agent.get_investigation_target()

	if not target or not is_instance_valid(target):
		return FAILURE

	# Check if target is still alive
	if "stats" in target and target.stats and target.stats.has_method("is_dead"):
		if target.stats.is_dead():
			# Target died - clear investigation
			if agent.has_method("clear_investigation"):
				agent.clear_investigation()
			return FAILURE

	# Update blackboard with current target info
	blackboard.set_var(investigation_target_var, target)

	var pos: Vector3 = Vector3.INF
	if agent.has_method("get_investigation_position"):
		pos = agent.get_investigation_position()
	blackboard.set_var(investigation_position_var, pos)

	return SUCCESS
