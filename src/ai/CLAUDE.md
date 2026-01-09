# AI Behavior System

Autonomous behavior controllers using composition pattern. Currently implements food-seeking; designed to extend with shelter, fire, work, and other needs.

## Files

| File | Purpose |
|------|---------|
| `needs_controller.gd` | Autonomous hunger management - seeks food containers, eats when critical |

## Architecture

Uses composition over inheritance:

```
ClickableUnit (CharacterBody3D)
└── NeedsController (child node)
    ├── Monitors: _unit.stats.hunger
    ├── Queries: get_tree().get_nodes_in_group("containers")
    ├── Commands: _unit.move_to(), _unit.eat_food_item()
    └── Listens: _unit.reached_destination
```

Each behavior controller is a focused ~100 line script that does ONE thing well. Multiple controllers can be attached to a single unit for layered autonomous behavior.

## NeedsController

Handles autonomous food-seeking behavior for a ClickableUnit.

### Signals
```gdscript
signal seeking_food(container: Node)   # Emitted when starting to pathfind to food
signal eating_food(item_name: String)  # Emitted when consuming food item
```

### Exports
```gdscript
@export var hunger_seek_threshold: float = 50.0  # Start seeking food
@export var hunger_eat_threshold: float = 35.0   # Eat from personal stash (critical)
@export var check_interval: float = 5.0          # Seconds between need checks
```

### State
```gdscript
var _unit: ClickableUnit = null           # Parent unit (set in _ready)
var _check_timer: float = 0.0             # Time since last check
var _seeking_container: Node = null       # Current target container
var _arrived_at_container: bool = false   # Whether we've reached target
```

### Behavior Flow

```
Every 5 seconds (_process):
│
├── hunger <= 35 (critical)?
│   └── YES → Try eat from personal inventory
│       ├── Has food → Eat it, emit eating_food
│       └── No food → Fall through to seeking
│
└── hunger <= 50 and not moving and no food in inventory?
    └── YES → Find nearest food container
        ├── Found → Move to it, emit seeking_food
        └── None → Do nothing

On reached_destination:
└── If was seeking container:
    └── Take one food item from container
        └── Add to personal inventory
```

### Key Functions

```gdscript
func _check_hunger_needs() -> void:
    # Critical: eat from personal stash immediately
    if hunger <= hunger_eat_threshold:
        if _try_eat_personal_food():
            return

    # Low: seek food from containers
    if hunger <= hunger_seek_threshold and not _unit.is_moving:
        if not _unit.has_food_in_inventory():
            _seek_food_container()
```

```gdscript
func _seek_food_container() -> void:
    # Find nearest container with food
    var containers := get_tree().get_nodes_in_group("containers")
    for container in containers:
        var storage: StorageContainer = container.get_node_or_null("StorageContainer")
        if not storage or not storage.has_food():
            continue
        # Distance check and move to nearest...
```

## Integration Points

### With ClickableUnit
- **Parent requirement:** Must be direct child of ClickableUnit
- **Uses:** `_unit.stats.hunger`, `_unit.is_moving`, `_unit.inventory`
- **Calls:** `_unit.move_to()`, `_unit.eat_food_item()`, `_unit.has_food_in_inventory()`
- **Listens:** `_unit.reached_destination` signal

### With StorageContainer
- **Queries:** `get_tree().get_nodes_in_group("containers")`
- **Checks:** `storage.has_food()` to filter valid containers
- **Takes:** `storage.take_food_item()` removes item from container

### With Inventory (gloot)
- **Adds:** `_unit.inventory.add_item(food)` after taking from container

## Scene Setup

```
Captain (CharacterBody3D with clickable_unit.gd)
├── NavigationAgent3D
├── CollisionShape3D
├── AnimationPlayer
└── NeedsController (Node with needs_controller.gd)  ← Add as child
```

Or in code:
```gdscript
var controller := NeedsController.new()
unit.add_child(controller)
```

## Common Modifications

### Adjust hunger thresholds
```gdscript
# More aggressive food seeking
@export var hunger_seek_threshold: float = 70.0  # Seek earlier
@export var hunger_eat_threshold: float = 50.0   # Eat earlier
```

### Add debug output
```gdscript
func _check_hunger_needs() -> void:
    print("[NeedsController] %s hunger: %.1f" % [_unit.unit_name, _unit.stats.hunger])
    # ... rest of function
```

### Disable autonomous behavior temporarily
```gdscript
# In parent unit or game manager
$NeedsController.set_process(false)  # Disable
$NeedsController.set_process(true)   # Re-enable
```

---

## Planned Extensions

The AI system is designed to grow with additional behavior controllers:

### ShelterController (not implemented)
```gdscript
# Seek shelter when:
# - Cold (warmth < threshold)
# - Blizzard active
# - Night time
```

### FireController (not implemented)
```gdscript
# Seek fire/warmth source when:
# - Cold (warmth < threshold)
# - Has firewood in inventory (start fire)
```

### WorkController (not implemented)
```gdscript
# Handle task queue:
# - Accept assigned tasks from player
# - Auto-select tasks when idle
# - Prioritize based on urgency
```

### Behavior Tree System (not implemented)

Future architecture for complex decision-making:
```
BehaviorTree
├── Selector (try in order until success)
│   ├── Sequence: Flee if threatened
│   ├── Sequence: Eat if starving
│   ├── Sequence: Warm up if freezing
│   ├── Sequence: Complete assigned task
│   └── Sequence: Find idle activity
```

## Quirks & Notes

1. **Check interval:** 5 seconds by default to avoid expensive per-frame queries
2. **No interruption:** Once moving to container, won't redirect until arrival
3. **Single item:** Takes only one food item per trip (realistic behavior)
4. **No pathfinding validation:** Assumes NavigationAgent3D handles unreachable containers
5. **Group dependency:** Containers must be in "containers" group to be found
