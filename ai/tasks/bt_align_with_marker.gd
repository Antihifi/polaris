@tool
extends BTAction
class_name BTAlignWithMarker
## Aligns the agent with a Marker3D stored in the blackboard.

@export var marker_var: StringName = &"target_marker"
@export var face_away: bool = false

func _generate_name() -> String:
	var facing := "away" if face_away else "toward"
	return "AlignWith [%s] (%s)" % [marker_var, facing]


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var marker: Marker3D = blackboard.get_var(marker_var, null)
	if not marker or not is_instance_valid(marker):
		return FAILURE

	# Validate marker position - reject if suspiciously near origin (likely invalid transform)
	var marker_pos: Vector3 = marker.global_position
	if marker_pos.length() < 1.0:
		push_warning("BTAlignWithMarker: Marker position near origin (%.2f, %.2f, %.2f) - likely invalid" % [
			marker_pos.x, marker_pos.y, marker_pos.z])
		return FAILURE

	# Position at marker
	agent.global_position = marker_pos

	# Orient based on marker rotation
	if face_away:
		agent.rotation.y = marker.rotation.y + PI
	else:
		agent.rotation.y = marker.rotation.y

	return SUCCESS
