# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Polaris** is an arctic survival RTS set in the age of exploration, inspired by The Terror, Franklin/Scott expeditions, Rimworld, and Kenshi. Players manage 10-16 shipwreck survivors trying to endure a year until rescue arrives.

**Engine:** Godot 4.5 (mobile renderer)
**Main Scene:** `main.tscn`

See `GameDesignDocument.md` for complete design specifications.

## Running the Project

Open in Godot 4.5+ and run. The main scene is `main.tscn`.

### Godot Headless Validation

**Godot Path**: `/mnt/c/Users/antih/Desktop/Godot_v4.5.1-stable_win64_console.exe`

```bash
# Validate script and capture errors
/mnt/c/Users/antih/Desktop/Godot_v4.5.1-stable_win64_console.exe \
  --headless --script path/to/script.gd 2>&1
```

**Error Output Captured:**
- Script errors with line numbers: `SCRIPT ERROR: ... at: func_name (res://file.gd:42)`
- Stack traces: `WARNING/ERROR: message\n   at: function (file.cpp:123)`

## Architecture

### Project Structure
```
polaris/
├── src/                          # Game-specific code (NEW)
│   ├── characters/               # Survivor system
│   │   ├── survivor.gd           # CharacterBody3D with NavigationAgent3D
│   │   ├── survivor_stats.gd     # Survival needs resource
│   │   └── trait.gd              # Trait modifiers resource
│   ├── ai/                       # Character behavior
│   │   ├── needs_controller.gd   # Autonomous needs management
│   │   ├── behavior_tree.gd      # State machine for actions
│   │   └── task_queue.gd         # Player-assigned work
│   ├── control/                  # Input and selection
│   │   ├── selection_manager.gd  # Selection singleton
│   │   └── selectable.gd         # Selectable component
│   ├── systems/                  # Core game systems
│   │   ├── time_manager.gd       # Day/night, seasons, rescue timer
│   │   ├── weather_system.gd     # Weather effects
│   │   └── expedition_manager.gd # Sled expeditions
│   ├── items/                    # Inventory system
│   │   ├── item_database.gd      # All game items
│   │   ├── inventory.gd          # Personal inventory
│   │   └── stockpile.gd          # Camp storage
│   ├── building/                 # Construction system
│   │   ├── building_manager.gd   # Building placement
│   │   ├── blueprint.gd          # Construction ghost
│   │   └── building.gd           # Base building class
│   ├── combat/                   # Combat system
│   │   ├── combat_manager.gd     # Combat resolution
│   │   └── enemy.gd              # Hostile entities
│   ├── npcs/                     # Non-player entities
│   │   └── native_camp.gd        # Trade with natives
│   ├── ui/                       # User interface
│   │   ├── hud.gd                # Main game HUD
│   │   ├── character_portraits.gd # Survivor sidebar
│   │   └── inventory_ui.gd       # Inventory display
│   └── game_manager.gd           # Core game loop
├── addons/
│   ├── ninetailsrabbit.indie_blueprint_rpg/  # RPG mechanics
│   ├── terrain_3d/                           # Terrain editing
│   └── 3d_rts_camera/                        # Camera controls
├── characters/                   # Character assets (GLTF models)
├── terrain/                      # Terrain data files
└── main.tscn                     # Main game scene
```

### Autoloads (Singletons)
**Existing (from addons):**
- `IndieBlueprintLootManager` - Loot table management
- `IndieBlueprintTurnityManager` - Turn-based sessions (not used in MVP)
- `IndieBlueprintRecipeManager` - Crafting recipes

**New (to add):**
- `TimeManager` - Day/night, seasons, game speed, rescue timer
- `SelectionManager` - Character selection state
- `GameManager` - Core game state, win/lose conditions

### Key Systems

**Character System:**
- Survivors are `CharacterBody3D` with `NavigationAgent3D` for pathfinding
- `IndieBlueprintHealth` component for health/damage
- Custom `SurvivorStats` resource for needs (hunger, cold, morale, energy)
- `Trait` resources modify behavior and stats

**Needs/AI:**
- Priority: Player commands > Critical needs > Assigned work > Idle
- Characters autonomously seek food, warmth, rest when needs are critical
- Player assigns work tasks (build, haul, hunt)

**Time System:**
- Real-time with pause/1x/2x/4x speed controls
- Day/night cycle affects lighting and temperature
- Seasons: Summer (90d), Autumn (90d), Winter (90d), Spring (95+d)
- Rescue timer: 365 + random(30-180) days

**Building System:**
- Blueprint placement -> Material hauling -> Construction time -> Complete
- Buildings: Tent, Improved Shelter, Storage Pile, Fire Pit, Workshop

**Combat:**
- Simple Rimworld-style auto-attack
- Enemies: Wolves (pack), Polar Bears (solitary)
- Uses `IndieBlueprintHealth` for damage

## Key Addon: indie-blueprint-rpg

Located in `addons/ninetailsrabbit.indie_blueprint_rpg/src/`:

**health/** - Health component
- Attach `IndieBlueprintHealth` as child node to any entity
- Methods: `damage(amount)`, `health(amount)`, `enable_invulnerability(bool, time)`
- Signals: `health_changed(amount, type)`, `died`

**probability/loot/** - Loot generation
- `LootTableData` resource defines probability rules
- `LootItem` wraps items with weight/rarity/chance
- `LootieTable.generate(times)` returns `Array[LootItem]`

**items/craft/** - Crafting system
- `CraftableItem` and `Recipe` resources
- `IndieBlueprintRecipeManager` singleton manages recipes

**stats/** - RPG stats (extend for survival needs)
- `RpgCharacterMetaStats` base stats resource

## Code Conventions

**Critical Rules:**
- NEVER null check without understanding WHY it's null
- Use descriptive var names: `snow_streak_particles` not `particles`
- Expose vars to Inspector when possible and logical
- Prefer ints over floats (especially for display/debug)
- Use composition over inheritance
- Signals for communication, not direct references

**Static Typing:**
```gdscript
var survivor: Survivor = $Survivor
func calculate_cold(temperature: float) -> float:
```

**Signals for Events:**
```gdscript
signal need_critical(need_type: String, value: float)
signal survivor_died(survivor: Survivor)
```

**Resources for Data:**
```gdscript
class_name SurvivorStats extends Resource
@export var hunger: float = 100.0
@export var cold: float = 100.0
```

**Components as Child Nodes:**
```
Survivor (CharacterBody3D)
├── CollisionShape3D
├── NavigationAgent3D
├── IndieBlueprintHealth
├── NeedsController
└── Model (Node3D)
```

**Autoload Access:**
```gdscript
TimeManager.pause()
SelectionManager.select(survivor)
GameManager.check_win_condition()
```

## Common Godot 4 Pitfalls

**Reserved Keywords:**
- `trait` is reserved in GDScript 4 - use `survivor_trait` or similar instead

**Tweens:**
- Call `set_loops()` without args for infinite: `create_tween().set_loops()`
- ALWAYS bind to node: `node.create_tween()` not `create_tween()` (prevents "Target object freed" errors)
- Check `is_instance_valid()` before animating nodes that might be freed

**get_rect():**
- Control nodes: Have `get_rect()` and `get_global_rect()`
- Node2D nodes (Sprite2D, etc.): Only `get_rect()`, NO `get_global_rect()`
- `get_rect()` behavior differs: Control=global, Node2D=local relative to pivot
- Don't mix Control/Node2D in parent-child for bounds checking

**Property Checking:**
- `.has()` is ONLY for Dictionaries/Arrays, NOT for Nodes/Objects
- WRONG: `node.has("property")` ❌ (will crash with "Invalid call. Nonexistent function 'has'")
- RIGHT: `"property" in node` ✅
- Alternative: `node.get("property")` returns null if doesn't exist
- Example:
  ```gdscript
  # Check property exists (Dictionary)
  if my_dict.has("key"):  # ✅ Valid - Dictionary

  # Check property exists (Node)
  if "health" in player:  # ✅ Valid - Node property check
  if player.has("health"):  # ❌ INVALID - will crash
  ```

**Type Inference:**
- Dictionary values have no inferred type - always explicitly type:
  ```gdscript
  # BAD - type cannot be inferred
  var sunrise := config.sunrise_hour

  # GOOD - explicit type
  var sunrise: int = config.sunrise_hour
  ```

**Input Actions:**
- The RTS camera uses `ui_shift` for speed boost - add this to Project Settings > Input Map
- Default `ui_*` actions: `ui_left`, `ui_right`, `ui_up`, `ui_down`, `ui_accept`, `ui_cancel`
- `ui_shift` is NOT a default action - must be manually added

## Navigation Setup

Terrain3D requires NavigationRegion3D with baked NavigationMesh:
1. Select Terrain3D node → Terrain3D menu → "Set up Navigation"
2. Use the "Navigable" terrain tool to paint walkable areas (shows magenta)
3. Select Terrain3D → Terrain3D menu → "Bake NavMesh"
4. Save the scene immediately after baking
5. Characters use NavigationAgent3D to pathfind

**Important:** Do NOT use the standard NavigationRegion3D bake button - only use Terrain3D's baker.

## Known Issues / TODO

**Slope Navigation (LOW PRIORITY):**
- Characters can get stuck on steeper slopes due to known Godot 4 NavigationAgent3D issues
- See: https://github.com/godotengine/godot/issues/88237
- Potential fixes: Adjust NavigationMesh `agent_max_slope`, `agent_max_climb` settings
- Or adjust `cell_size`/`cell_height` in NavigationMesh for finer resolution on slopes

## Common Tasks

**Add new item type:**
1. Create `LootItem` resource in `res://items/`
2. Set weight/rarity/chance as needed
3. Add to relevant `LootTableData`

**Add new building:**
1. Create building scene in `src/building/buildings/`
2. Extend `Building` base class
3. Register in `BuildingManager`

**Add new trait:**
1. Create `Trait` resource
2. Define stat modifiers and behavior flags
3. Apply to survivors during generation
