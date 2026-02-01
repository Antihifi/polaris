extends Node
## Handles RTS-style input: click to select, right-click to move.
## Supports both single-select and multi-select modes for ClickableUnit.
## Attach to main scene or as child of camera.

@export var camera: Camera3D
@export var terrain_collision_mask: int = 1  # Layer for terrain/ground
@export var unit_collision_mask: int = 2     # Layer for selectable units
@export var container_collision_mask: int = 8  # Layer 4 for containers (1 << 3)
@export var sled_collision_mask: int = 16     # Layer 5 for vehicles/sleds
@export var workbench_collision_mask: int = 32  # Layer 6 for workbenches
@export var construction_site_collision_mask: int = 64  # Layer 7 for construction sites
@export var ship_collision_mask: int = 128  # Layer 8 for ships
@export var tent_collision_mask: int = 256  # Layer 9 for placed tents

## Enable multi-selection with shift-click and box select
@export var multi_select_enabled: bool = true

signal unit_double_clicked(unit: Node)
signal selection_changed(units: Array)
signal container_clicked(container: StorageContainer)
signal sled_clicked(sled: Node)
signal workbench_clicked(workbench: Node)
signal construction_site_clicked(site: Node)
signal ship_clicked(ship: Node)
signal tent_clicked(tent: Node)
signal corpse_clicked(corpse: Node)

# Single selection (legacy support)
var selected_unit: ClickableUnit = null

# Multi-selection for units
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

	# Check if it's a selectable unit (ClickableUnit)
	if hit is ClickableUnit:
		return hit as Node

	# Check parent in case we hit a child collider
	var parent: Node = hit.get_parent()
	if parent is ClickableUnit:
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


func _raycast_for_sled(screen_position: Vector2) -> Node:
	## Raycast to find a sled at screen position. Returns null if none found.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state
	var sled_query := PhysicsRayQueryParameters3D.create(from, to, sled_collision_mask)
	var sled_result := space_state.intersect_ray(sled_query)

	if sled_result.is_empty():
		return null

	var hit: Object = sled_result.collider

	# Check if it's a SledController directly
	if hit is RigidBody3D and hit.is_in_group("sleds"):
		return hit as Node

	# Check parent in case we hit a child collider
	if hit is Node:
		var parent: Node = (hit as Node).get_parent()
		if parent is RigidBody3D and parent.is_in_group("sleds"):
			return parent

	return null


func _raycast_for_workbench(screen_position: Vector2) -> Node:
	## Raycast to find a workbench at screen position. Returns null if none found.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state

	# Try workbench collision layer first
	var workbench_query := PhysicsRayQueryParameters3D.create(from, to, workbench_collision_mask)
	workbench_query.collide_with_areas = true
	workbench_query.collide_with_bodies = true
	var workbench_result := space_state.intersect_ray(workbench_query)

	if not workbench_result.is_empty():
		var hit: Object = workbench_result.collider
		if hit is Node:
			# Walk up parent chain to find workbench root (in "workbenches" group)
			var current: Node = hit as Node
			for i in range(5):
				if not current:
					break
				if current.is_in_group("workbenches"):
					return current
				current = current.get_parent()

	return null


func _raycast_for_construction_site(screen_position: Vector2) -> Node:
	## Raycast to find a construction site at screen position. Returns null if none found.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state

	# Try construction site collision layer first
	var site_query := PhysicsRayQueryParameters3D.create(from, to, construction_site_collision_mask)
	site_query.collide_with_areas = true
	site_query.collide_with_bodies = true
	var site_result := space_state.intersect_ray(site_query)

	if not site_result.is_empty():
		var hit: Object = site_result.collider
		if hit is Node:
			# Walk up parent chain to find construction site (in "construction_sites" group)
			var current: Node = hit as Node
			for i in range(5):
				if not current:
					break
				if current.is_in_group("construction_sites"):
					return current
				if current is ConstructionSite:
					return current
				current = current.get_parent()

	# Fallback: check construction_sites group via general raycast
	var general_query := PhysicsRayQueryParameters3D.create(from, to)
	general_query.collide_with_areas = true
	general_query.collide_with_bodies = true
	var general_result := space_state.intersect_ray(general_query)

	if not general_result.is_empty():
		var hit: Object = general_result.collider
		if hit is Node:
			var current: Node = hit as Node
			for i in range(5):
				if not current:
					break
				if current.is_in_group("construction_sites"):
					return current
				if current is ConstructionSite:
					return current
				current = current.get_parent()

	return null


func _raycast_for_tent(screen_position: Vector2) -> Node:
	## Raycast to find a placed tent at screen position. Returns null if none found.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0
	var space_state := camera.get_world_3d().direct_space_state

	var tent_query := PhysicsRayQueryParameters3D.create(from, to, tent_collision_mask)
	tent_query.collide_with_areas = true
	tent_query.collide_with_bodies = false
	var tent_result := space_state.intersect_ray(tent_query)

	if not tent_result.is_empty():
		var hit: Object = tent_result.collider
		if hit is Node:
			var current: Node = hit as Node
			for i in range(5):
				if not current:
					break
				if current.is_in_group("placed_tents"):
					return current
				current = current.get_parent()
	return null


func _raycast_for_ship(screen_position: Vector2) -> Node:
	## Raycast to find a ship at screen position. Returns null if none found.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state

	# Try ship collision layer first
	var ship_query := PhysicsRayQueryParameters3D.create(from, to, ship_collision_mask)
	ship_query.collide_with_areas = true
	ship_query.collide_with_bodies = true
	var ship_result := space_state.intersect_ray(ship_query)

	if not ship_result.is_empty():
		var hit: Object = ship_result.collider
		if hit is Node:
			# Walk up parent chain to find ship root (in "ship_resources" group)
			var current: Node = hit as Node
			for i in range(5):
				if not current:
					break
				if current.is_in_group("ship_resources"):
					return current
				current = current.get_parent()

	# Fallback: general raycast and check for ship_resources group
	var general_query := PhysicsRayQueryParameters3D.create(from, to)
	general_query.collide_with_areas = true
	general_query.collide_with_bodies = true
	var general_result := space_state.intersect_ray(general_query)

	if not general_result.is_empty():
		var hit: Object = general_result.collider
		if hit is Node:
			var current: Node = hit as Node
			for i in range(5):
				if not current:
					break
				if current.is_in_group("ship_resources"):
					return current
				current = current.get_parent()

	return null


func _try_assign_officer_to_site(site: Node) -> bool:
	## Try to assign selected officers to construction site.
	## Returns true if any officers were assigned.
	var assigned_any: bool = false

	for unit in selected_units:
		if not is_instance_valid(unit):
			continue

		# Check if unit is an officer or captain (rank > 0)
		if "rank" in unit:
			var rank: int = unit.rank
			# UnitRank.MAN = 0, OFFICER = 1, CAPTAIN = 2
			if rank > 0:
				# Move officer to site
				unit.move_to(site.global_position)
				_set_player_command_active(unit, true)
				print("[RTSInput] Assigned %s to construction site" % unit.name)
				assigned_any = true

				# Register with WorkManager if available
				var work_manager := _get_work_manager()
				if work_manager:
					work_manager.assign_worker(unit, 3, site)  # 3 = CONSTRUCTING

	return assigned_any


func _get_work_manager() -> Node:
	## Find the WorkManager autoload.
	if has_node("/root/WorkManager"):
		return get_node("/root/WorkManager")
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

	# Set camera focus (officers/captain only)
	var focus: Node = _get_focusable_unit(unit)
	if focus and camera and camera.has_method("set_focus_target"):
		camera.set_focus_target(focus)
		_update_camera_height(focus)

	# Emit double-click signal
	if is_double_click:
		unit_double_clicked.emit(unit)


func _handle_right_click(screen_position: Vector2) -> void:
	## Move selected unit(s) to clicked position on terrain.
	## If clicking on a sled with units selected, emit sled_clicked signal.
	## If clicking on a workbench, emit workbench_clicked signal.
	## If clicking on a construction site, emit construction_site_clicked or assign officer.
	## Non-lead sled pullers are filtered out - they follow their leader automatically.

	# Check if right-clicking on a dead unit (corpse)
	var clicked_corpse := _raycast_for_unit(screen_position)
	if clicked_corpse and clicked_corpse is ClickableUnit and (clicked_corpse as ClickableUnit).is_dead:
		corpse_clicked.emit(clicked_corpse)
		return

	# Check if right-clicking on a construction site
	var clicked_site := _raycast_for_construction_site(screen_position)
	if clicked_site:
		# If officer is selected, assign them to the site
		if has_selection():
			var officer_assigned := _try_assign_officer_to_site(clicked_site)
			if officer_assigned:
				return
		# Otherwise show site panel
		construction_site_clicked.emit(clicked_site)
		return

	# Check if right-clicking on a placed tent
	var clicked_tent := _raycast_for_tent(screen_position)
	if clicked_tent:
		tent_clicked.emit(clicked_tent)
		return

	# Check if right-clicking on a workbench
	var clicked_workbench := _raycast_for_workbench(screen_position)
	if clicked_workbench:
		workbench_clicked.emit(clicked_workbench)
		return

	# Check if right-clicking on a ship
	var clicked_ship := _raycast_for_ship(screen_position)
	if clicked_ship:
		ship_clicked.emit(clicked_ship)
		return

	# Check if right-clicking on a sled (only if we have units selected)
	if has_selection():
		var clicked_sled := _raycast_for_sled(screen_position)
		if clicked_sled:
			sled_clicked.emit(clicked_sled)
			return

	if selected_units.is_empty() and not selected_unit:
		print("[RTSInput] No units selected, ignoring right-click")
		return

	var target_position := _get_terrain_position(screen_position)
	if target_position == Vector3.INF:
		print("[RTSInput] Could not find valid terrain position")
		return

	# Filter out units that can't receive movement commands (non-lead sled pullers)
	var movable_units: Array[Node] = []
	for unit in selected_units:
		if unit.has_method("can_receive_move_command") and unit.can_receive_move_command():
			movable_units.append(unit)
		elif not unit.has_method("can_receive_move_command"):
			# Legacy units without the method can always move
			movable_units.append(unit)

	if movable_units.is_empty():
		print("[RTSInput] No movable units selected (non-lead sled pullers cannot be commanded)")
		return

	print("[RTSInput] Moving %d units to: %s" % [movable_units.size(), target_position])

	# Move all movable units in formation
	if movable_units.size() > 1:
		_move_units_in_formation(movable_units, target_position)
		# Set player command active for all units
		for unit in movable_units:
			_set_player_command_active(unit, true)
	elif movable_units.size() == 1:
		movable_units[0].move_to(target_position)
		_set_player_command_active(movable_units[0], true)
	elif selected_unit and (not selected_unit.has_method("can_receive_move_command") or selected_unit.can_receive_move_command()):
		# Legacy single selection (only if can receive commands)
		selected_unit.move_to(target_position)
		_set_player_command_active(selected_unit, true)

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

	# Method 1: Terrain3D CPU raymarching (bypasses physics, reliable on all slopes)
	# Uses Terrain3D's built-in get_intersection() which walks the ray against the
	# heightmap directly — no HeightMapShape3D physics bugs, no iterative convergence issues.
	if terrain_3d and terrain_3d.has_method("get_intersection"):
		var hit: Vector3 = terrain_3d.get_intersection(from, direction)
		if hit.z < 3.4e38 and not is_nan(hit.y):
			return hit

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

	# Clear camera focus target and height limit
	if camera and camera.has_method("clear_focus_target"):
		camera.clear_focus_target()
	if camera and "max_camera_height" in camera:
		camera.max_camera_height = 15.0
	if camera and "max_camera_distance" in camera:
		camera.max_camera_distance = 20.0

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

		# Skip undiscovered units - they cannot be selected until recruited
		if "is_discovered" in unit and not unit.is_discovered:
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

	# Focus camera on best officer/captain in selection
	var focus: Node = _get_focusable_unit(null)
	if focus and camera and camera.has_method("set_focus_target"):
		camera.set_focus_target(focus)
		_update_camera_height(focus)

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
			# Skip undiscovered units - they cannot be selected until recruited
			if "is_discovered" in unit and not unit.is_discovered:
				continue
			_add_to_selection(unit)

	print("[RTSInput] Selected all %d units" % selected_units.size())


func _show_move_indicator(position: Vector3) -> void:
	## Show destination indicator on movable selected units (skips dead/undiscovered).
	for unit in selected_units:
		if unit.has_method("show_destination_indicator") and unit.has_method("can_receive_move_command") and unit.can_receive_move_command():
			unit.show_destination_indicator(position)
	# Legacy single selection
	if selected_unit and selected_unit.has_method("show_destination_indicator"):
		if not selected_unit.has_method("can_receive_move_command") or selected_unit.can_receive_move_command():
			selected_unit.show_destination_indicator(position)


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


func _get_focusable_unit(preferred: Node) -> Node:
	## Return preferred if it's an officer/captain, else find the best one in selection.
	if preferred and "rank" in preferred and preferred.rank >= 1:
		return preferred
	var best: Node = null
	var best_rank: int = 0
	for unit in selected_units:
		if not is_instance_valid(unit):
			continue
		if "rank" in unit and unit.rank >= 1 and unit.rank > best_rank:
			best_rank = unit.rank
			best = unit
	return best


func _update_camera_height(unit: Node) -> void:
	## Compute max camera height from unit's navigation equipment and skill.
	if not camera or not "max_camera_height" in camera:
		return
	var height: float = 15.0
	if unit.has_method("has_item_by_id"):
		if unit.has_item_by_id("spyglass"):
			height += 10.0
		if unit.has_item_by_id("sextant"):
			height += 10.0
	if "stats" in unit and unit.stats and "navigation_skill" in unit.stats:
		height += unit.stats.navigation_skill * 0.05
	camera.max_camera_height = height


func _set_player_command_active(unit: Node, active: bool) -> void:
	## Set the player command flag on a unit's AI controller.
	## Also clears animation lock so unit can respond immediately.
	var ai_controller: Node = unit.get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("set_player_command_active"):
		ai_controller.set_player_command_active(active)

	# Clear animation lock so unit can move immediately
	# (otherwise unit stays frozen during BT waits until lock is released)
	if active and "is_animation_locked" in unit:
		unit.is_animation_locked = false
