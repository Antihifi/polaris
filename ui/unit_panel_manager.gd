class_name UnitPanelManager extends Node
## Manages multiple CharacterStats and InventoryPanel instances.
## Spawns new panels on double-click, tracks unit->panel mapping,
## handles focus/bring-to-front, and cleans up on unit death/removal.
## Owns tether lines for detached stats panels (same pattern as InventoryHUD).

signal panel_opened(unit: ClickableUnit)
signal panel_closed(unit: ClickableUnit)

const CharacterStatsScene: PackedScene = preload("res://ui/character_stats.tscn")

const MAX_STATS_PANELS: int = 6
const MAX_INVENTORY_PANELS: int = 4

## Height offset above objects in world units (for tether target position)
var world_height_offset: float = 4.0

## Active panels: unit instance_id -> panel
var _stats_panels: Dictionary = {}
var _stats_units: Dictionary = {}
var _stats_tethers: Dictionary = {}
var _inventory_panels: Dictionary = {}
## Focus order: most recently focused panel's unit ID at end
var _focus_order: Array[int] = []

var _stats_parent: CanvasLayer = null
var _inventory_parent: CanvasLayer = null
var _camera: Camera3D = null


func setup(stats_parent: CanvasLayer, inventory_parent: CanvasLayer = null) -> void:
	_stats_parent = stats_parent
	_inventory_parent = inventory_parent


func _process(_delta: float) -> void:
	if _stats_panels.is_empty():
		return
	if not _camera:
		_camera = get_viewport().get_camera_3d()
	if not _camera:
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size

	for uid: int in _stats_panels.keys():
		var panel: Control = _stats_panels[uid]
		var unit: ClickableUnit = _stats_units.get(uid) as ClickableUnit
		var tether: Line2D = _stats_tethers.get(uid) as Line2D
		if not is_instance_valid(panel) or not panel.visible or not is_instance_valid(unit):
			if tether and is_instance_valid(tether):
				tether.visible = false
			continue
		if panel.is_detached:
			if tether:
				_update_tether(tether, panel, unit, viewport_size)
		else:
			if tether and is_instance_valid(tether):
				tether.visible = false


func _create_tether_line() -> Line2D:
	## Create a tether line for a drag-detached panel.
	var line := Line2D.new()
	line.width = 1.0
	line.default_color = Color(0.8, 0.8, 0.8, 0.4)
	line.z_index = -1
	line.visible = false
	_stats_parent.add_child(line)
	return line


func _update_tether(line: Line2D, panel: Control, target_node: Node3D, viewport_size: Vector2) -> void:
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
	var panel_center: Vector2 = panel.position + panel.size / 2.0
	line.points = PackedVector2Array([panel_center, target_screen])
	line.visible = true


func open_stats_for_unit(unit: ClickableUnit) -> Control:
	## Open or focus a stats panel for the given unit.
	var uid: int = unit.get_instance_id()
	if uid in _stats_panels:
		var panel: Control = _stats_panels[uid]
		_bring_to_front(uid, panel)
		return panel
	# Enforce limit
	if _stats_panels.size() >= MAX_STATS_PANELS:
		_close_oldest_stats_panel()
	# Spawn new panel
	var panel: Control = CharacterStatsScene.instantiate()
	_stats_parent.add_child(panel)
	panel.show_for_unit(unit)
	_stats_panels[uid] = panel
	_stats_units[uid] = unit
	_focus_order.append(uid)
	# Create tether line
	_stats_tethers[uid] = _create_tether_line()
	# Connect cleanup signals
	if panel.has_signal("closed"):
		panel.closed.connect(_on_stats_panel_closed.bind(uid))
	if not unit.tree_exiting.is_connected(_on_unit_exiting):
		unit.tree_exiting.connect(_on_unit_exiting.bind(uid))
	panel_opened.emit(unit)
	return panel


func has_stats_panel(unit: ClickableUnit) -> bool:
	return unit.get_instance_id() in _stats_panels


func close_stats_for_unit(unit: ClickableUnit) -> void:
	var uid: int = unit.get_instance_id()
	if uid in _stats_panels:
		var panel: Control = _stats_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()


func toggle_stats_for_unit(unit: ClickableUnit) -> void:
	## Open if not open, close if open. Used by C key.
	if has_stats_panel(unit):
		close_stats_for_unit(unit)
	else:
		open_stats_for_unit(unit)


func close_topmost() -> void:
	## Close the most recently focused panel. Called on ESC.
	if _focus_order.is_empty():
		return
	var uid: int = _focus_order.back()
	if uid in _stats_panels:
		var panel: Control = _stats_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()
	elif uid in _inventory_panels:
		var panel: Control = _inventory_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()


func close_all() -> void:
	for uid: int in _stats_panels.keys():
		var panel: Control = _stats_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()
	for uid: int in _inventory_panels.keys():
		var panel: Control = _inventory_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()


func has_any_panel_open() -> bool:
	return not _stats_panels.is_empty() or not _inventory_panels.is_empty()


func _bring_to_front(uid: int, panel: Control) -> void:
	## Bring panel to top of draw order and update focus order.
	panel.get_parent().move_child(panel, -1)
	_focus_order.erase(uid)
	_focus_order.append(uid)


func _on_stats_panel_closed(uid: int) -> void:
	if uid in _stats_panels:
		var panel: Control = _stats_panels[uid]
		_stats_panels.erase(uid)
		_stats_units.erase(uid)
		_focus_order.erase(uid)
		# Clean up tether line
		if uid in _stats_tethers:
			var tether: Line2D = _stats_tethers[uid]
			if is_instance_valid(tether):
				tether.queue_free()
			_stats_tethers.erase(uid)
		if is_instance_valid(panel):
			panel.queue_free()


func _on_inventory_panel_closed(uid: int) -> void:
	if uid in _inventory_panels:
		var panel: Control = _inventory_panels[uid]
		_inventory_panels.erase(uid)
		_focus_order.erase(uid)
		panel.queue_free()


func _on_unit_exiting(uid: int) -> void:
	## Unit being freed - close its panels.
	if uid in _stats_panels:
		var panel: Control = _stats_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()
	if uid in _inventory_panels:
		var panel: Control = _inventory_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()


func _close_oldest_stats_panel() -> void:
	## Close the least recently focused stats panel.
	for uid: int in _focus_order:
		if uid in _stats_panels:
			var panel: Control = _stats_panels[uid]
			if is_instance_valid(panel) and panel.has_method("hide_panel"):
				panel.hide_panel()
			return
	# Fallback: close first in dictionary
	if not _stats_panels.is_empty():
		var uid: int = _stats_panels.keys()[0]
		var panel: Control = _stats_panels[uid]
		if is_instance_valid(panel) and panel.has_method("hide_panel"):
			panel.hide_panel()
