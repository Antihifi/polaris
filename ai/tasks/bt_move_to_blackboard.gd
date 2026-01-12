@tool
extends BTAction
class_name BTMoveToBlackboard
## Moves the agent to a position stored in the blackboard.
## Includes stuck detection - gives up after stuck_timeout seconds of no progress.
##
## Uses same pattern as original bt_move_to_target.gd from commit 31c8cc1:
## - Check arrival distance FIRST before calling move_to
## - Only call move_to ONCE using _moving guard
## - Return RUNNING while moving

@export var target_var: StringName = &"target_position"
@export var arrival_distance: float = 3.0
@export var stuck_timeout: float = 3.0
@export var stuck_threshold: float = 0.3  # Minimum distance per second to not be "stuck"

var _moving: bool = false
var _last_position: Vector3 = Vector3.INF
var _stuck_timer: float = 0.0


func _generate_name() -> String:
	return "MoveTo [%s] (%.1fm)" % [target_var, arrival_distance]


func _enter() -> void:
	# Reset state when task starts - but DON'T call move_to here!
	_moving = false
	_stuck_timer = 0.0
	_last_position = Vector3.INF


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		print("[BTMoveTo] ERROR: No agent!")
		return FAILURE

	var target: Vector3 = blackboard.get_var(target_var, Vector3.INF)
	if target == Vector3.INF:
		print("[BTMoveTo] No target in blackboard")
		return FAILURE

	# Check arrival FIRST - before calling move_to
	var dist: float = agent.global_position.distance_to(target)
	if dist < arrival_distance:
		print("[BTMoveTo] Arrived at target (dist=%.2f < %.2f)" % [dist, arrival_distance])
		if agent.has_method("stop"):
			agent.stop()
		_moving = false
		return SUCCESS

	# Check if navigation gave up (is_moving became false externally)
	if _moving and "is_moving" in agent and not agent.is_moving:
		print("[BTMoveTo] Navigation gave up (is_moving=false)")
		if agent.has_method("stop"):
			agent.stop()
		_moving = false
		return SUCCESS

	# Only call move_to ONCE
	if not _moving and agent.has_method("move_to"):
		print("[BTMoveTo] Starting move to %s (dist=%.2f)" % [target, dist])
		agent.move_to(target)
		_moving = true
		_last_position = agent.global_position
		return RUNNING

	# Stuck detection: check if we've moved enough since last tick
	if _last_position != Vector3.INF:
		var moved: float = agent.global_position.distance_to(_last_position)
		var expected_movement: float = stuck_threshold * delta

		if moved < expected_movement:
			_stuck_timer += delta
			if _stuck_timer >= stuck_timeout:
				# We're stuck - stop and return success to try a new behavior
				if agent.has_method("stop"):
					agent.stop()
				_moving = false
				return SUCCESS
		else:
			# Making progress, reset timer
			_stuck_timer = 0.0

	_last_position = agent.global_position
	return RUNNING


func _exit() -> void:
	if _moving:
		var agent: Node3D = get_agent()
		if agent and agent.has_method("stop"):
			agent.stop()
	_moving = false
