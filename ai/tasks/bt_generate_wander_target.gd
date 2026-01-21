@tool
extends BTAction
class_name BTGenerateWanderTarget
## Generates a random wander target within a radius.
## Respects leash boundary for errant units (undiscovered groups).

@export var output_var: StringName = &"target_position"
@export var wander_radius: float = 10.0

func _generate_name() -> String:
	return "GenerateWander (%.0fm)" % wander_radius


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Random angle and distance
	var angle: float = randf() * TAU
	var distance: float = randf_range(3.0, wander_radius)

	var offset := Vector3(cos(angle), 0, sin(angle)) * distance
	var target: Vector3 = agent.global_position + offset

	# Constrain to leash boundary if agent is leashed (errant group)
	if agent.has_method("is_leashed") and agent.is_leashed():
		if agent.has_method("get_leash_constrained_position"):
			target = agent.get_leash_constrained_position(target)

	# NOTE: NavMesh validation REMOVED - full terrain bake ensures complete coverage
	# No need to snap targets to NavMesh anymore

	blackboard.set_var(output_var, target)
	blackboard.set_var(&"current_action", "Wandering")
	return SUCCESS
