class_name ConstructionSite
extends Node3D
## A construction site where units work to complete a build project.

signal progress_changed(percent: float)
signal material_deposited(material_id: String, count: int)
signal construction_complete(result_scene: PackedScene)
signal construction_cancelled
signal worker_joined(unit: Node)
signal worker_left(unit: Node)

## The recipe being built.
@export var recipe: BuildRecipe

## The workbench that initiated this construction.
var linked_workbench: Node = null

## Materials that have been deposited at this site.
var materials_deposited: Dictionary = {}

## Materials currently being hauled to this site (reserved but not yet deposited).
var materials_reserved: Dictionary = {}

## Construction progress (0.0 to 1.0).
var construction_progress: float = 0.0

## Units currently working on construction.
var active_workers: Array[Node] = []

## Maximum number of constructors at once.
const MAX_CONSTRUCTORS: int = 2

## Reference to the progress bar (added as child).
var _progress_bar: Node = null


func _ready() -> void:
	add_to_group("construction_sites")
	# Initialize deposited materials to zero.
	if recipe:
		for mat_id: String in recipe.required_materials:
			materials_deposited[mat_id] = 0


func get_progress_percent() -> float:
	## Get construction progress as percentage (0-100).
	return construction_progress * 100.0


func get_materials_needed(exclude_reserved: bool = false) -> Dictionary:
	## Get dictionary of materials still needed: {id: amount}.
	## If exclude_reserved is true, also subtracts in-flight reservations.
	if not recipe:
		return {}
	var needed: Dictionary = {}
	for mat_id: String in recipe.required_materials:
		var required: int = recipe.required_materials[mat_id]
		var deposited: int = materials_deposited.get(mat_id, 0)
		var remaining: int = required - deposited
		if exclude_reserved:
			remaining -= materials_reserved.get(mat_id, 0)
		if remaining > 0:
			needed[mat_id] = remaining
	return needed


func has_all_required_materials() -> bool:
	## Check if all required materials have been deposited.
	return get_materials_needed().size() == 0


func deposit_material(material_id: String, count: int) -> int:
	## Deposit materials at the construction site.
	## Returns the amount actually accepted (may be less than count).
	if not recipe:
		return 0

	var required: int = recipe.required_materials.get(material_id, 0)
	var deposited: int = materials_deposited.get(material_id, 0)
	var can_accept: int = required - deposited

	if can_accept <= 0:
		return 0

	var accepted: int = mini(count, can_accept)
	materials_deposited[material_id] = deposited + accepted
	# Clear reservation for the deposited amount.
	unreserve_material(material_id, accepted)
	material_deposited.emit(material_id, accepted)

	return accepted


func reserve_material(material_id: String, count: int) -> int:
	## Reserve materials for hauling. Returns amount actually reserved.
	var needed: int = _get_unreserved_need(material_id)
	var reserved: int = mini(count, needed)
	if reserved > 0:
		materials_reserved[material_id] = materials_reserved.get(material_id, 0) + reserved
	return reserved


func unreserve_material(material_id: String, count: int) -> void:
	## Cancel a reservation (unit failed to deliver or materials deposited).
	var current: int = materials_reserved.get(material_id, 0)
	materials_reserved[material_id] = maxi(current - count, 0)


func _get_unreserved_need(material_id: String) -> int:
	## How many more of this material can be reserved?
	var required: int = recipe.required_materials.get(material_id, 0) if recipe else 0
	var deposited: int = materials_deposited.get(material_id, 0)
	var reserved: int = materials_reserved.get(material_id, 0)
	return maxi(required - deposited - reserved, 0)


func add_work(hours: float, efficiency: float = 1.0) -> void:
	## Add work hours to construction progress.
	## efficiency is the combined efficiency of the worker.
	if not recipe:
		return
	if not has_all_required_materials():
		return

	var total_hours: float = recipe.get_total_work_hours()
	var effective_hours: float = hours * efficiency

	# Multi-worker bonus: +25% per additional worker.
	var worker_count: int = active_workers.size()
	if worker_count > 1:
		effective_hours *= 1.0 + (worker_count - 1) * 0.25

	construction_progress += effective_hours / total_hours
	construction_progress = clampf(construction_progress, 0.0, 1.0)

	progress_changed.emit(get_progress_percent())

	# Update progress bar if exists.
	if _progress_bar and _progress_bar.has_method("set_progress"):
		_progress_bar.set_progress(construction_progress)

	# Check for completion.
	if construction_progress >= 1.0:
		_complete_construction()


func can_accept_worker() -> bool:
	## Check if the site can accept more workers.
	return active_workers.size() < MAX_CONSTRUCTORS


func register_worker(unit: Node) -> bool:
	## Register a unit as working on this site.
	if not can_accept_worker():
		return false
	if unit in active_workers:
		return true
	active_workers.append(unit)
	worker_joined.emit(unit)
	return true


func unregister_worker(unit: Node) -> void:
	## Unregister a unit from this site.
	if unit in active_workers:
		active_workers.erase(unit)
		worker_left.emit(unit)


func get_worker_count() -> int:
	## Get the number of active workers.
	return active_workers.size()


func set_progress_bar(bar: Node) -> void:
	## Set the progress bar component.
	_progress_bar = bar


func cancel_construction() -> void:
	## Cancel the construction and return materials to workbench.
	# Return deposited materials to linked workbench.
	if linked_workbench and is_instance_valid(linked_workbench):
		if linked_workbench.has_method("add_materials"):
			for mat_id: String in materials_deposited:
				var count: int = materials_deposited[mat_id]
				if count > 0:
					linked_workbench.add_materials(mat_id, count)

	# Clear all reservations.
	materials_reserved.clear()

	# Unregister all workers.
	for worker in active_workers.duplicate():
		unregister_worker(worker)

	# Emit cancelled signal.
	construction_cancelled.emit()

	# Unregister from WorkManager.
	var work_manager := _get_work_manager()
	if work_manager:
		work_manager.unregister_construction_site(self)

	# Remove the construction site.
	queue_free()


func _complete_construction() -> void:
	## Handle construction completion.
	# Spawn the result scene at this location.
	var result_scene: PackedScene = recipe.get_result_scene() if recipe else null
	if result_scene:
		var result: Node3D = result_scene.instantiate()
		# Add to tree first so global_position/rotation setters work.
		get_parent().add_child(result)
		result.global_rotation = global_rotation
		# Elevate RigidBody3D results slightly so physics can settle them onto terrain.
		# Static objects (campfires etc.) go directly at ground level.
		if result is RigidBody3D:
			result.global_position = global_position + Vector3(0, 0.5, 0)
			_unfreeze_rigid_bodies_deferred(result)
		else:
			result.global_position = global_position
		# If this is a tent, make it interactive for store/place.
		if recipe.id == &"tent":
			result.add_to_group("placed_tents")
			TentPlacementManager.add_tent_click_area(result)

	# Emit completion signal.
	construction_complete.emit(result_scene)

	# Unregister from WorkManager.
	var work_manager := _get_work_manager()
	if work_manager:
		work_manager.unregister_construction_site(self)

	# Remove the construction site.
	queue_free()


func _unfreeze_rigid_bodies_deferred(node: Node) -> void:
	## Unfreeze RigidBody3D nodes after a short delay to let terrain collision initialize.
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(node):
		_unfreeze_rigid_bodies(node)


func _unfreeze_rigid_bodies(node: Node) -> void:
	## Recursively unfreeze all RigidBody3D nodes.
	if node is RigidBody3D:
		var rb: RigidBody3D = node
		rb.freeze = false
	for child in node.get_children():
		_unfreeze_rigid_bodies(child)


func _get_work_manager() -> Node:
	## Find the WorkManager autoload.
	if has_node("/root/WorkManager"):
		return get_node("/root/WorkManager")
	return null


# =============================================================================
# SERIALIZATION (for save/load system)
# =============================================================================

func serialize() -> Dictionary:
	## Serialize construction site state for saving.
	return {
		"recipe_id": recipe.id if recipe else "",
		"position": [global_position.x, global_position.y, global_position.z],
		"rotation": [global_rotation.x, global_rotation.y, global_rotation.z],
		"progress": construction_progress,
		"materials_deposited": materials_deposited.duplicate()
	}


func deserialize(data: Dictionary) -> void:
	## Restore construction site state from save data.
	## Note: Recipe must be set before calling this.
	if data.has("position"):
		var pos: Array = data.get("position", [0, 0, 0])
		global_position = Vector3(pos[0], pos[1], pos[2])

	if data.has("rotation"):
		var rot: Array = data.get("rotation", [0, 0, 0])
		global_rotation = Vector3(rot[0], rot[1], rot[2])

	construction_progress = data.get("progress", 0.0)

	if data.has("materials_deposited"):
		materials_deposited = data.get("materials_deposited", {}).duplicate()

	# Update progress bar if exists.
	if _progress_bar and _progress_bar.has_method("set_progress"):
		_progress_bar.set_progress(construction_progress)
