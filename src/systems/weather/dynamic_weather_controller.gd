## Dynamic weather controller that manages procedural snow events.
## Creates varied weather events with randomized parameters, respecting time-of-day constraints.
## FAVORS clear weather during sunrise/sunset (due to shader light scattering), but allows
## existing events to complete naturally - never abruptly cancels ongoing weather.
class_name DynamicWeatherController
extends Node

signal weather_event_started(event: WeatherEvent)
signal weather_event_ended(event: WeatherEvent)
signal weather_status_changed(status: Dictionary)

## Current weather event data
class WeatherEvent:
	var intensity_name: String = "Clear"
	var wind_speed: float = 0.0
	var wind_direction: float = 0.0
	var fog_density: float = 0.0
	var particle_ratio: float = 0.0
	var duration_seconds: float = 0.0
	var start_time: float = 0.0
	var is_blizzard: bool = false

	func get_wind_direction_cardinal() -> String:
		var deg := rad_to_deg(wind_direction)
		if deg < 0:
			deg += 360.0
		if deg >= 337.5 or deg < 22.5:
			return "N"
		elif deg < 67.5:
			return "NE"
		elif deg < 112.5:
			return "E"
		elif deg < 157.5:
			return "SE"
		elif deg < 202.5:
			return "S"
		elif deg < 247.5:
			return "SW"
		elif deg < 292.5:
			return "W"
		else:
			return "NW"

## References
var _snow_controller: SnowController = null
var _time_manager: Node = null
var _sky3d: Node = null
var _game_manager: Node = null
var _forced_event: bool = false  # True when weather is manually forced (debug menu)

## Current state
var _current_event: WeatherEvent = null
var _clear_weather_timer: float = 0.0
var _event_timer: float = 0.0
var _is_transitioning: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

## Persistent wind state - drifts gradually between events rather than jumping
## This creates realistic weather where wind direction shifts slowly over time
var _persistent_wind_direction: float = 0.0  # Radians, -PI to PI
var _persistent_wind_speed: float = 3.0  # m/s, baseline light breeze

# =============================================================================
# TIMING CONFIGURATION (in GAME minutes)
# =============================================================================
@export_category("Weather Timing")

## Minimum clear weather duration (game minutes)
@export var clear_weather_min_minutes: float = 4.0

## Maximum clear weather duration (game minutes)
@export var clear_weather_max_minutes: float = 6.0

## Minimum light snow duration (game minutes)
@export var light_snow_max_minutes: float = 5.0

## Maximum heavy blizzard duration (game minutes)
@export var heavy_blizzard_max_minutes: float = 2.0

## Transition duration (real seconds) - smooth fade between states
@export var transition_duration: float = 8.0

# =============================================================================
# TIME-OF-DAY CONSTRAINTS
# =============================================================================
@export_category("Time Constraints")

## Hours considered "sunrise" - avoid snow (light scattering issues)
@export var sunrise_start_hour: float = 4.0
@export var sunrise_end_hour: float = 7.0

## Hours considered "sunset" - avoid snow
@export var sunset_start_hour: float = 18.0
@export var sunset_end_hour: float = 21.0

## Prefer heavier snow during midday (10-16)
@export var midday_start_hour: float = 10.0
@export var midday_end_hour: float = 16.0

# =============================================================================
# INTENSITY WEIGHTS
# =============================================================================
@export_category("Weather Probabilities")

## Weight for clear weather (0-1)
@export_range(0.0, 1.0) var weight_clear: float = 0.35

## Weight for very light snow
@export_range(0.0, 1.0) var weight_very_light: float = 0.2

## Weight for light snow
@export_range(0.0, 1.0) var weight_light: float = 0.2

## Weight for light-medium snow
@export_range(0.0, 1.0) var weight_light_medium: float = 0.12

## Weight for medium snow
@export_range(0.0, 1.0) var weight_medium: float = 0.08

## Weight for heavy blizzard (rare!)
@export_range(0.0, 1.0) var weight_heavy: float = 0.05

func _ready() -> void:
	_rng.randomize()

	# Initialize persistent wind with random starting direction
	_persistent_wind_direction = _rng.randf_range(-PI, PI)
	_persistent_wind_speed = _rng.randf_range(2.0, 5.0)  # Light breeze to start

	# Find references
	await get_tree().process_frame
	_find_references()

	# Create initial clear weather event
	_current_event = WeatherEvent.new()
	_current_event.intensity_name = "Clear"
	_current_event.wind_direction = _persistent_wind_direction
	_current_event.wind_speed = _persistent_wind_speed
	_current_event.duration_seconds = _get_game_minutes_as_seconds(_rng.randf_range(clear_weather_min_minutes, clear_weather_max_minutes))
	_current_event.start_time = Time.get_ticks_msec() / 1000.0

	print("[DynamicWeather] Initialized - starting with clear weather for %.1f game minutes" % (clear_weather_min_minutes))


func _find_references() -> void:
	# Find SnowController
	var root := get_tree().current_scene
	if root:
		var nodes := root.find_children("*", "SnowController", true, false)
		if nodes.size() > 0:
			_snow_controller = nodes[0]
			print("[DynamicWeather] Found SnowController")

	# Find TimeManager
	_time_manager = get_node_or_null("/root/TimeManager")
	if _time_manager:
		print("[DynamicWeather] Found TimeManager")

	# Find Sky3D
	if root:
		var sky_nodes := root.find_children("*Sky3D*", "", true, false)
		if sky_nodes.size() > 0:
			_sky3d = sky_nodes[0]
			print("[DynamicWeather] Found Sky3D")

	# Find GameManager for wind audio integration
	_game_manager = get_node_or_null("/root/GameManager")
	if _game_manager:
		print("[DynamicWeather] Found GameManager for audio integration")


func _process(delta: float) -> void:
	if not _snow_controller:
		return

	# Don't process weather during pause (menu open)
	if get_tree().paused:
		return

	# Update event timer
	_update_event_timer(delta)

	# Emit status updates periodically
	weather_status_changed.emit(get_weather_status())


func _update_event_timer(delta: float) -> void:
	if _is_transitioning:
		return

	# Skip timer updates when weather is manually forced (debug menu)
	if _forced_event:
		return

	_event_timer += delta

	# Check if current event has expired
	if _current_event and _event_timer >= _current_event.duration_seconds:
		_event_timer = 0.0
		_schedule_next_event()


func _schedule_next_event() -> void:
	## Schedule the next weather event based on weights and time-of-day
	## Note: Sunrise/sunset only influences NEW event selection, never cancels existing events

	var current_hour := _get_current_hour()
	var is_sunrise := current_hour >= sunrise_start_hour and current_hour < sunrise_end_hour
	var is_sunset := current_hour >= sunset_start_hour and current_hour < sunset_end_hour
	var is_midday := current_hour >= midday_start_hour and current_hour < midday_end_hour
	var is_golden_hour := is_sunrise or is_sunset

	# If we were snowing, go to clear weather (natural event transition)
	if _current_event and _current_event.intensity_name != "Clear":
		_start_clear_weather()
		return

	# Pick next weather event based on weighted random
	# Golden hour (sunrise/sunset) FAVORS clear weather but doesn't force it
	var intensity := _pick_weighted_intensity(is_midday, is_golden_hour)

	if is_golden_hour and intensity != "Clear":
		print("[DynamicWeather] Golden hour (%.1f) - selected %s despite sunrise/sunset" % [current_hour, intensity])

	if intensity == "Clear":
		_start_clear_weather()
	else:
		_start_snow_event(intensity, is_midday)


func _pick_weighted_intensity(favor_heavy: bool, favor_clear: bool = false) -> String:
	## Pick a weather intensity based on weights
	## favor_heavy: true during midday to boost storm chances
	## favor_clear: true during sunrise/sunset to favor clear skies (but not force)

	var weights := {
		"Clear": weight_clear,
		"Very Light": weight_very_light,
		"Light": weight_light,
		"Light-Medium": weight_light_medium,
		"Medium": weight_medium,
		"Heavy": weight_heavy,
	}

	# During midday, boost heavier weather chances
	if favor_heavy:
		weights["Light-Medium"] *= 1.5
		weights["Medium"] *= 1.8
		weights["Heavy"] *= 2.0
		weights["Clear"] *= 0.7

	# During sunrise/sunset (golden hour), strongly favor clear weather
	# but don't force it - there's still a small chance of weather
	if favor_clear:
		weights["Clear"] *= 4.0  # Heavily boost clear chance
		weights["Very Light"] *= 0.3  # Reduce all snow intensities
		weights["Light"] *= 0.2
		weights["Light-Medium"] *= 0.1
		weights["Medium"] *= 0.05
		weights["Heavy"] *= 0.02  # Very unlikely during golden hour

	# Normalize weights
	var total: float = 0.0
	for w in weights.values():
		total += w

	var roll := _rng.randf() * total
	var cumulative: float = 0.0

	for intensity in weights.keys():
		cumulative += weights[intensity]
		if roll <= cumulative:
			return intensity

	return "Clear"


func _start_clear_weather() -> void:
	## Transition to clear weather
	print("[DynamicWeather] Starting clear weather")

	_is_transitioning = true

	# Wind direction drifts gradually during clear weather too (max ~30°)
	var direction_drift := _rng.randf_range(-PI / 6.0, PI / 6.0)
	_persistent_wind_direction = wrapf(_persistent_wind_direction + direction_drift, -PI, PI)

	# Wind speed drifts toward calm (1-4 m/s) gradually
	var target_speed := _rng.randf_range(1.0, 4.0)
	var speed_diff := target_speed - _persistent_wind_speed
	speed_diff = clampf(speed_diff, -5.0, 5.0)  # Max 5 m/s change
	_persistent_wind_speed = clampf(_persistent_wind_speed + speed_diff, 1.0, 35.0)

	# Create clear weather event
	var event := WeatherEvent.new()
	event.intensity_name = "Clear"
	event.wind_speed = _persistent_wind_speed
	event.wind_direction = _persistent_wind_direction
	event.fog_density = 0.0
	event.particle_ratio = 0.0
	event.duration_seconds = _get_game_minutes_as_seconds(
		_rng.randf_range(clear_weather_min_minutes, clear_weather_max_minutes)
	)
	event.start_time = Time.get_ticks_msec() / 1000.0
	event.is_blizzard = false

	# Stop snow with smooth transition
	if _snow_controller:
		_snow_controller.transition_duration = transition_duration
		_snow_controller.stop_snow()

	# Update wind in Sky3D
	_set_sky3d_wind(event.wind_speed, event.wind_direction)

	# Set wind audio volume multiplier in GameManager (clear weather = base volume)
	_set_weather_volume_multiplier(1.0)

	_current_event = event
	weather_event_started.emit(event)

	# Wait for transition to complete
	await get_tree().create_timer(transition_duration + 0.5).timeout
	_is_transitioning = false
	weather_event_ended.emit(event)


func _start_snow_event(intensity: String, is_midday: bool) -> void:
	## Start a snow event with randomized parameters
	print("[DynamicWeather] Starting %s snow event (midday=%s)" % [intensity, is_midday])

	_is_transitioning = true

	# Create snow event with randomized parameters
	var event := _generate_snow_event(intensity)

	# Apply to snow controller
	if _snow_controller:
		_apply_event_to_snow_controller(event)

	# Update wind in Sky3D
	_set_sky3d_wind(event.wind_speed, event.wind_direction)

	# Set wind audio volume multiplier in GameManager
	var volume_mult := _get_volume_multiplier_for_intensity(intensity)
	_set_weather_volume_multiplier(volume_mult)

	_current_event = event
	weather_event_started.emit(event)

	# Wait for transition
	await get_tree().create_timer(transition_duration + 0.5).timeout
	_is_transitioning = false


func _generate_snow_event(intensity: String) -> WeatherEvent:
	## Generate a snow event with randomized parameters based on intensity.
	## Wind direction drifts gradually from current state (max ~45° per event).
	## Wind speed changes gradually based on intensity target range.

	var event := WeatherEvent.new()
	event.intensity_name = intensity
	event.start_time = Time.get_ticks_msec() / 1000.0

	# Wind direction drifts gradually - max ~45° (PI/4) shift per event
	# This creates realistic weather where wind doesn't suddenly reverse
	var direction_drift := _rng.randf_range(-PI / 4.0, PI / 4.0)
	_persistent_wind_direction = wrapf(_persistent_wind_direction + direction_drift, -PI, PI)
	event.wind_direction = _persistent_wind_direction

	# Wind speed drifts toward intensity target range (max ~5 m/s change per event)
	# This prevents jarring jumps from calm to blizzard in one transition
	var target_speed_min: float
	var target_speed_max: float

	# Particle ratios scaled for 15000 max particles:
	# - Lower intensities maintain similar visual to before (5000 * old_ratio ≈ 15000 * new_ratio)
	# - Heavy blizzard uses full 15000 = 3x more particles than before
	match intensity:
		"Very Light":
			target_speed_min = 3.0
			target_speed_max = 6.0
			event.fog_density = _rng.randf_range(0.005, 0.012)
			event.particle_ratio = _rng.randf_range(0.05, 0.1)  # ~750-1500 particles
			event.duration_seconds = _get_game_minutes_as_seconds(_rng.randf_range(2.0, light_snow_max_minutes))
			event.is_blizzard = false

		"Light":
			target_speed_min = 6.0
			target_speed_max = 10.0
			event.fog_density = _rng.randf_range(0.012, 0.018)
			event.particle_ratio = _rng.randf_range(0.1, 0.17)  # ~1500-2500 particles
			event.duration_seconds = _get_game_minutes_as_seconds(_rng.randf_range(2.0, light_snow_max_minutes))
			event.is_blizzard = false

		"Light-Medium":
			target_speed_min = 10.0
			target_speed_max = 15.0
			event.fog_density = _rng.randf_range(0.018, 0.025)
			event.particle_ratio = _rng.randf_range(0.17, 0.25)  # ~2500-3750 particles
			event.duration_seconds = _get_game_minutes_as_seconds(_rng.randf_range(1.5, 4.0))
			event.is_blizzard = false

		"Medium":
			target_speed_min = 15.0
			target_speed_max = 22.0
			event.fog_density = _rng.randf_range(0.025, 0.035)
			event.particle_ratio = _rng.randf_range(0.25, 0.4)  # ~3750-6000 particles
			event.duration_seconds = _get_game_minutes_as_seconds(_rng.randf_range(1.0, 3.0))
			event.is_blizzard = false

		"Heavy":
			target_speed_min = 22.0
			target_speed_max = 30.0
			event.fog_density = _rng.randf_range(0.035, 0.05)
			event.particle_ratio = 1.0  # Full 15000 particles (3x previous max)
			# Heavy blizzards are short - max 2 game minutes
			event.duration_seconds = _get_game_minutes_as_seconds(_rng.randf_range(0.5, heavy_blizzard_max_minutes))
			event.is_blizzard = true

		_:  # Default to very light
			target_speed_min = 3.0
			target_speed_max = 6.0
			event.fog_density = _rng.randf_range(0.005, 0.012)
			event.particle_ratio = _rng.randf_range(0.05, 0.1)
			event.duration_seconds = _get_game_minutes_as_seconds(_rng.randf_range(2.0, 4.0))
			event.is_blizzard = false

	# Drift wind speed toward target range (max 5 m/s change per event)
	var target_speed := _rng.randf_range(target_speed_min, target_speed_max)
	var max_speed_change := 5.0
	var speed_diff := target_speed - _persistent_wind_speed
	speed_diff = clampf(speed_diff, -max_speed_change, max_speed_change)
	_persistent_wind_speed = clampf(_persistent_wind_speed + speed_diff, 1.0, 35.0)
	event.wind_speed = _persistent_wind_speed

	return event


func _apply_event_to_snow_controller(event: WeatherEvent) -> void:
	## Apply event parameters to the SnowController

	# Set transition duration for smooth changes
	_snow_controller.transition_duration = transition_duration

	# Determine which base intensity to use
	var base_intensity: int = SnowController.SnowIntensity.LIGHT
	if event.is_blizzard or event.intensity_name == "Heavy":
		base_intensity = SnowController.SnowIntensity.HEAVY

	# Override specific parameters for this event
	# Dynamically modify the snow controller's export values before starting

	if base_intensity == SnowController.SnowIntensity.LIGHT:
		_snow_controller.light_wind_speed = event.wind_speed
		_snow_controller.light_particle_ratio = event.particle_ratio
		_snow_controller.light_fog_shader_density = event.fog_density

		# Adjust other parameters based on intensity variation
		var intensity_factor := event.particle_ratio / 0.5  # Normalize around light default
		_snow_controller.light_camera_far_ratio = clampf(0.5 - (intensity_factor - 1.0) * 0.1, 0.2, 0.6)
		_snow_controller.light_sun_energy = clampf(0.8 - (intensity_factor - 1.0) * 0.1, 0.5, 0.9)

	else:  # HEAVY
		_snow_controller.heavy_wind_speed = event.wind_speed
		_snow_controller.heavy_particle_ratio = event.particle_ratio
		_snow_controller.heavy_fog_shader_density = event.fog_density

		# Heavy blizzard settings
		_snow_controller.heavy_camera_far_ratio = clampf(0.05 - event.fog_density * 0.5, 0.025, 0.1)
		_snow_controller.heavy_sun_energy = clampf(0.3 - event.fog_density * 2.0, 0.15, 0.4)

	# Start the snow
	_snow_controller.start_snow(base_intensity)


func _set_sky3d_wind(speed: float, direction: float) -> void:
	## Set wind in Sky3D
	if _sky3d:
		if "wind_speed" in _sky3d:
			_sky3d.wind_speed = speed
		if "wind_direction" in _sky3d:
			_sky3d.wind_direction = direction


func _get_volume_multiplier_for_intensity(intensity: String) -> float:
	## Get wind volume multiplier for GameManager based on intensity
	## GameManager already has base wind audio - we just adjust the multiplier
	match intensity:
		"Clear":
			return 1.0
		"Very Light":
			return 1.05
		"Light":
			return 1.1
		"Light-Medium":
			return 1.2
		"Medium":
			return 1.35
		"Heavy":
			return 1.5  # Matches GameManager's blizzard_volume_multiplier
		_:
			return 1.0


func _set_weather_volume_multiplier(multiplier: float) -> void:
	## Set the wind audio volume multiplier in GameManager
	if _game_manager and _game_manager.has_method("set_weather_volume_multiplier"):
		_game_manager.set_weather_volume_multiplier(multiplier)


func _get_current_hour() -> float:
	## Get current hour from TimeManager/Sky3D
	if _time_manager and "current_hour" in _time_manager:
		return float(_time_manager.current_hour)
	if _sky3d and "tod" in _sky3d and _sky3d.tod:
		return _sky3d.tod.current_time
	return 12.0  # Default to midday


func _get_game_minutes_as_seconds(game_minutes: float) -> float:
	## Convert game minutes to real seconds based on time scale
	## Sky3D default: 15 real minutes = 24 game hours = 1440 game minutes
	## So 1 game minute = 15*60/1440 = 0.625 real seconds at 1x speed

	var minutes_per_day := 15.0
	if _sky3d and "minutes_per_day" in _sky3d:
		minutes_per_day = _sky3d.minutes_per_day

	# Real seconds per game minute
	var real_seconds_per_game_minute := (minutes_per_day * 60.0) / 1440.0

	return game_minutes * real_seconds_per_game_minute


# =============================================================================
# PUBLIC API
# =============================================================================

func get_weather_status() -> Dictionary:
	## Get current weather status for UI display
	if not _current_event:
		return {
			"event_name": "Clear",
			"wind_speed": 0.0,
			"wind_direction": "N",
			"fog_density": 0.0,
			"is_blizzard": false,
			"time_remaining": 0.0,
		}

	var elapsed := Time.get_ticks_msec() / 1000.0 - _current_event.start_time
	var remaining := maxf(0.0, _current_event.duration_seconds - elapsed)

	return {
		"event_name": _current_event.intensity_name,
		"wind_speed": _current_event.wind_speed,
		"wind_direction": _current_event.get_wind_direction_cardinal(),
		"fog_density": _current_event.fog_density,
		"is_blizzard": _current_event.is_blizzard,
		"time_remaining": remaining,
	}


func get_current_event() -> WeatherEvent:
	return _current_event


func force_weather(intensity: String) -> void:
	## Force a specific weather type (for debug menu).
	## Forced weather does NOT auto-expire - it stays until another force_weather
	## call or until resume_automatic_weather() is called.
	_event_timer = 0.0
	_forced_event = true

	print("[DynamicWeather] FORCED: %s (auto-scheduling disabled)" % intensity)

	if intensity == "Clear":
		_start_clear_weather()
	else:
		_start_snow_event(intensity, true)


func force_clear_weather() -> void:
	## Immediately transition to clear weather
	force_weather("Clear")


func is_safe_for_snow() -> bool:
	## Check if current time is safe for snow (not sunrise/sunset)
	var hour := _get_current_hour()
	var is_sunrise := hour >= sunrise_start_hour and hour < sunrise_end_hour
	var is_sunset := hour >= sunset_start_hour and hour < sunset_end_hour
	return not is_sunrise and not is_sunset
