extends Node
## Autoload singleton
## Manages work assignments, job discovery, and worker coordination.
## Should be added as an Autoload singleton.

signal job_available(job_type: JobType, location: Node)
signal job_completed(job_type: JobType, location: Node)
signal worker_assigned(unit: Node, job_type: JobType, target: Node)
signal worker_released(unit: Node)

enum JobType {
	GATHERING,    ## Collecting raw materials from ship
	PREPARING,    ## Processing materials at workbench
	HAULING,      ## Transporting materials between locations
	CONSTRUCTING  ## Building at construction sites
}

## Maximum workers per job type (except CONSTRUCTING which is per-site).
const MAX_GATHERERS: int = 2
const MAX_PREPARERS: int = 2
const MAX_HAULERS: int = 2
const MAX_CONSTRUCTORS_PER_SITE: int = 2

## Discovery radius for finding work.
const WORK_DISCOVERY_RADIUS: float = 30.0

## Registered construction sites.
var _construction_sites: Array[Node] = []
## Registered workbenches.
var _workbenches: Array[Node] = []
## Ship resource component (source for gathering).
var _ship_resource: Node = null
## Worker assignments: unit -> {job_type: JobType, target: Node}
var _worker_assignments: Dictionary = {}


func _ready() -> void:
	# Connect to tree changes to auto-cleanup dead references.
	get_tree().node_removed.connect(_on_node_removed)


func register_construction_site(site: Node) -> void:
	## Register a new construction site.
	if site not in _construction_sites:
		_construction_sites.append(site)
		site.add_to_group("construction_sites")
		job_available.emit(JobType.CONSTRUCTING, site)


func unregister_construction_site(site: Node) -> void:
	## Unregister a construction site (completed or cancelled).
	_construction_sites.erase(site)
	site.remove_from_group("construction_sites")
	# Release any workers assigned to this site.
	_release_workers_for_target(site)


func register_workbench(workbench: Node) -> void:
	## Register a workbench.
	if workbench not in _workbenches:
		_workbenches.append(workbench)
		workbench.add_to_group("workbenches")


func unregister_workbench(workbench: Node) -> void:
	## Unregister a workbench.
	_workbenches.erase(workbench)
	workbench.remove_from_group("workbenches")


func set_ship_resource(ship: Node) -> void:
	## Set the ship resource component for gathering.
	_ship_resource = ship


func get_available_job(unit: Node) -> Dictionary:
	## Find available work for a unit based on proximity and need.
	## Returns {"job_type": JobType, "target": Node} or empty dict if none.
	var unit_pos: Vector3 = unit.global_position

	# Check for nearby construction sites needing workers or materials.
	for site in _construction_sites:
		if not is_instance_valid(site):
			continue
		var dist: float = unit_pos.distance_to(site.global_position)
		if dist > WORK_DISCOVERY_RADIUS:
			continue

		# Does site need constructors?
		if _can_site_accept_constructor(site):
			if site.has_all_required_materials():
				return {"job_type": JobType.CONSTRUCTING, "target": site}

		# Does site need materials hauled to it?
		if site.get_materials_needed().size() > 0:
			# Check if workbench has materials to haul.
			var workbench := _find_workbench_with_materials_for_site(site)
			if workbench and _get_worker_count(JobType.HAULING) < MAX_HAULERS:
				return {"job_type": JobType.HAULING, "target": site}

	# Check for nearby workbenches needing gatherers or preparers.
	for workbench in _workbenches:
		if not is_instance_valid(workbench):
			continue
		var dist: float = unit_pos.distance_to(workbench.global_position)
		if dist > WORK_DISCOVERY_RADIUS:
			continue

		# Need gatherers?
		if _ship_resource and _get_worker_count(JobType.GATHERING) < MAX_GATHERERS:
			# Check if any sites need more materials.
			if _any_site_needs_materials():
				return {"job_type": JobType.GATHERING, "target": _ship_resource}

	return {}


func assign_worker(unit: Node, job_type: JobType, target: Node) -> bool:
	## Assign a worker to a job. Returns true if successful.
	if not is_instance_valid(unit) or not is_instance_valid(target):
		return false

	# Check capacity limits.
	match job_type:
		JobType.GATHERING:
			if _get_worker_count(JobType.GATHERING) >= MAX_GATHERERS:
				return false
		JobType.PREPARING:
			if _get_worker_count(JobType.PREPARING) >= MAX_PREPARERS:
				return false
		JobType.HAULING:
			if _get_worker_count(JobType.HAULING) >= MAX_HAULERS:
				return false
		JobType.CONSTRUCTING:
			if not _can_site_accept_constructor(target):
				return false

	# Release any existing assignment.
	release_worker(unit)

	# Create new assignment.
	_worker_assignments[unit] = {"job_type": job_type, "target": target}
	unit.add_to_group("construction_workers")
	worker_assigned.emit(unit, job_type, target)

	# If constructing, register with site.
	if job_type == JobType.CONSTRUCTING and target.has_method("register_worker"):
		target.register_worker(unit)

	return true


func release_worker(unit: Node) -> void:
	## Release a worker from their current assignment.
	if unit not in _worker_assignments:
		return

	var assignment: Dictionary = _worker_assignments[unit]
	var job_type: JobType = assignment.get("job_type", JobType.GATHERING)
	var target: Node = assignment.get("target", null)

	# Unregister from construction site if applicable.
	if job_type == JobType.CONSTRUCTING and is_instance_valid(target):
		if target.has_method("unregister_worker"):
			target.unregister_worker(unit)

	_worker_assignments.erase(unit)
	unit.remove_from_group("construction_workers")
	worker_released.emit(unit)


func get_worker_assignment(unit: Node) -> Dictionary:
	## Get a worker's current assignment.
	return _worker_assignments.get(unit, {})


func is_worker_assigned(unit: Node) -> bool:
	## Check if a unit has a work assignment.
	return unit in _worker_assignments


func get_worker_count(job_type: JobType) -> int:
	## Get count of workers assigned to a job type.
	return _get_worker_count(job_type)


func get_all_construction_sites() -> Array[Node]:
	## Get all registered construction sites.
	return _construction_sites.duplicate()


func get_nearest_workbench(position: Vector3) -> Node:
	## Find the nearest workbench to a position.
	var nearest: Node = null
	var nearest_dist: float = INF
	for wb in _workbenches:
		if not is_instance_valid(wb):
			continue
		var dist: float = position.distance_to(wb.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = wb
	return nearest


# ============== Private Methods ==============

func _get_worker_count(job_type: JobType) -> int:
	## Count workers assigned to a specific job type.
	var count: int = 0
	for assignment: Dictionary in _worker_assignments.values():
		if assignment.get("job_type", -1) == job_type:
			count += 1
	return count


func _can_site_accept_constructor(site: Node) -> bool:
	## Check if a construction site can accept more constructors.
	if not is_instance_valid(site):
		return false
	if not site.has_method("can_accept_worker"):
		return false
	return site.can_accept_worker()


func _release_workers_for_target(target: Node) -> void:
	## Release all workers assigned to a specific target.
	var to_release: Array[Node] = []
	for unit: Node in _worker_assignments:
		var assignment: Dictionary = _worker_assignments[unit]
		if assignment.get("target", null) == target:
			to_release.append(unit)
	for unit in to_release:
		release_worker(unit)


func _find_workbench_with_materials_for_site(site: Node) -> Node:
	## Find a workbench that has materials needed by the site.
	if not site.has_method("get_materials_needed"):
		return null
	var needed: Dictionary = site.get_materials_needed()
	for workbench in _workbenches:
		if not is_instance_valid(workbench):
			continue
		if not workbench.has_method("has_materials"):
			continue
		for mat_id: String in needed:
			if workbench.has_materials(mat_id, 1):
				return workbench
	return null


func _any_site_needs_materials() -> bool:
	## Check if any construction site needs more materials.
	for site in _construction_sites:
		if not is_instance_valid(site):
			continue
		if site.has_method("get_materials_needed"):
			if site.get_materials_needed().size() > 0:
				return true
	return false


func _on_node_removed(node: Node) -> void:
	## Cleanup when nodes are removed from tree.
	if node in _construction_sites:
		_construction_sites.erase(node)
		_release_workers_for_target(node)
	if node in _workbenches:
		_workbenches.erase(node)
	if node == _ship_resource:
		_ship_resource = null
	if node in _worker_assignments:
		release_worker(node)
