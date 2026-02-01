class_name TentPanel extends Control
## UI panel for interacting with placed tents.
## Shows [Store Tent] button to pack tent into a nearby empty crate.

signal closed
signal tent_stored(tent: Node3D)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var status_label: Label = $Panel/MarginContainer/VBoxContainer/StatusLabel
@onready var store_button: Button = $Panel/MarginContainer/VBoxContainer/StoreButton

var _current_tent: Node3D = null
var _camera: Camera3D = null

@export var world_height_offset: float = 4.0
@export var screen_offset: Vector2 = Vector2(0, -20)

## Maximum distance to search for an empty crate.
const STORE_SEARCH_RADIUS: float = 10.0


func _ready() -> void:
	store_button.pressed.connect(_on_store_pressed)
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_tent and _camera:
		_update_panel_position()
		_update_display()


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_cancel"):
		hide_panel()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.pressed and not _is_point_in_panel(mouse.position):
			hide_panel()


func show_for_tent(tent: Node3D, camera: Camera3D = null) -> void:
	## Display the panel for a placed tent.
	if not tent or not is_instance_valid(tent):
		return
	_current_tent = tent
	_camera = camera if camera else get_viewport().get_camera_3d()
	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	_current_tent = null
	visible = false
	closed.emit()


func _update_panel_position() -> void:
	## Position panel near the tent in screen space.
	if not _current_tent or not _camera:
		return
	var world_pos: Vector3 = _current_tent.global_position + Vector3(0, world_height_offset, 0)
	if not _camera.is_position_in_frustum(world_pos):
		visible = false
		return
	var screen_pos: Vector2 = _camera.unproject_position(world_pos)
	var panel_size: Vector2 = panel.size
	position = screen_pos - panel_size / 2.0 + screen_offset
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, 0, viewport_size.y - panel_size.y)


func _update_display() -> void:
	if not _current_tent or not is_instance_valid(_current_tent):
		hide_panel()
		return
	title_label.text = "TENT"
	var crate: Node = _find_nearest_empty_crate()
	if crate:
		store_button.disabled = false
		status_label.text = "Empty crate within range"
	else:
		store_button.disabled = true
		status_label.text = "No empty crate within %dm" % int(STORE_SEARCH_RADIUS)


func _on_store_pressed() -> void:
	## Pack the tent into the nearest empty crate.
	if not _current_tent or not is_instance_valid(_current_tent):
		return
	var crate_node: Node = _find_nearest_empty_crate()
	if not crate_node:
		return
	var storage: StorageContainer = crate_node.get_node_or_null("StorageContainer")
	if not storage:
		return
	var item: InventoryItem = storage.add_item_by_id("tent")
	if item:
		var tent_ref: Node3D = _current_tent
		hide_panel()
		tent_ref.queue_free()
		tent_stored.emit(tent_ref)
		print("[TentPanel] Stored tent in %s" % storage.display_name)


func _find_nearest_empty_crate() -> Node:
	## Find nearest crate with zero items within STORE_SEARCH_RADIUS.
	if not _current_tent:
		return null
	var tent_pos: Vector3 = _current_tent.global_position
	var crates: Array = get_tree().get_nodes_in_group("crates")
	var best_crate: Node = null
	var best_dist: float = STORE_SEARCH_RADIUS + 1.0
	for crate in crates:
		if not is_instance_valid(crate) or not crate is Node3D:
			continue
		var dist: float = (crate as Node3D).global_position.distance_to(tent_pos)
		if dist > STORE_SEARCH_RADIUS:
			continue
		var storage: StorageContainer = crate.get_node_or_null("StorageContainer")
		if not storage:
			continue
		if storage.get_item_count() == 0 and dist < best_dist:
			best_dist = dist
			best_crate = crate
	return best_crate


func _is_point_in_panel(point: Vector2) -> bool:
	if not panel:
		return false
	var panel_rect := Rect2(panel.global_position, panel.size)
	return panel_rect.has_point(point)
