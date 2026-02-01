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
	"nails": 0,
	"scrap_sails": 0
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
	## Sites start empty - units must haul materials to them.
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
	var visual: Node3D = _create_site_visual(site, recipe)

	# Add click collision area based on visual bounds.
	_add_click_collision(site, visual)

	# Add progress bar.
	var progress_bar := ProgressBar3D.new()
	site.add_child(progress_bar)
	site.set_progress_bar(progress_bar)

	# Register with WorkManager.
	var work_manager := _get_work_manager()
	if work_manager:
		work_manager.register_construction_site(site)

	# Connect signals.
	site.construction_complete.connect(_on_site_complete.bind(site))
	site.construction_cancelled.connect(_on_site_cancelled.bind(site))

	return site


func _create_site_visual(site: ConstructionSite, recipe: BuildRecipe) -> Node3D:
	## Create the visual representation of the construction site.
	## Returns the visual node for bounds calculation.
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
	return visual


func _add_click_collision(site: ConstructionSite, visual: Node3D) -> void:
	## Add click collision area centered on the visual's bounds.
	var aabb: AABB = _get_combined_aabb(visual)
	if aabb.size == Vector3.ZERO:
		aabb = AABB(Vector3(-1.5, 0, -1.5), Vector3(3, 2, 3))

	var click_area := Area3D.new()
	click_area.name = "ClickArea"
	click_area.collision_layer = 64  # Layer 7 for construction sites
	click_area.collision_mask = 0

	var click_shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = aabb.size
	click_shape.shape = box
	click_shape.position = aabb.position + aabb.size * 0.5  # Center of AABB
	click_area.add_child(click_shape)
	site.add_child(click_area)


func _get_combined_aabb(node: Node3D) -> AABB:
	## Get combined AABB of all MeshInstance3D children.
	var result: AABB = AABB()
	var found_mesh: bool = false

	if node is MeshInstance3D:
		var mi: MeshInstance3D = node
		if mi.mesh:
			result = mi.mesh.get_aabb()
			result.position = mi.position + result.position
			found_mesh = true

	for child in node.get_children():
		if child is Node3D:
			var child_aabb: AABB = _get_combined_aabb(child as Node3D)
			if child_aabb.size != Vector3.ZERO:
				if found_mesh:
					result = result.merge(child_aabb)
				else:
					result = child_aabb
					found_mesh = true

	return result


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
	var resource_groups: Array[String] = [
		"containers", "interactable", "barrels", "crates",
		"food_sources", "seats", "beds", "heat_sources", "shelters",
		"barrel_positions", "fire_positions", "bed_positions",
	]
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
