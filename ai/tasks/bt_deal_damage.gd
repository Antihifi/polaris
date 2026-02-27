@tool
extends BTAction
class_name BTDealDamage
## Deal damage to combat_target. Returns SUCCESS after dealing damage, FAILURE if no valid target.

@export var target_var: StringName = &"combat_target"

var _axe_hit_sound: AudioStream = preload("res://sounds/axe_hit.mp3")


func _generate_name() -> String:
	return "DealDamage"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var target_ref: Variant = blackboard.get_var(target_var, null)
	if not is_instance_valid(target_ref):
		return FAILURE
	var target: Node3D = target_ref as Node3D

	# Check if target is dead
	if "is_dead" in target and target.is_dead:
		return FAILURE

	# Get damage from weapon or agent
	var damage: float = 10.0
	var weapon: WeaponStats = null

	# Try to get weapon via get_equipped_weapon() (ClickableUnit)
	if agent.has_method("get_equipped_weapon"):
		weapon = agent.get_equipped_weapon()

	if weapon:
		# Get strength from stats (default 75)
		var strength: float = 75.0
		if "stats" in agent and agent.stats and "current_strength" in agent.stats:
			strength = agent.stats.current_strength

		# Get damage modifier from traits
		var damage_mod: float = 1.0
		if agent.has_method("get_damage_modifier"):
			damage_mod = agent.get_damage_modifier()

		damage = weapon.get_damage(strength, damage_mod)
	elif "damage" in agent:
		# Fallback for animals
		damage = agent.damage

	# Deal damage (blood particles triggered by EquipmentAnimationComponent at 1.65s mark)
	if target.has_method("take_damage"):
		target.take_damage(damage, agent)

	# Play axe hit sound for hatchet strikes
	if weapon and weapon.id == &"hatchet":
		SoundManager.play_sound(_axe_hit_sound)

	return SUCCESS
