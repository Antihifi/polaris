@tool
extends BTAction
class_name BTFindBed
## Finds an available bed within a shelter and stores its markers.

@export var shelter_node_var: StringName = &"target_node"
@export var bed_marker_var: StringName = &"target_marker"
@export var bed_position_var: StringName = &"target_position"
@export var occupancy_distance: float = 2.5  ## Distance to check for other survivors

func _generate_name() -> String:
	return "FindBed in [%s]" % shelter_node_var


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Find beds in the "beds" group
	var beds: Array[Node] = agent.get_tree().get_nodes_in_group("beds")
	if beds.is_empty():
		return FAILURE

	# Find nearest unoccupied bed
	var nearest_bed: Node3D = null
	var nearest_dist := INF

	for bed in beds:
		if not bed is Node3D:
			continue

		# Check if bed is occupied (another survivor nearby)
		var occupied := false
		for survivor in agent.get_tree().get_nodes_in_group("survivors"):
			if survivor == agent:
				continue
			if not survivor is Node3D:
				continue
			var dist: float = bed.global_position.distance_to(survivor.global_position)
			if dist < occupancy_distance:  # Within threshold = occupied
				occupied = true
				break

		if occupied:
			continue

		var dist: float = agent.global_position.distance_to(bed.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_bed = bed

	if not nearest_bed:
		print("[BTFindBed] No unoccupied bed found for %s" % [agent.unit_name if "unit_name" in agent else "unit"])
		return FAILURE

	# Find foot_of__bed marker (note: double underscore in scene)
	var foot_marker: Marker3D = nearest_bed.find_child("foot_of__bed", true, false)
	if foot_marker:
		blackboard.set_var(bed_marker_var, foot_marker)
		blackboard.set_var(bed_position_var, foot_marker.global_position)
		print("[BTFindBed] %s found bed marker at %s" % [agent.unit_name if "unit_name" in agent else "unit", foot_marker.global_position])
	else:
		# Fallback to bed position
		blackboard.set_var(bed_position_var, nearest_bed.global_position)
		print("[BTFindBed] WARNING: No foot_of__bed marker in bed, using bed position %s" % nearest_bed.global_position)

	blackboard.set_var(&"current_action", "Seeking shelter")
	return SUCCESS
