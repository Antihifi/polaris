extends Node
## MINIMAL navigation test - no textures, just get nav working.

var terrain: Terrain3D
var camera: Camera3D


func _ready() -> void:
	# Create camera FIRST to prevent Terrain3D errors
	camera = Camera3D.new()
	camera.name = "TempCamera"
	camera.current = true
	add_child(camera)

	terrain = create_terrain()

	# Tell terrain about camera immediately
	if terrain.has_method("set_camera"):
		terrain.set_camera(camera)

	# Setup runtime nav baker
	$RuntimeNavigationBaker.terrain = terrain
	$RuntimeNavigationBaker.enabled = false  # Don't auto-bake yet

	# Force first bake at origin
	$RuntimeNavigationBaker.force_bake_at(Vector3.ZERO)
	await $RuntimeNavigationBaker.bake_finished

	# Now enable for continuous baking
	$RuntimeNavigationBaker.enabled = true

	# Spawn captain
	_spawn_captain()


func create_terrain() -> Terrain3D:
	## MINIMAL terrain - no textures, just geometry

	terrain = Terrain3D.new()
	terrain.name = "Terrain3D"
	add_child(terrain, true)
	terrain.owner = get_tree().get_current_scene()
	terrain.add_to_group("terrain")

	# Generate GENTLE heightmap
	var noise := FastNoiseLite.new()
	noise.frequency = 0.001
	var img: Image = Image.create_empty(2048, 2048, false, Image.FORMAT_RF)
	for x in img.get_width():
		for y in img.get_height():
			img.set_pixel(x, y, Color(noise.get_noise_2d(x, y), 0., 0., 1.))

	terrain.region_size = Terrain3D.SIZE_1024
	terrain.data.import_images([img, null, null], Vector3(-1024, 0, -1024), 0.0, 30.0)

	print("[SimpleNavTest] Terrain created - height scale 30.0")
	return terrain


func _spawn_captain() -> void:
	var captain_scene: PackedScene = preload("res://src/characters/captain.tscn")
	var captain: Node3D = captain_scene.instantiate()
	captain.name = "Captain"
	add_child(captain)

	captain.global_position = Vector3(0, 50, 0)
	captain.movement_speed = 5.0

	$RuntimeNavigationBaker.player = captain

	print("[SimpleNavTest] Captain spawned at %s" % captain.global_position)

	_setup_camera(captain)


func _setup_camera(target: Node3D) -> void:
	# Replace temp camera with RTS camera
	var rts_camera_scene: PackedScene = preload("res://src/camera/rts_camera.tscn")
	var rts_camera: Camera3D = rts_camera_scene.instantiate()
	rts_camera.name = "RTScamera"
	add_child(rts_camera)

	if rts_camera.has_method("focus_on"):
		rts_camera.focus_on(target, true)

	# Update terrain to use new camera
	if terrain.has_method("set_camera"):
		terrain.set_camera(rts_camera)

	# Remove temp camera
	if camera:
		camera.queue_free()
		camera = null

	var input_handler := preload("res://src/control/rts_input_handler.gd").new()
	input_handler.name = "RTSInputHandler"
	input_handler.camera = rts_camera
	add_child(input_handler)

	print("[SimpleNavTest] Camera setup complete")
