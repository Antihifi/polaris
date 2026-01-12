# Combat System

**Status:** Not Yet Implemented

Combat encounters and damage resolution for survival threats.

## Planned Purpose

Handle hostile encounters including:
- **Wildlife:** Polar bears, wolves
- **Environmental:** Frostbite damage, starvation damage
- **Human:** Desperate survivors, hostile natives (rare)

**Note:** Combat is not the primary focus of Polaris. The game emphasizes survival management over combat mechanics. Combat should be rare, dangerous, and avoidable.

## Directory Structure

```
src/combat/
├── CLAUDE.md           # This file
└── (planned files)
```

## Planned Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Combat System                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ CombatResolver  │     │ Handles damage calculation, │    │
│  │ (Autoload)      │────►│ hit detection, outcomes     │    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ Weapon          │     │ Damage, range, attack speed │    │
│  │ (Resource)      │────►│ Used by survivors & enemies │    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ ThreatDetector  │     │ Detects nearby hostiles,    │    │
│  │ (Component)     │────►│ triggers flee/fight response│    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Existing Integration

### IndieBlueprintHealth Addon

The `Survivor` class already uses `IndieBlueprintHealth` for health management:

```gdscript
# In survivor.gd
@onready var health_component: Node = $IndieBlueprintHealth

func _ready() -> void:
    if health_component:
        health_component.died.connect(_on_health_died)
        health_component.health_changed.connect(_on_health_changed)
```

This provides:
- `take_damage(amount: int, type: int)` - Apply damage
- `heal(amount: int)` - Restore health
- `died` signal - Death event
- `health_changed` signal - UI updates

### SurvivorStats Health

Stats also track health separately (synced with component):
```gdscript
# In survivor_stats.gd
@export var health: float = 100.0

func is_dying() -> bool:
    return health <= CRITICAL_THRESHOLD  # 15.0

func is_dead() -> bool:
    return health <= 0.0
```

### Trait: Coward/Combative

Traits already define combat behavior:
```gdscript
# Coward trait
flees_combat: bool = true
morale_modifier: float = 0.85

# Combative trait
damage_modifier: float = 1.3
morale_aura: float = -5.0  # Affects nearby survivors negatively
can_trigger_mental_break: bool = true
```

### Flee Behavior (Survivor)

Survivors can already flee:
```gdscript
func flee_from(threat_position: Vector3) -> void:
    if not _cached_flees_combat:
        return  # Only cowards flee

    current_state = State.FLEEING
    var flee_direction := (global_position - threat_position).normalized()
    var flee_target := global_position + flee_direction * 20.0
    navigation_agent.target_position = flee_target
```

## Planned Features

### Environmental Damage

Already partially implemented in `survivor_stats.gd`:
```gdscript
# In apply_hourly_decay()
if is_starving():
    health -= 2.0  # Starvation damage
if is_freezing():
    health -= 3.0  # Frostbite damage
```

### Weapon System

```gdscript
class_name Weapon extends Resource

@export var name: String
@export var damage: float = 10.0
@export var range: float = 2.0          # Melee vs ranged
@export var attack_speed: float = 1.0   # Attacks per second
@export var durability: float = 100.0

enum WeaponType { MELEE, RANGED }
@export var weapon_type: WeaponType = WeaponType.MELEE
```

### Combat Resolution

Simple deterministic system (not dice-based):
```gdscript
func resolve_attack(attacker: Node, defender: Node, weapon: Weapon) -> void:
    var base_damage := weapon.damage

    # Attacker modifiers
    if "damage_modifier" in attacker:
        base_damage *= attacker.damage_modifier

    # Defender modifiers (armor, etc.)
    if "damage_reduction" in defender:
        base_damage *= (1.0 - defender.damage_reduction)

    # Apply damage
    if defender.has_method("take_damage"):
        defender.take_damage(int(base_damage))
```

### Threat Encounters

Random encounters during exploration:
```gdscript
class_name ThreatEncounter extends Resource

@export var threat_type: String = "polar_bear"
@export var spawn_chance: float = 0.05  # Per hour in wilderness
@export var aggression: float = 0.7     # Chance to attack vs flee
@export var damage: float = 25.0
@export var health: float = 100.0
```

### Flee vs Fight Decision

AI chooses based on traits and situation:
```gdscript
func _evaluate_threat(threat: Node) -> void:
    var should_flee := false

    # Cowards always flee
    if _cached_flees_combat:
        should_flee = true

    # Low health = flee
    if stats.health < 30.0:
        should_flee = true

    # Outnumbered = flee
    if _count_nearby_hostiles() > _count_nearby_allies():
        should_flee = true

    if should_flee:
        flee_from(threat.global_position)
    else:
        _engage_combat(threat)
```

## Design Considerations

### Combat Should Be:

1. **Rare** - Most gameplay is survival management, not fighting
2. **Dangerous** - Even winning costs health/resources
3. **Avoidable** - Player can choose to flee or hide
4. **Consequential** - Death is permanent, injuries linger

### Combat Should NOT Be:

1. **Primary gameplay** - This is survival RTS, not action
2. **Frequent** - Encounters should be events, not routine
3. **Trivial** - No "trash mobs" to grind through
4. **Required** - Pacifist playthroughs should be possible

## Integration Points

### With Survivors
- Health component for damage
- Traits for combat modifiers
- State machine for FLEEING/combat states

### With AI System
- Threat detection triggers flee behavior
- Combat as autonomous behavior (defend self)

### With TimeManager
- Encounter chances per hour
- Night increases danger

### With Weather
- Blizzards provide cover (reduced encounter chance)
- Extreme cold forces wildlife indoors

## Implementation Priority

1. **Environmental damage** (already working)
2. **Flee behavior** (already working)
3. **Wildlife encounters** (polar bear)
4. **Basic melee combat** (knife, hatchet)
5. **Ranged combat** (rifles - limited ammo)

## Related Systems

- `src/characters/survivor.gd` - Health, flee, traits
- `src/characters/survivor_stats.gd` - Health tracking, damage
- `ai/` - Behavior responses to threats (LimboAI behavior trees)
- `addons/ninetailsrabbit.indie_blueprint_rpg/` - Health component
