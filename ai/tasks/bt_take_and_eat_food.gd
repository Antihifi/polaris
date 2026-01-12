@tool
extends BTAction
class_name BTTakeAndEatFood
## Takes food from a container and eats it.

@export var container_var: StringName = &"target_node"

func _generate_name() -> String:
	return "TakeAndEatFood"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	var container: Node3D = blackboard.get_var(container_var, null)

	if not agent or not container:
		return FAILURE

	# Find StorageContainer
	var storage: Node = container.find_child("StorageContainer", true, false)
	if not storage:
		return FAILURE

	# Take food from container
	if storage.has_method("take_food_item"):
		var food = storage.take_food_item()
		if food and agent.has_method("eat_food_item"):
			# Add to inventory then eat
			if "inventory" in agent and agent.inventory:
				agent.inventory.add_item(food)
			agent.eat_food_item(food)
			return SUCCESS

	return FAILURE
