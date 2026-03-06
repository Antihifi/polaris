@tool
extends BTAction
class_name BTInvestigateMove
## Action: Move toward investigation target in increments.
## Moves ~20m at a time, then BT decides to continue or give up.

@export var investigate_distance: float = 20.0
@export var investigation_position_var: StringName = &"investigation_position"
@export var arrival_tolerance: float = 3.0
@export var stuck_timeout: float = 3.0
@export var stuck_threshold: float = 0.3  ## Minimum distance per second to not be "stuck"

var _investigate_pos: Vector3 = Vector3.INF
var _last_position: Vector3 = Vector3.INF
var _stuck_timer: float = 0.0


func _generate_name() -> String:
	return "InvestigateMove [%.0fm]" % investigate_distance


func _enter() -> void:
	_investigate_pos = Vector3.INF
	_last_position = Vector3.INF
	_stuck_timer = 0.0
	# Guard against null overrides from .tres serialization
	if stuck_timeout <= 0.0:
		stuck_timeout = 3.0
	if stuck_threshold <= 0.0:
		stuck_threshold = 0.3


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target_pos: Vector3 = blackboard.get_var(investigation_position_var, Vector3.INF)
	if target_pos == Vector3.INF:
		return FAILURE

	# Calculate investigation point on first tick
	if _investigate_pos == Vector3.INF:
		# Update target position from animal (may have moved)
		if agent.has_method("update_investigation_position"):
			agent.update_investigation_position()
			target_pos = agent.get_investigation_position() if agent.has_method("get_investigation_position") else target_pos

		var direction := (target_pos - agent.global_position).normalized()
		var distance_to_target := agent.global_position.distance_to(target_pos)

		# Move investigate_distance toward target, or directly to target if closer
		var move_dist := minf(investigate_distance, distance_to_target)
		_investigate_pos = agent.global_position + direction * move_dist

		# Start moving
		if agent.has_method("move_to"):
			agent.move_to(_investigate_pos)
		if agent.has_method("set_chasing"):
			agent.set_chasing(true)  # Use faster speed

	# Check if reached investigation point
	var dist := agent.global_position.distance_to(_investigate_pos)
	if dist < arrival_tolerance:
		if agent.has_method("set_chasing"):
			agent.set_chasing(false)
		return SUCCESS

	# Stuck detection - give up investigating
	if _last_position != Vector3.INF:
		var moved := agent.global_position.distance_to(_last_position)
		if moved < stuck_threshold * delta:
			_stuck_timer += delta
			if _stuck_timer >= stuck_timeout:
				if agent.has_method("set_chasing"):
					agent.set_chasing(false)
				return FAILURE
		else:
			_stuck_timer = 0.0
	_last_position = agent.global_position

	# Still moving
	return RUNNING


func _exit() -> void:
	var agent: Node3D = get_agent()
	if agent and agent.has_method("set_chasing"):
		agent.set_chasing(false)
