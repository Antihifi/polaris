extends Node
## Singleton managing core game state, win/lose conditions, and game flow.
## Access via GameManager autoload.

signal game_started
signal game_over(won: bool, score: int)
signal survivor_count_changed(alive: int, total: int)

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

# Current state
var current_state: GameState = GameState.MAIN_MENU
var initial_survivor_count: int = 0
var survivors_alive: int = 0

# Scene references
var survivor_scene: PackedScene = preload("res://src/characters/survivor.tscn")

# Survivor names pool
const SURVIVOR_NAMES: Array[String] = [
	"Captain Crozier", "Lieutenant Gore", "Sergeant Tozer", "Dr. Goodsir",
	"Mr. Blanky", "Mr. Hickey", "Mr. Diggle", "Mr. Collins",
	"Henry Peglar", "Thomas Evans", "William Strong", "John Hartnell",
	"William Braine", "James Reid", "Edmund Hoar", "George Chambers",
	"Robert Sinclair", "David Young", "Abraham Seeley", "Francis Dunn"
]


func _ready() -> void:
	# Connect to TimeManager signals
	if has_node("/root/TimeManager"):
		var time_manager := get_node("/root/TimeManager")
		time_manager.rescue_arrived.connect(_on_rescue_arrived)


func _unhandled_input(event: InputEvent) -> void:
	if current_state != GameState.PLAYING:
		return

	# Pause toggle
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


# --- Game Flow ---

func start_new_game() -> void:
	## Initialize a new game with random survivors and salvage.
	current_state = GameState.PLAYING

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
	## Create initial survivors with random traits.
	var spawn_center := Vector3.ZERO  # TODO: Get from spawn point in scene
	var spawn_radius := 5.0

	var available_names := SURVIVOR_NAMES.duplicate()
	available_names.shuffle()

	for i in range(initial_survivor_count):
		var survivor := survivor_scene.instantiate() as Survivor

		# Assign name
		if i < available_names.size():
			survivor.survivor_name = available_names[i]
		else:
			survivor.survivor_name = "Survivor %d" % (i + 1)

		# Assign random traits (1-3 traits)
		var trait_count := randi_range(1, 3)
		survivor.traits = SurvivorTrait.get_random_traits(trait_count)

		# Initialize stats with some variation
		survivor.stats = SurvivorStats.new()
		survivor.stats.hunger = randf_range(70.0, 100.0)
		survivor.stats.warmth = randf_range(60.0, 90.0)
		survivor.stats.morale = starting_morale + randf_range(-10.0, 10.0)
		survivor.stats.energy = randf_range(80.0, 100.0)

		# Randomize skills
		survivor.stats.hunting_skill = randf_range(10.0, 50.0)
		survivor.stats.construction_skill = randf_range(10.0, 50.0)
		survivor.stats.medicine_skill = randf_range(10.0, 50.0)
		survivor.stats.navigation_skill = randf_range(10.0, 50.0)
		survivor.stats.survival_skill = randf_range(10.0, 50.0)

		# Position in a circle around spawn point
		var angle := (TAU / initial_survivor_count) * i
		var offset := Vector3(cos(angle), 0, sin(angle)) * spawn_radius
		survivor.global_position = spawn_center + offset

		# Connect death signal
		survivor.died.connect(_on_survivor_died)

		# Add to scene
		get_tree().current_scene.add_child(survivor)


func _generate_starting_salvage() -> void:
	## Generate randomized starting resources from the sunken ship.
	# TODO: Implement when inventory/stockpile system is ready
	# This will use IndieBlueprintLootManager to generate items
	pass


# --- Win/Lose Conditions ---

func _on_survivor_died(survivor: Survivor) -> void:
	survivors_alive -= 1
	survivor_count_changed.emit(survivors_alive, initial_survivor_count)

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
	if survivors_alive > initial_survivor_count / 2:
		score += 2000

	# Morale bonus
	var total_morale := 0.0
	var survivors := get_tree().get_nodes_in_group("survivors")
	for node in survivors:
		if node is Survivor:
			var survivor := node as Survivor
			if survivor.current_state != Survivor.State.DEAD:
				total_morale += survivor.stats.morale

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

func get_all_survivors() -> Array[Survivor]:
	var result: Array[Survivor] = []
	var nodes := get_tree().get_nodes_in_group("survivors")
	for node in nodes:
		if node is Survivor:
			result.append(node as Survivor)
	return result


func get_alive_survivors() -> Array[Survivor]:
	var result: Array[Survivor] = []
	for survivor in get_all_survivors():
		if survivor.current_state != Survivor.State.DEAD:
			result.append(survivor)
	return result


func get_survivor_by_name(survivor_name: String) -> Survivor:
	for survivor in get_all_survivors():
		if survivor.survivor_name == survivor_name:
			return survivor
	return null


func get_survivors_with_trait(trait_id: String) -> Array[Survivor]:
	var result: Array[Survivor] = []
	for survivor in get_alive_survivors():
		if survivor.has_trait(trait_id):
			result.append(survivor)
	return result


func get_game_stats() -> Dictionary:
	## Get current game statistics for UI display.
	var alive := get_alive_survivors()
	var total_hunger := 0.0
	var total_warmth := 0.0
	var total_morale := 0.0

	for survivor in alive:
		total_hunger += survivor.stats.hunger
		total_warmth += survivor.stats.warmth
		total_morale += survivor.stats.morale

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
