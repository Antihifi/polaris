@tool
class_name BTCheckThreat extends BTCondition
## Checks if there's a dangerous entity within detection range.
## Stores threat position in blackboard for flee behavior.

@export var detection_radius: float = 15.0
@export var threat_position_var: StringName = &"threat_position"

## Groups considered threats
const THREAT_GROUPS: Array[String] = [
	"predators",      # Polar bears, wolves
	"hostile_npcs",   # Aggressive natives, mutineers
	"hazards",        # Environmental dangers
]


func _generate_name() -> String:
	return "CheckThreat (%.0fm)" % detection_radius


func _tick(_delta: float) -> Status:
	var unit: ClickableUnit = blackboard.get_var(&"unit")
	if not unit:
		return FAILURE

	var unit_pos: Vector3 = blackboard.get_var(&"unit_position", Vector3.ZERO)
	var nearest_threat: Node3D = null
	var nearest_dist: float = detection_radius

	# Check all threat groups
	for group_name in THREAT_GROUPS:
		var threats: Array[Node] = unit.get_tree().get_nodes_in_group(group_name)
		for threat in threats:
			if not threat is Node3D:
				continue
			if threat == unit:
				continue  # Don't flee from self

			var dist: float = unit_pos.distance_to(threat.global_position)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_threat = threat

	if nearest_threat:
		blackboard.set_var(threat_position_var, nearest_threat.global_position)
		return SUCCESS

	return FAILURE
