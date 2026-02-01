class_name AuroraController
extends Node
## Controls aurora borealis visibility based on weather and time conditions.
## Sets shader uniforms on the Sky3D sky material so the aurora renders as a sky layer
## between stars and clouds — correctly occluded by cloud cover.
## Aurora only appears during clear nights, with higher probability in winter and extreme cold.

signal aurora_started
signal aurora_ended

# --- Appearance ---
@export_category("Appearance")
@export var aurora_color: Color = Color(0.15, 0.85, 0.45, 1.0)
@export var emission_strength: float = 4.0

# --- Timing ---
@export_category("Timing")
@export var fade_duration: float = 8.0  ## Seconds for fade in/out
@export var base_aurora_chance: float = 0.15  ## Per eligible hour
@export var aurora_min_hours: int = 2
@export var aurora_max_hours: int = 6

# --- Shader Tuning ---
@export_category("Shader")
@export var shader_speed: float = 0.01
@export var shader_smoothness: float = 0.3
@export var shader_distort: float = 1.0
@export var shader_scale: float = 0.02
@export var shader_offset: float = 0.0

# References
var _time_manager: Node = null
var _weather_controller: Node = null
var _sky_material: ShaderMaterial = null

# Noise texture for aurora pattern
var _noise_texture: NoiseTexture2D = null

# State
var _aurora_active: bool = false
var _current_intensity: float = 0.0  ## 0.0 = invisible, 1.0 = full
var _remaining_hours: int = 0
var _fade_tween: Tween = null
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	call_deferred("_initialize")


func _initialize() -> void:
	_find_references()
	_setup_sky_aurora()
	_connect_signals()


func _find_references() -> void:
	_time_manager = get_node_or_null("/root/TimeManager")
	if _time_manager:
		print("[AuroraController] Found TimeManager")

	var root: Node = get_tree().current_scene
	if root:
		var controllers: Array[Node] = root.find_children("*", "DynamicWeatherController", true, false)
		if controllers.size() > 0:
			_weather_controller = controllers[0]
			print("[AuroraController] Found DynamicWeatherController")

	# Find Sky3D node and get its sky material
	if root:
		var sky_nodes: Array[Node] = root.find_children("*", "WorldEnvironment", true, false)
		for sky_node: Node in sky_nodes:
			if "sky_material" in sky_node and sky_node.sky_material is ShaderMaterial:
				_sky_material = sky_node.sky_material
				print("[AuroraController] Found sky material via Sky3D")
				break
		if not _sky_material:
			push_warning("[AuroraController] No Sky3D sky_material found — aurora disabled")


func _setup_sky_aurora() -> void:
	## Create noise texture and set initial aurora uniforms on the sky material.
	if not _sky_material:
		return

	# Create noise texture for the aurora pattern
	_noise_texture = NoiseTexture2D.new()
	_noise_texture.width = 512
	_noise_texture.height = 512
	_noise_texture.seamless = true
	var noise_gen: FastNoiseLite = FastNoiseLite.new()
	noise_gen.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise_gen.frequency = 0.01
	noise_gen.fractal_octaves = 3
	_noise_texture.noise = noise_gen

	# Set aurora shader parameters on the sky material
	_sky_material.set_shader_parameter("aurora_noise", _noise_texture)
	_sky_material.set_shader_parameter("aurora_color", aurora_color)
	_sky_material.set_shader_parameter("aurora_emission", emission_strength)
	_sky_material.set_shader_parameter("aurora_speed", shader_speed)
	_sky_material.set_shader_parameter("aurora_smoothness", shader_smoothness)
	_sky_material.set_shader_parameter("aurora_distort", shader_distort)
	_sky_material.set_shader_parameter("aurora_scale", shader_scale)
	_sky_material.set_shader_parameter("aurora_offset", shader_offset)
	_sky_material.set_shader_parameter("aurora_intensity", 0.0)
	_sky_material.set_shader_parameter("aurora_visible", false)

	print("[AuroraController] Aurora sky shader parameters initialized")


func _connect_signals() -> void:
	if _time_manager and _time_manager.has_signal("hour_passed"):
		_time_manager.hour_passed.connect(_on_hour_passed)
		print("[AuroraController] Connected to TimeManager.hour_passed")

	if _weather_controller and _weather_controller.has_signal("weather_event_started"):
		_weather_controller.weather_event_started.connect(_on_weather_event_started)
		print("[AuroraController] Connected to DynamicWeatherController.weather_event_started")


func _on_hour_passed(_hour: int, _day: int) -> void:
	## Evaluate aurora conditions each game hour.
	if _aurora_active:
		_remaining_hours -= 1
		if _remaining_hours <= 0:
			_fade_out_aurora()
			return

		# Check if conditions have become invalid (dawn arrived)
		if not _is_nighttime():
			_fade_out_aurora()
			return
		return

	# Not active — check if we should start
	if not _can_aurora_start():
		return

	var chance: float = _calculate_aurora_chance()
	var roll: float = _rng.randf()
	if roll <= chance:
		_remaining_hours = _rng.randi_range(aurora_min_hours, aurora_max_hours)
		_fade_in_aurora()
		print("[AuroraController] Aurora triggered! Duration: %d hours (roll=%.3f, chance=%.3f)" % [_remaining_hours, roll, chance])


func _on_weather_event_started(event: RefCounted) -> void:
	## If weather changes to snow while aurora is active, fade out.
	if not _aurora_active:
		return

	if event and "intensity_name" in event:
		if event.intensity_name != "Clear":
			print("[AuroraController] Weather changed to %s, fading aurora" % event.intensity_name)
			_fade_out_aurora()


func _can_aurora_start() -> bool:
	## Check hard requirements for aurora.
	if not _is_nighttime():
		return false
	if not _is_clear_weather():
		return false
	return true


func _is_nighttime() -> bool:
	if _time_manager and _time_manager.has_method("is_nighttime"):
		return _time_manager.is_nighttime()
	return false


func _is_clear_weather() -> bool:
	if _weather_controller and _weather_controller.has_method("is_clear_weather"):
		return _weather_controller.is_clear_weather()
	# No weather controller (e.g. menu screen) — assume clear
	return true


func _get_current_temperature() -> float:
	if _time_manager and _time_manager.has_method("get_current_temperature"):
		return _time_manager.get_current_temperature()
	return -20.0  # Default to cold


func _get_current_season() -> int:
	if _time_manager and "current_season" in _time_manager:
		return _time_manager.current_season
	return 2  # Default to winter


func _calculate_aurora_chance() -> float:
	## Calculate aurora probability for this hour based on season and temperature.
	var chance: float = base_aurora_chance

	# Season multiplier
	var season: int = _get_current_season()
	match season:
		0:  # SUMMER
			chance *= 0.3
		1:  # AUTUMN
			chance *= 1.3
		2:  # WINTER
			chance *= 2.0
		3:  # SPRING
			chance *= 1.3

	# Temperature boost — colder = more likely
	var temp: float = _get_current_temperature()
	if temp < -35.0:
		chance *= 2.0
	elif temp < -25.0:
		chance *= 1.5

	return clampf(chance, 0.0, 0.8)  # Cap at 80% to avoid guaranteed triggers


func _fade_in_aurora() -> void:
	if not _sky_material:
		return

	_aurora_active = true
	_sky_material.set_shader_parameter("aurora_visible", true)

	if _fade_tween and _fade_tween.is_valid():
		_fade_tween.kill()

	_fade_tween = create_tween()
	_fade_tween.tween_method(_set_intensity, 0.0, 1.0, fade_duration)

	aurora_started.emit()
	print("[AuroraController] Aurora fading in")


func _fade_out_aurora() -> void:
	if _fade_tween and _fade_tween.is_valid():
		_fade_tween.kill()

	_fade_tween = create_tween()
	_fade_tween.tween_method(_set_intensity, _current_intensity, 0.0, fade_duration)
	_fade_tween.tween_callback(_on_aurora_fully_hidden)

	print("[AuroraController] Aurora fading out")


func _on_aurora_fully_hidden() -> void:
	_aurora_active = false
	_remaining_hours = 0
	if _sky_material:
		_sky_material.set_shader_parameter("aurora_visible", false)
	aurora_ended.emit()


func _set_intensity(value: float) -> void:
	_current_intensity = value
	if _sky_material:
		_sky_material.set_shader_parameter("aurora_intensity", value)


# =============================================================================
# PUBLIC API
# =============================================================================

func start_aurora() -> void:
	## Force aurora on (debug/menu use).
	_remaining_hours = aurora_max_hours
	_fade_in_aurora()


func stop_aurora() -> void:
	## Force aurora off.
	_fade_out_aurora()


func is_aurora_active() -> bool:
	return _aurora_active
