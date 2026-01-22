@tool
extends BTAction
class_name BTFindWork
## Finds available work via proximity to workbenches or construction sites.
## Sets work_type and work_target in blackboard.

## Discovery radius for finding work.
@export var discovery_radius: float = 30.0
## Blackboard variable for work type.
@export var work_type_var: StringName = &"work_type"
## Blackboard variable for work target.
@export var work_target_var: StringName = &"work_target"
## Blackboard variable for target position.
@export var target_position_var: StringName = &"target_position"


func _generate_name() -> String:
	return "FindWork [radius: %.0fm]" % discovery_radius


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# If already assigned work and moving, don't interrupt
	var existing_type: String = blackboard.get_var(work_type_var, "")
	if existing_type != "" and "is_moving" in agent and agent.is_moving:
		return SUCCESS

	var agent_pos: Vector3 = agent.global_position

	# Priority 1: Find construction sites needing workers
	var construction_job: Dictionary = _find_construction_work(agent, agent_pos)
	if not construction_job.is_empty():
		_set_work_assignment(construction_job)
		return SUCCESS

	# Priority 2: Find gathering work if sites need materials
	var gathering_job: Dictionary = _find_gathering_work(agent, agent_pos)
	if not gathering_job.is_empty():
		_set_work_assignment(gathering_job)
		return SUCCESS

	# Priority 3: Find hauling work
	var hauling_job: Dictionary = _find_hauling_work(agent, agent_pos)
	if not hauling_job.is_empty():
		_set_work_assignment(hauling_job)
		return SUCCESS

	# No work found
	blackboard.set_var(work_type_var, "")
	blackboard.set_var(work_target_var, null)
	return FAILURE


func _find_construction_work(agent: Node3D, agent_pos: Vector3) -> Dictionary:
	## Find construction sites that need workers.
	var work_manager := _get_work_manager(agent)
	var sites: Array = agent.get_tree().get_nodes_in_group("construction_sites")

	for site in sites:
		if not site is Node3D:
			continue

		var dist: float = agent_pos.distance_to(site.global_position)
		if dist > discovery_radius:
			continue

		# Check if site can accept workers and has materials
		if site.has_method("can_accept_worker") and site.can_accept_worker():
			if site.has_method("has_all_required_materials") and site.has_all_required_materials():
				# Check worker limit via WorkManager
				if work_manager:
					var count: int = work_manager.get_worker_count(3)  # CONSTRUCTING = 3
					if count < 2:  # Per-site limit
						return {
							"type": "constructing",
							"target": site,
							"position": site.global_position
						}
				else:
					return {
						"type": "constructing",
						"target": site,
						"position": site.global_position
					}

	return {}


func _find_gathering_work(agent: Node3D, agent_pos: Vector3) -> Dictionary:
	## Find gathering work from ship.
	var work_manager := _get_work_manager(agent)

	# Check if already at max gatherers
	if work_manager:
		var count: int = work_manager.get_worker_count(0)  # GATHERING = 0
		if count >= 2:
			return {}

	# Check if any construction sites need materials
	var sites_need_materials: bool = false
	var sites: Array = agent.get_tree().get_nodes_in_group("construction_sites")
	for site in sites:
		if site.has_method("get_materials_needed"):
			if site.get_materials_needed().size() > 0:
				sites_need_materials = true
				break

	if not sites_need_materials:
		return {}

	# Find ship resource
	var ships: Array = agent.get_tree().get_nodes_in_group("ship_resources")
	for ship in ships:
		if not ship is Node3D:
			# Check parent if component
			var parent: Node = ship.get_parent()
			if parent is Node3D:
				ship = parent
			else:
				continue

		# Check if ship has resources
		var ship_comp: Node = null
		for child in ship.get_children():
			if child.get_class() == "ShipResourceComponent" or child is ShipResourceComponent:
				ship_comp = child
				break

		if ship_comp and ship_comp.has_method("is_all_exhausted"):
			if not ship_comp.is_all_exhausted():
				return {
					"type": "gathering",
					"target": ship,
					"position": ship.global_position
				}

	return {}


func _find_hauling_work(agent: Node3D, agent_pos: Vector3) -> Dictionary:
	## Find hauling work - bring materials from workbench to construction site.
	var work_manager := _get_work_manager(agent)

	# Check if already at max haulers
	if work_manager:
		var count: int = work_manager.get_worker_count(2)  # HAULING = 2
		if count >= 2:
			return {}

	# Find workbenches with materials and sites that need them
	var workbenches: Array = agent.get_tree().get_nodes_in_group("workbenches")
	var sites: Array = agent.get_tree().get_nodes_in_group("construction_sites")

	for site in sites:
		if not site.has_method("get_materials_needed"):
			continue
		var needed: Dictionary = site.get_materials_needed()
		if needed.is_empty():
			continue

		# Check nearby workbenches for materials
		for workbench in workbenches:
			if not workbench is Node3D:
				continue

			var dist: float = agent_pos.distance_to(workbench.global_position)
			if dist > discovery_radius:
				continue

			# Check if workbench has materials
			var wb_comp: Node = _find_workbench_component(workbench)
			if wb_comp:
				for mat_id: String in needed:
					if wb_comp.has_method("has_materials") and wb_comp.has_materials(mat_id, 1):
						return {
							"type": "hauling",
							"target": site,
							"source": workbench,
							"position": workbench.global_position
						}

	return {}


func _set_work_assignment(job: Dictionary) -> void:
	## Set blackboard variables for the work assignment.
	var work_type: String = job.get("type", "")
	var target: Node = job.get("target", null)
	var position: Vector3 = job.get("position", Vector3.INF)

	blackboard.set_var(work_type_var, work_type)
	blackboard.set_var(work_target_var, target)
	blackboard.set_var(target_position_var, position)

	# Store source for hauling
	if work_type == "hauling":
		blackboard.set_var(&"haul_source", job.get("source", null))

	# Set current action for UI
	match work_type:
		"gathering":
			blackboard.set_var(&"current_action", "Gathering materials")
		"hauling":
			blackboard.set_var(&"current_action", "Hauling materials")
		"constructing":
			blackboard.set_var(&"current_action", "Building")
		_:
			blackboard.set_var(&"current_action", "Working")


func _get_work_manager(agent: Node) -> Node:
	## Find the WorkManager autoload.
	if agent.has_node("/root/WorkManager"):
		return agent.get_node("/root/WorkManager")
	return null


func _find_workbench_component(workbench: Node) -> Node:
	## Find WorkbenchComponent child.
	for child in workbench.get_children():
		if child is WorkbenchComponent:
			return child
	return null
