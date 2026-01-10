@tool
class_name BTSeekResource extends BTAction
## Finds nearest resource of specified type and stores position in blackboard.

@export_enum("food_source", "heat_source", "shelter", "water_source") var resource_type: String = "food_source"
@export var target_var: StringName = &"move_target"
@export var node_var: StringName = &"target_node"
@export var max_search_distance: float = 100.0

## Group names for each resource type
const RESOURCE_GROUPS: Dictionary = {
	"food_source": "containers",
	"heat_source": "heat_sources",
	"shelter": "shelters",
	"water_source": "water_sources",
}


func _generate_name() -> String:
	return "SeekResource: %s" % resource_type


func _tick(_delta: float) -> Status:
	var unit_pos: Vector3 = blackboard.get_var(&"unit_position", Vector3.ZERO)
	var group_name: String = RESOURCE_GROUPS.get(resource_type, "")

	if group_name.is_empty():
		return FAILURE

	var targets: Array[Node] = agent.get_tree().get_nodes_in_group(group_name)

	var nearest: Node3D = null
	var nearest_dist: float = max_search_distance

	for target in targets:
		if not target is Node3D:
			continue
		if not _is_valid_resource(target):
			continue

		var dist: float = unit_pos.distance_to(target.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = target

	if nearest:
		blackboard.set_var(target_var, nearest.global_position)
		blackboard.set_var(node_var, nearest)
		return SUCCESS

	# Clear target variables on failure to prevent stale data
	blackboard.set_var(target_var, null)
	blackboard.set_var(node_var, null)
	return FAILURE


func _is_valid_resource(node: Node3D) -> bool:
	## Check if resource is currently usable.
	match resource_type:
		"food_source":
			# Check if container has food
			var storage: Node = node.get_node_or_null("StorageContainer")
			if storage and "inventory" in storage:
				var inv: Inventory = storage.inventory
				if inv:
					for item in inv.get_items():
						if item.get_property("category", "misc") == "food":
							return true
			return false

		"heat_source":
			# Heat sources are always valid if in group (campfire lit, etc.)
			# Could check node.is_lit() if campfire has that method
			if node.has_method("is_lit"):
				return node.is_lit()
			return true

		"shelter":
			# Shelters are always valid if in group
			return true

		"water_source":
			# Water sources are always valid if in group
			return true

	return true
