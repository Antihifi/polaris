# Character System

Survivor characters with navigation, survival needs, traits, and states.

## Files

| File | Purpose |
|------|---------|
| `clickable_unit.gd` | Base class for click-to-move units with stats |
| `survivor.gd` | Full survivor with traits, states, health component |
| `survivor.tscn` | Survivor scene with NavigationAgent3D |
| `survivor_stats.gd` | Resource for survival needs (hunger, warmth, etc.) |
| `trait.gd` | Resource for character traits and modifiers |
| `eye_controller.gd` | Eye tracking/animation for characters |

## Class Hierarchy

```
CharacterBody3D
├── ClickableUnit (class_name)
│   └── Captain node in main.tscn (uses clickable_unit.gd directly)
└── Survivor (class_name, extends CharacterBody3D directly)
    └── Full survivor with IndieBlueprintHealth, traits
```

**Note:** `ClickableUnit` and `Survivor` are separate implementations. `ClickableUnit` is simpler and currently used for the Captain. `Survivor` is the full-featured class for spawned survivors.

## ClickableUnit

### Signals
```gdscript
signal selected
signal deselected
signal reached_destination
signal stats_changed  # For UI updates
```

### Key Properties
```gdscript
@export var unit_name: String = "Survivor"
@export var movement_speed: float = 1.0
@export var stats: SurvivorStats  # Created automatically if null
```

### Movement
Uses `NavigationAgent3D` for pathfinding:
```gdscript
func move_to(target_position: Vector3) -> void:
    navigation_agent.target_position = target_position
    is_moving = true
    _play_animation("walking")
    _start_footsteps()
```

Movement uses **full 3D direction** from NavigationAgent3D (including Y-axis) to follow terrain height:
```gdscript
var next_position := navigation_agent.get_next_path_position()
var direction := (next_position - current_pos).normalized()
velocity = direction * movement_speed * time_scale
move_and_slide()
```

**Critical:** The NavigationAgent3D's `get_next_path_position()` returns correct Y coordinates from the baked NavMesh. Never flatten direction to XZ plane only - this causes units to float above terrain after traversing slopes.

### Energy Drain While Walking
```gdscript
const BASE_WALKING_ENERGY_DRAIN: float = 0.5  # Per real second at 1x

func _drain_walking_energy(delta: float, time_scale: float) -> void:
    var drain := BASE_WALKING_ENERGY_DRAIN * delta * time_scale
    drain *= stats.get_energy_drain_multiplier()  # Condition modifier
    stats.energy -= drain
```

### Animation & Audio
- Finds `AnimationPlayer` in children recursively
- Creates `AudioStreamPlayer3D` for positional footsteps
- Speed scales with `movement_speed` and `time_scale`

```gdscript
@export var base_animation_speed: float = 0.15
@export var base_footstep_speed: float = 0.5

func _update_speed_scale() -> void:
    animation_player.speed_scale = base_animation_speed * movement_speed * time_scale
    _footstep_player.pitch_scale = base_footstep_speed * movement_speed * time_scale
```

## Survivor

Full survivor class with states, traits, and health integration.

### States
```gdscript
enum State {
    IDLE,
    MOVING,
    WORKING,
    RESTING,
    EATING,
    WARMING,
    FLEEING,
    DEAD
}
```

### Signals
```gdscript
signal selected
signal deselected
signal died(survivor: Survivor)
signal need_critical(need_name: String, value: float)
signal reached_destination
signal task_completed(task_type: String)
```

### Traits Integration
Traits are cached on `_ready()` for performance:
```gdscript
var _cached_movement_modifier: float = 1.0
var _cached_hunger_modifier: float = 1.0
var _cached_flees_combat: bool = false
# etc.

func _cache_trait_effects() -> void:
    for survivor_trait in traits:
        _cached_movement_modifier *= survivor_trait.movement_speed_modifier
        if survivor_trait.flees_combat:
            _cached_flees_combat = true
```

### Health Component
Uses `IndieBlueprintHealth` addon:
```gdscript
@onready var health_component: Node = $IndieBlueprintHealth

func _ready() -> void:
    if health_component:
        health_component.died.connect(_on_health_died)
        health_component.health_changed.connect(_on_health_changed)
```

## SurvivorStats Resource

All values 0-100 where higher is better.

### Needs
```gdscript
@export var hunger: float = 100.0    # Food satisfaction
@export var warmth: float = 100.0    # Body temperature
@export var health: float = 100.0    # Physical condition
@export var morale: float = 75.0     # Mental state
@export var energy: float = 100.0    # Stamina (capped by health)
```

### Energy-Health Correlation
Energy maximum is limited by health:
```gdscript
func get_max_energy() -> float:
    if health >= 80.0:
        return 100.0
    elif health >= 50.0:
        return 75.0 + (health - 50.0) * (25.0 / 30.0)
    elif health >= 20.0:
        return 40.0 + (health - 20.0) * (35.0 / 30.0)
    else:
        return 10.0 + health * (30.0 / 20.0)
```

### Thresholds
```gdscript
const CRITICAL_THRESHOLD: float = 15.0
const LOW_THRESHOLD: float = 35.0
const COMFORTABLE_THRESHOLD: float = 65.0

func is_starving() -> bool: return hunger <= CRITICAL_THRESHOLD
func is_hungry() -> bool: return hunger <= LOW_THRESHOLD
func is_freezing() -> bool: return warmth <= CRITICAL_THRESHOLD
# etc.
```

### Work Efficiency
Returns 0.0 to 1.5 based on condition:
```gdscript
func get_work_efficiency() -> float:
    var efficiency: float = 1.0
    if is_starving(): efficiency *= 0.3
    elif is_hungry(): efficiency *= 0.7
    if is_freezing(): efficiency *= 0.4
    if is_exhausted(): efficiency *= 0.2
    if morale >= 85.0: efficiency *= 1.15  # High morale bonus
    return clampf(efficiency, 0.0, 1.5)
```

### Hourly Decay
Called by `TimeManager` each in-game hour:
```gdscript
func apply_hourly_decay(is_working: bool, is_in_shelter: bool,
                        is_near_fire: bool, ambient_temperature: float) -> void:
    # Hunger always decays (faster if working)
    hunger -= hunger_decay_rate * (1.5 if is_working else 1.0)

    # Warmth affected by environment
    if is_near_fire: warmth += 5.0
    if is_in_shelter: warmth += 2.0

    # Cold effect based on temperature and resistance
    var cold_effect := (-ambient_temperature - 10.0) * 0.5
    cold_effect *= (1.0 - cold_resistance / 100.0)
    warmth -= maxf(cold_effect, 0.0)

    # Health damage from critical needs
    if is_starving(): health -= 2.0
    if is_freezing(): health -= 3.0
```

### Energy Drain Multiplier
Used for walking and working:
```gdscript
func get_energy_drain_multiplier() -> float:
    var multiplier: float = 1.0
    if health < 30.0: multiplier += 1.5    # Very low health
    elif health < 60.0: multiplier += 0.75
    if is_starving(): multiplier += 1.0
    if is_freezing(): multiplier += 1.0
    return multiplier
```

## SurvivorTrait Resource

### Trait Types
```gdscript
enum TraitType {
    PERSONALITY,  # Behavior and morale
    PHYSICAL,     # Physical capabilities
    SKILL,        # Skill proficiency
    MENTAL        # Mental state
}
```

### Modifier Properties
```gdscript
# Multipliers (1.0 = no change)
@export var hunger_decay_modifier: float = 1.0
@export var cold_resistance_modifier: float = 1.0
@export var carry_capacity_modifier: float = 1.0
@export var movement_speed_modifier: float = 1.0
@export var damage_modifier: float = 1.0

# Additive bonuses
@export var hunting_bonus: float = 0.0
@export var construction_bonus: float = 0.0
@export var medicine_bonus: float = 0.0

# Behavior flags
@export var flees_combat: bool = false
@export var is_leader: bool = false
@export var can_trigger_mental_break: bool = false
```

### Built-in Traits
Created via static factory methods:
```gdscript
static func create_strong() -> SurvivorTrait:
    var new_trait := SurvivorTrait.new()
    new_trait.id = "strong"
    new_trait.display_name = "Strong"
    new_trait.carry_capacity_modifier = 1.5
    new_trait.construction_bonus = 15.0
    return new_trait
```

Available traits:
- **Positive:** Strong, Cold Blooded, Natural Leader, Personable, Affable, Skilled Hunter, Navigator, Medic
- **Negative:** Weak, Drunkard, Coward, Combative

### Random Trait Generation
```gdscript
static func get_random_traits(count: int = 2, allow_conflicting: bool = false) -> Array[SurvivorTrait]:
    # Handles conflicts like strong/weak, coward/combative
```

## Integration with TimeManager

`TimeManager` updates all survivors hourly:
```gdscript
func _update_survivor_needs() -> void:
    var survivors := get_tree().get_nodes_in_group("survivors")
    var temp := get_current_temperature()

    for node in survivors:
        if node.has_method("update_needs"):
            node.update_needs(1.0, is_in_shelter, is_near_fire, temp)
```

## Node Structure

### ClickableUnit (Captain)
```
Captain (CharacterBody3D with clickable_unit.gd)
├── NavigationAgent3D
├── CollisionShape3D
├── CaptainAnimations (imported from FBX)
│   └── AnimationPlayer
└── AudioStreamPlayer3D (created at runtime for footsteps)
```

### Survivor
```
Survivor (CharacterBody3D)
├── NavigationAgent3D
├── CollisionShape3D
├── IndieBlueprintHealth
└── Model (Node3D)
```

## Common Modifications

### Add new need
1. Add property to `survivor_stats.gd` with setter
2. Add threshold check functions
3. Add decay logic in `apply_hourly_decay()`
4. Update `get_work_efficiency()` if it affects performance

### Add new trait
1. Add static factory method in `trait.gd`
2. Add to `get_all_traits()` array
3. Add conflict pair in `get_random_traits()` if needed
4. Handle in `Survivor._cache_trait_effects()` if it has special behavior

### Change movement behavior
Modify `_physics_process()` in `clickable_unit.gd`:
```gdscript
# Add terrain-based speed modifier
var terrain_modifier := _get_terrain_speed_modifier(global_position)
velocity = direction * movement_speed * time_scale * terrain_modifier
```

## Known Issues & Fixes

### Units Floating After Slopes (Fixed)

**Problem:** Units would float above terrain after traversing slopes, losing contact with the NavMesh.

**Root Cause:** Original code stripped Y-axis from navigation direction:
```gdscript
# BAD - ignores height from NavMesh
var direction := Vector3(
    next_position.x - current_pos.x,
    0.0,  # Bug: always 0
    next_position.z - current_pos.z
)
```

**Solution:** Use full 3D direction from NavigationAgent3D:
```gdscript
# GOOD - includes Y coordinate from baked NavMesh
var direction := next_position - current_pos
```

The NavigationAgent3D already provides correct Y coordinates from the baked NavMesh - no gravity or terrain height queries needed.
