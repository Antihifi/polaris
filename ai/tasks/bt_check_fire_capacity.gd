@tool
extends BTAction
class_name BTCheckFireCapacity
## Fails if fire already has too many units nearby.
## Use before committing to a fire to prevent overcrowding.

@export var fire_node_var: StringName = &"target_node"
@export var max_units: int = 5
@export var check_radius: float = 6.0

func _generate_name() -> String:
	return "CheckFireCapacity [%s] (max %d)" % [fire_node_var, max_units]


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	var fire: Node3D = blackboard.get_var(fire_node_var, null)
	if not agent or not fire:
		return FAILURE

	var count: int = 0
	for survivor in agent.get_tree().get_nodes_in_group("survivors"):
		if survivor == agent:
			continue
		if not survivor is Node3D:
			continue
		if survivor.global_position.distance_to(fire.global_position) < check_radius:
			count += 1

	if count >= max_units:
		return FAILURE

	return SUCCESS
