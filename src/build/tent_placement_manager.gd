class_name TentPlacementManager extends Node
## Manages placing tents from inventory items using the ghost placement system.
## Unlike workbench placement, this skips construction — the tent is placed instantly.

signal tent_placed(position: Vector3, rotation_y: float)
signal tent_placement_cancelled

var _ghost_placement: GhostPlacement = null
var _source_item: InventoryItem = null
var _source_inventory: Inventory = null


func start_tent_placement(item: InventoryItem) -> void:
	## Begin placing a tent from an inventory item.
	var recipe_id: String = item.get_property("recipe_id", "")
	if recipe_id.is_empty():
		push_error("[TentPlacementManager] Item has no recipe_id")
		return

	var recipe: BuildRecipe = BuildRecipes.get_recipe(StringName(recipe_id))
	if not recipe:
		push_error("[TentPlacementManager] Unknown recipe: %s" % recipe_id)
		return

	_source_item = item
	_source_inventory = item.get_inventory()

	# Create ghost placement controller if needed.
	if not _ghost_placement:
		_ghost_placement = GhostPlacement.new()
		_ghost_placement.placement_confirmed.connect(_on_placement_confirmed)
		_ghost_placement.placement_cancelled.connect(_on_placement_cancelled)
		get_tree().current_scene.add_child(_ghost_placement)

	# Pass null workbench — skips distance and material checks.
	_ghost_placement.start_placement(recipe, null)


func _on_placement_confirmed(position: Vector3, rotation_y: float, recipe: BuildRecipe) -> void:
	## Place the tent directly (no construction site — it's already built).
	if not recipe or recipe.result_scene_path.is_empty():
		return

	var scene: PackedScene = load(recipe.result_scene_path)
	if not scene:
		push_error("[TentPlacementManager] Failed to load scene: %s" % recipe.result_scene_path)
		return

	var tent: Node3D = scene.instantiate()
	get_tree().current_scene.add_child(tent)
	tent.global_position = position
	tent.rotation.y = rotation_y
	tent.add_to_group("placed_tents")

	# Add click detection for tent panel interaction.
	_add_tent_click_area(tent)

	# Remove tent item from source inventory.
	if _source_item and is_instance_valid(_source_item) and _source_inventory:
		_source_inventory.remove_item(_source_item)

	_source_item = null
	_source_inventory = null
	tent_placed.emit(position, rotation_y)
	print("[TentPlacementManager] Tent placed at %s" % position)


func _on_placement_cancelled() -> void:
	_source_item = null
	_source_inventory = null
	tent_placement_cancelled.emit()


static func add_tent_click_area(tent: Node3D) -> void:
	## Add an Area3D for click detection on a placed tent. Static for reuse.
	_add_tent_click_area_to(tent)


static func _add_tent_click_area_to(tent: Node3D) -> void:
	## Internal: add click area to tent node.
	var click_area := Area3D.new()
	click_area.name = "TentClickArea"
	click_area.collision_layer = 256  # Layer 9
	click_area.collision_mask = 0
	click_area.monitorable = true
	click_area.monitoring = false

	var collision := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(4.0, 3.0, 4.0)
	collision.shape = box
	collision.position = Vector3(0, 1.5, 0)
	click_area.add_child(collision)
	tent.add_child(click_area)


func _add_tent_click_area(tent: Node3D) -> void:
	_add_tent_click_area_to(tent)
