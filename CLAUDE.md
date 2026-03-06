# CLAUDE.md

Guidance for Claude Code when working with this repository.

## CRITICAL RULES

### No Guessing — ASK
**NEVER guess, assume, or write defensive fallback code when unsure.** If you don't know the answer, the file is too large to read, or the requirement is ambiguous — **ASK the user.** Do not invent plausible-looking solutions. Do not add "just in case" code paths. Wrong code that looks right is worse than no code at all.

### No Commits Without Testing
**NEVER commit/push until user has tested and given explicit permission.**

### Check Logs First
**ALWAYS check Godot logs before asking about runtime errors:**
```bash
cat "/mnt/c/Users/antih/AppData/Roaming/Godot/app_userdata/Polaris/logs/godot.log" | tail -200
```

### Scene Creation
**NEVER programmatically generate .tscn files.** ASK the user to create scenes in Godot editor.

### Editor-First Configuration
**NEVER create a node or change a parameter in code that CAN be done in the editor.** This includes nodes (NavigationObstacle3D, Area3D, etc.), UI elements, materials, shaders, collision layers/masks, and export properties. Adding nodes in code adds unnecessary LOC and makes it harder to debug/tweak. Scripts should only manage runtime state and logic — not construct node hierarchies or set values that belong in the Inspector.

### No Impossible Fallbacks
**NEVER create fallbacks to unreachable positions.** If a task can't find a valid target, FAIL immediately and let the behavior tree handle it. Don't send units to ship centers, object origins, or other positions inside collision meshes.

### Composition Over Monoliths
**NEVER duplicate logic across classes. Use COMPOSITION with shared components.**
- If two classes need the same functionality (combat, health, movement), create a COMPONENT
- Components emit standardized SIGNALS that other systems can connect to
- Example: `CombatComponent` handles combat state for BOTH ClickableUnit AND Animal
- DO NOT write parallel implementations with slightly different APIs

### Behavior Trees Over Hardcoded Logic
**Use LimboAI behavior trees for ALL agent logic. NEVER hardcode state machines in scripts.**
- Combat, gathering, fleeing, patrolling - ALL belongs in BT
- Scripts should provide atomic ACTIONS and CONDITIONS for BT to compose
- If you find yourself writing `if state == X: do_thing()` chains, STOP and use BT instead
- Officers are the ONLY exception (player-controlled, no BT)

### Standardized Signals
**All combatants MUST emit these signals via CombatComponent:**
- `combat_started(target: Node3D)`
- `combat_ended`
- `took_damage(amount: float, attacker: Node3D)`
- `died`
- `health_changed(new_health: float, max_health: float)`

---

## Project Overview

**Polaris** - Arctic survival RTS inspired by The Terror/Franklin expedition. Players manage 10-16 crew members surviving until rescue.

- **Engine:** Godot 4.5 (Forward+ renderer)
- **Main Scene:** `main.tscn`
- **Godot Path:** `/mnt/c/Users/antih/Desktop/Godot_v4.5.1-stable_win64_console.exe`

See `GameDesignDocument.md` for design specs.

---

## Terminology

**"Unit" and "Survivor" are synonymous** - both refer to crew members.

| Term | Class | Description |
|------|-------|-------------|
| Unit/Survivor | `ClickableUnit` | Any crew member |
| Men | `ClickableUnit` + AI | Semi-autonomous via LimboAI |
| Officers/Captain | `ClickableUnit` | Directly controllable |

**Key Classes:**
- `ClickableUnit` - THE unit class for all characters
- `SurvivorStats` - Survival needs resource
- `SurvivorTrait` - Character trait modifiers

---

## Autoloads

| Autoload | Purpose |
|----------|---------|
| `TimeManager` | Day/night, seasons, Sky3D sync |
| `SelectionManager` | Multi-selection, control groups |
| `GameManager` | Game state, win/lose |
| `SoundManager` | Audio management |

---

## Key Addons

| Addon | Purpose |
|-------|---------|
| **LimboAI** | Behavior trees for AI |
| **Sky3D** | Day/night cycle, atmosphere |

### LimboAI Task Rules

**BEFORE creating any BT task:**
1. Run `ls ai/tasks/` and READ what exists
2. Each task does ONE thing (~50-100 lines max)
3. Use BTSequence in .tres to compose tasks, NOT state machines in code
4. Tasks should NOT do navigation - use `BTMoveToBlackboard` for that
5. `BTFindNearestResource` + `BTMoveToBlackboard` handles most "go to X" patterns

**Task patterns:**
| Need | Tasks to compose |
|------|------------------|
| Go to resource | `BTFindNearestResource` → `BTMoveToBlackboard` |
| Gather from ship | `BTFindNearestResource [ship_scrap_wood]` → `BTMoveToBlackboard` → `BTGatherFromShip` |
| Deposit materials | `BTFindNearestResource [workbenches]` → `BTMoveToBlackboard` → `BTDepositMaterials` |
| **Terrain3D** | Large terrain, procedural generation |
| **indie_blueprint_rpg** | Health, loot, crafting |

---

## Subsystem Documentation

Detailed docs in each directory's CLAUDE.md:

| System | Location | Key Topics |
|--------|----------|------------|
| Camera | [src/camera/](src/camera/CLAUDE.md) | WASD, orbit, zoom |
| Characters | [src/characters/](src/characters/CLAUDE.md) | Units, stats, traits |
| Control | [src/control/](src/control/CLAUDE.md) | Input, selection |
| Systems | [src/systems/](src/systems/CLAUDE.md) | Time, weather, spawning |
| Terrain | [src/terrain/](src/terrain/CLAUDE.md) | **Procedural generation, Terrain3D API, NavMesh** |
| Items | [src/items/](src/items/CLAUDE.md) | Inventory, protoset |
| UI | [ui/](ui/CLAUDE.md) | HUD, panels |
| AI | [ai/](ai/CLAUDE.md) | Behavior trees |
| Ship Destruction | [tools/](tools/CLAUDE.md) | **Progressive demolition, sinking, sound effects** |
| Effects | [src/effects/](src/effects/CLAUDE.md) | Aurora borealis, visual FX |

**Planned Systems:** See [docs/DESIGN.md](docs/DESIGN.md) for combat, building, NPCs.

---

## Code Conventions

1. **Static typing required** - `var x: Type = value`
2. **Composition over inheritance** - behavior as child components
3. **Scripts ~100-150 lines max** - split if larger
4. **Signals for communication** - not direct references
5. **Descriptive names** - `snow_streak_particles` not `particles`
6. **Document performance concerns** - flag O(n) operations in loops

### Node Groups

| Group | Purpose |
|-------|---------|
| `survivors` | TimeManager updates |
| `selectable_units` | Input queries |
| `terrain` | Height queries |
| `containers` | Storage objects |

---

## Terrain3D Reference

**Demo Location:** `res://Terrain3D-demo/src/` - ALWAYS reference for procedural terrain.

| File | Use For |
|------|---------|
| `RuntimeNavigationBaker.gd` | Dynamic NavMesh |
| `CodeGenerated.gd` | Procedural setup |
| `Enemy.gd` | NavigationAgent + terrain checks |

---

## Navigation (Terrain3D)

**Docs:** [terrain3d.readthedocs.io/en/stable/docs/navigation.html](https://terrain3d.readthedocs.io/en/stable/docs/navigation.html)

### Setup
1. Terrain3D menu → "Set up Navigation"
2. Paint walkable areas (magenta)
3. Terrain3D menu → "Bake NavMesh" (**NOT** standard bake button)

### Critical: NavigationObstacle3D Does NOT Affect Pathfinding

`NavigationObstacle3D` only affects agent-agent avoidance. For units to path around walls/ships:
- Static obstacles must be **children of NavigationRegion3D**
- Then rebake NavMesh

| Need | Solution |
|------|----------|
| Units avoid each other | `NavigationObstacle3D` |
| Units path around walls | Child of NavigationRegion3D + rebake |

---

## Common Gotchas

| Issue | Fix |
|-------|-----|
| `trait` reserved | Use `survivor_trait` |
| `node.has("prop")` crashes | Use `"prop" in node` |
| Dict type inference fails | Explicit type: `var x: int = dict.val` |
| Tween "target freed" | Use `node.create_tween()` not `create_tween()` |
| `ui_shift` not found | Manually add in Project Settings |
| Full-rect Control blocks clicks | Set `mouse_filter = MOUSE_FILTER_IGNORE` |

---

## Quick Reference

| Need | File |
|------|------|
| Camera | `src/camera/rts_camera.gd` |
| Click handling | `src/control/rts_input_handler.gd` |
| Time/date | `src/systems/time_manager.gd` |
| Unit movement | `src/characters/clickable_unit.gd` |
| Survival stats | `src/characters/survivor_stats.gd` |
| Terrain generation | `src/terrain/terrain_generator.gd` |
