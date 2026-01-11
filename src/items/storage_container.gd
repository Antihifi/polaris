class_name StorageContainer extends Node
## Adds inventory functionality to a storage object (barrel, crate, etc.).
## Attach as child of the 3D object or add via script.
## Uses composition: this Node wraps the parent 3D scene.
## Automatically creates a click Area3D for reliable click detection.

signal inventory_opened(container: StorageContainer)
signal inventory_closed(container: StorageContainer)
signal contents_changed

enum StorageType {
	FOOD,      ## Barrels: food and beverages only
	GENERAL    ## Crates: wood, tools, fuel
}

@export var display_name: String = "Storage Container"
@export var storage_type: StorageType = StorageType.GENERAL
@export var grid_width: int = 6
@export var grid_height: int = 4

## Click detection collision layer (layer 4 = containers)
const CONTAINER_COLLISION_LAYER: int = 8  # Layer 4 (1 << 3)

## Allowed item categories based on storage type
const FOOD_CATEGORIES: Array[String] = ["food"]
const GENERAL_CATEGORIES: Array[String] = ["fuel", "tool", "misc"]

var inventory: Inventory = null
var grid_constraint: GridConstraint = null
var is_open: bool = false
var click_area: Area3D = null
var _protoset: JSON = null


func _ready() -> void:
	# Add parent to groups (the 3D object)
	var parent := get_parent()
	if parent:
		parent.add_to_group("containers")
		parent.add_to_group("interactable")

	# Load protoset
	_protoset = load("res://data/items_protoset.json")

	# Create inventory programmatically
	_setup_inventory()

	# Create click detection area
	_setup_click_area()


func _setup_inventory() -> void:
	## Create Inventory with GridConstraint as children.
	inventory = Inventory.new()
	inventory.name = "Inventory"
	inventory.protoset = _protoset
	add_child(inventory)

	grid_constraint = GridConstraint.new()
	grid_constraint.name = "GridConstraint"
	grid_constraint.size = Vector2i(grid_width, grid_height)
	inventory.add_child(grid_constraint)

	# Connect signals
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)

	print("[StorageContainer] %s inventory ready, protoset: %s, grid: %dx%d" % [
		display_name, _protoset != null, grid_width, grid_height
	])


func _setup_click_area() -> void:
	## Create an Area3D for reliable click detection.
	var parent := get_parent()
	if not parent or not parent is Node3D:
		return

	click_area = Area3D.new()
	click_area.name = "ClickArea"
	click_area.collision_layer = CONTAINER_COLLISION_LAYER
	click_area.collision_mask = 0  # Don't detect anything, just be detected
	click_area.monitorable = true
	click_area.monitoring = false

	# Create a box collision shape based on parent's mesh bounds
	var collision := CollisionShape3D.new()
	collision.name = "ClickCollision"

	var box := BoxShape3D.new()
	# Estimate size based on storage type
	if storage_type == StorageType.FOOD:
		box.size = Vector3(0.8, 1.2, 0.8)  # Barrel shape
	else:
		box.size = Vector3(1.0, 0.8, 1.0)  # Crate shape

	collision.shape = box
	collision.position = Vector3(0, box.size.y * 0.5, 0)  # Center at bottom

	click_area.add_child(collision)
	# Use call_deferred to avoid "busy setting up children" error during _ready()
	parent.call_deferred("add_child", click_area)


func can_accept_item(item: InventoryItem) -> bool:
	## Check if this container can accept the given item based on storage_type.
	var category: String = item.get_property("category", "misc")

	match storage_type:
		StorageType.FOOD:
			return category in FOOD_CATEGORIES
		StorageType.GENERAL:
			return category in GENERAL_CATEGORIES

	return false


func add_item_by_id(prototype_id: String) -> InventoryItem:
	## Create and add an item by prototype ID.
	if not inventory:
		print("[StorageContainer] add_item_by_id FAILED - no inventory!")
		return null
	if not inventory.protoset:
		print("[StorageContainer] add_item_by_id FAILED - no protoset!")
		return null
	var item: InventoryItem = inventory.create_and_add_item(prototype_id)
	if not item:
		print("[StorageContainer] create_and_add_item returned null for: %s" % prototype_id)
	return item


func open() -> void:
	## Open this container (triggers UI to show).
	is_open = true
	inventory_opened.emit(self)


func close() -> void:
	## Close this container.
	is_open = false
	inventory_closed.emit(self)


func get_items_of_category(category: String) -> Array[InventoryItem]:
	## Get all items matching a category.
	var result: Array[InventoryItem] = []
	if not inventory:
		return result
	for item in inventory.get_items():
		if item.get_property("category", "misc") == category:
			result.append(item)
	return result


func has_food() -> bool:
	## Check if container has any food items.
	return not get_items_of_category("food").is_empty()


func get_first_food_item() -> InventoryItem:
	## Get the first food item (for taking).
	var food_items := get_items_of_category("food")
	return food_items[0] if not food_items.is_empty() else null


func take_food_item() -> InventoryItem:
	## Remove and return first food item.
	var food := get_first_food_item()
	if food and inventory:
		inventory.remove_item(food)
		return food
	return null


func get_item_count() -> int:
	## Get total number of items.
	return inventory.get_items().size() if inventory else 0


func _on_item_added(_item: InventoryItem) -> void:
	contents_changed.emit()


func _on_item_removed(_item: InventoryItem) -> void:
	contents_changed.emit()
