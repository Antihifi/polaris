@tool
extends BTAction
class_name BTCheckStuck
## Detects if the agent is stuck and nudges it sideways.

@export var stuck_threshold_seconds: float = 3.0
@export var nudge_distance: float = 0.5

var _last_position: Vector3 = Vector3.INF
var _stuck_time: float = 0.0

func _generate_name() -> String:
	return "CheckStuck (%.1fs)" % stuck_threshold_seconds


func _enter() -> void:
	_last_position = Vector3.INF
	_stuck_time = 0.0


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return SUCCESS

	# Only check when moving
	if "is_moving" in agent and not agent.is_moving:
		_stuck_time = 0.0
		_last_position = agent.global_position
		return SUCCESS

	# First tick - initialize position
	if _last_position == Vector3.INF:
		_last_position = agent.global_position
		return SUCCESS

	# Check movement progress
	var moved: float = agent.global_position.distance_to(_last_position)
	if moved < 0.1:
		_stuck_time += delta
		if _stuck_time >= stuck_threshold_seconds:
			# Nudge sideways and rotate
			var right: Vector3 = agent.transform.basis.x.normalized()
			agent.global_position += right * nudge_distance
			agent.rotation.y += deg_to_rad(90.0)
			_stuck_time = 0.0
			print("[BTCheckStuck] Nudged %s" % agent.name)
	else:
		_stuck_time = 0.0

	_last_position = agent.global_position
	return SUCCESS
