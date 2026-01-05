class_name SurvivorStats extends Resource
## Survival needs and skills for a survivor character.
## Values range from 0-100 where higher is better (except for specific cases).

# Survival Needs (0-100, lower = worse condition)
@export_category("Needs")
@export_range(0.0, 100.0) var hunger: float = 100.0:
	set(value):
		hunger = clampf(value, 0.0, 100.0)

@export_range(0.0, 100.0) var warmth: float = 100.0:  # Inverse of cold - higher = warmer
	set(value):
		warmth = clampf(value, 0.0, 100.0)

@export_range(0.0, 100.0) var health: float = 100.0:
	set(value):
		health = clampf(value, 0.0, 100.0)

@export_range(0.0, 100.0) var morale: float = 75.0:
	set(value):
		morale = clampf(value, 0.0, 100.0)

@export_range(0.0, 100.0) var energy: float = 100.0:
	set(value):
		energy = clampf(value, 0.0, 100.0)

# Decay rates (per in-game hour)
@export_category("Decay Rates")
@export var hunger_decay_rate: float = 2.0  # Hunger decreases by this per hour
@export var energy_decay_rate: float = 1.5  # Energy decreases when working
@export var morale_decay_rate: float = 0.5  # Base morale decay

# Skills (0-100, higher = better)
@export_category("Skills")
@export_range(0.0, 100.0) var hunting_skill: float = 25.0
@export_range(0.0, 100.0) var construction_skill: float = 25.0
@export_range(0.0, 100.0) var medicine_skill: float = 25.0
@export_range(0.0, 100.0) var navigation_skill: float = 25.0
@export_range(0.0, 100.0) var survival_skill: float = 25.0

# Resistances (0-100, higher = more resistant)
@export_category("Resistances")
@export_range(0.0, 100.0) var cold_resistance: float = 25.0

# Physical attributes
@export_category("Physical")
@export var max_carry_weight: float = 50.0  # kg
@export var current_carry_weight: float = 0.0
@export var movement_speed_modifier: float = 1.0

# Thresholds for need states
const CRITICAL_THRESHOLD: float = 15.0
const LOW_THRESHOLD: float = 35.0
const COMFORTABLE_THRESHOLD: float = 65.0


func is_starving() -> bool:
	return hunger <= CRITICAL_THRESHOLD


func is_hungry() -> bool:
	return hunger <= LOW_THRESHOLD


func is_freezing() -> bool:
	return warmth <= CRITICAL_THRESHOLD


func is_cold() -> bool:
	return warmth <= LOW_THRESHOLD


func is_dying() -> bool:
	return health <= CRITICAL_THRESHOLD


func is_injured() -> bool:
	return health <= LOW_THRESHOLD


func is_depressed() -> bool:
	return morale <= LOW_THRESHOLD


func is_exhausted() -> bool:
	return energy <= CRITICAL_THRESHOLD


func is_tired() -> bool:
	return energy <= LOW_THRESHOLD


func is_dead() -> bool:
	return health <= 0.0


func get_work_efficiency() -> float:
	## Returns a multiplier for work speed based on current condition.
	## Range: 0.0 to 1.5
	var efficiency: float = 1.0

	# Hunger affects efficiency
	if is_starving():
		efficiency *= 0.3
	elif is_hungry():
		efficiency *= 0.7

	# Cold affects efficiency
	if is_freezing():
		efficiency *= 0.4
	elif is_cold():
		efficiency *= 0.75

	# Energy affects efficiency
	if is_exhausted():
		efficiency *= 0.2
	elif is_tired():
		efficiency *= 0.6

	# Morale affects efficiency
	if is_depressed():
		efficiency *= 0.7
	elif morale >= COMFORTABLE_THRESHOLD:
		efficiency *= 1.1

	# High morale bonus
	if morale >= 85.0:
		efficiency *= 1.15

	return clampf(efficiency, 0.0, 1.5)


func get_most_critical_need() -> String:
	## Returns the name of the most urgent need, or empty string if all okay.
	var needs: Dictionary = {
		"hunger": hunger,
		"warmth": warmth,
		"energy": energy,
		"health": health
	}

	var most_critical: String = ""
	var lowest_value: float = 100.0

	for need_name in needs:
		var value: float = needs[need_name]
		if value < lowest_value and value <= LOW_THRESHOLD:
			lowest_value = value
			most_critical = need_name

	return most_critical


func apply_hourly_decay(is_working: bool, is_in_shelter: bool, is_near_fire: bool, ambient_temperature: float) -> void:
	## Called once per in-game hour to update needs.

	# Hunger always decays
	var hunger_modifier: float = 1.0
	if is_working:
		hunger_modifier = 1.5  # Working makes you hungrier
	hunger -= hunger_decay_rate * hunger_modifier

	# Warmth affected by environment
	var warmth_change: float = 0.0
	if is_near_fire:
		warmth_change += 5.0
	if is_in_shelter:
		warmth_change += 2.0

	# Temperature effect (ambient_temperature in Celsius, negative in arctic)
	var cold_effect: float = (-ambient_temperature - 10.0) * 0.5  # Stronger effect below -10C
	cold_effect *= (1.0 - cold_resistance / 100.0)  # Resistance reduces effect
	warmth_change -= maxf(cold_effect, 0.0)

	warmth += warmth_change

	# Energy decays when working, recovers when resting
	if is_working:
		energy -= energy_decay_rate
	else:
		energy += energy_decay_rate * 0.5  # Slow passive recovery

	# Health damage from critical needs
	if is_starving():
		health -= 2.0
	if is_freezing():
		health -= 3.0

	# Morale decay
	morale -= morale_decay_rate
	if is_starving() or is_freezing():
		morale -= 1.0  # Extra morale loss from suffering


func eat_food(nutrition_value: float) -> void:
	hunger += nutrition_value


func rest(hours: float) -> void:
	energy += hours * 10.0


func warm_up(amount: float) -> void:
	warmth += amount


func heal(amount: float) -> void:
	health += amount


func boost_morale(amount: float) -> void:
	morale += amount


func damage_morale(amount: float) -> void:
	morale -= amount


func can_carry_more(weight: float) -> bool:
	return current_carry_weight + weight <= max_carry_weight


func get_remaining_carry_capacity() -> float:
	return max_carry_weight - current_carry_weight
