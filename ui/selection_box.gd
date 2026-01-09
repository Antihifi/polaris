class_name SelectionBox extends Control
## Draws the box selection rectangle during click-drag selection.
## Lightweight programmatic approach - no shader needed.

## Off-white color for the selection box
@export var box_color: Color = Color(0.9, 0.9, 0.85, 0.8)
@export var border_color: Color = Color(0.95, 0.95, 0.9, 1.0)
@export var border_width: float = 2.0

var _input_handler: Node = null


func _ready() -> void:
	# Make sure we cover the whole screen
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE  # Don't intercept mouse events

	# Find the input handler
	call_deferred("_find_input_handler")


func _find_input_handler() -> void:
	# Look for RTSInputHandler in parent scene
	var parent := get_parent()
	while parent:
		var handler := parent.get_node_or_null("RTSInputHandler")
		if handler:
			_input_handler = handler
			return
		parent = parent.get_parent()

	# Try finding in current scene root
	var root := get_tree().current_scene
	_input_handler = root.get_node_or_null("RTSInputHandler")


func _process(_delta: float) -> void:
	# Only redraw when box selecting
	if _input_handler and _input_handler.is_box_selecting:
		queue_redraw()
	elif is_queued_for_deletion() == false:
		# Clear any previous drawing when not selecting
		queue_redraw()


func _draw() -> void:
	if not _input_handler:
		return

	if not _input_handler.is_box_selecting:
		return

	var rect: Rect2 = _input_handler.get_box_selection_rect()
	if rect.size.length() < 5.0:
		return  # Too small to draw

	# Draw filled rectangle with transparency
	var fill_color := box_color
	fill_color.a = 0.15  # Very transparent fill
	draw_rect(rect, fill_color, true)

	# Draw border
	draw_rect(rect, border_color, false, border_width)
