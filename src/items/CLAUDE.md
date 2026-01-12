# Inventory System

Grid-based inventory using Godot's [gloot](https://github.com/peter-kish/gloot) addon for storage containers and unit inventories.

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────┐
│                     Inventory System                         │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐         ┌─────────────────────────┐    │
│  │items_protoset.json│◄───────┤ Item Definitions        │    │
│  └────────┬────────┘         │ (food, fuel, tools)     │    │
│           │                  └─────────────────────────┘    │
│           ▼                                                  │
│  ┌─────────────────┐         ┌─────────────────────────┐    │
│  │ StorageContainer │────────►│ Inventory + GridConstraint│  │
│  │ (barrels/crates) │         └─────────────────────────┘    │
│  └─────────────────┘                                         │
│                                                              │
│  ┌─────────────────┐         ┌─────────────────────────┐    │
│  │ ClickableUnit    │────────►│ Inventory (5x5 grid)    │    │
│  │ (survivors)      │         └─────────────────────────┘    │
│  └─────────────────┘                                         │
│                                                              │
│  ┌─────────────────┐         ┌─────────────────────────┐    │
│  │ InventoryHUD     │────────►│ UI Panels for drag/drop │    │
│  └─────────────────┘         └─────────────────────────┘    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Key Files

| File | Purpose |
|------|---------|
| `data/items_protoset.json` | Item definitions (prototypes) |
| `src/items/storage_container.gd` | Container component script |
| `src/characters/clickable_unit.gd` | Unit inventory (lines 358-418) |
| `ui/inventory_hud.gd` | HUD manager for panels |
| `ui/inventory_panel.gd` | Reusable inventory panel UI |
| `src/systems/object_spawner.gd` | Spawns containers with items |
| `ai/man_ai_controller.gd` | Autonomous behavior (includes food-seeking) |

## Item Definitions

Items are defined in `data/items_protoset.json`. Each item has:

```json
{
  "hardtack": {
    "name": "Hardtack",
    "size": "Vector2i(1, 1)",
    "category": "food",
    "nutritional_value": 15.0,
    "max_stack_size": 5,
    "weight": 0.3
  }
}
```

### Current Items

**Food (1x1 grid):**
| ID | Name | Nutrition | Special |
|----|------|-----------|---------|
| `hardtack` | Hardtack | 15 | - |
| `salt_pork` | Salt Pork | 35 | - |
| `pemmican` | Pemmican | 40 | - |
| `tinned_meat` | Tinned Meat | 30 | - |
| `rum` | Rum | 5 | +15 morale, +10 warmth |

**Fuel (2x2 grid):**
| ID | Name | Burn Duration |
|----|------|---------------|
| `firewood` | Firewood | 45 min |
| `coal` | Coal | 90 min |

**Tools:**
| ID | Name | Size | Durability |
|----|------|------|------------|
| `knife` | Knife | 1x2 | 100 |
| `hatchet` | Hatchet | 2x2 | 100 |

## Adding New Items

1. Add definition to `data/items_protoset.json`:
```json
"lantern_oil": {
  "name": "Lantern Oil",
  "size": "Vector2i(1, 2)",
  "category": "fuel",
  "burn_duration": 120.0,
  "max_stack_size": 3,
  "weight": 0.5
}
```

2. Add icon to `ui/icons/items/` (optional but recommended)

3. If new category, update `StorageContainer` category arrays:
```gdscript
const FOOD_CATEGORIES: Array[String] = ["food"]
const GENERAL_CATEGORIES: Array[String] = ["fuel", "tool", "misc", "light"]
```

## Storage Containers

`StorageContainer` is a composition-based component. Attach as child of a 3D object.

### Storage Types

| Type | Accepts | Use Case |
|------|---------|----------|
| `FOOD` | food category only | Barrels |
| `GENERAL` | fuel, tool, misc | Crates |

### Scene Setup

```
StorageBarrel (Node3D)
├── barrel_mesh (MeshInstance3D)
│   └── StaticBody3D
│       └── CollisionShape3D
└── StorageContainer (Node with script)
    └── Inventory (auto-created)
        └── GridConstraint (auto-created)
```

The root node must be added to `"containers"` group (done automatically by StorageContainer).

### API

```gdscript
# Get container from 3D object
var container: StorageContainer = node.get_node("StorageContainer")

# Add items
container.add_item_by_id("hardtack")
container.add_item_by_id("salt_pork")

# Query items
container.has_food()                    # bool
container.get_first_food_item()         # InventoryItem
container.get_items_of_category("fuel") # Array[InventoryItem]
container.get_item_count()              # int

# Take items (removes from inventory)
var food: InventoryItem = container.take_food_item()

# Open/close (triggers UI)
container.open()
container.close()

# Check category acceptance
container.can_accept_item(item)  # bool
```

### Signals

```gdscript
signal inventory_opened(container: StorageContainer)
signal inventory_closed(container: StorageContainer)
signal contents_changed
```

## Unit Inventory

Each `ClickableUnit` has a 5x5 inventory grid.

### API

```gdscript
var unit: ClickableUnit

# Check/get food
unit.has_food_in_inventory()      # bool
unit.get_food_from_inventory()    # InventoryItem (doesn't remove)

# Consume food (removes item, restores stats)
unit.eat_food_item(item)

# Direct inventory access
unit.inventory.get_items()
unit.inventory.create_and_add_item("hardtack")
unit.inventory.remove_item(item)
```

### Signals

```gdscript
signal inventory_changed  # When items added/removed
```

## Inventory HUD

`InventoryHUD` manages UI panels for viewing/transferring items.

### Controls

| Key/Action | Effect |
|------------|--------|
| `I` | Toggle selected unit's inventory |
| Click container | Open container inventory |
| Drag & drop | Transfer items between inventories |

### API

```gdscript
var hud: InventoryHUD

# Open/close panels
hud.open_container(container)
hud.close_container()
hud.open_unit_inventory(unit)
hud.close_unit_inventory()

# Query state
hud.is_any_panel_open()  # bool
```

### Signals

```gdscript
signal container_opened(container: StorageContainer)
signal container_closed
signal unit_inventory_opened(unit: ClickableUnit)
signal unit_inventory_closed
```

## Autonomous Behavior

`ManAIController` (child of ClickableUnit) handles automatic food-seeking via LimboAI behavior tree:

1. When hunger drops below threshold (set via BTCheckAgentProperty):
   - AI seeks nearest container with food
   - Takes food item and eats it

See [AI System](../../ai/CLAUDE.md) for full behavior tree documentation.

## Object Spawner

`ObjectSpawner` spawns containers with random items.

```gdscript
var spawner = preload("res://src/systems/object_spawner.gd").new()
add_child(spawner)

# Spawn around a position
spawner.spawn_radius = 30.0
spawner.spawn_containers(6, 6, center_position)  # 6 barrels, 6 crates
```

Items are randomly populated:
- Barrels: 2-5 food items
- Crates: 2-4 fuel/tool items

## Extending the System

### Adding Equipment Slots

To add worn equipment (clothing, weapons):

1. Create `equipment_slots.gd` resource:
```gdscript
class_name EquipmentSlots extends Resource
@export var head: InventoryItem
@export var torso: InventoryItem
@export var hands: InventoryItem
@export var feet: InventoryItem
@export var weapon: InventoryItem
```

2. Add to ClickableUnit:
```gdscript
var equipment: EquipmentSlots = EquipmentSlots.new()

func equip_item(item: InventoryItem, slot: String) -> bool:
    # Validate item fits slot based on category
    # Move from inventory to equipment
    pass
```

### Adding Crafting

To combine items:

1. Define recipes in a JSON or resource file
2. Create `crafting_station.gd` that checks player has ingredients
3. Remove ingredients, add output item

### Adding Item Decay

To make food spoil:

1. Add `created_time: float` property to items
2. In TimeManager hourly update, check age vs `spoil_time`
3. Either remove item or convert to "spoiled_food" variant

## Troubleshooting

### Container clicks not working
- Ensure container root has `StorageContainer` child node
- Root must be in `"containers"` group (auto-added by script)
- Colliders must exist on the mesh

### Items not appearing in inventory
- Check protoset is loaded: `inventory.protoset != null`
- Verify item ID matches JSON key exactly
- Check grid has space: `grid_constraint.size`

### Drag/drop not working
- Panels must use gloot's `CtrlInventoryGrid` or equivalent
- Both inventories need same protoset reference
