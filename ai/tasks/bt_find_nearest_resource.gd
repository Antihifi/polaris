@tool
extends BTAction
class_name BTFindNearestResource
## Finds the nearest resource node in a group and stores it in the blackboard.

@export_enum("shelters", "heat_sources", "containers", "barrels", "crates", "beds", "seats") var resource_group: String = "shelters"
@export var target_position_var: StringName = &"target_position"
@export var target_node_var: StringName = &"target_node"

func _generate_name() -> String:
	return "FindNearest [%s]" % resource_group


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		print("[BTFindResource] ERROR: No agent!")
		return FAILURE

	# If agent is already moving OR locked in animation, don't interrupt with a new search
	# This prevents BTDynamicSelector re-evaluation from causing jitter or
	# overwriting targets during animation sequences (opening_a_lid, eating, etc.)
	var existing_target: Vector3 = blackboard.get_var(target_position_var, Vector3.INF)
	if existing_target != Vector3.INF:
		if "is_moving" in agent and agent.is_moving:
			return SUCCESS  # Already moving to target
		if "is_animation_locked" in agent and agent.is_animation_locked:
			return SUCCESS  # In animation phase, keep current target

	var nearest: Node3D = null
	var nearest_dist := INF

	# Check if agent is leashed (errant group - restricted to camp area)
	var is_leashed: bool = agent.has_method("is_leashed") and agent.is_leashed()

	var nodes := agent.get_tree().get_nodes_in_group(resource_group)
	for node in nodes:
		if not node is Node3D:
			continue

		# If leashed, only consider resources within leash boundary
		if is_leashed and agent.has_method("is_within_leash"):
			if not agent.is_within_leash(node.global_position):
				continue

		var dist: float = agent.global_position.distance_to(node.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = node

	if nearest:
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
			"barrels":
				blackboard.set_var(&"current_action", "Seeking food")
			"crates":
				blackboard.set_var(&"current_action", "Seeking equipment")
			_:
				blackboard.set_var(&"current_action", "Seeking " + resource_group)
		return SUCCESS

	return FAILURE
