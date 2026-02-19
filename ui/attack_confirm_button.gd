extends Control
class_name AttackConfirmButton
## Confirmation button for attacking non-hostile human targets.
## Appears above the target unit when player holds right-click on a survivor.

signal attack_confirmed(target: Node3D)

var _target: Node3D = null
var _camera: Camera3D = null

@export var world_height_offset: float = 2.5
@export var screen_offset: Vector2 = Vector2(0, -20)

@onready var panel: Panel = $Panel
@onready var attack_button: Button = $Panel/AttackButton


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP

	if attack_button:
		attack_button.pressed.connect(_on_attack_pressed)


func _process(_delta: float) -> void:
	if visible and _target and _camera:
		_update_position()


func show_at(_screen_position: Vector2, target: Node3D) -> void:
	## Show the attack button above the target unit.
	if not target or not is_instance_valid(target):
		return

	_target = target
	_camera = get_viewport().get_camera_3d()

	_update_position()
	visible = true

	if attack_button:
		attack_button.grab_focus()


func _update_position() -> void:
	## Position panel above the target in screen space.
	if not _target or not _camera:
		return

	var world_pos: Vector3 = _target.global_position + Vector3(0, world_height_offset, 0)

	if not _camera.is_position_in_frustum(world_pos):
		visible = false
		return

	var screen_pos: Vector2 = _camera.unproject_position(world_pos)
	var panel_size: Vector2 = panel.size if panel else size

	position = screen_pos - panel_size / 2.0 + screen_offset

	# Clamp to viewport
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, 0, viewport_size.y - panel_size.y)


func hide_button() -> void:
	## Hide the button and clear target reference.
	visible = false
	_target = null


func _on_attack_pressed() -> void:
	## Called when attack button is clicked.
	if _target and is_instance_valid(_target):
		attack_confirmed.emit(_target)
	hide_button()


func _input(event: InputEvent) -> void:
	if not visible:
		return

	# Hide on right-click release
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_RIGHT and not mouse.pressed:
			hide_button()
