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

## Number of containers to spawn (barrels and crates)
@export var barrel_count: int = 6
@export var crate_count: int = 6

## Number of fires to spawn 
@export var fire_count: int = 2

var input_handler: Node
var game_hud: CanvasLayer
var character_spawner: Node
var object_spawner: Node
var inventory_hud: CanvasLayer
var sled_panel: Control


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

	# Create sled interaction panel
	var sled_panel_scene := preload("res://ui/sled_panel.tscn")
	sled_panel = sled_panel_scene.instantiate()
	add_child(sled_panel)

	# Connect sled click to sled panel
	input_handler.sled_clicked.connect(_on_sled_clicked)

	# Captain is player-controlled only - no AI controller

	# Focus camera on captain initially
	if rts_camera.has_method("focus_on"):
		rts_camera.focus_on(captain, true)

	# Spawn containers and test survivors
	call_deferred("_spawn_initial_objects")
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

	# Add AI controller to each spawned survivor
	for survivor in survivors:
		_add_ai_controller(survivor)

	# Print summary
	character_spawner.print_survivor_summary()


## Officer scene for F4 spawning
var officer_scene: PackedScene = preload("res://src/characters/officers.tscn")
var spawned_officer_count: int = 0


func _unhandled_input(event: InputEvent) -> void:
	# Debug key bindings
	if event is InputEventKey and event.pressed:
		var key := event as InputEventKey

		# F4: Spawn one officer at camera focus
		if key.keycode == KEY_F4:
			_spawn_test_officer()

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

	object_spawner.spawn_containers(barrel_count, crate_count, fire_count, spawn_center)


func _on_container_clicked(container: StorageContainer) -> void:
	## Handle container click - open inventory UI.
	container.open()
	inventory_hud.open_container(container)


func _on_sled_clicked(sled: Node) -> void:
	## Handle sled right-click - show sled interaction panel.
	if not sled or not sled_panel:
		return
	# Get currently selected units from input handler
	var selected: Array[Node] = input_handler.get_selected_units()
	if selected.is_empty():
		return
	sled_panel.show_for_sled(sled, selected, rts_camera)


func _add_ai_controller(unit: Node) -> void:
	## Add ManAIController component to a unit for behavior tree AI.
	if not unit:
		return
	var ManAIControllerScript: Script = preload("res://ai/man_ai_controller.gd")
	var ai_controller: Node = ManAIControllerScript.new()
	ai_controller.name = "ManAIController"
	# Load the behavior tree
	ai_controller.behavior_tree = preload("res://ai/man_bt.tres")
	unit.add_child(ai_controller)


func _spawn_test_officer() -> void:
	## Spawn a single officer near the captain for testing (F4).
	## Officers have no AI - fully player controlled like the captain.
	var spawn_center := captain.global_position if captain else Vector3.ZERO

	# Offset spawn position slightly from captain
	var offset := Vector3(randf_range(-5.0, 5.0), 0, randf_range(-5.0, 5.0))
	var spawn_pos := spawn_center + offset

	# Get terrain height at spawn position
	var terrain: Node = _find_terrain3d()
	if terrain and "data" in terrain and terrain.data:
		var height: float = terrain.data.get_height(spawn_pos)
		if not is_nan(height):
			spawn_pos.y = height

	# Instantiate officer
	var officer: Node = officer_scene.instantiate()
	spawned_officer_count += 1
	officer.unit_name = "Officer %d" % spawned_officer_count
	officer.movement_speed = 5.0  # Match Men speed (CharacterSpawner sets 5.0)

	# Add to scene tree FIRST (before setting global_position)
	add_child(officer)
	officer.global_position = spawn_pos

	print("[MainController] Spawned %s at %s (F4)" % [officer.unit_name, spawn_pos])


func _find_terrain3d() -> Node:
	## Find the Terrain3D node in the scene by searching recursively.
	return _find_node_by_class(self, "Terrain3D")


func _find_node_by_class(node: Node, class_name_to_find: String) -> Node:
	if node.get_class() == class_name_to_find:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_to_find)
		if result:
			return result
	return null
