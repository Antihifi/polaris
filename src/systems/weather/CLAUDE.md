# Weather System

Snow and blizzard effects with smooth transitions, integrating with Sky3D for realistic arctic storms.

## Files

| File | Purpose |
|------|---------|
| `snow_controller.gd` | Main weather controller - manages snow intensity, fog, and Sky3D integration |
| `snow_controller.tscn` | Scene definition (Node with script attached) |
| `snow_particles.tscn` | GPU particle system for snowfall (5000 particles) |
| `blizzard_fog.gdshader` | Animated fog shader creating drifting wind bands |

## Architecture

The weather system uses a multi-layer approach for realistic blizzard effects:

```
SnowController
├── Snow Particles (GPUParticles3D)
│   └── Follow camera, spawn upwind, drift with wind
├── Global Volumetric Fog (Environment)
│   └── Base haze layer visible from all angles
├── FogVolume with Shader (localized)
│   └── Animated drifting bands around camera
├── Sky3D Integration
│   └── Wind, sun/ambient energy, SkyDome clouds
└── Camera Far Plane
    └── Distance clipping for true visibility reduction
```

**Critical:** The camera far plane reduction is what actually hides distant mountains during blizzards, not just the fog.

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

### Exports
```gdscript
@export var sky3d: Node                        # Sky3D reference (auto-found if null)
@export var transition_duration: float = 5.0  # Seconds for smooth transitions
@export var spawn_height_offset: float = 25.0 # Height above camera for particles
@export var normal_far_distance: float = 4000.0  # Clear weather far plane
@export var blizzard_far_distance: float = 150.0 # Heavy snow far plane
```

### Intensity Configurations

Each intensity level defines a complete configuration dictionary:

| Property | NONE | LIGHT | HEAVY |
|----------|------|-------|-------|
| `particle_amount_ratio` | 0.0 | 0.4 | 1.0 |
| `sky3d_wind_speed` | 0.0 | 8.0 m/s | 25.0 m/s |
| `sun_energy` | 1.0 | 0.7 | 0.25 |
| `ambient_energy` | 1.0 | 0.85 | 0.4 |
| `volumetric_fog_density` | 0.0 | 0.04 | 0.08 |
| `fog_shader_density` | 0.0 | 1.2 | 2.5 |
| `camera_far_ratio` | 1.0 | 0.4 (~1600m) | 0.0375 (~150m) |
| `cumulus_coverage` | original | 0.75 | 1.0 |
| `atm_darkness` | original | 0.65 | 0.85 |

### Public API

```gdscript
# Start snow with smooth transition
func start_snow(intensity: SnowIntensity = SnowIntensity.LIGHT) -> void

# Stop snow with smooth fade-out
func stop_snow() -> void

# Set intensity immediately (no transition)
func set_snow_immediate(intensity: SnowIntensity) -> void

# Check if snowing (including during transitions)
func is_snowing() -> bool
```

### State Variables
```gdscript
var current_intensity: SnowIntensity = SnowIntensity.NONE
var _target_intensity: SnowIntensity = SnowIntensity.NONE
var _transition_progress: float = 1.0  # 0-1, 1 = complete

var _snow_particles: GPUParticles3D    # Active particle system
var _particle_material: ParticleProcessMaterial  # For wind modification
var _fog_volume: FogVolume             # Localized animated fog
var _fog_shader_material: ShaderMaterial
var _camera: Camera3D
var _environment: Environment          # From Sky3D
var _sky_dome: Node                     # SkyDome for clouds
```

## Two-Layer Fog System

### Layer 1: Global Volumetric Fog (Environment)
```gdscript
_environment.volumetric_fog_enabled = true
_environment.volumetric_fog_density = 0.08       # Thick base layer
_environment.volumetric_fog_emission = Color(0.25, 0.25, 0.27)  # Visible from all angles
_environment.volumetric_fog_albedo = Color(0.9, 0.9, 0.95)      # White-ish for snow
```

Provides base haze layer visible from all directions.

### Layer 2: FogVolume with Animated Shader
```gdscript
_fog_volume = FogVolume.new()
_fog_volume.size = Vector3(400, 100, 400)  # 400m x 100m x 400m box
_fog_volume.shape = RenderingServer.FOG_VOLUME_SHAPE_BOX
_fog_volume.material = _fog_shader_material  # blizzard_fog.gdshader
```

Creates drifting bands of fog that move with the wind direction. Stays centered on camera every frame.

## Blizzard Fog Shader

```glsl
shader_type fog;

uniform sampler2D noise_tex : repeat_enable;
uniform float noise_scale = 0.02;
uniform float flatness = 8.0;           // Vertical banding control
uniform float density = 2.0;
uniform vec3 emission = vec3(0.7, 0.7, 0.75);
uniform float fog_speed = 0.8;
uniform float wind_direction = 0.0;     // Synced from Sky3D

void fog() {
    // Wind vector from direction (negated to match particle visual)
    vec2 wind_dir = vec2(-sin(wind_direction), -cos(wind_direction));
    vec2 move_uv = wind_dir * TIME * fog_speed;

    // Layered noise for detail
    float detail_noise = texture(noise_tex, WORLD_POSITION.xz * noise_scale + move_uv * 0.5).r;
    float noise = texture(noise_tex, WORLD_POSITION.xz * noise_scale + move_uv + detail_noise).r;

    DENSITY = mix(1.0, noise, UVW.y * flatness);
    DENSITY *= step(0.0, -SDF) * density;
    ALBEDO = texture(grad_tex, vec2(DENSITY, 0.5)).rgb;
    EMISSION = emission;
}
```

## Particle System

### Snow Particles Configuration (snow_particles.tscn)
- **Amount:** 5000 particles
- **Emission shape:** Box 80x2x80 (horizontal spread)
- **Initial velocity:** 3-5 m/s downward
- **Lifetime:** 10 seconds
- **Gravity:** Modified by wind (set dynamically)
- **Turbulence:** Enabled for natural movement
- **Billboard mode:** Face camera

### Particle Positioning
```gdscript
func _update_particle_position() -> void:
    # Spawn above camera
    var spawn_y := _camera.global_position.y + spawn_height_offset

    # Offset upwind so particles drift toward camera
    var offset := Vector3.ZERO
    if sky3d:
        var wind_dir: float = sky3d.wind_direction
        var wind_speed: float = sky3d.wind_speed
        # Spawn opposite of wind direction
        offset.x = -sin(wind_dir) * wind_speed * 1.5
        offset.z = -cos(wind_dir) * wind_speed * 1.5

    _snow_particles.global_position = Vector3(cam_pos.x + offset.x, spawn_y, cam_pos.z + offset.z)
```

### Wind-Driven Gravity
```gdscript
func _update_wind() -> void:
    var wind_dir: float = sky3d.wind_direction
    var wind_speed: float = sky3d.wind_speed
    var mult: float = config["particle_wind_mult"]  # 0.8 or 2.0

    var wind_x: float = sin(wind_dir) * wind_speed * mult
    var wind_z: float = cos(wind_dir) * wind_speed * mult

    _particle_material.gravity = Vector3(wind_x, -9.8, wind_z)
```

## Sky3D Integration

### Properties Modified
| Sky3D Property | Effect |
|----------------|--------|
| `wind_speed` | Affects particle drift and fog animation |
| `wind_direction` | Direction of snow/fog movement |
| `sun_energy` | Dimmed during storms (0.25 in heavy) |
| `ambient_energy` | Reduced overall lighting |

### SkyDome Properties Modified
| Property | Effect |
|----------|--------|
| `cumulus_coverage` | Increased cloud cover |
| `cumulus_intensity` | Reduced cloud detail |
| `cirrus_coverage` | High altitude haze |
| `atm_darkness` | Darker atmosphere |
| `atm_thickness` | Thicker atmosphere scatter |
| `atm_sun_intensity` | Sun disk dimming |

## Transition System

All properties smoothly interpolate over `transition_duration` (default 5 seconds):

```gdscript
func _apply_transition() -> void:
    var t: float = _transition_progress  # 0.0 to 1.0

    # Particle amount
    _snow_particles.amount_ratio = lerpf(from_ratio, to_ratio, t)

    # Sky3D properties
    sky3d.wind_speed = lerpf(from_wind, to_wind, t)
    sky3d.sun_energy = lerpf(from_sun, to_sun, t)

    # Volumetric fog
    _environment.volumetric_fog_density = lerpf(from_fog, to_fog, t)

    # Camera far plane (the key visibility control)
    _camera.far = normal_far_distance * lerpf(from_far_ratio, to_far_ratio, t)
```

## Critical Quirks & Implementation Details

### 1. Camera Far Plane is Key
```gdscript
// Line 496 comment: "this is what actually hides the mountains"
_camera.far = normal_far_distance * target_ratio  // 150m in heavy snow
```

The volumetric fog alone doesn't hide distant terrain - reducing the camera's far clipping plane does the actual visibility reduction.

### 2. Original Values Caching
The controller stores original Sky3D/SkyDome/Environment values in `_ready()` and restores them when snow stops. This prevents "getting stuck" with modified settings.

### 3. Wind Direction Synchronization
Both particles and fog shader use the same wind direction from Sky3D:
- Particles spawn upwind and drift toward camera
- Fog shader animates in same direction
- Creates cohesive visual effect

### 4. Environment from Sky3D
```gdscript
// Sky3D extends WorldEnvironment, so its .environment is the active one
if "environment" in sky3d and sky3d.environment:
    _environment = sky3d.environment
```

### 5. Deferred Initialization
```gdscript
func _ready() -> void:
    await get_tree().process_frame  // Wait for Sky3D to initialize
    _store_original_values()
```

## Integration Points

### With TimeManager
- TimeManager doesn't directly control weather
- Weather could be triggered based on season/random events

### With DebugMenu
```gdscript
# In ui/debug_menu.gd
_snow_controller.start_snow(SnowController.SnowIntensity.LIGHT)
_snow_controller.start_snow(SnowController.SnowIntensity.HEAVY)
_snow_controller.stop_snow()
_snow_controller.set_snow_immediate(SnowController.SnowIntensity.NONE)
```

### With Survivors (potential)
Heavy snow could trigger:
- Increased warmth drain
- Reduced work efficiency
- Shelter-seeking behavior

## Scene Setup

Add to main scene:
```
main.tscn
├── Sky3D (WorldEnvironment)
└── SnowController [instance: src/systems/weather/snow_controller.tscn]
```

The controller auto-finds Sky3D if not assigned via export.

## Common Modifications

### Add new intensity level (MODERATE)
```gdscript
enum SnowIntensity { NONE, LIGHT, MODERATE, HEAVY }

# Add to _intensity_configs:
SnowIntensity.MODERATE: {
    "particle_amount_ratio": 0.6,
    "camera_far_ratio": 0.25,  # ~1000m visibility
    # ... other properties
}
```

### Trigger weather based on season
```gdscript
# In TimeManager or GameManager
func _on_hour_passed(hour: int, day: int) -> void:
    if TimeManager.current_season == TimeManager.Season.WINTER:
        if randf() < 0.1:  # 10% chance per hour
            _snow_controller.start_snow(SnowController.SnowIntensity.HEAVY)
```

### Add rain weather type
1. Create `rain_controller.gd` following same pattern
2. Create `rain_particles.tscn` with different material
3. Skip fog volume (rain doesn't reduce visibility as much)
4. Modify Sky3D cloud/atmosphere settings
