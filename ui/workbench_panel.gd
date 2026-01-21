class_name WorkbenchPanel extends Control
## UI panel for workbench interaction - allows crafting items with Scrap Wood.
## Shows when right-clicking a workbench.
## Positions itself near the workbench in screen space.

signal closed
signal item_crafted(item_id: String, cost: int)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var craft_grid: GridContainer = $Panel/MarginContainer/VBoxContainer/CraftGrid
@onready var status_label: Label = $Panel/MarginContainer/VBoxContainer/StatusLabel

# Craft buttons
@onready var sled_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/SledButton
@onready var tent_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/TentButton
@onready var crate_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/CrateButton
@onready var barrel_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/BarrelButton
@onready var firewood_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/FirewoodButton
@onready var upgrade_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/UpgradeButton

var _current_workbench: Node = null
var _camera: Camera3D = null

## Height offset above workbench in world units
@export var world_height_offset: float = 2.0
## Screen space offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)

## Crafting recipes: item_id -> wood_cost
const RECIPES: Dictionary = {
	"sled": 5,
	"tent_frame": 3,
	"crate": 2,
	"barrel": 1,
	"firewood": 1,
	"upgrade": 10
}


func _ready() -> void:
	# Connect button signals
	sled_button.pressed.connect(_on_craft_pressed.bind("sled"))
	tent_button.pressed.connect(_on_craft_pressed.bind("tent_frame"))
	crate_button.pressed.connect(_on_craft_pressed.bind("crate"))
	barrel_button.pressed.connect(_on_craft_pressed.bind("barrel"))
	firewood_button.pressed.connect(_on_craft_pressed.bind("firewood"))
	upgrade_button.pressed.connect(_on_craft_pressed.bind("upgrade"))

	# Start hidden
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_workbench and _camera:
		_update_panel_position()


func _input(event: InputEvent) -> void:
	# Close panel on Escape or click outside
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


func show_for_workbench(workbench: Node, camera: Camera3D = null) -> void:
	## Display the workbench panel for the given workbench.
	if not workbench:
		return

	_current_workbench = workbench

	if camera:
		_camera = camera
	else:
		_camera = get_viewport().get_camera_3d()

	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the workbench panel.
	_current_workbench = null
	visible = false
	closed.emit()


func _update_panel_position() -> void:
	## Position panel near the workbench in screen space.
	if not _current_workbench or not _camera:
		return

	var world_pos: Vector3 = _current_workbench.global_position + Vector3(0, world_height_offset, 0)

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
	## Update the panel content.
	if not _current_workbench:
		return

	title_label.text = "Workbench"

	# TODO: Get wood count from nearby containers or unit inventories
	var wood_count: int = _get_available_wood()
	status_label.text = "Scrap Wood: %d" % wood_count

	_update_buttons(wood_count)


func _update_buttons(wood_count: int) -> void:
	## Enable/disable buttons based on available wood.
	sled_button.disabled = wood_count < RECIPES["sled"]
	tent_button.disabled = wood_count < RECIPES["tent_frame"]
	crate_button.disabled = wood_count < RECIPES["crate"]
	barrel_button.disabled = wood_count < RECIPES["barrel"]
	firewood_button.disabled = wood_count < RECIPES["firewood"]
	upgrade_button.disabled = wood_count < RECIPES["upgrade"]


func _get_available_wood() -> int:
	## Get total scrap wood available from nearby containers and unit inventories.
	## For now, returns a placeholder value. Full implementation will check:
	## - Containers in "containers" group within workbench radius
	## - Selected units' inventories
	## - Workbench's own storage (if any)

	# TODO: Implement actual inventory checking
	# Placeholder: return 10 for testing
	return 10


func _on_craft_pressed(item_id: String) -> void:
	## Handle craft button press.
	var cost: int = RECIPES.get(item_id, 0)
	var available: int = _get_available_wood()

	if available < cost:
		print("[WorkbenchPanel] Not enough wood for %s (need %d, have %d)" % [item_id, cost, available])
		return

	print("[WorkbenchPanel] Crafting %s (cost: %d wood)" % [item_id, cost])
	item_crafted.emit(item_id, cost)

	# TODO: Consume wood from inventory
	# TODO: Spawn crafted item

	_update_display()
