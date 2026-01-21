# Weather System

Snow and blizzard effects with smooth transitions, integrating with Sky3D for realistic arctic storms.

## Files

| File | Purpose |
|------|---------|
| `snow_controller.gd` | Main weather controller - manages snow intensity, fog, and Sky3D integration |
| `snow_controller.tscn` | Scene definition (Node with script attached) |
| `snow_particles.tscn` | GPU particle system for snowfall (5000 particles) |
| `blizzard_post_process.gdshader` | Screen-space raymarched volumetric fog with triangle noise |
| `blizzard_fog.gdshader` | Legacy fog shader (replaced by post-process version) |

## Architecture

The weather system uses a multi-layer approach for realistic blizzard effects:

```
SnowController
├── Snow Particles (GPUParticles3D)
│   └── Follow camera, spawn upwind, drift with wind
├── Global Volumetric Fog (Environment)
│   └── Base haze layer visible from all angles
├── Screen-Space Post-Process Fog (MeshInstance3D + Shader)
│   └── Raymarched volumetric bands with triangle noise
├── Sky3D Integration
│   └── Wind, sun/ambient energy, SkyDome clouds, light tint
└── Camera Far Plane
    └── Distance clipping for true visibility reduction
```

**Critical:** The camera far plane reduction is what actually hides distant mountains during blizzards, not just the fog.

---

## Blizzard Post-Process Shader

The volumetric fog effect uses a **screen-space raymarching shader** adapted from Dave Hoskins' "Frozen Wasteland" Shadertoy.

### How It Works

1. **Fullscreen Quad**: A `MeshInstance3D` with a `QuadMesh` is parented to the camera
2. **Depth Reading**: Shader reads the depth buffer to know where scene geometry is
3. **Raymarching**: For each pixel, marches rays from camera toward the scene
4. **Triangle Noise**: Samples procedural noise at world XZ coordinates for stable bands
5. **Beer-Lambert**: Uses exponential transmittance for realistic fog accumulation
6. **Light Tinting**: Syncs with Sky3D sun color for sunrise/sunset matching

### Key Shader Technique: World-Anchored 2D Sampling

```glsl
// Sample fog using WORLD XZ coordinates only
// This ensures fog bands are anchored to the world and don't swirl with camera movement
float sample_fog_2d(vec2 world_xz, float world_y, float time_val) {
    vec2 fog_xz = world_xz;
    fog_xz -= time_val * wind_speed * wind_dir;  // Wind movement

    // Large sweeping waves based on ORIGINAL world position
    fog_xz.x += sin(world_xz.y * wave_frequency + time_val * 0.15) * wave_amplitude;

    // Sample noise using 2D position (Y is time-based for animation)
    vec3 noise_pos = vec3(fog_xz.x, time_val * vertical_drift, fog_xz.y);
    float noise = triangle_noise_3d(noise_pos * noise_scale);

    return noise * height_factor;
}
```

### Triangle Noise

Creates sharper, more defined fog bands than smooth Perlin noise:

```glsl
float tri(float x) { return abs(fract(x) - 0.5); }

vec3 tri3(vec3 p) {
    return vec3(tri(p.z + tri(p.y)), tri(p.z + tri(p.x)), tri(p.y + tri(p.x)));
}

float triangle_noise_3d(vec3 p) {
    float rz = 0.0;
    for (int i = 0; i < 3; i++) {
        vec3 dg = tri3(bp);
        p += dg;
        rz += tri(p.z + tri(p.x + tri(p.y))) / z;
        // ... octave scaling
    }
    return rz;
}
```

### Beer-Lambert Transmittance

Proper volumetric transparency - fog accumulates but doesn't fully block:

```glsl
float transmittance = 1.0;
for (int i = 0; i < ray_steps; i++) {
    float fog_sample = sample_fog_2d(sample_pos.xz, sample_pos.y, TIME);
    transmittance *= exp(-fog_sample * fog_density * step_size);
}
float opacity = 1.0 - transmittance;
```

---

## Shader Parameters & Tuning

### Fog Density / Intensity

| Parameter | Light Snow | Heavy Blizzard | Effect |
|-----------|------------|----------------|--------|
| `light_fog_shader_density` | 0.015 | - | Overall fog opacity |
| `heavy_fog_shader_density` | - | 0.04 | Higher = denser fog |

**Tuning:** Lower values = more subtle, semi-transparent bands. Higher values = denser, more opaque.

### Band Size and Shape

| Parameter | Default | Effect |
|-----------|---------|--------|
| `fog_noise_scale` | 0.004 | Smaller = larger bands, Larger = finer detail |
| `fog_wave_amplitude` | 15.0 | Larger = more sweeping wave motion |
| `fog_wave_frequency` | 0.04 | Smaller = longer wavelength waves |

**For larger sweeping bands:** Decrease `noise_scale`, increase `wave_amplitude`
**For more detailed bands:** Increase `noise_scale`, decrease `wave_amplitude`

### Movement Speed

| Parameter | Default | Effect |
|-----------|---------|--------|
| `fog_wind_speed` | 2.0 | How fast bands drift horizontally |
| `fog_vertical_drift` | 0.1 | Vertical animation speed |

**Note:** Wind speed is automatically synced from Sky3D and smoothed to prevent hurricane effects during transitions.

### Height Distribution

| Parameter | Default | Effect |
|-----------|---------|--------|
| `fog_height` | 20.0 | Center height of fog layer (world Y) |
| `fog_falloff` | 0.02 | How quickly fog fades above/below center |

**For ground-hugging fog:** Lower `fog_height`, increase `fog_falloff`
**For thick atmospheric fog:** Higher `fog_height`, decrease `fog_falloff`

### Colors

| Parameter | Default | Effect |
|-----------|---------|--------|
| `fog_albedo` | (0.75, 0.77, 0.8) | Base fog color |
| `fog_emission_color` | (0.6, 0.62, 0.65) | Self-illumination |

**Sunrise/Sunset:** The shader automatically picks up Sky3D's sun color via `light_tint` uniform.

---

## SnowController

### Signals
```gdscript
signal snow_started(intensity: SnowIntensity)
signal snow_stopped
signal snow_intensity_changed(from: SnowIntensity, to: SnowIntensity)
```

### Snow Intensity Enum
```gdscript
enum SnowIntensity {
    NONE,   # Clear weather
    LIGHT,  # Light snowfall, moderate visibility
    HEAVY   # Blizzard, severely reduced visibility
}
```

### Key Exports

```gdscript
@export var sky3d: Node                        # Sky3D reference (auto-found if null)
@export var transition_duration: float = 5.0  # Seconds for smooth transitions

# Light Snow
@export var light_fog_shader_density: float = 0.015
@export var light_camera_far_ratio: float = 0.4

# Heavy Blizzard
@export var heavy_fog_shader_density: float = 0.04
@export var heavy_camera_far_ratio: float = 0.0375

# Fog Shader Tuning
@export var fog_noise_scale: float = 0.008
@export var fog_wind_speed: float = 7.0
@export var fog_wave_amplitude: float = 3.0
```

### Public API

```gdscript
func start_snow(intensity: SnowIntensity = SnowIntensity.LIGHT) -> void
func stop_snow() -> void
func set_snow_immediate(intensity: SnowIntensity) -> void
func is_snowing() -> bool
```

---

## Implementation Details

### Wind Speed Smoothing

To prevent "hurricane effect" during intensity transitions, fog wind speed is smoothed:

```gdscript
var target_fog_wind: float = wind_speed * 0.15
_smoothed_fog_wind_speed = lerpf(_smoothed_fog_wind_speed, target_fog_wind, 0.02)
_fog_shader_material.set_shader_parameter("wind_speed", _smoothed_fog_wind_speed)
```

### Sunrise/Sunset Light Tinting

The fog color automatically matches Sky3D's sun color:

```gdscript
func _update_fog_light_tint() -> void:
    if "sun" in sky3d and sky3d.sun:
        var sun_node: DirectionalLight3D = sky3d.sun
        light_color = sun_node.light_color
        var tint_amount = clamp(1.0 - sun_node.light_energy * 0.5, 0.0, 1.0)
        _fog_shader_material.set_shader_parameter("light_tint_strength", tint_amount * 0.6)
```

### Camera Far Plane Reduction

The fog alone doesn't hide distant mountains - the camera far plane does:

```gdscript
_camera.far = normal_far_distance * target_ratio  // 150m in heavy snow
```

---

## Performance Notes

The shader is optimized for performance:
- **20 ray steps** (adjustable) - balance between quality and speed
- **Early exit** when transmittance < 0.01
- **Pure math noise** - no texture samples in the noise function
- **Fixed iteration count** in triangle noise (3 octaves)

Typical performance: 60fps on mid-range hardware with default settings.

---

## Common Modifications

### Make fog more subtle
```gdscript
light_fog_shader_density = 0.008  # Half the default
fog_noise_scale = 0.003           # Larger, softer bands
```

### Make fog more dramatic
```gdscript
heavy_fog_shader_density = 0.08   # Double the default
fog_wave_amplitude = 25.0         # More dramatic sweeping
```

### Change fog movement speed
```gdscript
fog_wind_speed = 15.0  # Faster horizontal drift
```
Note: This is further scaled by Sky3D wind and smoothed internally.

### Disable sunrise/sunset tinting
Set `light_tint_strength = 0.0` in the shader or modify `_update_fog_light_tint()`.

---

## Debugging

### Fog not visible
1. Check `light_fog_shader_density` / `heavy_fog_shader_density` > 0
2. Verify `_fog_mesh` is created (check console for "Created screen-space post-process fog mesh")
3. Ensure camera reference is valid

### Fog too opaque / whiteout
1. Lower `fog_shader_density` values (try 0.01-0.02)
2. Check `fog_max_opacity` cap in shader (default 0.7)

### Fog bands not moving
1. Verify Sky3D wind_speed > 0
2. Check `fog_wind_speed` export
3. Confirm `_update_wind()` is being called

### Hurricane effect during transitions
1. Verify `_smoothed_fog_wind_speed` smoothing is active
2. Lower the lerp factor (currently 0.02)
