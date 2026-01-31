# Ship Destruction System

Documentation for the ship crushing/destruction physics system.

## Overview

The ship destruction system simulates the HMS Erebus being crushed by ice pressure over time. It provides:
- **Progressive structural failure** with realistic dependencies
- **3D positional sound effects** (wood crashing, ground impacts, creaking, rumbling)
- **Camera shake** on impacts (small for explosions, large for ground impacts)
- **Sinking animation** with hull explosions and rumble sounds

## Files

| File | Purpose |
|------|---------|
| `demolition_test_controller.gd` | Main destruction controller with staged demolition, sound, and sinking |
| `rigging_cleanup_manager.gd` | Cleans up rigging pieces below ground |
| `fix_rigging_origins.gd` | EditorScript to fix mesh origin issues |

## Test Scene

**Location:** `objects/erebus4/erebus_physics_test.tscn`

Contains:
- ErebusFragmentedV1 (5900+ mesh fragments)
- DemolitionTestController
- RiggingCleanupManager

## Controls (Test Scene)

| Key | Action |
|-----|--------|
| 1 | Rigging (cycles through groups) |
| 2 | Shroud (cycles through groups) |
| 3 | Mast (progressive, top-down) |
| 4 | Hull (progressive, edges first) |
| 5 | Deck (progressive, edges first) |
| 6 | Fascia (all at once) |
| 7 | Misc externals (all at once) |
| S | Trigger sink event |
| Space | Destroy everything |
| R | Reset all |

## Destruction Order

Realistic structural failure sequence:

1. **Rigging** - Light cables/ropes fail first (no dependency)
2. **Shrouds** - Heavy support cables fail (triggers mast shake)
3. **Masts** - Require shrouds destroyed first, fail top-down
4. **Hull** - Fails from edges inward, cascades at 60% damage
5. **Deck** - Same pattern as hull

## Sound System

### 3D Positional Audio
All destruction sounds use `AudioStreamPlayer3D` with logarithmic attenuation:
- `unit_size = 2.0` - Sound at base volume at 2m distance
- `max_distance = 150.0` - Silent beyond this range

### Sound Events
| Event | Sound | Volume | Camera Shake |
|-------|-------|--------|--------------|
| Hull/Mast/Deck explosion | `wood_crash.mp3` | -6 dB | 0.15 intensity, 0.4s |
| Mast ground impact | `crash_on_ground.mp3` | 0 dB | 0.5 intensity, 0.8s |
| Ambient creaking | `ship_wood_creak.mp3` | -12 dB | None |
| Sink event start | `low_rumble.mp3` | -6 dB | None |
| Sink in progress | `mid_rumble_loop.mp3` | -3 dB | None |

### Creaking System
Continuous ambient creaking that varies with destruction progress:
- **Early (>70% intact):** Rare creaks, 20-40s intervals
- **Mid (30-70% intact):** Frequent creaks, 5-15s intervals
- **Late (<30% intact):** Subsiding creaks, 30-60s intervals

Each creak plays a random 5-10 second segment with fade in/out.

### Ground Impact Detection
Mast pieces are tracked after being unfrozen. When they reach `ground_y + 1.0`:
- Ground crash sound plays at impact position
- Large camera shake triggers
- Only triggers ONCE per mast (not per piece)

## Sinking System

Press **S** to trigger a sink event:

1. **Immediate:** Low rumble plays
2. **After 5-7s delay:** Ship starts sinking
3. **During sink:**
   - Mid rumble loop plays
   - Ship descends 0.5-1.5m
   - Ship rolls ±15° and pitches ±7.5°
   - Vibration decreases as sink settles
   - 2-6 hull pieces explode outward
4. **On completion:**
   - Rumbles fade out over 3s
   - Ship retains new position/rotation
   - Multiple S presses = cumulative sinking

## Mast Shake Effect

When rigging/shrouds collapse, connected masts shake:
- **Rigging collapse:** 1.5x amplitude, 0.8x duration (sharp jolt)
- **Shroud collapse:** 2.0x amplitude, 1.8x duration (dramatic sway)

Uses `tween_method()` with dampened sine wave oscillation.

## Audio Files

Located in `/sounds/`:
- `wood_crash.mp3` - Explosive destruction events
- `crash_on_ground.mp3` - Mast ground impact
- `ship_wood_creak.mp3` - Continuous creaking (5+ min)
- `low_rumble.mp3` - Sinking intro (39s)
- `mid_rumble_loop.mp3` - Sinking loop

## Integration

### For Testing (main.tscn)
- Destruction happens over hours/1 game day
- Manual key controls for testing

### For Production (procedural game)
- Destruction happens over 5-10 game days
- TimeManager triggers sink events automatically
- Ship resource depletion tied to destruction phases

## Known Issues

### Fixed Transform Origins
Some mesh groups had incorrect RigidBody3D origins:
- Rigging_Foremast
- Rigging_MainMast
- Mast_MizzenMast

Use `fix_rigging_origins.gd` EditorScript to fix:
1. Open `erebus_physics_ready.tscn`
2. Script > Run (Ctrl+Shift+X)
3. Save scene

## Export Settings

The demolition controller exposes these settings in the inspector:

| Setting | Default | Description |
|---------|---------|-------------|
| `ground_y` | 0.0 | Y level of ground for impact detection |
| `sound_unit_size` | 2.0 | Distance where sound is at base volume |
| `sound_max_distance` | 150.0 | Maximum audible distance |

## Future Features

- [ ] TimeManager integration for automated destruction over game days
- [ ] Ship resource depletion tied to destruction phases
