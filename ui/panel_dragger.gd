class_name PanelDragger extends RefCounted
## Handles drag-to-detach logic for a UI panel.
## When the user drags a panel, it detaches from auto-follow mode.
## Double-click on the drag handle re-attaches it.

var is_dragging: bool = false
var is_detached: bool = false
var _drag_offset: Vector2 = Vector2.ZERO


func handle_input(event: InputEvent, panel: Control) -> void:
	## Process input events for drag detection. Call from panel's gui_input.
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				is_dragging = true
				_drag_offset = mb.position
			else:
				is_dragging = false
	elif event is InputEventMouseMotion and is_dragging:
		var motion := event as InputEventMouseMotion
		panel.position += motion.relative
		is_detached = true


func reset() -> void:
	## Re-attach panel to auto-follow mode.
	is_detached = false
	is_dragging = false
