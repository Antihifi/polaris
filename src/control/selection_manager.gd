extends Node
## Singleton managing selection of survivors and other selectable entities.
## Access via SelectionManager autoload.

signal selection_changed(selected: Array[Survivor])
signal survivor_selected(survivor: Survivor)
signal survivor_deselected(survivor: Survivor)
signal group_assigned(group_number: int, survivors: Array[Survivor])

# Currently selected survivors
var selected_survivors: Array[Survivor] = []

# Control groups (1-9)
var control_groups: Dictionary = {}  # {group_number: Array[Survivor]}

# Selection box (for drag selection)
var selection_box_start: Vector2 = Vector2.ZERO
var is_dragging_selection: bool = false

# Layer for raycasting
const SURVIVOR_COLLISION_LAYER: int = 2


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

func select(survivor: Survivor, add_to_selection: bool = false) -> void:
	## Select a single survivor. If add_to_selection is true, adds to current selection.
	if not add_to_selection:
		clear_selection()

	if survivor not in selected_survivors:
		selected_survivors.append(survivor)
		survivor.select()
		survivor_selected.emit(survivor)

	selection_changed.emit(selected_survivors)


func deselect(survivor: Survivor) -> void:
	## Remove a survivor from selection.
	if survivor in selected_survivors:
		selected_survivors.erase(survivor)
		survivor.deselect()
		survivor_deselected.emit(survivor)
		selection_changed.emit(selected_survivors)


func clear_selection() -> void:
	## Deselect all survivors.
	for survivor in selected_survivors:
		survivor.deselect()
		survivor_deselected.emit(survivor)

	selected_survivors.clear()
	selection_changed.emit(selected_survivors)


func select_multiple(survivors: Array[Survivor], add_to_selection: bool = false) -> void:
	## Select multiple survivors at once.
	if not add_to_selection:
		clear_selection()

	for survivor in survivors:
		if survivor not in selected_survivors:
			selected_survivors.append(survivor)
			survivor.select()
			survivor_selected.emit(survivor)

	selection_changed.emit(selected_survivors)


func select_all() -> void:
	## Select all survivors in the scene.
	var all_survivors := get_tree().get_nodes_in_group("survivors")
	var typed_survivors: Array[Survivor] = []
	for node in all_survivors:
		if node is Survivor:
			typed_survivors.append(node as Survivor)
	select_multiple(typed_survivors)


func toggle_selection(survivor: Survivor) -> void:
	## Toggle selection state of a survivor.
	if survivor in selected_survivors:
		deselect(survivor)
	else:
		select(survivor, true)


# --- Control Groups ---

func assign_control_group(group_number: int) -> void:
	## Assign currently selected survivors to a control group.
	if group_number < 1 or group_number > 9:
		return

	control_groups[group_number] = selected_survivors.duplicate()
	group_assigned.emit(group_number, control_groups[group_number])


func recall_control_group(group_number: int) -> void:
	## Select all survivors in a control group.
	if group_number < 1 or group_number > 9:
		return

	var group: Array = control_groups[group_number]
	if group.is_empty():
		return

	# Filter out dead or removed survivors
	var valid_survivors: Array[Survivor] = []
	for survivor in group:
		if is_instance_valid(survivor) and survivor.current_state != Survivor.State.DEAD:
			valid_survivors.append(survivor)

	control_groups[group_number] = valid_survivors
	select_multiple(valid_survivors)


func get_control_group(group_number: int) -> Array[Survivor]:
	## Get survivors in a control group.
	if group_number < 1 or group_number > 9:
		return []
	return control_groups[group_number]


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
	## Finish box selection and select survivors within the box.
	is_dragging_selection = false

	if selection_rect.size.length() < 5.0:
		# Too small, treat as a click
		return

	var survivors_in_box: Array[Survivor] = []
	var all_survivors := get_tree().get_nodes_in_group("survivors")

	for node in all_survivors:
		if node is Survivor:
			var survivor := node as Survivor
			var screen_pos := camera.unproject_position(survivor.global_position)
			if selection_rect.has_point(screen_pos):
				survivors_in_box.append(survivor)

	if not survivors_in_box.is_empty():
		select_multiple(survivors_in_box, add_to_selection)


# --- Raycast Selection ---

func try_select_at_position(camera: Camera3D, screen_position: Vector2, add_to_selection: bool = false) -> bool:
	## Attempt to select a survivor at the given screen position using raycast.
	## Returns true if a survivor was selected.
	var from := camera.project_ray_origin(screen_position)
	var to := from + camera.project_ray_normal(screen_position) * 1000.0

	var space_state := camera.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to, SURVIVOR_COLLISION_LAYER)
	var result := space_state.intersect_ray(query)

	if result.is_empty():
		if not add_to_selection:
			clear_selection()
		return false

	var collider: Object = result.collider
	if collider is Survivor:
		select(collider as Survivor, add_to_selection)
		return true

	# Check parent in case we hit a child collider
	var parent: Node = collider.get_parent()
	if parent is Survivor:
		select(parent as Survivor, add_to_selection)
		return true

	if not add_to_selection:
		clear_selection()

	return false


# --- Utility ---

func get_selected_count() -> int:
	return selected_survivors.size()


func has_selection() -> bool:
	return not selected_survivors.is_empty()


func get_first_selected() -> Survivor:
	if selected_survivors.is_empty():
		return null
	return selected_survivors[0]


func get_selection_center() -> Vector3:
	## Get the center position of all selected survivors.
	if selected_survivors.is_empty():
		return Vector3.ZERO

	var total := Vector3.ZERO
	for survivor in selected_survivors:
		total += survivor.global_position

	return total / selected_survivors.size()


func command_selected_to_move(target_position: Vector3) -> void:
	## Command all selected survivors to move to a position.
	if selected_survivors.is_empty():
		return

	# Simple formation: spread out around target
	var count := selected_survivors.size()
	if count == 1:
		selected_survivors[0].move_to(target_position)
	else:
		var spacing := 1.5
		var angle_step := TAU / count
		for i in range(count):
			var offset := Vector3(
				cos(angle_step * i) * spacing,
				0,
				sin(angle_step * i) * spacing
			)
			selected_survivors[i].move_to(target_position + offset)
