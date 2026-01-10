class_name WindController
extends Node3D
## Controls global wind parameters for shaders.
## Rotate this node to change wind direction (wind blows along -Z axis).
## In production, integrate with SnowController/WeatherSystem for coordinated effects.

@export_group("Wind Settings")
@export_range(0.0, 3.0) var wind_intensity: float = 0.8:
	set(value):
		wind_intensity = value
		_update_wind_intensity()

@export_range(0.0, 5.0) var wind_speed: float = 1.5:
	set(value):
		wind_speed = value
		_update_wind_speed()

@export_group("Animation")
@export var animate_intensity: bool = false
@export_range(0.1, 1.5) var intensity_min: float = 0.4
@export_range(0.5, 3.0) var intensity_max: float = 1.2
@export_range(0.1, 2.0) var intensity_cycle_speed: float = 0.3

@export var animate_direction: bool = false
@export_range(1.0, 45.0) var direction_sway_degrees: float = 15.0
@export_range(0.05, 0.5) var direction_sway_speed: float = 0.1

var _last_rotation: Vector3 = Vector3.ZERO
var _base_rotation_y: float = 0.0
var _time_accumulator: float = 0.0


func _ready() -> void:
	_base_rotation_y = rotation.y
	_update_all_wind_params()


func _process(delta: float) -> void:
	_time_accumulator += delta

	# Animate intensity (gusts)
	if animate_intensity:
		var t := (sin(_time_accumulator * intensity_cycle_speed * TAU) + 1.0) * 0.5
		var animated_intensity := lerpf(intensity_min, intensity_max, t)
		RenderingServer.global_shader_parameter_set("wind_intensity", animated_intensity)

	# Animate direction (swaying wind)
	if animate_direction:
		var sway := sin(_time_accumulator * direction_sway_speed * TAU)
		rotation.y = _base_rotation_y + deg_to_rad(sway * direction_sway_degrees)

	# Update direction only when rotation changes
	if rotation != _last_rotation:
		_update_wind_direction()
		_last_rotation = rotation


func _update_wind_direction() -> void:
	# Wind blows along the node's -Z axis (forward)
	var forward := -basis.z
	var wind_dir := Vector3(forward.x, 0.0, forward.z).normalized()
	RenderingServer.global_shader_parameter_set("wind_direction", wind_dir)


func _update_wind_intensity() -> void:
	RenderingServer.global_shader_parameter_set("wind_intensity", wind_intensity)


func _update_wind_speed() -> void:
	RenderingServer.global_shader_parameter_set("wind_speed", wind_speed)


func _update_all_wind_params() -> void:
	_update_wind_direction()
	_update_wind_intensity()
	_update_wind_speed()


## Call this to sync wind with weather intensity (0.0 = calm, 1.0 = storm)
func set_weather_intensity(weather_factor: float) -> void:
	wind_intensity = lerpf(intensity_min, intensity_max, weather_factor)
	wind_speed = lerpf(0.4, 1.5, weather_factor)
