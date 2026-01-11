# AI Behavior System

Autonomous behavior system using **LimboAI** (behavior trees + state machines) for both player-controlled Officers and AI-controlled Men.

## Overview

| Unit Type | Count | Control Mode | AI Role |
|-----------|-------|--------------|---------|
| **Officers** | ~12 | Player-controlled | Execute player commands, fallback to survival needs |
| **Men** | 20-30 | AI-controlled | Fully autonomous survival behavior |

Both unit types use the **same LimboAI system** with different behavior tree roots. Promotion/demotion simply swaps which BT root is active while preserving the shared blackboard (needs data).

---

## Why LimboAI (Not Utility AI + Another System)

We evaluated using separate addons for Officers (LimboAI) and Men (Utility AI GDExtension). **This was rejected** because:

1. **Promotion problem** - When a Man becomes an Officer (or vice versa), you'd need to tear down one AI system's state and rebuild another's. Fragile and error-prone.
2. **Two mental models** - Designers must learn both utility scoring AND behavior tree logic.
3. **Two debuggers** - Different debugging workflows for different unit types.
4. **Shared blackboard sync** - Both systems have their own data storage; syncing is manual work.

**Solution:** Use LimboAI exclusively. Implement utility-style scoring as custom BTTask nodes for the Men. One system, one debugger, seamless role transitions.

---

## Installation

### Step 1: Install LimboAI

1. Download from [LimboAI Asset Library (Godot 4.4+)](https://godotengine.org/asset-library/asset/3787) or [GitHub](https://github.com/limbonaut/limboai)
2. Extract to `addons/limboai/`
3. Enable in Project Settings → Plugins
4. Restart Godot

### Step 2: Verify Installation

After enabling, you should see:
- `BTPlayer` node type available
- `BTTask`, `BTComposite`, `BTDecorator` base classes
- BehaviorTree resource type
- LimboAI debugger panel in bottom dock

---

## Architecture

### System Overview

```
Survivor Unit (CharacterBody3D)
├── BTPlayer (LimboAI behavior tree runner)
│   ├── blackboard → SurvivorBlackboard (shared needs data)
│   └── behavior_tree → officer_bt.tres OR man_bt.tres
├── SurvivorStats (existing Resource - hunger, warmth, etc.)
├── NavigationAgent3D
└── ... (other existing components)
```

### Key Concept: Shared Blackboard

The **blackboard** is LimboAI's data store. All needs, targets, and state live here. When promoting/demoting, we swap the behavior tree but **keep the same blackboard**.

```gdscript
# On promotion: Man → Officer
func promote_to_officer() -> void:
    var bt_player: BTPlayer = $BTPlayer
    # Blackboard stays intact - all needs data preserved
    bt_player.behavior_tree = preload("res://src/ai/trees/officer_bt.tres")
    is_officer = true

# On demotion: Officer → Man
func demote_to_man() -> void:
    var bt_player: BTPlayer = $BTPlayer
    bt_player.behavior_tree = preload("res://src/ai/trees/man_bt.tres")
    is_officer = false
```

---

## Directory Structure (IMPLEMENTED)

```
src/ai/
├── CLAUDE.md                    # This file
├── man_ai_component.gd          # Attaches BTPlayer to units, handles player override
├── trees/                       # Behavior tree resources (user creates via editor)
│   └── man_bt.tres              # Man (autonomous) behavior tree [TODO: create in editor]
├── tasks/
│   ├── actions/
│   │   ├── bt_move_to_target.gd     # Navigate to blackboard position
│   │   ├── bt_consume_food.gd       # Eat from inventory (plays "taking_item" anim)
│   │   ├── bt_take_item.gd          # Take item from container (plays "opening_a_lid" anim)
│   │   ├── bt_rest.gd               # Rest until energy recovered
│   │   ├── bt_wander.gd             # Idle wandering behavior
│   │   ├── bt_flee.gd               # Flee from threat
│   │   ├── bt_seek_resource.gd      # Find nearest resource by group
│   │   └── bt_wait.gd               # Simple wait (returns RUNNING)
│   ├── conditions/
│   │   ├── bt_check_need.gd         # Check need < threshold + utility scoring
│   │   ├── bt_has_item.gd           # Check inventory for item category
│   │   ├── bt_is_near.gd            # Check proximity (fire/shelter/captain)
│   │   ├── bt_check_threat.gd       # Check if dangerous entity nearby
│   │   └── bt_check_player_override.gd  # Check if player command active
│   ├── composites/
│   │   └── bt_utility_selector.gd   # Scores children, picks highest utility
│   └── decorators/
│       └── bt_utility_wrapper.gd    # Adds utility score to wrapped subtree
├── blackboard/
│   └── blackboard_sync.gd           # Syncs unit state to blackboard per tick
└── needs_controller.gd              # [DEPRECATED - not used]
```

---

## Behavior Tree Design

### Officer Behavior Tree

Officers prioritize **player commands** but fall back to survival needs when idle.

```
officer_bt.tres
├── Selector (priority)
│   ├── Sequence: Execute Player Command
│   │   ├── BTCondition: has_player_command
│   │   ├── BTAction: execute_command
│   │   └── BTAction: clear_command
│   │
│   ├── Sequence: Critical Survival (interrupt anything)
│   │   ├── BTCondition: is_dying
│   │   └── SubTree: survival_needs.tres
│   │
│   └── BTAction: idle_animation
```

### Man Behavior Tree (Utility-Based)

Men use **utility scoring** to decide between competing needs. This is implemented as a custom `BTUtilitySelector` that scores children and picks the highest.

```
man_bt.tres
├── Selector (priority)
│   ├── Sequence: Flee Danger
│   │   ├── BTCondition: threat_nearby
│   │   └── BTAction: flee_to_safety
│   │
│   ├── BTUtilitySelector (scores needs, picks most urgent)
│   │   ├── Sequence: Address Hunger [score: inverse of hunger stat]
│   │   │   ├── BTCheckNeed: hunger < 50
│   │   │   ├── BTSeekResource: food_source
│   │   │   ├── BTMoveToTarget
│   │   │   └── BTConsumeItem: food
│   │   │
│   │   ├── Sequence: Address Warmth [score: inverse of warmth stat]
│   │   │   ├── BTCheckNeed: warmth < 50
│   │   │   ├── BTSeekResource: heat_source
│   │   │   └── BTMoveToTarget
│   │   │
│   │   ├── Sequence: Address Energy [score: inverse of energy stat]
│   │   │   ├── BTCheckNeed: energy < 40
│   │   │   ├── BTSeekResource: shelter
│   │   │   ├── BTMoveToTarget
│   │   │   └── BTAction: rest
│   │   │
│   │   └── Sequence: Seek Shelter (weather)
│   │       ├── BTCondition: bad_weather
│   │       ├── BTSeekResource: shelter
│   │       └── BTMoveToTarget
│   │
│   └── BTAction: wander_idle
```

---

## Custom Task Implementations

### BTUtilitySelector (Core Innovation)

This custom composite node implements utility AI scoring within LimboAI's behavior tree framework.

```gdscript
# src/ai/tasks/bt_utility_selector.gd
@tool
class_name BTUtilitySelector extends BTComposite
## Selects child with highest utility score instead of fixed priority.
## Each child must implement get_utility_score(blackboard) -> float.

func _tick(delta: float) -> int:
    var best_score: float = 0.0
    var best_child: BTTask = null

    for child in get_children():
        if not child.has_method("get_utility_score"):
            continue
        var score: float = child.get_utility_score(blackboard)
        if score > best_score:
            best_score = score
            best_child = child

    if best_child:
        return best_child.execute(delta)
    return FAILURE


func _get_configuration_warnings() -> PackedStringArray:
    var warnings: PackedStringArray = []
    for child in get_children():
        if not child.has_method("get_utility_score"):
            warnings.append("Child %s missing get_utility_score()" % child.name)
    return warnings
```

### BTCheckNeed

```gdscript
# src/ai/tasks/bt_check_need.gd
@tool
class_name BTCheckNeed extends BTCondition
## Checks if a survival need is below threshold.

@export var need_name: StringName = &"hunger"
@export var threshold: float = 50.0
@export var comparison: StringName = &"less_than"  # less_than, greater_than

func _tick(_delta: float) -> int:
    var stats: SurvivorStats = blackboard.get_var(&"stats")
    if not stats:
        return FAILURE

    var value: float = stats.get(need_name)

    match comparison:
        &"less_than":
            return SUCCESS if value < threshold else FAILURE
        &"greater_than":
            return SUCCESS if value > threshold else FAILURE

    return FAILURE


## For BTUtilitySelector - returns urgency score 0.0-1.0
func get_utility_score(bb: Blackboard) -> float:
    var stats: SurvivorStats = bb.get_var(&"stats")
    if not stats:
        return 0.0

    var value: float = stats.get(need_name)
    # Invert: lower stat = higher urgency
    # At 0 hunger → score 1.0, at 100 hunger → score 0.0
    return 1.0 - (value / 100.0)
```

### BTSeekResource

```gdscript
# src/ai/tasks/bt_seek_resource.gd
@tool
class_name BTSeekResource extends BTAction
## Finds nearest resource of type and stores in blackboard.

@export var resource_type: StringName = &"food_source"
@export var target_var: StringName = &"move_target"
@export var max_search_distance: float = 100.0

## Group names for each resource type
const RESOURCE_GROUPS: Dictionary = {
    &"food_source": "containers",
    &"heat_source": "heat_sources",
    &"shelter": "shelters",
    &"water_source": "water_sources",
}

func _tick(_delta: float) -> int:
    var unit_pos: Vector3 = blackboard.get_var(&"unit_position")
    var group_name: String = RESOURCE_GROUPS.get(resource_type, "")

    if group_name.is_empty():
        return FAILURE

    var targets := get_tree().get_nodes_in_group(group_name)
    var nearest: Node3D = null
    var nearest_dist: float = max_search_distance

    for target in targets:
        if not target is Node3D:
            continue
        if not _is_valid_resource(target):
            continue

        var dist: float = unit_pos.distance_to(target.global_position)
        if dist < nearest_dist:
            nearest_dist = dist
            nearest = target

    if nearest:
        blackboard.set_var(target_var, nearest.global_position)
        blackboard.set_var(&"target_node", nearest)
        return SUCCESS

    return FAILURE


func _is_valid_resource(node: Node3D) -> bool:
    ## Override in subclass for type-specific validation
    match resource_type:
        &"food_source":
            var storage: StorageContainer = node.get_node_or_null("StorageContainer")
            return storage and storage.has_food()
        &"heat_source":
            return node.has_method("is_lit") and node.is_lit()
        &"shelter":
            return node.is_in_group("shelters")
    return true
```

### BTMoveToTarget

```gdscript
# src/ai/tasks/bt_move_to_target.gd
@tool
class_name BTMoveToTarget extends BTAction
## Moves unit to position stored in blackboard.

@export var target_var: StringName = &"move_target"
@export var arrival_distance: float = 1.5

var _moving: bool = false

func _tick(_delta: float) -> int:
    var target_pos: Vector3 = blackboard.get_var(target_var, Vector3.ZERO)
    if target_pos == Vector3.ZERO:
        return FAILURE

    var unit: ClickableUnit = blackboard.get_var(&"unit")
    if not unit:
        return FAILURE

    var distance: float = unit.global_position.distance_to(target_pos)

    if distance <= arrival_distance:
        _moving = false
        return SUCCESS

    if not _moving:
        unit.move_to(target_pos)
        _moving = true

    return RUNNING


func _exit() -> void:
    _moving = false
```

---

## Blackboard Setup

### SurvivorBlackboard Variables

| Variable | Type | Source | Description |
|----------|------|--------|-------------|
| `unit` | ClickableUnit | Setup | Reference to owner unit |
| `stats` | SurvivorStats | Setup | Reference to stats resource |
| `unit_position` | Vector3 | Per-tick | Current world position |
| `move_target` | Vector3 | Tasks | Navigation target |
| `target_node` | Node3D | Tasks | Current interaction target |
| `player_command` | Dictionary | Input | Pending player command (Officers) |
| `threat_position` | Vector3 | Perception | Nearest threat location |
| `is_in_shelter` | bool | Area detection | Currently in shelter |
| `is_near_fire` | bool | Area detection | Currently near heat source |

### Blackboard Sync Script

```gdscript
# Attached to survivor unit, syncs data to blackboard each tick
func _physics_process(_delta: float) -> void:
    if not bt_player or not bt_player.blackboard:
        return

    var bb: Blackboard = bt_player.blackboard
    bb.set_var(&"unit_position", global_position)
    bb.set_var(&"is_in_shelter", _check_in_shelter())
    bb.set_var(&"is_near_fire", _check_near_fire())
```

---

## Integration with Existing Systems

### SurvivorStats Integration

The existing `SurvivorStats` resource integrates directly with the blackboard:

```gdscript
# In survivor setup
func _ready() -> void:
    var bt_player: BTPlayer = $BTPlayer
    bt_player.blackboard.set_var(&"stats", stats)
    bt_player.blackboard.set_var(&"unit", self)
```

Key `SurvivorStats` methods used by BT tasks:
- `stats.hunger`, `stats.warmth`, `stats.energy` - Need values (0-100)
- `stats.is_starving()`, `stats.is_freezing()` - Critical state checks
- `stats.get_most_critical_need()` - Returns most urgent need name
- `stats.eat_food()`, `stats.warm_up()`, `stats.rest()` - Recovery actions

### SelectionManager Integration (Officers)

Officers need to receive player commands:

```gdscript
# In SelectionManager or RTSInputHandler
func _issue_move_command(target_pos: Vector3) -> void:
    for unit in selected_units:
        if unit.is_officer:
            var bb: Blackboard = unit.bt_player.blackboard
            bb.set_var(&"player_command", {
                "type": "move",
                "target": target_pos
            })
```

### TimeManager Integration

Blackboard values that update on time events:

```gdscript
# Connect to TimeManager.hour_passed
func _on_hour_passed() -> void:
    var bb: Blackboard = bt_player.blackboard
    bb.set_var(&"current_hour", TimeManager.current_hour)
    bb.set_var(&"is_daytime", TimeManager.is_daytime())
    bb.set_var(&"ambient_temp", TimeManager.get_ambient_temperature())
```

---

## Implementation Steps

### Phase 1: Foundation

1. **Install LimboAI** addon
2. **Create directory structure** (`src/ai/tasks/`, `src/ai/trees/`, `src/ai/blackboard/`)
3. **Implement core tasks:**
   - `BTCheckNeed`
   - `BTSeekResource`
   - `BTMoveToTarget`
   - `BTConsumeItem`
4. **Create basic blackboard** with `SurvivorStats` integration

### Phase 2: Man Behavior (Autonomous)

1. **Implement `BTUtilitySelector`** for needs-based scoring
2. **Create `man_bt.tres`** with survival need sequences
3. **Test with single AI-controlled unit**
4. **Add all survival behaviors:**
   - Hunger → seek food → eat
   - Cold → seek fire/shelter
   - Tired → seek shelter → rest
   - Weather → seek shelter

### Phase 3: Officer Behavior (Player-Controlled)

1. **Create `BTWaitForCommand`** task
2. **Create `officer_bt.tres`** with command priority
3. **Integrate with `SelectionManager`** for command input
4. **Add fallback survival** when no commands

### Phase 4: Promotion/Demotion

1. **Implement `promote_to_officer()`** - swap BT, preserve blackboard
2. **Implement `demote_to_man()`** - swap BT, preserve blackboard
3. **Add death detection** - trigger promotion of highest-morale Man
4. **Test role transitions** thoroughly

### Phase 5: Polish

1. **Visual debugger** integration for testing
2. **Performance profiling** with 30+ units
3. **Migrate from `NeedsController`** (deprecated)
4. **Documentation updates**

---

## Migration from NeedsController

The existing `needs_controller.gd` will be **deprecated** once LimboAI is implemented. Migration path:

| NeedsController Feature | LimboAI Equivalent |
|------------------------|-------------------|
| `_check_hunger_needs()` | `BTCheckNeed` + `BTUtilitySelector` |
| `_seek_food_container()` | `BTSeekResource` with `food_source` type |
| `_try_eat_personal_food()` | `BTConsumeItem` task |
| `seeking_food` signal | Blackboard state + UI polling |
| `check_interval` timer | BT tick rate (configurable) |

**Do not delete** `needs_controller.gd` until Phase 2 is complete and tested.

---

## Performance Considerations

### Tick Rate

LimboAI defaults to ticking every physics frame. For 30+ units, consider:

```gdscript
# In BTPlayer setup
bt_player.update_mode = BTPlayer.UPDATE_MODE_IDLE  # Use _process instead
bt_player.tick_interval = 0.1  # Tick every 100ms instead of every frame
```

### Group Queries

`BTSeekResource` uses `get_nodes_in_group()` which allocates. For many units:

1. **Cache group results** in a singleton, update on spawn/despawn signals
2. **Stagger queries** - not all units query same frame
3. **Spatial partitioning** if >50 units (unlikely for this game)

### Blackboard Memory

Each unit has its own blackboard. With 40 units, this is negligible. Just avoid storing large data (arrays, dictionaries) per-unit.

---

## Debugging

### LimboAI Visual Debugger

1. Select a unit with BTPlayer in the scene
2. Open LimboAI panel in bottom dock
3. See real-time tree execution, active nodes, blackboard state

### Debug Prints

```gdscript
# In any BTTask
func _tick(delta: float) -> int:
    var unit_name: String = blackboard.get_var(&"unit").unit_name
    print("[BT:%s] %s ticking" % [unit_name, get_name()])
    # ...
```

### Common Issues

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Unit does nothing | Blackboard `unit` or `stats` not set | Check `_ready()` setup |
| Task always fails | Missing blackboard variable | Add `print()` to check values |
| Unit stuck moving | `BTMoveToTarget` not returning SUCCESS | Check `arrival_distance` or timeout |
| Wrong need addressed | Utility scores miscalculated | Debug `get_utility_score()` |

---

## Known Issues & Fixes

### Units Getting Stuck When Seeking Resources (FIXED)

**Symptom:** Units seeking fire/shelter/food would get stuck indefinitely if their path was blocked by other units, obstacles, or NavigationObstacle3D boundaries.

**Root Cause:** `bt_move_to_target.gd` had NO stuck detection - it returned RUNNING forever if the unit couldn't reach its destination.

**Fix Applied (January 2026):**

Added 8-second timeout with stuck detection in `bt_move_to_target.gd`:
```gdscript
var _move_timeout: float = 0.0
const MAX_MOVE_TIME: float = 8.0

func _enter() -> void:
    _moving = false
    _move_timeout = 0.0

func _tick(delta: float) -> Status:
    # ... existing checks ...

    # Stuck detection
    _move_timeout += delta
    if _move_timeout >= MAX_MOVE_TIME:
        _moving = false
        _move_timeout = 0.0
        unit.stop()
        print("[BTMoveToTarget] Timeout after %.1fs, stopping at dist=%.1fm" % [MAX_MOVE_TIME, distance])
        return SUCCESS  # Allow behavior to continue
```

**Design Decision:** Returns SUCCESS on timeout (not FAILURE) so the parent sequence continues. This allows units to warm/rest at their current position instead of abandoning the behavior entirely.

**Related Tasks with Timeouts:**
- `bt_wander.gd` - 5 second max wander time
- `bt_warm_by_fire.gd` - Built-in timeout for warming
- `bt_move_to_target.gd` - 8 second stuck detection

---

### Units Over-Favoring Shelter at Mild Temperatures (FIXED)

**Symptom:** At 0°C weather, units would constantly seek shelter instead of gathering by the fire. They spent more time walking to shelter than actually surviving.

**Root Cause:** Energy and warmth utility wrappers had equal scoring weights. Units didn't understand that:
1. Low warmth is MORE urgent (cascades to energy burn, hunger, morale)
2. They'll naturally sleep ~8 hours/day anyway, so low energy isn't critical
3. Fire is the primary survival resource at mild temperatures

**Fix Applied (January 2026):**

1. **Adjusted thresholds in `man_bt.tres`:**
   - Warmth threshold: 60% → 50% (only trigger when warmth is actually concerning)
   - Energy threshold: 60% → 40% (don't seek shelter until quite tired)

2. **Adjusted score multipliers:**
   - Warmth: `score_multiplier = 1.5` (higher priority when warmth IS low)
   - Energy: `score_multiplier = 0.8` (lower priority - units "know" they'll sleep later)

3. **Added extreme weather boost to `bt_utility_wrapper.gd`:**
   ```gdscript
   @export var extreme_weather_boost: float = 0.0

   func _update_score() -> void:
       # ... base scoring ...
       if extreme_weather_boost > 0.0 and _is_extreme_weather():
           score += extreme_weather_boost

   func _is_extreme_weather() -> bool:
       # Returns true if temp < -20°C
       var temp: float = time_manager.current_temperature
       return temp < -20.0
   ```

4. **Energy wrapper gets `extreme_weather_boost = 1.0`** - shelter becomes priority in blizzards/extreme cold.

**Design Philosophy:**
- **Warmth < 50%** = URGENT → seek fire immediately
- **Energy < 40%** = NOT urgent if fire available → sit by fire, sleep later
- **Shelter** = Only for: sleeping (night), extreme cold (<-20°C), weather events
- **Fire** = Primary gathering spot for warmth, morale, socializing

---

### Units All Facing North When Resting (FIXED)

**Symptom:** When units rest in shelter, they all face the same direction (north), looking unnatural and robotic.

**Root Cause:** `bt_rest.gd` didn't set a facing direction when starting rest.

**Fix Applied:**
```gdscript
# In bt_rest.gd
func _tick(delta: float) -> Status:
    if not _resting:
        _face_random_direction(unit)
        # ... start rest animation ...

func _face_random_direction(unit: Node) -> void:
    if unit is Node3D:
        unit.global_rotation.y = randf() * TAU
```

---

## References

- [LimboAI GitHub](https://github.com/limbonaut/limboai)
- [LimboAI Documentation](https://limboai.readthedocs.io/)
- [Behavior Tree Concepts](https://www.gamedeveloper.com/programming/behavior-trees-for-ai-how-they-work)
- [Utility AI in Games](https://www.gameaipro.com/GameAIPro/GameAIPro_Chapter09_An_Introduction_to_Utility_Theory.pdf)
