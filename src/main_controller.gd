extends Node
## Main scene controller - sets up RTS input handling, HUD, and character spawning.
## Attach this script to the root node of main.tscn
## Navigation is handled by Terrain3D's baked NavigationMesh.

@onready var rts_camera: Camera3D = $RTScamera
@onready var captain: Node3D = $Captain

## Number of survivors to spawn for testing (0 = none)
@export var test_survivor_count: int = 0

## Spawn radius around captain
@export var spawn_radius: float = 30.0

var input_handler: Node
var game_hud: CanvasLayer
var character_spawner: Node


func _ready() -> void:
	# Create and add the RTS input handler
	input_handler = preload("res://src/control/rts_input_handler.gd").new()
	input_handler.name = "RTSInputHandler"
	input_handler.camera = rts_camera
	add_child(input_handler)

	# Create and add the game HUD
	var hud_scene := preload("res://src/ui/game_hud.tscn")
	game_hud = hud_scene.instantiate()
	add_child(game_hud)

	# Create character spawner
	character_spawner = preload("res://src/systems/character_spawner.gd").new()
	character_spawner.name = "CharacterSpawner"
	character_spawner.spawn_radius = spawn_radius
	add_child(character_spawner)

	# Focus camera on captain initially
	if rts_camera.has_method("focus_on"):
		rts_camera.focus_on(captain, true)

	# Spawn test survivors if configured
	if test_survivor_count > 0:
		_spawn_test_survivors()


func _spawn_test_survivors() -> void:
	## Spawn survivors around the captain for testing.
	var spawn_center := captain.global_position if captain else Vector3.ZERO
	print("[MainController] Spawning %d test survivors around %s" % [test_survivor_count, spawn_center])

	# Wait a frame for navigation to be ready
	await get_tree().process_frame

	var survivors: Array[Node] = character_spawner.spawn_survivors(test_survivor_count, spawn_center)
	print("[MainController] Spawned %d survivors" % survivors.size())

	# Print summary
	character_spawner.print_survivor_summary()


func _unhandled_input(event: InputEvent) -> void:
	# Debug key bindings
	if event is InputEventKey and event.pressed:
		var key := event as InputEventKey

		# F5: Spawn 10 more survivors
		if key.keycode == KEY_F5:
			var spawn_center := captain.global_position if captain else Vector3.ZERO
			character_spawner.spawn_survivors(10, spawn_center)
			print("[MainController] Spawned 10 more survivors (F5)")

		# F6: Spawn 30 more survivors
		elif key.keycode == KEY_F6:
			var spawn_center := captain.global_position if captain else Vector3.ZERO
			character_spawner.spawn_survivors(30, spawn_center)
			print("[MainController] Spawned 30 more survivors (F6)")

		# F7: Print survivor summary
		elif key.keycode == KEY_F7:
			character_spawner.print_survivor_summary()

		# F8: Despawn all spawned survivors
		elif key.keycode == KEY_F8:
			character_spawner.despawn_all()
			print("[MainController] Despawned all survivors (F8)")


## Get all survivors including captain
func get_all_survivors() -> Array[Node]:
	var survivors: Array[Node] = []
	if captain:
		survivors.append(captain)
	survivors.append_array(character_spawner.get_all_survivors())
	return survivors
