@tool
extends BTAction
class_name BTFindNearestResource
## Finds the nearest resource node in a group and stores it in the blackboard.

@export_enum("shelters", "heat_sources", "containers", "barrels", "crates", "beds", "seats", "fire_positions", "barrel_positions", "bed_positions") var resource_group: String = "shelters"
@export var target_position_var: StringName = &"target_position"
@export var target_node_var: StringName = &"target_node"

func _generate_name() -> String:
	return "FindNearest [%s]" % resource_group


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		print("[BTFindResource] ERROR: No agent!")
		return FAILURE

	# If agent is already moving, don't interrupt with a new search
	# This prevents BTDynamicSelector re-evaluation from causing jitter mid-journey
	# NOTE: Do NOT check is_animation_locked here - it causes stale target contamination
	# when sequences are aborted (e.g., sitting at crate → seek food uses old seat target)
	var existing_target: Vector3 = blackboard.get_var(target_position_var, Vector3.INF)
	if existing_target != Vector3.INF:
		if "is_moving" in agent and agent.is_moving:
			return SUCCESS  # Already moving to target, don't change it

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

		# Skip occupied positions (another survivor within 1.5m OR already en-route)
		# The en-route check prevents race conditions at game start where multiple
		# units all pick the same "unoccupied" position simultaneously
		var occupied := false
		for survivor in agent.get_tree().get_nodes_in_group("survivors"):
			if survivor == agent:
				continue
			if not survivor is Node3D:
				continue
			# Check if already at position
			if survivor.global_position.distance_to(node.global_position) < 1.5:
				occupied = true
				break
			# Check if en-route to this position
			if "is_moving" in survivor and survivor.is_moving:
				var nav_agent: NavigationAgent3D = survivor.get_node_or_null("NavigationAgent3D")
				if nav_agent and nav_agent.target_position.distance_to(node.global_position) < 1.5:
					occupied = true
					break
		if occupied:
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
