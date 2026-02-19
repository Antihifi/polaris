@tool
extends BTCondition
class_name BTDefend
## Condition that checks if unit was attacked and should defend.
## If true, sets the attacker as combat_target in blackboard.

@export var target_var: StringName = &"combat_target"


func _generate_name() -> String:
	return "WasAttacked?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Check if we have a last_attacker set
	if not "last_attacker" in agent:
		return FAILURE

	var attacker: Node3D = agent.last_attacker
	if not attacker or not is_instance_valid(attacker):
		return FAILURE

	# Don't defend if already in combat
	if "is_in_combat" in agent and agent.is_in_combat:
		return FAILURE

	# Don't defend if we're fleeing
	if "is_fleeing" in agent and agent.is_fleeing:
		return FAILURE

	# Check if attacker is still a threat (alive and nearby)
	if _is_target_dead(attacker):
		return FAILURE

	var dist := agent.global_position.distance_to(attacker.global_position)
	if dist > 30.0:  # Attacker ran away
		return FAILURE

	# Set attacker as target
	blackboard.set_var(target_var, attacker)
	blackboard.set_var(&"target_position", attacker.global_position)
	blackboard.set_var(&"current_action", "Defending")
	return SUCCESS


func _is_target_dead(target: Node3D) -> bool:
	if "stats" in target and target.stats:
		if target.stats.has_method("is_dead"):
			return target.stats.is_dead()
	if "health" in target:
		return target.health <= 0
	return false
