# Men AI System - LimboAI Behavior Trees

## Official Documentation

**LimboAI Docs:** https://limboai.readthedocs.io/en/stable/

Key sections:
- [Introduction to Behavior Trees](https://limboai.readthedocs.io/en/stable/behavior-trees/introduction.html)
- [Creating Custom Tasks](https://limboai.readthedocs.io/en/stable/behavior-trees/custom-tasks.html)
- [Using the Blackboard](https://limboai.readthedocs.io/en/stable/behavior-trees/using-blackboard.html)
- [Class Reference](https://limboai.readthedocs.io/en/stable/classes/featured-classes.html)

---

## Critical Rules

### 1. NEVER Edit .tres or Blackboard Files Programmatically

**Claude/AI agents must NEVER edit:**
- `man_bt.tres` (behavior tree resource)
- Any Blackboard files
- Any LimboAI resource files

**Why:** LimboAI's BBVariant sub-resources, node UIDs, and resource IDs have complex interdependencies. Editing them as text causes:
- Broken resource references
- Invalid node hierarchies
- Silent failures that are hard to debug

**Instead:** Provide clear instructions for the user to make changes in the Godot editor.

### 2. NavigationAgent3D Drift Fix
When stopping a unit, you MUST reset the NavigationAgent:
```gdscript
navigation_agent.target_position = global_position  # Clears path
navigation_agent.set_velocity(Vector3.ZERO)          # Stops avoidance
```
Just setting `is_moving = false` causes drift!

### 3. BTDynamicSelector Performance
Re-evaluates ALL preceding children every tick. Avoid O(n) tasks (survivor loops) in high-priority sequences.

### 4. Task Location
Custom tasks MUST be in `res://ai/tasks/`, NOT `res://src/ai/tasks/`.

### 5. Prefer Built-in LimboAI Tasks

**Always use LimboAI built-ins before creating custom tasks:**

| Need | Use Built-in | NOT Custom |
|------|--------------|------------|
| Check agent property | `BTCheckAgentProperty` | Custom BTCondition |
| Set agent property | `BTSetAgentProperty` | Custom BTAction |
| Wait duration | `BTWait`, `BTRandomWait` | Custom wait task |
| Play animation | `BTPlayAnimation` | Custom animation task |

**ClickableUnit exposes computed properties** for BTCheckAgentProperty:
- `warmth`, `hunger`, `energy`, `health`, `morale` (direct stat access)
- `is_warmth_critical`, `is_hunger_critical`, etc. (threshold checks)
- `distance_to_target`, `is_at_target`, `is_near_target` (proximity)
- `is_animation_locked`, `is_moving`, `is_dead`

### 6. WATCH THE LOG SPAM
Never log ANYTHING once per frame and be strategic about your logs in general.

---

## Architecture

### File Structure
```
ai/
├── man_ai_controller.gd         # Creates BTPlayer, manages blackboard
├── man_bt.tres                  # Main behavior tree (EDIT IN GODOT EDITOR!)
└── tasks/
    # === KEEP: Domain-specific tasks ===
    ├── bt_align_with_marker.gd     # Align with Marker3D (beds, seats)
    ├── bt_consume_food.gd          # Eat from inventory or container
    ├── bt_find_bed.gd              # Find bed with Marker3D
    ├── bt_find_fire_spot.gd        # Find empty spot around fire
    ├── bt_find_food_container.gd   # Find container with food
    ├── bt_find_nearest_resource.gd # Generic group-based finder
    ├── bt_find_seat.gd             # Find sittable surface
    ├── bt_move_to_blackboard.gd    # Move with stuck detection
    ├── bt_sync_target_position.gd  # Copy blackboard to agent for proximity checks
    │
    # === DEPRECATED: Use built-in tasks instead ===
    ├── bt_check_need_critical.gd   # Use BTCheckAgentProperty(warmth < 25)
    ├── bt_check_proximity.gd       # Use BTSyncTargetPosition + BTCheckAgentProperty
    ├── bt_face_target.gd           # Use BTRotateToFaceTarget
    ├── bt_generate_wander_target.gd # Use BTRandomPosition
    └── bt_set_animation_lock.gd    # Use BTSetAgentProperty(is_animation_locked)
```

### How It Works
1. **ManAIController** attaches as child of ClickableUnit
2. Creates **BTPlayer** with `set_scene_root_hint(_unit)` BEFORE adding to tree
3. Sets `agent_node = NodePath("../..")` (grandparent = unit)
4. Tree ticks every physics frame

### Blackboard Variables
| Variable | Type | Purpose |
|----------|------|---------|
| `player_command_active` | bool | Pauses AI for player commands |
| `current_action` | String | UI display text |
| `target_position` | Vector3 | Movement destination |
| `target_node` | Node | Resource node reference |
| `target_marker` | Marker3D | Alignment point (beds, seats) |
| `fire_position` | Vector3 | Fire location for facing (≠ target_position!) |

---

## Current Behavior Tree

Root is **BTDynamicSelector** (re-evaluates priorities each tick):

```
BTDynamicSelector [Root]
├── 1. PlayerOverride - BTCheckVar(player_command_active) → BTWait(0.1s)
├── 2. SeekShelter (energy < 25) - FindBed → Move → Lock → Sleep anims (45-60s) → Unlock
├── 3. SeekWarmth (warmth < 60) - FindHeat → Move → Lock → Crouch/Stand anims (15-45s) → Unlock
├── 4. SeekFood (hunger < 60) - FindContainer → Move → Lock → Open/Take/Eat anims → Unlock
└── 5. IdleBehaviors [BTRandomSelector]
    ├── Wander - GenerateTarget → Move → Wait(15-30s)
    ├── SitOnCrate - FindSeat → Move → AlignMarker → Sit anims (20-40s)
    └── WarmByFire - FindHeat → FindSpot → Move → Face → Crouch/Stand (15-45s)
```

**Note:** Uses `BTCheckNeedCritical` (custom BTCondition) for stat checks, not `BTCheckAgentProperty`.

---

## Custom Task Patterns

### Condition (BTCondition)
```gdscript
@tool
extends BTCondition
class_name BTCheckNeedCritical

@export_enum("warmth", "energy", "hunger") var need: String = "warmth"
@export var threshold: float = 25.0

func _tick(_delta: float) -> Status:
    var agent: Node3D = get_agent()
    if not agent or not "stats" in agent:
        return FAILURE
    return SUCCESS if agent.stats.get(need) < threshold else FAILURE
```

### Action (BTAction)
```gdscript
@tool
extends BTAction
class_name BTMyTask

func _generate_name() -> String:
    return "MyTask"

func _tick(_delta: float) -> Status:
    var agent: Node3D = get_agent()
    if not agent:
        return FAILURE
    blackboard.set_var(&"current_action", "Doing thing")
    return SUCCESS  # or FAILURE or RUNNING
```

### Movement (returns RUNNING)
```gdscript
func _tick(delta: float) -> Status:
    if agent.global_position.distance_to(target) < arrival_distance:
        agent.stop()
        return SUCCESS
    if not _moving:
        agent.move_to(target)
        _moving = true
    return RUNNING
```

---

## Integration

### ManAIController API
```gdscript
ai.set_player_command_active(true)   # Pause AI
ai.set_player_command_active(false)  # Resume AI
ai.set_enabled(false)                # Disable entirely
ai.get_current_action()              # Get status string
```

### ClickableUnit Requirements
- `stats: SurvivorStats` - survival stats
- `move_to(pos: Vector3)` - start navigation
- `stop()` - halt movement (must reset NavigationAgent!)
- `is_moving: bool` - movement state
- `is_animation_locked: bool` - prevents movement during animations

**Computed Properties for BTCheckAgentProperty:**
- `warmth`, `hunger`, `energy`, `health`, `morale` - direct stat values
- `is_warmth_critical`, `is_hunger_critical`, `is_energy_critical` - threshold checks
- `_bt_target_position: Vector3` - set by BTSyncTargetPosition
- `distance_to_target: float` - distance to `_bt_target_position`
- `is_at_target: bool` - true if distance < 3m
- `is_near_target: bool` - true if distance < 5m

### Required Groups
| Group | Purpose |
|-------|---------|
| `beds` | Sleep targets |
| `heat_sources` | Fire/warmth |
| `containers` | All storage (generic) |
| `barrels` | Food storage (StorageType.FOOD) |
| `crates` | Equipment storage (StorageType.GENERAL) |
| `survivors` | TimeManager updates |

---

## Debugging

```bash
tail -200 "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log"
grep -i "error\|fail" "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log" | tail -50
```

Enable **LimboAI Visual Debugger** in editor to see active branches.

---

## Key Rules

1. **Use the visual editor** - BBVariant serialization is complex
2. **Keep tasks under 50 lines** - single responsibility
3. **Always set `current_action`** - UI feedback
4. **Test incrementally** - one behavior at a time
5. **Prefer built-in tasks** - BTWait, BTPlayAnimation, BTRandomSelector, etc.

---

## Known Issues & Editor Fixes

### Issue: Units Crouch/Sleep Without Reaching Resource

**Symptom:** Units start sleeping/crouching animations even though they're far from the bed/fire.

**Root Cause:** The behavior tree sequences proceed to "at-resource" animations even when MoveTo fails.

**Fix in Godot Editor (RECOMMENDED PATTERN):**

Use built-in tasks with ClickableUnit's computed properties:

```
1. BTCheckAgentProperty                     ← Check need
   - property: "warmth"
   - check_type: CHECK_LESS_THAN (1)
   - value: 25.0

2. BTFindNearestResource                    ← Find target

3. BTMoveToBlackboard                       ← Move to target

4. BTSyncTargetPosition                     ← Copy blackboard to agent
   - source_var: "target_position"

5. BTCheckAgentProperty                     ← Verify arrival
   - property: "distance_to_target"
   - check_type: CHECK_LESS_THAN (1)
   - value: 3.0

6. BTSetAgentProperty                       ← Lock animations
   - property: "is_animation_locked"
   - value: true

7. [Animation tasks]

8. BTSetAgentProperty                       ← Unlock
   - property: "is_animation_locked"
   - value: false
```

### Issue: Animation Lock Before Movement

**Symptom:** Units don't move because they're animation-locked before the move starts.

**Fix:** Only lock animations AFTER movement AND proximity check complete.

### Issue: is_animation_locked Never Cleared After BTDynamicSelector Abort (FIXED 2026-01-20)

**Symptom:** Units play walking animation but don't actually move. They're stuck facing away from resources.

**Root Cause:** When BTDynamicSelector aborts a sequence mid-animation (e.g., hunger drops during SitOnCrate's RandomWait), the final `BTSetAgentProperty(is_animation_locked = false)` never runs!

Example SitOnCrateSequence:
1. SetProperty(is_animation_locked = true) ← SET HERE
2. PlayAnimation (sit down)
3. PlayAnimation (sitting idle)
4. RandomWait (20-40s) ← INTERRUPTED HERE when need drops
5. PlayAnimation (stand up) ← NEVER REACHED
6. SetProperty(is_animation_locked = false) ← NEVER REACHED!

**Fix Applied:** In `clickable_unit.gd`, `move_to()` now clears `is_animation_locked`:
```gdscript
func move_to(target_position: Vector3) -> void:
    if is_dead:
        return
    is_animation_locked = false  # <-- Clears leftover lock from aborted sequences
    navigation_agent.target_position = target_position
    ...
```

**Why this works:** Movement is mutually exclusive with stationary animations. If the BT calls move_to(), the unit should move, period.

**Lesson learned:** Single-line fixes > 150-line overengineered solutions. Always find the actual root cause.

### BTCheckAgentProperty CheckType Values

| Value | Name | Description |
|-------|------|-------------|
| 0 | CHECK_EQUAL | `==` |
| 1 | CHECK_LESS_THAN | `<` |
| 2 | CHECK_LESS_THAN_OR_EQUAL | `<=` |
| 3 | CHECK_GREATER_THAN | `>` |
| 4 | CHECK_GREATER_THAN_OR_EQUAL | `>=` |
| 5 | CHECK_NOT_EQUAL | `!=` |

---

## LimboAI Core Concepts

### Task Return Values
| Value | Meaning |
|-------|---------|
| `SUCCESS` | Task completed successfully, move to next in sequence |
| `FAILURE` | Task failed, sequence stops (or selector tries next) |
| `RUNNING` | Task still in progress, will be ticked again |

### Composite Nodes
| Node | Behavior |
|------|----------|
| `BTSequence` | Runs children in order until one fails |
| `BTSelector` | Runs children until one succeeds |
| `BTDynamicSelector` | Like selector but re-evaluates earlier children each tick |
| `BTRandomSelector` | Picks random child each time |

### Important: BTDynamicSelector Behavior

**The root uses BTDynamicSelector** which means:
- Every tick, it checks if a higher-priority sequence should run
- If `SeekShelter` (energy < 25) becomes valid, it interrupts `WanderSequence`
- Tasks in higher-priority sequences run EVERY TICK until they fail

This is why log spam can occur - tasks like `BTSetAnimationLock` run every tick when their sequence is active.

### Blackboard Variable Naming Convention

Variables ending in `_var` are **configuration** - they specify which blackboard key to use:
```gdscript
@export var target_var: StringName = &"target_position"  # Reads/writes to "target_position" key
```

This is NOT the variable name in the BlackboardPlan - it's which key the task operates on.

---

## CRITICAL: BTPlayAnimation Sequential Behavior

### The Problem

**BTPlayAnimation with `await_completion = 0` (default) returns SUCCESS immediately.**

This means in a BTSequence, back-to-back BTPlayAnimation nodes **ALL FIRE ON THE SAME TICK**:

```
BTSequence:
├── BTPlayAnimation("stand_up_from_laying_down")  ← tick N, returns SUCCESS
├── BTPlayAnimation("sleeping_idle")               ← tick N, returns SUCCESS (OVERWRITES!)
├── BTRandomWait(45s)                              ← tick N, returns RUNNING (pauses here)
```

The first animation is **immediately overwritten** by the second because both start on the same frame.

### The Solution: Use `await_completion`

Set `await_completion` to the animation duration (in seconds) for animations that must complete before the next:

| Animation | Duration | await_completion |
|-----------|----------|------------------|
| stand_up_from_laying_down | ~2s | 2.0 |
| crouch_to_stand | ~1.5s | 1.5 |
| opening_a_lid | ~1s | 1.5 |
| taking_item | ~1s | 1.0 |
| closing_a_lid | ~1s | 1.5 |
| sitting_from_standing | ~1s | 1.5 |

**Looping animations (sleeping_idle, crouching_idle, sitting_depressed) should NOT have await_completion** - they loop indefinitely.

### Blend Parameter

`blend` = crossfade duration in seconds between animations:
- `-1.0` (default): No custom blend, instant cut
- `0.2-0.3`: Quick, snappy transitions
- `0.5`: Smooth natural transitions
- `1.0`: Very slow, deliberate blends (good for survival actions)

BTPlayAnimation uses Godot's AnimationPlayer.play() directly - **NO AnimationTree required**.

---

## Pending Editor Fixes (man_bt.tres)

### 1. Enable Disabled Animation Locks

The following BTSetAgentProperty nodes are DISABLED (`_enabled = false`) and must be enabled:

**SeekWarmth sequence:**
- Line ~235-238: `BTSetAgentProperty_l2yjk` (is_animation_locked = true)
- Line ~275-278: `BTSetAgentProperty_8jgo4` (is_animation_locked = false)

**SeekFood sequence (if exists):**
- Line ~141-144: `BTSetAgentProperty_sbexb` (is_animation_locked = true)
- Line ~193-196: `BTSetAgentProperty_s7c4l` (is_animation_locked = false)

**How to enable:** Select node in BT editor → Inspector → uncheck "Disabled"

### 2. Set await_completion on Transition Animations

**SeekShelter:**
- `BTPlayAnimation("stand_up_from_laying_down", speed=-1)` → `await_completion = 2.0`
- `BTPlayAnimation("stand_up_from_laying_down")` (after wait) → `await_completion = 2.0`

**SeekWarmth/CrouchByFire:**
- `BTPlayAnimation("crouch_to_stand", speed=-1)` → `await_completion = 1.5`
- `BTPlayAnimation("crouch_to_stand")` (after wait) → `await_completion = 1.5`

**SeekFood:**
- `BTPlayAnimation("opening_a_lid")` → `await_completion = 1.5`
- `BTPlayAnimation("taking_item")` → `await_completion = 1.0`
- `BTPlayAnimation("closing_a_lid")` → `await_completion = 1.5`

**SitOnCrate:**
- `BTPlayAnimation("sitting_from_standing")` → `await_completion = 1.5`
- `BTPlayAnimation("sitting_from_standing", speed=-1)` (stand up) → `await_completion = 1.5`

### 3. Fix SeekShelter to Navigate to Beds (Not Shelter Areas)

**Issue:** Units navigate to shelter Area3D centers, then sleep NEAR shelters instead of IN beds.

**Fix:** In SeekShelter sequence, change `BTFindNearestResource`:
- **Current:** `resource_group = "shelters"` (navigates to ShelterArea center)
- **Change to:** `resource_group = "beds"` (navigates to actual beds)

Beds are already in the `"beds"` group and have `foot_of__bed` / `head_of_bed` Marker3D nodes.

**In editor:** Select the `BTFindNearestResource` node in SeekShelter → Inspector → change `Resource Group` dropdown to `beds`
