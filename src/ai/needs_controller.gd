class_name NeedsController extends Node
## Handles autonomous food-seeking behavior for a ClickableUnit.
## Attach as a child of ClickableUnit - uses composition pattern.
## Small, focused script (~80 lines) - does ONE thing: manage hunger needs.

signal seeking_food(container: Node)
signal eating_food(item_name: String)

## Start seeking food when hunger drops below this
@export var hunger_seek_threshold: float = 50.0
## Eat from personal stash when below this (critical)
@export var hunger_eat_threshold: float = 35.0
## Seconds between need checks
@export var check_interval: float = 5.0

var _unit: ClickableUnit = null
var _check_timer: float = 0.0
var _seeking_container: Node = null
var _arrived_at_container: bool = false


func _ready() -> void:
	_unit = get_parent() as ClickableUnit
	if not _unit:
		push_error("[NeedsController] Must be child of ClickableUnit")
		return
	_unit.reached_destination.connect(_on_unit_reached_destination)


func _process(delta: float) -> void:
	if not _unit or not _unit.stats:
		return

	_check_timer += delta
	if _check_timer < check_interval:
		return
	_check_timer = 0.0

	_check_hunger_needs()


func _check_hunger_needs() -> void:
	## Evaluate hunger and take action if needed.
	var hunger: float = _unit.stats.hunger

	# Critical: eat from personal stash immediately
	if hunger <= hunger_eat_threshold:
		if _try_eat_personal_food():
			return

	# Low: seek food from containers
	if hunger <= hunger_seek_threshold and not _unit.is_moving:
		if not _unit.has_food_in_inventory():
			_seek_food_container()


func _try_eat_personal_food() -> bool:
	## Try to eat food from personal inventory. Returns true if ate.
	var food: InventoryItem = _unit.get_food_from_inventory()
	if food:
		var item_name: String = food.get_property("name", "food")
		_unit.eat_food_item(food)
		eating_food.emit(item_name)
		return true
	return false


func _seek_food_container() -> void:
	## Find and move to nearest food container.
	var containers := get_tree().get_nodes_in_group("containers")
	var nearest: Node = null
	var nearest_dist: float = INF

	for container in containers:
		var storage: StorageContainer = container.get_node_or_null("StorageContainer")
		if not storage or not storage.has_food():
			continue

		var dist: float = _unit.global_position.distance_to(container.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = container

	if nearest:
		_seeking_container = nearest
		_arrived_at_container = false
		_unit.move_to(nearest.global_position)
		seeking_food.emit(nearest)


func _on_unit_reached_destination() -> void:
	## Called when unit arrives at destination.
	if not _seeking_container:
		return

	_arrived_at_container = true
	_take_food_from_container()
	_seeking_container = null


func _take_food_from_container() -> void:
	## Take one food item from the container we arrived at.
	if not _seeking_container:
		return

	var storage: StorageContainer = _seeking_container.get_node_or_null("StorageContainer")
	if not storage:
		return

	var food: InventoryItem = storage.take_food_item()
	if food and _unit.inventory:
		_unit.inventory.add_item(food)
		print("[NeedsController] %s took %s from container" % [
			_unit.unit_name, food.get_property("name", "food")
		])
