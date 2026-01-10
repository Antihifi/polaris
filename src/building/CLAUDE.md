# Building System

**Status:** Not Yet Implemented

Construction system for shelters, storage structures, and fire pits.

## Planned Purpose

Allow survivors to construct buildings that provide:
- **Shelter:** Protection from cold and weather
- **Storage:** Additional container space
- **Fire pits:** Heat source for warmth
- **Workstations:** Crafting and repair locations

## Directory Structure

```
src/building/
├── CLAUDE.md           # This file
├── buildings/          # Building definition resources (empty)
└── (planned files)
```

## Planned Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Building System                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ BuildingTemplate│     │ Building Resource           │    │
│  │ (Resource)      │────►│ - name, description         │    │
│  └─────────────────┘     │ - construction_cost         │    │
│                          │ - build_time                │    │
│                          │ - shelter_value             │    │
│                          │ - storage_capacity          │    │
│                          └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ BuildingPlacer  │     │ Handles ghost placement,    │    │
│  │ (Node)          │────►│ validation, snap to grid    │    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ ConstructionSite│     │ In-progress building with   │    │
│  │ (Node3D)        │────►│ progress bar, worker slots  │    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ Building        │     │ Completed building with     │    │
│  │ (Node3D)        │────►│ functionality (shelter,etc) │    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Planned Building Types

### Shelter Buildings

| Building | Shelter Value | Materials | Build Time |
|----------|---------------|-----------|------------|
| Lean-to | 25% | 5 firewood | 30 min |
| Snow shelter | 40% | None (snow) | 45 min |
| Tent | 50% | Canvas, poles | 20 min |
| Stone hut | 75% | 20 rocks | 4 hours |

### Utility Buildings

| Building | Function | Materials | Build Time |
|----------|----------|-----------|------------|
| Fire pit | Heat source | 3 rocks | 10 min |
| Storage rack | 4x6 storage | 4 firewood | 20 min |
| Smoking rack | Food preservation | 6 firewood | 30 min |
| Workbench | Crafting station | 8 firewood, tools | 1 hour |

## Planned Features

### Construction Tasks
```gdscript
# Survivor assigned to build
class_name ConstructionTask extends Task

var target_site: ConstructionSite
var work_progress: float = 0.0

func work(delta: float, efficiency: float) -> void:
    work_progress += delta * efficiency
    target_site.add_progress(work_progress)
```

### Resource Costs
```gdscript
# In BuildingTemplate resource
@export var material_costs: Dictionary = {
    "firewood": 5,
    "rock": 10
}

func can_afford(inventory: Inventory) -> bool:
    for item_id in material_costs:
        if inventory.count_item(item_id) < material_costs[item_id]:
            return false
    return true
```

### Shelter Mechanics
Buildings provide shelter value that reduces cold effect:
```gdscript
# In survivor needs update
var shelter_value := _get_nearby_shelter_value()
var cold_reduction := shelter_value * ambient_temperature * 0.5
stats.warmth -= maxf(cold_effect - cold_reduction, 0.0)
```

### Decay System
Buildings deteriorate over time:
```gdscript
@export var max_durability: float = 100.0
@export var decay_rate: float = 0.5  # Per day

var current_durability: float = max_durability

func _on_day_passed() -> void:
    current_durability -= decay_rate
    if current_durability <= 0.0:
        _collapse()
```

## Integration Points

### With TimeManager
- Construction progress ticks with game time
- Decay updates on `day_passed` signal

### With Inventory System
- Material costs checked and deducted
- StorageContainer added to storage buildings

### With Survivors
- Construction assigned as tasks
- Shelter value affects warmth decay
- Work efficiency affects build speed

### With Weather System
- Shelter reduces weather effects
- Fire pits provide warmth radius
- Buildings block wind

## Implementation Notes

When implementing this system:

1. **Start simple:** Lean-to shelter only
2. **Use composition:** Building functionality as components
3. **Grid-based placement:** Snap to terrain grid
4. **Visual feedback:** Ghost preview during placement
5. **Progress visualization:** Construction site with scaffold mesh

## Related Systems

- `src/characters/` - Survivor task assignment
- `src/items/` - Material costs
- `src/systems/time_manager.gd` - Time-based progression
- `src/systems/weather/` - Weather protection
