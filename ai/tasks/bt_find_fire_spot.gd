@tool
extends BTAction
class_name BTFindFireSpot
## Finds an empty spot around a fire (no other unit within min_spacing).

@export var fire_node_var: StringName = &"target_node"
@export var output_position_var: StringName = &"target_position"
@export var fire_position_var: StringName = &"fire_position"  ## Store fire pos for BTFaceTarget
@export var fire_distance: float = 4.0
@export var min_spacing: float = 2.5

func _generate_name() -> String:
	return "FindFireSpot (%.1fm apart)" % min_spacing


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	var fire: Node3D = blackboard.get_var(fire_node_var, null)

	if not agent or not fire:
		return FAILURE

	# Get all survivors to check spacing
	var survivors: Array[Node] = agent.get_tree().get_nodes_in_group("survivors")

	# Try 8 positions around the fire
	for i in range(8):
		var angle: float = i * TAU / 8.0
		var offset := Vector3(cos(angle), 0, sin(angle)) * fire_distance
		var candidate: Vector3 = fire.global_position + offset

		# Check if any other unit is too close
		var too_close := false
		for survivor in survivors:
			if survivor == agent:
				continue
			if not survivor is Node3D:
				continue
			var dist: float = candidate.distance_to(survivor.global_position)
			if dist < min_spacing:
				too_close = true
				break

		if not too_close:
			blackboard.set_var(output_position_var, candidate)
			blackboard.set_var(fire_position_var, fire.global_position)  # For BTFaceTarget
			blackboard.set_var(&"current_action", "Warming by fire")
			return SUCCESS

	# No empty spot found - just use fire position with random offset
	var random_angle: float = randf() * TAU
	var fallback: Vector3 = fire.global_position + Vector3(cos(random_angle), 0, sin(random_angle)) * fire_distance
	blackboard.set_var(output_position_var, fallback)
	blackboard.set_var(fire_position_var, fire.global_position)  # For BTFaceTarget
	blackboard.set_var(&"current_action", "Warming by fire")
	return SUCCESS
