extends Node
## Main scene controller - sets up RTS input handling.
## Attach this script to the root node of main.tscn
## Navigation is handled by Terrain3D's baked NavigationMesh.

@onready var rts_camera: Camera3D = $RTScamera
@onready var captain: Node3D = $Captain

var input_handler: Node


func _ready() -> void:
	# Create and add the RTS input handler
	input_handler = preload("res://src/control/rts_input_handler.gd").new()
	input_handler.name = "RTSInputHandler"
	input_handler.camera = rts_camera
	add_child(input_handler)

	# Focus camera on captain initially
	if rts_camera.has_method("focus_on"):
		rts_camera.focus_on(captain, true)


func _input(event: InputEvent) -> void:
	# Double-click to focus camera on captain
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			if input_handler.selected_unit:
				rts_camera.focus_on(input_handler.selected_unit)
