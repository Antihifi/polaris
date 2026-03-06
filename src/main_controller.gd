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
var workbench_panel: Control
var ship_resource_panel: Control
var construction_site_panel: Control
var tent_panel: Control
var tent_placement_manager: TentPlacementManager
var butcher_panel: Control


func _ready() -> void:
	# Initialize RNG for officer name generation
	_officer_rng.randomize()

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

	# Create workbench interaction panel
	var workbench_panel_scene := preload("res://ui/workbench_panel.tscn")
	workbench_panel = workbench_panel_scene.instantiate()
	add_child(workbench_panel)

	# Connect workbench click to workbench panel
	input_handler.workbench_clicked.connect(_on_workbench_clicked)

	# Create ship resource panel
	var ship_resource_panel_scene := preload("res://ui/ship_resource_panel.tscn")
	ship_resource_panel = ship_resource_panel_scene.instantiate()
	add_child(ship_resource_panel)

	# Connect ship click to ship resource panel
	input_handler.ship_clicked.connect(_on_ship_clicked)

	# Create construction site panel
	var construction_site_panel_scene := preload("res://ui/construction_site_panel.tscn")
	construction_site_panel = construction_site_panel_scene.instantiate()
	add_child(construction_site_panel)

	# Connect construction site click to construction site panel
	input_handler.construction_site_clicked.connect(_on_construction_site_clicked)

	# Create tent interaction panel and placement manager
	var tent_panel_scene := preload("res://ui/tent_panel.tscn")
	tent_panel = tent_panel_scene.instantiate()
	add_child(tent_panel)
	input_handler.tent_clicked.connect(_on_tent_clicked)

	tent_placement_manager = TentPlacementManager.new()
	tent_placement_manager.name = "TentPlacementManager"
	add_child(tent_placement_manager)

	# Create butcher confirmation panel
	var butcher_panel_scene := preload("res://ui/butcher_panel.tscn")
	butcher_panel = butcher_panel_scene.instantiate()
	add_child(butcher_panel)
	input_handler.corpse_clicked.connect(_on_corpse_clicked)
	input_handler.limb_clicked.connect(_on_limb_clicked)
	butcher_panel.butcher_confirmed.connect(_on_butcher_confirmed)

	# Connect inventory item action (e.g. Place Tent from crate, Carve body parts)
	var container_panel: InventoryPanel = inventory_hud.get_container_panel()
	if container_panel:
		container_panel.item_action_requested.connect(_on_inventory_item_action)

	# Also connect unit panel so carving works from unit inventory
	var unit_panel: InventoryPanel = null  # Dynamic unit panels handle this now
	if unit_panel:
		unit_panel.item_action_requested.connect(_on_inventory_item_action)

	# Enable carve button when unit inventory opens (check if unit has knife)
	inventory_hud.unit_inventory_opened.connect(_on_unit_inventory_opened)

	# Aurora controller (appearance tuned in aurora_controller.tscn)
	var aurora_ctrl: Node = preload("res://src/effects/aurora_controller.tscn").instantiate()
	add_child(aurora_ctrl)
	if aurora_ctrl.has_signal("aurora_started"):
		aurora_ctrl.aurora_started.connect(_on_aurora_started)

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
var _officer_rng: RandomNumberGenerator = RandomNumberGenerator.new()


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


func _on_workbench_clicked(workbench: Node) -> void:
	## Handle workbench right-click - show workbench crafting panel.
	if not workbench or not workbench_panel:
		return
	workbench_panel.show_for_workbench(workbench, rts_camera)


func _on_ship_clicked(clicked_ship: Node) -> void:
	## Handle ship right-click - show ship resource panel.
	if not clicked_ship or not ship_resource_panel:
		return
	if ship_resource_panel.has_method("show_for_ship"):
		ship_resource_panel.show_for_ship(clicked_ship)


func _on_construction_site_clicked(site: Node) -> void:
	## Handle construction site right-click - show construction site panel.
	if not site or not construction_site_panel:
		return
	if construction_site_panel.has_method("show_for_site"):
		construction_site_panel.show_for_site(site, rts_camera)


func _on_tent_clicked(tent: Node) -> void:
	## Handle tent right-click - show tent panel with Store button.
	if not tent or not tent_panel:
		return
	if tent_panel.has_method("show_for_tent"):
		tent_panel.show_for_tent(tent, rts_camera)


func _on_inventory_item_action(item: InventoryItem, action: String) -> void:
	## Handle inventory item action (e.g. placing a tent, carving body parts).
	if action == "place" and tent_placement_manager:
		inventory_hud.close_container()
		tent_placement_manager.start_tent_placement(item)
	elif action == "carve":
		_handle_carve(item)


func _on_unit_inventory_opened(unit: ClickableUnit) -> void:
	## Enable/disable carve button based on whether the unit has a knife.
	var unit_panel: InventoryPanel = null  # Dynamic unit panels handle this now
	if unit_panel and unit:
		var has_knife: bool = unit.has_method("has_item_by_id") and unit.has_item_by_id("knife")
		unit_panel.set_carve_enabled(has_knife)


func _on_corpse_clicked(corpse: Node) -> void:
	## Handle right-click on dead unit or animal — show butcher panel or corpse inventory.
	if not corpse or not is_instance_valid(corpse):
		return
	# If already butchered, open corpse inventory directly.
	var corpse_inv: Inventory = corpse.get_node_or_null("CorpseInventory")
	if corpse_inv:
		_open_corpse_inventory(corpse, corpse_inv)
		return
	# Otherwise show butcher confirmation panel.
	if not butcher_panel:
		return
	var selected: Array[Node] = input_handler.get_selected_units()
	var butcher: Node = selected[0] if not selected.is_empty() else null
	var has_axe: bool = butcher and butcher.has_method("has_item_by_id") and butcher.has_item_by_id("hatchet")
	# Get name for panel display - animals have animal_name, units have unit_name
	var corpse_name: String = ""
	if corpse is Animal:
		corpse_name = corpse.animal_name if "animal_name" in corpse else "Animal"
	elif "unit_name" in corpse:
		corpse_name = corpse.unit_name
	butcher_panel.show_for_corpse(corpse, has_axe, rts_camera, corpse_name)


func _on_limb_clicked(limb: SeveredLimb) -> void:
	## Handle right-click on severed limb - collect if unit has knife.
	if not limb or not is_instance_valid(limb):
		return
	var selected: Array[Node] = input_handler.get_selected_units()
	if selected.is_empty():
		return
	var collector: Node = selected[0]
	if collector.has_method("has_item_by_id") and collector.has_item_by_id("knife"):
		limb.collect(collector)


func _on_butcher_confirmed(corpse: Node3D) -> void:
	## Create corpse inventory with body parts after butcher confirmation.
	## Handles both ClickableUnit (human) and Animal corpses.
	if not corpse or not is_instance_valid(corpse):
		return
	# Validate: must have a selected unit with a hatchet
	var selected: Array[Node] = input_handler.get_selected_units()
	var butcher_unit: Node = selected[0] if not selected.is_empty() else null
	if not butcher_unit or not butcher_unit.has_method("has_item_by_id") or not butcher_unit.has_item_by_id("hatchet"):
		push_warning("[MainController] Butcher attempted without selected unit with hatchet!")
		return
	var protoset: JSON = load("res://data/items_protoset.json")
	var corpse_inv := Inventory.new()
	corpse_inv.name = "CorpseInventory"
	corpse_inv.protoset = protoset
	corpse.add_child(corpse_inv)

	var grid := GridConstraint.new()
	grid.name = "GridConstraint"
	corpse_inv.add_child(grid)

	# Check if this is an animal or human corpse
	if corpse is Animal:
		# Animal butchering - larger grid for bear parts
		grid.size = Vector2i(10, 8)
		_add_animal_body_parts(corpse, corpse_inv)
		var animal_name: String = corpse.animal_name if "animal_name" in corpse else "animal"
		print("[MainController] Butchered %s — body parts created" % animal_name)
		# No butchering horror for animals (not cannibalism)
	else:
		# Human butchering
		grid.size = Vector2i(8, 6)
		corpse_inv.create_and_add_item("human_head")
		corpse_inv.create_and_add_item("human_arm")
		corpse_inv.create_and_add_item("human_arm")
		corpse_inv.create_and_add_item("human_leg")
		corpse_inv.create_and_add_item("human_leg")
		corpse_inv.create_and_add_item("human_torso")
		# Apply butchering horror to all living units within 25m (human only)
		_apply_butchering_horror(corpse.global_position)
		var corpse_name: String = corpse.unit_name if "unit_name" in corpse else "unit"
		print("[MainController] Butchered %s — body parts created" % corpse_name)

	corpse.add_to_group("butchered")
	_open_corpse_inventory(corpse, corpse_inv)


func _add_animal_body_parts(animal: Animal, inv: Inventory) -> void:
	## Add body parts specific to the animal type.
	## For polar bears: head, 4 legs, torso, pelt, fat.
	if animal is PolarBear:
		inv.create_and_add_item("bear_head")
		inv.create_and_add_item("bear_leg")
		inv.create_and_add_item("bear_leg")
		inv.create_and_add_item("bear_leg")
		inv.create_and_add_item("bear_leg")
		inv.create_and_add_item("bear_torso")
		inv.create_and_add_item("bear_pelt")
		inv.create_and_add_item("bear_fat")
	else:
		# Generic animal fallback - just spawn some meat directly
		var meat_count: int = randi_range(animal.meat_min, animal.meat_max) if animal else 3
		var meat_id: String = animal.meat_item_id if animal else "seal_meat"
		for i in range(meat_count):
			inv.create_and_add_item(meat_id)


func _open_corpse_inventory(corpse: Node, corpse_inv: Inventory) -> void:
	## Open the corpse inventory in the container panel.
	var container_panel: InventoryPanel = inventory_hud.get_container_panel()
	if not container_panel:
		return
	# Get name - animals have animal_name, units have unit_name
	var corpse_name: String = "Corpse"
	if corpse is Animal:
		corpse_name = corpse.animal_name if "animal_name" in corpse else "Animal"
	elif "unit_name" in corpse:
		corpse_name = corpse.unit_name
	container_panel.show_inventory(corpse_inv, "REMAINS OF %s" % corpse_name.to_upper())
	# Enable/disable carve based on whether selected unit has a knife.
	var selected: Array[Node] = input_handler.get_selected_units()
	var butcher: Node = selected[0] if not selected.is_empty() else null
	var has_knife: bool = butcher and butcher.has_method("has_item_by_id") and butcher.has_item_by_id("knife")
	container_panel.set_carve_enabled(has_knife)


func _handle_carve(item: InventoryItem) -> void:
	## Carve a body part into meat. Uses hunting_skill and animal size for yield multiplier.
	## Supports both human and animal body parts via meat_item_id property.
	if not item or not is_instance_valid(item):
		return
	# Validate: must have a selected unit with a knife
	var selected: Array[Node] = input_handler.get_selected_units()
	var carver_unit: Node = selected[0] if not selected.is_empty() else null
	if not carver_unit or not carver_unit.has_method("has_item_by_id") or not carver_unit.has_item_by_id("knife"):
		push_warning("[MainController] Carve attempted without selected unit with knife!")
		return
	var inv: Inventory = item.get_inventory()
	if not inv:
		return

	# Calculate skill-based multiplier from hunting_skill (0-100 maps to 0.5-1.5)
	var skill_multiplier: float = 1.0
	if "stats" in carver_unit and carver_unit.stats:
		var hunting_skill: float = carver_unit.stats.hunting_skill if "hunting_skill" in carver_unit.stats else 25.0
		skill_multiplier = remap(hunting_skill, 0.0, 100.0, 0.5, 1.5)

	# Calculate size-based multiplier for animals (5.0-8.5 maps to 0.6-1.2)
	var size_multiplier: float = 1.0
	var corpse: Node = inv.get_parent()  # CorpseInventory's parent is the corpse
	if corpse and corpse is Animal and "size_scale" in corpse:
		size_multiplier = remap(corpse.size_scale, 5.0, 8.5, 0.6, 1.2)

	var meat_yield: int = int(item.get_property("meat_yield", 1))
	var combined_multiplier: float = skill_multiplier * size_multiplier
	var total_meat: int = maxi(1, int(floorf(meat_yield * combined_multiplier)))

	# Determine meat type - animal parts have meat_item_id, human parts default to human_meat
	var meat_item_id: String = str(item.get_property("meat_item_id", "human_meat"))

	inv.remove_item(item)
	for i in range(total_meat):
		inv.create_and_add_item(meat_item_id)
	print("[MainController] Carved body part into %d %s (skill: %.0f%%, size: %.0f%%)" % [total_meat, meat_item_id, skill_multiplier * 100.0, size_multiplier * 100.0])


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

	# Set rank BEFORE add_child so _ready() can configure PassiveAI correctly
	officer.rank = ClickableUnit.UnitRank.OFFICER

	# Generate random name using CharacterSpawner name pools
	var first_name: String = CharacterSpawner.FIRST_NAMES[_officer_rng.randi() % CharacterSpawner.FIRST_NAMES.size()]
	var last_name: String = CharacterSpawner.LAST_NAMES[_officer_rng.randi() % CharacterSpawner.LAST_NAMES.size()]
	officer.unit_name = "Lt. %s %s" % [first_name, last_name]
	officer.movement_speed = 5.0  # Match Men speed (CharacterSpawner sets 5.0)

	# Add to scene tree (triggers _ready which checks rank for PassiveAI setup)
	add_child(officer)
	officer.global_position = spawn_pos

	print("[MainController] Spawned %s at %s (F4)" % [officer.unit_name, spawn_pos])


# --- Morale Events ---

const BUTCHERING_HORROR_RADIUS: float = 25.0

func _apply_butchering_horror(corpse_position: Vector3) -> void:
	## Apply instant 50% morale hit + ongoing decay to all living units within 25m.
	var survivors: Array[Node] = get_tree().get_nodes_in_group("survivors")
	var affected_count: int = 0
	var bark_targets: Array[Node] = []

	for unit: Node in survivors:
		if not is_instance_valid(unit):
			continue
		if "stats" in unit and unit.stats and unit.stats.is_dead():
			continue
		var dist: float = unit.global_position.distance_to(corpse_position)
		if dist > BUTCHERING_HORROR_RADIUS:
			continue
		if unit.has_method("apply_butchering_horror"):
			unit.apply_butchering_horror()
			bark_targets.append(unit)
			affected_count += 1

	# Trigger barks on 1-2 affected units
	bark_targets.shuffle()
	var bark_mgr: Node = get_node_or_null("/root/BarkManager")
	for i in mini(2, bark_targets.size()):
		var u: Node = bark_targets[i]
		if bark_mgr and bark_mgr.has_method("bark_immediate"):
			bark_mgr.bark_immediate(u, "No... God, no... what have we become?", 5.0)

	print("[MainController] Butchering horror: %d units affected within %.0fm" % [affected_count, BUTCHERING_HORROR_RADIUS])


func _on_aurora_started() -> void:
	## Boost all survivors' morale by +25 when aurora event fires.
	var duration_days: int = randi_range(1, 3)
	var duration_hours: int = duration_days * 24

	var survivors: Array[Node] = get_tree().get_nodes_in_group("survivors")
	var bark_targets: Array[Node] = []

	for unit: Node in survivors:
		if not is_instance_valid(unit):
			continue
		if "stats" in unit and unit.stats and unit.stats.is_dead():
			continue
		if unit.has_method("apply_aurora_boost"):
			unit.apply_aurora_boost(duration_hours)
			bark_targets.append(unit)

	# Trigger aurora barks on 2-3 random units
	bark_targets.shuffle()
	var bark_mgr: Node = get_node_or_null("/root/BarkManager")
	for i in mini(3, bark_targets.size()):
		var u: Node = bark_targets[i]
		if bark_mgr and bark_mgr.has_method("bark"):
			var delay: float = randf_range(1.0, 5.0)
			get_tree().create_timer(delay).timeout.connect(func() -> void:
				if is_instance_valid(u) and bark_mgr and bark_mgr.has_method("bark"):
					bark_mgr.bark(u, "aurora", 5.0)
			)

	print("[MainController] Aurora morale boost: +25 to %d units, lasting %d days" % [bark_targets.size(), duration_days])


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
