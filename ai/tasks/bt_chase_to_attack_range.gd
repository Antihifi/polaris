@tool
extends BTAction
class_name BTChaseToAttackRange
## Move toward combat_target until within weapon attack range.
## Returns SUCCESS when in range, RUNNING while moving, FAILURE if no target.

@export var target_var: StringName = &"combat_target"
@export var range_buffer: float = 2.0  # Extra distance to account for collision

## PERF: Track last target pos to avoid recalculating path every tick
var _last_target_pos: Vector3 = Vector3.INF


func _generate_name() -> String:
	return "ChaseToAttackRange"


func _enter() -> void:
	_last_target_pos = Vector3.INF


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target: Node3D = blackboard.get_var(target_var, null)
	if not target or not is_instance_valid(target):
		return FAILURE

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
		# Navigate toward target (pass true to indicate combat chase, don't disengage combat)
		if agent.has_method("move_to"):
			# Calculate position just within attack range
			var dir_to_target := (target.global_position - agent.global_position).normalized()
			var attack_pos := target.global_position - dir_to_target * attack_range * 0.5
			agent.move_to(attack_pos, true)  # is_combat_chase = true
		elif "navigation_agent" in agent and agent.navigation_agent:
			agent.navigation_agent.target_position = target.global_position

	return RUNNING
