@tool
extends BTAction
class_name BTWorkAtSite
## Performs construction work at a site.
## ASSUMES agent is already at the site (use BTMoveToBlackboard first).
## Returns RUNNING while working, SUCCESS when site is complete.

## Blackboard variable for construction site (set by BTFindNearestResource).
@export var target_node_var: StringName = &"target_node"
## Work interval in seconds (how often to add work).
@export var work_interval: float = 1.0

var _working: bool = false
var _work_timer: float = 0.0
var _registered: bool = false


func _generate_name() -> String:
	return "WorkAtSite"


func _enter() -> void:
	_working = false
	_work_timer = 0.0
	_registered = false


func _exit() -> void:
	# Unregister from site when leaving.
	var site: Node = blackboard.get_var(target_node_var, null)
	if site and _registered:
		if site.has_method("unregister_worker"):
			var agent: Node3D = get_agent()
			if agent:
				site.unregister_worker(agent)
		_registered = false


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var site: Node = blackboard.get_var(target_node_var, null)
	if not site or not is_instance_valid(site):
		return FAILURE

	# Check if site has all materials.
	if site.has_method("has_all_required_materials"):
		if not site.has_all_required_materials():
			blackboard.set_var(&"current_action", "Waiting for materials")
			return FAILURE

	# Check if site is complete.
	if site.has_method("get_progress_percent"):
		if site.get_progress_percent() >= 100.0:
			return SUCCESS

	# Start working.
	if not _working:
		if agent.has_method("stop"):
			agent.stop()
		_working = true
		_work_timer = 0.0

		# Register with site.
		if site.has_method("register_worker") and not _registered:
			if site.register_worker(agent):
				_registered = true
			else:
				return FAILURE  # Site is full

		blackboard.set_var(&"current_action", "Building")

	# Perform work at interval.
	_work_timer += delta
	if _work_timer >= work_interval:
		_work_timer = 0.0

		var efficiency: float = _get_work_efficiency(agent)
		var hours_per_interval: float = 0.1

		if site.has_method("add_work"):
			site.add_work(hours_per_interval, efficiency)

		if site.has_method("get_progress_percent"):
			if site.get_progress_percent() >= 100.0:
				blackboard.set_var(&"current_action", "Finished building")
				return SUCCESS

	return RUNNING


func _get_work_efficiency(agent: Node) -> float:
	## Get construction efficiency from stats and traits.
	var efficiency: float = 1.0
	if "stats" in agent and agent.stats:
		if agent.stats.has_method("get_work_efficiency"):
			efficiency *= agent.stats.get_work_efficiency()
		if agent.stats.has_method("has_trait"):
			if agent.stats.has_trait("carpenter"):
				efficiency *= 1.25
			elif agent.stats.has_trait("builder"):
				efficiency *= 1.15
	return efficiency
