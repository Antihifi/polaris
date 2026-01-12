@tool
extends BTAction
class_name BTFindFoodContainer
## Finds the nearest container with food.

@export var output_position_var: StringName = &"target_position"
@export var output_node_var: StringName = &"target_node"

func _generate_name() -> String:
	return "FindFoodContainer"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var containers: Array[Node] = agent.get_tree().get_nodes_in_group("containers")
	var nearest: Node3D = null
	var nearest_dist := INF

	for container in containers:
		if not container is Node3D:
			continue

		# Check if container has food via StorageContainer child
		var storage: Node = container.find_child("StorageContainer", true, false)
		if not storage:
			continue

		# Check if storage has food
		if storage.has_method("has_food") and not storage.has_food():
			continue

		var dist: float = agent.global_position.distance_to(container.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = container

	if nearest:
		blackboard.set_var(output_position_var, nearest.global_position)
		blackboard.set_var(output_node_var, nearest)
		blackboard.set_var(&"current_action", "Seeking food")
		return SUCCESS

	return FAILURE
