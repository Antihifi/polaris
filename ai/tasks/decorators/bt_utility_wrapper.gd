@tool
class_name BTUtilityWrapper extends BTDecorator
## Wraps a subtree and provides a utility score for BTUtilitySelector.
## Score is calculated based on inverse of a need value (lower need = higher urgency).

@export var need_name: StringName = &"hunger"
@export var base_score: float = 1.0
@export var score_multiplier: float = 1.0

var _cached_score: float = 0.0


func _generate_name() -> String:
	return "Utility[%s]" % need_name


func _tick(delta: float) -> Status:
	# Update cached score before executing child
	_update_score()

	# Execute wrapped child
	if get_child_count() > 0:
		return get_child(0).execute(delta)

	return FAILURE


func _update_score() -> void:
	## Calculate utility score based on need urgency.
	## Lower need value = higher urgency = higher score.
	var stats: Resource = blackboard.get_var(&"stats")
	if not stats:
		_cached_score = 0.0
		return

	var need_value: float = 100.0
	if need_name in stats:
		need_value = stats.get(need_name)

	# Inverse: need at 0 = max urgency (score 1.0), need at 100 = min urgency (score 0.0)
	var urgency: float = 1.0 - (need_value / 100.0)

	# Apply multiplier and base score
	_cached_score = (base_score + urgency) * score_multiplier


func get_utility_score() -> float:
	## Called by BTUtilitySelector to get this branch's score.
	_update_score()
	return _cached_score
