class_name CharacterSpawner extends Node
## Spawns multiple characters using captain.tscn as the base unit.
## Randomizes stats, names, and animation offsets for variety.

signal survivors_spawned(count: int)
signal spawn_progress(current: int, total: int)

## Scene to instantiate for each unit (defaults to men.tscn)
@export var unit_scene: PackedScene

## Officer scene (no AI controller, player-controlled)
var officer_scene: PackedScene

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

	# Load default unit scenes
	if not unit_scene:
		unit_scene = preload("res://src/characters/men.tscn")
	if not officer_scene:
		officer_scene = preload("res://src/characters/officers.tscn")


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


func spawn_officers(count: int, center: Vector3) -> Array[Node]:
	## Spawn multiple officers (player-controlled, no AI).
	## Used for ship complement officers.
	var spawned: Array[Node] = []
	var positions := _generate_spawn_positions(count, center)

	for i in range(count):
		var officer := _spawn_single_officer(positions[i], i)
		if officer:
			spawned.append(officer)
			_spawned_units.append(officer)

	print("[CharacterSpawner] Spawned %d officers" % spawned.size())
	return spawned


func spawn_errant_group(center: Vector3, men_count: int, has_officer: bool, leash_radius: float = 20.0) -> Array[Node]:
	## Spawn an errant group (undiscovered, AI-controlled, leashed to camp).
	## These units don't appear in roster until discovered by captain/officer.
	var group: Array[Node] = []
	var positions := _generate_spawn_positions(men_count + (1 if has_officer else 0), center)
	var pos_idx := 0

	# Spawn men (undiscovered, AI-controlled)
	for i in range(men_count):
		var unit := _spawn_single_unit(positions[pos_idx], i)
		if unit:
			unit.is_discovered = false
			unit.remove_from_group("selectable_units")
			unit.leash_center = center
			unit.leash_radius = leash_radius
			group.append(unit)
		pos_idx += 1

	# Optionally spawn officer (undiscovered, AI-controlled until found)
	if has_officer and pos_idx < positions.size():
		var officer := _spawn_errant_officer(positions[pos_idx])
		if officer:
			officer.is_discovered = false
			officer.remove_from_group("selectable_units")
			officer.leash_center = center
			officer.leash_radius = leash_radius
			group.append(officer)

	print("[CharacterSpawner] Spawned errant group: %d men, %s officer" % [
		men_count, "1" if has_officer else "no"])
	return group


func _spawn_single_officer(position: Vector3, index: int) -> Node:
	## Create and configure a single officer (player-controlled).
	var unit: Node = officer_scene.instantiate()

	# Set rank BEFORE add_child so _ready() can configure PassiveAI correctly
	unit.rank = ClickableUnit.UnitRank.OFFICER

	# Add to scene (triggers _ready which checks rank for PassiveAI setup)
	get_tree().current_scene.add_child(unit)
	unit.global_position = position

	# Generate random identity
	var first_name := FIRST_NAMES[_rng.randi() % FIRST_NAMES.size()]
	var last_name := LAST_NAMES[_rng.randi() % LAST_NAMES.size()]
	unit.unit_name = "Lt. %s %s" % [first_name, last_name]

	# Randomize stats
	_randomize_stats(unit)

	# Set movement speed with slight variation
	unit.movement_speed = _vary_value(base_movement_speed, 0.15)

	# Random rotation
	unit.rotation.y = _rng.randf() * TAU

	# ~30% chance to assign Personable trait (officers are more social)
	if _rng.randf() < 0.3 and unit.has_method("add_trait"):
		unit.add_trait(SurvivorTrait.create_personable())

	return unit


func _spawn_errant_officer(position: Vector3) -> Node:
	## Spawn an officer for errant group (AI-controlled until discovered).
	## Uses men.tscn (with AI) but sets rank to OFFICER.
	var unit: Node = unit_scene.instantiate()  # men.tscn has ManAIController

	# Set rank BEFORE add_child so _ready() knows this is an officer
	unit.rank = ClickableUnit.UnitRank.OFFICER

	get_tree().current_scene.add_child(unit)
	unit.global_position = position

	var first_name := FIRST_NAMES[_rng.randi() % FIRST_NAMES.size()]
	var last_name := LAST_NAMES[_rng.randi() % LAST_NAMES.size()]
	unit.unit_name = "Lt. %s %s" % [first_name, last_name]

	_randomize_stats(unit)
	unit.movement_speed = _vary_value(base_movement_speed, 0.15)
	unit.rotation.y = _rng.randf() * TAU

	# ~30% chance to assign Personable trait (officers are more social)
	if _rng.randf() < 0.3 and unit.has_method("add_trait"):
		unit.add_trait(SurvivorTrait.create_personable())

	_spawned_units.append(unit)
	return unit


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

	# ~20% chance to assign Personable trait (well-liked crew member)
	if _rng.randf() < 0.2 and unit.has_method("add_trait"):
		unit.add_trait(SurvivorTrait.create_personable())

	return unit


func _randomize_stats(unit: Node) -> void:
	## Randomize survival stats for variety.
	if not "stats" in unit or not unit.stats:
		return

	var stats: SurvivorStats = unit.stats

	# All units start at full health and energy
	stats.health = 100.0
	stats.energy = 100.0

	# Warmth and hunger still varied for early-game pressure
	stats.warmth = _rng.randf_range(50.0, 80.0)
	stats.hunger = _rng.randf_range(50.0, 80.0)
	stats.morale = _vary_value(87.5, 0.086)

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

	# Generate strength with skewed distribution (60-100, higher values rare)
	var strength_value: float = _generate_skewed_strength()
	stats.base_strength = strength_value
	stats.current_strength = strength_value


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


func _generate_skewed_strength() -> float:
	## Generate strength 60-100 with values above 70 increasingly rare.
	## Uses inverse power distribution: most units will be 60-70, few will be 85+.
	## Approximately: 50% get 60-70, 35% get 70-85, 15% get 85-100.
	var uniform: float = _rng.randf()  # 0.0 to 1.0
	var power: float = 2.5  # Higher = more skewed toward lower values
	var skewed: float = 1.0 - pow(uniform, 1.0 / power)
	return 60.0 + skewed * 40.0  # Maps to 60-100 range


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


# =============================================================================
# POLAR BEAR SPAWNING
# =============================================================================

## Polar bear scene
var _polar_bear_scene: PackedScene = null

## Mesh node path for scaling polar bear size
const POLAR_BEAR_MESH_PATH := "Sketchfab_Scene/Sketchfab_model/f15cec222ae14ed19735d1a5209e5257_fbx/Object_2/RootNode/Object_4"


func spawn_polar_bears(count: int, island_mask: Image, world_size: float, is_demo: bool) -> Array[Node]:
	## Spawn polar bears on the north coast with randomized stats and size.
	## is_demo: true for 2km map (smaller roam/aggro), false for 10km map.
	## Returns array of spawned bears.

	if not _polar_bear_scene:
		_polar_bear_scene = preload("res://characters/polar_bear/polar_bear.tscn")

	var spawned: Array[Node] = []
	var min_separation: float = 100.0 if is_demo else 200.0
	var positions := _generate_polar_bear_positions(count, island_mask, world_size, min_separation)

	for i in range(positions.size()):
		var bear: Node3D = _polar_bear_scene.instantiate()
		get_tree().current_scene.add_child(bear)
		bear.global_position = positions[i]

		# Randomize roaming distance (scaled by game size)
		if is_demo:
			bear.roam_radius = _rng.randf_range(40.0, 60.0)
		else:
			bear.roam_radius = _rng.randf_range(100.0, 150.0)

		# Randomize aggro multiplier (0.6 = docile, 1.4 = aggressive)
		bear.aggro_multiplier = _rng.randf_range(0.6, 1.4)

		# Randomize investigation persistence (0.4 = gives up quickly, 0.8 = relentless hunter)
		bear.investigation_persistence = _rng.randf_range(0.4, 0.8)

		# Randomize speed (±20% of base 4.0)
		bear.movement_speed = _vary_value(4.0, 0.2)

		# Randomize size (25% small, 50% normal, 25% large)
		var size_scale: float = _get_bear_size_scale()
		_apply_bear_size(bear, size_scale)

		# Random rotation
		bear.rotation.y = _rng.randf() * TAU

		spawned.append(bear)

	print("[CharacterSpawner] Spawned %d polar bears on north coast" % spawned.size())
	return spawned


func _generate_polar_bear_positions(count: int, island_mask: Image, world_size: float, min_separation: float) -> Array[Vector3]:
	## Generate positions on north coast (top 30% of map) with large separation.
	## Bears are solitary, so enforce minimum distance between them.
	var positions: Array[Vector3] = []
	var max_attempts := 200

	if not island_mask:
		push_warning("[CharacterSpawner] No island mask for polar bear spawning")
		return positions

	var img_width := island_mask.get_width()
	var img_height := island_mask.get_height()
	var meters_per_pixel: float = world_size / float(img_width)

	# Search in north region (top 30% of image, avoiding very edge)
	var search_y_min := int(img_height * 0.05)
	var search_y_max := int(img_height * 0.35)
	var search_x_min := int(img_width * 0.05)
	var search_x_max := int(img_width * 0.95)

	for bear_idx in range(count):
		var valid := false
		var attempts := 0
		var world_pos := Vector3.ZERO

		while not valid and attempts < max_attempts:
			attempts += 1

			# Random pixel in north region
			var px := _rng.randi_range(search_x_min, search_x_max)
			var py := _rng.randi_range(search_y_min, search_y_max)

			# Check island mask - want solid land or ice (mask >= 0.2)
			var mask_value: float = island_mask.get_pixel(px, py).r
			if mask_value < 0.2:
				continue

			# Convert pixel to world position (centered at origin)
			var half_size := float(img_width) / 2.0
			var world_x := (float(px) - half_size) * meters_per_pixel
			var world_z := (float(py) - half_size) * meters_per_pixel

			# Get terrain height
			var world_y := _get_terrain_height(Vector3(world_x, 0, world_z))
			world_pos = Vector3(world_x, world_y, world_z)

			# Check separation from existing positions
			valid = true
			for existing_pos in positions:
				if world_pos.distance_to(existing_pos) < min_separation:
					valid = false
					break

		if valid:
			positions.append(world_pos)
		elif attempts >= max_attempts:
			# Couldn't find valid position, skip this bear
			push_warning("[CharacterSpawner] Could not place polar bear %d after %d attempts" % [bear_idx, max_attempts])

	return positions


func _get_bear_size_scale() -> float:
	## Return bear size scale: 25% small (5-6), 50% normal (6.5-7.5), 25% large (7.5-8.5)
	var roll := _rng.randf()
	if roll < 0.25:
		# Small (juvenile/female): 5.0 - 6.0
		return _rng.randf_range(5.0, 6.0)
	elif roll < 0.75:
		# Normal (adult): 6.5 - 7.5
		return _rng.randf_range(6.5, 7.5)
	else:
		# Large (dominant male): 7.5 - 8.5
		return _rng.randf_range(7.5, 8.5)


func _apply_bear_size(bear: Node3D, scale_value: float) -> void:
	## Apply uniform scale to the polar bear mesh node and store for butchering yield.
	# Store the size scale for butchering calculations
	if "size_scale" in bear:
		bear.size_scale = scale_value

	var mesh_node: Node3D = bear.get_node_or_null(POLAR_BEAR_MESH_PATH)
	if mesh_node:
		mesh_node.transform = Transform3D(
			Basis(Vector3(scale_value, 0, 0), Vector3(0, scale_value, 0), Vector3(0, 0, scale_value)),
			mesh_node.transform.origin
		)
	else:
		push_warning("[CharacterSpawner] Could not find polar bear mesh node for scaling")
