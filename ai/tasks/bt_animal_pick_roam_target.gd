@tool
extends BTAction
class_name BTAnimalPickRoamTarget
## Pick random point within roam radius. Sets roam_target in blackboard.

@export var roam_target_var: StringName = &"roam_target"
@export var roam_radius: float = 20.0


func _generate_name() -> String:
	return "PickRoamTarget [%.0fm]" % roam_radius


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Use agent's roam_radius if available (set by spawner), otherwise use exported default
	var radius: float = roam_radius
	if "roam_radius" in agent:
		radius = agent.roam_radius

	var offset := Vector3(
		randf_range(-radius, radius),
		0.0,
		randf_range(-radius, radius)
	)

	var target: Vector3 = agent.global_position + offset
	blackboard.set_var(roam_target_var, target)

	return SUCCESS
