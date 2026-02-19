@tool
extends BTAction
class_name BTAnimalDealDamage
## Apply damage to threat_target. Single hit, returns SUCCESS.

@export var threat_target_var: StringName = &"threat_target"


func _generate_name() -> String:
	return "DealDamage"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target: Node3D = blackboard.get_var(threat_target_var, null)
	if not target or not is_instance_valid(target):
		return FAILURE

	# Validate target is in attack hitbox (if hitbox exists)
	if "attack_hitbox" in agent and agent.attack_hitbox:
		var overlapping: Array = agent.attack_hitbox.get_overlapping_bodies()
		if target not in overlapping:
			return FAILURE  # Target escaped hitbox, need to chase again

	var damage: float = agent.damage if "damage" in agent else 10.0

	if target.has_method("take_damage"):
		target.take_damage(damage, agent)

	return SUCCESS
