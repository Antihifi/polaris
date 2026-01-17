@tool
extends EditorPlugin
## Terrain Parameters Editor Plugin
## Adds a dock panel for tweaking procedural terrain generation parameters.

var dock: Control


func _enter_tree() -> void:
	dock = preload("res://addons/terrain_params/terrain_params_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)


func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()
