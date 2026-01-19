class_name SledPanel extends Control
## UI panel for sled interaction - allows attaching selected units to pull the sled.
## Shows when right-clicking a sled with unit(s) selected.
## Positions itself near the sled in screen space.

signal closed
signal unit_attached(unit: Node, sled: Node)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var attach_button: Button = $Panel/MarginContainer/VBoxContainer/AttachButton
@onready var detach_button: Button = $Panel/MarginContainer/VBoxContainer/DetachButton
@onready var status_label: Label = $Panel/MarginContainer/VBoxContainer/StatusLabel

var _current_sled: Node = null
var _selected_units: Array[Node] = []
var _camera: Camera3D = null
var _input_handler: Node = null

## Height offset above sled in world units
@export var world_height_offset: float = 2.5
## Screen space offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)


func _ready() -> void:
	# Connect button signals
	attach_button.pressed.connect(_on_attach_pressed)
	detach_button.pressed.connect(_on_detach_pressed)

	# Start hidden
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_sled and _camera:
		_update_panel_position()
		_update_status()


func _input(event: InputEvent) -> void:
	# Close panel on Escape or another right-click
	if visible:
		if event.is_action_pressed("ui_cancel"):
			hide_panel()
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseButton:
			var mouse := event as InputEventMouseButton
			# Close on any click outside the panel
			if mouse.pressed and not _is_point_in_panel(mouse.position):
				hide_panel()


func _is_point_in_panel(point: Vector2) -> bool:
	## Check if a screen point is inside the panel bounds.
	if not panel:
		return false
	var panel_rect := Rect2(panel.global_position, panel.size)
	return panel_rect.has_point(point)


func show_for_sled(sled: Node, selected_units: Array[Node], camera: Camera3D = null) -> void:
	## Display the sled interaction panel for the given sled.
	if not sled:
		return

	_current_sled = sled
	_selected_units = selected_units

	if camera:
		_camera = camera
	else:
		_camera = get_viewport().get_camera_3d()

	# Find input handler for selection tracking
	var root := get_tree().current_scene
	if root:
		_input_handler = root.get_node_or_null("RTSInputHandler")

	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the sled panel.
	_current_sled = null
	_selected_units.clear()
	visible = false
	closed.emit()


func _update_panel_position() -> void:
	## Position panel near the sled in screen space.
	if not _current_sled or not _camera:
		return

	var world_pos: Vector3 = _current_sled.global_position + Vector3(0, world_height_offset, 0)

	if not _camera.is_position_in_frustum(world_pos):
		visible = false
		return

	var screen_pos: Vector2 = _camera.unproject_position(world_pos)
	var panel_size: Vector2 = panel.size
	position = screen_pos - panel_size / 2.0 + screen_offset

	# Clamp to screen bounds
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, 0, viewport_size.y - panel_size.y)


func _update_display() -> void:
	## Update the panel content based on selected units and sled state.
	if not _current_sled:
		return

	# Update title with sled info
	var pullers_count: int = 0
	var max_pullers: int = 4
	if "pullers" in _current_sled:
		pullers_count = _current_sled.pullers.size()
	if "max_pullers" in _current_sled:
		max_pullers = _current_sled.max_pullers

	title_label.text = "Sled (%d/%d pullers)" % [pullers_count, max_pullers]

	# Update buttons based on selection
	_update_buttons()


func _update_buttons() -> void:
	## Update attach/detach button visibility and text based on selection.
	if _selected_units.is_empty():
		attach_button.visible = false
		detach_button.visible = false
		return

	# Check how many selected units can attach vs are already attached
	var can_attach: Array[Node] = []
	var already_attached: Array[Node] = []

	for unit in _selected_units:
		if not is_instance_valid(unit):
			continue
		if "attached_sled" in unit and unit.attached_sled == _current_sled:
			already_attached.append(unit)
		elif "attached_sled" in unit and unit.attached_sled == null:
			can_attach.append(unit)

	# Show attach button if any unit can attach
	if can_attach.size() > 0:
		attach_button.visible = true
		if can_attach.size() == 1:
			var unit_name: String = can_attach[0].unit_name if "unit_name" in can_attach[0] else "Unit"
			attach_button.text = "Attach %s to sled" % unit_name
		else:
			attach_button.text = "Attach %d units to sled" % can_attach.size()
	else:
		attach_button.visible = false

	# Show detach button if any unit is already attached
	if already_attached.size() > 0:
		detach_button.visible = true
		if already_attached.size() == 1:
			var unit_name: String = already_attached[0].unit_name if "unit_name" in already_attached[0] else "Unit"
			detach_button.text = "Detach %s from sled" % unit_name
		else:
			detach_button.text = "Detach %d units from sled" % already_attached.size()
	else:
		detach_button.visible = false


func _update_status() -> void:
	## Update status label with sled info (cargo weight, etc).
	if not _current_sled or not status_label:
		return

	var status_parts: Array[String] = []

	# Cargo info
	if _current_sled.has_method("get_cargo_weight") and _current_sled.has_method("get_total_weight"):
		var cargo: float = _current_sled.get_cargo_weight()
		var max_cargo: float = _current_sled.max_cargo_weight if "max_cargo_weight" in _current_sled else 500.0
		if cargo > 0:
			status_parts.append("Cargo: %.0f/%.0f kg" % [cargo, max_cargo])

	# Lead puller info
	if "lead_puller" in _current_sled and _current_sled.lead_puller:
		var lead_name: String = _current_sled.lead_puller.unit_name if "unit_name" in _current_sled.lead_puller else "Unknown"
		status_parts.append("Lead: %s" % lead_name)

	status_label.text = "\n".join(status_parts) if status_parts.size() > 0 else ""


func _on_attach_pressed() -> void:
	## Attach selected units to the sled.
	if not _current_sled:
		return

	var attached_count: int = 0
	for unit in _selected_units:
		if not is_instance_valid(unit):
			continue
		# Skip units already attached to something
		if "attached_sled" in unit and unit.attached_sled != null:
			continue

		if unit.has_method("attach_to_sled"):
			if unit.attach_to_sled(_current_sled):
				attached_count += 1
				unit_attached.emit(unit, _current_sled)

	if attached_count > 0:
		print("[SledPanel] Attached %d units to sled" % attached_count)

	_update_display()


func _on_detach_pressed() -> void:
	## Detach selected units from the sled.
	if not _current_sled:
		return

	var detached_count: int = 0
	for unit in _selected_units:
		if not is_instance_valid(unit):
			continue
		# Only detach if attached to this sled
		if "attached_sled" in unit and unit.attached_sled == _current_sled:
			if unit.has_method("detach_from_sled"):
				unit.detach_from_sled()
				detached_count += 1

	if detached_count > 0:
		print("[SledPanel] Detached %d units from sled" % detached_count)

	_update_display()
