# Combat System

## Overview

Deterministic combat (Kenshi/Rimworld style). Damage = `WeaponBaseDamage × (0.8 + Strength/250)`.

## Architecture

```
src/combat/
├── weapon_stats.gd      # Weapon resource
└── weapon_database.gd   # Static weapon definitions

src/creatures/
├── animal.gd            # Base class (uses LimboAI)
└── polar_bear.gd        # Stats override

ai/tasks/
├── bt_animal_*.gd       # Animal behavior tasks
└── bt_attack.gd         # Survivor attack task
```

## Weapons

| ID | Damage | Range | Speed |
|----|--------|-------|-------|
| unarmed | 3-5 | 1.5m | 1.0s |
| knife | 6-10 | 1.5m | 0.8s |
| hatchet | 10-15 | 2.0m | 1.2s |

## Combat Flow

### Initiation
- **Officers**: Right-click hostile to attack
- **Men**: Auto-defend when attacked
- **Animals**: Territorial attack on proximity

### Input (rts_input_handler.gd)
```gdscript
# In _handle_right_click():
var hostile := _raycast_for_hostile(screen_position)
if hostile:
    _issue_attack_command(hostile)
```

## Animals

| Animal | HP | Damage | Aggro | Behavior |
|--------|-----|--------|-------|----------|
| Polar Bear | 200 | 35 | 30m | Territorial |
| Seal | 40 | 5 | 15m | Passive |
| Caribou | 60 | 10 | 20m | Passive |

### Animal LimboAI Tasks
- `bt_animal_is_low_health` - Flee condition
- `bt_animal_has_threat` - Detect survivors
- `bt_animal_chase_target` - Move to attack range
- `bt_animal_deal_damage` - Apply damage
- `bt_animal_pick_roam_target` - Random roam point
- `bt_animal_roam_to_target` - Navigate to roam

### Survivor LimboAI Tasks (Men)
- `bt_has_combat_target` - Condition: has valid combat target, sets blackboard var
- `bt_attack` - State manager: sets is_in_combat on enter/exit
- `bt_chase_to_attack_range` - Move toward target until in weapon range
- `bt_deal_damage` - Apply damage from weapon to target

### passive_bt.tres Combat Sequence
Men combat is handled entirely in BT. Update the Combat sequence:
```
BTSequence "Combat"
├── BTCondition (bt_has_combat_target)     # Sets combat_target in blackboard
├── BTAction (bt_attack)                   # Manages combat state
├── BTAction (bt_chase_to_attack_range)    # Move to weapon range
├── BTPlayAnimation                        # Attack animation, await_completion
└── BTAction (bt_deal_damage)              # Apply damage
```

**Note:** Officers use code-based combat (clickable_unit._process_combat). Men skip this when their BT is active.

### Animation Blending
Use BTPlayAnimation with `blend` parameter:
- Idle→Walk: blend=0.5
- Walk→Run: blend=0.3
- Run→Attack: blend=0.2, await_completion=1.5

## Flee Behavior

| Trait | Threshold |
|-------|-----------|
| Coward | 50% HP |
| Normal | 15% HP |
| Combative | Never |
| Animals | 25% HP |

## Scene Setup

### Collision Layers
Animals must be on **layer 2** for raycast detection (same as units).

### polar_bear.tscn Structure
```
PolarBear (CharacterBody3D, layer=2)
├── NavigationAgent3D
├── CollisionShape3D
├── Model + AnimationPlayer
└── AnimalAIController
```

## Key Signals

```gdscript
# ClickableUnit
signal combat_started(target: Node3D)
signal combat_ended
signal took_damage(amount: float, attacker: Node3D)

# Animal
signal died(animal: Animal)
signal took_damage(amount: float, attacker: Node3D)
```
