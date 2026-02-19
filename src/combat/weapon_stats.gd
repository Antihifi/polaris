class_name WeaponStats extends Resource
## Defines weapon properties for combat damage calculation.

enum WeaponType {
	MELEE,
	RANGED
}

@export var id: StringName = &""
@export var display_name: String = ""
@export var weapon_type: WeaponType = WeaponType.MELEE

@export_category("Damage")
@export var min_damage: float = 3.0
@export var max_damage: float = 5.0
@export var attack_speed: float = 1.0  ## Seconds between attacks
@export var attack_range: float = 1.5  ## Meters

@export_category("Ranged Only")
@export var base_accuracy: float = 0.7  ## 0-1, modified by Shooting skill
@export var reload_time: float = 18.0   ## Seconds to reload

@export_category("Animation")
@export var attack_animation: String = "punching"


func get_damage(strength: float = 75.0, damage_modifier: float = 1.0) -> float:
	## Calculate damage with strength scaling and trait modifier.
	## Formula: base_damage * (0.8 + strength/250) * damage_modifier
	var base: float = randf_range(min_damage, max_damage)
	var strength_mult: float = 0.8 + strength / 250.0
	return base * strength_mult * damage_modifier


func get_accuracy(shooting_skill: float = 0.0, is_marksman: bool = false) -> float:
	## Calculate hit chance for ranged weapons.
	## Base accuracy + 2% per shooting skill level + 15% if marksman
	if weapon_type != WeaponType.RANGED:
		return 1.0  # Melee always hits

	var accuracy: float = base_accuracy
	accuracy += shooting_skill * 0.02
	if is_marksman:
		accuracy += 0.15
	return clampf(accuracy, 0.0, 0.95)  # Cap at 95%
