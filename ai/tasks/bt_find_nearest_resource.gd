@tool
extends BTAction
class_name BTFindNearestResource
## Finds the nearest resource node in a group and stores it in the blackboard.

@export_enum("shelters", "heat_sources", "containers", "beds") var resource_group: String = "shelters"
@export var target_position_var: StringName = &"target_position"
@export var target_node_var: StringName = &"target_node"

func _generate_name() -> String:
	return "FindNearest [%s]" % resource_group


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		print("[BTFindResource] ERROR: No agent!")
		return FAILURE

	var nearest: Node3D = null
	var nearest_dist := INF

	var nodes := agent.get_tree().get_nodes_in_group(resource_group)
	for node in nodes:
		if not node is Node3D:
			continue
		var dist: float = agent.global_position.distance_to(node.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = node

	if nearest:
		print("[BTFindResource] Found %s at %s (dist=%.2f, group=%s had %d nodes)" % [
			nearest.name, nearest.global_position, nearest_dist, resource_group, nodes.size()])
		blackboard.set_var(target_position_var, nearest.global_position)
		blackboard.set_var(target_node_var, nearest)
		# Set action based on resource type
		match resource_group:
			"heat_sources":
				blackboard.set_var(&"current_action", "Seeking warmth")
			"shelters":
				blackboard.set_var(&"current_action", "Seeking shelter")
			"containers":
				blackboard.set_var(&"current_action", "Seeking supplies")
			_:
				blackboard.set_var(&"current_action", "Seeking " + resource_group)
		return SUCCESS

	print("[BTFindResource] No %s found (group had %d nodes)" % [resource_group, nodes.size()])
	return FAILURE
