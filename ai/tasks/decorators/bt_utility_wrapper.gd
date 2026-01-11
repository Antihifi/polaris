@tool
class_name BTUtilityWrapper extends BTDecorator
## Wraps a subtree and provides a utility score for BTUtilitySelector.
## Score is calculated based on inverse of a need value (lower need = higher urgency).

@export var need_name: StringName = &"hunger"
@export var base_score: float = 1.0
@export var score_multiplier: float = 1.0
## Extra score added when extreme weather is active (temp < -20°C)
## Set to 1.0 for shelter to prioritize it in blizzards
@export var extreme_weather_boost: float = 0.0

var _cached_score: float = 0.0
var _cached_time_manager: Node = null


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
	var score: float = (base_score + urgency) * score_multiplier

	# Add extreme weather boost if enabled and conditions met
	if extreme_weather_boost > 0.0 and _is_extreme_weather():
		score += extreme_weather_boost

	_cached_score = score


func _is_extreme_weather() -> bool:
	## Returns true if temperature < -20°C (extreme cold requiring shelter)
	if not _cached_time_manager:
		_cached_time_manager = Engine.get_singleton("TimeManager") if Engine.has_singleton("TimeManager") else null
		if not _cached_time_manager:
			_cached_time_manager = agent.get_tree().root.get_node_or_null("TimeManager")

	if not _cached_time_manager:
		return false

	var temp: float = _cached_time_manager.current_temperature if "current_temperature" in _cached_time_manager else 0.0
	return temp < -20.0
	# TODO: Add blizzard check when weather system is implemented


func get_utility_score() -> float:
	## Called by BTUtilitySelector to get this branch's score.
	_update_score()
	return _cached_score
