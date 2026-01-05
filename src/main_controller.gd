extends Node
## Main scene controller - sets up RTS input handling and navigation.
## Attach this script to the root node of main.tscn

@onready var rts_camera: Camera3D = $RTScamera
@onready var captain: Node3D = $Captain

var input_handler: Node


func _ready() -> void:
	# Create and add the RTS input handler
	input_handler = preload("res://src/control/rts_input_handler.gd").new()
	input_handler.name = "RTSInputHandler"
	input_handler.camera = rts_camera
	add_child(input_handler)

	# Set up navigation - Terrain3D needs special handling
	# For now, we'll use a simple NavigationRegion3D with a flat plane
	# that matches the terrain bounds. In production, you'd bake the navmesh from terrain.
	_setup_basic_navigation()

	# Focus camera on captain initially
	if rts_camera.has_method("focus_on"):
		rts_camera.focus_on(captain, true)


func _setup_basic_navigation() -> void:
	## Creates a basic navigation region for testing.
	## TODO: Replace with proper Terrain3D navigation mesh baking.

	# Check if NavigationRegion3D already exists
	var nav_region := get_node_or_null("NavigationRegion3D")
	if nav_region:
		print("[MainController] Using existing NavigationRegion3D")
		return

	# Get the terrain height at origin to place nav mesh correctly
	var terrain_height := 0.0
	var terrain := _find_terrain3d()
	if terrain and "data" in terrain and terrain.data:
		var h: float = terrain.data.get_height(Vector3.ZERO)
		if not is_nan(h):
			terrain_height = h
			print("[MainController] Terrain height at origin: ", terrain_height)

	nav_region = NavigationRegion3D.new()
	nav_region.name = "NavigationRegion3D"
	add_child(nav_region)

	# Create a large flat navigation mesh for testing
	var nav_mesh := NavigationMesh.new()

	# Set navigation mesh parameters
	nav_mesh.agent_radius = 0.5
	nav_mesh.agent_height = 2.0
	nav_mesh.agent_max_climb = 0.5
	nav_mesh.agent_max_slope = 45.0

	# Create vertices for a large flat plane at terrain height
	var size := 500.0
	var y := terrain_height
	var vertices := PackedVector3Array([
		Vector3(-size, y, -size),
		Vector3(size, y, -size),
		Vector3(size, y, size),
		Vector3(-size, y, size)
	])

	# Bake a simple mesh
	nav_mesh.vertices = vertices
	nav_mesh.add_polygon(PackedInt32Array([0, 1, 2]))
	nav_mesh.add_polygon(PackedInt32Array([0, 2, 3]))

	nav_region.navigation_mesh = nav_mesh

	print("[MainController] Navigation region created at y=", y)


func _find_terrain3d() -> Node:
	## Find the Terrain3D node in the scene.
	var nodes := get_tree().get_nodes_in_group("terrain")
	if nodes.size() > 0:
		return nodes[0]

	# Search by class name
	return _find_node_by_class(get_tree().current_scene, "Terrain3D")


func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	if node.get_class() == class_name_str:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_str)
		if result:
			return result
	return null


func _input(event: InputEvent) -> void:
	# Double-click to focus camera on captain
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			if input_handler.selected_unit:
				rts_camera.focus_on(input_handler.selected_unit)
