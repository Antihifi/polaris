@tool
extends BTAction
class_name BTAttack
## Manages combat state. Chase/animate/damage logic is in the BT sequence.
## Sets is_in_combat on enter, clears on exit.

@export var target_var: StringName = &"combat_target"


func _generate_name() -> String:
	return "Attack [%s]" % target_var


func _enter() -> void:
	var agent: Node3D = get_agent()
	if not agent:
		return
	var target: Node3D = blackboard.get_var(target_var, null)
	# Use CombatComponent if available, otherwise try direct methods
	var combat = agent.get_node_or_null("CombatComponent")
	if combat:
		combat.start_combat(target)
	elif agent.has_method("attack_target"):
		agent.attack_target(target)


func _exit() -> void:
	# NOTE: Do NOT stop combat here! _exit() is called when BTAttack returns
	# SUCCESS/FAILURE, but combat should continue through the rest of the
	# sequence (chase → animate → damage). Combat only stops when:
	# - Target dies (handled by _tick returning SUCCESS)
	# - User gives move command (handled by move_to())
	# - Unit flees (handled by _tick returning FAILURE)
	pass


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target: Node3D = blackboard.get_var(target_var, null)

	# No target - fail
	if not target or not is_instance_valid(target):
		return FAILURE

	# Target is dead - success (combat won)
	if _is_target_dead(target):
		return SUCCESS

	# Agent is fleeing - fail (combat abandoned)
	if "is_fleeing" in agent and agent.is_fleeing:
		return FAILURE

	return SUCCESS  # Let BT sequence handle chase/animate/damage


func _is_target_dead(target: Node3D) -> bool:
	if "is_dead" in target:
		return target.is_dead
	if "stats" in target and target.stats:
		if target.stats.has_method("is_dead"):
			return target.stats.is_dead()
		if "health" in target.stats:
			return target.stats.health <= 0
	if "health" in target:
		return target.health <= 0
	return false
