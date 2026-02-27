@tool
extends BTAction
class_name BTFindEnemy
## Finds the nearest enemy target and stores it in the blackboard.

@export_enum("hostile", "survivor", "animal") var target_type: String = "hostile"
@export var target_var: StringName = &"combat_target"
@export var target_position_var: StringName = &"target_position"
## Maximum search distance in meters. 0 = unlimited.
@export var detection_range: float = 15.0
## If true, prioritize weakest (lowest HP) target instead of nearest.
@export var prioritize_weak: bool = false


func _generate_name() -> String:
	var name_str := "FindEnemy [%s]" % target_type
	if detection_range > 0.0:
		name_str += " (%.0fm)" % detection_range
	if prioritize_weak:
		name_str += " [weak]"
	return name_str


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Check if target already set in blackboard (by attack_target() or previous find)
	if blackboard.has_var(target_var):
		var existing_ref: Variant = blackboard.get_var(target_var, null)
		if is_instance_valid(existing_ref):
			var existing: Node3D = existing_ref as Node3D
			if not _is_target_dead(existing):
				return SUCCESS
			else:
				blackboard.set_var(target_var, null)

	# Officers/Captain only engage when player explicitly commands - don't auto-find targets
	if "rank" in agent and agent.rank >= 1:  # OFFICER=1, CAPTAIN=2
		return FAILURE

	var targets: Array[Node3D] = []

	match target_type:
		"hostile":
			# Find hostile animals and broken men
			targets = _find_hostiles(agent)
		"survivor":
			# Find other survivors (for berserk/wendigo behavior)
			targets = _find_survivors(agent)
		"animal":
			# Find only animals
			targets = _find_animals(agent)

	if targets.is_empty():
		blackboard.set_var(&"current_action", "No targets")
		return FAILURE

	# Select best target
	var best: Node3D = null
	if prioritize_weak:
		best = _select_weakest(targets)
	else:
		best = _select_nearest(agent, targets)

	if not best:
		return FAILURE

	blackboard.set_var(target_var, best)
	blackboard.set_var(target_position_var, best.global_position)
	blackboard.set_var(&"current_action", "Engaging target")
	return SUCCESS


func _find_hostiles(agent: Node3D) -> Array[Node3D]:
	var result: Array[Node3D] = []
	var tree := agent.get_tree()

	# Animals in hostile group
	for node in tree.get_nodes_in_group("hostile"):
		if _is_valid_target(agent, node):
			result.append(node)

	# Broken men (berserk/wendigo) - they attack others, so they're hostile
	for node in tree.get_nodes_in_group("survivors"):
		if node == agent:
			continue
		if not node is Node3D:
			continue
		if "is_berserk" in node and node.is_berserk:
			if _is_valid_target(agent, node):
				result.append(node)
		elif "is_wendigo" in node and node.is_wendigo:
			if _is_valid_target(agent, node):
				result.append(node)

	return result


func _find_survivors(agent: Node3D) -> Array[Node3D]:
	var result: Array[Node3D] = []
	for node in agent.get_tree().get_nodes_in_group("survivors"):
		if node == agent:
			continue
		if _is_valid_target(agent, node):
			result.append(node)
	return result


func _find_animals(agent: Node3D) -> Array[Node3D]:
	var result: Array[Node3D] = []
	for node in agent.get_tree().get_nodes_in_group("animals"):
		if _is_valid_target(agent, node):
			result.append(node)
	return result


func _is_valid_target(agent: Node3D, target: Node3D) -> bool:
	if not target or not is_instance_valid(target):
		return false
	if not target is Node3D:
		return false

	# Check distance
	var dist := agent.global_position.distance_to(target.global_position)
	if detection_range > 0.0 and dist > detection_range:
		return false

	# Check if target is dead
	if "stats" in target and target.stats and target.stats.has_method("is_dead"):
		if target.stats.is_dead():
			return false
	if "health" in target and target.health <= 0:
		return false

	return true


func _select_nearest(agent: Node3D, targets: Array[Node3D]) -> Node3D:
	var best: Node3D = null
	var best_dist := INF
	for target in targets:
		var dist := agent.global_position.distance_to(target.global_position)
		if dist < best_dist:
			best_dist = dist
			best = target
	return best


func _select_weakest(targets: Array[Node3D]) -> Node3D:
	var best: Node3D = null
	var best_hp := INF
	for target in targets:
		var hp := 100.0
		if "stats" in target and target.stats and "health" in target.stats:
			hp = target.stats.health
		elif "health" in target:
			hp = target.health
		if hp < best_hp:
			best_hp = hp
			best = target
	return best


func _is_target_dead(target: Node3D) -> bool:
	if "is_dead" in target:
		return target.is_dead
	if "stats" in target and target.stats:
		if target.stats.has_method("is_dead"):
			return target.stats.is_dead()
		if "health" in target.stats:
			return target.stats.health <= 0
	if "health" in target:
		return target.health <= 0
	return false
