@tool
extends BTAction
class_name BTDepositMaterials
## Deposits carried materials at workbench or construction site.
## Returns RUNNING while moving, SUCCESS when deposited.

## Blackboard variable for target position.
@export var target_position_var: StringName = &"target_position"
## Blackboard variable for deposit target.
@export var work_target_var: StringName = &"work_target"
## Blackboard variable for carried materials.
@export var carried_materials_var: StringName = &"carried_materials"
## Distance to consider "arrived" at target.
@export var arrival_distance: float = 3.0

var _moving: bool = false
var _depositing: bool = false


func _generate_name() -> String:
	return "DepositMaterials"


func _enter() -> void:
	_moving = false
	_depositing = false


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Get carried materials
	var carried: Dictionary = blackboard.get_var(carried_materials_var, {})
	if carried.is_empty():
		# Nothing to deposit
		return SUCCESS

	# Find deposit target - prefer workbench, fallback to construction site
	var target: Node3D = _find_deposit_target(agent)
	if not target:
		return FAILURE

	var agent_pos: Vector3 = agent.global_position
	var target_pos: Vector3 = target.global_position
	var dist: float = agent_pos.distance_to(target_pos)

	# Phase 1: Move to target
	if dist > arrival_distance:
		if not _moving:
			agent.move_to(target_pos)
			_moving = true
			blackboard.set_var(&"current_action", "Hauling materials")
		return RUNNING

	# Phase 2: Stop and deposit
	if not _depositing:
		agent.stop()
		_depositing = true

	# Deposit materials
	var deposited_any: bool = false
	var workbench_comp: WorkbenchComponent = _find_workbench_component(target)

	if workbench_comp:
		# Deposit to workbench
		for mat_id: String in carried:
			var amount: int = carried[mat_id]
			workbench_comp.deposit_material(mat_id, amount)
			print("[BTDepositMaterials] Deposited %d %s to workbench" % [amount, mat_id])
			deposited_any = true
	elif target.has_method("deposit_material"):
		# Deposit to construction site
		for mat_id: String in carried:
			var amount: int = carried[mat_id]
			var accepted: int = target.deposit_material(mat_id, amount)
			if accepted > 0:
				print("[BTDepositMaterials] Deposited %d %s to site" % [accepted, mat_id])
				deposited_any = true

	# Clear carried materials
	blackboard.set_var(carried_materials_var, {})
	blackboard.set_var(&"current_action", "Idle")

	return SUCCESS if deposited_any else FAILURE


func _find_deposit_target(agent: Node) -> Node3D:
	## Find the nearest workbench or construction site to deposit materials.
	var agent_pos: Vector3 = agent.global_position
	var nearest: Node3D = null
	var nearest_dist: float = INF

	# Check workbenches first (prefer depositing to workbench)
	var workbenches: Array = agent.get_tree().get_nodes_in_group("workbenches")
	for wb in workbenches:
		if not wb is Node3D:
			continue
		var dist: float = agent_pos.distance_to(wb.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = wb

	# Only check construction sites if no workbench nearby
	if nearest_dist > 50.0:
		var sites: Array = agent.get_tree().get_nodes_in_group("construction_sites")
		for site in sites:
			if not site is Node3D:
				continue
			# Only deposit to sites that need materials
			if site.has_method("get_materials_needed"):
				if site.get_materials_needed().is_empty():
					continue
			var dist: float = agent_pos.distance_to(site.global_position)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest = site

	return nearest


func _find_workbench_component(target: Node) -> WorkbenchComponent:
	## Find WorkbenchComponent on target.
	for child in target.get_children():
		if child is WorkbenchComponent:
			return child as WorkbenchComponent
	return null
