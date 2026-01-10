# AI System Documentation

## Overview

LimboAI-based behavior tree system for autonomous survivor AI. Men operate fully autonomously, addressing survival needs (hunger, warmth, energy, morale) based on utility scoring.

---

## Known Bugs (Priority)

### BUG: Units Crowding Fire / Animation Breaking
**Status:** OPEN | **Severity:** HIGH

**Description:** When ~10+ men spawn, they all path toward the fire simultaneously. They collide, stack on top of each other, and their animations break - resulting in "ice skating" across the fire.

**Root Cause:** Multiple issues compound:
1. BTUtilitySelector picks warmth branch for ALL cold units simultaneously
2. All units path to the SAME fire position (center of WarmthArea)
3. NavigationAgent avoidance doesn't prevent stacking when many units converge
4. No "occupancy" check for fire - units don't spread out around it

**Potential Fixes:**
- Add random offset to fire target position (spread units around campfire)
- Implement "slots" around fire that units claim
- Add BTCondition to check if fire is "crowded" (>N units within radius)
- Stagger AI activation so not all units decide simultaneously

### BUG: Units Getting Stuck on Crates/Barrels
**Status:** OPEN | **Severity:** HIGH

**Description:** Units frequently get stuck walking into crates and barrels, unable to navigate around them despite NavigationAgent3D.

**Root Cause:** Likely one of:
1. Navigation mesh not properly baked around obstacle collision shapes
2. Obstacle collision shapes don't match visual mesh
3. NavigationAgent avoidance radius too small
4. Units trying to path TO the container center (inside the collision)

**Potential Fixes:**
- Re-bake navigation mesh with proper obstacle margins
- Adjust container collision shapes to match visual bounds
- Increase NavigationAgent3D `radius` and `neighbor_distance`
- When seeking containers, target a position NEAR the container, not its center

---

## Directory Structure

```
ai/
├── tasks/
│   ├── actions/
│   │   ├── bt_consume_food.gd     # Eat from inventory (plays "taking_item" anim)
│   │   ├── bt_flee.gd             # Flee from threat at increased speed
│   │   ├── bt_move_to_target.gd   # Navigate to blackboard position
│   │   ├── bt_rest.gd             # Rest to recover energy (plays "idle")
│   │   ├── bt_seek_resource.gd    # Find nearest resource by group
│   │   ├── bt_take_item.gd        # Take item from container (plays "opening_a_lid")
│   │   ├── bt_wait.gd             # Wait for specified duration
│   │   └── bt_wander.gd           # Idle wandering behavior
│   ├── conditions/
│   │   ├── bt_check_need.gd       # Check need < threshold + utility score
│   │   ├── bt_check_player_override.gd  # Check if player command active
│   │   ├── bt_check_threat.gd     # Detect threats within radius
│   │   ├── bt_has_item.gd         # Check inventory for item category
│   │   └── bt_is_near.gd          # Check proximity (fire/shelter/captain)
│   ├── composites/
│   │   └── bt_utility_selector.gd # Scores children, picks highest utility
│   └── decorators/
│       └── bt_utility_wrapper.gd  # Adds utility score to subtree
└── CLAUDE.md                      # This file
```

## Core Components (in src/ai/)

| File | Purpose |
|------|---------|
| `src/ai/man_ai_component.gd` | Attaches BTPlayer to units, handles player override |
| `src/ai/blackboard/blackboard_sync.gd` | Syncs unit state to blackboard each tick |

## Blackboard Variables

| Variable | Type | Source | Purpose |
|----------|------|--------|---------|
| `unit` | ClickableUnit | Setup | Owner reference |
| `stats` | SurvivorStats | Setup | Needs data |
| `unit_position` | Vector3 | Per-tick | Current position |
| `is_near_fire` | bool | Per-tick | Fire proximity |
| `is_in_shelter` | bool | Per-tick | Shelter state |
| `is_near_captain` | bool | Per-tick | Captain proximity |
| `move_target` | Vector3 | Tasks | Navigation target |
| `target_node` | Node3D | Tasks | Current resource node |
| `threat_position` | Vector3 | Tasks | Position of threat |
| `player_override` | bool | Per-tick | True if player issued move command |

## Resource Groups

Used by `bt_seek_resource.gd` to find resources:

| Group | Members | Set By |
|-------|---------|--------|
| `containers` | Storage crates/barrels | StorageContainer._ready() |
| `heat_sources` | Campfires | warmth_area.gd adds parent |
| `shelters` | Tents, ship areas | shelter_area.gd adds parent |
| `water_sources` | Water containers | (future) |

## Animation Mapping

| Action | Animation | Duration | Notes |
|--------|-----------|----------|-------|
| Taking from container | `opening_a_lid` | ~2s | Kneeling, opening |
| Eating/consuming | `taking_item` | ~1s | Hand to mouth |
| Resting | `idle` | Loop | Placeholder |
| Walking | `walking` | Loop | Standard move |
| Fleeing | `walking` | Loop | Uses speed multiplier |

## Player Override Mechanism

When player right-clicks to move a Man:
1. `rts_input_handler.gd` calls `unit.move_to(pos, true)` with player flag
2. `clickable_unit.gd` sets `player_command_active = true`
3. `blackboard_sync.gd` syncs this to `player_override` blackboard var
4. BT checks `BTCheckPlayerOverride` at root - if true, returns RUNNING (AI pauses)
5. When `reached_destination` signal fires, sets `player_command_active = false`
6. Next tick, AI resumes normal behavior

## Utility Scoring

The `BTUtilitySelector` chooses which need to address based on urgency:

```
Score = (1.0 - need_value/100) * multiplier
```

- Need at 0% → Score = 1.0 (maximum urgency)
- Need at 100% → Score = 0.0 (minimum urgency)
- Highest score wins

## Behavior Tree Structure (man_bt.tres)

Create this in Godot's LimboAI editor:

```
Selector [Root]
├── Sequence [Player Override]
│   ├── BTCheckPlayerOverride
│   └── BTWait (0.1s)  # Return RUNNING to pause AI
│
├── Sequence [Flee from danger]
│   ├── BTCheckThreat
│   └── BTFlee
│
├── BTUtilitySelector [Needs]
│   ├── BTUtilityWrapper[hunger] → Sequence
│   │   ├── BTCheckNeed (hunger < 60)
│   │   └── Selector [Get Food]
│   │       ├── Seq → BTHasItem(food), BTConsumeFood
│   │       └── Seq → BTSeekResource(food), BTMoveToTarget, BTTakeItem, BTConsumeFood
│   │
│   ├── BTUtilityWrapper[warmth] → Sequence
│   │   ├── BTCheckNeed (warmth < 60)
│   │   └── Selector [Get Warm]
│   │       ├── BTIsNear (fire)
│   │       └── Seq → BTSeekResource(heat), BTMoveToTarget
│   │
│   ├── BTUtilityWrapper[energy] → Sequence
│   │   ├── BTCheckNeed (energy < 50)
│   │   └── Selector [Find Rest]
│   │       ├── BTIsNear (shelter)
│   │       └── Seq → BTSeekResource(shelter), BTMoveToTarget
│   │   └── BTRest (until 80%)
│   │
│   └── BTUtilityWrapper[morale] → Sequence
│       ├── BTCheckNeed (morale < 40)
│       └── Seq → BTSeekResource(fire), BTMoveToTarget
│
└── BTWander  # Default idle behavior
```

## Creating the Behavior Tree

1. Open Godot and go to **Project → Tools → LimboAI → Editor**
2. Create new BehaviorTree resource
3. Build the tree structure as shown above
4. Save as `res://ai/trees/man_bt.tres`
5. Assign to `ManAIComponent.behavior_tree` export or `CharacterSpawner.ai_behavior_tree`

## Performance Notes

- Tick interval: 0.1s default (10 ticks/sec per unit)
- 30 units = 300 ticks/sec (acceptable)
- Group queries are cached by Godot
- Animation state checks are O(1)

---

## Inventory Integration (gloot)

Units and containers use the **gloot** addon for inventory management.

### Inventory Access Patterns

| Node Type | How to Access Inventory |
|-----------|------------------------|
| ClickableUnit | `unit.inventory` (direct property) |
| Storage Container | `node.get_node("StorageContainer").inventory` |

**BTTakeItem** uses `_get_inventory()` helper that tries all patterns:
1. Direct `inventory` property
2. "Inventory" child node
3. "StorageContainer" child with `inventory` property

### Item Transfer

gloot's Inventory class does NOT have a `transfer()` method. Use:
```gdscript
# Remove from source, add to destination
if source_inv.remove_item(item):
    if not dest_inv.add_item(item):
        # Rollback if add fails
        source_inv.add_item(item)
```

### Item Properties

Items in containers should have:
```json
{
  "category": "food",       // Used by BTSeekResource, BTTakeItem
  "nutritional_value": 20,  // Used by eat_food_item()
  "morale_value": 5,        // Bonus morale from eating
  "warmth_value": 0         // Bonus warmth (hot food)
}
```

---

## Debugging

### Common Issues

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Units go to 0,0,0 | `unit_position` not set | ManAIComponent uses deferred activation |
| Units stuck wandering | BTWander returns RUNNING forever | Fixed: returns SUCCESS after wait |
| Units not eating | BTTakeItem inventory lookup | Fixed: uses `_get_inventory()` helper |
| "Variable not found" spam | BTPlayer activated before blackboard | Ensure BTPlayer `active=false` in scene |
| FPS drops | Debug prints in tick functions | Removed most prints |

### Adding Debug Prints

**DO NOT** add prints in `_tick()` functions - they run every frame and tank FPS.

If you must debug, use conditional prints:
```gdscript
# Only print on state changes
if _state != _last_state:
    print("[BTTask] State changed: %s -> %s" % [_last_state, _state])
    _last_state = _state
```

### Log Location

```
/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log
```

### Verifying Setup

1. **BTPlayer in scene**: Check men.tscn has BTPlayer child with `active=false`
2. **Behavior tree assigned**: BTPlayer.behavior_tree = res://src/ai/man_bt.tres
3. **Groups populated**: Check containers/heat_sources/shelters groups have nodes
4. **Blackboard sync**: ManAIComponent creates BlackboardSync child on unit
