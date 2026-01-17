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
var _frames_since_move_called: int = 0


func _generate_name() -> String:
	return "MoveTo [%s] (%.1fm)" % [target_var, arrival_distance]


var _current_target: Vector3 = Vector3.INF  # Track what target we're moving to

func _enter() -> void:
	# Check if agent is already moving/animating to the same target (re-entry from BTDynamicSelector)
	var agent: Node3D = get_agent()
	var target: Vector3 = blackboard.get_var(target_var, Vector3.INF)

	# Don't reset state if we're already working on this target
	if agent and _current_target != Vector3.INF and _current_target.distance_to(target) < 1.0:
		# Already moving to this target
		if "is_moving" in agent and agent.is_moving:
			return
		# Or in animation phase (already arrived, playing animations)
		if "is_animation_locked" in agent and agent.is_animation_locked:
			return

	# Fresh start - reset state
	_moving = false
	_stuck_timer = 0.0
	_last_position = Vector3.INF
	_frames_since_move_called = 0
	_current_target = Vector3.INF


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
		if agent.has_method("stop"):
			agent.stop()
		_moving = false
		return SUCCESS

	# Only call move_to ONCE
	if not _moving and agent.has_method("move_to"):
		agent.move_to(target)
		_moving = true
		_current_target = target  # Track what we're moving to
		_frames_since_move_called = 0
		_last_position = agent.global_position
		return RUNNING

	# Increment frame counter while moving
	_frames_since_move_called += 1

	# Check if navigation gave up - but ONLY after giving physics time to start!
	# We wait 3+ frames so the physics engine can process the move_to() call.
	if _moving and _frames_since_move_called > 3:
		if "is_moving" in agent and not agent.is_moving:
			if agent.has_method("stop"):
				agent.stop()
			_moving = false
			# Check if we actually arrived at the target
			if dist < arrival_distance:
				return SUCCESS
			else:
				return FAILURE  # Navigation gave up but we're not at target

	# Stuck detection: check if we've moved enough since last tick
	if _last_position != Vector3.INF:
		var moved: float = agent.global_position.distance_to(_last_position)
		var expected_movement: float = stuck_threshold * delta

		if moved < expected_movement:
			_stuck_timer += delta
			if _stuck_timer >= stuck_timeout:
				if agent.has_method("stop"):
					agent.stop()
				_moving = false
				# Check if we actually arrived at the target
				if dist < arrival_distance:
					return SUCCESS
				else:
					return FAILURE  # Stuck and not at target
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
