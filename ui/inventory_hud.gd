class_name InventoryHUD extends CanvasLayer
## Manages inventory UI panels for containers and units.
## Handles "I" key to toggle unit inventory.
## Supports multiple unit inventories open simultaneously.
## Panels follow their attached objects in screen space.

const InventoryPanelScene: PackedScene = preload("res://ui/inventory_panel.tscn")

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

const MAX_UNIT_PANELS: int = 4

## Container panel (singleton — one container open at a time)
var _container_panel: InventoryPanel = null
var _container_root: Control = null
var _current_container: StorageContainer = null
var _container_tether: Line2D = null

## Unit panels: unit instance_id -> InventoryPanel
var _unit_panels: Dictionary = {}
## Root Controls: unit instance_id -> Control (scene root that holds flourish + panel)
var _unit_panel_roots: Dictionary = {}
## Unit references: unit instance_id -> ClickableUnit
var _unit_panel_units: Dictionary = {}
## Tether lines: unit instance_id -> Line2D
var _unit_tethers: Dictionary = {}
## Focus order for ESC: most recently opened unit ID at end
var _focus_order: Array[int] = []

var _camera: Camera3D = null


func _ready() -> void:
	# Find scene-based container panel (root Control with InventoryPanel child)
	_container_root = get_node_or_null("%ContainerPanel") as Control
	if _container_root:
		_container_panel = _container_root.get_node_or_null("InventoryPanel") as InventoryPanel
		if _container_panel:
			_container_panel.panel_closed.connect(_on_container_panel_closed)
	# Hide scene-based unit panel (we use dynamic panels now)
	var scene_unit_root: Control = get_node_or_null("%UnitPanel") as Control
	if scene_unit_root:
		scene_unit_root.visible = false
	# Create container tether line
	_container_tether = _create_tether_line()


func _create_tether_line() -> Line2D:
	## Create a tether line for a drag-detached panel.
	var line := Line2D.new()
	line.width = 1.0
	line.default_color = Color(0.8, 0.8, 0.8, 0.4)
	line.z_index = -1
	line.visible = false
	add_child(line)
	return line


func _process(_delta: float) -> void:
	_update_panel_positions()


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return

	var key := event as InputEventKey

	# "I" key toggles selected unit's inventory
	if key.keycode == KEY_I:
		_toggle_unit_inventory()

	# Escape closes topmost unit panel, then container
	elif key.keycode == KEY_ESCAPE:
		if not _focus_order.is_empty():
			var uid: int = _focus_order.back()
			_close_unit_panel(uid)
			get_viewport().set_input_as_handled()
		elif _container_panel and _container_panel.visible:
			close_container()
			get_viewport().set_input_as_handled()


func _update_panel_positions() -> void:
	## Position panels near their attached objects in screen space.
	if not _camera:
		_camera = get_viewport().get_camera_3d()
	if not _camera:
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size

	# Position container panel near container
	if _container_panel and _container_panel.visible and _current_container:
		if _container_panel.is_detached:
			_update_tether(_container_tether, _container_root, _current_container.get_parent() as Node3D, viewport_size)
		else:
			if _container_tether:
				_container_tether.visible = false
			var container_node: Node3D = _current_container.get_parent() as Node3D
			if container_node:
				var world_pos: Vector3 = container_node.global_position + Vector3(0, world_height_offset, 0)
				if _camera.is_position_in_frustum(world_pos):
					var screen_pos: Vector2 = _camera.unproject_position(world_pos)
					var root_size: Vector2 = _container_root.size
					var target_pos: Vector2 = screen_pos + screen_offset - Vector2(root_size.x + panel_spacing / 2, root_size.y / 2)
					target_pos.x = clampf(target_pos.x, 0, viewport_size.x - root_size.x)
					target_pos.y = clampf(target_pos.y, 0, viewport_size.y - root_size.y)
					_container_root.position = target_pos
	else:
		if _container_tether:
			_container_tether.visible = false

	# Position unit panels near their units
	for uid: int in _unit_panels.keys():
		var panel: InventoryPanel = _unit_panels[uid]
		var root: Control = _unit_panel_roots.get(uid) as Control
		var unit: ClickableUnit = _unit_panel_units.get(uid) as ClickableUnit
		var tether: Line2D = _unit_tethers.get(uid) as Line2D
		if not is_instance_valid(panel) or not panel.visible or not is_instance_valid(unit) or not is_instance_valid(root):
			if tether and is_instance_valid(tether):
				tether.visible = false
			continue
		if panel.is_detached:
			if tether:
				_update_tether(tether, root, unit, viewport_size)
		else:
			if tether and is_instance_valid(tether):
				tether.visible = false
			var world_pos: Vector3 = unit.global_position + Vector3(0, world_height_offset, 0)
			if _camera.is_position_in_frustum(world_pos):
				var screen_pos: Vector2 = _camera.unproject_position(world_pos)
				var root_size: Vector2 = root.size
				var target_pos: Vector2 = screen_pos + screen_offset + Vector2(panel_spacing / 2, -root_size.y / 2)
				target_pos.x = clampf(target_pos.x, 0, viewport_size.x - root_size.x)
				target_pos.y = clampf(target_pos.y, 0, viewport_size.y - root_size.y)
				root.position = target_pos


func _update_tether(line: Line2D, root: Control, target_node: Node3D, viewport_size: Vector2) -> void:
	## Update a tether line from a detached panel to its target object.
	if not line or not target_node or not _camera:
		if line:
			line.visible = false
		return
	var world_pos: Vector3 = target_node.global_position + Vector3(0, world_height_offset, 0)
	var in_frustum: bool = _camera.is_position_in_frustum(world_pos)
	var target_screen: Vector2 = _camera.unproject_position(world_pos)
	if not in_frustum:
		target_screen = target_screen.clamp(Vector2.ZERO, viewport_size)
	var panel_center: Vector2 = root.position + root.size / 2.0
	line.points = PackedVector2Array([panel_center, target_screen])
	line.visible = true


func _toggle_unit_inventory() -> void:
	## Toggle inventory for currently selected unit.
	## If the unit already has a panel, close it. Otherwise open a new one.
	var unit: ClickableUnit = _get_selected_unit()
	if not unit or not unit.inventory:
		return

	var uid: int = unit.get_instance_id()
	if uid in _unit_panels:
		# Unit already has a panel open — close it (toggle off)
		_close_unit_panel(uid)
	else:
		# Open a new panel for this unit
		_open_unit_panel(unit)


func _get_selected_unit() -> ClickableUnit:
	## Get the currently selected unit.
	# Try RTSInputHandler first
	var input_handler := _find_input_handler()
	if input_handler and input_handler.has_selection():
		var selected: Array = input_handler.get_selected_units()
		if not selected.is_empty():
			var unit: ClickableUnit = selected[0] as ClickableUnit
			if unit:
				return unit
	# Fallback to SelectionManager
	var selection_mgr := get_node_or_null("/root/SelectionManager")
	if selection_mgr and selection_mgr.has_selection():
		var survivor: Node = selection_mgr.get_first_selected()
		if survivor is ClickableUnit:
			return survivor as ClickableUnit
	return null


func _find_input_handler() -> Node:
	## Find RTSInputHandler in scene.
	var root := get_tree().current_scene
	if root:
		return root.get_node_or_null("RTSInputHandler")
	return null


func _open_unit_panel(unit: ClickableUnit) -> void:
	## Open a new inventory panel for the given unit.
	# Enforce limit — close oldest if full
	if _unit_panels.size() >= MAX_UNIT_PANELS:
		_close_oldest_unit_panel()

	var uid: int = unit.get_instance_id()
	# Scene root is a Control containing FlourishTop + InventoryPanel
	var root: Control = InventoryPanelScene.instantiate() as Control
	add_child(root)
	var panel: InventoryPanel = root.get_node("InventoryPanel") as InventoryPanel
	panel.show_inventory(unit.inventory, unit.unit_name)

	# Track root, panel, and unit
	_unit_panel_roots[uid] = root
	_unit_panels[uid] = panel
	_unit_panel_units[uid] = unit
	_focus_order.append(uid)

	# Create tether line for this panel
	var tether: Line2D = _create_tether_line()
	_unit_tethers[uid] = tether

	# Connect cleanup signals
	panel.panel_closed.connect(_on_unit_panel_closed.bind(uid))
	if not unit.tree_exiting.is_connected(_on_unit_exiting):
		unit.tree_exiting.connect(_on_unit_exiting.bind(uid))

	unit_inventory_opened.emit(unit)


func _close_unit_panel(uid: int) -> void:
	## Close a specific unit's inventory panel.
	if uid not in _unit_panels:
		return
	var panel: InventoryPanel = _unit_panels[uid]
	if is_instance_valid(panel) and panel.has_method("hide_panel"):
		panel.hide_panel()
	# Cleanup handled by _on_unit_panel_closed


func _close_oldest_unit_panel() -> void:
	## Close the least recently focused unit panel.
	for uid: int in _focus_order:
		if uid in _unit_panels:
			_close_unit_panel(uid)
			return
	# Fallback: close first in dictionary
	if not _unit_panels.is_empty():
		var uid: int = _unit_panels.keys()[0]
		_close_unit_panel(uid)


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
	if _container_tether:
		_container_tether.visible = false
	container_closed.emit()


func open_unit_inventory(unit: ClickableUnit) -> void:
	## Show inventory for a unit. Called externally (e.g., from container interactions).
	if not unit or not unit.inventory:
		return
	var uid: int = unit.get_instance_id()
	if uid in _unit_panels:
		# Already open — bring to front
		_focus_order.erase(uid)
		_focus_order.append(uid)
		return
	_open_unit_panel(unit)


func close_unit_inventory() -> void:
	## Close all unit inventory panels. Used by external callers.
	for uid: int in _unit_panels.keys():
		_close_unit_panel(uid)


func _on_container_panel_closed() -> void:
	if _current_container:
		_current_container.close()
	_current_container = null
	container_closed.emit()


func _on_unit_panel_closed(uid: int) -> void:
	## Clean up tracking when a unit panel is closed.
	if uid in _unit_panels:
		var root: Control = _unit_panel_roots.get(uid) as Control
		_unit_panels.erase(uid)
		_unit_panel_roots.erase(uid)
		_unit_panel_units.erase(uid)
		_focus_order.erase(uid)
		# Clean up tether line
		if uid in _unit_tethers:
			var tether: Line2D = _unit_tethers[uid]
			if is_instance_valid(tether):
				tether.queue_free()
			_unit_tethers.erase(uid)
		# Free the root Control (which frees the panel and flourish)
		if is_instance_valid(root):
			root.queue_free()
	unit_inventory_closed.emit()


func _on_unit_exiting(uid: int) -> void:
	## Unit being freed — close its inventory panel.
	_close_unit_panel(uid)


func get_container_panel() -> InventoryPanel:
	return _container_panel


func is_any_panel_open() -> bool:
	if _container_panel and _container_panel.visible:
		return true
	return not _unit_panels.is_empty()
