@tool
extends BTCondition
class_name BTEntityHasThreat
## Condition: Check if entity has a threat to respond to.
## Works for both animals (territorial) and men (reactive).
##
## Animals: Uses investigation target or finds nearby survivors.
## Men: Checks last_attacker, nearby bears, or hostile humans.

@export var threat_target_var: StringName = &"threat_target"
@export var close_range_check: float = 15.0  # Detection range


func _generate_name() -> String:
	return "HasThreat?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var is_territorial: bool = agent.is_territorial if "is_territorial" in agent else false

	if is_territorial:
		# === ANIMAL LOGIC (territorial predators) ===
		return _check_animal_threats(agent)
	else:
		# === MEN LOGIC (reactive, flee-first) ===
		return _check_human_threats(agent)


func _check_animal_threats(agent: Node3D) -> Status:
	## Original animal threat detection logic.
	# First check if we already have a threat target (from previous combat)
	var existing_target_ref: Variant = blackboard.get_var(threat_target_var)
	if is_instance_valid(existing_target_ref):
		var existing_target: Node3D = existing_target_ref as Node3D
		if _is_valid_target(existing_target):
			blackboard.set_var(&"threat_position", existing_target.global_position)
			return SUCCESS
		else:
			blackboard.set_var(threat_target_var, null)

	# Check if investigation target is close enough to attack
	if agent.has_method("get_investigation_target"):
		var investigation_target: Node3D = agent.get_investigation_target()
		if investigation_target and is_instance_valid(investigation_target):
			if _is_valid_target(investigation_target):
				var dist := agent.global_position.distance_to(investigation_target.global_position)
				var attack_range: float = agent.attack_range if "attack_range" in agent else 2.5
				if dist <= attack_range + 5.0:
					blackboard.set_var(threat_target_var, investigation_target)
					blackboard.set_var(&"threat_position", investigation_target.global_position)
					if agent.has_method("clear_investigation"):
						agent.clear_investigation()
					return SUCCESS

	# Fallback: Quick check for very close survivors
	var nearest: Node3D = _find_close_survivors(agent, close_range_check)
	if nearest:
		blackboard.set_var(threat_target_var, nearest)
		blackboard.set_var(&"threat_position", nearest.global_position)
		return SUCCESS

	return FAILURE


func _check_human_threats(agent: Node3D) -> Status:
	## Threat detection for men - checks multiple sources.
	# 1. Was attacked (last_attacker)
	if "last_attacker" in agent:
		var attacker: Node3D = agent.last_attacker
		if attacker and is_instance_valid(attacker) and _is_valid_target(attacker):
			blackboard.set_var(threat_target_var, attacker)
			blackboard.set_var(&"threat_position", attacker.global_position)
			return SUCCESS

	# 2. Nearby hostile animals (bears)
	var hostile_threat := _find_close_hostile(agent, close_range_check)
	if hostile_threat:
		blackboard.set_var(threat_target_var, hostile_threat)
		blackboard.set_var(&"threat_position", hostile_threat.global_position)
		return SUCCESS

	# 3. Nearby berserk/wendigo humans
	var hostile_human := _find_hostile_human(agent, close_range_check)
	if hostile_human:
		blackboard.set_var(threat_target_var, hostile_human)
		blackboard.set_var(&"threat_position", hostile_human.global_position)
		return SUCCESS

	return FAILURE


func _is_valid_target(target: Node3D) -> bool:
	## Check if target is alive and valid.
	if "stats" in target and target.stats and target.stats.has_method("is_dead"):
		return not target.stats.is_dead()
	if "health" in target:
		return target.health > 0
	return true


func _find_close_survivors(agent: Node3D, max_range: float) -> Node3D:
	## Find nearest survivor within range (for animals).
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


func _find_close_hostile(agent: Node3D, max_range: float) -> Node3D:
	## Find nearest hostile animal (bear) within range.
	var nearest: Node3D = null
	var nearest_dist := INF

	for node in agent.get_tree().get_nodes_in_group("hostile"):
		if not node is Node3D:
			continue
		if not _is_valid_target(node):
			continue

		var dist := agent.global_position.distance_to(node.global_position)
		if dist < max_range and dist < nearest_dist:
			nearest_dist = dist
			nearest = node

	return nearest


func _find_hostile_human(agent: Node3D, max_range: float) -> Node3D:
	## Find nearest berserk/wendigo human within range.
	var nearest: Node3D = null
	var nearest_dist := INF

	for node in agent.get_tree().get_nodes_in_group("survivors"):
		if node == agent:
			continue
		if not node is Node3D:
			continue

		# Check if berserk or wendigo
		var is_hostile := false
		if "is_berserk" in node and node.is_berserk:
			is_hostile = true
		if "is_wendigo" in node and node.is_wendigo:
			is_hostile = true
		if not is_hostile:
			continue

		if not _is_valid_target(node):
			continue

		var dist := agent.global_position.distance_to(node.global_position)
		if dist < max_range and dist < nearest_dist:
			nearest_dist = dist
			nearest = node

	return nearest
