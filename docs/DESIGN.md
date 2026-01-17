# Planned Systems Design Document

This document contains design specifications for **systems not yet implemented**. These are planning documents, not documentation of working code.

**Status**: All systems below are **NOT YET IMPLEMENTED**.

---

# Combat System

Combat encounters and damage resolution for survival threats.

## Purpose

Handle hostile encounters including:
- **Wildlife:** Polar bears, wolves
- **Environmental:** Frostbite damage, starvation damage
- **Human:** Desperate survivors, hostile natives (rare)

**Note:** Combat is not the primary focus of Polaris. The game emphasizes survival management over combat mechanics. Combat should be rare, dangerous, and avoidable.

## Planned Architecture

```
CombatResolver (Autoload)  → Damage calculation, hit detection, outcomes
Weapon (Resource)          → Damage, range, attack speed
ThreatDetector (Component) → Detects hostiles, triggers flee/fight
```

## Existing Integration

### IndieBlueprintHealth Addon

The `Survivor` class already uses `IndieBlueprintHealth`:
- `take_damage(amount: int, type: int)`
- `heal(amount: int)`
- `died` signal
- `health_changed` signal

### SurvivorStats Health

Stats track health separately (synced with component):
```gdscript
@export var health: float = 100.0
func is_dying() -> bool: return health <= CRITICAL_THRESHOLD
func is_dead() -> bool: return health <= 0.0
```

### Trait: Coward/Combative

Traits already define combat behavior:
- Coward: `flees_combat: bool = true`
- Combative: `damage_modifier: float = 1.3`

### Flee Behavior

Survivors can already flee via `flee_from(threat_position: Vector3)`.

### Environmental Damage

Already implemented in `survivor_stats.gd`:
```gdscript
if is_starving(): health -= 2.0
if is_freezing(): health -= 3.0
```

## Planned Features

### Weapon System
```gdscript
class_name Weapon extends Resource
@export var damage: float = 10.0
@export var range: float = 2.0
@export var attack_speed: float = 1.0
enum WeaponType { MELEE, RANGED }
```

### Combat Resolution
Simple deterministic system (not dice-based) applying attacker/defender modifiers.

### Threat Encounters
Random encounters during exploration with configurable spawn_chance, aggression, damage.

### Flee vs Fight Decision
AI chooses based on traits (coward), health (<30%), and ally/enemy ratio.

## Design Principles

**Combat Should Be:**
1. Rare - Most gameplay is survival management
2. Dangerous - Even winning costs health/resources
3. Avoidable - Player can flee or hide
4. Consequential - Death permanent, injuries linger

**Combat Should NOT Be:**
1. Primary gameplay
2. Frequent
3. Trivial
4. Required

## Integration Points

- **Survivors**: Health component, traits, state machine
- **AI System**: Threat detection, flee behavior
- **TimeManager**: Encounter chances per hour, night danger
- **Weather**: Blizzards provide cover

## Implementation Priority

1. Environmental damage (already working)
2. Flee behavior (already working)
3. Wildlife encounters (polar bear)
4. Basic melee combat
5. Ranged combat (rifles - limited ammo)

---

# Building System

Construction system for shelters, storage structures, and fire pits.

## Purpose

Allow survivors to construct buildings that provide:
- **Shelter:** Protection from cold and weather
- **Storage:** Additional container space
- **Fire pits:** Heat source for warmth
- **Workstations:** Crafting and repair locations

## Planned Architecture

```
BuildingTemplate (Resource)  → Name, cost, build time, shelter value
BuildingPlacer (Node)        → Ghost placement, validation, snap to grid
ConstructionSite (Node3D)    → In-progress with progress bar, worker slots
Building (Node3D)            → Completed functionality
```

## Planned Building Types

### Shelter Buildings

| Building | Shelter Value | Materials | Build Time |
|----------|---------------|-----------|------------|
| Lean-to | 25% | 5 firewood | 30 min |
| Snow shelter | 40% | None (snow) | 45 min |
| Tent | 50% | Canvas, poles | 20 min |
| Stone hut | 75% | 20 rocks | 4 hours |

### Utility Buildings

| Building | Function | Materials | Build Time |
|----------|----------|-----------|------------|
| Fire pit | Heat source | 3 rocks | 10 min |
| Storage rack | 4x6 storage | 4 firewood | 20 min |
| Smoking rack | Food preservation | 6 firewood | 30 min |
| Workbench | Crafting station | 8 firewood, tools | 1 hour |

## Planned Features

### Construction Tasks
Survivors assigned to build, work_progress advances based on efficiency.

### Resource Costs
`material_costs: Dictionary` checked against inventory via `can_afford()`.

### Shelter Mechanics
Buildings provide `shelter_value` that reduces cold effect on warmth decay.

### Decay System
Buildings deteriorate over time (`decay_rate` per day), collapse at 0 durability.

## Integration Points

- **TimeManager**: Construction progress, decay updates
- **Inventory**: Material costs
- **Survivors**: Task assignment, shelter affects warmth, efficiency affects speed
- **Weather**: Shelter reduces effects, fire pits provide warmth radius

## Implementation Notes

1. Start simple: Lean-to shelter only
2. Use composition: Building functionality as components
3. Grid-based placement: Snap to terrain grid
4. Visual feedback: Ghost preview during placement
5. Progress visualization: Construction site with scaffold mesh

---

# NPC System

Non-player characters including native Inuit camps and traders.

## Purpose

Provide interaction opportunities beyond survival:
- **Inuit camps:** Trade, guidance, cultural exchange
- **Rescue parties:** Late-game encounters
- **Other survivors:** Found survivors, rival groups

**Historical context:** The Franklin expedition had some contact with Inuit peoples. Survivors who worked with Inuit guides had better chances of survival.

## Planned Architecture

```
NPCDefinition (Resource)  → Name, dialogue, trade inventory, disposition
Camp (Node3D)             → Location with NPCs, inventory, reputation
TradeSystem (Node)        → Item exchange, value calculation
DialogueSystem (Node)     → Conversation UI, choices, outcomes
```

## Planned NPC Types

### Inuit Hunter
- Disposition: neutral
- Trades: seal_meat, fur_clothing, whale_oil
- Wants: metal_tools, tobacco, beads

### Inuit Elder
- Disposition: wise
- Provides: survival_knowledge, navigation_tips

### Lost Sailor
- Disposition: desperate
- Can join party if rescued

## Planned Features

### Trading System

Barter-based economy (no currency). Items have relative trade values:
- hardtack: 1.0
- knife: 10.0
- seal_meat: 8.0
- fur_coat: 25.0

Trade allowed if offer_value >= request_value * 0.8.

### Reputation System

Actions affect standing with NPC groups (-100 to 100):

| Reputation | Trade Rates | Help |
|------------|-------------|------|
| Friendly (50+) | Fair | Will assist |
| Neutral (0-50) | Standard | May assist |
| Wary (-50-0) | Unfavorable | Won't help |
| Hostile (-50-) | No trade | May attack |

### Reputation Effects

| Action | Change |
|--------|--------|
| Fair trade | +5 |
| Gift | +10 |
| Help in danger | +20 |
| Theft | -30 |
| Violence | -50 |

### Dialogue System
Simple branching dialogue with JSON trees.

### Survival Knowledge
Inuit NPCs can teach skills (hunting, navigation, survival, cold_resistance).

## Camp Locations
Camps placed on world map with signals for entered/exited.

## Integration Points

- **Inventory**: Trade items
- **SurvivorStats**: Skill learning, Affable trait bonus
- **TimeManager**: Visit duration, NPC restock
- **Weather**: Shelter during visits, no trade in blizzards
- **Map**: Camps marked, discovery through exploration

## Design Considerations

### Cultural Sensitivity

Inuit peoples should be:
- Respectful - Not stereotyped
- Capable - Experts in arctic survival
- Autonomous - Their own goals
- Historically grounded

### Gameplay Purpose

NPCs provide:
- Alternative survival strategies
- Information
- Hope (contact in isolation)
- Moral choices

## Implementation Priority

1. Basic Camp - Location with shelter
2. Simple Trade - Item exchange
3. Reputation - Track relationship
4. Dialogue - Basic conversation trees
5. Learning - Skill improvement
