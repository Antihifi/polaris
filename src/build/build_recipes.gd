class_name BuildRecipes
extends RefCounted
## Static database of all build recipes.

static var _recipes: Dictionary = {}
static var _initialized: bool = false


static func _init_recipes() -> void:
	## Initialize all recipes. Called lazily on first access.
	if _initialized:
		return
	_initialized = true

	# Crate - 2 days, simplest build
	var crate := BuildRecipe.new()
	crate.id = &"crate"
	crate.display_name = "Crate"
	crate.description = "A wooden storage crate for supplies."
	crate.construction_days = 2
	crate.required_materials = {"scrap_wood": 3, "nails": 1}
	crate.result_scene_path = "res://objects/storage_crate_small.tscn"
	_recipes[&"crate"] = crate

	# Barrel - 3 days
	var barrel := BuildRecipe.new()
	barrel.id = &"barrel"
	barrel.display_name = "Barrel"
	barrel.description = "A sturdy barrel for food storage."
	barrel.construction_days = 3
	barrel.required_materials = {"scrap_wood": 4, "nails": 2}
	barrel.result_scene_path = "res://objects/storage_barrel.tscn"
	_recipes[&"barrel"] = barrel

	# Tent Frame - 4 days
	var tent_frame := BuildRecipe.new()
	tent_frame.id = &"tent_frame"
	tent_frame.display_name = "Tent Frame"
	tent_frame.description = "Wooden poles for tent construction."
	tent_frame.construction_days = 4
	tent_frame.required_materials = {"scrap_wood": 5, "nails": 3}
	tent_frame.result_scene_path = "res://objects/small_tent1/small_tent_1.tscn"
	_recipes[&"tent_frame"] = tent_frame

	# Firewood Bundle - 1 day, no nails (no scene - uses default box)
	var firewood := BuildRecipe.new()
	firewood.id = &"firewood_bundle"
	firewood.display_name = "Firewood Bundle"
	firewood.description = "Processed wood for burning."
	firewood.construction_days = 1
	firewood.required_materials = {"scrap_wood": 2}
	# No scene path - will use default box mesh
	_recipes[&"firewood_bundle"] = firewood

	# Sled - 10 days, most complex
	var sled := BuildRecipe.new()
	sled.id = &"sled"
	sled.display_name = "Sled"
	sled.description = "A sturdy sled for hauling supplies across the ice."
	sled.construction_days = 10
	sled.required_materials = {"scrap_wood": 10, "nails": 5}
	sled.result_scene_path = "res://objects/sled1/sled_1.tscn"
	_recipes[&"sled"] = sled


static func get_recipe(id: StringName) -> BuildRecipe:
	## Get a recipe by ID. Returns null if not found.
	_init_recipes()
	return _recipes.get(id, null) as BuildRecipe


static func get_all_recipes() -> Array[BuildRecipe]:
	## Get all available recipes.
	_init_recipes()
	var result: Array[BuildRecipe] = []
	for recipe: BuildRecipe in _recipes.values():
		result.append(recipe)
	return result


static func get_recipe_ids() -> Array[StringName]:
	## Get all recipe IDs.
	_init_recipes()
	var ids: Array[StringName] = []
	for id: StringName in _recipes.keys():
		ids.append(id)
	return ids
