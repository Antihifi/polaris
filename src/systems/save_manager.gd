extends Node
## Singleton managing game saves and loads.
## Coordinates Terrain3D, Sky3D, Gloot, and custom serialization.
## Access via SaveManager autoload.

signal save_completed(slot: String, success: bool)
signal load_completed(slot: String, success: bool)
signal autosave_triggered

const SAVE_DIR := "user://saves/"
const AUTOSAVE_SLOT := "autosave"
const MAX_MANUAL_SLOTS := 3

## Enable autosave on day change.
@export var autosave_enabled: bool = true


func _ready() -> void:
	# Connect to TimeManager for autosave on day change.
	var time_manager := get_node_or_null("/root/TimeManager")
	if time_manager and time_manager.has_signal("day_passed"):
		time_manager.day_passed.connect(_on_day_passed)
		print("[SaveManager] Connected to TimeManager for autosave")


func _on_day_passed(_day: int) -> void:
	## Trigger autosave at start of each new day.
	if autosave_enabled:
		autosave_triggered.emit()
		save_game(AUTOSAVE_SLOT)


# =============================================================================
# SAVE GAME
# =============================================================================

func save_game(slot: String) -> bool:
	## Save current game state to slot.
	## Returns true on success.
	var save_dir := SAVE_DIR + slot + "/"

	# Ensure directories exist.
	_ensure_directory(save_dir)
	_ensure_directory(save_dir + "terrain/")
	_ensure_directory(save_dir + "inventories/")

	var success := true

	# 1. Save terrain (Terrain3D built-in).
	if not _save_terrain(save_dir + "terrain/"):
		push_warning("[SaveManager] Terrain save failed")
		success = false

	# 2. Save NavMesh cache.
	if not _save_navmesh(save_dir + "navmesh.tres"):
		push_warning("[SaveManager] NavMesh save failed")
		# Non-critical - can rebake on load.

	# 3. Build game state dictionary.
	var game_data := {
		"version": 1,
		"timestamp": Time.get_unix_time_from_system(),
		"seed": _get_seed_string(),
		"time": _serialize_time(),
		"units": _serialize_units(),
		"pois": _serialize_pois(),
		"npcs": _serialize_npcs(),
		"errant_men": _serialize_errant_men(),
		"buildings": _serialize_buildings(),
		"ship_resources": _serialize_ship_resources()
	}

	# 4. Save game state JSON.
	if not _save_json(save_dir + "game_state.json", game_data):
		push_error("[SaveManager] Game state save failed")
		success = false

	# 5. Save container inventories.
	if not _save_inventories(save_dir + "inventories/"):
		push_warning("[SaveManager] Some inventories failed to save")

	if success:
		print("[SaveManager] Game saved to slot: %s" % slot)

	save_completed.emit(slot, success)
	return success


# =============================================================================
# LOAD GAME
# =============================================================================

func load_game(slot: String) -> bool:
	## Load game state from slot.
	## Returns true on success.
	var save_dir := SAVE_DIR + slot + "/"

	if not DirAccess.dir_exists_absolute(save_dir):
		push_error("[SaveManager] Save slot not found: %s" % slot)
		load_completed.emit(slot, false)
		return false

	var success := true

	# 1. Load game state JSON first (need seed before terrain).
	var game_data := _load_json(save_dir + "game_state.json")
	if game_data.is_empty():
		push_error("[SaveManager] Failed to load game state")
		load_completed.emit(slot, false)
		return false

	# 2. Load terrain.
	if not _load_terrain(save_dir + "terrain/"):
		push_error("[SaveManager] Terrain load failed")
		success = false

	# 3. Load NavMesh (or rebake).
	if not _load_navmesh(save_dir + "navmesh.tres"):
		print("[SaveManager] NavMesh not found, will rebake on demand")

	# 4. Restore time state.
	_deserialize_time(game_data.get("time", {}))

	# 5. Restore units.
	_deserialize_units(game_data.get("units", []))

	# 6. Restore buildings.
	_deserialize_buildings(game_data.get("buildings", {}))

	# 7. Restore ship resources.
	_deserialize_ship_resources(game_data.get("ship_resources", {}))

	# 8. Load container inventories.
	_load_inventories(save_dir + "inventories/")

	if success:
		print("[SaveManager] Game loaded from slot: %s" % slot)

	load_completed.emit(slot, success)
	return success


# =============================================================================
# SLOT MANAGEMENT
# =============================================================================

func get_save_slots() -> Array[Dictionary]:
	## Returns info about all save slots (manual + autosave).
	var slots: Array[Dictionary] = []

	# Autosave slot.
	var autosave_info := _get_slot_info(AUTOSAVE_SLOT)
	if not autosave_info.is_empty():
		autosave_info["is_autosave"] = true
		slots.append(autosave_info)

	# Manual slots.
	for i in range(1, MAX_MANUAL_SLOTS + 1):
		var slot_name := "slot_%d" % i
		var slot_info := _get_slot_info(slot_name)
		slot_info["slot_name"] = slot_name
		slot_info["is_autosave"] = false
		slots.append(slot_info)

	return slots


func _get_slot_info(slot: String) -> Dictionary:
	## Get info about a save slot.
	var save_dir := SAVE_DIR + slot + "/"
	var info := {"slot_name": slot, "exists": false}

	if not DirAccess.dir_exists_absolute(save_dir):
		return info

	var game_data := _load_json(save_dir + "game_state.json")
	if game_data.is_empty():
		return info

	info["exists"] = true
	info["timestamp"] = game_data.get("timestamp", 0)
	info["seed"] = game_data.get("seed", "unknown")

	var time_data: Dictionary = game_data.get("time", {})
	info["day"] = time_data.get("current_day", 1)
	info["days_until_rescue"] = time_data.get("days_until_rescue", 0)

	return info


func delete_save(slot: String) -> bool:
	## Delete a save slot.
	var save_dir := SAVE_DIR + slot + "/"
	if not DirAccess.dir_exists_absolute(save_dir):
		return true

	# Recursively delete directory contents.
	return _delete_directory_recursive(save_dir)


func has_save(slot: String) -> bool:
	## Check if a save slot exists.
	var save_dir := SAVE_DIR + slot + "/"
	return DirAccess.dir_exists_absolute(save_dir) and FileAccess.file_exists(save_dir + "game_state.json")


# =============================================================================
# TERRAIN SERIALIZATION
# =============================================================================

func _save_terrain(terrain_dir: String) -> bool:
	## Save terrain using Terrain3D built-in method.
	var terrain := _find_terrain3d()
	if not terrain or not "data" in terrain or not terrain.data:
		return false

	terrain.data.save_directory(terrain_dir)
	print("[SaveManager] Terrain saved to: %s" % terrain_dir)
	return true


func _load_terrain(terrain_dir: String) -> bool:
	## Load terrain using Terrain3D built-in method.
	var terrain := _find_terrain3d()
	if not terrain:
		return false

	if not DirAccess.dir_exists_absolute(terrain_dir):
		return false

	terrain.data_directory = terrain_dir
	print("[SaveManager] Terrain loaded from: %s" % terrain_dir)
	return true


# =============================================================================
# NAVMESH SERIALIZATION
# =============================================================================

func _save_navmesh(navmesh_path: String) -> bool:
	## Save NavigationMesh resource.
	var nav_region := _find_navigation_region()
	if not nav_region or not nav_region.navigation_mesh:
		return false

	var err := ResourceSaver.save(nav_region.navigation_mesh, navmesh_path)
	if err == OK:
		print("[SaveManager] NavMesh saved to: %s" % navmesh_path)
		return true
	return false


func _load_navmesh(navmesh_path: String) -> bool:
	## Load NavigationMesh resource.
	if not ResourceLoader.exists(navmesh_path):
		return false

	var nav_region := _find_navigation_region()
	if not nav_region:
		return false

	var nav_mesh := ResourceLoader.load(navmesh_path)
	if nav_mesh:
		nav_region.navigation_mesh = nav_mesh
		print("[SaveManager] NavMesh loaded from: %s" % navmesh_path)
		return true
	return false


# =============================================================================
# TIME SERIALIZATION
# =============================================================================

func _serialize_time() -> Dictionary:
	## Serialize time state from TimeManager and Sky3D.
	var time_manager := get_node_or_null("/root/TimeManager")
	if not time_manager:
		return {}

	var data := {
		"current_day": time_manager.current_day,
		"current_season": time_manager.current_season,
		"days_until_rescue": time_manager.days_until_rescue,
		"total_days_to_rescue": time_manager.total_days_to_rescue,
		"time_scale": time_manager.time_scale
	}

	# Use Sky3D unix timestamp if available.
	if time_manager.sky3d and time_manager.sky3d.tod:
		data["unix_timestamp"] = time_manager.sky3d.tod.get_unix_timestamp()

	return data


func _deserialize_time(data: Dictionary) -> void:
	## Restore time state to TimeManager and Sky3D.
	if data.is_empty():
		return

	var time_manager := get_node_or_null("/root/TimeManager")
	if not time_manager:
		return

	time_manager.current_day = data.get("current_day", 1)
	time_manager.current_season = data.get("current_season", 0)
	time_manager.days_until_rescue = data.get("days_until_rescue", 365)
	time_manager.total_days_to_rescue = data.get("total_days_to_rescue", 365)
	time_manager.set_time_scale(data.get("time_scale", 1.0))

	# Restore Sky3D time.
	if time_manager.sky3d and time_manager.sky3d.tod and data.has("unix_timestamp"):
		time_manager.sky3d.tod.set_from_unix_timestamp(data.get("unix_timestamp"))

	print("[SaveManager] Time restored: Day %d, %d days until rescue" % [
		time_manager.current_day, time_manager.days_until_rescue])


# =============================================================================
# UNIT SERIALIZATION
# =============================================================================

func _serialize_units() -> Array:
	## Serialize all discovered units.
	var units_data: Array = []

	for unit in get_tree().get_nodes_in_group("selectable_units"):
		if not unit.has_method("get_display_info"):
			continue

		var unit_data := {
			"name": unit.unit_name if "unit_name" in unit else "Unknown",
			"rank": unit.rank if "rank" in unit else 0,
			"position": _vector3_to_array(unit.global_position),
			"rotation_y": unit.rotation.y,
			"is_discovered": unit.is_discovered if "is_discovered" in unit else true
		}

		# Serialize stats.
		if "stats" in unit and unit.stats:
			unit_data["stats"] = {
				"health": unit.stats.health,
				"hunger": unit.stats.hunger,
				"warmth": unit.stats.warmth,
				"energy": unit.stats.energy,
				"morale": unit.stats.morale
			}

		# Serialize inventory using Gloot's built-in method.
		if "inventory" in unit and unit.inventory:
			unit_data["inventory"] = unit.inventory.serialize()

		units_data.append(unit_data)

	return units_data


func _deserialize_units(units_data: Array) -> void:
	## Restore unit states.
	if units_data.is_empty():
		return

	var existing_units := get_tree().get_nodes_in_group("selectable_units")

	for unit_data: Dictionary in units_data:
		var unit_name: String = unit_data.get("name", "")

		# Find matching unit by name.
		var unit: Node = null
		for existing in existing_units:
			if "unit_name" in existing and existing.unit_name == unit_name:
				unit = existing
				break

		if not unit:
			push_warning("[SaveManager] Unit not found: %s" % unit_name)
			continue

		# Restore position.
		var pos_array: Array = unit_data.get("position", [])
		if pos_array.size() >= 3:
			unit.global_position = Vector3(pos_array[0], pos_array[1], pos_array[2])

		unit.rotation.y = unit_data.get("rotation_y", 0.0)

		# Restore stats.
		var stats_data: Dictionary = unit_data.get("stats", {})
		if not stats_data.is_empty() and "stats" in unit and unit.stats:
			unit.stats.health = stats_data.get("health", 100.0)
			unit.stats.hunger = stats_data.get("hunger", 100.0)
			unit.stats.warmth = stats_data.get("warmth", 100.0)
			unit.stats.energy = stats_data.get("energy", 100.0)
			unit.stats.morale = stats_data.get("morale", 75.0)

		# Restore inventory using Gloot's built-in method.
		var inv_data: Dictionary = unit_data.get("inventory", {})
		if not inv_data.is_empty() and "inventory" in unit and unit.inventory:
			unit.inventory.deserialize(inv_data)

	print("[SaveManager] Restored %d units" % units_data.size())


# =============================================================================
# ERRANT MEN SERIALIZATION
# =============================================================================

func _serialize_errant_men() -> Array:
	## Serialize undiscovered errant men.
	var errant_data: Array = []

	for unit in get_tree().get_nodes_in_group("survivors"):
		if "is_discovered" in unit and not unit.is_discovered:
			errant_data.append({
				"name": unit.unit_name if "unit_name" in unit else "Unknown",
				"position": _vector3_to_array(unit.global_position),
				"leash_center": _vector3_to_array(unit.leash_center) if "leash_center" in unit else [],
				"leash_radius": unit.leash_radius if "leash_radius" in unit else 20.0
			})

	return errant_data


# =============================================================================
# POI SERIALIZATION
# =============================================================================

func _serialize_pois() -> Dictionary:
	## Serialize POI locations.
	# POIs are static - stored in procedural_game_controller._pois
	var controller := _find_procedural_controller()
	if controller and "_pois" in controller:
		var pois_copy := {}
		for key: String in controller._pois:
			var pos: Vector3 = controller._pois[key]
			pois_copy[key] = _vector3_to_array(pos)
		return pois_copy
	return {}


# =============================================================================
# NPC SERIALIZATION (polar bears, seals, etc.)
# =============================================================================

func _serialize_npcs() -> Array:
	## Serialize NPCs (placeholder for future wildlife).
	# Currently no NPCs implemented - return empty.
	return []


# =============================================================================
# BUILDING SERIALIZATION
# =============================================================================

func _serialize_buildings() -> Dictionary:
	## Serialize construction sites and workbenches.
	var data := {
		"construction_sites": [],
		"workbenches": []
	}

	# Serialize construction sites.
	for site in get_tree().get_nodes_in_group("construction_sites"):
		if site is ConstructionSite:
			var site_data := {
				"recipe_id": site.recipe.id if site.recipe else "",
				"position": _vector3_to_array(site.global_position),
				"rotation": _vector3_to_array(site.global_rotation),
				"progress": site.construction_progress,
				"materials_deposited": site.materials_deposited.duplicate()
			}
			data["construction_sites"].append(site_data)

	# Serialize workbenches.
	for workbench in get_tree().get_nodes_in_group("workbenches"):
		var component := workbench.get_node_or_null("WorkbenchComponent") as WorkbenchComponent
		if not component:
			# Check if workbench IS the component.
			component = workbench as WorkbenchComponent

		if component:
			var wb_data := {
				"position": _vector3_to_array(workbench.global_position),
				"stored_materials": component.stored_materials.duplicate()
			}
			data["workbenches"].append(wb_data)

	return data


func _deserialize_buildings(data: Dictionary) -> void:
	## Restore building states.
	if data.is_empty():
		return

	# Restore workbench materials.
	var workbenches := get_tree().get_nodes_in_group("workbenches")
	var wb_data_list: Array = data.get("workbenches", [])

	for wb_data: Dictionary in wb_data_list:
		var pos := _array_to_vector3(wb_data.get("position", []))

		# Find nearest workbench to saved position.
		var nearest: Node = null
		var nearest_dist: float = 10.0  # Max 10m tolerance.
		for wb in workbenches:
			var wb_node: Node3D = wb as Node3D
			if not wb_node:
				continue
			var dist: float = wb_node.global_position.distance_to(pos)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest = wb

		if nearest:
			var component := nearest.get_node_or_null("WorkbenchComponent") as WorkbenchComponent
			if component:
				component.stored_materials = wb_data.get("stored_materials", {}).duplicate()

	# TODO: Restore construction sites (requires spawning ConstructionSite nodes).
	# This is more complex - would need to recreate sites with proper recipes.

	print("[SaveManager] Building states restored")


# =============================================================================
# SHIP RESOURCES SERIALIZATION
# =============================================================================

func _serialize_ship_resources() -> Dictionary:
	## Serialize ship resource pool.
	for node in get_tree().get_nodes_in_group("ship_resources"):
		var component := node.get_node_or_null("ShipResourceComponent") as ShipResourceComponent
		if not component:
			component = node as ShipResourceComponent

		if component:
			return {"material_pool": component.material_pool.duplicate()}

	return {}


func _deserialize_ship_resources(data: Dictionary) -> void:
	## Restore ship resource pool.
	if data.is_empty():
		return

	for node in get_tree().get_nodes_in_group("ship_resources"):
		var component := node.get_node_or_null("ShipResourceComponent") as ShipResourceComponent
		if not component:
			component = node as ShipResourceComponent

		if component and data.has("material_pool"):
			component.material_pool = data.get("material_pool", {}).duplicate()
			print("[SaveManager] Ship resources restored")
			return


# =============================================================================
# INVENTORY SERIALIZATION (Containers)
# =============================================================================

func _save_inventories(inv_dir: String) -> bool:
	## Save all container inventories.
	var success := true

	for container in get_tree().get_nodes_in_group("containers"):
		if "inventory" in container and container.inventory:
			var inv_data: Dictionary = container.inventory.serialize()
			var filename := _sanitize_filename(container.name) + ".json"
			if not _save_json(inv_dir + filename, inv_data):
				success = false

	return success


func _load_inventories(inv_dir: String) -> void:
	## Load all container inventories.
	if not DirAccess.dir_exists_absolute(inv_dir):
		return

	for container in get_tree().get_nodes_in_group("containers"):
		if "inventory" in container and container.inventory:
			var filename := _sanitize_filename(container.name) + ".json"
			var inv_data := _load_json(inv_dir + filename)
			if not inv_data.is_empty():
				container.inventory.deserialize(inv_data)


# =============================================================================
# HELPERS
# =============================================================================

func _ensure_directory(path: String) -> void:
	## Create directory if it doesn't exist.
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path)


func _save_json(path: String, data: Dictionary) -> bool:
	## Save dictionary as JSON file.
	var json_string := JSON.stringify(data, "\t")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("[SaveManager] Cannot open file for writing: %s" % path)
		return false
	file.store_string(json_string)
	file.close()
	return true


func _load_json(path: String) -> Dictionary:
	## Load dictionary from JSON file.
	if not FileAccess.file_exists(path):
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}

	var json_string := file.get_as_text()
	file.close()

	var json := JSON.new()
	var err := json.parse(json_string)
	if err != OK:
		push_error("[SaveManager] JSON parse error: %s" % json.get_error_message())
		return {}

	return json.data as Dictionary


func _delete_directory_recursive(path: String) -> bool:
	## Recursively delete a directory and its contents.
	var dir := DirAccess.open(path)
	if not dir:
		return false

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		var full_path := path + file_name
		if dir.current_is_dir():
			_delete_directory_recursive(full_path + "/")
		else:
			dir.remove(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	return DirAccess.remove_absolute(path) == OK


func _sanitize_filename(name: String) -> String:
	## Remove invalid characters from filename.
	return name.replace("/", "_").replace("\\", "_").replace(":", "_")


func _vector3_to_array(v: Vector3) -> Array:
	## Convert Vector3 to array for JSON.
	return [v.x, v.y, v.z]


func _array_to_vector3(arr: Array) -> Vector3:
	## Convert array to Vector3.
	if arr.size() >= 3:
		return Vector3(arr[0], arr[1], arr[2])
	return Vector3.ZERO


func _find_terrain3d() -> Node:
	## Find Terrain3D node.
	var nodes := get_tree().get_nodes_in_group("terrain")
	return nodes[0] if nodes.size() > 0 else null


func _find_navigation_region() -> NavigationRegion3D:
	## Find NavigationRegion3D in scene.
	# Check RuntimeNavBaker first.
	var baker := get_tree().current_scene.find_child("RuntimeNavBaker", true, false)
	if baker and "navigation_region" in baker:
		return baker.navigation_region

	# Fallback to any NavigationRegion3D.
	var regions := get_tree().get_nodes_in_group("navigation_regions")
	if regions.size() > 0:
		return regions[0] as NavigationRegion3D

	return null


func _find_procedural_controller() -> Node:
	## Find ProceduralGameController.
	return get_tree().current_scene


func _get_seed_string() -> String:
	## Get current game seed.
	var controller := _find_procedural_controller()
	if controller and "_seed_manager" in controller and controller._seed_manager:
		return controller._seed_manager.get_seed_string()
	return "unknown"
