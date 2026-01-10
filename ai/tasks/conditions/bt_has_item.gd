@tool
class_name BTHasItem extends BTCondition
## Checks if unit has item of specified category in inventory.

@export var item_category: String = "food"


func _generate_name() -> String:
	return "HasItem: %s" % item_category


func _tick(_delta: float) -> Status:
	var unit: ClickableUnit = blackboard.get_var(&"unit")
	if not unit or not unit.inventory:
		return FAILURE

	for item in unit.inventory.get_items():
		if item.get_property("category", "misc") == item_category:
			return SUCCESS

	return FAILURE
