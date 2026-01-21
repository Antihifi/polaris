## Sled Controller
## Manages puller attachment, cargo tracking, and rope visuals.
## Physics-based pulling is handled by HarnessPullSystem child node.
extends RigidBody3D
class_name SledController

signal puller_attached(unit: Node3D)
signal puller_detached(unit: Node3D)
signal cargo_changed(total_weight: float)

## Formation positions for pullers (relative to harness, local space)
const FORMATION_OFFSETS: Array[Vector3] = [
	Vector3.ZERO,            # Index 0 = Leader
	Vector3(-1.0, 0, -1.0),  # Index 1 = Back-left
	Vector3(1.0, 0, -1.0),   # Index 2 = Back-right
	Vector3(-1.0, 0, -2.0),  # Index 3 = Further back-left
]

## Base mass of empty sled in kg
@export var base_mass: float = 150.0
## Maximum cargo weight the sled can carry in kg
@export var max_cargo_weight: float = 500.0
## Maximum number of units that can pull this sled
@export var max_pullers: int = 4

## Rope Visual Settings
@export_group("Rope Visuals")
@export var rope_visual_scene: PackedScene = null
@export var show_rope_visuals: bool = true

## Reference to front marker for rope attachment
@onready var sled_front: Marker3D = $SledFront if has_node("SledFront") else null
## Reference to the cargo detection area
@onready var cargo_area: Area3D = $CargoArea if has_node("CargoArea") else null

## Array of units currently attached as pullers
var pullers: Array[Node3D] = []
## The designated lead puller who determines navigation
var lead_puller: Node3D = null
## Current cargo items detected in the cargo area
var cargo_items: Array[Node3D] = []
## Cached total cargo weight
var _cached_cargo_weight: float = 0.0
## Dictionary mapping puller -> RopeVisual instance
var _rope_visuals: Dictionary = {}
## Reference to harness pull system (child node)
var harness_system: HarnessPullSystem = null


func _ready() -> void:
	mass = base_mass

	if cargo_area:
		cargo_area.body_entered.connect(_on_cargo_entered)
		cargo_area.body_exited.connect(_on_cargo_exited)

	add_to_group("sleds")

	# Get harness system reference (child node)
	harness_system = get_node_or_null("HarnessPullSystem") as HarnessPullSystem
	if harness_system:
		print("[SledController] Harness pull system found")
	else:
		push_warning("[SledController] No HarnessPullSystem child - sled won't move")

	# Disable collision on cargo StaticBody3D nodes to prevent physics conflicts
	_disable_cargo_collision(self)




## Attach a unit as a puller. Returns true if successful.
func attach_puller(unit: Node3D) -> bool:
	if pullers.size() >= max_pullers:
		push_warning("[SledController] Max pullers reached")
		return false

	if unit in pullers:
		push_warning("[SledController] Unit already attached")
		return false

	pullers.append(unit)

	# First puller becomes the lead
	if lead_puller == null:
		lead_puller = unit

	# Assign formation offset for support pullers
	var puller_index: int = pullers.size() - 1
	if puller_index > 0 and puller_index < FORMATION_OFFSETS.size():
		if "sled_formation_offset" in unit:
			unit.sled_formation_offset = FORMATION_OFFSETS[puller_index]

	_create_rope_visual(unit)
	puller_attached.emit(unit)
	print("[SledController] Attached puller %d: %s" % [puller_index, unit.name])
	return true


## Detach a unit from pulling duty.
func detach_puller(unit: Node3D) -> void:
	var idx: int = pullers.find(unit)
	if idx == -1:
		return

	if "sled_formation_offset" in unit:
		unit.sled_formation_offset = Vector3.ZERO

	_destroy_rope_visual(unit)
	pullers.remove_at(idx)

	# Reassign lead if needed
	if unit == lead_puller:
		lead_puller = pullers[0] if not pullers.is_empty() else null

	_reassign_formation_offsets()
	puller_detached.emit(unit)


## Detach all pullers.
func detach_all_pullers() -> void:
	var pullers_copy: Array[Node3D] = pullers.duplicate()
	for puller in pullers_copy:
		detach_puller(puller)


## Get the current total weight of cargo.
func get_cargo_weight() -> float:
	return _cached_cargo_weight


## Get the total weight including base sled mass.
func get_total_weight() -> float:
	return base_mass + _cached_cargo_weight


func _on_cargo_entered(body: Node3D) -> void:
	if body == self:
		return
	if body.is_in_group("containers") or body.is_in_group("survivors"):
		cargo_items.append(body)
		_recalculate_cargo_weight()


func _on_cargo_exited(body: Node3D) -> void:
	var idx: int = cargo_items.find(body)
	if idx != -1:
		cargo_items.remove_at(idx)
		_recalculate_cargo_weight()


func _recalculate_cargo_weight() -> void:
	var old_weight: float = _cached_cargo_weight
	_cached_cargo_weight = 0.0

	for item in cargo_items:
		_cached_cargo_weight += _get_item_weight(item)

	mass = base_mass + _cached_cargo_weight

	if not is_equal_approx(old_weight, _cached_cargo_weight):
		cargo_changed.emit(_cached_cargo_weight)


func _get_item_weight(item: Node3D) -> float:
	if "weight" in item:
		return item.weight
	if item.is_in_group("survivors"):
		return 80.0
	elif item.is_in_group("containers"):
		return 30.0
	return 20.0


func _create_rope_visual(unit: Node3D) -> void:
	if not show_rope_visuals or rope_visual_scene == null or not sled_front:
		return

	var rope: Node3D = rope_visual_scene.instantiate()
	if rope == null:
		return

	get_parent().add_child(rope)
	if rope.has_method("setup"):
		rope.setup(sled_front, unit, 6.0)  # Rope length for visuals
	_rope_visuals[unit] = rope


func _destroy_rope_visual(unit: Node3D) -> void:
	if unit not in _rope_visuals:
		return
	var rope: Node3D = _rope_visuals[unit]
	if is_instance_valid(rope):
		rope.queue_free()
	_rope_visuals.erase(unit)


func _reassign_formation_offsets() -> void:
	for i in range(pullers.size()):
		if i == 0:
			continue  # Leader doesn't need offset
		if i < FORMATION_OFFSETS.size() and "sled_formation_offset" in pullers[i]:
			pullers[i].sled_formation_offset = FORMATION_OFFSETS[i]


## Get harness position for external queries (e.g., puller positioning)
func get_harness_position() -> Vector3:
	if harness_system:
		return harness_system.get_harness_position()
	if sled_front:
		return sled_front.global_position
	return global_position


## Recursively disable collision on StaticBody3D children (cargo items).
## Prevents physics conflicts when cargo is parented to RigidBody3D sled.
func _disable_cargo_collision(node: Node) -> void:
	for child in node.get_children():
		if child is StaticBody3D:
			child.collision_layer = 0
			child.collision_mask = 0
		_disable_cargo_collision(child)
