@tool
extends BTAction
class_name BTEatFromInventory
## Eat food from personal inventory. Only triggers when unit is idle.
## Plays eating animation and consumes best food item.
## Returns RUNNING during animation, SUCCESS when done, FAILURE if no food or busy.

@export var eat_duration: float = 3.0  ## Duration of eating animation

var _eating: bool = false
var _eat_timer: float = 0.0
var _food_item: InventoryItem = null


func _generate_name() -> String:
	return "EatFromInventory (%.1fs)" % eat_duration


func _enter() -> void:
	_eating = false
	_eat_timer = 0.0
	_food_item = null


func _tick(delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Guard: Don't eat if moving or already animating
	if "is_moving" in agent and agent.is_moving:
		return FAILURE
	if "is_animation_locked" in agent and agent.is_animation_locked:
		return FAILURE

	if not _eating:
		# Start eating - find food first
		if not agent.has_method("get_food_from_inventory"):
			return FAILURE

		_food_item = agent.get_food_from_inventory()
		if not _food_item:
			return FAILURE

		_eating = true
		_eat_timer = 0.0
		blackboard.set_var(&"current_action", "Eating")

		# Play eating animation (fallback to taking_item if eating not available)
		if "animation_player" in agent and agent.animation_player:
			if agent.animation_player.has_animation("eating"):
				agent._play_animation("eating")
			elif agent.animation_player.has_animation("taking_item"):
				agent._play_animation("taking_item")

		var unit_name: String = agent.unit_name if "unit_name" in agent else "unit"
		print("[BTEatFromInventory] %s started eating" % unit_name)
		return RUNNING

	# Continue eating animation
	_eat_timer += delta

	if _eat_timer >= eat_duration:
		# Consume the food
		if _food_item and agent.has_method("eat_food_item"):
			agent.eat_food_item(_food_item)

		# Return to idle animation
		if agent.has_method("_play_animation"):
			agent._play_animation("idle")

		blackboard.set_var(&"current_action", "Idle")

		var unit_name: String = agent.unit_name if "unit_name" in agent else "unit"
		print("[BTEatFromInventory] %s finished eating" % unit_name)

		_eating = false
		_food_item = null
		return SUCCESS

	return RUNNING


func _exit() -> void:
	_eating = false
	_eat_timer = 0.0
	_food_item = null
