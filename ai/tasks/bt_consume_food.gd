@tool
extends BTAction
class_name BTConsumeFood
## Eat food from personal inventory OR from nearby container.
## Priority: 1) Personal inventory, 2) Nearby container (if within proximity)
##
## This allows units to eat food they're carrying anywhere, but requires
## proximity to eat from shared food containers.

@export var container_proximity: float = 3.0  ## Max distance to take food from container

func _generate_name() -> String:
	return "ConsumeFood (proximity: %.1fm)" % container_proximity


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# PRIORITY 1: Check personal inventory for food
	if agent.has_method("get_food_from_inventory") and agent.has_method("eat_food_item"):
		var personal_food: InventoryItem = agent.get_food_from_inventory()
		if personal_food:
			agent.eat_food_item(personal_food)
			blackboard.set_var(&"current_action", "Eating (from pack)")
			print("[BTConsumeFood] %s ate from personal inventory" % [agent.unit_name if "unit_name" in agent else "unit"])
			return SUCCESS

	# PRIORITY 2: Take from nearby container (requires proximity)
	var container_node: Node3D = blackboard.get_var(&"target_node", null)
	if not container_node:
		blackboard.set_var(&"current_action", "No food source")
		return FAILURE

	# Proximity check - must be near container to take from it
	var dist: float = agent.global_position.distance_to(container_node.global_position)
	if dist > container_proximity:
		print("[BTConsumeFood] %s too far from container (%.1fm > %.1fm)" % [
			agent.unit_name if "unit_name" in agent else "unit", dist, container_proximity])
		blackboard.set_var(&"current_action", "Too far from food")
		return FAILURE

	# Get StorageContainer child
	var storage: Node = container_node.find_child("StorageContainer", false, false)
	if not storage:
		storage = container_node.get_node_or_null("StorageContainer")
	if not storage or not storage.has_method("has_food"):
		return FAILURE

	# Check if container has food
	if not storage.has_food():
		blackboard.set_var(&"current_action", "Container empty")
		return FAILURE

	# Take food item from container
	var food: InventoryItem = storage.take_food_item()
	if not food:
		return FAILURE

	# Eat the food
	if agent.has_method("eat_food_item"):
		agent.eat_food_item(food)
		blackboard.set_var(&"current_action", "Eating")
		print("[BTConsumeFood] %s took and ate from container" % [agent.unit_name if "unit_name" in agent else "unit"])
		return SUCCESS

	# Fallback: directly apply nutrition if method doesn't exist
	if "stats" in agent and agent.stats:
		var nutrition: float = food.get_property("nutritional_value", 10.0)
		agent.stats.hunger = minf(agent.stats.hunger + nutrition, 100.0)
		blackboard.set_var(&"current_action", "Eating")
		return SUCCESS

	return FAILURE
