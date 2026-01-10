@tool
class_name BTTakeItem extends BTAction
## Takes an item from a container and adds it to unit's inventory.
## Plays "opening_a_lid" animation during the action.

@export var item_category: String = "food"
@export var container_var: StringName = &"target_node"

var _animation_started: bool = false
var _item_taken: bool = false


func _generate_name() -> String:
	return "TakeItem: %s" % item_category


func _enter() -> void:
	_animation_started = false
	_item_taken = false


func _tick(_delta: float) -> Status:
	var unit: Node = blackboard.get_var(&"unit")
	var container: Node = blackboard.get_var(container_var)

	if not unit:
		print("[BTTakeItem] FAIL: no unit in blackboard")
		return FAILURE
	if not container:
		print("[BTTakeItem] FAIL: no container in blackboard var '%s'" % container_var)
		return FAILURE
	if not is_instance_valid(container):
		print("[BTTakeItem] FAIL: container is freed/invalid")
		return FAILURE

	# Start animation if not started
	if not _animation_started:
		if unit.has_node("AnimationPlayer"):
			var anim_player: AnimationPlayer = unit.get_node("AnimationPlayer")
			if anim_player.has_animation("opening_a_lid"):
				anim_player.play("opening_a_lid")
		_animation_started = true
		return RUNNING

	# Check if animation is still playing
	if unit.has_node("AnimationPlayer"):
		var anim_player: AnimationPlayer = unit.get_node("AnimationPlayer")
		if anim_player.is_playing() and anim_player.current_animation == "opening_a_lid":
			return RUNNING

	# Animation done, take the item
	if not _item_taken:
		_item_taken = _transfer_item(container, unit)

	return SUCCESS if _item_taken else FAILURE


func _transfer_item(container: Node, unit: Node) -> bool:
	## Transfer one item matching category from container to unit inventory.
	## Containers use StorageContainer child, units use Inventory child directly.
	var container_inv: Inventory = _get_inventory(container, "container")
	if not container_inv:
		return false

	# Get unit's inventory first
	var unit_inv: Inventory = _get_inventory(unit, "unit")
	if not unit_inv:
		return false

	# Find matching item
	for item in container_inv.get_items():
		var cat: String = item.get_property("category", "misc")
		if cat == item_category:
			# Transfer: remove from container, add to unit
			# Note: gloot Inventory doesn't have transfer(), must remove then add
			if container_inv.remove_item(item):
				if unit_inv.add_item(item):
					print("[BTTakeItem] SUCCESS: transferred item to %s" % unit.name)
					return true
				else:
					# Failed to add to unit - put it back in container
					container_inv.add_item(item)
					print("[BTTakeItem] FAIL: couldn't add item to unit inventory")
			else:
				print("[BTTakeItem] FAIL: couldn't remove item from container")

	return false


func _get_inventory(node: Node, node_type: String) -> Inventory:
	## Get inventory from a node. Tries multiple patterns:
	## 1. Direct "inventory" property (ClickableUnit)
	## 2. "Inventory" child node that IS an Inventory
	## 3. "StorageContainer" child with "inventory" property (containers)

	# Pattern 1: Direct inventory property (ClickableUnit has this)
	if "inventory" in node and node.inventory is Inventory:
		return node.inventory

	# Pattern 2: "Inventory" child node
	var inv_child: Node = node.get_node_or_null("Inventory")
	if inv_child and inv_child is Inventory:
		return inv_child

	# Pattern 3: StorageContainer child (gloot containers)
	var storage: Node = node.get_node_or_null("StorageContainer")
	if storage and "inventory" in storage:
		var inv: Inventory = storage.inventory
		if inv:
			return inv

	return null
