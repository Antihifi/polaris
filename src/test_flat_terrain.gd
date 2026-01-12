extends Node
## Minimal flat terrain test for navigation debugging.
## Creates a simple flat Terrain3D and tests if navigation works.

var _captain_scene: PackedScene = preload("res://src/characters/captain.tscn")
var _camera_scene: PackedScene = preload("res://src/camera/rts_camera.tscn")

var terrain: Node = null
var runtime_nav_baker: RuntimeNavBaker = null
var captain: Node3D = null


func _ready() -> void:
	# Create temp camera
	var temp_cam := Camera3D.new()
	temp_cam.current = true
	add_child(temp_cam)

	# Basic lighting
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-45, -30, 0)
	add_child(sun)

	print("[FlatTest] Creating flat terrain...")
	await _create_flat_terrain()

	print("[FlatTest] Setting up navigation...")
	_setup_navigation()

	print("[FlatTest] Baking NavMesh...")
	runtime_nav_baker.force_bake_at(Vector3.ZERO)
	await runtime_nav_baker.bake_finished

	print("[FlatTest] Spawning captain...")
	_spawn_captain()

	# Wait for physics sync
	for i in range(10):
		await get_tree().physics_frame

	# Test navigation
	_test_navigation()

	# Setup camera
	var rts_camera: Camera3D = _camera_scene.instantiate()
	add_child(rts_camera)
	if terrain.has_method("set_camera"):
		terrain.set_camera(rts_camera)
	rts_camera.focus_on(captain, true)
	temp_cam.queue_free()

	# Input handler
	var input_handler := preload("res://src/control/rts_input_handler.gd").new()
	input_handler.camera = rts_camera
	add_child(input_handler)

	print("[FlatTest] Ready!")


func _create_flat_terrain() -> void:
	# Create Terrain3D
	terrain = ClassDB.instantiate("Terrain3D")
	terrain.name = "Terrain3D"
	add_child(terrain)
	terrain.add_to_group("terrain")

	# Simple settings
	terrain.vertex_spacing = 1.0  # 1 meter per vertex
	terrain.region_size = Terrain3D.SIZE_1024

	if terrain.material:
		terrain.material.world_background = Terrain3DMaterial.NONE
		if "auto_shader" in terrain.material:
			terrain.material.auto_shader = true

	# Create a FLAT heightmap (all zeros = height 0)
	var size := 512
	var heightmap := Image.create(size, size, false, Image.FORMAT_RF)
	# All pixels default to 0 = flat terrain at Y=0

	# Import with offset to center at origin
	var offset := Vector3(-size / 2.0, 0, -size / 2.0)
	terrain.data.import_images([heightmap, null, null], offset, 0.0, 1.0)

	await get_tree().process_frame
	terrain.data.calc_height_range(true)

	# Verify
	var test_height: float = terrain.data.get_height(Vector3.ZERO)
	print("[FlatTest] Terrain height at origin: %.2f" % test_height)


func _setup_navigation() -> void:
	runtime_nav_baker = RuntimeNavBaker.new()
	runtime_nav_baker.name = "RuntimeNavBaker"
	runtime_nav_baker.terrain = terrain
	runtime_nav_baker.mesh_size = Vector3(128, 64, 128)  # Smaller for test
	runtime_nav_baker.enabled = false
	runtime_nav_baker.log_timing = true
	add_child(runtime_nav_baker)


func _spawn_captain() -> void:
	captain = _captain_scene.instantiate()
	captain.name = "Captain"
	add_child(captain)

	# Spawn at origin, slightly above terrain
	var terrain_y: float = terrain.data.get_height(Vector3.ZERO)
	if is_nan(terrain_y):
		terrain_y = 0.0
	captain.global_position = Vector3(0, terrain_y + 1.0, 0)

	runtime_nav_baker.player = captain
	runtime_nav_baker.enabled = true

	print("[FlatTest] Captain at %s" % captain.global_position)


func _test_navigation() -> void:
	var nav_agent: NavigationAgent3D = captain.get_node_or_null("NavigationAgent3D")
	if not nav_agent:
		print("[FlatTest] ERROR: No NavigationAgent3D!")
		return

	var nav_map := nav_agent.get_navigation_map()
	print("[FlatTest] Nav map: %s" % nav_map)

	# Check closest point
	var captain_pos := captain.global_position
	var closest := NavigationServer3D.map_get_closest_point(nav_map, captain_pos)
	print("[FlatTest] Captain pos: %s" % captain_pos)
	print("[FlatTest] Closest NavMesh point: %s (dist: %.2f)" % [closest, captain_pos.distance_to(closest)])

	# Test path
	var target := captain_pos + Vector3(10, 0, 10)
	var closest_target := NavigationServer3D.map_get_closest_point(nav_map, target)
	var path := NavigationServer3D.map_get_path(nav_map, closest, closest_target, true)
	print("[FlatTest] Path to %s: %d points" % [closest_target, path.size()])

	if path.size() > 0:
		print("[FlatTest] SUCCESS! Navigation works on flat terrain!")
		for i in range(mini(path.size(), 5)):
			print("[FlatTest]   Point %d: %s" % [i, path[i]])
	else:
		print("[FlatTest] FAILED! Path still empty on flat terrain!")

		# More debug
		var regions := NavigationServer3D.map_get_regions(nav_map)
		print("[FlatTest] Map has %d regions" % regions.size())

		var cell_size := NavigationServer3D.map_get_cell_size(nav_map)
		var cell_height := NavigationServer3D.map_get_cell_height(nav_map)
		print("[FlatTest] Map cell_size=%.3f, cell_height=%.3f" % [cell_size, cell_height])
