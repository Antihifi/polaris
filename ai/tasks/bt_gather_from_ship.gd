@tool
extends BTAction
class_name BTGatherFromShip
## Moves to ship and gathers materials from ship's resource pool.
## Returns RUNNING while moving/gathering, SUCCESS when done.

## Blackboard variable for target position.
@export var target_position_var: StringName = &"target_position"
## Blackboard variable for work target (ship).
@export var work_target_var: StringName = &"work_target"
## Blackboard variable for carried materials.
@export var carried_materials_var: StringName = &"carried_materials"
## Distance to consider "arrived" at ship.
@export var arrival_distance: float = 5.0
## Time to spend gathering (seconds).
@export var gather_time: float = 3.0

var _gathering: bool = false
var _gather_timer: float = 0.0
var _moving: bool = false


func _generate_name() -> String:
	return "GatherFromShip"


func _enter() -> void:
	_gathering = false
	_gather_timer = 0.0
	_moving = false


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var ship: Node3D = blackboard.get_var(work_target_var, null) as Node3D
	if not ship:
		return FAILURE

	var agent_pos: Vector3 = agent.global_position
	var ship_pos: Vector3 = ship.global_position
	var dist: float = agent_pos.distance_to(ship_pos)

	# Phase 1: Move to ship
	if dist > arrival_distance:
		if not _moving:
			agent.move_to(ship_pos)
			_moving = true
			blackboard.set_var(&"current_action", "Walking to ship")
		return RUNNING

	# Phase 2: Stop and gather
	if not _gathering:
		agent.stop()
		_gathering = true
		_gather_timer = 0.0
		blackboard.set_var(&"current_action", "Gathering materials")

	# Wait for gather time
	_gather_timer += delta
	if _gather_timer < gather_time:
		return RUNNING

	# Phase 3: Actually gather materials
	var ship_resource: Node = _find_ship_resource(ship)
	if not ship_resource:
		return FAILURE

	# Calculate efficiency (Resourceful trait = 1.25)
	var efficiency: float = _get_gather_efficiency(agent)

	# Gather materials
	var gathered: Dictionary = {}
	if ship_resource.has_method("gather_any_material"):
		gathered = ship_resource.gather_any_material(efficiency)
	elif ship_resource.has_method("gather_material"):
		gathered = ship_resource.gather_material("scrap_wood", 5, efficiency)

	if gathered.is_empty() or gathered.get("amount", 0) <= 0:
		# Ship exhausted
		blackboard.set_var(&"current_action", "Ship exhausted")
		return FAILURE

	# Store gathered materials in blackboard
	var carried: Dictionary = blackboard.get_var(carried_materials_var, {})
	var mat_id: String = gathered.get("material_id", "")
	var amount: int = gathered.get("amount", 0)
	carried[mat_id] = carried.get(mat_id, 0) + amount
	blackboard.set_var(carried_materials_var, carried)

	print("[BTGatherFromShip] Gathered %d %s" % [amount, mat_id])

	return SUCCESS


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
		# Check for Resourceful trait
		if agent.stats.has_method("has_trait"):
			if agent.stats.has_trait("resourceful"):
				efficiency *= 1.25

	return efficiency
