# Effects System

Visual effects for environmental phenomena.

## Files

| File | Purpose |
|------|---------|
| `aurora_controller.gd` | Manages aurora visibility based on weather/time conditions |
| `aurora.gdshader` | Standalone spatial shader (unused — aurora now rendered in sky shader) |

---

## Aurora Borealis

### How It Works

The aurora is rendered as a **sky shader layer** inside the Sky3D `SkyMaterial.gdshader`. This ensures it appears behind clouds (between the star field and cloud layers). The `AuroraController` sets aurora uniforms on the sky material at runtime.

The shader uses noise-based wave patterns projected onto the sky dome via `EYEDIR`, with an elevation-dependent brightness band that confines the aurora to the upper sky.

### Sky Shader Uniforms (in `SkyMaterial.gdshader`)

| Parameter | Default | Effect |
|-----------|---------|--------|
| `aurora_visible` | `false` | Enable/disable aurora rendering |
| `aurora_color` | Green (0.15, 0.85, 0.45) | Aurora color |
| `aurora_intensity` | 0.0 | Controller-driven fade (0=hidden, 1=full) |
| `aurora_emission` | 4.0 | Glow intensity multiplier |
| `aurora_speed` | 0.01 | Animation speed |
| `aurora_scale` | 0.02 | Noise pattern scale |
| `aurora_smoothness` | 0.3 | Wave edge softness |
| `aurora_distort` | 1.0 | Noise distortion amount |
| `aurora_offset` | 0.0 | Wave offset |
| `aurora_noise` | - | Required: NoiseTexture2D (FastNoiseLite, Simplex, freq ~0.01) |

### Controller (`AuroraController`)

Checks conditions every game hour via `TimeManager.hour_passed`:

| Condition | Requirement |
|-----------|-------------|
| Night | Required |
| Clear weather | Required (queries `DynamicWeatherController.is_clear_weather()`) |
| Season | Winter: 2x chance, Autumn/Spring: 1.3x, Summer: 0.3x |
| Temperature | Below -25C: 1.5x, Below -35C: 2x |

**Base chance:** 15% per eligible hour. Aurora lasts 2-6 game hours.

The controller finds the Sky3D node's `sky_material` and sets aurora uniforms on it. No 3D mesh is needed.

### Signals

```gdscript
signal aurora_started   # Emitted when aurora becomes visible
signal aurora_ended     # Emitted when aurora fully fades out
```

### Public API

```gdscript
func start_aurora() -> void       # Force aurora on (debug/menu)
func stop_aurora() -> void        # Force aurora off
func is_aurora_active() -> bool   # Query current state
```

---

## Adding to a Scene

### Important: AuroraController is the Source of Truth

The `AuroraController` applies its `@export` values to the sky material on init. **Do NOT tweak aurora shader params on the sky material directly** — the controller will overwrite them. Instead, tune the `@export` vars on the AuroraController node in the inspector:

| Controller Export | Maps to Shader Uniform |
|-------------------|----------------------|
| `aurora_color` | `aurora_color` |
| `emission_strength` | `aurora_emission` |
| `shader_speed` | `aurora_speed` |
| `shader_smoothness` | `aurora_smoothness` |
| `shader_distort` | `aurora_distort` |
| `shader_scale` | `aurora_scale` |
| `shader_offset` | `aurora_offset` |

The controller also creates the noise texture and manages `aurora_visible` / `aurora_intensity` automatically.

### Gameplay (with conditions)
1. Add an `AuroraController` node as child of the scene root
2. Tune appearance via the controller's `@export` vars in the inspector
3. Controller auto-finds Sky3D and applies uniforms on init
4. Requires: Sky3D in scene + `TimeManager` autoload + `DynamicWeatherController` in scene tree

### Procedural / Dynamic Sky3D
Same approach — the AuroraController finds whatever Sky3D exists at init time. Since it runs `_initialize()` via `call_deferred`, the Sky3D node just needs to exist by the end of the first frame. Tune appearance on the AuroraController's `@export` vars.

### Menu Screen (always-on decoration)
1. `menu_screen.gd` sets `aurora_visible = true` directly on the sky material
2. Aurora appearance values come from the sky material's editor-set shader params
3. No AuroraController needed — no condition checks for menu

---

## Sky Shader Integration Notes

The aurora code lives in `addons/sky_3d/shaders/SkyMaterial.gdshader` (modified from the addon). If the Sky3D addon is updated, the aurora uniforms and `render_aurora()` function must be re-added:
- Uniforms: `group_uniforms aurora;` block
- Functions: `render_aurora()`
- Render call: in `render_sky()` between `deep_space` and `// Clouds`

---

## Performance

- Aurora rendering is skipped entirely when `aurora_visible = false`
- No raymarching needed — the sky shader version uses direct noise sampling
- Noise texture is 512x512, seamless, generated once at startup
