extends Node
## Handles RTS-style input: click to select, right-click to move.
## Supports both single-select (ClickableUnit) and multi-select (Survivor) modes.
## Attach to main scene or as child of camera.

@export var camera: Camera3D
@export var terrain_collision_mask: int = 1  # Layer for terrain/ground
@export var unit_collision_mask: int = 2     # Layer for selectable units
@export var container_collision_mask: int = 8  # Layer 4 for containers (1 << 3)

## Enable multi-selection with shift-click and box select
@export var multi_select_enabled: bool = true

signal unit_double_clicked(unit: Node)
signal selection_changed(units: Array)
signal container_clicked(container: StorageContainer)

# Single selection (legacy support for ClickableUnit)
var selected_unit: ClickableUnit = null

# Multi-selection for Survivor units
var selected_units: Array[Node] = []

# Box selection state
var is_box_selecting: bool = false
var box_start: Vector2 = Vector2.ZERO
var box_current: Vector2 = Vector2.ZERO

# Terrain3D reference for height queries
var terrain_3d: Node = null

# Double-click detection
var _last_click_time: int = 0
var _last_clicked_unit: Node = null
const DOUBLE_CLICK_THRESHOLD_MS: int = 400

# Formation spacing for group moves
const FORMATION_SPACING: float = 2.0


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

	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton

		# Left click - select unit or start box selection
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				_handle_left_click_down(mouse_event.position)
			else:
				_handle_left_click_up(mouse_event.position)

		# Right click - move selected unit(s)
		elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			_handle_right_click(mouse_event.position)

	# Mouse motion for box selection
	elif event is InputEventMouseMotion and is_box_selecting:
		box_current = (event as InputEventMouseMotion).position

	# Keyboard shortcuts
	elif event is InputEventKey and event.pressed:
		var key := event as InputEventKey
		if key.keycode == KEY_A and key.ctrl_pressed:
			# Ctrl+A: Select all units
			_select_all_units()


func _handle_left_click_down(screen_position: Vector2) -> void:
	## Handle left mouse button press - start selection or box select.
	box_start = screen_position
	box_current = screen_position

	# Check if shift is held for additive selection
	var add_to_selection := Input.is_key_pressed(KEY_SHIFT) and multi_select_enabled

	# Try to click on a unit first
	var clicked_unit := _raycast_for_unit(screen_position)

	if clicked_unit:
		# Clicked directly on a unit
		_handle_unit_click(clicked_unit, add_to_selection)
	else:
		# Check for container click
		var clicked_container := _raycast_for_container(screen_position)
		if clicked_container:
			container_clicked.emit(clicked_container)
			return

		# Start box selection if multi-select enabled
		if multi_select_enabled:
			is_box_selecting = true
			if not add_to_selection:
				_deselect_all()


func _handle_left_click_up(screen_position: Vector2) -> void:
	## Handle left mouse button release - finish box selection.
	if is_box_selecting:
		is_box_selecting = false
		var box_size := (screen_position - box_start).length()

		# Only process as box selection if dragged more than threshold
		if box_size > 10.0:
			_finish_box_selection()

	box_start = Vector2.ZERO
	box_current = Vector2.ZERO


func _raycast_for_unit(screen_position: Vector2) -> Node:
	## Raycast to find a unit at screen position. Returns null if none found.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state
	var unit_query := PhysicsRayQueryParameters3D.create(from, to, unit_collision_mask)
	var unit_result := space_state.intersect_ray(unit_query)

	if unit_result.is_empty():
		return null

	var hit: Object = unit_result.collider

	# Check if it's a selectable unit (ClickableUnit or Survivor)
	if hit is ClickableUnit or hit is Survivor:
		return hit as Node

	# Check parent in case we hit a child collider
	var parent: Node = hit.get_parent()
	if parent is ClickableUnit or parent is Survivor:
		return parent

	return null


func _raycast_for_container(screen_position: Vector2) -> StorageContainer:
	## Raycast to find a container at screen position using dedicated container layer.
	## Returns null if none found.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state

	# First try: raycast against container collision layer (Area3D click areas)
	var container_query := PhysicsRayQueryParameters3D.create(from, to, container_collision_mask)
	container_query.collide_with_areas = true
	container_query.collide_with_bodies = false
	var container_result := space_state.intersect_ray(container_query)

	if not container_result.is_empty():
		var hit: Object = container_result.collider
		if hit is Area3D:
			# Area3D is child of container root, which has StorageContainer as child
			var container_root: Node = hit.get_parent()
			if container_root:
				return container_root.get_node_or_null("StorageContainer") as StorageContainer

	# Fallback: raycast against any physics body and walk up to find container
	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result := space_state.intersect_ray(query)

	if result.is_empty():
		return null

	var hit: Object = result.collider
	if not hit or not hit is Node:
		return null

	# Walk up parent chain to find container root (up to 5 levels)
	var current: Node = hit as Node
	for i in range(5):
		if not current:
			break
		if current.is_in_group("containers"):
			return current.get_node_or_null("StorageContainer") as StorageContainer
		current = current.get_parent()

	return null


func _handle_unit_click(unit: Node, add_to_selection: bool) -> void:
	## Handle clicking on a unit - single or additive selection.
	# Check for double-click
	var current_time := Time.get_ticks_msec()
	var is_double_click := false

	if unit == _last_clicked_unit:
		var time_diff := current_time - _last_click_time
		if time_diff <= DOUBLE_CLICK_THRESHOLD_MS:
			is_double_click = true

	_last_click_time = current_time
	_last_clicked_unit = unit

	if add_to_selection:
		# Toggle selection if shift-clicking
		if unit in selected_units:
			_deselect_unit(unit)
		else:
			_add_to_selection(unit)
	else:
		# Single select - clear others and select this one
		_deselect_all()
		_add_to_selection(unit)

	# Legacy support for ClickableUnit
	if unit is ClickableUnit:
		selected_unit = unit

	# Set camera focus
	if camera and camera.has_method("set_focus_target"):
		camera.set_focus_target(unit)

	# Emit double-click signal
	if is_double_click:
		unit_double_clicked.emit(unit)


func _handle_right_click(screen_position: Vector2) -> void:
	## Move selected unit(s) to clicked position on terrain.
	if selected_units.is_empty() and not selected_unit:
		print("[RTSInput] No units selected, ignoring right-click")
		return

	var target_position := _get_terrain_position(screen_position)
	if target_position == Vector3.INF:
		print("[RTSInput] Could not find valid terrain position")
		return

	print("[RTSInput] Moving %d units to: %s" % [selected_units.size(), target_position])

	# Move all selected units in formation
	if selected_units.size() > 1:
		_move_units_in_formation(selected_units, target_position)
	elif selected_units.size() == 1:
		selected_units[0].move_to(target_position)
	elif selected_unit:
		# Legacy single selection
		selected_unit.move_to(target_position)

	_show_move_indicator(target_position)


func _move_units_in_formation(units: Array, target: Vector3) -> void:
	## Move multiple units to target in a circular formation.
	var count := units.size()

	if count == 1:
		units[0].move_to(target)
		return

	if count == 2:
		# Two units: side by side
		units[0].move_to(target + Vector3(-FORMATION_SPACING * 0.5, 0, 0))
		units[1].move_to(target + Vector3(FORMATION_SPACING * 0.5, 0, 0))
		return

	# Multiple units: circular formation around target
	# Calculate rings needed
	var inner_count := mini(8, count)
	var angle_step := TAU / inner_count

	for i in range(count):
		var ring := i / 8  # Which ring (0 = inner, 1 = outer, etc.)
		var pos_in_ring := i % 8
		var ring_radius := FORMATION_SPACING * (ring + 1)
		var ring_count := mini(8, count - ring * 8)
		var ring_angle := TAU / ring_count

		var angle := ring_angle * pos_in_ring
		var offset := Vector3(cos(angle) * ring_radius, 0, sin(angle) * ring_radius)

		# Get terrain height at destination
		var dest := target + offset
		dest.y = _get_terrain_height(dest)

		units[i].move_to(dest)


func _get_terrain_height(position: Vector3) -> float:
	## Get terrain height at position.
	if terrain_3d and "data" in terrain_3d and terrain_3d.data:
		var height: float = terrain_3d.data.get_height(position)
		if not is_nan(height):
			return height
	return position.y


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


## --- Multi-Selection Functions ---

func _add_to_selection(unit: Node) -> void:
	## Add a unit to selection if not already selected.
	if unit in selected_units:
		return

	selected_units.append(unit)

	# Call select() on unit if it has the method
	if unit.has_method("select"):
		unit.select()

	selection_changed.emit(selected_units)


func _deselect_unit(unit: Node) -> void:
	## Remove a unit from selection.
	if unit not in selected_units:
		return

	selected_units.erase(unit)

	# Call deselect() on unit if it has the method
	if unit.has_method("deselect"):
		unit.deselect()

	# Legacy support
	if unit == selected_unit:
		selected_unit = null

	selection_changed.emit(selected_units)


func _deselect_all() -> void:
	## Clear all selections.
	for unit in selected_units:
		if is_instance_valid(unit) and unit.has_method("deselect"):
			unit.deselect()

	selected_units.clear()
	selected_unit = null

	# Clear camera focus target
	if camera and camera.has_method("clear_focus_target"):
		camera.clear_focus_target()

	selection_changed.emit(selected_units)


func _finish_box_selection() -> void:
	## Select all units within the selection box.
	var add_to_selection := Input.is_key_pressed(KEY_SHIFT)

	# Calculate selection rectangle
	var rect := Rect2(
		min(box_start.x, box_current.x),
		min(box_start.y, box_current.y),
		abs(box_current.x - box_start.x),
		abs(box_current.y - box_start.y)
	)

	# Find all selectable units in the box
	var units_in_box: Array[Node] = []
	var all_units := get_tree().get_nodes_in_group("survivors")
	all_units.append_array(get_tree().get_nodes_in_group("selectable_units"))

	# Remove duplicates
	var unique_units: Array[Node] = []
	for unit in all_units:
		if unit not in unique_units:
			unique_units.append(unit)

	for unit in unique_units:
		if not is_instance_valid(unit):
			continue

		# Project unit position to screen
		var screen_pos := camera.unproject_position(unit.global_position)

		if rect.has_point(screen_pos):
			units_in_box.append(unit)

	# Apply selection
	if not add_to_selection:
		_deselect_all()

	for unit in units_in_box:
		_add_to_selection(unit)

	print("[RTSInput] Box selected %d units" % units_in_box.size())


func _select_all_units() -> void:
	## Select all selectable units in the scene.
	_deselect_all()

	var all_units := get_tree().get_nodes_in_group("survivors")
	all_units.append_array(get_tree().get_nodes_in_group("selectable_units"))

	# Remove duplicates
	var unique_units: Array[Node] = []
	for unit in all_units:
		if unit not in unique_units:
			unique_units.append(unit)

	for unit in unique_units:
		if is_instance_valid(unit):
			_add_to_selection(unit)

	print("[RTSInput] Selected all %d units" % selected_units.size())


func _show_move_indicator(position: Vector3) -> void:
	## Visual feedback for move command (optional).
	# TODO: Add a visual indicator (particle, decal, etc.)
	pass


## --- Public API ---

func get_selected_unit() -> ClickableUnit:
	## Legacy: Get single selected ClickableUnit.
	return selected_unit


func get_selected_units() -> Array[Node]:
	## Get all selected units.
	return selected_units


func get_selection_count() -> int:
	return selected_units.size()


func has_selection() -> bool:
	return not selected_units.is_empty()


func get_selection_center() -> Vector3:
	## Get center position of all selected units.
	if selected_units.is_empty():
		return Vector3.ZERO

	var total := Vector3.ZERO
	for unit in selected_units:
		if is_instance_valid(unit):
			total += unit.global_position

	return total / selected_units.size()


func get_box_selection_rect() -> Rect2:
	## Get current box selection rectangle (for UI drawing).
	if not is_box_selecting:
		return Rect2()

	return Rect2(
		min(box_start.x, box_current.x),
		min(box_start.y, box_current.y),
		abs(box_current.x - box_start.x),
		abs(box_current.y - box_start.y)
	)
