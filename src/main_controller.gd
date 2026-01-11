extends Node
## Main scene controller - sets up RTS input handling, HUD, and character spawning.
## Attach this script to the root node of main.tscn
## Navigation is handled by Terrain3D's baked NavigationMesh.

## Terrain generation classes
const TerrainGenerator := preload("res://src/terrain/terrain_generator.gd")

@onready var rts_camera: Camera3D = $RTScamera
@onready var captain: Node3D = $Captain

## Number of survivors to spawn for testing (0 = none)
@export var test_survivor_count: int = 0

## Spawn radius around captain
@export var spawn_radius: float = 30.0

## Number of containers to spawn (barrels and crates)
@export var barrel_count: int = 6
@export var crate_count: int = 6

var input_handler: Node
var game_hud: CanvasLayer
var character_spawner: Node
var object_spawner: Node
var inventory_hud: CanvasLayer
var terrain_generator: Node

## Set to true to generate procedural terrain on startup
@export var enable_terrain_generation: bool = false


func _ready() -> void:
	# Create and add the RTS input handler
	input_handler = preload("res://src/control/rts_input_handler.gd").new()
	input_handler.name = "RTSInputHandler"
	input_handler.camera = rts_camera
	add_child(input_handler)

	# Create and add the game HUD
	var hud_scene := preload("res://ui/game_hud.tscn")
	game_hud = hud_scene.instantiate()
	add_child(game_hud)

	# Generate procedural terrain if enabled
	if enable_terrain_generation and GameManager.is_new_game:
		await _generate_terrain()

	# Create character spawner
	character_spawner = preload("res://src/systems/character_spawner.gd").new()
	character_spawner.name = "CharacterSpawner"
	character_spawner.spawn_radius = spawn_radius
	add_child(character_spawner)

	# Create object spawner (containers)
	object_spawner = preload("res://src/systems/object_spawner.gd").new()
	object_spawner.name = "ObjectSpawner"
	object_spawner.spawn_radius = spawn_radius
	add_child(object_spawner)

	# Create inventory HUD (use scene for easier UI customization)
	var inventory_hud_scene := preload("res://ui/inventory_hud.tscn")
	inventory_hud = inventory_hud_scene.instantiate()
	add_child(inventory_hud)

	# Connect container click to inventory HUD
	input_handler.container_clicked.connect(_on_container_clicked)

	# Add NeedsController to captain
	_add_needs_controller(captain)

	# Focus camera on captain initially
	if rts_camera.has_method("focus_on"):
		rts_camera.focus_on(captain, true)

	# Spawn containers and test survivors
	call_deferred("_spawn_initial_objects")
	if test_survivor_count > 0:
		_spawn_test_survivors()


func _generate_terrain() -> void:
	## Generate procedural terrain from seed.
	print("[MainController] Starting terrain generation...")

	# Ensure seed is initialized
	if not GameManager.seed_manager:
		GameManager.initialize_seed()

	# Create terrain generator
	terrain_generator = TerrainGenerator.new()
	terrain_generator.name = "TerrainGenerator"
	add_child(terrain_generator)

	# Connect progress signals
	terrain_generator.generation_progress.connect(_on_terrain_progress)
	terrain_generator.generation_completed.connect(_on_terrain_completed)
	terrain_generator.generation_failed.connect(_on_terrain_failed)

	# Start generation and wait for completion
	await terrain_generator.generate(GameManager.seed_manager)

	# Clean up
	terrain_generator.queue_free()
	terrain_generator = null

	print("[MainController] Terrain generation complete")


func _on_terrain_progress(stage: String, percent: float) -> void:
	## Forward terrain progress to GameManager for UI.
	GameManager.terrain_generation_progress.emit(stage, percent)
	print("[MainController] Terrain: %s (%.0f%%)" % [stage, percent * 100])


func _on_terrain_completed(pois: Dictionary) -> void:
	## Store POI locations when terrain generation completes.
	GameManager.set_poi_locations(pois)

	# Move captain to ship position if it exists
	var ship_pos := GameManager.get_ship_position()
	if ship_pos != Vector3.ZERO and captain:
		captain.global_position = ship_pos + Vector3(0, 1, 0)  # Slightly above ground
		print("[MainController] Moved captain to ship position: %s" % ship_pos)


func _on_terrain_failed(reason: String) -> void:
	## Handle terrain generation failure.
	push_error("[MainController] Terrain generation failed: %s" % reason)
	# Continue with existing terrain as fallback


func _spawn_test_survivors() -> void:
	## Spawn survivors around the captain for testing.
	var spawn_center := captain.global_position if captain else Vector3.ZERO
	print("[MainController] Spawning %d test survivors around %s" % [test_survivor_count, spawn_center])

	# Wait a frame for navigation to be ready
	await get_tree().process_frame

	var survivors: Array[Node] = character_spawner.spawn_survivors(test_survivor_count, spawn_center)
	print("[MainController] Spawned %d survivors" % survivors.size())

	# Add NeedsController to each spawned survivor
	for survivor in survivors:
		_add_needs_controller(survivor)

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


func _spawn_initial_objects() -> void:
	## Spawn containers around the captain.
	if barrel_count <= 0 and crate_count <= 0:
		return

	var spawn_center := captain.global_position if captain else Vector3.ZERO
	print("[MainController] Spawning %d barrels and %d crates around %s" % [barrel_count, crate_count, spawn_center])

	object_spawner.spawn_containers(barrel_count, crate_count, spawn_center)


func _on_container_clicked(container: StorageContainer) -> void:
	## Handle container click - open inventory UI.
	container.open()
	inventory_hud.open_container(container)


func _add_needs_controller(unit: Node) -> void:
	## Add NeedsController component to a unit.
	if not unit:
		return
	var NeedsControllerScript: Script = preload("res://src/ai/needs_controller.gd")
	var needs: Node = NeedsControllerScript.new()
	needs.name = "NeedsController"
	unit.add_child(needs)
