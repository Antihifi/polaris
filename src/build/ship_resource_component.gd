class_name ShipResourceComponent
extends Node
## Manages the ship's resource pool for gathering materials.
## Workers can gather from anywhere on the ship.

signal material_gathered(material_id: String, count: int)
signal material_depleted(material_id: String)

## Material pool available on the ship.
@export var material_pool: Dictionary = {
	"scrap_wood": 500,
	"nails": 200
}

## Base amount gathered per gathering action.
@export var base_gather_amount: int = 5

## Reference to parent ship node.
var _ship: Node3D = null


func _ready() -> void:
	_ship = get_parent() as Node3D
	if _ship:
		_ship.add_to_group("ship_resources")

	# Register with WorkManager if available.
	await get_tree().process_frame
	var work_manager := _get_work_manager()
	if work_manager:
		work_manager.set_ship_resource(_ship if _ship else self)


func _exit_tree() -> void:
	var work_manager := _get_work_manager()
	if work_manager:
		work_manager.set_ship_resource(null)


func gather_material(material_id: String, amount: int, efficiency: float = 1.0) -> Dictionary:
	## Gather materials from the ship.
	## Returns {"material_id": String, "amount": int} of what was gathered.
	## efficiency multiplier affects how much is actually gathered.
	var available: int = material_pool.get(material_id, 0)
	if available <= 0:
		return {"material_id": material_id, "amount": 0}

	# Apply efficiency (e.g., Resourceful trait = 1.25)
	var effective_amount: int = int(ceil(amount * efficiency))
	var gathered: int = mini(effective_amount, available)

	material_pool[material_id] = available - gathered
	material_gathered.emit(material_id, gathered)

	# Check if depleted.
	if material_pool[material_id] <= 0:
		material_depleted.emit(material_id)

	return {"material_id": material_id, "amount": gathered}


func gather_any_material(efficiency: float = 1.0) -> Dictionary:
	## Gather the first available material.
	## Returns {"material_id": String, "amount": int} or empty dict.
	for mat_id: String in material_pool:
		if material_pool[mat_id] > 0:
			return gather_material(mat_id, base_gather_amount, efficiency)
	return {}


func get_available(material_id: String) -> int:
	## Get the amount of a specific material available.
	return material_pool.get(material_id, 0)


func get_all_available() -> Dictionary:
	## Get all available materials.
	return material_pool.duplicate()


func is_exhausted(material_id: String) -> bool:
	## Check if a specific material is exhausted.
	return material_pool.get(material_id, 0) <= 0


func is_all_exhausted() -> bool:
	## Check if all materials are exhausted.
	for mat_id: String in material_pool:
		if material_pool[mat_id] > 0:
			return false
	return true


func add_material(material_id: String, amount: int) -> void:
	## Add materials to the pool (e.g., for testing or events).
	var current: int = material_pool.get(material_id, 0)
	material_pool[material_id] = current + amount


func _get_work_manager() -> Node:
	## Find the WorkManager autoload.
	if has_node("/root/WorkManager"):
		return get_node("/root/WorkManager")
	return null


# =============================================================================
# SERIALIZATION (for save/load system)
# =============================================================================

func serialize() -> Dictionary:
	## Serialize ship resource state for saving.
	return {
		"material_pool": material_pool.duplicate()
	}


func deserialize(data: Dictionary) -> void:
	## Restore ship resource state from save data.
	if data.has("material_pool"):
		material_pool = data.get("material_pool", {}).duplicate()
