# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ⚠️ DEBUGGING: CHECK LOGS FIRST

**ALWAYS check the Godot logs before asking the user about runtime errors.** The logs contain print statements, errors, and debug output that are essential for diagnosing issues.

### Log Location
```
/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log
```

### Quick Commands
```bash
# View latest log (most recent output)
cat "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log" | tail -200

# Search for specific errors
grep -i "error\|fail\|exception" "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log" | tail -50

# Find timestamped logs (if godot.log is stale)
ls -la "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/"
```

---

## Project Overview

**Polaris** is an arctic survival RTS set in the age of exploration, inspired by The Terror, Franklin/Scott expeditions, Rimworld, and Kenshi. Players manage 10-16 shipwreck survivors trying to endure a year until rescue arrives.

- **Engine:** Godot 4.5 (mobile renderer)
- **Main Scene:** `main.tscn`
- **Historical Setting:** September 1846, Franklin expedition trapped in ice (uses 60°N in-game, see [Systems CLAUDE.md](src/systems/CLAUDE.md) for latitude quirk)

See `GameDesignDocument.md` for complete design specifications.

## Running the Project

Open in Godot 4.5+ and run. The main scene is `main.tscn`.

### Godot Headless Validation

**Godot Path**: `/mnt/c/Users/antih/Desktop/Godot_v4.5.1-stable_win64_console.exe`

```bash
/mnt/c/Users/antih/Desktop/Godot_v4.5.1-stable_win64_console.exe \
  --headless --script path/to/script.gd 2>&1
```

## Architecture Overview

### Project Structure (Implemented)

```
polaris/
├── src/                          # Game-specific code
│   ├── camera/                   # RTS camera system
│   │   └── rts_camera.gd         # WASD, edge scroll, zoom, MMB orbit
│   ├── characters/               # Survivor/unit system
│   │   ├── clickable_unit.gd     # Base click-to-move CharacterBody3D
│   │   ├── survivor.gd           # Full survivor with traits/states
│   │   ├── survivor_stats.gd     # Survival needs resource
│   │   ├── trait.gd              # Trait modifiers resource
│   │   └── eye_controller.gd     # Character eye animation
│   ├── control/                  # Input handling
│   │   ├── rts_input_handler.gd  # Click select, right-click move
│   │   └── selection_manager.gd  # Multi-select, control groups
│   ├── systems/                  # Core game systems
│   │   ├── time_manager.gd       # Sky3D integration, seasons, rescue timer
│   │   └── weather/              # Weather effects
│   │       ├── snow_controller.gd    # Snow intensity management
│   │       └── snow_particles.tscn   # GPU particle system
│   ├── terrain/                  # Procedural terrain generation
│   │   ├── terrain_generator.gd  # Main orchestrator, generation pipeline
│   │   ├── island_shape.gd       # Teardrop island mask generation
│   │   ├── heightmap_generator.gd# Multi-octave noise heightmaps
│   │   ├── texture_painter.gd    # Height/slope-based texture assignment
│   │   ├── poi_placer.gd         # POI placement with pathfinding validation
│   │   ├── seed_manager.gd       # Seed handling and persistence
│   │   └── CLAUDE.md             # Comprehensive implementation guide
│   ├── ui/                       # User interface
│   │   ├── game_hud.gd           # Main HUD manager
│   │   ├── time_hud.gd           # Clock, date, temperature display
│   │   └── character_stats.gd    # Survivor stats panel
│   ├── game_manager.gd           # Game state, win/lose, ambient audio
│   └── main_controller.gd        # Scene bootstrap
├── addons/
│   ├── sky_3d/                   # Day/night cycle, sun/moon, atmosphere
│   ├── terrain_3d/               # Large terrain with LOD
│   ├── ninetailsrabbit.indie_blueprint_rpg/  # Health, loot, crafting
│   ├── sound_manager/            # Audio management
│   └── mixamo_animation_retargeter/  # Animation tools
├── characters/                   # Character assets (GLTF models)
│   └── captain/                  # Captain model with animations
├── terrain/                      # Terrain data files
├── sounds/                       # Audio assets
└── main.tscn                     # Main game scene
```

### Partially Implemented

These directories have initial work or design documentation:
- `src/ai/` - LimboAI behavior trees for Officers/Men (see [AI System](src/ai/CLAUDE.md) for implementation guide)

### Not Yet Implemented

These directories exist but are empty/placeholder:
- `src/building/` - Construction system
- `src/combat/` - Combat resolution
- `src/items/` - Inventory system
- `src/npcs/` - Native camps, trading

### Autoloads (Singletons)

Configured in `project.godot`:

| Autoload | Path | Purpose |
|----------|------|---------|
| `TimeManager` | `src/systems/time_manager.gd` | Day/night, seasons, rescue timer, Sky3D sync |
| `SelectionManager` | `src/control/selection_manager.gd` | Multi-selection, control groups |
| `GameManager` | `src/game_manager.gd` | Game state, win/lose, ambient audio |
| `SoundManager` | `addons/sound_manager/` | Audio pooling and management |
| `IndieBlueprintLootManager` | `addons/.../loot_manager.gd` | Loot tables |
| `IndieBlueprintRecipeManager` | `addons/.../recipe_manager.tscn` | Crafting recipes |

### Key Addons

| Addon | Purpose | Integration Point |
|-------|---------|-------------------|
| **LimboAI** | Behavior trees + state machines for AI | `BTPlayer` on each survivor unit (see [AI System](src/ai/CLAUDE.md)) |
| **Sky3D** | Day/night cycle, sun/moon position, atmosphere | `TimeManager` syncs time, sets arctic latitude |
| **Terrain3D** | Large terrain with LOD, procedural generation | `TerrainGenerator` uses API for heightmap import, texture painting; `RTSInputHandler` queries height |
| **indie_blueprint_rpg** | Health component, loot tables, crafting | `Survivor` uses `IndieBlueprintHealth` |

## System Integration Map

```
┌─────────────────────────────────────────────────────────────────┐
│                        main.tscn                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │RTScamera │  │ Sky3D    │  │Terrain3D │  │ Captain  │        │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘        │
└───────┼─────────────┼─────────────┼─────────────┼──────────────┘
        │             │             │             │
        ▼             ▼             ▼             ▼
┌───────────────┐ ┌───────────┐ ┌───────────┐ ┌───────────────────┐
│RTSInputHandler│ │TimeManager│ │Height     │ │ClickableUnit      │
│ - click select│◄┤ - syncs   │ │queries    │ │ - NavigationAgent │
│ - right-click │ │   time    │ │for move   │ │ - SurvivorStats   │
│   move        │ │ - seasons │ │targets    │ │ - animations      │
└───────┬───────┘ └───────────┘ └───────────┘ └─────────┬─────────┘
        │                                               │
        ▼                                               ▼
┌───────────────┐                               ┌───────────────────┐
│  GameHUD      │                               │ stats_changed     │
│ - TimeHUD     │◄──────────────────────────────┤ signal updates UI │
│ - CharStats   │                               └───────────────────┘
└───────────────┘
```

## Documentation Requirements

**ALWAYS update documentation as you work.** Documentation must be kept current at every level:

### Root CLAUDE.md
- High-level architecture and project overview
- Cross-cutting concerns and conventions
- Links to subsystem documentation

### Subsystem CLAUDE.md Files
Each major directory (`src/camera/`, `src/characters/`, `src/control/`, `src/systems/`, `ui/`, etc.) must have its own `CLAUDE.md` containing:
- Purpose and responsibilities of that subsystem
- All files in the directory with their purposes
- Signals, enums, and key configuration
- API documentation for public functions
- Integration points with other systems
- **Known quirks, workarounds, and gotchas** (critical for future debugging)
- Common modifications and how to make them

### When to Update Documentation
- **After fixing a bug**: Document the root cause and solution, especially if non-obvious
- **After adding features**: Document new signals, functions, configuration options
- **After discovering quirks**: Immediately document addon/engine quirks with workarounds
- **After refactoring**: Update affected file lists and integration points

### Documentation Format
- Use tables for file listings and configuration
- Include code examples for common patterns
- Mark important warnings with **bold** or dedicated sections
- Keep documentation practical - focus on "what you need to know to work with this code"

---

## Code Conventions

### Critical Rules

1. **NEVER null check without understanding WHY it's null**
2. **Use descriptive var names:** `snow_streak_particles` not `particles`
3. **Expose vars to Inspector** when possible and logical
4. **Prefer ints over floats** (especially for display/debug)
5. **Composition over inheritance** - always
6. **Keep scripts SMALL** - each script does one thing well (~100-150 lines max)
7. **Signals for communication**, not direct references
8. **Flag performance concerns** - always warn about potentially expensive operations (see Performance section)

### Composition & Script Size

- **Behavior as components**: AI behaviors, controllers, etc. are child nodes with focused scripts
- Child scripts reference parent via `get_parent()` pattern
- Example: `NeedsController` is a child of `ClickableUnit`, not part of the unit script
- If a script exceeds ~150 lines, split it into focused child components

### Static Typing (Required)

```gdscript
var survivor: Survivor = $Survivor
func calculate_cold(temperature: float) -> float:
var time_scale: float = _time_manager.time_scale  # Explicit type for dict values
```

### Signals Pattern

```gdscript
# Define
signal stats_changed
signal need_critical(need_name: String, value: float)

# Emit
stats_changed.emit()
need_critical.emit("hunger", stats.hunger)

# Connect
unit.stats_changed.connect(_on_stats_changed)
```

### Resources for Data

```gdscript
class_name SurvivorStats extends Resource
@export_range(0.0, 100.0) var hunger: float = 100.0:
    set(value):
        hunger = clampf(value, 0.0, 100.0)
```

### Node Groups

| Group | Members | Purpose |
|-------|---------|---------|
| `survivors` | All survivor units | TimeManager hourly updates |
| `selectable_units` | Clickable entities | Input handler queries |
| `terrain` | Terrain3D node | Height queries |

## Common Godot 4 Pitfalls

### Scene Creation - ASK, Don't Generate

**NEVER programmatically generate complex .tscn scene files.** Godot's scene format has complex UIDs, ArrayMesh binary data, and resource references that are easily corrupted when written by hand or script.

Instead:
- **ASK the user** to create scenes in the Godot editor
- Provide clear instructions for what nodes/properties to set up
- Only edit simple properties in existing scenes (transforms, exports, etc.)

This applies especially to:
- Scenes with custom meshes (ArrayMesh, QuadMesh with specific vertices)
- Scenes with shader materials and noise textures
- Any scene requiring specific UID references

### Reserved Keywords
- `trait` is reserved - use `survivor_trait` instead

### Property Checking
```gdscript
# WRONG - will crash
if node.has("property"):  # ❌

# RIGHT
if "property" in node:    # ✅
var val = node.get("property")  # Returns null if missing
```

### Dictionary Type Inference
```gdscript
# BAD - type cannot be inferred
var sunrise := config.sunrise_hour

# GOOD - explicit type
var sunrise: int = config.sunrise_hour
```

### Tweens
```gdscript
# ALWAYS bind to node (prevents "Target object freed")
var tween := node.create_tween()  # ✅
var tween := create_tween()       # ❌

# Check validity before animating
if is_instance_valid(target):
    target.create_tween().tween_property(...)
```

### Input Actions
- `ui_shift` is NOT a default action - manually added in Project Settings
- Default actions: `ui_left`, `ui_right`, `ui_up`, `ui_down`, `ui_accept`, `ui_cancel`

## Performance Guidelines

**Always warn about potentially expensive implementations.** When adding features that run frequently (every frame, every physics tick), document the cost and scaling behavior.

### Per-Frame Operations (Watch List)

Operations in `_process()` or `_physics_process()` that could become expensive:

| Location | Operation | Cost | Notes |
|----------|-----------|------|-------|
| `rts_camera.gd` | `_constrain_to_units()` | O(n) units | Runs during WASD movement; fine for 10-16 units |

### Red Flags to Document

When implementing features, **always document** if you introduce:

1. **Group queries in process loops** - `get_nodes_in_group()` allocates a new array each call
2. **Distance checks against all entities** - O(n) per frame adds up
3. **Raycasts per entity** - Physics queries are expensive
4. **String operations in hot paths** - GDScript strings allocate
5. **Signal spam** - Emitting signals every frame to many listeners

### Acceptable Patterns

- **O(n) with small n** - Iterating 10-16 survivors is negligible
- **Conditional execution** - Only run expensive code when actually needed (e.g., only during movement)
- **Cached queries** - Store group results and update on spawn/despawn signals

### When to Optimize

Don't pre-optimize, but **do document**. If profiling shows issues:
1. Cache expensive queries
2. Use spatial partitioning for large entity counts
3. Throttle updates (every N frames instead of every frame)
4. Move to signals instead of polling

## Navigation Setup (Terrain3D)

1. Select Terrain3D node -> Terrain3D menu -> "Set up Navigation"
2. Use "Navigable" terrain tool to paint walkable areas (shows magenta)
3. Select Terrain3D -> Terrain3D menu -> "Bake NavMesh"
4. Save scene immediately after baking

**Important:** Do NOT use standard NavigationRegion3D bake - only Terrain3D's baker.

## Key Files Quick Reference

| Need | File | Key Functions/Signals |
|------|------|----------------------|
| Camera control | `src/camera/rts_camera.gd` | `focus_on()`, `zoom_changed` signal |
| Click handling | `src/control/rts_input_handler.gd` | `_handle_left_click()`, `_handle_right_click()` |
| Time/date | `src/systems/time_manager.gd` | `get_formatted_time()`, `hour_passed` signal |
| Unit movement | `src/characters/clickable_unit.gd` | `move_to()`, `stats_changed` signal |
| Survival stats | `src/characters/survivor_stats.gd` | `apply_hourly_decay()`, `get_work_efficiency()` |
| Game state | `src/game_manager.gd` | `start_new_game()`, `game_over` signal |

## Subsystem Documentation

Each major system has its own CLAUDE.md with detailed documentation:

- [AI System](src/ai/CLAUDE.md) - **LimboAI behavior trees for Officers/Men, utility-based needs scoring**
- [Camera System](src/camera/CLAUDE.md) - RTS camera with orbit, zoom, focus
- [Character System](src/characters/CLAUDE.md) - Survivors, stats, traits
- [Control System](src/control/CLAUDE.md) - Input handling, selection
- [Game Systems](src/systems/CLAUDE.md) - Time, weather, Sky3D integration
- [Terrain Generation](src/terrain/CLAUDE.md) - **Procedural island generation, Terrain3D API, NavMesh baking**
- [UI System](src/ui/CLAUDE.md) - HUD, stats panels, time display

## Scene Structure

### Main Scene Hierarchy

```
main.tscn (9KB)
├── DirectionalLight3D
├── Captain [instance: captain.tscn]
├── RTScamera [instance: src/camera/rts_camera.tscn]
├── Sky3D (WorldEnvironment) - day/night cycle
│   ├── SunLight, MoonLight
│   ├── SkyDome
│   └── TimeOfDay
├── Crates [instance: objects/crates1.tscn]
├── SnowController [instance: src/systems/weather/snow_controller.tscn]
└── world_map [instance: terrain/world_map.tscn]
    ├── NavigationRegion3D
    │   ├── navigation_mesh → terrain/navigation_mesh.tres
    │   └── Terrain3D (data: res://terrain/)
    └── Textures: snow_01, rock_dark_01 (external PNGs)
```

### Terrain3D Best Practices

To keep scene files small and readable:
- **Textures**: Always use ExtResource (external PNG files), never inline
- **NavigationMesh**: Extract to external `.tres` file after baking
- **Terrain data**: Stored in `res://terrain/` directory (binary .res files)

## Common Tasks

### Add new survivor trait
1. Add static factory method to `src/characters/trait.gd`
2. Add to `get_all_traits()` array
3. Handle conflicts in `get_random_traits()` if needed

### Modify survival mechanics
1. Update decay/recovery in `src/characters/survivor_stats.gd`
2. Update `get_energy_drain_multiplier()` for condition effects
3. Emit `stats_changed` signal for UI updates

### Change time/date settings
1. Edit exports in `src/systems/time_manager.gd`:
   - `starting_month`, `starting_day`, `starting_year`
   - `arctic_latitude` for day/night variation
   - `minutes_per_game_day` for game speed

### Add weather effects
1. Create particle scene in `src/systems/weather/`
2. Add intensity config to `snow_controller.gd`
3. Connect to Sky3D fog settings
