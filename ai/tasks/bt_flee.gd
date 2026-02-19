@tool
extends BTAction
class_name BTFlee
## Flee away from a threat position stored in blackboard.

@export var threat_position_var: StringName = &"threat_position"
@export var flee_distance: float = 30.0
## If true, try to flee toward nearest heat source or shelter.
@export var prefer_safe_spots: bool = true

var _flee_target: Vector3 = Vector3.INF
var _fleeing: bool = false


func _generate_name() -> String:
	return "Flee [%.0fm]" % flee_distance


func _enter() -> void:
	_flee_target = Vector3.INF
	_fleeing = false


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Check if we're still supposed to be fleeing
	if "is_fleeing" in agent and not agent.is_fleeing:
		return SUCCESS  # Stopped fleeing (recovered composure)

	# Calculate flee target if not done
	if _flee_target == Vector3.INF:
		_flee_target = _calculate_flee_target(agent)
		if _flee_target == Vector3.INF:
			return FAILURE  # Nowhere to run

	# Check if we've reached safety
	var dist_to_target := agent.global_position.distance_to(_flee_target)
	if dist_to_target < 3.0:
		blackboard.set_var(&"current_action", "Escaped")
		if "stop" in agent:
			agent.stop()
		return SUCCESS

	# Keep moving
	if not _fleeing:
		if agent.has_method("move_to"):
			agent.move_to(_flee_target)
		_fleeing = true

	blackboard.set_var(&"current_action", "Fleeing!")
	return RUNNING


func _calculate_flee_target(agent: Node3D) -> Vector3:
	var threat_pos: Vector3 = blackboard.get_var(threat_position_var, Vector3.INF)

	# Try to find a safe spot first
	if prefer_safe_spots:
		var safe_spot := _find_nearest_safe_spot(agent)
		if safe_spot != Vector3.INF:
			return safe_spot

	# No safe spot or not preferred - flee away from threat
	if threat_pos != Vector3.INF:
		var flee_dir := (agent.global_position - threat_pos).normalized()
		flee_dir.y = 0.0
		if flee_dir.length_squared() < 0.01:
			flee_dir = Vector3(randf() - 0.5, 0, randf() - 0.5).normalized()
		return agent.global_position + flee_dir * flee_distance

	# No threat position - just run somewhere
	var random_dir := Vector3(randf() - 0.5, 0, randf() - 0.5).normalized()
	return agent.global_position + random_dir * flee_distance


func _find_nearest_safe_spot(agent: Node3D) -> Vector3:
	var best_pos := Vector3.INF
	var best_dist := INF
	var tree := agent.get_tree()

	# Check heat sources (fires)
	for node in tree.get_nodes_in_group("heat_sources"):
		if not node is Node3D:
			continue
		var dist := agent.global_position.distance_to(node.global_position)
		if dist < best_dist and dist < flee_distance * 2.0:
			best_dist = dist
			best_pos = node.global_position

	# Check shelters
	for node in tree.get_nodes_in_group("shelters"):
		if not node is Node3D:
			continue
		var dist := agent.global_position.distance_to(node.global_position)
		if dist < best_dist and dist < flee_distance * 2.0:
			best_dist = dist
			best_pos = node.global_position

	return best_pos
