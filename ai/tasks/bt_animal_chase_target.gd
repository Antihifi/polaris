@tool
extends BTAction
class_name BTAnimalChaseTarget
## Move toward threat_target until within attack range.

@export var threat_target_var: StringName = &"threat_target"
@export var stuck_timeout: float = 3.0
@export var stuck_threshold: float = 0.3  ## Minimum distance per second to not be "stuck"

var _last_position: Vector3 = Vector3.INF
var _stuck_timer: float = 0.0


func _generate_name() -> String:
	return "ChaseTarget"


func _enter() -> void:
	var agent: Node3D = get_agent()
	if agent and agent.has_method("set_chasing"):
		agent.set_chasing(true)
	_last_position = Vector3.INF
	_stuck_timer = 0.0
	# Guard against null overrides from .tres serialization
	if stuck_timeout <= 0.0:
		stuck_timeout = 3.0
	if stuck_threshold <= 0.0:
		stuck_threshold = 0.3


func _exit() -> void:
	var agent: Node3D = get_agent()
	if agent and agent.has_method("set_chasing"):
		agent.set_chasing(false)


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target_ref: Variant = blackboard.get_var(threat_target_var, null)
	if not is_instance_valid(target_ref):
		return FAILURE
	var target: Node3D = target_ref as Node3D

	var attack_range: float = agent.attack_range if "attack_range" in agent else 2.5
	var dist: float = agent.global_position.distance_to(target.global_position)

	# Buffer accounts for collision radii (bear ~2m + unit ~0.5m) - hitbox validates actual hit
	if dist <= attack_range + 2.5:
		return SUCCESS

	# Navigate toward target
	if agent.has_method("move_to"):
		agent.move_to(target.global_position)

	# Stuck detection - fail so BT re-evaluates
	if _last_position != Vector3.INF:
		var moved := agent.global_position.distance_to(_last_position)
		if moved < stuck_threshold * _delta:
			_stuck_timer += _delta
			if _stuck_timer >= stuck_timeout:
				return FAILURE
		else:
			_stuck_timer = 0.0
	_last_position = agent.global_position

	return RUNNING
