class_name CharacterSpawner extends Node
## Spawns multiple characters using captain.tscn as the base unit.
## Randomizes stats, names, and animation offsets for variety.

signal survivors_spawned(count: int)
signal spawn_progress(current: int, total: int)

## Scene to instantiate for each unit (defaults to captain.tscn)
@export var unit_scene: PackedScene

## Random name pools (Franklin expedition era)
const FIRST_NAMES: Array[String] = [
	"James", "John", "William", "Thomas", "Henry", "Charles", "George", "Edward",
	"Francis", "Robert", "Richard", "Samuel", "Frederick", "Alexander", "Benjamin",
	"Alfred", "Arthur", "Patrick", "Joseph", "Michael", "Daniel", "David", "Peter",
	"Solomon", "Cornelius", "Magnus", "Neptune", "Abraham", "Harry", "Fitzjames"
]

const LAST_NAMES: Array[String] = [
	"Franklin", "Crozier", "Fitzjames", "Goodsir", "Blanky", "Irving", "Little",
	"Hodgson", "Des Voeux", "Peglar", "Armitage", "Bridgens", "Gibson", "Hartnell",
	"Torrington", "Braine", "Stanley", "McDonald", "Rae", "Ross", "McClintock",
	"Barrow", "Parry", "Back", "Richardson", "Gore", "Collins", "Reid", "Peddie"
]

## Spawn area configuration
@export var spawn_center: Vector3 = Vector3.ZERO
@export var spawn_radius: float = 20.0
@export var min_separation: float = 2.0

## Base movement speed for spawned units (captain default is 5.0)
@export var base_movement_speed: float = 5.0

var _spawned_units: Array[Node] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _terrain_cache: Node = null


func _ready() -> void:
	_rng.randomize()

	# Load default unit
	if not unit_scene:
		unit_scene = preload("res://src/characters/men.tscn")


func spawn_survivors(count: int, center: Vector3 = Vector3.INF) -> Array[Node]:
	## Spawn multiple units around a center point.
	## Returns array of spawned unit nodes.

	if center == Vector3.INF:
		center = spawn_center

	var spawned: Array[Node] = []
	var positions := _generate_spawn_positions(count, center)

	for i in range(count):
		var unit := _spawn_single_unit(positions[i], i)
		if unit:
			spawned.append(unit)
			_spawned_units.append(unit)
			spawn_progress.emit(i + 1, count)

	survivors_spawned.emit(spawned.size())
	print("[CharacterSpawner] Spawned %d units" % spawned.size())
	return spawned


func _spawn_single_unit(position: Vector3, index: int) -> Node:
	## Create and configure a single unit.
	var unit: Node = unit_scene.instantiate()

	# Add to scene FIRST (before setting global_position to avoid error)
	get_tree().current_scene.add_child(unit)

	# Now set position (node is in tree)
	unit.global_position = position

	# Generate random identity
	var first_name := FIRST_NAMES[_rng.randi() % FIRST_NAMES.size()]
	var last_name := LAST_NAMES[_rng.randi() % LAST_NAMES.size()]
	unit.unit_name = "%s %s" % [first_name, last_name]

	# Randomize stats
	_randomize_stats(unit)

	# Set movement speed with slight variation (±20%)
	unit.movement_speed = _vary_value(base_movement_speed, 0.2)

	# Set random animation offset (0-1) so units don't animate in sync
	if "animation_offset" in unit:
		unit.animation_offset = _rng.randf()
		_apply_initial_animation_offset(unit)

	# Randomize initial rotation so they face different directions
	unit.rotation.y = _rng.randf() * TAU

	return unit


func _randomize_stats(unit: Node) -> void:
	## Randomize survival stats for variety.
	if not "stats" in unit or not unit.stats:
		return

	var stats: SurvivorStats = unit.stats

	# Vary base needs (start with some variation in condition)
	# Testing: Start at ~55% (47-63%) to trigger priority behaviors
	stats.hunger = _vary_value(55.0, 0.15)
	stats.warmth = _vary_value(55.0, 0.15)
	stats.health = _vary_value(60.0, 0.08)
	stats.morale = _vary_value(55.0, 0.15)
	stats.energy = _vary_value(55.0, 0.15)

	# Vary skills significantly
	stats.hunting_skill = _vary_value(25.0, 0.5)
	stats.construction_skill = _vary_value(25.0, 0.5)
	stats.medicine_skill = _vary_value(25.0, 0.5)
	stats.navigation_skill = _vary_value(25.0, 0.5)
	stats.survival_skill = _vary_value(25.0, 0.5)

	# Vary resistances
	stats.cold_resistance = _vary_value(25.0, 0.4)

	# Vary physical attributes
	stats.max_carry_weight = _vary_value(50.0, 0.3)


func _apply_initial_animation_offset(unit: Node) -> void:
	## Apply animation offset to the current idle animation.
	var anim_player: AnimationPlayer = _find_animation_player(unit)
	if not anim_player:
		return

	var offset: float = unit.animation_offset if "animation_offset" in unit else 0.0
	if offset <= 0.0:
		return

	var current_anim := anim_player.current_animation
	if current_anim.is_empty():
		return

	var anim_length := anim_player.current_animation_length
	if anim_length > 0:
		anim_player.seek(offset * anim_length, true)


func _find_animation_player(node: Node) -> AnimationPlayer:
	## Recursively search for AnimationPlayer in node tree.
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var found := _find_animation_player(child)
		if found:
			return found
	return null


func _vary_value(base_value: float, variation: float) -> float:
	## Return base_value with random variation.
	var min_val := base_value * (1.0 - variation)
	var max_val := base_value * (1.0 + variation)
	return _rng.randf_range(min_val, max_val)


func _generate_spawn_positions(count: int, center: Vector3) -> Array[Vector3]:
	## Generate spread-out positions avoiding overlap.
	var positions: Array[Vector3] = []
	var max_attempts := 100

	for i in range(count):
		var pos := Vector3.ZERO
		var valid := false
		var attempts := 0

		while not valid and attempts < max_attempts:
			attempts += 1

			# Generate random position in circle
			var angle := _rng.randf() * TAU
			var radius := sqrt(_rng.randf()) * spawn_radius  # sqrt for uniform distribution
			pos = center + Vector3(cos(angle) * radius, 0, sin(angle) * radius)

			# Check separation from existing positions
			valid = true
			for existing_pos in positions:
				if pos.distance_to(existing_pos) < min_separation:
					valid = false
					break

		# Get terrain height at position (if terrain exists)
		pos.y = _get_terrain_height(pos)
		positions.append(pos)

	return positions


func _get_terrain_height(position: Vector3) -> float:
	## Query terrain height at position.
	var terrain := _find_terrain3d()
	if terrain and "data" in terrain and terrain.data:
		var height: float = terrain.data.get_height(position)
		if not is_nan(height):
			return height
	return position.y


func _find_terrain3d() -> Node:
	## Find Terrain3D node in scene (cached).
	if _terrain_cache and is_instance_valid(_terrain_cache):
		return _terrain_cache

	var nodes := get_tree().get_nodes_in_group("terrain")
	if nodes.size() > 0:
		_terrain_cache = nodes[0]
		return _terrain_cache

	_terrain_cache = _find_node_by_class(get_tree().current_scene, "Terrain3D")
	return _terrain_cache


func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	if node.get_class() == class_name_str:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_str)
		if result:
			return result
	return null


func get_all_survivors() -> Array[Node]:
	## Returns all units spawned by this spawner.
	var valid: Array[Node] = []
	for s in _spawned_units:
		if is_instance_valid(s):
			valid.append(s)
	_spawned_units = valid
	return valid


func despawn_all() -> void:
	## Remove all spawned units.
	for unit in _spawned_units:
		if is_instance_valid(unit):
			unit.queue_free()
	_spawned_units.clear()
	print("[CharacterSpawner] Despawned all units")


func print_survivor_summary() -> void:
	## Debug function to print spawned unit info.
	print("\n=== Spawned Units Summary ===")
	for i in range(_spawned_units.size()):
		var u: Node = _spawned_units[i]
		if is_instance_valid(u):
			var name_str: String = u.unit_name if "unit_name" in u else u.name
			if "stats" in u and u.stats:
				print("%d. %s - HP:%.0f HUN:%.0f WRM:%.0f EN:%.0f SPD:%.1f" % [
					i + 1,
					name_str,
					u.stats.health,
					u.stats.hunger,
					u.stats.warmth,
					u.stats.energy,
					u.movement_speed if "movement_speed" in u else 0.0
				])
			else:
				print("%d. %s (no stats)" % [i + 1, name_str])
	print("=============================\n")
