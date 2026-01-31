class_name DemoResourceAnchor
extends Node
## Keeps ship resource Area3D nodes at ground level as the ship sinks.
## Without this, resources would descend underground with the ship.
## Monitors ship_root Y position and applies inverse translation to ResourceNodes.

## The ship root node (ErebusFragmentedV1 or Ship1 parent)
var ship_root: Node3D = null

## The ResourceNodes parent that contains all gathering Area3Ds
var resource_nodes: Node3D = null

## Recorded initial Y position of the ship
var _initial_ship_y: float = 0.0

## Whether initialization is complete
var _initialized: bool = false

## Roll/pitch threshold (radians) to trigger reparenting
const TILT_THRESHOLD: float = 0.3  # ~17 degrees

## Whether resources have been reparented to scene root
var _reparented: bool = false


func _ready() -> void:
	call_deferred("_initialize")


func _initialize() -> void:
	if not ship_root:
		push_warning("[DemoResourceAnchor] No ship_root assigned")
		return

	if not resource_nodes:
		resource_nodes = ship_root.get_node_or_null("ResourceNodes")
		if not resource_nodes:
			# Try parent
			var parent: Node = ship_root.get_parent()
			if parent:
				resource_nodes = parent.get_node_or_null("ResourceNodes")

	if not resource_nodes:
		push_warning("[DemoResourceAnchor] No ResourceNodes found")
		return

	_initial_ship_y = ship_root.global_position.y
	_initialized = true


func _process(_delta: float) -> void:
	if not _initialized:
		return
	if not is_instance_valid(ship_root) or not is_instance_valid(resource_nodes):
		return

	if _reparented:
		return  # Already reparented, no more adjustments needed

	# Check if ship has tilted significantly (roll or pitch)
	var roll: float = absf(ship_root.rotation.z)
	var pitch: float = absf(ship_root.rotation.x)

	if roll > TILT_THRESHOLD or pitch > TILT_THRESHOLD:
		_reparent_to_scene_root()
		return

	# Counter-translate resource nodes to compensate for ship sinking
	var current_ship_y: float = ship_root.global_position.y
	var sink_delta: float = _initial_ship_y - current_ship_y

	if sink_delta > 0.05:
		resource_nodes.position.y = sink_delta


func _reparent_to_scene_root() -> void:
	## Reparent ResourceNodes to the scene root to decouple from ship transform.
	## Preserves global position so resources don't jump.
	if _reparented or not is_instance_valid(resource_nodes):
		return

	var global_xform: Transform3D = resource_nodes.global_transform
	var scene_root: Node = get_tree().current_scene
	if not scene_root:
		return

	resource_nodes.get_parent().remove_child(resource_nodes)
	scene_root.add_child(resource_nodes)
	resource_nodes.global_transform = global_xform
	_reparented = true
	print("[DemoResourceAnchor] ResourceNodes reparented to scene root (ship tilted)")
