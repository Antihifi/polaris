@tool
extends BTCondition
class_name BTAnimalHasThreat
## Condition: Check if animal has a target to attack.
## Uses event-driven detection (Area3D signals) - no expensive iteration.
## Falls back to investigation target if set, or checks for very close threats.

@export var threat_target_var: StringName = &"threat_target"
@export var close_range_check: float = 15.0  # Always check this close (cheap)


func _generate_name() -> String:
	return "HasThreat?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var is_territorial: bool = agent.is_territorial if "is_territorial" in agent else false
	if not is_territorial:
		return FAILURE

	# First check if we already have a threat target (from previous combat)
	var existing_target: Node3D = blackboard.get_var(threat_target_var)
	if existing_target and is_instance_valid(existing_target):
		if _is_valid_target(existing_target):
			# Update position and keep target
			blackboard.set_var(&"threat_position", existing_target.global_position)
			return SUCCESS
		else:
			# Target died or invalid - clear it
			blackboard.set_var(threat_target_var, null)

	# Check if investigation target is close enough to attack
	if agent.has_method("get_investigation_target"):
		var investigation_target: Node3D = agent.get_investigation_target()
		if investigation_target and is_instance_valid(investigation_target):
			if _is_valid_target(investigation_target):
				var dist := agent.global_position.distance_to(investigation_target.global_position)
				var attack_range: float = agent.attack_range if "attack_range" in agent else 2.5
				if dist <= attack_range + 5.0:  # Close enough to attack
					blackboard.set_var(threat_target_var, investigation_target)
					blackboard.set_var(&"threat_position", investigation_target.global_position)
					if agent.has_method("clear_investigation"):
						agent.clear_investigation()
					return SUCCESS

	# Fallback: Quick check for very close survivors only (cheap - small radius)
	# This handles cases where Area3D didn't trigger (e.g., survivor spawned nearby)
	var nearest: Node3D = _find_close_threat(agent, close_range_check)
	if nearest:
		blackboard.set_var(threat_target_var, nearest)
		blackboard.set_var(&"threat_position", nearest.global_position)
		return SUCCESS

	return FAILURE


func _is_valid_target(target: Node3D) -> bool:
	## Check if target is alive and valid.
	if "stats" in target and target.stats and target.stats.has_method("is_dead"):
		return not target.stats.is_dead()
	return true


func _find_close_threat(agent: Node3D, max_range: float) -> Node3D:
	## Quick check for very close survivors only. Cheap since radius is small.
	var nearest: Node3D = null
	var nearest_dist := INF

	for node in agent.get_tree().get_nodes_in_group("survivors"):
		if not node is Node3D:
			continue
		if not _is_valid_target(node):
			continue

		var dist: float = agent.global_position.distance_to(node.global_position)
		if dist < max_range and dist < nearest_dist:
			nearest_dist = dist
			nearest = node

	return nearest
