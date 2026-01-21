@tool
extends BTAction
class_name BTAlignWithMarker
## Aligns the agent with a Marker3D stored in the blackboard.

@export var marker_var: StringName = &"target_node"
@export var face_away: bool = false

func _generate_name() -> String:
	var facing := "away" if face_away else "toward"
	return "AlignWith [%s] (%s)" % [marker_var, facing]


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var marker: Node3D = blackboard.get_var(marker_var, null)
	if not marker or not is_instance_valid(marker):
		return FAILURE

	# Validate marker position - reject if suspiciously near origin (likely invalid transform)
	var marker_pos: Vector3 = marker.global_position
	if marker_pos.length() < 1.0:
		push_warning("BTAlignWithMarker: Marker position near origin (%.2f, %.2f, %.2f) - likely invalid" % [
			marker_pos.x, marker_pos.y, marker_pos.z])
		return FAILURE

	# CRITICAL: Stop movement and physics BEFORE teleporting to prevent drift
	# Without this, the unit gets teleported then immediately physics pushes it away
	if agent.has_method("stop"):
		agent.stop()
	if "velocity" in agent:
		agent.velocity = Vector3.ZERO
	if "is_moving" in agent:
		agent.is_moving = false
	# Lock position during the stationary animation phase
	if "is_animation_locked" in agent:
		agent.is_animation_locked = true

	# Position at marker
	agent.global_position = marker_pos

	# Orient: use "Face" child if present, otherwise use marker rotation
	var face_node: Node3D = marker.get_node_or_null("Face")
	if face_node:
		var dir := (face_node.global_position - agent.global_position).normalized()
		dir.y = 0
		if dir.length_squared() > 0.001:
			agent.rotation.y = atan2(dir.x, dir.z)
	elif face_away:
		agent.rotation.y = marker.rotation.y + PI
	else:
		agent.rotation.y = marker.rotation.y

	return SUCCESS
