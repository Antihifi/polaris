@tool
class_name BTUtilitySelector extends BTComposite
## Selects the child with the highest utility score.
## Children should be wrapped with BTUtilityWrapper or implement get_utility_score().

@export var score_var_prefix: StringName = &"utility_"


func _generate_name() -> String:
	return "UtilitySelector"


func _tick(_delta: float) -> Status:
	var best_child: BTTask = null
	var best_score: float = -1.0

	# Evaluate all children and find highest utility
	# BTComposite uses get_child_count() and get_child(index)
	for i in get_child_count():
		var child: BTTask = get_child(i)
		var score: float = _get_child_score(child)
		if score > best_score:
			best_score = score
			best_child = child

	if not best_child:
		return FAILURE

	# Execute the best child
	var result: Status = best_child.execute(_delta)

	# If child completes (success or failure), we're done for this tick
	# Next tick will re-evaluate scores
	return result


func _get_child_score(child: BTTask) -> float:
	## Get utility score from child task.
	## Checks for BTUtilityWrapper or get_utility_score method.

	# Check if child has utility wrapper functionality
	if child.has_method("get_utility_score"):
		return child.get_utility_score()

	# Check blackboard for score variable
	var child_name: String = child.get_task_name()
	var score_var: StringName = StringName(str(score_var_prefix) + child_name.to_snake_case())
	var bb_score = blackboard.get_var(score_var, -1.0)
	if bb_score >= 0.0:
		return bb_score

	# Default: no score means low priority
	return 0.0
