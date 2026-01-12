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
		print("[BTAnimLock] FAILURE - agent=%s, has_prop=%s" % [agent, "is_animation_locked" in agent if agent else false])
		return FAILURE

	agent.is_animation_locked = lock
	print("[BTAnimLock] Set lock=%s for %s" % [lock, agent.name])
	return SUCCESS
