extends Node
## Handles RTS-style input: click to select, right-click to move.
## Attach to main scene or as child of camera.

@export var camera: Camera3D
@export var terrain_collision_mask: int = 1  # Layer for terrain/ground
@export var unit_collision_mask: int = 2     # Layer for selectable units

var selected_unit: ClickableUnit = null
var is_box_selecting: bool = false
var box_start: Vector2 = Vector2.ZERO

# Terrain3D reference for height queries
var terrain_3d: Node = null


func _ready() -> void:
	# Try to find camera if not set
	if not camera:
		camera = get_viewport().get_camera_3d()

	# Find Terrain3D node
	await get_tree().process_frame  # Wait for scene to be ready
	_find_terrain3d()


func _unhandled_input(event: InputEvent) -> void:
	if not camera:
		return

	# Left click - select unit
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton

		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			_handle_left_click(mouse_event.position)

		# Right click - move selected unit
		elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			_handle_right_click(mouse_event.position)


func _handle_left_click(screen_position: Vector2) -> void:
	## Try to select a unit at click position.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state

	# First, try to hit a unit
	var unit_query := PhysicsRayQueryParameters3D.create(from, to, unit_collision_mask)
	var unit_result := space_state.intersect_ray(unit_query)

	if not unit_result.is_empty():
		var hit: Object = unit_result.collider
		if hit is ClickableUnit:
			_select_unit(hit)
			return
		# Check parent (in case we hit a child collider)
		var parent: Node = hit.get_parent()
		if parent is ClickableUnit:
			_select_unit(parent)
			return

	# Clicked on nothing selectable - deselect
	_deselect_current()


func _handle_right_click(screen_position: Vector2) -> void:
	## Move selected unit to clicked position on terrain.
	if not selected_unit:
		print("[RTSInput] No unit selected, ignoring right-click")
		return

	var target_position := _get_terrain_position(screen_position)
	print("[RTSInput] Target position: ", target_position)
	if target_position != Vector3.INF:
		print("[RTSInput] Commanding move to: ", target_position)
		selected_unit.move_to(target_position)
		_show_move_indicator(target_position)
	else:
		print("[RTSInput] Could not find valid terrain position")


func _get_terrain_position(screen_position: Vector2) -> Vector3:
	## Get world position on terrain from screen position.
	## Returns Vector3.INF if no valid position found.
	var from := camera.project_ray_origin(screen_position)
	var direction := camera.project_ray_normal(screen_position)

	# Method 1: Try Terrain3D direct height query (no physics needed)
	if terrain_3d and "data" in terrain_3d and terrain_3d.data:
		# Use iterative approach: start with y=0 plane, get height, refine
		if abs(direction.y) > 0.001:
			# Initial intersection with y=0 plane
			var t := -from.y / direction.y
			if t > 0:
				var ground_pos := from + direction * t
				var height: float = terrain_3d.data.get_height(ground_pos)
				if not is_nan(height):
					# Refine: intersect with plane at actual terrain height
					t = (height - from.y) / direction.y
					if t > 0:
						ground_pos = from + direction * t
						height = terrain_3d.data.get_height(ground_pos)
						if not is_nan(height):
							print("[RTSInput] Terrain3D hit at: ", Vector3(ground_pos.x, height, ground_pos.z))
							return Vector3(ground_pos.x, height, ground_pos.z)

	# Method 2: Fallback to physics raycast
	var to := from + direction * 1000.0
	var space_state := camera.get_world_3d().direct_space_state
	var terrain_query := PhysicsRayQueryParameters3D.create(from, to, terrain_collision_mask)
	var terrain_result := space_state.intersect_ray(terrain_query)

	if not terrain_result.is_empty():
		print("[RTSInput] Physics raycast hit at: ", terrain_result.position)
		return terrain_result.position

	# Method 3: Simple ground plane intersection as last resort
	if abs(direction.y) > 0.001:
		var t := -from.y / direction.y
		if t > 0:
			var fallback_pos := from + direction * t
			print("[RTSInput] Fallback ground plane at: ", fallback_pos)
			return fallback_pos

	return Vector3.INF


func _find_terrain3d() -> void:
	## Find the Terrain3D node in the scene.
	var nodes := get_tree().get_nodes_in_group("terrain")
	if nodes.size() > 0:
		terrain_3d = nodes[0]
		return

	# Search by class name
	terrain_3d = _find_node_by_class(get_tree().current_scene, "Terrain3D")


func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	if node.get_class() == class_name_str:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_str)
		if result:
			return result
	return null


func _select_unit(unit: ClickableUnit) -> void:
	# Deselect previous
	if selected_unit and selected_unit != unit:
		selected_unit.deselect()

	selected_unit = unit
	selected_unit.select()

	# Set camera focus target for MMB orbit
	if camera and camera.has_method("set_focus_target"):
		camera.set_focus_target(unit)


func _deselect_current() -> void:
	if selected_unit:
		selected_unit.deselect()
		selected_unit = null

	# Clear camera focus target
	if camera and camera.has_method("clear_focus_target"):
		camera.clear_focus_target()


func _show_move_indicator(position: Vector3) -> void:
	## Visual feedback for move command (optional).
	# TODO: Add a visual indicator (particle, decal, etc.)
	pass


func get_selected_unit() -> ClickableUnit:
	return selected_unit
