# Build System

Autonomous construction system for Polaris. Men work autonomously; Officers can be directly assigned.

## Key Classes

| Class | File | Purpose |
|-------|------|---------|
| `BuildRecipe` | build_recipe.gd | Recipe resource defining buildable items |
| `BuildRecipes` | build_recipes.gd | Static database of all recipes |
| `ConstructionSite` | construction_site.gd | Active construction in progress |
| `GhostPlacement` | ghost_placement.gd | Placement preview with validation |
| `WorkbenchComponent` | workbench_component.gd | Workbench material storage & placement |
| `ShipResourceComponent` | ship_resource_component.gd | Ship material pool for gathering |
| `ProgressBar3D` | progress_bar_3d.gd | Floating progress bar billboard |

## Autoload Required

Add `WorkManager` (src/systems/work_manager.gd) as autoload in Project Settings.

## Recipes

| Recipe | Days | Scrap Wood | Nails | Scene |
|--------|------|------------|-------|-------|
| crate | 2 | 3 | 1 | storage_crate_small.tscn |
| barrel | 3 | 4 | 2 | storage_barrel.tscn |
| tent_frame | 4 | 5 | 3 | more_open_small_tent_1.tscn |
| firewood_bundle | 1 | 2 | 0 | (default box) |
| sled | 10 | 10 | 5 | sled_1.tscn |

## Ghost & Construction Site Visuals

Both ghost placement and construction sites instantiate the **full scene** from `result_scene_path`:
- Ghost: Transparent shader, collision disabled, removed from groups
- Under construction: Semi-transparent shader, collision enabled, resource groups removed

This ensures proper transforms/scale for all objects.

## Behavior Tree Tasks

| Task | Purpose |
|------|---------|
| `BTCheckCanWork` | Gate: All stats > 50% |
| `BTFindWork` | Discover work within 30m |
| `BTGatherFromShip` | Gather materials from ship |
| `BTDepositMaterials` | Deposit at workbench/site |
| `BTWorkAtSite` | Perform construction |

### BT Structure (Add to man_bt.tres after SeekFood)

```
BTSequence "WorkBehavior"
├── BTCheckCanWork
├── BTFindWork
├── BTSelector
│   ├── GatherSequence (work_type == "gathering")
│   ├── HaulSequence (work_type == "hauling")
│   └── ConstructSequence (work_type == "constructing")
└── BTCooldown (5s)
```

## Worker Limits

- Gathering: max 2 workers
- Hauling: max 2 workers
- Constructing: max 2 workers per site

Each additional worker adds 25% speed bonus.

## Placement Validation

- Max 75m from workbench
- Max 10% slope
- No collision with objects
- Materials available

Ghost colors:
- Valid: `Color(0.6, 0.7, 0.5, 0.5)` (olive green)
- Invalid: `Color(1.0, 0.3, 0.3, 0.5)` (red)

## Work-Related Traits

| Trait | Effect |
|-------|--------|
| carpenter | +25% construction speed |
| builder | +15% construction speed |
| beast_of_burden | +50% carry capacity |
| resourceful | +25% gathering yield |

## Cancel Construction

Sites can be cancelled via `ConstructionSitePanel`:
- Click site → panel shows progress, materials, workers
- "Cancel Build" button calls `site.cancel_construction()`
- Materials returned to linked workbench via `add_materials()`

## Integration Points

1. **WorkbenchComponent**: Add as child of workbench scene
2. **ShipResourceComponent**: Add as child of Erebus ship scene
3. **WorkManager**: Register as autoload
4. **RTSInputHandler**: Already updated for construction site clicks
5. **WorkbenchPanel**: Already updated to use WorkbenchComponent
6. **ConstructionSitePanel**: Shows site info, cancel button

## User Actions Required (Godot Editor)

1. Add `WorkManager` autoload
2. Add `WorkbenchComponent` to workbench_1.tscn
3. Add `ShipResourceComponent` to erebus.tscn
4. Edit `man_bt.tres` to add Work behavior branch
5. Create `construction_site_panel.tscn` (similar to workbench_panel.tscn)
