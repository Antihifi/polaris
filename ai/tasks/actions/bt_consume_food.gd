@tool
class_name BTConsumeFood extends BTAction
## Consumes food from inventory and restores hunger.
## Plays "taking_item" animation during consumption.

@export var hunger_restore: float = 30.0

var _animation_started: bool = false
var _food_consumed: bool = false


func _generate_name() -> String:
	return "ConsumeFood"


func _enter() -> void:
	_animation_started = false
	_food_consumed = false


func _tick(_delta: float) -> Status:
	var unit: Node = blackboard.get_var(&"unit")
	if not unit:
		return FAILURE

	# Check if unit has food
	if not unit.has_method("has_food_in_inventory"):
		return FAILURE
	if not unit.has_food_in_inventory():
		return FAILURE

	# Start animation if not started
	if not _animation_started:
		if unit.has_node("AnimationPlayer"):
			var anim_player: AnimationPlayer = unit.get_node("AnimationPlayer")
			if anim_player.has_animation("taking_item"):
				anim_player.play("taking_item")
		_animation_started = true
		return RUNNING

	# Check if animation is still playing
	if unit.has_node("AnimationPlayer"):
		var anim_player: AnimationPlayer = unit.get_node("AnimationPlayer")
		if anim_player.is_playing() and anim_player.current_animation == "taking_item":
			return RUNNING

	# Animation done (or no animation), consume the food
	if not _food_consumed:
		if not unit.has_method("get_food_from_inventory"):
			return FAILURE

		var food_item = unit.get_food_from_inventory()
		if not food_item:
			return FAILURE

		if not unit.has_method("eat_food_item"):
			return FAILURE

		unit.eat_food_item(food_item)
		_food_consumed = true
		return SUCCESS

	return SUCCESS if _food_consumed else FAILURE
