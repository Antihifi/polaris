class_name UnitPanelManager extends Node
## Manages multiple CharacterStats and InventoryPanel instances.
## Spawns new panels on double-click, tracks unit->panel mapping,
## handles focus/bring-to-front, and cleans up on unit death/removal.

signal panel_opened(unit: ClickableUnit)
signal panel_closed(unit: ClickableUnit)

const CharacterStatsScene: PackedScene = preload("res://ui/character_stats.tscn")

const MAX_STATS_PANELS: int = 6
const MAX_INVENTORY_PANELS: int = 4

## Active panels: unit instance_id -> panel
var _stats_panels: Dictionary = {}
var _inventory_panels: Dictionary = {}
## Focus order: most recently focused panel's unit ID at end
var _focus_order: Array[int] = []

var _stats_parent: CanvasLayer = null
var _inventory_parent: CanvasLayer = null


func setup(stats_parent: CanvasLayer, inventory_parent: CanvasLayer = null) -> void:
	_stats_parent = stats_parent
	_inventory_parent = inventory_parent


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
	_focus_order.append(uid)
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
		_focus_order.erase(uid)
		# Clean up tether line if it exists
		if is_instance_valid(panel) and panel.has_method("get_tether_line"):
			var tether: Line2D = panel.get_tether_line()
			if tether and is_instance_valid(tether):
				tether.queue_free()
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
