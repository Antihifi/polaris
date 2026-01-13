@tool
extends BTAction
class_name BTFindSeat
## Finds an available seat point on a container (barrel/crate).

@export var output_position_var: StringName = &"target_position"
@export var output_marker_var: StringName = &"target_marker"
@export var min_spacing: float = 2.0

func _generate_name() -> String:
	return "FindSeat (%.1fm apart)" % min_spacing


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var survivors: Array[Node] = agent.get_tree().get_nodes_in_group("survivors")
	var containers: Array[Node] = agent.get_tree().get_nodes_in_group("containers")

	var best_seat: Marker3D = null
	var best_dist := INF

	for container in containers:
		if not container is Node3D:
			continue

		# Find SeatPoints node
		var seat_points: Node = container.find_child("SeatPoints", true, false)
		if not seat_points:
			continue

		# Check each seat marker
		for child in seat_points.get_children():
			if not child is Marker3D:
				continue

			var seat_pos: Vector3 = child.global_position

			# Skip seats with invalid positions (near origin = likely bad transform)
			if seat_pos.length() < 1.0:
				continue

			# Check if occupied
			var occupied := false
			for survivor in survivors:
				if survivor == agent:
					continue
				if not survivor is Node3D:
					continue
				if seat_pos.distance_to(survivor.global_position) < min_spacing:
					occupied = true
					break

			if occupied:
				continue

			var dist: float = agent.global_position.distance_to(seat_pos)
			if dist < best_dist:
				best_dist = dist
				best_seat = child

	if best_seat:
		blackboard.set_var(output_position_var, best_seat.global_position)
		blackboard.set_var(output_marker_var, best_seat)
		blackboard.set_var(&"current_action", "Sitting on crate")
		return SUCCESS

	return FAILURE
