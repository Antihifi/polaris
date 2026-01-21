@tool
extends BTAction
class_name BTWalkToMarker
## Walks the agent to a Marker3D position smoothly (no teleport).
## Use instead of BTAlignWithMarker when you want natural movement to the final position.
## Returns RUNNING while walking, SUCCESS when arrived.

@export var marker_var: StringName = &"target_node"
@export var arrival_distance: float = 0.5  ## How close to get before considering arrived
@export var face_marker: bool = true  ## Face toward marker when arrived

var _walking: bool = false

func _generate_name() -> String:
	return "WalkToMarker [%s] (%.1fm)" % [marker_var, arrival_distance]


func _enter() -> void:
	_walking = false


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var marker: Node3D = blackboard.get_var(marker_var, null)
	if not marker or not is_instance_valid(marker):
		return FAILURE

	var marker_pos: Vector3 = marker.global_position

	# Check if arrived
	var dist: float = agent.global_position.distance_to(marker_pos)
	if dist < arrival_distance:
		# Stop and optionally face the marker
		if agent.has_method("stop"):
			agent.stop()

		if face_marker:
			# Orient toward marker (or Face child if present)
			var face_node: Node3D = marker.get_node_or_null("Face")
			if face_node:
				var dir := (face_node.global_position - agent.global_position).normalized()
				dir.y = 0
				if dir.length_squared() > 0.001:
					agent.rotation.y = atan2(dir.x, dir.z)
			else:
				# Face toward marker center
				var dir := (marker_pos - agent.global_position).normalized()
				dir.y = 0
				if dir.length_squared() > 0.001:
					agent.rotation.y = atan2(dir.x, dir.z)

		_walking = false
		return SUCCESS

	# Start walking if not already
	if not _walking and agent.has_method("move_to"):
		agent.move_to(marker_pos)
		_walking = true

	return RUNNING


func _exit() -> void:
	if _walking:
		var agent: Node3D = get_agent()
		if agent and agent.has_method("stop"):
			agent.stop()
	_walking = false
