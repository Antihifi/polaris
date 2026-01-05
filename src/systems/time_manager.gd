extends Node
## Singleton managing game time, day/night cycle, seasons, and rescue timer.
## Access via TimeManager autoload.

signal hour_passed(hour: int, day: int)
signal day_passed(day: int)
signal season_changed(season: Season)
signal time_scale_changed(scale: float)
signal rescue_approaching(days_remaining: int)
signal rescue_arrived

enum Season {
	SUMMER,
	AUTUMN,
	WINTER,
	SPRING
}

# Time configuration
@export_category("Time Settings")
@export var seconds_per_game_hour: float = 30.0  # Real seconds per in-game hour
@export var hours_per_day: int = 24
@export var days_per_season: int = 90

# Current time state
var current_hour: int = 8  # Start at 8 AM
var current_day: int = 1
var current_season: Season = Season.SUMMER
var days_until_rescue: int = 0
var total_days_to_rescue: int = 0

# Time control
var time_scale: float = 1.0  # 0 = paused, 1 = normal, 2 = fast, 4 = faster
var is_paused: bool = false

# Internal timer
var _time_accumulator: float = 0.0

# Season configurations
const SEASON_CONFIG: Dictionary = {
	Season.SUMMER: {
		"name": "Summer",
		"sunrise_hour": 4,
		"sunset_hour": 22,
		"base_temperature": -5.0,  # Celsius
		"light_intensity": 1.0
	},
	Season.AUTUMN: {
		"name": "Autumn",
		"sunrise_hour": 7,
		"sunset_hour": 17,
		"base_temperature": -15.0,
		"light_intensity": 0.8
	},
	Season.WINTER: {
		"name": "Winter",
		"sunrise_hour": 10,
		"sunset_hour": 14,
		"base_temperature": -35.0,
		"light_intensity": 0.5
	},
	Season.SPRING: {
		"name": "Spring",
		"sunrise_hour": 6,
		"sunset_hour": 18,
		"base_temperature": -10.0,
		"light_intensity": 0.9
	}
}


func _ready() -> void:
	# Calculate rescue timer (1 year + random extra months)
	_initialize_rescue_timer()


func _process(delta: float) -> void:
	if is_paused or time_scale <= 0.0:
		return

	_time_accumulator += delta * time_scale

	# Check if an hour has passed
	while _time_accumulator >= seconds_per_game_hour:
		_time_accumulator -= seconds_per_game_hour
		_advance_hour()


func _initialize_rescue_timer() -> void:
	## Set up the rescue timer: 365 days + 30-180 random days.
	var base_days := 365
	var extra_days := randi_range(30, 180)
	total_days_to_rescue = base_days + extra_days
	days_until_rescue = total_days_to_rescue


func _advance_hour() -> void:
	current_hour += 1

	if current_hour >= hours_per_day:
		current_hour = 0
		_advance_day()

	hour_passed.emit(current_hour, current_day)

	# Update all survivors' needs
	_update_survivor_needs()


func _advance_day() -> void:
	current_day += 1
	days_until_rescue -= 1

	day_passed.emit(current_day)

	# Check for season change
	var season_day := (current_day - 1) % (days_per_season * 4)
	var new_season := Season.SUMMER

	if season_day < days_per_season:
		new_season = Season.SUMMER
	elif season_day < days_per_season * 2:
		new_season = Season.AUTUMN
	elif season_day < days_per_season * 3:
		new_season = Season.WINTER
	else:
		new_season = Season.SPRING

	if new_season != current_season:
		current_season = new_season
		season_changed.emit(current_season)

	# Check rescue timer
	if days_until_rescue <= 30:
		rescue_approaching.emit(days_until_rescue)

	if days_until_rescue <= 0:
		rescue_arrived.emit()


func _update_survivor_needs() -> void:
	## Called each in-game hour to update all survivor needs.
	var survivors := get_tree().get_nodes_in_group("survivors")
	var temp := get_current_temperature()

	for node in survivors:
		if node.has_method("update_needs"):
			# TODO: Check if survivor is in shelter or near fire
			var is_in_shelter := false
			var is_near_fire := false
			node.update_needs(1.0, is_in_shelter, is_near_fire, temp)


# --- Time Control ---

func pause() -> void:
	is_paused = true
	time_scale = 0.0
	time_scale_changed.emit(time_scale)


func unpause() -> void:
	is_paused = false
	time_scale = 1.0
	time_scale_changed.emit(time_scale)


func toggle_pause() -> void:
	if is_paused:
		unpause()
	else:
		pause()


func set_time_scale(scale: float) -> void:
	## Set time scale. 0 = paused, 1 = normal, 2 = fast, 4 = faster.
	time_scale = clampf(scale, 0.0, 4.0)
	is_paused = time_scale <= 0.0
	time_scale_changed.emit(time_scale)


func cycle_time_scale() -> void:
	## Cycle through time scales: 0 -> 1 -> 2 -> 4 -> 0.
	if time_scale <= 0.0:
		set_time_scale(1.0)
	elif time_scale < 1.5:
		set_time_scale(2.0)
	elif time_scale < 3.0:
		set_time_scale(4.0)
	else:
		set_time_scale(0.0)


# --- Environment Queries ---

func get_current_temperature() -> float:
	## Get current temperature in Celsius based on season and time of day.
	var config: Dictionary = SEASON_CONFIG[current_season]
	var base_temp: float = config.base_temperature

	# Temperature variation by time of day
	var sunrise: int = config.sunrise_hour
	var sunset: int = config.sunset_hour
	var midday := (sunrise + sunset) / 2

	var time_modifier: float = 0.0
	if current_hour >= sunrise and current_hour <= sunset:
		# Daytime - warmer
		var day_progress := float(current_hour - sunrise) / float(sunset - sunrise)
		time_modifier = sin(day_progress * PI) * 5.0  # Up to 5 degrees warmer at midday
	else:
		# Nighttime - colder
		time_modifier = -5.0

	return base_temp + time_modifier


func is_daytime() -> bool:
	var config: Dictionary = SEASON_CONFIG[current_season]
	return current_hour >= config.sunrise_hour and current_hour < config.sunset_hour


func is_nighttime() -> bool:
	return not is_daytime()


func get_daylight_hours() -> int:
	var config: Dictionary = SEASON_CONFIG[current_season]
	return config.sunset_hour - config.sunrise_hour


func get_light_intensity() -> float:
	## Get current light intensity for DirectionalLight3D.
	var config: Dictionary = SEASON_CONFIG[current_season]
	var base_intensity: float = config.light_intensity

	if is_nighttime():
		return base_intensity * 0.1  # Very dim at night

	# Smooth transition at sunrise/sunset
	var sunrise: int = config.sunrise_hour
	var sunset: int = config.sunset_hour

	if current_hour < sunrise + 2:
		# Sunrise transition
		var progress := float(current_hour - sunrise + 2) / 2.0
		return base_intensity * clampf(progress, 0.1, 1.0)
	elif current_hour > sunset - 2:
		# Sunset transition
		var progress := float(sunset - current_hour) / 2.0
		return base_intensity * clampf(progress, 0.1, 1.0)

	return base_intensity


func get_sun_rotation() -> float:
	## Get sun rotation angle for day/night cycle (0-360 degrees).
	var config: Dictionary = SEASON_CONFIG[current_season]
	var sunrise: int = config.sunrise_hour
	var sunset: int = config.sunset_hour

	# Map hour to rotation (sunrise = -90, noon = 0, sunset = 90)
	var day_length: int = sunset - sunrise
	var midday: float = (sunrise + sunset) / 2.0

	if current_hour >= sunrise and current_hour <= sunset:
		var progress: float = (current_hour - midday) / (day_length / 2.0)
		return progress * 90.0
	else:
		# Night - sun below horizon
		if current_hour > sunset:
			var night_progress: float = (current_hour - sunset) / float(24 - sunset + sunrise)
			return 90.0 + night_progress * 180.0
		else:
			var night_progress: float = (sunrise - current_hour) / float(sunrise)
			return -90.0 - (1.0 - night_progress) * 180.0


# --- Getters ---

func get_season_name() -> String:
	return SEASON_CONFIG[current_season].name


func get_formatted_date() -> String:
	## Returns date string like "Day 45 - Autumn".
	return "Day %d - %s" % [current_day, get_season_name()]


func get_formatted_time() -> String:
	## Returns time string like "14:00".
	return "%02d:00" % current_hour


func get_rescue_progress() -> float:
	## Returns 0.0 to 1.0 indicating progress toward rescue.
	if total_days_to_rescue <= 0:
		return 1.0
	return 1.0 - (float(days_until_rescue) / float(total_days_to_rescue))


func get_days_survived() -> int:
	return current_day


func get_time_scale_label() -> String:
	if time_scale <= 0.0:
		return "PAUSED"
	elif time_scale < 1.5:
		return "1x"
	elif time_scale < 3.0:
		return "2x"
	else:
		return "4x"


# --- Rescue Timer Modification ---

func reduce_rescue_timer(days: int) -> void:
	## Reduce days until rescue (from expedition signals, etc.).
	days_until_rescue = maxi(1, days_until_rescue - days)
	rescue_approaching.emit(days_until_rescue)
