@tool
extends BTCondition
class_name BTHasClearShot
## Condition: Check if agent has a clear line of attack to target.
## Raycasts from agent to target - fails if a friendly is in the path.
## Works for melee, ranged, and thrown weapons.

@export var target_var: StringName = &"combat_target"
## Height offset for raycast origin (chest level)
@export var ray_height: float = 1.2


func _generate_name() -> String:
	return "HasClearShot?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target_ref: Variant = blackboard.get_var(target_var, null)
	if not is_instance_valid(target_ref):
		return FAILURE
	var target: Node3D = target_ref as Node3D

	# Get physics space for raycasting
	var space_state := agent.get_world_3d().direct_space_state
	if not space_state:
		return SUCCESS  # Can't check, assume clear

	# Raycast from agent chest to target chest
	var from := agent.global_position + Vector3.UP * ray_height
	var to := target.global_position + Vector3.UP * ray_height

	var query := PhysicsRayQueryParameters3D.create(from, to)
	# Only check against units (layer 2)
	query.collision_mask = 2
	# Exclude self and target from the check
	query.exclude = [agent.get_rid(), target.get_rid()]

	var result := space_state.intersect_ray(query)

	if result.is_empty():
		return SUCCESS  # Path is clear

	# Something is in the way - check if it's a friendly
	var collider: Node3D = result.get("collider")
	if not collider:
		return SUCCESS  # Unknown obstacle, assume clear

	# Check if collider is in survivors group (friendly)
	if collider.is_in_group("survivors"):
		# Skip dead/downed units
		if "stats" in collider and collider.stats and collider.stats.has_method("is_dead"):
			if collider.stats.is_dead():
				return SUCCESS
		# Living friendly in the way - can't attack
		return FAILURE

	# Non-friendly obstacle (enemy, animal) - can attack through/past
	return SUCCESS
