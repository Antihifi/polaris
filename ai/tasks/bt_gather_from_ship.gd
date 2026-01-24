@tool
extends BTAction
class_name BTGatherFromShip
## Gathers materials from ship's resource pool.
## ASSUMES agent is already at the ship (use BTMoveToBlackboard first).
## Returns SUCCESS after gathering, FAILURE if ship exhausted.

## Blackboard variable for work target (ship).
@export var work_target_var: StringName = &"work_target"
## Time to spend gathering (seconds).
@export var gather_time: float = 2.0

var _gather_timer: float = 0.0
var _started: bool = false


func _generate_name() -> String:
	return "GatherFromShip"


func _enter() -> void:
	_gather_timer = 0.0
	_started = false


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Get ship from target_node (set by BTFindNearestResource).
	var target_node: Node3D = blackboard.get_var(&"target_node", null)
	var ship: Node3D = _find_ship_from_node(target_node)
	if not ship:
		return FAILURE

	# Start gathering.
	if not _started:
		if agent.has_method("stop"):
			agent.stop()
		_started = true
		blackboard.set_var(&"current_action", "Gathering")

	# Wait for gather time.
	_gather_timer += delta
	if _gather_timer < gather_time:
		return RUNNING

	# Gather materials.
	var ship_resource: Node = _find_ship_resource(ship)
	if not ship_resource:
		return FAILURE

	var efficiency: float = _get_gather_efficiency(agent)
	var gathered: Dictionary = {}

	if ship_resource.has_method("gather_material"):
		gathered = ship_resource.gather_material("scrap_wood", 1, efficiency)

	if gathered.is_empty() or gathered.get("amount", 0) <= 0:
		blackboard.set_var(&"current_action", "Ship exhausted")
		return FAILURE

	# Start carrying.
	var mat_id: String = gathered.get("material_id", "")
	var amount: int = gathered.get("amount", 0)
	if agent.has_method("start_carrying"):
		agent.start_carrying(mat_id, amount)

	blackboard.set_var(&"current_action", "Carrying " + mat_id)
	return SUCCESS


func _find_ship_from_node(node: Node3D) -> Node3D:
	## Find ship Node3D from Area3D node (traverse up to find ship_resources group).
	if not node:
		return null
	var current: Node = node
	while current:
		if current.is_in_group("ship_resources"):
			if current is Node3D:
				return current as Node3D
			var parent: Node = current.get_parent()
			if parent is Node3D:
				return parent as Node3D
		current = current.get_parent()
	return null


func _find_ship_resource(ship: Node) -> Node:
	## Find ShipResourceComponent on ship.
	for child in ship.get_children():
		if child is ShipResourceComponent:
			return child
	return null


func _get_gather_efficiency(agent: Node) -> float:
	## Get gathering efficiency from traits.
	var efficiency: float = 1.0
	if "stats" in agent and agent.stats:
		if agent.stats.has_method("has_trait"):
			if agent.stats.has_trait("resourceful"):
				efficiency *= 1.25
	return efficiency
