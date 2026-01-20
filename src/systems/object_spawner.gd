class_name ObjectSpawner extends Node
## Spawns storage containers (barrels, crates) and the ship around a center point.
## Follows CharacterSpawner pattern. Adds StorageContainer component via composition.

signal containers_spawned(count: int)
signal ship_spawned(ship: Node3D)

## Scenes to instantiate
var barrel_scene: PackedScene
var crate_scene: PackedScene
var ship_scene: PackedScene
var fire_scene: PackedScene

## Spawned ship reference
var spawned_ship: Node3D = null

## Spawn configuration
@export var spawn_radius: float = 15.0
@export var min_separation: float = 3.0

## Item pools for random population
const BARREL_ITEMS: Array[String] = ["hardtack", "salt_pork", "pemmican", "tinned_meat", "rum"]
const CRATE_ITEMS: Array[String] = ["firewood", "coal", "knife", "hatchet"]

var _spawned_containers: Array[Node] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _terrain_cache: Node = null


func _ready() -> void:
	_rng.randomize()
	barrel_scene = preload("res://objects/storage_barrel.tscn")
	crate_scene = preload("res://objects/storage_crate_small.tscn")
	ship_scene = preload("res://objects/ship1/ship_1.tscn")
	fire_scene = preload("res://objects/campfire_1.tscn")


func spawn_containers(barrel_count: int, crate_count: int, fire_count: int, center: Vector3) -> Array[Node]:
	## Spawn barrels and crates around a center point.
	var total := barrel_count + crate_count + fire_count
	var positions := _generate_spawn_positions(total, center)
	var spawned: Array[Node] = []
	var pos_idx := 0

	# Spawn barrels first
	for i in range(barrel_count):
		var container := _spawn_container(barrel_scene, positions[pos_idx], true)
		if container:
			spawned.append(container)
			_spawned_containers.append(container)
		pos_idx += 1

	# Then crates
	for i in range(crate_count):
		var container := _spawn_container(crate_scene, positions[pos_idx], false)
		if container:
			spawned.append(container)
			_spawned_containers.append(container)
		pos_idx += 1
		
	# Then fires
	for i in range(fire_count):
		var container := _spawn_container(fire_scene, positions[pos_idx], false)
		if container:
			spawned.append(container)
			_spawned_containers.append(container)
		pos_idx += 1

	containers_spawned.emit(spawned.size())
	print("[ObjectSpawner] Spawned %d containers (%d barrels, %d crates)" % [
		spawned.size(), barrel_count, crate_count
	])
	return spawned


func _spawn_container(scene: PackedScene, position: Vector3, is_barrel: bool) -> Node:
	## Instantiate container scene and add StorageContainer component.
	var obj: Node3D = scene.instantiate()
	get_tree().current_scene.add_child(obj)
	obj.global_position = position
	obj.rotation.y = _rng.randf() * TAU

	# Add StorageContainer component (composition)
	var storage := StorageContainer.new()
	storage.name = "StorageContainer"
	if is_barrel:
		storage.display_name = "Barrel"
		storage.storage_type = StorageContainer.StorageType.FOOD
		storage.grid_width = 4
		storage.grid_height = 8
	else:
		storage.display_name = "Crate"
		storage.storage_type = StorageContainer.StorageType.GENERAL
		storage.grid_width = 4
		storage.grid_height = 4
	obj.add_child(storage)

	# Populate with random items - use call_deferred since inventory is set up in _ready()
	call_deferred("_populate_container", storage, is_barrel)

	return obj


func _populate_container(storage: StorageContainer, is_barrel: bool) -> void:
	## Add random items to a container.
	var item_pool: Array[String] = BARREL_ITEMS if is_barrel else CRATE_ITEMS
	var item_count := _rng.randi_range(6, 15)  # Tripled from 2-5

	print("[ObjectSpawner] Populating %s with %d items" % [storage.display_name, item_count])

	for i in range(item_count):
		var item_id: String = item_pool[_rng.randi() % item_pool.size()]
		var item: InventoryItem = storage.add_item_by_id(item_id)
		if item:
			print("[ObjectSpawner] Added %s to %s" % [item_id, storage.display_name])
		else:
			print("[ObjectSpawner] FAILED to add %s to %s" % [item_id, storage.display_name])


func _generate_spawn_positions(count: int, center: Vector3) -> Array[Vector3]:
	## Generate spread-out positions avoiding overlap.
	## Containers are static objects so we use terrain height directly.
	## Unlike characters, containers don't have gravity/collision to settle onto terrain.
	var positions: Array[Vector3] = []
	var max_attempts := 100

	for i in range(count):
		var pos := Vector3.ZERO
		var valid := false
		var attempts := 0

		while not valid and attempts < max_attempts:
			attempts += 1
			var angle := _rng.randf() * TAU
			var radius := sqrt(_rng.randf()) * spawn_radius
			pos = center + Vector3(cos(angle) * radius, 0, sin(angle) * radius)

			valid = true
			for existing in positions:
				if pos.distance_to(existing) < min_separation:
					valid = false
					break

		# Use terrain height for static objects (they can't fall with physics)
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


func spawn_campfire(position: Vector3, dim: bool = false) -> Node3D:
	## Spawn a campfire at the given position.
	## If dim=true, reduces warmth radius and light energy (for errant camps).
	var fire: Node3D = fire_scene.instantiate()
	get_tree().current_scene.add_child(fire)

	# Position on terrain
	var fire_height := _get_terrain_height(position)
	fire.global_position = Vector3(position.x, fire_height, position.z)

	if dim:
		# Reduce warmth radius (WarmthArea has warmth_radius=10 by default)
		var warmth_area: Node = fire.find_child("WarmthArea", true, false)
		if warmth_area and warmth_area.has_method("set_radius"):
			warmth_area.set_radius(5.0)  # Half normal radius
			print("[ObjectSpawner] Set dim fire warmth radius to 5m")

		# Reduce light energy if fire has a light
		for child in fire.get_children():
			if child is OmniLight3D:
				child.light_energy *= 0.5
				print("[ObjectSpawner] Reduced fire light energy by 50%%")
				break

	print("[ObjectSpawner] Spawned %s campfire at %s" % ["dim" if dim else "normal", fire.global_position])
	return fire


func spawn_ship(position: Vector3, rotation_y: float = 0.0) -> Node3D:
	## Spawn the ship at the given position.
	## Used for procedurally generated terrain where ship isn't pre-placed.
	if spawned_ship and is_instance_valid(spawned_ship):
		print("[ObjectSpawner] Ship already spawned, skipping")
		return spawned_ship

	spawned_ship = ship_scene.instantiate()
	get_tree().current_scene.add_child(spawned_ship)

	# Position ship - spawn slightly high and let it settle if needed
	# Ship is static so we query terrain height directly
	var ship_height := _get_terrain_height(position)
	spawned_ship.global_position = Vector3(position.x, ship_height, position.z)
	spawned_ship.rotation.y = rotation_y

	print("[ObjectSpawner] Spawned ship at %s" % spawned_ship.global_position)
	ship_spawned.emit(spawned_ship)
	return spawned_ship


func get_ship() -> Node3D:
	## Get the spawned ship, or find existing ship in scene.
	if spawned_ship and is_instance_valid(spawned_ship):
		return spawned_ship

	# Check if ship already exists in scene (from pre-made terrain)
	var existing_ships := get_tree().get_nodes_in_group("ship")
	if existing_ships.size() > 0:
		return existing_ships[0] as Node3D

	# Search by name as fallback
	var scene := get_tree().current_scene
	var ship := scene.find_child("Ship1", true, false)
	if ship:
		return ship as Node3D

	return null


func get_all_containers() -> Array[Node]:
	## Returns all containers spawned by this spawner.
	var valid: Array[Node] = []
	for c in _spawned_containers:
		if is_instance_valid(c):
			valid.append(c)
	_spawned_containers = valid
	return valid


func get_food_containers() -> Array[Node]:
	## Get all barrel (food) containers.
	var result: Array[Node] = []
	for c in get_all_containers():
		var storage: StorageContainer = c.get_node_or_null("StorageContainer")
		if storage and storage.storage_type == StorageContainer.StorageType.FOOD:
			result.append(c)
	return result
