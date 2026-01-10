@tool
class_name BTIsNear extends BTCondition
## Checks if unit is near a specific resource type using Area3D-based detection.

@export_enum("fire", "shelter", "captain", "personable") var proximity_type: String = "fire"


func _generate_name() -> String:
	return "IsNear: %s" % proximity_type


func _tick(_delta: float) -> Status:
	var is_near: bool = false

	match proximity_type:
		"fire":
			is_near = blackboard.get_var(&"is_near_fire", false)
		"shelter":
			is_near = blackboard.get_var(&"is_in_shelter", false)
		"captain":
			is_near = blackboard.get_var(&"is_near_captain", false)
		"personable":
			# Check unit directly for personable aura
			var unit: ClickableUnit = blackboard.get_var(&"unit")
			if unit:
				is_near = unit.is_near_personable()

	return SUCCESS if is_near else FAILURE
