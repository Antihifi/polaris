@tool
extends BTCondition
class_name BTCheckCanGather
## Returns SUCCESS if there's a ship with resources to gather, FAILURE otherwise.


func _generate_name() -> String:
	return "CanGather?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Don't gather if already carrying - should haul to workbench instead.
	if agent.has_method("is_carrying") and agent.is_carrying():
		return FAILURE

	# Check if any ship has resources.
	for ship in agent.get_tree().get_nodes_in_group("ship_resources"):
		if ship.has_method("has_resources") and ship.has_resources():
			return SUCCESS
		# Also check ShipResourceComponent children.
		for child in ship.get_children():
			if child is ShipResourceComponent:
				if child.has_method("has_resources") and child.has_resources():
					return SUCCESS

	return FAILURE
