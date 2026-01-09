class_name InventoryHUD extends CanvasLayer
## Manages inventory UI panels for containers and units.
## Handles "I" key to toggle unit inventory.
## Panels follow their attached objects in screen space.

const InventoryPanelScript: Script = preload("res://ui/inventory_panel.gd")

signal container_opened(container: StorageContainer)
signal container_closed
signal unit_inventory_opened(unit: ClickableUnit)
signal unit_inventory_closed

## Height offset above objects in world units
@export var world_height_offset: float = 2.0
## Screen offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)
## Horizontal spacing between panels when both are open
@export var panel_spacing: float = 20.0

var _container_panel: InventoryPanel = null
var _unit_panel: InventoryPanel = null
var _current_container: StorageContainer = null
var _current_unit: ClickableUnit = null
var _camera: Camera3D = null


func _ready() -> void:
	# Try to find scene nodes first
	_container_panel = get_node_or_null("%ContainerPanel") as InventoryPanel
	_unit_panel = get_node_or_null("%UnitPanel") as InventoryPanel

	if _container_panel and _unit_panel:
		# Scene-based: just connect signals
		_container_panel.panel_closed.connect(_on_container_panel_closed)
		_unit_panel.panel_closed.connect(_on_unit_panel_closed)
	else:
		# Programmatic fallback
		_build_panels()


func _build_panels() -> void:
	## Build panels programmatically (fallback for non-scene usage).
	# Create container panel (left side)
	_container_panel = InventoryPanelScript.new()
	_container_panel.name = "ContainerPanel"
	_container_panel.title = "Container"
	_container_panel.position = Vector2(50, 100)
	_container_panel.panel_closed.connect(_on_container_panel_closed)
	add_child(_container_panel)

	# Create unit panel (right side)
	_unit_panel = InventoryPanelScript.new()
	_unit_panel.name = "UnitPanel"
	_unit_panel.title = "Inventory"
	_unit_panel.position = Vector2(400, 100)
	_unit_panel.panel_closed.connect(_on_unit_panel_closed)
	add_child(_unit_panel)


func _process(_delta: float) -> void:
	# Update panel positions to follow their objects
	_update_panel_positions()


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return

	var key := event as InputEventKey

	# "I" key toggles selected unit's inventory
	if key.keycode == KEY_I:
		_toggle_unit_inventory()

	# Escape closes any open panel
	elif key.keycode == KEY_ESCAPE:
		if _unit_panel and _unit_panel.visible:
			close_unit_inventory()
		if _container_panel and _container_panel.visible:
			close_container()


func _update_panel_positions() -> void:
	## Position panels near their attached objects in screen space.
	if not _camera:
		_camera = get_viewport().get_camera_3d()
	if not _camera:
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size

	# Position container panel near container
	if _container_panel and _container_panel.visible and _current_container:
		var container_node: Node3D = _current_container.get_parent() as Node3D
		if container_node:
			var world_pos: Vector3 = container_node.global_position + Vector3(0, world_height_offset, 0)
			if _camera.is_position_in_frustum(world_pos):
				var screen_pos: Vector2 = _camera.unproject_position(world_pos)
				var panel_size: Vector2 = _container_panel.size
				# Position panel to the left of the object
				var target_pos: Vector2 = screen_pos + screen_offset - Vector2(panel_size.x + panel_spacing / 2, panel_size.y / 2)
				# Clamp to screen
				target_pos.x = clampf(target_pos.x, 0, viewport_size.x - panel_size.x)
				target_pos.y = clampf(target_pos.y, 0, viewport_size.y - panel_size.y)
				_container_panel.position = target_pos

	# Position unit panel near unit
	if _unit_panel and _unit_panel.visible and _current_unit:
		var world_pos: Vector3 = _current_unit.global_position + Vector3(0, world_height_offset, 0)
		if _camera.is_position_in_frustum(world_pos):
			var screen_pos: Vector2 = _camera.unproject_position(world_pos)
			var panel_size: Vector2 = _unit_panel.size
			# Position panel to the right of the object
			var target_pos: Vector2 = screen_pos + screen_offset + Vector2(panel_spacing / 2, -panel_size.y / 2)
			# Clamp to screen
			target_pos.x = clampf(target_pos.x, 0, viewport_size.x - panel_size.x)
			target_pos.y = clampf(target_pos.y, 0, viewport_size.y - panel_size.y)
			_unit_panel.position = target_pos


func _toggle_unit_inventory() -> void:
	## Toggle inventory for currently selected unit.
	if _unit_panel and _unit_panel.visible:
		close_unit_inventory()
		return

	# Try RTSInputHandler first (for ClickableUnit selection)
	var input_handler := _find_input_handler()
	if input_handler and input_handler.has_selection():
		var selected: Array = input_handler.get_selected_units()
		if not selected.is_empty():
			var unit: ClickableUnit = selected[0] as ClickableUnit
			if unit:
				open_unit_inventory(unit)
				return

	# Fallback to SelectionManager (for Survivor selection)
	var selection_mgr := get_node_or_null("/root/SelectionManager")
	if selection_mgr and selection_mgr.has_selection():
		var survivor: Node = selection_mgr.get_first_selected()
		if survivor is ClickableUnit:
			open_unit_inventory(survivor as ClickableUnit)


func _find_input_handler() -> Node:
	## Find RTSInputHandler in scene.
	var root := get_tree().current_scene
	if root:
		return root.get_node_or_null("RTSInputHandler")
	return null


func open_container(container: StorageContainer) -> void:
	## Show inventory for a storage container.
	if not _container_panel:
		return
	_current_container = container
	_container_panel.show_inventory(container.inventory, container.display_name)
	container_opened.emit(container)


func close_container() -> void:
	if _current_container:
		_current_container.close()
	_current_container = null
	if _container_panel:
		_container_panel.hide_panel()
	container_closed.emit()


func open_unit_inventory(unit: ClickableUnit) -> void:
	## Show inventory for a unit.
	if not unit or not unit.inventory or not _unit_panel:
		return
	_current_unit = unit
	_unit_panel.show_inventory(unit.inventory, unit.unit_name)
	unit_inventory_opened.emit(unit)


func close_unit_inventory() -> void:
	_current_unit = null
	if _unit_panel:
		_unit_panel.hide_panel()
	unit_inventory_closed.emit()


func _on_container_panel_closed() -> void:
	if _current_container:
		_current_container.close()
	_current_container = null
	container_closed.emit()


func _on_unit_panel_closed() -> void:
	_current_unit = null
	unit_inventory_closed.emit()


func is_any_panel_open() -> bool:
	if not _container_panel or not _unit_panel:
		return false
	return _container_panel.visible or _unit_panel.visible
