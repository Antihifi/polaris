extends Node
## Singleton managing selection of units and other selectable entities.
## Access via SelectionManager autoload.

signal selection_changed(selected: Array[Node])
signal unit_selected(unit: Node)
signal unit_deselected(unit: Node)
signal group_assigned(group_number: int, units: Array[Node])

# Currently selected units
var selected_units: Array[Node] = []

# Control groups (1-9)
var control_groups: Dictionary = {}  # {group_number: Array[Node]}

# Selection box (for drag selection)
var selection_box_start: Vector2 = Vector2.ZERO
var is_dragging_selection: bool = false

# Layer for raycasting
const UNIT_COLLISION_LAYER: int = 2


func _ready() -> void:
	# Initialize control groups
	for i in range(1, 10):
		control_groups[i] = []


func _unhandled_input(event: InputEvent) -> void:
	# Handle control group assignment and recall
	if event is InputEventKey and event.pressed:
		var key := event as InputEventKey
		var number := _get_number_from_keycode(key.keycode)

		if number > 0 and number <= 9:
			if Input.is_key_pressed(KEY_CTRL):
				# Ctrl+Number: Assign current selection to group
				assign_control_group(number)
			else:
				# Number: Recall control group
				recall_control_group(number)


func _get_number_from_keycode(keycode: Key) -> int:
	match keycode:
		KEY_1: return 1
		KEY_2: return 2
		KEY_3: return 3
		KEY_4: return 4
		KEY_5: return 5
		KEY_6: return 6
		KEY_7: return 7
		KEY_8: return 8
		KEY_9: return 9
		_: return 0


# --- Selection Methods ---

func select(unit: Node, add_to_selection: bool = false) -> void:
	## Select a single unit. If add_to_selection is true, adds to current selection.
	if not add_to_selection:
		clear_selection()

	if unit not in selected_units:
		selected_units.append(unit)
		if unit.has_method("select"):
			unit.select()
		unit_selected.emit(unit)

	selection_changed.emit(selected_units)


func deselect(unit: Node) -> void:
	## Remove a unit from selection.
	if unit in selected_units:
		selected_units.erase(unit)
		if unit.has_method("deselect"):
			unit.deselect()
		unit_deselected.emit(unit)
		selection_changed.emit(selected_units)


func clear_selection() -> void:
	## Deselect all units.
	for unit in selected_units:
		if unit.has_method("deselect"):
			unit.deselect()
		unit_deselected.emit(unit)

	selected_units.clear()
	selection_changed.emit(selected_units)


func select_multiple(units: Array[Node], add_to_selection: bool = false) -> void:
	## Select multiple units at once.
	if not add_to_selection:
		clear_selection()

	for unit in units:
		if unit not in selected_units:
			selected_units.append(unit)
			if unit.has_method("select"):
				unit.select()
			unit_selected.emit(unit)

	selection_changed.emit(selected_units)


func select_all() -> void:
	## Select all units in the scene.
	var all_units := get_tree().get_nodes_in_group("survivors")
	all_units.append_array(get_tree().get_nodes_in_group("selectable_units"))

	# Remove duplicates
	var unique_units: Array[Node] = []
	for node in all_units:
		if node not in unique_units and is_instance_valid(node):
			unique_units.append(node)

	select_multiple(unique_units)


func toggle_selection(unit: Node) -> void:
	## Toggle selection state of a unit.
	if unit in selected_units:
		deselect(unit)
	else:
		select(unit, true)


# --- Control Groups ---

func assign_control_group(group_number: int) -> void:
	## Assign currently selected units to a control group.
	if group_number < 1 or group_number > 9:
		return

	control_groups[group_number] = selected_units.duplicate()
	group_assigned.emit(group_number, control_groups[group_number])


func recall_control_group(group_number: int) -> void:
	## Select all units in a control group.
	if group_number < 1 or group_number > 9:
		return

	var group: Array = control_groups[group_number]
	if group.is_empty():
		return

	# Filter out dead or removed units
	var valid_units: Array[Node] = []
	for unit in group:
		if is_instance_valid(unit):
			# Check if unit is dead (if it has stats)
			var is_dead := false
			if "stats" in unit and unit.stats and unit.stats.has_method("is_dead"):
				is_dead = unit.stats.is_dead()
			if not is_dead:
				valid_units.append(unit)

	control_groups[group_number] = valid_units
	select_multiple(valid_units)


func get_control_group(group_number: int) -> Array[Node]:
	## Get units in a control group.
	if group_number < 1 or group_number > 9:
		return []

	var result: Array[Node] = []
	for unit in control_groups[group_number]:
		result.append(unit)
	return result


# --- Box Selection ---

func start_box_selection(screen_position: Vector2) -> void:
	## Begin drag selection.
	selection_box_start = screen_position
	is_dragging_selection = true


func update_box_selection(current_position: Vector2) -> Rect2:
	## Update and return the selection box rectangle.
	if not is_dragging_selection:
		return Rect2()

	var top_left := Vector2(
		min(selection_box_start.x, current_position.x),
		min(selection_box_start.y, current_position.y)
	)
	var size := Vector2(
		abs(current_position.x - selection_box_start.x),
		abs(current_position.y - selection_box_start.y)
	)

	return Rect2(top_left, size)


func finish_box_selection(camera: Camera3D, selection_rect: Rect2, add_to_selection: bool = false) -> void:
	## Finish box selection and select units within the box.
	is_dragging_selection = false

	if selection_rect.size.length() < 5.0:
		# Too small, treat as a click
		return

	var units_in_box: Array[Node] = []
	var all_units := get_tree().get_nodes_in_group("survivors")
	all_units.append_array(get_tree().get_nodes_in_group("selectable_units"))

	for node in all_units:
		if node is Node3D:
			var screen_pos := camera.unproject_position(node.global_position)
			if selection_rect.has_point(screen_pos) and node not in units_in_box:
				units_in_box.append(node)

	if not units_in_box.is_empty():
		select_multiple(units_in_box, add_to_selection)


# --- Raycast Selection ---

func try_select_at_position(camera: Camera3D, screen_position: Vector2, add_to_selection: bool = false) -> bool:
	## Attempt to select a unit at the given screen position using raycast.
	## Returns true if a unit was selected.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to, UNIT_COLLISION_LAYER)
	var result := space_state.intersect_ray(query)

	if result.is_empty():
		if not add_to_selection:
			clear_selection()
		return false

	var collider: Object = result.collider

	# Check if collider is selectable
	if _is_selectable(collider):
		select(collider as Node, add_to_selection)
		return true

	# Check parent in case we hit a child collider
	var parent: Node = collider.get_parent()
	if _is_selectable(parent):
		select(parent, add_to_selection)
		return true

	if not add_to_selection:
		clear_selection()

	return false


func _is_selectable(node: Object) -> bool:
	## Check if a node is selectable (in survivors or selectable_units group).
	if not node is Node:
		return false
	var n := node as Node
	return n.is_in_group("survivors") or n.is_in_group("selectable_units")


# --- Utility ---

func get_selected_count() -> int:
	return selected_units.size()


func has_selection() -> bool:
	return not selected_units.is_empty()


func get_first_selected() -> Node:
	if selected_units.is_empty():
		return null
	return selected_units[0]


func get_selection_center() -> Vector3:
	## Get the center position of all selected units.
	if selected_units.is_empty():
		return Vector3.ZERO

	var total := Vector3.ZERO
	for unit in selected_units:
		if unit is Node3D:
			total += unit.global_position

	return total / selected_units.size()


func command_selected_to_move(target_position: Vector3) -> void:
	## Command all selected units to move to a position.
	if selected_units.is_empty():
		return

	# Simple formation: spread out around target
	var count := selected_units.size()
	if count == 1:
		if selected_units[0].has_method("move_to"):
			selected_units[0].move_to(target_position)
	else:
		var spacing := 1.5
		var angle_step := TAU / count
		for i in range(count):
			var offset := Vector3(
				cos(angle_step * i) * spacing,
				0,
				sin(angle_step * i) * spacing
			)
			if selected_units[i].has_method("move_to"):
				selected_units[i].move_to(target_position + offset)


# --- Legacy compatibility ---
# These properties/methods provide backwards compatibility for code using old names

var selected_survivors: Array[Node]:
	get:
		return selected_units
	set(value):
		selected_units = value
