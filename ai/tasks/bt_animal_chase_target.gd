@tool
extends BTAction
class_name BTAnimalChaseTarget
## Move toward threat_target until within attack range.

@export var threat_target_var: StringName = &"threat_target"


func _generate_name() -> String:
	return "ChaseTarget"


func _enter() -> void:
	var agent: Node3D = get_agent()
	if agent and agent.has_method("set_chasing"):
		agent.set_chasing(true)


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

	return RUNNING
