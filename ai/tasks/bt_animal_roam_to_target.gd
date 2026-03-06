@tool
extends BTAction
class_name BTAnimalRoamToTarget
## Navigate to roam_target position. Returns SUCCESS when arrived.

@export var roam_target_var: StringName = &"roam_target"
@export var arrival_distance: float = 2.0
@export var stuck_timeout: float = 3.0
@export var stuck_threshold: float = 0.3  ## Minimum distance per second to not be "stuck"

var _last_position: Vector3 = Vector3.INF
var _stuck_timer: float = 0.0


func _generate_name() -> String:
	return "RoamToTarget"


func _enter() -> void:
	_last_position = Vector3.INF
	_stuck_timer = 0.0
	# Guard against null overrides from .tres serialization
	if stuck_timeout <= 0.0:
		stuck_timeout = 3.0
	if stuck_threshold <= 0.0:
		stuck_threshold = 0.3


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target: Vector3 = blackboard.get_var(roam_target_var, Vector3.INF)
	if target == Vector3.INF:
		return FAILURE

	var dist: float = agent.global_position.distance_to(target)
	if dist <= arrival_distance:
		return SUCCESS

	# Navigate toward target
	if agent.has_method("move_to"):
		agent.move_to(target)

	# Stuck detection - succeed so BT picks a new roam target next cycle
	if _last_position != Vector3.INF:
		var moved := agent.global_position.distance_to(_last_position)
		if moved < stuck_threshold * _delta:
			_stuck_timer += _delta
			if _stuck_timer >= stuck_timeout:
				return SUCCESS
		else:
			_stuck_timer = 0.0
	_last_position = agent.global_position

	return RUNNING
