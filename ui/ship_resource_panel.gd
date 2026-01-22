class_name ShipResourcePanel extends Control
## UI panel for ship resource display - shows available materials when right-clicking the ship.
## Positions itself near the ship in screen space.

signal closed

@onready var panel: Panel = $ShipResourcePanel
@onready var title_label: Label = $ShipResourcePanel/MarginContainer/VBoxContainer/TitleLabel
@onready var resource_grid: GridContainer = $ShipResourcePanel/MarginContainer/VBoxContainer/ResourceGrid
@onready var close_button: Button = $ShipResourcePanel/MarginContainer/VBoxContainer/CloseButton

var _current_ship: Node = null
var _ship_resource: ShipResourceComponent = null
var _camera: Camera3D = null

## Height offset above ship in world units.
@export var world_height_offset: float = 15.0
## Screen space offset to nudge panel position.
@export var screen_offset: Vector2 = Vector2(0, -20)

## Display names for materials.
const MATERIAL_NAMES: Dictionary = {
	"scrap_wood": "Scrap Wood",
	"nails": "Nails",
	"coal": "Coal",
	"hard_tack": "Hard Tack",
	"salt_pork": "Salt Pork",
	"pemmican": "Pemmican",
	"tinned_meat": "Tinned Meat",
	"rum": "Rum"
}


func _ready() -> void:
	# Connect close button.
	if close_button:
		close_button.pressed.connect(hide_panel)

	# Start hidden.
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_ship and _camera:
		_update_panel_position()


func _input(event: InputEvent) -> void:
	# Close panel on Escape or click outside.
	if visible:
		if event.is_action_pressed("ui_cancel"):
			hide_panel()
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseButton:
			var mouse := event as InputEventMouseButton
			# Close on any click outside the panel.
			if mouse.pressed and not _is_point_in_panel(mouse.position):
				hide_panel()


func _is_point_in_panel(point: Vector2) -> bool:
	## Check if a screen point is inside the panel bounds.
	if not panel:
		return false
	var panel_rect := Rect2(panel.global_position, panel.size)
	return panel_rect.has_point(point)


func show_for_ship(ship: Node) -> void:
	## Show the panel for a specific ship.
	_current_ship = ship
	_camera = get_viewport().get_camera_3d()

	# Find ship resource component.
	_ship_resource = _find_ship_resource(ship)

	if not _ship_resource:
		push_warning("ShipResourcePanel: No ShipResourceComponent found on ship")
		return

	# Update display.
	_update_resource_display()

	# Position and show.
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the panel.
	visible = false
	_current_ship = null
	_ship_resource = null
	closed.emit()


func _find_ship_resource(ship: Node) -> ShipResourceComponent:
	## Find ShipResourceComponent on ship or its children.
	if ship is ShipResourceComponent:
		return ship as ShipResourceComponent

	for child in ship.get_children():
		if child is ShipResourceComponent:
			return child as ShipResourceComponent

	return null


func _update_resource_display() -> void:
	## Update the resource labels to show current amounts.
	if not _ship_resource or not resource_grid:
		return

	# Clear existing labels.
	for child in resource_grid.get_children():
		child.queue_free()

	# Get all materials and display them.
	var materials := _ship_resource.get_all_available()
	for mat_id: String in materials:
		var amount: int = materials[mat_id]

		# Create label for material name.
		var name_label := Label.new()
		name_label.text = MATERIAL_NAMES.get(mat_id, mat_id.capitalize())
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		resource_grid.add_child(name_label)

		# Create label for amount.
		var amount_label := Label.new()
		amount_label.text = str(amount)
		amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		if amount <= 0:
			amount_label.modulate = Color(1, 0.3, 0.3)  # Red for depleted.
		elif amount < 50:
			amount_label.modulate = Color(1, 0.8, 0.3)  # Yellow for low.
		resource_grid.add_child(amount_label)


func _update_panel_position() -> void:
	## Position the panel in screen space near the ship.
	if not _current_ship or not _camera or not panel:
		return
	if not _current_ship is Node3D:
		return

	var ship_pos: Vector3 = (_current_ship as Node3D).global_position + Vector3.UP * world_height_offset
	var screen_pos := _camera.unproject_position(ship_pos)

	# Center panel horizontally on the point.
	var half_width := panel.size.x * 0.5
	screen_pos.x -= half_width
	screen_pos += screen_offset

	# Clamp to viewport bounds.
	var viewport_size := get_viewport().get_visible_rect().size
	screen_pos.x = clampf(screen_pos.x, 0, viewport_size.x - panel.size.x)
	screen_pos.y = clampf(screen_pos.y, 0, viewport_size.y - panel.size.y)

	panel.global_position = screen_pos
