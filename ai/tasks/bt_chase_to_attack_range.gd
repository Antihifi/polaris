@tool
extends BTAction
class_name BTChaseToAttackRange
## Move toward combat_target until within weapon attack range.
## Returns SUCCESS when in range, RUNNING while moving, FAILURE if no target.

@export var target_var: StringName = &"combat_target"
@export var range_buffer: float = 0.3  # Collision capsule radii (~0.25m per unit)
@export var ray_height: float = 1.2  # Chest level for clear shot check

## PERF: Track last target pos to avoid recalculating path every tick
var _last_target_pos: Vector3 = Vector3.INF
var _side_offset: float = 0.0  # Perpendicular offset when blocked


func _generate_name() -> String:
	return "ChaseToAttackRange"


func _enter() -> void:
	_last_target_pos = Vector3.INF
	_side_offset = 0.0


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target_ref: Variant = blackboard.get_var(target_var, null)
	if not is_instance_valid(target_ref):
		return FAILURE
	var target: Node3D = target_ref as Node3D

	# Get attack range from weapon or use default
	var attack_range: float = 2.5
	if "equipped_weapon" in agent and agent.equipped_weapon:
		attack_range = agent.equipped_weapon.attack_range
	elif "attack_range" in agent:
		attack_range = agent.attack_range

	var dist: float = agent.global_position.distance_to(target.global_position)

	# In range - stop moving and return success
	if dist <= attack_range + range_buffer:
		if agent.has_method("stop"):
			agent.stop()
		return SUCCESS

	# PERF: Only update navigation if target moved significantly (>1m)
	var target_moved := _last_target_pos.distance_to(target.global_position) > 1.0

	if target_moved:
		_last_target_pos = target.global_position

		var dir_to_target := (target.global_position - agent.global_position).normalized()
		dir_to_target.y = 0.0

		# Check if friendly blocks path - if so, offset sideways
		if _is_blocked_by_friendly(agent, target):
			# Alternate sides, increase offset each time
			_side_offset = 2.5 if _side_offset <= 0.0 else -(_side_offset + 1.0)
			var perp := Vector3(-dir_to_target.z, 0, dir_to_target.x)
			var offset := perp * _side_offset
			var attack_pos := target.global_position - dir_to_target * attack_range * 0.5 + offset
			if agent.has_method("move_to"):
				agent.move_to(attack_pos, true)
		else:
			_side_offset = 0.0
			var attack_pos := target.global_position - dir_to_target * attack_range * 0.5
			if agent.has_method("move_to"):
				agent.move_to(attack_pos, true)

	return RUNNING


func _is_blocked_by_friendly(agent: Node3D, target: Node3D) -> bool:
	var space_state := agent.get_world_3d().direct_space_state
	if not space_state:
		return false

	var from := agent.global_position + Vector3.UP * ray_height
	var to := target.global_position + Vector3.UP * ray_height

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 2
	query.exclude = [agent.get_rid(), target.get_rid()]

	var result := space_state.intersect_ray(query)
	if result.is_empty():
		return false

	var collider: Node3D = result.get("collider")
	if not collider:
		return false

	if collider.is_in_group("survivors"):
		# Skip dead
		if "stats" in collider and collider.stats and collider.stats.has_method("is_dead"):
			if collider.stats.is_dead():
				return false
		return true

	return false
