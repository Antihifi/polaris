@tool
extends BTAction
class_name BTGatherFrom
## Gathers materials from a source (ship or workbench) and starts carrying.
## ASSUMES agent is already at the source (use BTMoveToBlackboard first).

@export_enum("ship", "workbench") var source_type: String = "ship"
## Fallback material_id (ship mode). Blackboard &"material_id" overrides this.
@export var material_id: String = "scrap_wood"
## Time to spend gathering (seconds). Only applies to ship mode.
@export var gather_time: float = 2.0
## Blackboard var for construction site (workbench mode). Used to determine what to withdraw.
@export var site_var: StringName = &"site_node"
## After withdrawing (workbench mode), retarget these blackboard vars to the site.
@export var retarget_node_var: StringName = &"target_node"
@export var retarget_position_var: StringName = &"target_position"

var _gather_timer: float = 0.0
var _started: bool = false


func _generate_name() -> String:
	return "Gather [%s]" % source_type


func _enter() -> void:
	_gather_timer = 0.0
	_started = false


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	match source_type:
		"ship":
			return _gather_from_ship(agent, delta)
		"workbench":
			return _withdraw_from_workbench(agent)
	return FAILURE


func _gather_from_ship(agent: Node3D, delta: float) -> Status:
	# Don't gather if already carrying (prevents material loss on interrupted sequences).
	if agent.has_method("is_carrying") and agent.is_carrying():
		return FAILURE

	var ship_resource: ShipResourceComponent = null
	for node in agent.get_tree().get_nodes_in_group("ship_resources"):
		if node is ShipResourceComponent:
			ship_resource = node
			break
	if not ship_resource:
		return FAILURE

	if not _started:
		if agent.has_method("stop"):
			agent.stop()
		_started = true
		blackboard.set_var(&"current_action", "Gathering")

	_gather_timer += delta
	if _gather_timer < gather_time:
		return RUNNING

	var efficiency: float = _get_gather_efficiency(agent)
	var mat_id: String = blackboard.get_var(&"material_id", material_id)
	var gathered: Dictionary = ship_resource.gather_material(mat_id, 1, efficiency)

	if gathered.is_empty() or gathered.get("amount", 0) <= 0:
		blackboard.set_var(&"current_action", "Ship exhausted")
		return FAILURE

	var amount: int = gathered.get("amount", 0)
	if agent.has_method("start_carrying"):
		agent.start_carrying(mat_id, amount)
	blackboard.set_var(&"current_action", "Carrying " + mat_id)
	return SUCCESS


func _withdraw_from_workbench(agent: Node3D) -> Status:
	var workbench_ref: Variant = blackboard.get_var(retarget_node_var, null)
	if not is_instance_valid(workbench_ref):
		return FAILURE
	var workbench: Node = workbench_ref as Node
	# Get as Variant first to avoid error on freed instance assignment.
	var site_ref: Variant = blackboard.get_var(site_var, null)
	if not is_instance_valid(site_ref):
		return FAILURE
	var site: Node = site_ref as Node

	# Already carrying from a previous interrupted delivery — skip withdrawal, just retarget.
	if agent.has_method("is_carrying") and agent.is_carrying():
		blackboard.set_var(retarget_node_var, site)
		blackboard.set_var(retarget_position_var, site.global_position)
		blackboard.set_var(&"is_delivering", true)
		return SUCCESS

	if not site.has_method("get_materials_needed"):
		return FAILURE
	var needed: Dictionary = site.get_materials_needed()
	if needed.is_empty():
		return FAILURE

	var wb_comp: WorkbenchComponent = null
	for child in workbench.get_children():
		if child is WorkbenchComponent:
			wb_comp = child as WorkbenchComponent
			break
	if not wb_comp:
		return FAILURE

	for mat_id: String in needed:
		var withdrawn: int = wb_comp.withdraw_material(mat_id, 1)
		if withdrawn > 0:
			if agent.has_method("start_carrying"):
				agent.start_carrying(mat_id, withdrawn)
			blackboard.set_var(retarget_node_var, site)
			blackboard.set_var(retarget_position_var, site.global_position)
			blackboard.set_var(&"is_delivering", true)
			blackboard.set_var(&"current_action", "Hauling " + mat_id)
			return SUCCESS

	# Nothing available at workbench — unregister so another unit can try later.
	if site.has_method("unregister_deliverer"):
		site.unregister_deliverer(agent)
	return FAILURE


func _get_gather_efficiency(agent: Node) -> float:
	var efficiency: float = 1.0
	if "stats" in agent and agent.stats:
		if agent.stats.has_method("has_trait"):
			if agent.stats.has_trait("resourceful"):
				efficiency *= 1.25
	return efficiency
