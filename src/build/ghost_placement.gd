class_name GhostPlacement
extends Node3D
## Visual preview for building placement with terrain validation.
## Instantiates the full scene with ghost shader applied.

signal placement_confirmed(position: Vector3, rotation_y: float, recipe: BuildRecipe)
signal placement_cancelled

## Color when placement is valid.
@export var valid_color: Color = Color(0.6, 0.7, 0.5, 0.5)
## Color when placement is invalid.
@export var invalid_color: Color = Color(1.0, 0.3, 0.3, 0.5)
## Maximum distance from workbench in meters.
@export var max_distance_from_workbench: float = 75.0
## Maximum slope in degrees.
@export var max_slope_degrees: float = 10.0
## Sample distance for slope calculation.
@export var slope_sample_distance: float = 2.0
## Rotation step per scroll wheel tick in degrees.
@export var rotation_step_degrees: float = 15.0

var _ghost_instance: Node3D = null
var _ghost_materials: Array[ShaderMaterial] = []
var _current_recipe: BuildRecipe = null
var _linked_workbench: Node = null
var _is_active: bool = false
var _is_valid_position: bool = false
var _validation_reason: String = ""
## Current Y rotation in radians.
var _current_rotation_y: float = 0.0

var _terrain_cache: Node = null
var _camera: Camera3D = null


func _ready() -> void:
	set_process(false)
	set_process_input(false)


func _process(_delta: float) -> void:
	if not _is_active:
		return
	_update_ghost_position()


func _input(event: InputEvent) -> void:
	if not _is_active:
		return

	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			if _is_valid_position:
				_confirm_placement()
				get_viewport().set_input_as_handled()
		elif mb.button_index == MOUSE_BUTTON_RIGHT and mb.pressed:
			cancel_placement()
			get_viewport().set_input_as_handled()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_UP and mb.pressed:
			# Rotate counter-clockwise.
			_rotate_ghost(-deg_to_rad(rotation_step_degrees))
			get_viewport().set_input_as_handled()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN and mb.pressed:
			# Rotate clockwise.
			_rotate_ghost(deg_to_rad(rotation_step_degrees))
			get_viewport().set_input_as_handled()

	if event is InputEventKey:
		var key: InputEventKey = event
		if key.keycode == KEY_ESCAPE and key.pressed:
			cancel_placement()
			get_viewport().set_input_as_handled()


func start_placement(recipe: BuildRecipe, workbench: Node) -> void:
	## Enter placement mode for a recipe.
	if not recipe:
		push_error("GhostPlacement: Cannot start placement without recipe")
		return

	_current_recipe = recipe
	_linked_workbench = workbench
	_is_active = true
	_is_valid_position = false
	_current_rotation_y = 0.0

	# Find camera.
	_camera = get_viewport().get_camera_3d()

	# Create ghost instance.
	_create_ghost_instance()

	set_process(true)
	set_process_input(true)

	visible = true


func cancel_placement() -> void:
	## Cancel placement mode.
	_cleanup()
	placement_cancelled.emit()


func is_active() -> bool:
	## Check if placement mode is active.
	return _is_active


func get_validation_reason() -> String:
	## Get the reason for invalid placement (empty if valid).
	return _validation_reason


func _confirm_placement() -> void:
	## Confirm placement at current position and rotation.
	var final_position: Vector3 = global_position
	var final_rotation_y: float = _current_rotation_y
	var recipe: BuildRecipe = _current_recipe

	_cleanup()
	placement_confirmed.emit(final_position, final_rotation_y, recipe)


func _cleanup() -> void:
	## Cleanup placement mode.
	_is_active = false
	set_process(false)
	set_process_input(false)

	if _ghost_instance:
		_ghost_instance.queue_free()
		_ghost_instance = null

	_ghost_materials.clear()
	_current_recipe = null
	_linked_workbench = null
	_current_rotation_y = 0.0
	visible = false


func _rotate_ghost(delta_radians: float) -> void:
	## Rotate the ghost by the given amount around the Y axis.
	_current_rotation_y += delta_radians
	# Keep rotation in 0 to 2*PI range.
	_current_rotation_y = fmod(_current_rotation_y, TAU)
	if _current_rotation_y < 0:
		_current_rotation_y += TAU
	# Apply rotation to the GhostPlacement node itself.
	rotation.y = _current_rotation_y


func _create_ghost_instance() -> void:
	## Create ghost preview by instantiating full scene with shader.
	if _ghost_instance:
		_ghost_instance.queue_free()
		_ghost_instance = null
	_ghost_materials.clear()

	# Try to load scene from recipe.
	if _current_recipe and not _current_recipe.result_scene_path.is_empty():
		if ResourceLoader.exists(_current_recipe.result_scene_path):
			var scene: PackedScene = load(_current_recipe.result_scene_path)
			if scene:
				_ghost_instance = scene.instantiate()

				# Disable collision so it doesn't interact with physics.
				_disable_collision(_ghost_instance)

				# Remove from groups so units don't interact with it.
				_remove_from_groups(_ghost_instance)

				# Apply ghost shader to all meshes.
				_apply_ghost_shader(_ghost_instance)

				add_child(_ghost_instance)
				return

	# Fallback: create default box mesh.
	_create_fallback_box()


func _create_fallback_box() -> void:
	## Create a fallback box mesh for recipes without scenes.
	var mesh_instance := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(2.0, 1.5, 2.0)
	mesh_instance.mesh = box

	# Apply ghost shader.
	var mat := _create_ghost_material()
	mesh_instance.material_override = mat
	_ghost_materials.append(mat)

	_ghost_instance = mesh_instance
	add_child(_ghost_instance)


func _apply_ghost_shader(node: Node) -> void:
	## Recursively apply ghost shader to all MeshInstance3D nodes.
	if node is MeshInstance3D:
		var mi: MeshInstance3D = node
		var mat := _create_ghost_material()
		mi.material_override = mat
		_ghost_materials.append(mat)

	for child in node.get_children():
		_apply_ghost_shader(child)


func _create_ghost_material() -> ShaderMaterial:
	## Create a ghost shader material.
	var mat := ShaderMaterial.new()
	mat.shader = _create_ghost_shader()
	mat.set_shader_parameter("ghost_color", valid_color)
	return mat


func _create_ghost_shader() -> Shader:
	## Create shader for ghost transparency.
	var shader := Shader.new()
	shader.code = """
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform vec4 ghost_color : source_color = vec4(0.6, 0.7, 0.5, 0.5);

void fragment() {
	ALBEDO = ghost_color.rgb;
	ALPHA = ghost_color.a;
}
"""
	return shader


func _disable_collision(node: Node) -> void:
	## Recursively disable all collision shapes and freeze RigidBody3D.
	if node is CollisionShape3D:
		var cs: CollisionShape3D = node
		cs.disabled = true
	elif node is CollisionPolygon3D:
		var cp: CollisionPolygon3D = node
		cp.disabled = true
	elif node is StaticBody3D:
		# Disable the body entirely.
		var sb: StaticBody3D = node
		sb.collision_layer = 0
		sb.collision_mask = 0
	elif node is CharacterBody3D:
		var cb: CharacterBody3D = node
		cb.collision_layer = 0
		cb.collision_mask = 0
	elif node is RigidBody3D:
		var rb: RigidBody3D = node
		rb.collision_layer = 0
		rb.collision_mask = 0
		# Freeze the rigid body so it doesn't fall through terrain.
		rb.freeze = true
		rb.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	elif node is Area3D:
		var a: Area3D = node
		a.collision_layer = 0
		a.collision_mask = 0
		a.monitorable = false
		a.monitoring = false

	for child in node.get_children():
		_disable_collision(child)


func _remove_from_groups(node: Node) -> void:
	## Recursively remove node from all groups.
	for group_name in node.get_groups():
		node.remove_from_group(group_name)

	for child in node.get_children():
		_remove_from_groups(child)


func _update_ghost_position() -> void:
	## Update ghost position based on mouse raycast.
	if not _camera:
		return

	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = _camera.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = _camera.project_ray_normal(mouse_pos)

	# Raycast to find terrain position.
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_origin + ray_dir * 1000.0
	)
	query.collision_mask = 1  # Terrain layer.

	var result: Dictionary = space_state.intersect_ray(query)
	if result.is_empty():
		_is_valid_position = false
		_validation_reason = "No valid ground"
		_update_ghost_color(invalid_color)
		return

	var hit_pos: Vector3 = result.position

	# Snap to terrain height.
	var terrain := _find_terrain3d()
	if terrain and terrain.data:
		var terrain_height: float = terrain.data.get_height(hit_pos)
		if not is_nan(terrain_height):
			hit_pos.y = terrain_height

	global_position = hit_pos

	# Validate position.
	var validation: Dictionary = _validate_position(hit_pos)
	_is_valid_position = validation.valid
	_validation_reason = validation.get("reason", "")

	# Update ghost color.
	var color: Color = valid_color if _is_valid_position else invalid_color
	_update_ghost_color(color)


func _update_ghost_color(color: Color) -> void:
	## Update the color of all ghost materials.
	for mat: ShaderMaterial in _ghost_materials:
		mat.set_shader_parameter("ghost_color", color)


func _validate_position(pos: Vector3) -> Dictionary:
	## Validate if position is suitable for building.
	## Returns {"valid": bool, "reason": String}
	var validation_result: Dictionary = {"valid": true, "reason": ""}

	# 1. Check distance from workbench.
	if _linked_workbench:
		var dist: float = pos.distance_to(_linked_workbench.global_position)
		if dist > max_distance_from_workbench:
			validation_result.valid = false
			validation_result.reason = "Too far from workbench (max %dm)" % int(max_distance_from_workbench)
			return validation_result

	# 2. Check terrain slope.
	var slope: float = _calculate_slope(pos)
	if slope > max_slope_degrees:
		validation_result.valid = false
		validation_result.reason = "Ground too steep (%.0f° > %d° max)" % [slope, int(max_slope_degrees)]
		return validation_result

	# 3. Check collision with existing objects.
	if _check_collision(pos):
		validation_result.valid = false
		validation_result.reason = "Blocked by obstacle"
		return validation_result

	# 4. Check if workbench has required materials.
	if not _check_materials_available():
		validation_result.valid = false
		validation_result.reason = "Insufficient materials"
		return validation_result

	return validation_result


func _calculate_slope(pos: Vector3) -> float:
	## Calculate terrain slope at position in degrees.
	var terrain := _find_terrain3d()
	if not terrain or not terrain.data:
		return 0.0

	var h_center: float = terrain.data.get_height(pos)
	if is_nan(h_center):
		return 90.0  # Invalid position.

	var h_north: float = terrain.data.get_height(pos + Vector3(0, 0, -slope_sample_distance))
	var h_south: float = terrain.data.get_height(pos + Vector3(0, 0, slope_sample_distance))
	var h_east: float = terrain.data.get_height(pos + Vector3(slope_sample_distance, 0, 0))
	var h_west: float = terrain.data.get_height(pos + Vector3(-slope_sample_distance, 0, 0))

	# If any sample is invalid, assume steep.
	if is_nan(h_north) or is_nan(h_south) or is_nan(h_east) or is_nan(h_west):
		return 90.0

	# Calculate max height difference.
	var max_diff: float = 0.0
	for h: float in [h_north, h_south, h_east, h_west]:
		max_diff = maxf(max_diff, absf(h - h_center))

	# Convert to degrees: arctan(rise/run).
	return rad_to_deg(atan(max_diff / slope_sample_distance))


func _check_collision(pos: Vector3) -> bool:
	## Check if position collides with existing objects.
	var space_state := get_world_3d().direct_space_state

	# Create a box shape for collision check.
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.0, 1.5, 2.0)  # Approximate building size.

	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = Transform3D(Basis.IDENTITY, pos + Vector3(0, 0.75, 0))
	params.collision_mask = 0b11111110  # Exclude terrain (layer 1).

	var results: Array = space_state.intersect_shape(params, 1)
	return results.size() > 0


func _check_materials_available() -> bool:
	## Check if workbench has required materials.
	if not _linked_workbench or not _current_recipe:
		return false

	# Check if workbench has the method.
	if not _linked_workbench.has_method("get_stored_material_count"):
		# If workbench doesn't track materials yet, allow placement.
		return true

	for mat_id: String in _current_recipe.required_materials:
		var needed: int = _current_recipe.required_materials[mat_id]
		var available: int = _linked_workbench.get_stored_material_count(mat_id)
		if available < needed:
			return false

	return true


func _find_terrain3d() -> Node:
	## Find Terrain3D node in scene (cached).
	if _terrain_cache and is_instance_valid(_terrain_cache):
		return _terrain_cache

	var nodes: Array = get_tree().get_nodes_in_group("terrain")
	if nodes.size() > 0:
		_terrain_cache = nodes[0]
		return _terrain_cache

	# Fallback: search by class name.
	_terrain_cache = _find_node_by_class(get_tree().current_scene, "Terrain3D")
	return _terrain_cache


func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	## Recursively find a node by class name.
	if node.get_class() == class_name_str:
		return node
	for child in node.get_children():
		var found_node: Node = _find_node_by_class(child, class_name_str)
		if found_node:
			return found_node
	return null
