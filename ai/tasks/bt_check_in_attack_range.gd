@tool
extends BTCondition
class_name BTCheckInAttackRange
## Condition: Check if investigation target is in attack range.
## If so, transfer to threat_target and clear investigation (transition to combat).

@export var investigation_target_var: StringName = &"investigation_target"
@export var threat_target_var: StringName = &"threat_target"
@export var attack_range_buffer: float = 5.0  # Extra range to trigger combat


func _generate_name() -> String:
	return "InAttackRange?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target: Node3D = blackboard.get_var(investigation_target_var)
	if not target or not is_instance_valid(target):
		return FAILURE

	# Check if target is dead
	if "stats" in target and target.stats and target.stats.has_method("is_dead"):
		if target.stats.is_dead():
			# Target died - clear and fail
			if agent.has_method("clear_investigation"):
				agent.clear_investigation()
			return FAILURE

	# Get attack range from agent
	var attack_range: float = 2.5
	if "attack_range" in agent:
		attack_range = agent.attack_range

	# Check distance
	var dist := agent.global_position.distance_to(target.global_position)
	if dist <= attack_range + attack_range_buffer:
		# In attack range! Transfer to combat
		blackboard.set_var(threat_target_var, target)
		blackboard.set_var(&"threat_position", target.global_position)

		# Clear investigation state
		if agent.has_method("clear_investigation"):
			agent.clear_investigation()

		return SUCCESS

	return FAILURE
