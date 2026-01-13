class_name SurvivorStats extends Resource
## Survival needs and skills for a survivor character.
## Values range from 0-100 where higher is better (except for specific cases).

## Death causes for tracking how a character died
enum DeathCause { NONE, STARVATION, EXHAUSTION, HYPOTHERMIA, VIOLENCE, SCURVY, LEAD_POISONING }

## Current death cause (set when entering dying state)
var dying_cause: DeathCause = DeathCause.NONE

## Health drain rate when in dying condition (per hour)
const DYING_HEALTH_DRAIN: float = 5.0

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
		# Energy is capped by health - can't have more energy than health allows
		var max_energy := get_max_energy()
		energy = clampf(value, 0.0, max_energy)

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
	## Returns true if any vital stat has reached 0 (actively dying)
	return hunger <= 0.0 or energy <= 0.0 or warmth <= 0.0


func is_critically_injured() -> bool:
	## Returns true if health is critically low
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


func get_dying_cause() -> DeathCause:
	## Returns the cause of dying state based on which stat hit 0 first
	if hunger <= 0.0:
		return DeathCause.STARVATION
	if energy <= 0.0:
		return DeathCause.EXHAUSTION
	if warmth <= 0.0:
		return DeathCause.HYPOTHERMIA
	return dying_cause  # Could be scurvy/lead/violence set externally


func get_hunger_drain_multiplier() -> float:
	## Returns hunger drain multiplier based on energy and warmth levels.
	## Low energy = body burning reserves faster.
	## Cold = body needs more calories to maintain temperature.
	var mult := 1.0

	# Energy cascade - low energy increases hunger
	if energy < 25.0:
		mult *= 2.5
	elif energy < 50.0:
		mult *= 1.5

	# Cold cascade - being cold increases hunger
	if warmth < 25.0:
		mult *= 2.0
	elif warmth < 50.0:
		mult *= 1.25

	return mult


func get_critical_state_multiplier() -> float:
	## Returns multiplier for health/morale drain based on critical stat count.
	## Multiple critical stats = cascading failure.
	var critical_count := 0
	if hunger < 25.0:
		critical_count += 1
	if energy < 25.0:
		critical_count += 1
	if warmth < 25.0:
		critical_count += 1

	match critical_count:
		2:
			return 2.0
		3:
			return 4.0
		_:
			return 1.0


func get_max_energy() -> float:
	## Maximum energy is limited by health. Low health = can't sustain high energy.
	## At 100% health, max energy is 100. At 50% health, max energy is ~75.
	## At 20% health, max energy is ~40. At 10% health, max energy is ~25.
	if health >= 80.0:
		return 100.0
	elif health >= 50.0:
		# Linear interpolation from 100 at health=80 to 75 at health=50
		return 75.0 + (health - 50.0) * (25.0 / 30.0)
	elif health >= 20.0:
		# Steeper drop: from 75 at health=50 to 40 at health=20
		return 40.0 + (health - 20.0) * (35.0 / 30.0)
	else:
		# Critical: from 40 at health=20 to 10 at health=0
		return 10.0 + health * (30.0 / 20.0)


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


func apply_hourly_decay(is_working: bool, is_in_shelter: bool, is_in_bed: bool, is_near_fire: bool,
		ambient_temperature: float, is_in_sunlight: bool = true) -> void:
	## Called once per in-game hour to update needs.
	## Uses cascading multipliers: low energy/warmth increase hunger drain, etc.

	# Hunger decay with cascading multiplier
	var hunger_drain := hunger_decay_rate * get_hunger_drain_multiplier()
	if is_working:
		hunger_drain *= 1.5  # Working makes you hungrier
	hunger -= hunger_drain

	# Warmth affected by environment
	var warmth_change: float = 0.0
	if is_near_fire:
		warmth_change += 5.0
	if is_in_shelter:
		warmth_change += 2.0
	if is_in_sunlight and not is_in_shelter:
		warmth_change += 1.0  # Sunlight provides minor warmth

	# Temperature effect (ambient_temperature in Celsius, negative in arctic)
	var cold_effect: float = (-ambient_temperature - 10.0) * 0.5  # Stronger effect below -10C
	cold_effect *= (1.0 - cold_resistance / 100.0)  # Resistance reduces effect

	# Nighttime doubles cold effect when below 0C
	if not is_in_sunlight and ambient_temperature < 0.0:
		cold_effect *= 2.0

	warmth_change -= maxf(cold_effect, 0.0)
	warmth += warmth_change

	# Energy management - affected by working, health, and other conditions
	var energy_change: float = 0.0
	if is_working:
		# Base working drain with cascading multiplier
		var work_drain := energy_decay_rate * get_energy_drain_multiplier()
		energy_change -= work_drain
	else:
		# Resting recovery
		var recovery := 3.0  # Base idle recovery
		if is_in_bed:
			recovery = 20.0  # Bed recovery (2X shelter rate)
		elif is_in_shelter:
			recovery = 10.0  # Tent recovery (~3.3x base)
			# TODO: Improved shelter gives 12.0
		if health < 50.0:
			recovery *= health / 50.0  # Reduced recovery when injured
		energy_change += recovery

	# Sunlight bonus to energy recovery
	if is_in_sunlight and not is_working:
		energy_change += 0.5

	# If energy exceeds max (health dropped), force it down
	var max_energy := get_max_energy()
	if energy > max_energy:
		energy_change -= minf(energy - max_energy, 5.0)

	energy += energy_change

	# Morale decay with critical state multiplier
	var morale_drain := morale_decay_rate * get_critical_state_multiplier()
	if is_starving() or is_freezing():
		morale_drain += 1.0  # Extra morale loss from suffering
	if not is_in_sunlight:
		morale_drain += 0.5  # Darkness is depressing (especially in winter)
	morale -= morale_drain

	# Dying condition - stats at 0 cause rapid health loss
	if is_dying():
		dying_cause = get_dying_cause()
		health -= DYING_HEALTH_DRAIN
	else:
		# Health damage from critical needs (slower than dying)
		if is_starving():
			health -= 2.0
		if is_freezing():
			health -= 3.0


func get_energy_drain_multiplier() -> float:
	## Returns how much faster energy drains based on current condition.
	## Poor health, hunger, or warmth = faster energy drain.
	var multiplier: float = 1.0

	# Low health increases drain significantly
	if health < 30.0:
		multiplier += 1.5  # 2.5x drain at very low health
	elif health < 60.0:
		multiplier += 0.75  # 1.75x drain at moderate health
	elif health < 80.0:
		multiplier += 0.25  # 1.25x drain

	# Hunger increases drain
	if is_starving():
		multiplier += 1.0
	elif is_hungry():
		multiplier += 0.5

	# Cold increases drain
	if is_freezing():
		multiplier += 1.0
	elif is_cold():
		multiplier += 0.5

	return multiplier


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
