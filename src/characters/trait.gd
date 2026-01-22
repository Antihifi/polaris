class_name SurvivorTrait extends Resource
## Defines a permanent character trait that modifies stats and behavior.

enum TraitType {
	PERSONALITY,  # Affects behavior and morale
	PHYSICAL,     # Affects physical capabilities
	SKILL,        # Affects skill proficiency
	MENTAL        # Affects mental state and reactions
}

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var trait_type: TraitType = TraitType.PERSONALITY
@export var is_positive: bool = true  # For UI coloring

# Stat modifiers (multipliers, 1.0 = no change)
@export_category("Stat Modifiers")
@export var hunger_decay_modifier: float = 1.0      # >1 = consumes more food
@export var cold_resistance_modifier: float = 1.0   # >1 = more cold resistant
@export var energy_decay_modifier: float = 1.0      # >1 = tires faster
@export var morale_modifier: float = 1.0            # >1 = higher base morale
@export var carry_capacity_modifier: float = 1.0    # >1 = can carry more
@export var movement_speed_modifier: float = 1.0    # >1 = moves faster

# Skill modifiers (additive bonuses)
@export_category("Skill Bonuses")
@export var hunting_bonus: float = 0.0
@export var construction_bonus: float = 0.0
@export var medicine_bonus: float = 0.0
@export var navigation_bonus: float = 0.0
@export var survival_bonus: float = 0.0

# Combat modifiers
@export_category("Combat")
@export var damage_modifier: float = 1.0
@export var flees_combat: bool = false

# Social modifiers
@export_category("Social")
@export var morale_aura: float = 0.0        # Affects nearby survivors' morale
@export var trade_bonus: float = 0.0         # Better trade rates with natives

# Special behavior flags
@export_category("Behavior Flags")
@export var is_leader: bool = false          # Priority in conflicts
@export var can_trigger_mental_break: bool = false


static func create_drunkard() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "drunkard"
	new_trait.display_name = "Drunkard"
	new_trait.description = "Consumes 50% more rations. Gains morale bonus when alcohol is available."
	new_trait.trait_type = TraitType.MENTAL
	new_trait.is_positive = false
	new_trait.hunger_decay_modifier = 1.5
	new_trait.can_trigger_mental_break = true
	return new_trait


static func create_coward() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "coward"
	new_trait.display_name = "Coward"
	new_trait.description = "Flees from combat. Suffers morale penalty during dangerous situations."
	new_trait.trait_type = TraitType.PERSONALITY
	new_trait.is_positive = false
	new_trait.flees_combat = true
	new_trait.morale_modifier = 0.85
	return new_trait


static func create_combative() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "combative"
	new_trait.display_name = "Combative"
	new_trait.description = "Deals more damage in combat. Reduces morale of nearby survivors."
	new_trait.trait_type = TraitType.PERSONALITY
	new_trait.is_positive = false
	new_trait.damage_modifier = 1.3
	new_trait.morale_aura = -5.0
	new_trait.can_trigger_mental_break = true
	return new_trait


static func create_personable() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "personable"
	new_trait.display_name = "Personable"
	new_trait.description = "Boosts the morale of nearby survivors."
	new_trait.trait_type = TraitType.PERSONALITY
	new_trait.is_positive = true
	new_trait.morale_aura = 5.0
	return new_trait


static func create_affable() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "affable"
	new_trait.display_name = "Affable"
	new_trait.description = "Gets better trade deals with natives."
	new_trait.trait_type = TraitType.PERSONALITY
	new_trait.is_positive = true
	new_trait.trade_bonus = 0.2
	return new_trait


static func create_strong() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "strong"
	new_trait.display_name = "Strong"
	new_trait.description = "Can carry more weight and builds faster."
	new_trait.trait_type = TraitType.PHYSICAL
	new_trait.is_positive = true
	new_trait.carry_capacity_modifier = 1.5
	new_trait.construction_bonus = 15.0
	return new_trait


static func create_weak() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "weak"
	new_trait.display_name = "Weak"
	new_trait.description = "Reduced carry capacity and slower construction."
	new_trait.trait_type = TraitType.PHYSICAL
	new_trait.is_positive = false
	new_trait.carry_capacity_modifier = 0.6
	new_trait.construction_bonus = -10.0
	return new_trait


static func create_cold_blooded() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "cold_blooded"
	new_trait.display_name = "Cold Blooded"
	new_trait.description = "Naturally resistant to cold temperatures."
	new_trait.trait_type = TraitType.PHYSICAL
	new_trait.is_positive = true
	new_trait.cold_resistance_modifier = 1.5
	return new_trait


static func create_leader() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "leader"
	new_trait.display_name = "Natural Leader"
	new_trait.description = "Provides a morale boost to nearby survivors. Has priority in conflicts."
	new_trait.trait_type = TraitType.PERSONALITY
	new_trait.is_positive = true
	new_trait.morale_aura = 8.0
	new_trait.is_leader = true
	return new_trait


static func create_skilled_hunter() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "skilled_hunter"
	new_trait.display_name = "Skilled Hunter"
	new_trait.description = "Significantly better at hunting animals."
	new_trait.trait_type = TraitType.SKILL
	new_trait.is_positive = true
	new_trait.hunting_bonus = 25.0
	return new_trait


static func create_navigator() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "navigator"
	new_trait.display_name = "Navigator"
	new_trait.description = "Better at expeditions and finding locations."
	new_trait.trait_type = TraitType.SKILL
	new_trait.is_positive = true
	new_trait.navigation_bonus = 25.0
	return new_trait


static func create_medic() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "medic"
	new_trait.display_name = "Medic"
	new_trait.description = "More effective at treating injuries and illness."
	new_trait.trait_type = TraitType.SKILL
	new_trait.is_positive = true
	new_trait.medicine_bonus = 25.0
	return new_trait


static func create_carpenter() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "carpenter"
	new_trait.display_name = "Former Carpenter"
	new_trait.description = "Builds structures 25% faster."
	new_trait.trait_type = TraitType.SKILL
	new_trait.is_positive = true
	new_trait.construction_bonus = 25.0
	return new_trait


static func create_builder() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "builder"
	new_trait.display_name = "Former Builder"
	new_trait.description = "Builds structures 15% faster."
	new_trait.trait_type = TraitType.SKILL
	new_trait.is_positive = true
	new_trait.construction_bonus = 15.0
	return new_trait


static func create_beast_of_burden() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "beast_of_burden"
	new_trait.display_name = "Beast of Burden"
	new_trait.description = "Carries 50% more materials when hauling."
	new_trait.trait_type = TraitType.PHYSICAL
	new_trait.is_positive = true
	new_trait.carry_capacity_modifier = 1.5
	return new_trait


static func create_resourceful() -> SurvivorTrait:
	var new_trait := SurvivorTrait.new()
	new_trait.id = "resourceful"
	new_trait.display_name = "Resourceful"
	new_trait.description = "Gathers 25% more materials per trip."
	new_trait.trait_type = TraitType.SKILL
	new_trait.is_positive = true
	new_trait.survival_bonus = 25.0  # Used as gathering efficiency
	return new_trait


static func get_all_traits() -> Array[SurvivorTrait]:
	## Returns an array of all available traits for random selection.
	return [
		create_drunkard(),
		create_coward(),
		create_combative(),
		create_personable(),
		create_affable(),
		create_strong(),
		create_weak(),
		create_cold_blooded(),
		create_leader(),
		create_skilled_hunter(),
		create_navigator(),
		create_medic(),
		create_carpenter(),
		create_builder(),
		create_beast_of_burden(),
		create_resourceful()
	]


static func get_random_traits(count: int = 2, allow_conflicting: bool = false) -> Array[SurvivorTrait]:
	## Returns random traits for a new survivor.
	var all_traits := get_all_traits()
	var selected: Array[SurvivorTrait] = []
	var selected_ids: Array[String] = []

	# Conflicting trait pairs
	var conflicts: Dictionary = {
		"strong": "weak",
		"weak": "strong",
		"coward": "combative",
		"combative": "coward",
		"leader": "coward"
	}

	all_traits.shuffle()

	for survivor_trait in all_traits:
		if selected.size() >= count:
			break

		# Check for conflicts
		if not allow_conflicting and survivor_trait.id in conflicts:
			var conflict_id: String = conflicts[survivor_trait.id]
			if conflict_id in selected_ids:
				continue

		selected.append(survivor_trait)
		selected_ids.append(survivor_trait.id)

	return selected
