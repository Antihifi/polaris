@tool
extends BTAction
class_name BTDie
## Handle death: play dying animation, spawn human meat, disable AI.
## Body remains selectable for looting until inventory is empty.

@export var meat_count: int = 5

var _death_processed: bool = false

func _generate_name() -> String:
	return "Die (spawn %d meat)" % meat_count


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Only process death once
	if _death_processed:
		return SUCCESS

	_death_processed = true

	# Play dying animation
	if agent.has_method("_play_animation"):
		agent._play_animation("dying")

	# Stop all movement and footsteps
	if agent.has_method("stop"):
		agent.stop()

	# Spawn human meat in inventory
	if "inventory" in agent and agent.inventory:
		var protoset: JSON = load("res://data/items_protoset.json")
		for i in meat_count:
			var meat := InventoryItem.new()
			meat.protoset = protoset
			meat.prototype_id = "human_meat"
			agent.inventory.add_item(meat)
		print("[BTDie] Spawned %d human_meat in %s inventory" % [meat_count, agent.unit_name if "unit_name" in agent else "unit"])

	# Stop physics processing (no more movement)
	agent.set_physics_process(false)
	if "is_moving" in agent:
		agent.is_moving = false

	# Remove from survivors group (no more stat updates)
	agent.remove_from_group("survivors")

	# Keep in selectable_units so body can be clicked/looted
	# Don't remove from selectable_units

	# Update action display
	blackboard.set_var(&"current_action", "Dead")

	# Connect to inventory to despawn when empty
	if "inventory" in agent and agent.inventory:
		if not agent.inventory.item_removed.is_connected(_on_inventory_item_removed.bind(agent)):
			agent.inventory.item_removed.connect(_on_inventory_item_removed.bind(agent))

	return SUCCESS


func _on_inventory_item_removed(_item: InventoryItem, agent: Node3D) -> void:
	## When inventory is emptied, despawn the body.
	if not is_instance_valid(agent):
		return
	if "inventory" in agent and agent.inventory:
		if agent.inventory.get_items().is_empty():
			print("[BTDie] %s body looted and despawning" % [agent.unit_name if "unit_name" in agent else "unit"])
			agent.queue_free()
