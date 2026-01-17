@tool
extends BTAction
class_name BTSetAnimationLock
## Sets or clears the animation lock on the agent.
## When locked, the agent's physics processing is disabled to prevent drift.

@export var lock: bool = true

func _generate_name() -> String:
	return "AnimationLock [%s]" % ("ON" if lock else "OFF")


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent or not "is_animation_locked" in agent:
		return FAILURE

	# Only update if the value actually changes
	if agent.is_animation_locked != lock:
		agent.is_animation_locked = lock
	return SUCCESS
