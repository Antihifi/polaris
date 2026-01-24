@tool
extends BTAction
class_name BTDepositMaterials
## Deposits carried materials at current location (workbench or construction site).
## ASSUMES agent is already at the target (use BTMoveToBlackboard first).
## Returns SUCCESS after depositing, FAILURE if nothing to deposit.

## Blackboard variable for target node.
@export var target_node_var: StringName = &"target_node"


func _generate_name() -> String:
	return "DepositMaterials"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Check if carrying anything.
	if agent.has_method("is_carrying") and not agent.is_carrying():
		return SUCCESS  # Nothing to deposit is OK

	# Get carried materials.
	var carried: Dictionary = {}
	if agent.has_method("stop_carrying"):
		carried = agent.stop_carrying()

	if carried.is_empty():
		return SUCCESS

	var mat_id: String = carried.get("material_id", "")
	var amount: int = carried.get("amount", 0)

	if mat_id == "" or amount <= 0:
		return SUCCESS

	# Find deposit target from blackboard.
	var target: Node = blackboard.get_var(target_node_var, null)
	if not target:
		# Try to find nearest workbench as fallback.
		target = _find_nearest_workbench(agent)

	if not target:
		return FAILURE

	# Deposit to workbench or construction site.
	var deposited: bool = false

	var wb_comp: WorkbenchComponent = _find_workbench_component(target)
	if wb_comp:
		wb_comp.deposit_material(mat_id, amount)
		deposited = true
	elif target.has_method("deposit_material"):
		target.deposit_material(mat_id, amount)
		deposited = true

	if deposited:
		blackboard.set_var(&"current_action", "Deposited " + mat_id)
		return SUCCESS

	return FAILURE


func _find_nearest_workbench(agent: Node3D) -> Node3D:
	## Find nearest workbench.
	var nearest: Node3D = null
	var nearest_dist: float = INF
	for wb in agent.get_tree().get_nodes_in_group("workbenches"):
		if not wb is Node3D:
			continue
		var dist: float = agent.global_position.distance_to(wb.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = wb
	return nearest


func _find_workbench_component(target: Node) -> WorkbenchComponent:
	## Find WorkbenchComponent on target.
	for child in target.get_children():
		if child is WorkbenchComponent:
			return child as WorkbenchComponent
	return null
