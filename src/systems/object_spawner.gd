class_name ObjectSpawner extends Node
## Spawns storage containers (barrels, crates) around a center point.
## Follows CharacterSpawner pattern. Adds StorageContainer component via composition.

signal containers_spawned(count: int)

## Scenes to instantiate
var barrel_scene: PackedScene
var crate_scene: PackedScene

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


func spawn_containers(barrel_count: int, crate_count: int, center: Vector3) -> Array[Node]:
	## Spawn barrels and crates around a center point.
	var total := barrel_count + crate_count
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
	var item_count := _rng.randi_range(2, 5)

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
