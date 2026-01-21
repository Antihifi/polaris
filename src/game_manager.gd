extends Node
## Singleton managing core game state, win/lose conditions, and game flow.
## Access via GameManager autoload.

# Ambient sounds - two wind layers that crossfade continuously
var wind_ambient_1: AudioStream = preload("res://sounds/storm-wind-1.mp3")
var wind_ambient_2: AudioStream = preload("res://sounds/wind2.mp3")
var _wind_player_1: AudioStreamPlayer
var _wind_player_2: AudioStreamPlayer
var _crossfade_progress: float = 0.0  # 0.0 = full wind1, 1.0 = full wind2

signal game_started
signal game_over(won: bool, score: int)
signal survivor_count_changed(alive: int, total: int)
signal poi_locations_set(pois: Dictionary)
signal terrain_generation_progress(stage: String, percent: float)

## Preload terrain generation classes
const SeedManager := preload("res://src/terrain/seed_manager.gd")

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	WON,
	LOST
}

# Game configuration
@export_category("Game Settings")
@export var min_survivors: int = 10
@export var max_survivors: int = 16
@export var starting_morale: float = 75.0

@export_category("Audio")
## Base ambient volume at maximum zoom out (0.0 to 1.0).
@export_range(0.0, 1.0, 0.05) var ambient_volume_max: float = 0.4
## Ambient volume at maximum zoom in (0.0 to 1.0).
@export_range(0.0, 1.0, 0.05) var ambient_volume_min: float = 0.1
## Volume boost for wind2.mp3 (quieter source file needs compensation).
@export_range(1.0, 5.0, 0.1) var wind2_volume_boost: float = 2.5
## Time in seconds for a full crossfade cycle (wind1 -> wind2 -> wind1).
@export_range(10.0, 120.0, 5.0) var crossfade_cycle_seconds: float = 45.0

## Weather-based volume multiplier (set by DynamicWeatherController)
## 1.0 = normal, 1.5 = blizzard (50% louder)
var _weather_volume_multiplier: float = 1.0

# Camera reference for zoom-based audio
var _rts_camera: Camera3D = null

# Current state
var current_state: GameState = GameState.MAIN_MENU
var initial_survivor_count: int = 0
var survivors_alive: int = 0

# Terrain generation state
var seed_manager: SeedManager = null
var poi_locations: Dictionary = {}
var is_new_game: bool = true

# Scene references - uses CharacterSpawner for unit creation
var _character_spawner: Node = null


func _ready() -> void:
	# Connect to TimeManager signals
	if has_node("/root/TimeManager"):
		var time_manager := get_node("/root/TimeManager")
		time_manager.rescue_arrived.connect(_on_rescue_arrived)

	# Create two looping ambient wind players for crossfading
	_wind_player_1 = AudioStreamPlayer.new()
	_wind_player_1.stream = wind_ambient_1
	_wind_player_1.volume_db = linear_to_db(ambient_volume_max)
	_wind_player_1.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_wind_player_1)
	_wind_player_1.finished.connect(_on_wind1_finished)
	_wind_player_1.play()

	_wind_player_2 = AudioStreamPlayer.new()
	_wind_player_2.stream = wind_ambient_2
	_wind_player_2.volume_db = linear_to_db(0.0)  # Start silent
	_wind_player_2.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_wind_player_2)
	_wind_player_2.finished.connect(_on_wind2_finished)
	_wind_player_2.play()

	# Connect to camera zoom after scene is ready
	call_deferred("_connect_camera_zoom")

	# Connect to SnowController for blizzard audio boost
	call_deferred("_connect_snow_controller")


func _process(delta: float) -> void:
	# Continuously crossfade between the two wind sounds using a sine wave
	# This creates a smooth, natural variation in the ambient wind
	_crossfade_progress += delta / crossfade_cycle_seconds
	if _crossfade_progress > 1.0:
		_crossfade_progress -= 1.0
	_update_wind_volume()


func _unhandled_input(_event: InputEvent) -> void:
	# Pause is now handled by DebugMenu (ESC key)
	pass


# --- Terrain/Seed Management ---

func initialize_seed(seed_value: int = 0) -> void:
	## Initialize or reinitialize the seed manager.
	## If seed_value is 0, generates a random seed.
	seed_manager = SeedManager.new()
	if seed_value == 0:
		seed_manager.generate_random_seed()
	else:
		seed_manager.set_seed(seed_value)
	print("[GameManager] Seed initialized: %s" % seed_manager.get_seed_string())


func get_seed_string() -> String:
	## Get the current terrain seed as a shareable string.
	if seed_manager:
		return seed_manager.get_seed_string()
	return ""


func set_poi_locations(pois: Dictionary) -> void:
	## Store POI locations from terrain generation.
	poi_locations = pois.duplicate(true)
	poi_locations_set.emit(poi_locations)
	print("[GameManager] POI locations set: %s" % str(poi_locations.keys()))


func get_ship_position() -> Vector3:
	## Get the ship spawn position (center of survivor spawn).
	return poi_locations.get("ship", Vector3.ZERO)


# --- Game Flow ---

func start_new_game(seed_value: int = 0) -> void:
	## Initialize a new game with random survivors and salvage.
	## If seed_value is 0, uses existing seed or generates random.
	current_state = GameState.PLAYING
	is_new_game = true

	# Initialize seed if not already done
	if not seed_manager:
		initialize_seed(seed_value)
	elif seed_value != 0:
		initialize_seed(seed_value)

	# Determine survivor count
	initial_survivor_count = randi_range(min_survivors, max_survivors)
	survivors_alive = initial_survivor_count

	# Spawn survivors
	_spawn_survivors()

	# Generate starting salvage
	_generate_starting_salvage()

	game_started.emit()
	survivor_count_changed.emit(survivors_alive, initial_survivor_count)


func _spawn_survivors() -> void:
	## Create initial survivors using CharacterSpawner.
	## CharacterSpawner handles name randomization, stats, and AI setup.
	var spawn_center := get_ship_position()

	# Create CharacterSpawner if not exists
	if not _character_spawner:
		var spawner_script: Script = preload("res://src/systems/character_spawner.gd")
		_character_spawner = spawner_script.new()
		_character_spawner.name = "CharacterSpawner"
		add_child(_character_spawner)

	# Configure spawner
	_character_spawner.spawn_center = spawn_center
	_character_spawner.spawn_radius = 5.0

	# Spawn units
	var units: Array[Node] = _character_spawner.spawn_survivors(initial_survivor_count, spawn_center)

	# Connect death signals (units emit stats_changed, check for death there)
	for unit in units:
		if unit.has_signal("stats_changed"):
			unit.stats_changed.connect(_on_unit_stats_changed.bind(unit))


func _generate_starting_salvage() -> void:
	## Generate randomized starting resources from the sunken ship.
	# TODO: Implement when inventory/stockpile system is ready
	# This will use IndieBlueprintLootManager to generate items
	pass


# --- Win/Lose Conditions ---

func _on_unit_stats_changed(unit: Node) -> void:
	## Check if unit died when stats change.
	if "stats" in unit and unit.stats and unit.stats.is_dead():
		_on_unit_died(unit)


func _on_unit_died(unit: Node) -> void:
	## Handle unit death.
	survivors_alive -= 1
	survivor_count_changed.emit(survivors_alive, initial_survivor_count)

	# Disconnect to prevent multiple calls
	if unit.has_signal("stats_changed") and unit.stats_changed.is_connected(_on_unit_stats_changed):
		unit.stats_changed.disconnect(_on_unit_stats_changed)

	# Check for game over
	if survivors_alive <= 0:
		end_game(false)


func _on_rescue_arrived() -> void:
	if current_state == GameState.PLAYING and survivors_alive > 0:
		end_game(true)


func end_game(won: bool) -> void:
	current_state = GameState.WON if won else GameState.LOST

	var score := calculate_score()
	game_over.emit(won, score)

	# Pause the game
	if has_node("/root/TimeManager"):
		get_node("/root/TimeManager").pause()


func calculate_score() -> int:
	## Calculate final score based on survivors, resources, and morale.
	var score := 0

	# Points per survivor alive
	score += survivors_alive * 1000

	# Bonus for saving more than half
	if survivors_alive > initial_survivor_count / 2.0:
		score += 2000

	# Morale bonus
	var total_morale := 0.0
	var alive_units := get_alive_units()
	for unit in alive_units:
		if "stats" in unit and unit.stats:
			total_morale += unit.stats.morale

	if survivors_alive > 0:
		var avg_morale := total_morale / survivors_alive
		score += int(avg_morale * 10)

	# Days survived bonus
	if has_node("/root/TimeManager"):
		var days: int = get_node("/root/TimeManager").get_days_survived()
		score += days * 5

	# TODO: Add resource stockpile bonus

	return score


# --- Pause ---

func toggle_pause() -> void:
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		if has_node("/root/TimeManager"):
			get_node("/root/TimeManager").pause()
	elif current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		if has_node("/root/TimeManager"):
			get_node("/root/TimeManager").unpause()


func is_paused() -> bool:
	return current_state == GameState.PAUSED


# --- Queries ---

func get_all_units() -> Array[Node]:
	## Get all units in the "survivors" group (includes dead).
	var result: Array[Node] = []
	var nodes := get_tree().get_nodes_in_group("survivors")
	for node in nodes:
		result.append(node)
	return result


func get_alive_units() -> Array[Node]:
	## Get all living units (not dead).
	var result: Array[Node] = []
	for unit in get_all_units():
		if "stats" in unit and unit.stats:
			if not unit.stats.is_dead():
				result.append(unit)
		else:
			result.append(unit)  # No stats = assume alive
	return result


func get_unit_by_name(unit_name: String) -> Node:
	## Find a unit by name.
	for unit in get_all_units():
		if "unit_name" in unit and unit.unit_name == unit_name:
			return unit
	return null


func get_units_with_trait(trait_id: String) -> Array[Node]:
	## Get all living units with a specific trait.
	## Note: Traits not yet integrated with ClickableUnit - returns empty for now.
	var result: Array[Node] = []
	for unit in get_alive_units():
		if unit.has_method("has_trait") and unit.has_trait(trait_id):
			result.append(unit)
	return result


func get_game_stats() -> Dictionary:
	## Get current game statistics for UI display.
	var alive := get_alive_units()
	var total_hunger := 0.0
	var total_warmth := 0.0
	var total_morale := 0.0

	for unit in alive:
		if "stats" in unit and unit.stats:
			total_hunger += unit.stats.hunger
			total_warmth += unit.stats.warmth
			total_morale += unit.stats.morale

	var count := alive.size()
	var avg_hunger := total_hunger / count if count > 0 else 0.0
	var avg_warmth := total_warmth / count if count > 0 else 0.0
	var avg_morale := total_morale / count if count > 0 else 0.0

	return {
		"survivors_alive": survivors_alive,
		"initial_survivors": initial_survivor_count,
		"average_hunger": avg_hunger,
		"average_warmth": avg_warmth,
		"average_morale": avg_morale,
		"game_state": GameState.keys()[current_state]
	}


# --- Audio ---

func _on_wind1_finished() -> void:
	## Loop the first ambient wind sound.
	if is_instance_valid(_wind_player_1):
		_wind_player_1.play()


func _on_wind2_finished() -> void:
	## Loop the second ambient wind sound.
	if is_instance_valid(_wind_player_2):
		_wind_player_2.play()


func _connect_camera_zoom() -> void:
	## Find and connect to the RTS camera's zoom signal.
	var tree := get_tree()
	if not tree or not tree.current_scene:
		return

	# Find RTScamera in the scene
	_rts_camera = tree.current_scene.get_node_or_null("RTScamera")
	if _rts_camera and _rts_camera.has_signal("zoom_changed"):
		_rts_camera.zoom_changed.connect(_on_camera_zoom_changed)
		# Set initial volume based on current zoom
		if _rts_camera.has_method("get_zoom_ratio"):
			_on_camera_zoom_changed(_rts_camera.orbit_distance, _rts_camera.get_zoom_ratio())


func _on_camera_zoom_changed(_zoom_level: float, zoom_ratio: float) -> void:
	## Adjust ambient wind volume based on camera zoom.
	## zoom_ratio: 0.0 = zoomed in, 1.0 = zoomed out
	## Wind is louder when zoomed out (overview), quieter when zoomed in (intimate).
	_update_wind_volume(zoom_ratio)


func _update_wind_volume(zoom_ratio: float = -1.0) -> void:
	## Update wind volume based on zoom, weather state, and crossfade.
	if not is_instance_valid(_wind_player_1) or not is_instance_valid(_wind_player_2):
		return

	# Get current zoom ratio if not provided
	if zoom_ratio < 0.0:
		if _rts_camera and _rts_camera.has_method("get_zoom_ratio"):
			zoom_ratio = _rts_camera.get_zoom_ratio()
		else:
			zoom_ratio = 1.0  # Default to zoomed out

	var base_volume := lerpf(ambient_volume_min, ambient_volume_max, zoom_ratio)

	# Apply weather-based volume multiplier (from DynamicWeatherController)
	base_volume *= _weather_volume_multiplier

	# Use sine wave for smooth crossfade (0 -> 1 -> 0 over the cycle)
	# sin gives us -1 to 1, we convert to 0 to 1 for the mix ratio
	var mix := (sin(_crossfade_progress * TAU) + 1.0) * 0.5  # 0.0 to 1.0

	# Calculate individual volumes (crossfade: as one goes up, the other goes down)
	var vol1 := base_volume * (1.0 - mix)
	var vol2 := base_volume * mix * wind2_volume_boost  # Boost quieter wind2

	_wind_player_1.volume_db = linear_to_db(clampf(vol1, 0.001, 1.0))
	_wind_player_2.volume_db = linear_to_db(clampf(vol2, 0.001, 1.0))


func _connect_snow_controller() -> void:
	## Find and connect to the SnowController for blizzard audio boost.
	## NOTE: If DynamicWeatherController is active, it handles volume directly.
	var tree := get_tree()
	if not tree or not tree.current_scene:
		return

	# Find SnowController in the scene
	var snow_controllers := tree.current_scene.find_children("*", "SnowController", true, false)
	if snow_controllers.size() > 0:
		var snow_controller: SnowController = snow_controllers[0]
		snow_controller.snow_started.connect(_on_snow_started)
		snow_controller.snow_stopped.connect(_on_snow_stopped)
		snow_controller.snow_intensity_changed.connect(_on_snow_intensity_changed)
		print("[GameManager] Connected to SnowController for audio callbacks")


func set_weather_volume_multiplier(multiplier: float) -> void:
	## Set the weather-based volume multiplier (called by DynamicWeatherController).
	## 1.0 = clear weather, 1.5 = heavy blizzard
	_weather_volume_multiplier = clampf(multiplier, 1.0, 3.0)
	_update_wind_volume()


func get_weather_volume_multiplier() -> float:
	## Get the current weather volume multiplier.
	return _weather_volume_multiplier


func _on_snow_started(intensity: SnowController.SnowIntensity) -> void:
	## Handle snow starting - set volume based on intensity.
	## Only used as fallback if DynamicWeatherController is not active.
	if intensity == SnowController.SnowIntensity.HEAVY:
		_weather_volume_multiplier = 1.5
	else:
		_weather_volume_multiplier = 1.1
	_update_wind_volume()


func _on_snow_stopped() -> void:
	## Handle snow stopping - restore normal volume.
	_weather_volume_multiplier = 1.0
	_update_wind_volume()


func _on_snow_intensity_changed(_from: SnowController.SnowIntensity, to: SnowController.SnowIntensity) -> void:
	## Handle snow intensity change.
	## Only used as fallback if DynamicWeatherController is not active.
	if to == SnowController.SnowIntensity.HEAVY:
		_weather_volume_multiplier = 1.5
	elif to == SnowController.SnowIntensity.LIGHT:
		_weather_volume_multiplier = 1.1
	else:
		_weather_volume_multiplier = 1.0
	_update_wind_volume()
