# Men AI System - LimboAI Behavior Tree Implementation

---

## ✅ MAJOR BUG FIXED (2026-01-12) - NavigationAgent Drift

### The Problem (SOLVED)
Units arrived at resources (heat sources, food), then **IMMEDIATELY floated/slid away in random directions** instead of staying in place for their 20-45 second waits. This bug persisted for DAYS across multiple debugging sessions.

### Root Cause
**The NavigationAgent3D was STILL ACTIVE** even after `stop()` was called. The `stop()` function only set:
- `is_moving = false`
- `velocity = Vector3.ZERO`

But the NavigationAgent3D internally continued computing paths and velocities because:
1. `target_position` was still set to the old destination
2. Avoidance system was still running via `velocity_computed` signal

### The Fix (Applied 2026-01-12)
In `clickable_unit.gd`, the `stop()` function now properly stops the NavigationAgent:

```gdscript
func stop() -> void:
    print("[Unit:%s] stop() at %s" % [unit_name, global_position])
    is_moving = false
    velocity = Vector3.ZERO
    # CRITICAL: Must also stop NavigationAgent to prevent drift!
    # Setting target to current position stops path computation.
    # Setting velocity to zero stops avoidance computation.
    navigation_agent.target_position = global_position
    navigation_agent.set_velocity(Vector3.ZERO)
    _play_animation("idle")
    _stop_footsteps()
```

### Why This Was Hard To Find
| Red Herring | Why It Seemed Like The Problem |
|-------------|-------------------------------|
| Animation playback | Units appeared "frozen" - but was actually separate issue (wrong .res file) |
| Physics/move_and_slide | Added `is_animation_locked` guard - didn't help |
| BTDebugWait timing | Logs showed waits progressing correctly - BT was fine |
| Y-height/floating | Visual symptom made it look like physics issue |

### Key Lesson
**When stopping a NavigationAgent3D-based unit, you MUST:**
1. Set `target_position = global_position` (clears path)
2. Call `set_velocity(Vector3.ZERO)` (stops avoidance)

Just setting `is_moving = false` is NOT enough!

---

## CRITICAL WARNINGS FOR FUTURE CLAUDE CODE AGENTS

**READ THIS ENTIRE SECTION BEFORE WRITING ANY CODE.**

### DO NOT programmatically generate .tres behavior tree files

**STOP. This is the most important lesson from this implementation.**

LimboAI uses complex `BBVariant` sub-resources with undocumented serialization formats. Attempting to write these programmatically WILL waste HOURS of development time.

**WRONG approach (wasted 3+ hours):**
```gdscript
# DO NOT DO THIS - BBVariant types cannot be easily constructed in code
var check = BTCheckVar.new()
check.variable = &"player_command_active"
check.value = true  # ERROR: Cannot assign bool to BBVariant

# Also DO NOT try to create BBBool, BBFloat objects - the serialization is complex
var bb_bool = BBBool.new()
bb_bool.saved_value = true  # This still won't serialize correctly to .tres
```

**CORRECT approach (takes 2 minutes):**
1. Open `man_bt.tres` in the Godot editor
2. Use the LimboAI visual behavior tree editor
3. Add/configure nodes visually - click on node, set properties in Inspector
4. Save - the editor handles all BBVariant serialization automatically

### PREFER visual trees over code complexity

The LimboAI editor provides:
- Drag-and-drop node creation
- Visual branching that humans can read and debug
- Automatic BBVariant type handling (this is the killer feature)
- Built-in documentation for each node type
- Visual debugger to see which branches are running

**Do NOT create complex programmatic tree builders.** The first implementation attempt created a 200+ line `_build_behavior_tree()` function that fought the API at every turn. The .tres file approach is simpler, more maintainable, and actually works.

### Keep custom tasks MINIMAL and SIMPLE

Each custom BTAction should be:
- **Under 50 lines of code**
- **Single responsibility** - do ONE thing
- **Leverage built-in LimboAI tasks** whenever possible

Built-in tasks to use INSTEAD of custom code:
| Task | Purpose |
|------|---------|
| `BTWait` / `BTRandomWait` | Waiting/delays |
| `BTCheckVar` | Check blackboard variable |
| `BTCheckAgentProperty` | Check agent property (e.g., `stats.energy < 60`) |
| `BTCallMethod` | Call any method on agent |
| `BTPlayAnimation` | Play animations |
| `BTSequence` | Run children in order until one fails |
| `BTSelector` | Try children until one succeeds |

### DO NOT over-engineer

The user explicitly requested:
> "Keep code VERY SIMPLE, rely on built-in LimboAI classes"
> "Highly modular and extensible for future game growth"
> "Outsource complexity, don't build a rat's nest"

If you find yourself writing more than 50 lines for a single task, STOP and reconsider.

---

## Architecture Overview

### Purpose

Semi-autonomous enlisted men of a stricken icebound polar exploration vessel. Important to the player because as officers die, men are promoted to officer. Only officers can be directly controlled by the player for building, defending, exploring, trading, etc. The win condition is based on how many men are rescued.

### File Structure

```
ai/
├── CLAUDE.md                    # This documentation (READ FIRST!)
├── man_ai_controller.gd         # Attaches BTPlayer to units dynamically
├── man_bt.tres                  # Main behavior tree (EDIT IN GODOT EDITOR!)
└── tasks/                       # Custom BT tasks (keep these SMALL!)
    ├── bt_find_bed.gd              # ~65 lines
    ├── bt_find_food_container.gd   # ~47 lines
    ├── bt_find_nearest_resource.gd # ~46 lines
    ├── bt_generate_wander_target.gd # ~28 lines
    └── bt_move_to_blackboard.gd    # ~68 lines (includes stuck detection)
```

**CRITICAL:** LimboAI requires custom tasks in `res://ai/tasks/`, NOT `res://src/ai/tasks/`. This caused a "Failed to list directory" error that took time to debug.

### How It Works

1. **ManAIController** is attached as a child of each ClickableUnit
2. In `_ready()`, it creates a **BTPlayer** dynamically and assigns `man_bt.tres`
3. The BTPlayer must be configured with:
   - `set_scene_root_hint(_unit)` - BEFORE adding to tree
   - `agent_node = NodePath("../..")` - points to the unit (grandparent of BTPlayer)
4. The behavior tree ticks every physics frame
5. Custom tasks in `ai/tasks/` extend `BTAction` and perform game-specific logic
6. **Blackboard** variables share state between tasks

### Blackboard Variables

| Variable | Type | Purpose |
|----------|------|---------|
| `player_command_active` | bool | True when player issued move command (pauses AI) |
| `current_action` | String | UI display ("Wandering", "Seeking food", etc.) |
| `target_position` | Vector3 | Movement destination (where unit walks to) |
| `target_node` | Node | Target resource node |
| `target_marker` | Marker3D | Alignment marker (beds, seats) |
| `fire_position` | Vector3 | Fire location for BTFaceTarget (distinct from target_position!) |

**IMPORTANT:** `target_position` vs `fire_position`:
- `target_position` = where the unit MOVES to (the spot around the fire)
- `fire_position` = the fire itself (what the unit should FACE)

BTFaceTarget should use `fire_position` when warming by fire, NOT `target_position`!

---

## Current Behavior Tree Structure

Open `man_bt.tres` in Godot to see the visual tree. Here's the logical structure:

```
BTSelector [Root - tries each child until one succeeds]
│
├── 1. PlayerOverride [BTSequence]
│   ├── BTCheckVar: player_command_active == true
│   └── BTWait: 0.1s (yield while player controls unit)
│
├── 2. SeekShelter [BTSequence] - when energy < 60%
│   ├── BTCheckAgentProperty: stats.energy < 60
│   ├── BTFindBed (custom)
│   ├── BTMoveToBlackboard (custom)
│   └── BTWait: 5.0s
│
├── 3. SeekWarmth [BTSequence] - when warmth < 60%
│   ├── BTCheckAgentProperty: stats.warmth < 60
│   ├── BTFindNearestResource: heat_sources (custom)
│   ├── BTMoveToBlackboard (custom)
│   └── BTWait: 5.0s
│
├── 4. SeekFood [BTSequence] - when hunger < 60%
│   ├── BTCheckAgentProperty: stats.hunger < 60
│   ├── BTFindFoodContainer (custom)
│   ├── BTMoveToBlackboard (custom)
│   └── BTWait: 3.0s
│
└── 5. Wander [BTSequence] - idle behavior (fallback)
    ├── BTGenerateWanderTarget (custom)
    ├── BTMoveToBlackboard (custom)
    └── BTRandomWait: 2-8s
```

---

## Current Status & Known Issues

### What's Working
- Wander behavior executes correctly (units move to random positions)
- `current_action` updates in blackboard for UI display
- Navigation via NavigationAgent3D functions with avoidance enabled
- Log spam has been removed from clickable_unit.gd
- Stuck detection in BTMoveToBlackboard (gives up after 3s of no progress)
- NavigationObstacle3D on containers with avoidance_enabled

### Fixed Issues (January 2026)

#### 1. Units getting stuck on crates/barrels - FIXED
**Root cause:** Two issues:
1. `clickable_unit.gd` was calling `move_and_slide()` directly instead of using `navigation_agent.set_velocity()` which bypassed the avoidance system
2. `storage_crate_small.tscn` was missing `avoidance_enabled = true` on its NavigationObstacle3D

**Fixes applied:**
1. Modified `clickable_unit.gd` to use `navigation_agent.set_velocity(desired_velocity)` which triggers the `velocity_computed` callback with avoidance-safe velocity
2. Added `avoidance_enabled = true` and `avoidance_layers = 1` to storage_crate_small.tscn
3. Added stuck detection to `bt_move_to_blackboard.gd` - gives up after 3 seconds of no progress

### Remaining Issues

#### 1. Priority behaviors may not trigger
**Symptom:** All units just wander, never seek shelter/warmth/food.

**Potential causes:**
- `stats.energy`, `stats.warmth`, `stats.hunger` might not be accessible via BTCheckAgentProperty
- Stats might not be decaying (TimeManager not calling `update_needs`)
- Thresholds set too low (60%) while stats start at 100%

**Debug steps:**
1. Check if stats are decaying in TimeManager
2. Manually set a unit's stats low in Inspector before running
3. Add debug prints to custom tasks to see if they're being reached

#### 2. Missing resource groups
**Symptom:** BTFindNearestResource returns FAILURE.

**Required groups that may not exist:**
- `heat_sources` - campfires need to be added to this group
- `beds` - bed scenes need to be added to this group
- `containers` - already exists (barrels/crates)

### Next Steps

1. **Verify resource groups exist** - add debug prints or check in editor
2. **Test with lowered stats** - manually set energy/warmth/hunger to 50 in Inspector
3. **Implement actual procedures** - currently just waits at location, needs:
   - Eating animation + stat restore
   - Sleep animation + energy restore
   - Warming animation + warmth restore

---

## Custom Task Template

```gdscript
@tool
extends BTAction
class_name BTMyTask
## One-line description of what this task does.

@export var some_param: String = "default"

func _generate_name() -> String:
    return "MyTask [%s]" % some_param

func _tick(_delta: float) -> Status:
    var agent: Node3D = get_agent()
    if not agent:
        return FAILURE

    # Your logic here (keep it SHORT)
    # Use blackboard.get_var() and blackboard.set_var()

    # IMPORTANT: Always set current_action for UI
    blackboard.set_var(&"current_action", "Doing something")

    return SUCCESS  # or FAILURE or RUNNING
```

### Common Patterns

**Finding nearest node in group:**
```gdscript
var nodes := agent.get_tree().get_nodes_in_group("my_group")
var nearest: Node3D = null
var nearest_dist := INF
for node in nodes:
    if not node is Node3D:
        continue
    var dist := agent.global_position.distance_to(node.global_position)
    if dist < nearest_dist:
        nearest_dist = dist
        nearest = node
```

**Calling agent methods:**
```gdscript
if agent.has_method("move_to"):
    agent.move_to(target_position)
```

**Returning RUNNING for ongoing actions:**
```gdscript
func _tick(_delta: float) -> Status:
    var dist := agent.global_position.distance_to(target)
    if dist < arrival_distance:
        return SUCCESS
    if not agent.is_moving:
        return SUCCESS  # Navigation gave up
    return RUNNING  # Still moving
```

---

## Integration Points

### ManAIController API

```gdscript
# Get current action for UI display
var action: String = unit.get_current_action()

# Pause AI for player commands
var ai = unit.get_node("ManAIController")
ai.set_player_command_active(true)

# Resume AI after player command completes
ai.set_player_command_active(false)

# Disable AI entirely
ai.set_enabled(false)
```

### ClickableUnit Requirements

The agent (ClickableUnit) must have:
- `stats: SurvivorStats` - for BTCheckAgentProperty to read
- `move_to(pos: Vector3)` - for movement tasks
- `stop()` - to halt movement
- `is_moving: bool` - movement state check

---

## Resource Groups Required

| Group | Scenes | Purpose |
|-------|--------|---------|
| `beds` | bed_1.tscn | Sleep targets |
| `heat_sources` | campfire.tscn | Warmth sources |
| `containers` | barrels, crates | Food/item storage |
| `survivors` | All ClickableUnits | TimeManager updates |
| `selectable_units` | All ClickableUnits | Input handling |

---

## Debugging

### Check the log
```bash
cat "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log" | tail -200
```

### Filter for errors
```bash
grep -i "error\|fail" "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log" | tail -50
```

### LimboAI Visual Debugger
Enable in the editor to see which tree branches are executing in real-time.

---

## Lessons Learned (The Hard Way)

1. **Use the visual editor** - It handles BBVariant serialization automatically
2. **Don't fight the API** - If something feels hacky, there's probably a built-in way
3. **Keep tasks under 50 lines** - Complex tasks = complex bugs
4. **Test incrementally** - Get one behavior working before adding more
5. **Check logs first** - Most issues are visible in the output
6. **Files must be in `ai/tasks/`** - Not `src/ai/tasks/` - LimboAI won't find them otherwise
7. **Set `current_action`** - Every task that changes state should update this for UI
8. **The simplest solution that works is the best solution** - Don't over-engineer
