class_name ButcherPanel extends Control
## Confirmation panel for butchering a dead unit's corpse.
## Shows [YES]/[NO] buttons. YES is only enabled if the butcher has a hatchet.

signal closed
signal butcher_confirmed(corpse: Node3D)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var prompt_label: Label = $Panel/MarginContainer/VBoxContainer/PromptLabel
@onready var status_label: Label = $Panel/MarginContainer/VBoxContainer/StatusLabel
@onready var yes_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/YesButton
@onready var no_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/NoButton

var _current_corpse: Node3D = null
var _camera: Camera3D = null
var _butcher_has_axe: bool = false

@export var world_height_offset: float = 3.0
@export var screen_offset: Vector2 = Vector2(0, -20)


func _ready() -> void:
	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_corpse and _camera:
		_update_panel_position()


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


func show_for_corpse(corpse: Node3D, butcher_has_axe: bool, camera: Camera3D = null) -> void:
	## Display the butcher confirmation for a dead unit.
	if not corpse or not is_instance_valid(corpse):
		return
	_current_corpse = corpse
	_butcher_has_axe = butcher_has_axe
	_camera = camera if camera else get_viewport().get_camera_3d()
	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	_current_corpse = null
	visible = false
	closed.emit()


func _update_panel_position() -> void:
	## Position panel near the corpse in screen space.
	if not _current_corpse or not _camera:
		return
	var world_pos: Vector3 = _current_corpse.global_position + Vector3(0, world_height_offset, 0)
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
	if not _current_corpse or not is_instance_valid(_current_corpse):
		hide_panel()
		return
	title_label.text = "BUTCHER"
	var corpse_name: String = _current_corpse.unit_name if "unit_name" in _current_corpse else "this unit"
	prompt_label.text = "Do you really want to butcher %s?" % corpse_name
	yes_button.disabled = not _butcher_has_axe
	if _butcher_has_axe:
		status_label.text = ""
	else:
		status_label.text = "Need hatchet"


func _on_yes_pressed() -> void:
	if not _current_corpse or not is_instance_valid(_current_corpse):
		return
	var corpse_ref: Node3D = _current_corpse
	hide_panel()
	butcher_confirmed.emit(corpse_ref)


func _on_no_pressed() -> void:
	hide_panel()


func _is_point_in_panel(point: Vector2) -> bool:
	if not panel:
		return false
	var panel_rect := Rect2(panel.global_position, panel.size)
	return panel_rect.has_point(point)
