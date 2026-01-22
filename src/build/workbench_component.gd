class_name WorkbenchComponent
extends Node
## Manages workbench functionality: material storage, placement mode, and construction sites.

signal placement_started(recipe: BuildRecipe)
signal placement_completed(site: ConstructionSite)
signal placement_cancelled
signal materials_changed

## Materials stored at this workbench.
var stored_materials: Dictionary = {
	"scrap_wood": 0,
	"nails": 0
}

## Construction sites created from this workbench.
var active_sites: Array[ConstructionSite] = []

## Ghost placement controller.
var _ghost_placement: GhostPlacement = null

## Reference to the parent workbench node.
var _workbench: Node3D = null


func _ready() -> void:
	_workbench = get_parent() as Node3D
	if _workbench:
		_workbench.add_to_group("workbenches")

	# Register with WorkManager if available.
	await get_tree().process_frame
	var work_manager := _get_work_manager()
	if work_manager:
		work_manager.register_workbench(_workbench if _workbench else self)


func _exit_tree() -> void:
	var work_manager := _get_work_manager()
	if work_manager and _workbench:
		work_manager.unregister_workbench(_workbench)


func get_available_recipes() -> Array[BuildRecipe]:
	## Get all recipes that can be built.
	return BuildRecipes.get_all_recipes()


func can_build(recipe: BuildRecipe) -> bool:
	## Check if we have enough materials for a recipe.
	if not recipe:
		return false
	return recipe.has_all_materials(stored_materials)


func start_placement_mode(recipe: BuildRecipe) -> void:
	## Enter placement mode for a recipe.
	if not recipe:
		push_error("WorkbenchComponent: Cannot start placement without recipe")
		return

	if not can_build(recipe):
		push_warning("WorkbenchComponent: Insufficient materials for %s" % recipe.display_name)
		return

	# Create ghost placement controller if needed.
	if not _ghost_placement:
		_ghost_placement = GhostPlacement.new()
		_ghost_placement.placement_confirmed.connect(_on_placement_confirmed)
		_ghost_placement.placement_cancelled.connect(_on_placement_cancelled)
		get_tree().current_scene.add_child(_ghost_placement)

	_ghost_placement.start_placement(recipe, _workbench if _workbench else self)
	placement_started.emit(recipe)


func cancel_placement_mode() -> void:
	## Cancel placement mode if active.
	if _ghost_placement and _ghost_placement.is_active():
		_ghost_placement.cancel_placement()


func is_placement_active() -> bool:
	## Check if placement mode is currently active.
	return _ghost_placement and _ghost_placement.is_active()


func get_stored_material_count(material_id: String) -> int:
	## Get the count of a specific material.
	return stored_materials.get(material_id, 0)


func has_materials(material_id: String, count: int) -> bool:
	## Check if we have at least count of a material.
	return get_stored_material_count(material_id) >= count


func deposit_material(material_id: String, count: int) -> void:
	## Add materials to storage.
	var current: int = stored_materials.get(material_id, 0)
	stored_materials[material_id] = current + count
	materials_changed.emit()


func add_materials(material_id: String, count: int) -> void:
	## Alias for deposit_material - used when returning materials from cancelled sites.
	deposit_material(material_id, count)


func withdraw_material(material_id: String, count: int) -> int:
	## Remove materials from storage. Returns actual amount withdrawn.
	var current: int = stored_materials.get(material_id, 0)
	var withdrawn: int = mini(count, current)
	stored_materials[material_id] = current - withdrawn
	materials_changed.emit()
	return withdrawn


func get_all_materials() -> Dictionary:
	## Get a copy of all stored materials.
	return stored_materials.duplicate()


func _on_placement_confirmed(position: Vector3, rotation_y: float, recipe: BuildRecipe) -> void:
	## Handle confirmed placement - create construction site.
	# Withdraw materials from storage.
	for mat_id: String in recipe.required_materials:
		var amount: int = recipe.required_materials[mat_id]
		withdraw_material(mat_id, amount)

	# Create construction site.
	var site := _create_construction_site(position, rotation_y, recipe)
	active_sites.append(site)

	placement_completed.emit(site)


func _on_placement_cancelled() -> void:
	## Handle cancelled placement.
	placement_cancelled.emit()


func _create_construction_site(position: Vector3, rotation_y: float, recipe: BuildRecipe) -> ConstructionSite:
	## Create a construction site at the given position and rotation.
	var site := ConstructionSite.new()
	site.recipe = recipe
	site.linked_workbench = _workbench if _workbench else self
	site.name = "ConstructionSite_%s" % recipe.id

	# Add to scene at position and rotation.
	get_tree().current_scene.add_child(site)
	site.global_position = position
	site.rotation.y = rotation_y

	# Create visual from actual scene or fallback box.
	_create_site_visual(site, recipe)

	# Add progress bar.
	var progress_bar := ProgressBar3D.new()
	site.add_child(progress_bar)
	site.set_progress_bar(progress_bar)

	# Mark materials as already deposited (we withdrew from workbench).
	for mat_id: String in recipe.required_materials:
		site.materials_deposited[mat_id] = recipe.required_materials[mat_id]

	# Register with WorkManager.
	var work_manager := _get_work_manager()
	if work_manager:
		work_manager.register_construction_site(site)

	# Connect signals.
	site.construction_complete.connect(_on_site_complete.bind(site))
	site.construction_cancelled.connect(_on_site_cancelled.bind(site))

	return site


func _create_site_visual(site: ConstructionSite, recipe: BuildRecipe) -> void:
	## Create the visual representation of the construction site.
	var visual: Node3D = null

	# Try to instantiate the actual scene.
	if not recipe.result_scene_path.is_empty():
		if ResourceLoader.exists(recipe.result_scene_path):
			var scene: PackedScene = load(recipe.result_scene_path)
			if scene:
				visual = scene.instantiate()
				# Apply semi-transparent "under construction" shader.
				_apply_construction_shader(visual)
				# Keep collision enabled so units can't walk through.
				# But don't add to resource groups yet.
				_remove_from_resource_groups(visual)

	# Fallback to box mesh.
	if not visual:
		var mesh_instance := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(2.0, 1.5, 2.0)
		mesh_instance.mesh = box
		var material := StandardMaterial3D.new()
		material.albedo_color = Color(0.5, 0.5, 0.5, 0.5)
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mesh_instance.material_override = material
		visual = mesh_instance

	site.add_child(visual)


func _apply_construction_shader(node: Node) -> void:
	## Apply semi-transparent shader to all meshes and freeze RigidBody3D.
	if node is MeshInstance3D:
		var mi: MeshInstance3D = node
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.6, 0.6, 0.6, 0.7)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mi.material_override = mat
	elif node is RigidBody3D:
		# Freeze rigid bodies so they don't fall during construction.
		var rb: RigidBody3D = node
		rb.freeze = true
		rb.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC

	for child in node.get_children():
		_apply_construction_shader(child)


func _remove_from_resource_groups(node: Node) -> void:
	## Remove from groups that would make units interact with it as a resource.
	var resource_groups: Array[String] = ["containers", "food_sources", "seats", "beds"]
	for group_name in node.get_groups():
		if group_name in resource_groups:
			node.remove_from_group(group_name)

	for child in node.get_children():
		_remove_from_resource_groups(child)


func _on_site_complete(site: ConstructionSite) -> void:
	## Handle construction site completion.
	active_sites.erase(site)


func _on_site_cancelled(site: ConstructionSite) -> void:
	## Handle construction site cancellation.
	active_sites.erase(site)


func _get_work_manager() -> Node:
	## Find the WorkManager autoload.
	if has_node("/root/WorkManager"):
		return get_node("/root/WorkManager")
	return null


# =============================================================================
# SERIALIZATION (for save/load system)
# =============================================================================

func serialize() -> Dictionary:
	## Serialize workbench state for saving.
	var position := _workbench.global_position if _workbench else Vector3.ZERO
	return {
		"position": [position.x, position.y, position.z],
		"stored_materials": stored_materials.duplicate()
	}


func deserialize(data: Dictionary) -> void:
	## Restore workbench state from save data.
	if data.has("stored_materials"):
		stored_materials = data.get("stored_materials", {}).duplicate()
		materials_changed.emit()
