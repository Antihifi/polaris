# Camera System

RTS-style camera with WASD movement, edge scrolling, zoom, and MMB orbit.

## Files

| File | Purpose |
|------|---------|
| `rts_camera.gd` | Main camera script extending Camera3D |
| `rts_camera.tscn` | Scene file (instanced in main.tscn) |

## Architecture

The camera uses an **orbit system** where the camera looks at `orbit_center` from a distance of `orbit_distance`. Yaw/pitch control the viewing angle.

```
     Camera (position calculated)
        \
         \  orbit_distance
          \
           \
            ● orbit_center (ground point being looked at)
```

### Key Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `orbit_center` | Vector3 | (0,0,0) | World position camera looks at |
| `orbit_distance` | float | 25.0 | Distance from orbit_center (zoom level) |
| `_yaw` | float | 0.0 | Horizontal rotation (radians) |
| `_pitch` | float | 0.8 | Vertical angle (radians, ~45°) |

### Derived Properties (read-only)

| Property | Calculation |
|----------|-------------|
| `current_height` | `orbit_distance * sin(_pitch)` |
| `orbit_radius` | `orbit_distance * cos(_pitch)` |

## Movement Controls

### Keyboard (WASD + Arrows)
```gdscript
# In _process()
if Input.is_physical_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
    movement.z -= 1  # Forward
```

Movement is rotated by yaw to stay relative to camera facing:
```gdscript
movement = movement.normalized().rotated(Vector3.UP, _yaw)
orbit_center += movement * camera_speed * speed_multiplier * delta
```

### Edge Scrolling
Activates when mouse is within `edge_scroll_margin` pixels of screen edge.

### Shift Boost
Holding `ui_shift` doubles movement speed (`speed_multiplier = 2.0`).

## Zoom

Controlled via mouse wheel in `_unhandled_input()`:
- `MOUSE_BUTTON_WHEEL_UP`: Zoom in (decrease `orbit_distance`)
- `MOUSE_BUTTON_WHEEL_DOWN`: Zoom out (increase `orbit_distance`)

Clamped between `camera_zoom_min` (10.0) and `camera_zoom_max` (50.0).

### Zoom Signal
```gdscript
signal zoom_changed(zoom_level: float, zoom_ratio: float)

func get_zoom_ratio() -> float:
    # Returns 0.0 (zoomed in) to 1.0 (zoomed out)
    return (orbit_distance - camera_zoom_min) / (camera_zoom_max - camera_zoom_min)
```

Used by `GameManager` to adjust ambient audio volume based on zoom level.

## MMB Orbit Rotation

Holding middle mouse button enables orbit rotation:

```gdscript
# In _unhandled_input() for InputEventMouseMotion
var dx = (event.relative.x / vmin) * yaw_sensitivity * TAU * sixty_fps
var dy = (event.relative.y / vmin) * pitch_sensitivity * TAU * sixty_fps

_yaw -= dx
_pitch += dy
_pitch = clamp(_pitch, deg_to_rad(pitch_min_deg), deg_to_rad(pitch_max_deg))
```

### Rotation Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `yaw_sensitivity` | 0.50 | Horizontal rotation speed |
| `pitch_sensitivity` | 0.18 | Vertical rotation speed |
| `pitch_min_deg` | 10.0 | Minimum tilt (looking down) |
| `pitch_max_deg` | 80.0 | Maximum tilt (looking sideways) |
| `max_step_deg` | 3.0 | Safety cap per frame |

## Focus System

### Focus on Node
```gdscript
func focus_on(target: Node3D, instant: bool = false) -> void:
    _focus_target = target
    _focus_destination = target.global_position
    if instant:
        orbit_center = _focus_destination
    else:
        _is_focusing = true  # Smooth transition
```

### Focus on Position
```gdscript
func focus_on_position(pos: Vector3, instant: bool = false) -> void:
```

### Orbit Target (for MMB rotation)
When a focus target is set and MMB is held, camera orbits around the target:
```gdscript
if _is_mmb_rotating and _focus_target and is_instance_valid(_focus_target):
    orbit_center = _focus_target.global_position
```

This is used by `RTSInputHandler` to allow orbiting around selected units.

## Integration Points

### RTSInputHandler
```gdscript
# On unit selection
if camera and camera.has_method("set_focus_target"):
    camera.set_focus_target(unit)

# On deselection
if camera and camera.has_method("clear_focus_target"):
    camera.clear_focus_target()
```

### GameManager (Audio)
```gdscript
# Connects to zoom_changed for ambient volume
_rts_camera.zoom_changed.connect(_on_camera_zoom_changed)

func _on_camera_zoom_changed(_zoom_level: float, zoom_ratio: float) -> void:
    # Louder when zoomed out, quieter when zoomed in
    var volume := lerpf(ambient_volume_min, ambient_volume_max, zoom_ratio)
    _wind_player.volume_db = linear_to_db(volume)
```

### MainController
```gdscript
# Initial focus on player unit
if rts_camera.has_method("focus_on"):
    rts_camera.focus_on(captain, true)
```

## Position Calculation

Core function that updates camera position from orbit parameters:

```gdscript
func _update_camera_position() -> void:
    # Spherical direction from yaw/pitch
    var dir := Vector3(
        sin(_yaw) * cos(_pitch),
        sin(_pitch),
        cos(_yaw) * cos(_pitch)
    ).normalized()

    position = orbit_center + dir * orbit_distance
    look_at(orbit_center, Vector3.UP)
```

## Exported Settings

All tunable via Inspector:

```gdscript
@export_category("Camera movement")
@export var camera_speed: float = 20.0
@export var camera_zoom_speed: float = 20.0
@export var camera_zoom_min: float = 10.0
@export var camera_zoom_max: float = 50.0

@export_category("Edge scrolling")
@export var edge_scroll_margin: float = 20.0

@export_category("Rotation")
@export var yaw_sensitivity: float = 0.50
@export var pitch_sensitivity: float = 0.18
@export var pitch_min_deg: float = 10.0
@export var pitch_max_deg: float = 80.0

@export_category("Focus")
@export var focus_lerp_speed: float = 5.0
@export var follow_selected: bool = false
```

## Common Modifications

### Change default zoom level
```gdscript
var orbit_distance: float = 25.0  # Change this value
```

### Add camera bounds
In `_process()` after movement calculation:
```gdscript
orbit_center.x = clampf(orbit_center.x, min_x, max_x)
orbit_center.z = clampf(orbit_center.z, min_z, max_z)
```

### Disable edge scrolling
Set `edge_scroll_margin = 0` in Inspector.

### Add camera shake
```gdscript
func shake(intensity: float, duration: float) -> void:
    var tween := create_tween()
    # Add random offset to position over duration
```
