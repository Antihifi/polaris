# Game Systems

Core game systems: time management, spawning, Sky3D integration, weather effects.

## Files

| File | Purpose |
|------|---------|
| `time_manager.gd` | Autoload: time, seasons, rescue timer, Sky3D sync |
| `character_spawner.gd` | Multi-character spawning with randomized stats/names |
| `object_spawner.gd` | Storage container spawning with item population |
| `weather/snow_controller.gd` | Snow intensity, fog, particle management |
| `weather/snow_particles.tscn` | GPU particle system for snowfall |
| `weather/blizzard_fog.gdshader` | Animated fog shader for blizzards |
| `weather/CLAUDE.md` | Detailed weather system documentation |

## TimeManager (Autoload)

Manages game time, seasons, and integrates with Sky3D for realistic arctic day/night cycles.

### Signals
```gdscript
signal hour_passed(hour: int, day: int)
signal day_passed(day: int)
signal season_changed(season: Season)
signal time_scale_changed(scale: float)
signal rescue_approaching(days_remaining: int)
signal rescue_arrived
```

### Season Enum
```gdscript
enum Season { SUMMER, AUTUMN, WINTER, SPRING }
```

### Configuration
```gdscript
@export var minutes_per_game_day: float = 15.0  # Real minutes per game day
@export var hours_per_day: int = 24
@export var days_per_season: int = 90
@export var arctic_latitude: float = 60.0  # Degrees north (see IMPORTANT note below)

# Starting date (Franklin expedition trapped in ice)
@export var starting_month: int = 9       # September
@export var starting_day: int = 12
@export var starting_year: int = 2024     # Modern year for Sky3D compatibility
@export var starting_hour: float = 8.0
```

### IMPORTANT: Sky3D Latitude Quirk

**Problem:** Sky3D's sun position calculation is overly aggressive at extreme latitudes (>65°N). At the historically accurate 74°N (Franklin expedition location), even in September the game shows perpetual twilight/golden hour with the sun barely dipping below the horizon - behavior that should only occur during summer solstice.

**Solution:** Use a reduced latitude of **60°N** instead of the real 74°N. This provides:
- Proper dark nights with visible stars
- Realistic sunrise/sunset times
- Dramatic arctic lighting during daytime
- Appropriate day length variation across seasons

**Also:** Use a modern year (2024) instead of 1846. Sky3D's Julian date calculations may not work correctly for historical dates. The player doesn't see the year in-game, so this has no gameplay impact.

If you need to adjust the latitude further:
- **55°N**: Even darker nights, more "normal" day/night cycle
- **65°N**: Longer twilight periods, shorter full darkness
- **50°N**: Very pronounced day/night, almost temperate feel

### Time State
```gdscript
var current_hour: int = 8
var current_day: int = 1
var current_season: Season = Season.SUMMER
var days_until_rescue: int = 0
var total_days_to_rescue: int = 0
var time_scale: float = 1.0  # 0=paused, 1=normal, 2=fast, 4=faster
var is_paused: bool = false
```

## Sky3D Integration

TimeManager finds and configures Sky3D at runtime:

```gdscript
func _find_sky3d() -> void:
    sky3d = _find_node_by_class(get_tree().current_scene, "Sky3D")
    if sky3d:
        _configure_sky3d()
        sky3d.tod.time_changed.connect(_on_sky3d_time_changed)
        sky3d.tod.day_changed.connect(_on_sky3d_day_changed)
```

### Configuration
```gdscript
func _configure_sky3d() -> void:
    var tod: Node = sky3d.tod
    tod.latitude = deg_to_rad(arctic_latitude)
    tod.year = starting_year
    tod.month = starting_month
    tod.day = starting_day
    tod.current_time = starting_hour
```

### Time Sync
Sky3D controls actual time progression; TimeManager syncs from it:
```gdscript
func _sync_from_sky3d() -> void:
    var tod: Node = sky3d.tod
    var sky_hour := int(tod.current_time)

    if sky_hour != _last_hour:
        _last_hour = sky_hour
        current_hour = sky_hour
        hour_passed.emit(current_hour, current_day)
        _update_survivor_needs()
```

### Time Scale Control
Adjusts Sky3D's `minutes_per_day` based on time scale:
```gdscript
func _update_sky3d_time_scale() -> void:
    if is_paused or time_scale <= 0.0:
        sky3d.pause()
    else:
        var new_minutes_per_day := minutes_per_game_day / time_scale
        sky3d.minutes_per_day = new_minutes_per_day
        sky3d.resume()
```

## Time Control API

```gdscript
func pause() -> void
func unpause() -> void
func toggle_pause() -> void
func set_time_scale(scale: float) -> void  # 0-4, clamped
func cycle_time_scale() -> void  # Cycles: 0 -> 1 -> 2 -> 4 -> 0
```

## Environment Queries

### Temperature
Based on season, time of day, and Sky3D sun position:
```gdscript
func get_current_temperature() -> float:
    var base_temp: float = SEASON_CONFIG[current_season].base_temperature
    # Summer: -5°C, Autumn: -15°C, Winter: -35°C, Spring: -10°C

    if is_daytime():
        # Warmer during day, peaks at midday (+5°C max)
        var day_progress := (hour_float - 6.0) / 12.0
        time_modifier = sin(day_progress * PI) * 5.0
    else:
        time_modifier = -5.0  # Colder at night

    return base_temp + time_modifier
```

### Day/Night Detection
```gdscript
func is_daytime() -> bool:
    if sky3d:
        return sky3d.is_day()  # Uses sun altitude
    return current_hour >= 6 and current_hour < 20

func is_nighttime() -> bool:
    if sky3d:
        return sky3d.is_night()
    return not is_daytime()
```

### Sky3D Light Queries
```gdscript
func get_sun_light_energy() -> float:
    if sky3d and sky3d.sun:
        return sky3d.sun.light_energy
    return 1.0 if is_daytime() else 0.0

func get_wind_speed() -> float:
    if sky3d:
        return sky3d.wind_speed
    return 1.0
```

## Survivor Needs Updates

Called every in-game hour:
```gdscript
func _update_survivor_needs() -> void:
    var survivors := get_tree().get_nodes_in_group("survivors")
    var temp := get_current_temperature()

    for node in survivors:
        if node.has_method("update_needs"):
            var is_in_shelter := false  # TODO: Check actual shelter
            var is_near_fire := false   # TODO: Check fire proximity
            node.update_needs(1.0, is_in_shelter, is_near_fire, temp)
```

## Rescue Timer

Initialized at game start:
```gdscript
func _initialize_rescue_timer() -> void:
    var base_days := 365
    var extra_days := randi_range(30, 180)
    total_days_to_rescue = base_days + extra_days
    days_until_rescue = total_days_to_rescue
```

Signals emitted when approaching rescue:
```gdscript
if days_until_rescue <= 30:
    rescue_approaching.emit(days_until_rescue)
if days_until_rescue <= 0:
    rescue_arrived.emit()
```

## Display Helpers

```gdscript
func get_formatted_time() -> String:
    if sky3d:
        return sky3d.game_time.substr(0, 5)  # "HH:MM"
    return "%02d:00" % current_hour

func get_formatted_date() -> String:
    if sky3d and sky3d.tod:
        return "%s - %s" % [sky3d.game_date, get_season_name()]
    return "Day %d - %s" % [current_day, get_season_name()]

func get_time_scale_label() -> String:
    if time_scale <= 0.0: return "PAUSED"
    elif time_scale < 1.5: return "1x"
    elif time_scale < 3.0: return "2x"
    else: return "4x"
```

---

## SnowController

Manages snow weather effects with smooth transitions.

### Snow Intensity
```gdscript
enum SnowIntensity { NONE, LIGHT, HEAVY }

var _intensity_configs: Dictionary = {
    SnowIntensity.NONE: {
        "particle_amount_ratio": 0.0,
        "fog_density": 0.0,
        "fog_enabled": false
    },
    SnowIntensity.LIGHT: {
        "particle_amount_ratio": 0.3,
        "fog_density": 0.002,
        "fog_enabled": true
    },
    SnowIntensity.HEAVY: {
        "particle_amount_ratio": 1.0,
        "fog_density": 0.012,
        "fog_enabled": true
    }
}
```

### Signals
```gdscript
signal snow_started(intensity: SnowIntensity)
signal snow_stopped
signal snow_intensity_changed(from: SnowIntensity, to: SnowIntensity)
```

### API
```gdscript
func start_snow(intensity: SnowIntensity = SnowIntensity.LIGHT) -> void
func stop_snow() -> void
func set_snow_immediate(intensity: SnowIntensity) -> void
func is_snowing() -> bool
```

### Transitions
Smooth transitions between intensity levels:
```gdscript
@export var transition_duration: float = 5.0  # Seconds

func _apply_transition() -> void:
    var t: float = _transition_progress  # 0.0 to 1.0

    # Lerp particle amount
    _snow_particles.amount_ratio = lerpf(from_ratio, to_ratio, t)

    # Lerp fog density
    sky3d.environment.volumetric_fog_density = lerpf(from_fog, to_fog, t)
```

### Particle Positioning
Particles follow the camera:
```gdscript
func _update_particle_position() -> void:
    if _camera:
        _snow_particles.global_position = _camera.global_position + Vector3.UP * 15.0
```

### Sky3D Fog Integration
Stores original fog settings and modifies during snow:
```gdscript
func _ready() -> void:
    if sky3d and sky3d.environment:
        _original_fog_enabled = sky3d.environment.volumetric_fog_enabled
        _original_fog_density = sky3d.environment.volumetric_fog_density
```

---

## Arctic Latitude Effects

At 74°N latitude, Sky3D simulates realistic polar phenomena:

| Month | Sun Behavior |
|-------|--------------|
| June-July | Midnight sun (24h daylight) |
| December-January | Polar night (24h darkness) |
| March/September | Normal day/night cycle |

The game starts in September 1846, providing a normal day/night cycle that transitions to polar night as winter approaches.

## Common Modifications

### Change game start date
Edit exports in `time_manager.gd`:
```gdscript
@export var starting_month: int = 6  # June for midnight sun
@export var starting_day: int = 21   # Summer solstice
```

### Adjust temperature range
Modify `SEASON_CONFIG`:
```gdscript
const SEASON_CONFIG: Dictionary = {
    Season.WINTER: {
        "base_temperature": -45.0,  # Colder
    },
}
```

### Add new weather type
1. Create particle scene in `weather/`
2. Add intensity enum and config to new controller
3. Connect to Sky3D environment settings
4. Add signals for weather changes

### Speed up/slow down time
```gdscript
@export var minutes_per_game_day: float = 5.0  # Faster: 5 min/day
```
