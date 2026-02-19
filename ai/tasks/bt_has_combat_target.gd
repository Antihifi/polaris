@tool
extends BTCondition
class_name BTHasCombatTarget
## Returns SUCCESS if agent has a valid combat target.
## Sets combat_target in blackboard for BTAttack to use.

@export var target_var: StringName = &"combat_target"


func _generate_name() -> String:
	return "HasCombatTarget?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# First check if BTFindEnemy already found a target in blackboard
	var bb_target: Node3D = blackboard.get_var(target_var, null)
	if bb_target and is_instance_valid(bb_target):
		if not _is_target_dead(bb_target):
			return SUCCESS

	# Then check agent's combat target (set by attack command or auto-defend)
	if not "_combat_target" in agent:
		return FAILURE

	var target: Node3D = agent._combat_target
	if not target or not is_instance_valid(target):
		return FAILURE

	if _is_target_dead(target):
		return FAILURE

	# Set target in blackboard for BTAttack to use
	blackboard.set_var(target_var, target)
	return SUCCESS


func _is_target_dead(target: Node3D) -> bool:
	if "is_dead" in target and target.is_dead:
		return true
	if "stats" in target and target.stats:
		if target.stats.has_method("is_dead") and target.stats.is_dead():
			return true
	return false
