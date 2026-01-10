# Data Files

Game data definitions including item prototypes for the inventory system.

## Files

| File | Purpose |
|------|---------|
| `items_protoset.json` | Item definitions for gloot inventory addon |

## Item Protoset

The gloot addon uses a JSON "protoset" to define all item types in the game. Each item has an ID (the key) and properties.

### File Format

```json
{
    "item_id": {
        "name": "Display Name",
        "image": "res://path/to/icon.png",
        "size": "Vector2i(width, height)",
        "category": "food|fuel|tool",
        "max_stack_size": 5,
        "weight": 1.0,
        // Category-specific properties...
    }
}
```

### Property Reference

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | String | Yes | Display name in UI |
| `image` | String | Yes | Path to icon texture |
| `size` | String | Yes | Grid size as "Vector2i(w, h)" |
| `category` | String | Yes | Item category for filtering |
| `max_stack_size` | int | Yes | Maximum items per stack |
| `weight` | float | Yes | Weight in kg |
| `nutritional_value` | float | Food | Hunger restored when eaten |
| `morale_value` | float | Food | Morale restored (optional) |
| `warmth_value` | float | Food | Warmth restored (optional) |
| `burn_duration` | float | Fuel | Minutes of fire time |
| `durability` | float | Tool | Starting durability |

### Size Format

Grid sizes are stored as strings due to JSON limitations:
- `"Vector2i(1, 1)"` - 1x1 cell
- `"Vector2i(2, 2)"` - 2x2 cells
- `"Vector2i(1, 2)"` - 1 wide, 2 tall

Parsed by gloot into actual Vector2i.

---

## Current Items

### Food Items (1x1)

| ID | Name | Nutrition | Morale | Warmth | Stack | Weight |
|----|------|-----------|--------|--------|-------|--------|
| `hardtack` | Hardtack | 15 | - | - | 5 | 0.3 kg |
| `salt_pork` | Salt Pork | 35 | - | - | 5 | 1.0 kg |
| `pemmican` | Pemmican | 40 | - | - | 5 | 0.5 kg |
| `tinned_meat` | Tinned Meat | 30 | - | - | 5 | 0.8 kg |
| `rum` | Rum | 5 | +15 | +10 | 5 | 0.7 kg |

**Notes:**
- Pemmican has the highest nutritional value (40) - historically accurate as it was the main expedition food
- Rum provides minimal nutrition but boosts morale and warmth
- All food items are 1x1 and stack to 5

### Fuel Items (2x2)

| ID | Name | Burn Duration | Stack | Weight |
|----|------|---------------|-------|--------|
| `firewood` | Firewood | 45 min | 3 | 3.0 kg |
| `coal` | Coal | 90 min | 3 | 2.5 kg |

**Notes:**
- Coal burns twice as long as firewood
- Larger grid size (2x2) limits inventory space usage
- Lower stack size (3) reflects bulk

### Tool Items

| ID | Name | Size | Durability | Stack | Weight |
|----|------|------|------------|-------|--------|
| `knife` | Knife | 1x2 | 100 | 1 | 0.4 kg |
| `hatchet` | Hatchet | 2x2 | 100 | 1 | 1.5 kg |

**Notes:**
- Tools don't stack (max_stack_size = 1)
- Durability decreases with use (not yet implemented)

---

## Categories

Categories determine which storage containers accept which items:

```gdscript
# In storage_container.gd
const FOOD_CATEGORIES: Array[String] = ["food"]
const GENERAL_CATEGORIES: Array[String] = ["fuel", "tool", "misc"]
```

| Category | Accepted By | Example Items |
|----------|-------------|---------------|
| `food` | Barrels (FOOD storage) | hardtack, pemmican, rum |
| `fuel` | Crates (GENERAL storage) | firewood, coal |
| `tool` | Crates (GENERAL storage) | knife, hatchet |
| `misc` | Crates (GENERAL storage) | (not yet implemented) |

---

## Adding New Items

### Step 1: Add to Protoset

```json
"lantern_oil": {
    "name": "Lantern Oil",
    "image": "res://inventory_icons/lantern_oil.png",
    "size": "Vector2i(1, 2)",
    "category": "fuel",
    "burn_duration": 120.0,
    "max_stack_size": 3,
    "weight": 0.5
}
```

### Step 2: Create Icon

Add icon to `inventory_icons/` directory:
- Recommended size: 64x64 or 128x128 pixels
- Format: PNG with transparency
- Style: Simple, recognizable silhouette

### Step 3: Update Spawner Pools (if applicable)

```gdscript
# In object_spawner.gd
const BARREL_ITEMS: Array[String] = ["hardtack", "salt_pork", ...]
const CRATE_ITEMS: Array[String] = ["firewood", "coal", "lantern_oil"]  # Add here
```

### Step 4: Add Category (if new)

If using a new category:

```gdscript
# In storage_container.gd
const GENERAL_CATEGORIES: Array[String] = ["fuel", "tool", "misc", "light"]
```

---

## Reading Items in Code

```gdscript
# Get item from inventory
var item: InventoryItem = inventory.get_item_by_id("hardtack")

# Read properties
var name: String = item.get_property("name", "Unknown")
var nutrition: float = item.get_property("nutritional_value", 0.0)
var category: String = item.get_property("category", "misc")
var size: Vector2i = item.get_property("size")  # Auto-parsed by gloot

# Check if item is food
if item.get_property("category", "") == "food":
    var nutrition := item.get_property("nutritional_value", 0.0)
```

---

## Integration Points

### With StorageContainer
```gdscript
# Add item by ID (creates from protoset)
var item: InventoryItem = storage.add_item_by_id("hardtack")

# Check category acceptance
storage.can_accept_item(item)  # Uses FOOD_CATEGORIES or GENERAL_CATEGORIES
```

### With ClickableUnit
```gdscript
# Eat food item
func eat_food_item(item: InventoryItem) -> void:
    var nutrition := item.get_property("nutritional_value", 0.0)
    var morale := item.get_property("morale_value", 0.0)
    var warmth := item.get_property("warmth_value", 0.0)

    stats.hunger += nutrition
    stats.morale += morale
    stats.warmth += warmth

    inventory.remove_item(item)
```

### With NeedsController
```gdscript
# Check if has food
func has_food() -> bool:
    for item in inventory.get_items():
        if item.get_property("category", "") == "food":
            return true
    return false
```

---

## Planned Items

Future items that could be added:

### Medical
```json
"bandage": {
    "name": "Bandage",
    "size": "Vector2i(1, 1)",
    "category": "medical",
    "heal_amount": 15.0
}
```

### Clothing
```json
"fur_coat": {
    "name": "Fur Coat",
    "size": "Vector2i(2, 3)",
    "category": "clothing",
    "cold_resistance": 25.0,
    "slot": "torso"
}
```

### Materials
```json
"scrap_metal": {
    "name": "Scrap Metal",
    "size": "Vector2i(1, 1)",
    "category": "material",
    "max_stack_size": 10
}
```

---

## Troubleshooting

### Item not appearing in inventory
1. Check protoset key matches exactly (case-sensitive)
2. Verify icon path is correct
3. Check grid has space for item size

### Item not accepted by container
1. Verify item category matches storage type
2. Check `FOOD_CATEGORIES` or `GENERAL_CATEGORIES` in `storage_container.gd`

### Icon not showing
1. Verify path starts with `res://`
2. Check file exists and is imported
3. Try reimporting the texture
