extends Node
## Singleton managing game time, seasons, and rescue timer.
## Integrates with Sky3D for day/night cycle visuals.
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

# Sky3D integration
var sky3d: Node = null  # Reference to Sky3D node

# Time configuration
@export_category("Time Settings")
@export var minutes_per_game_day: float = 15.0  # Real minutes per in-game day (matches Sky3D default)
@export var hours_per_day: int = 24
@export var days_per_season: int = 90

# Arctic location settings (high latitude for extreme day/night variation)
# NOTE: Using 60°N instead of real 74°N - Sky3D's calculation is too aggressive at extreme latitudes
@export_category("Location")
@export var arctic_latitude: float = 60.0  # Reduced from 74°N for better day/night cycles
@export var arctic_longitude: float = -95.0  # ~95°W for King William Island area
@export var utc_offset: float = -6.0  # Central Time zone (closest to expedition location)

# Current time state (synced from Sky3D)
var current_hour: int = 8
var current_day: int = 1
var current_season: Season = Season.SUMMER
var days_until_rescue: int = 0
var total_days_to_rescue: int = 0

# Time control
var time_scale: float = 1.0  # 0 = paused, 1 = normal, 2 = fast, 4 = faster
var is_paused: bool = false

# Internal tracking
var _last_hour: int = -1
var _last_day: int = -1

# Season configurations (temperature only - Sky3D handles lighting)
const SEASON_CONFIG: Dictionary = {
	Season.SUMMER: {
		"name": "Summer",
		"base_temperature": -5.0,  # Celsius
		"month_start": 6  # June
	},
	Season.AUTUMN: {
		"name": "Autumn",
		"base_temperature": -15.0,
		"month_start": 9  # September
	},
	Season.WINTER: {
		"name": "Winter",
		"base_temperature": -35.0,
		"month_start": 12  # December
	},
	Season.SPRING: {
		"name": "Spring",
		"base_temperature": -10.0,
		"month_start": 3  # March
	}
}


func _ready() -> void:
	# Find Sky3D in the scene tree (deferred to ensure scene is ready)
	call_deferred("_find_sky3d")

	# Calculate rescue timer (1 year + random extra months)
	_initialize_rescue_timer()


func _find_sky3d() -> void:
	## Locate Sky3D node and configure it for our game.
	sky3d = _find_node_by_class(get_tree().current_scene, "Sky3D")
	if sky3d:
		print("[TimeManager] Found Sky3D, integrating...")
		_configure_sky3d()
		# Connect to TimeOfDay signals
		var tod: Node = sky3d.tod
		if tod:
			tod.time_changed.connect(_on_sky3d_time_changed)
			tod.day_changed.connect(_on_sky3d_day_changed)
			print("[TimeManager] Connected to Sky3D TimeOfDay signals")
	else:
		print("[TimeManager] WARNING: Sky3D not found, using fallback time system")


## Starting date for the expedition (September 1846 - when Franklin expedition became trapped in ice)
## NOTE: Using 2024 temporarily to test if Sky3D has issues with historical dates
@export var starting_month: int = 9
@export var starting_day: int = 12
@export var starting_year: int = 2024  # Changed from 1846 to test
@export var starting_hour: float = 8.0

func _configure_sky3d() -> void:
	## Configure Sky3D for arctic survival game.
	if not sky3d:
		return

	# Set arctic location for realistic polar day/night cycles
	var tod: Node = sky3d.tod
	if tod:
		# Location: King William Island area (Franklin expedition)
		tod.latitude = deg_to_rad(arctic_latitude)
		tod.longitude = deg_to_rad(arctic_longitude)
		tod.utc = utc_offset

		# Set starting date - expedition trapped in ice (September 1846)
		# This is critical for proper sun position at arctic latitudes
		tod.year = starting_year
		tod.month = starting_month
		tod.day = starting_day
		tod.current_time = starting_hour

		print("[TimeManager] Set location to ", arctic_latitude, "°N, ", arctic_longitude, "°W, UTC", utc_offset)
		print("[TimeManager] Starting date: ", tod.game_date, " at ", tod.game_time)
		print("[TimeManager] Sky3D TOD values - year: ", tod.year, " month: ", tod.month, " day: ", tod.day)
		print("[TimeManager] Sky3D latitude (rad): ", tod.latitude, " = ", rad_to_deg(tod.latitude), "°")
		print("[TimeManager] Sky3D game_time_enabled: ", sky3d.game_time_enabled)
		print("[TimeManager] Sky3D minutes_per_day: ", sky3d.minutes_per_day)

		# Force a celestial update after we set the date
		if tod.has_method("_update_celestial_coords"):
			tod._update_celestial_coords()
			print("[TimeManager] Forced celestial coords update")

	# Set initial time scale
	_update_sky3d_time_scale()


func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	if node.get_class() == class_name_str or (node.has_method("get_script") and node.get_script() and node.get_script().get_global_name() == class_name_str):
		return node
	# Also check script class_name
	if "Sky3D" in node.name:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_str)
		if result:
			return result
	return null


var _debug_time_log_counter: int = 0

func _process(_delta: float) -> void:
	if not sky3d:
		return

	# Sync our time tracking with Sky3D
	_sync_from_sky3d()

	# Debug: log time every ~5 seconds (300 frames at 60fps)
	_debug_time_log_counter += 1
	if _debug_time_log_counter >= 300:
		_debug_time_log_counter = 0
		var debug_info := ""
		if sky3d and sky3d.tod:
			var tod: Node = sky3d.tod
			debug_info = "Date: %d-%02d-%02d | Lat: %.1f°" % [tod.year, tod.month, tod.day, rad_to_deg(tod.latitude)]
		print("[TimeManager] Time: ", get_formatted_time(), " | ", debug_info)


func _initialize_rescue_timer() -> void:
	## Set up the rescue timer: 365 days + 30-180 random days.
	var base_days := 365
	var extra_days := randi_range(30, 180)
	total_days_to_rescue = base_days + extra_days
	days_until_rescue = total_days_to_rescue


func _sync_from_sky3d() -> void:
	## Sync our time state from Sky3D's TimeOfDay.
	if not sky3d or not sky3d.tod:
		return

	var tod: Node = sky3d.tod
	var sky_hour := int(tod.current_time)
	var sky_day: int = tod.day

	# Check for hour change
	if sky_hour != _last_hour:
		_last_hour = sky_hour
		current_hour = sky_hour
		hour_passed.emit(current_hour, current_day)
		_update_survivor_needs()

	# Check for day change
	if sky_day != _last_day and _last_day != -1:
		_last_day = sky_day
		_on_day_advanced()

	_last_day = sky_day


func _on_sky3d_time_changed(_value: float) -> void:
	## Called when Sky3D time changes.
	pass  # We handle this in _sync_from_sky3d for smoother tracking


func _on_sky3d_day_changed(_value: int) -> void:
	## Called when Sky3D day changes.
	_on_day_advanced()


func _on_day_advanced() -> void:
	## Handle day advancement logic.
	current_day += 1
	days_until_rescue -= 1

	day_passed.emit(current_day)

	# Determine season from Sky3D month
	_update_season_from_sky3d()

	# Check rescue timer
	if days_until_rescue <= 30:
		rescue_approaching.emit(days_until_rescue)

	if days_until_rescue <= 0:
		rescue_arrived.emit()


func _update_season_from_sky3d() -> void:
	## Determine current season based on Sky3D month.
	if not sky3d or not sky3d.tod:
		return

	var month: int = sky3d.tod.month
	var new_season := current_season

	# Northern hemisphere seasons
	if month >= 6 and month <= 8:
		new_season = Season.SUMMER
	elif month >= 9 and month <= 11:
		new_season = Season.AUTUMN
	elif month == 12 or month <= 2:
		new_season = Season.WINTER
	else:  # 3, 4, 5
		new_season = Season.SPRING

	if new_season != current_season:
		current_season = new_season
		season_changed.emit(current_season)


func _update_sky3d_time_scale() -> void:
	## Update Sky3D's time progression based on our time scale.
	if not sky3d:
		return

	if is_paused or time_scale <= 0.0:
		# Use game_time_enabled property - more reliable than pause()/resume()
		# pause() only stops the timer, but game_time_enabled fully disables time progression
		sky3d.game_time_enabled = false
		print("[TimeManager] Sky3D paused (game_time_enabled = false)")
	else:
		# Adjust minutes_per_day based on time scale
		# Base: 15 minutes per day, faster speeds = shorter real-time days
		var new_minutes_per_day := minutes_per_game_day / time_scale
		sky3d.minutes_per_day = new_minutes_per_day
		sky3d.game_time_enabled = true
		print("[TimeManager] Sky3D speed set to ", new_minutes_per_day, " minutes/day (", time_scale, "x)")

#TODO: FIX NEAR FIRE CHECK TO SEND TO TIME MANAGER?

func _update_survivor_needs() -> void:
	## Called each in-game hour to update all survivor needs.
	## Shelter/fire proximity is now tracked via Area3D on each unit.
	var survivors := get_tree().get_nodes_in_group("survivors")
	var temp := get_current_temperature()
	var is_day := is_daytime()

	for node in survivors:
		if node.has_method("update_needs"):
			# Check shelter status from unit
			var in_shelter := false
			if node.has_method("is_in_shelter"):
				in_shelter = node.is_in_shelter()
			# Sunlight = daytime AND not in shelter
			var in_sunlight := is_day and not in_shelter
			# Check fire proximity
			var near_fire := false
			if node.has_method("is_near_fire"):
				near_fire = node.is_near_fire()
			node.update_needs(1.0, in_shelter, near_fire, temp, in_sunlight)


# --- Time Control ---

func pause() -> void:
	is_paused = true
	time_scale = 0.0
	_update_sky3d_time_scale()
	time_scale_changed.emit(time_scale)


func unpause() -> void:
	is_paused = false
	time_scale = 1.0
	_update_sky3d_time_scale()
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
	_update_sky3d_time_scale()
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


# --- Temperature Override (Debug) ---
var _temperature_override_enabled: bool = false
var _temperature_override_value: float = 0.0

func set_temperature_override(enabled: bool, value: float = 0.0) -> void:
	## Enable/disable temperature override for debugging.
	_temperature_override_enabled = enabled
	_temperature_override_value = value

func is_temperature_override_enabled() -> bool:
	return _temperature_override_enabled

func get_temperature_override_value() -> float:
	return _temperature_override_value

# --- Environment Queries ---

func get_current_temperature() -> float:
	## Get current temperature in Celsius based on season and time of day.
	## Returns override value if debug override is enabled.
	if _temperature_override_enabled:
		return _temperature_override_value

	var config: Dictionary = SEASON_CONFIG[current_season]
	var base_temp: float = config.base_temperature

	# Temperature variation by time of day (warmer during day, colder at night)
	var time_modifier: float = 0.0
	if is_daytime():
		# Daytime - warmer, peaks at midday
		var hour_float: float = current_hour
		if sky3d and sky3d.tod:
			hour_float = sky3d.tod.current_time
		# Simple sine curve for temperature variation
		var day_progress := (hour_float - 6.0) / 12.0  # Assume ~6am to 6pm core
		day_progress = clampf(day_progress, 0.0, 1.0)
		time_modifier = sin(day_progress * PI) * 5.0  # Up to 5 degrees warmer at midday
	else:
		# Nighttime - colder
		time_modifier = -5.0

	return base_temp + time_modifier


func is_daytime() -> bool:
	## Returns true if sun is above horizon (uses Sky3D if available).
	if sky3d:
		return sky3d.is_day()
	# Fallback
	return current_hour >= 6 and current_hour < 20


func is_nighttime() -> bool:
	## Returns true if sun is below horizon (uses Sky3D if available).
	if sky3d:
		return sky3d.is_night()
	return not is_daytime()


func get_sun_light_energy() -> float:
	## Get current sun light energy from Sky3D.
	if sky3d and sky3d.sun:
		return sky3d.sun.light_energy
	return 1.0 if is_daytime() else 0.0


func get_moon_light_energy() -> float:
	## Get current moon light energy from Sky3D.
	if sky3d and sky3d.moon:
		return sky3d.moon.light_energy
	return 0.3 if is_nighttime() else 0.0


func get_wind_speed() -> float:
	## Get current wind speed from Sky3D (m/s).
	if sky3d:
		return sky3d.wind_speed
	return 1.0


func get_wind_direction() -> float:
	## Get current wind direction from Sky3D (radians, 0 = north).
	if sky3d:
		return sky3d.wind_direction
	return 0.0


func is_blizzard() -> bool:
	## Returns true if weather is severe (HEAVY snow).
	## Used by AI to trigger emergency shelter seeking.
	var snow_controller: Node = _find_snow_controller()
	if snow_controller and "current_intensity" in snow_controller:
		# SnowIntensity.HEAVY = 2
		return snow_controller.current_intensity == 2
	return false


func _find_snow_controller() -> Node:
	## Finds the SnowController node in the scene.
	var nodes := get_tree().get_nodes_in_group("weather")
	if nodes.size() > 0:
		return nodes[0]
	# Search by name
	return get_tree().current_scene.find_child("SnowController", true, false)


# --- Getters ---

func get_season_name() -> String:
	return SEASON_CONFIG[current_season].name


func get_formatted_date() -> String:
	## Returns date string like "Day 45 - Autumn" or full date from Sky3D.
	if sky3d and sky3d.tod:
		return "%s - %s" % [sky3d.game_date, get_season_name()]
	return "Day %d - %s" % [current_day, get_season_name()]


func get_formatted_time() -> String:
	## Returns time string like "14:30" from Sky3D.
	if sky3d:
		return sky3d.game_time.substr(0, 5)  # "HH:MM" without seconds
	return "%02d:00" % current_hour


func get_sky3d_date() -> String:
	## Returns Sky3D's date string (YYYY-MM-DD).
	if sky3d:
		return sky3d.game_date
	return ""


func get_sky3d_time() -> String:
	## Returns Sky3D's time string (HH:MM:SS).
	if sky3d:
		return sky3d.game_time
	return ""


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
