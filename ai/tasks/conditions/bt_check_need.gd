@tool
class_name BTCheckNeed extends BTCondition
## Checks if a survival need is below/above threshold.
## Used both as a condition gate and for utility scoring.

@export var need_name: StringName = &"hunger"
@export var threshold: float = 50.0
@export_enum("less_than", "greater_than") var comparison: String = "less_than"


func _generate_name() -> String:
	return "CheckNeed: %s %s %.0f" % [need_name, comparison, threshold]


func _tick(_delta: float) -> Status:
	var stats: SurvivorStats = blackboard.get_var(&"stats")
	if not stats:
		return FAILURE

	var value: float = stats.get(need_name)
	var result: bool = false

	match comparison:
		"less_than":
			result = value < threshold
		"greater_than":
			result = value > threshold

	return SUCCESS if result else FAILURE


func get_utility_score() -> float:
	## Returns urgency score 0.0-1.0 based on how critical the need is.
	## Lower stat value = higher urgency score.
	var stats: SurvivorStats = blackboard.get_var(&"stats")
	if not stats:
		return 0.0

	var value: float = stats.get(need_name)
	# Invert: lower stat = higher urgency
	# At 0 hunger → score 1.0, at 100 hunger → score 0.0
	return 1.0 - (value / 100.0)
