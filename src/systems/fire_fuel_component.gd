class_name FireFuelComponent extends Node
## Manages fuel consumption for fires (campfires, fire pits, etc.).
## Attach as child of a fire node. Creates StorageContainer for fuel inventory.
## Consumes fuel over time based on protoset burn_duration (in hours).

signal fuel_changed(remaining_percent: float)
signal fuel_depleted
signal fire_state_changed(is_lit: bool)

@export var fuel_grid_size: Vector2i = Vector2i(4, 2)  # 8 slots for fuel
@export var start_lit: bool = true  # Whether fire starts lit (if fuel available)
@export var initial_fuel_id: String = "firewood"  # Fuel item to start with (empty = none)

var storage: StorageContainer
var current_fuel_item: InventoryItem = null
var current_fuel_remaining: float = 0.0  # 0.0-1.0 percentage of current unit
var current_burn_hours: float = 0.0  # Total hours this item will burn (randomized)
var is_lit: bool = false

# Fire visual references (found in parent)
var fire_mesh: MeshInstance3D
var fire_light: OmniLight3D
var fire_particles: GPUParticles3D
var warmth_area: Area3D
var _progress_bar: ProgressBar3D = null
var _peak_fuel_hours: float = 0.0  # High water mark for progress bar scaling


func _ready() -> void:
	_setup_fuel_storage()
	call_deferred("_find_fire_visuals")
	call_deferred("_setup_progress_bar")
	call_deferred("_add_initial_fuel")
	TimeManager.hour_passed.connect(_on_hour_passed)


func _setup_fuel_storage() -> void:
	## Create StorageContainer for fuel inventory.
	## Added to campfire root (parent) so StorageContainer's click area works —
	## StorageContainer._setup_click_area() needs a Node3D parent.
	storage = StorageContainer.new()
	storage.name = "StorageContainer"
	storage.display_name = "Campfire Fuel"
	storage.storage_type = StorageContainer.StorageType.FUEL
	storage.grid_width = fuel_grid_size.x
	storage.grid_height = fuel_grid_size.y
	get_parent().call_deferred("add_child", storage)

	# Connect to inventory changes to auto-light when fuel added
	storage.contents_changed.connect(_on_fuel_contents_changed)

	print("[FireFuel] Fuel storage created (%dx%d grid)" % [fuel_grid_size.x, fuel_grid_size.y])


func _find_fire_visuals() -> void:
	## Find fire visual nodes in parent (mesh, light, particles, warmth).
	var parent: Node = get_parent()
	if not parent:
		return

	# Find Fire mesh (usually named "Fire" or contains fire mesh)
	fire_mesh = parent.find_child("Fire", true, false) as MeshInstance3D

	# Find light (child of Fire mesh or direct child)
	if fire_mesh:
		fire_light = fire_mesh.find_child("OmniLight3D", true, false) as OmniLight3D
		fire_particles = fire_mesh.find_child("GPUParticles3D", true, false) as GPUParticles3D
	if not fire_light:
		fire_light = parent.find_child("OmniLight3D", true, false) as OmniLight3D
	if not fire_particles:
		fire_particles = parent.find_child("GPUParticles3D", true, false) as GPUParticles3D

	# Find WarmthArea
	warmth_area = parent.find_child("WarmthArea", true, false) as Area3D

	print("[FireFuel] Found visuals - mesh: %s, light: %s, particles: %s, warmth: %s" % [
		fire_mesh != null, fire_light != null, fire_particles != null, warmth_area != null
	])


func _setup_progress_bar() -> void:
	## Create a 3D progress bar above the campfire for fuel status.
	_progress_bar = ProgressBar3D.new()
	_progress_bar.position = Vector3(0, 1.5, 0)
	get_parent().add_child(_progress_bar)
	_update_progress_bar()


func _add_initial_fuel() -> void:
	## Add starting fuel so spawned campfires don't burn with empty inventory.
	if initial_fuel_id.is_empty():
		return
	if not storage or not storage.inventory:
		return
	# Only add if inventory is empty (don't double-add on deserialization).
	if not storage.get_items_of_category("fuel").is_empty():
		return
	var item: InventoryItem = storage.add_item_by_id(initial_fuel_id)
	if item:
		print("[FireFuel] Added initial fuel: %s" % initial_fuel_id)


func _get_item_id(item: InventoryItem) -> String:
	## Get the prototype ID string from an InventoryItem (gloot API).
	if item and item.get_prototype():
		return item.get_prototype().get_prototype_id()
	return "unknown"


func _update_progress_bar() -> void:
	## Update the progress bar based on hours remaining vs peak hours.
	## Peak resets upward when fuel is added, so bar starts full and ticks down.
	if not _progress_bar:
		return
	if not is_lit:
		_progress_bar.visible = false
		return
	_progress_bar.visible = true
	var hours: float = get_hours_remaining()
	# Update peak if we have more fuel than ever (fuel was just added)
	if hours > _peak_fuel_hours:
		_peak_fuel_hours = hours
	var progress: float = clampf(hours / _peak_fuel_hours, 0.0, 1.0) if _peak_fuel_hours > 0.0 else 0.0
	if _progress_bar.has_method("set_progress"):
		_progress_bar.set_progress(progress)


func _on_hour_passed(_hour: int, _day: int) -> void:
	## Called every in-game hour. Consume fuel if fire is lit.
	if not is_lit:
		return

	if current_fuel_item == null:
		# No current fuel, try to get next
		_try_consume_next_fuel()
		if current_fuel_item == null:
			# Still no fuel, fire goes out
			_set_fire_active(false)
			fuel_depleted.emit()
		return

	# Consume 1 hour worth of the current fuel
	if current_burn_hours > 0.0:
		var consumption: float = 1.0 / current_burn_hours
		current_fuel_remaining -= consumption
		fuel_changed.emit(current_fuel_remaining)
		_update_progress_bar()

		if current_fuel_remaining <= 0.0:
			_finish_current_fuel()


func _try_light_fire() -> void:
	## Attempt to light the fire if fuel is available.
	if is_lit:
		return

	if _try_consume_next_fuel():
		_set_fire_active(true)
		print("[FireFuel] Fire lit with %s" % _get_item_id(current_fuel_item))


func _try_consume_next_fuel() -> bool:
	## Try to start burning the next fuel item from inventory.
	## Returns true if fuel was found and started burning.
	if not storage or not storage.inventory:
		return false

	var fuel_items := storage.get_items_of_category("fuel")
	if fuel_items.is_empty():
		return false

	# Take first fuel item
	var item: InventoryItem = fuel_items[0]
	_start_burning_item(item)
	return true


func _start_burning_item(item: InventoryItem) -> void:
	## Start burning a fuel item.
	current_fuel_item = item

	# Get base burn duration from protoset (in hours)
	var base_hours: float = item.get_property("burn_duration", 24.0)

	# Add +/- 20% random variation
	# "Not every unit of fat/firewood/oil/coal etc. should be exactly the same"
	current_burn_hours = base_hours * randf_range(0.8, 1.2)
	current_fuel_remaining = 1.0

	print("[FireFuel] Started burning %s (%.1f hours, base %.1f)" % [
		_get_item_id(item), current_burn_hours, base_hours
	])


func _finish_current_fuel() -> void:
	## Called when current fuel item is fully consumed.
	if current_fuel_item and storage and storage.inventory:
		var item_name: String = _get_item_id(current_fuel_item)
		storage.inventory.remove_item(current_fuel_item)
		print("[FireFuel] Consumed %s" % item_name)

	current_fuel_item = null
	current_fuel_remaining = 0.0
	current_burn_hours = 0.0

	# Try to burn next item
	if not _try_consume_next_fuel():
		# No more fuel
		_set_fire_active(false)
		fuel_depleted.emit()


func _set_fire_active(active: bool) -> void:
	## Enable/disable fire visuals and warmth.
	is_lit = active
	fire_state_changed.emit(is_lit)

	# Control visuals
	if fire_mesh:
		fire_mesh.visible = active
	if fire_light:
		fire_light.visible = active
	if fire_particles:
		fire_particles.emitting = active

	# Control warmth area
	if warmth_area:
		warmth_area.monitoring = active
		var parent: Node = get_parent()
		if parent:
			if active:
				parent.add_to_group("heat_sources")
			else:
				parent.remove_from_group("heat_sources")

	_update_progress_bar()
	print("[FireFuel] Fire %s" % ("lit" if active else "extinguished"))


func _on_fuel_contents_changed() -> void:
	## Called when fuel inventory changes. Auto-light if fuel added while extinguished.
	if not is_lit and start_lit:
		_try_light_fire()
	_update_progress_bar()


# --- Public API ---

func add_fuel(item_id: String) -> bool:
	## Add fuel to the fire by item prototype ID.
	if not storage:
		return false
	var item: InventoryItem = storage.add_item_by_id(item_id)
	return item != null


func get_fuel_count() -> int:
	## Get total fuel items in inventory.
	if not storage:
		return 0
	return storage.get_items_of_category("fuel").size()


func get_fuel_remaining_percent() -> float:
	## Get total fuel remaining as percentage of peak (0.0-1.0).
	if _peak_fuel_hours <= 0.0:
		return 0.0
	return clampf(get_hours_remaining() / _peak_fuel_hours, 0.0, 1.0)


func get_hours_remaining() -> float:
	## Get estimated hours of fuel remaining (current item + inventory).
	var hours: float = current_fuel_remaining * current_burn_hours

	if storage and storage.inventory:
		for item in storage.get_items_of_category("fuel"):
			if item != current_fuel_item:
				hours += item.get_property("burn_duration", 24.0)

	return hours


func is_burning() -> bool:
	## Returns true if fire is currently lit and burning fuel.
	return is_lit and current_fuel_item != null


func extinguish() -> void:
	## Manually extinguish the fire (wastes remaining fuel in current item).
	if is_lit:
		_set_fire_active(false)
		# Clear current fuel (it's wasted)
		if current_fuel_item and storage and storage.inventory:
			storage.inventory.remove_item(current_fuel_item)
		current_fuel_item = null
		current_fuel_remaining = 0.0


func light() -> bool:
	## Manually light the fire. Returns true if successful.
	if is_lit:
		return true
	_try_light_fire()
	return is_lit
