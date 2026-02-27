@tool
extends BTAction
class_name BTFlee
## Flee away from a threat position stored in blackboard.

@export var threat_position_var: StringName = &"threat_position"
@export var flee_distance: float = 30.0
@export var stuck_timeout: float = 2.0
@export var stuck_threshold: float = 0.3  # Minimum distance per second to not be "stuck"

var _flee_target: Vector3 = Vector3.INF
var _fleeing: bool = false
var _last_position: Vector3 = Vector3.INF
var _stuck_timer: float = 0.0
var _recalc_attempts: int = 0
var _monitoring: bool = false  # Reached safety, watching threat


func _generate_name() -> String:
	return "Flee [%.0fm]" % flee_distance


func _enter() -> void:
	_flee_target = Vector3.INF
	_fleeing = false
	_last_position = Vector3.INF
	_stuck_timer = 0.0
	_recalc_attempts = 0
	_monitoring = false


func _exit() -> void:
	var agent: Node3D = get_agent()
	if agent:
		_reset_speed(agent)


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Check if threat is gone (dead or far away) - stop fleeing
	# If no threat_target (e.g., fleeing from dismemberment), skip threat checks
	var threat_target_ref: Variant = blackboard.get_var(&"threat_target", null)
	if is_instance_valid(threat_target_ref):
		var threat_target: Node3D = threat_target_ref as Node3D
		if _is_threat_dead(threat_target):
			_reset_speed(agent)
			if agent.has_method("stop"):
				agent.stop()
			return SUCCESS
		var threat_dist := agent.global_position.distance_to(threat_target.global_position)
		if threat_dist > flee_distance * 2.0:
			_reset_speed(agent)
			if agent.has_method("stop"):
				agent.stop()
			return SUCCESS

		# Monitoring: reached safety, watch threat. Re-flee if it closes in.
		if _monitoring:
			if threat_dist < flee_distance * 0.5:
				# Threat approaching — flee again
				_monitoring = false
				_flee_target = Vector3.INF
				_fleeing = false
			else:
				# Idle, face threat
				if agent.has_method("stop"):
					agent.stop()
				var look_dir := threat_target.global_position - agent.global_position
				look_dir.y = 0.0
				if look_dir.length_squared() > 0.01:
					agent.rotation.y = atan2(look_dir.x, look_dir.z)
				blackboard.set_var(&"current_action", "Watching threat")
				return RUNNING

	# In melee combat - must fight, can't flee
	if "is_in_combat" in agent and agent.is_in_combat:
		_reset_speed(agent)
		return SUCCESS

	# Calculate flee target if not done
	if _flee_target == Vector3.INF:
		_flee_target = _calculate_flee_target(agent)
		if _flee_target == Vector3.INF:
			return FAILURE  # Nowhere to run

	# Check if we've reached safety — enter monitoring instead of returning SUCCESS
	var dist_to_target := agent.global_position.distance_to(_flee_target)
	if dist_to_target < 3.0:
		_reset_speed(agent)
		if agent.has_method("stop"):
			agent.stop()
		_monitoring = true
		blackboard.set_var(&"current_action", "Escaped")
		return RUNNING

	# Keep moving
	if not _fleeing:
		if agent.has_method("move_to"):
			agent.move_to(_flee_target)
		_fleeing = true
		_last_position = agent.global_position

	# Stuck detection - recalculate flee target or give up
	if _last_position != Vector3.INF:
		var moved := agent.global_position.distance_to(_last_position)
		# Lower threshold for crawling units so they don't falsely trigger stuck
		var effective_threshold: float = stuck_threshold
		if "legs_remaining" in agent and agent.legs_remaining < 2:
			effective_threshold = 0.02  # Crawling is very slow, ~0.15 m/s
		var expected := effective_threshold * _delta
		if moved < expected:
			_stuck_timer += _delta
			if _stuck_timer >= stuck_timeout:
				_recalc_attempts += 1
				if _recalc_attempts >= 3:
					# Tried 3 times, give up — enter monitoring
					_reset_speed(agent)
					if agent.has_method("stop"):
						agent.stop()
					_monitoring = true
					blackboard.set_var(&"current_action", "Escaped")
					return RUNNING
				# Try a different escape direction
				_flee_target = _calculate_flee_target_offset(agent, _recalc_attempts)
				_fleeing = false
				_stuck_timer = 0.0
		else:
			_stuck_timer = 0.0
	_last_position = agent.global_position

	blackboard.set_var(&"current_action", "Fleeing!")
	return RUNNING


func _calculate_flee_target(agent: Node3D) -> Vector3:
	var threat_pos: Vector3 = blackboard.get_var(threat_position_var, Vector3.INF)

	if threat_pos != Vector3.INF:
		var flee_dir := (agent.global_position - threat_pos).normalized()
		flee_dir.y = 0.0
		if flee_dir.length_squared() < 0.01:
			flee_dir = Vector3(randf() - 0.5, 0, randf() - 0.5).normalized()
		return agent.global_position + flee_dir * flee_distance

	# No threat position - just run somewhere
	var random_dir := Vector3(randf() - 0.5, 0, randf() - 0.5).normalized()
	return agent.global_position + random_dir * flee_distance


func _calculate_flee_target_offset(agent: Node3D, attempt: int) -> Vector3:
	## Calculate flee target with offset angle for stuck recovery.
	## Attempt 1: 45 degrees right, Attempt 2: 45 degrees left
	var threat_pos: Vector3 = blackboard.get_var(threat_position_var, Vector3.INF)
	var flee_dir: Vector3

	if threat_pos != Vector3.INF:
		flee_dir = (agent.global_position - threat_pos).normalized()
	else:
		flee_dir = Vector3(randf() - 0.5, 0, randf() - 0.5).normalized()

	flee_dir.y = 0.0
	if flee_dir.length_squared() < 0.01:
		flee_dir = Vector3.FORWARD

	# Rotate direction by 45-90 degrees based on attempt
	var angle := PI / 4.0 * attempt  # 45, 90 degrees
	if attempt % 2 == 0:
		angle = -angle  # Alternate left/right
	var rotated := Vector3(
		flee_dir.x * cos(angle) - flee_dir.z * sin(angle),
		0.0,
		flee_dir.x * sin(angle) + flee_dir.z * cos(angle)
	).normalized()

	return agent.global_position + rotated * flee_distance


func _reset_speed(agent: Node3D) -> void:
	if "speed_multiplier" in agent:
		agent.speed_multiplier = 1.0


func _is_threat_dead(target: Node3D) -> bool:
	if "stats" in target and target.stats and target.stats.has_method("is_dead"):
		return target.stats.is_dead()
	if "health" in target:
		return target.health <= 0
	return false
