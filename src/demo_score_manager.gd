class_name DemoScoreManager
extends Node
## Tracks demo win/lose conditions and calculates scoring.
##
## Win: A sled reaches the "open water" Area3D at the south coast.
## Lose: All survivors dead.
## Score based on: survivors, condition, errant men found, tents, food.

signal demo_won(score: Dictionary)
signal demo_lost(reason: String)

## The open water Area3D (created by demo_controller at south coast)
var open_water_area: Area3D = null

## Tracked errant units (set by demo_controller after spawning)
var errant_units: Array[Node] = []

## Whether the game is active
var _game_active: bool = false


func setup(water_area: Area3D) -> void:
	## Initialize with the open water win-condition area.
	open_water_area = water_area
	open_water_area.body_entered.connect(_on_body_entered_open_water)
	_game_active = true

	# Connect to GameManager for lose condition
	var game_manager: Node = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.game_over.connect(_on_game_over)


func register_errant_units(units: Array[Node]) -> void:
	## Register errant units for discovery tracking.
	errant_units = units


func _on_body_entered_open_water(body: Node3D) -> void:
	## Check if a sled entered the open water area.
	if not _game_active:
		return

	if body.is_in_group("sleds"):
		_game_active = false
		var score: Dictionary = calculate_score()
		demo_won.emit(score)

		# Also notify GameManager
		var game_manager: Node = get_node_or_null("/root/GameManager")
		if game_manager and game_manager.has_method("end_game"):
			game_manager.end_game(true)

		print("[DemoScoreManager] WIN! Score: %s" % str(score))


func _on_game_over(won: bool, _score: int) -> void:
	## Handle game over from GameManager (all survivors dead).
	if won or not _game_active:
		return

	_game_active = false
	demo_lost.emit("All survivors have perished.")
	print("[DemoScoreManager] LOSE - All survivors dead")


func calculate_score() -> Dictionary:
	## Calculate the final demo score breakdown.
	var score: Dictionary = {}

	# Survivors alive
	var alive_units: Array[Node] = _get_alive_units()
	score["survivors_alive"] = alive_units.size()
	score["survivor_points"] = alive_units.size() * 500

	# Men in good condition (all 5 core stats > 50%)
	var good_condition_count: int = 0
	for unit in alive_units:
		if _is_in_good_condition(unit):
			good_condition_count += 1
	score["good_condition"] = good_condition_count
	score["condition_points"] = good_condition_count * 200

	# Errant men found (discovered from originally-errant groups)
	var errant_found: int = 0
	for unit in errant_units:
		if is_instance_valid(unit) and "is_discovered" in unit and unit.is_discovered:
			errant_found += 1
	score["errant_found"] = errant_found
	score["errant_points"] = errant_found * 300

	# Tents built (count tent scene instances in tree)
	var tents_built: int = _count_scene_instances("small_tent")
	score["tents_built"] = tents_built
	score["tent_points"] = tents_built * 150

	# Food stockpiled (items in containers)
	var food_items: int = _count_food_stockpiled()
	score["food_items"] = food_items
	score["food_points"] = food_items * 50

	# Total
	score["total"] = (
		score["survivor_points"] +
		score["condition_points"] +
		score["errant_points"] +
		score["tent_points"] +
		score["food_points"]
	)

	return score


func _get_alive_units() -> Array[Node]:
	## Get all living survivor units.
	var result: Array[Node] = []
	for unit in get_tree().get_nodes_in_group("survivors"):
		if "stats" in unit and unit.stats and not unit.stats.is_dead():
			result.append(unit)
	return result


func _is_in_good_condition(unit: Node) -> bool:
	## Check if all 5 core stats are above 50%.
	if not "stats" in unit or not unit.stats:
		return false
	var s: SurvivorStats = unit.stats
	return (
		s.hunger > 50.0 and
		s.warmth > 50.0 and
		s.health > 50.0 and
		s.morale > 50.0 and
		s.energy > 50.0
	)


func _count_scene_instances(name_contains: String) -> int:
	## Count scene instances whose name contains the given string.
	var count: int = 0
	_count_matching_nodes(get_tree().root, name_contains, count)
	return count


func _count_matching_nodes(node: Node, name_contains: String, count: int) -> int:
	## Recursively count nodes whose name contains the search string.
	if name_contains in node.name.to_lower():
		count += 1
	for child in node.get_children():
		count = _count_matching_nodes(child, name_contains, count)
	return count


func _count_food_stockpiled() -> int:
	## Count food items across all containers.
	var count: int = 0
	for container in get_tree().get_nodes_in_group("containers"):
		if container.has_method("get_item_count"):
			count += container.get_item_count()
		elif "inventory" in container:
			var inv: Node = container.inventory
			if inv and inv.has_method("get_items"):
				count += inv.get_items().size()
	return count
