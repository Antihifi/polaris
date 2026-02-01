@tool
extends BTAction
class_name BTEatFromInventory
## Consume food from personal inventory. Pure data operation.
## Animation should be handled by BTPlayAnimation nodes in the behavior tree.
## Returns SUCCESS if food was consumed, FAILURE if no food or unable to eat.


func _generate_name() -> String:
	return "EatFromInventory"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	if not agent.has_method("get_food_from_inventory"):
		return FAILURE

	var food_item: InventoryItem = agent.get_food_from_inventory()
	if not food_item:
		return FAILURE

	if not agent.has_method("eat_food_item"):
		return FAILURE

	agent.eat_food_item(food_item)

	var unit_name: String = agent.unit_name if "unit_name" in agent else "unit"
	print("[BTEatFromInventory] %s consumed food" % unit_name)
	return SUCCESS
