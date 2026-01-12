@tool
extends BTAction
class_name BTDebugWait
## Debug version of BTWait that logs enter/exit/tick for diagnosing BT flow.
## Use this to verify whether wait tasks are being entered and completing properly.
##
## Set min_duration = max_duration for fixed waits, or different values for random range.

@export var min_duration: float = 5.0
@export var max_duration: float = 5.0

var _elapsed: float = 0.0
var _target_duration: float = 0.0


func _generate_name() -> String:
	if min_duration == max_duration:
		return "DebugWait [%.1fs]" % min_duration
	return "DebugWait [%.1f-%.1fs]" % [min_duration, max_duration]


func _enter() -> void:
	_elapsed = 0.0
	# Pick random duration in range (or fixed if min == max)
	_target_duration = randf_range(min_duration, max_duration)
	var agent: Node3D = get_agent()
	var agent_name: String = agent.name if agent else "unknown"
	print("[BTDebugWait] ENTER - agent=%s, will wait %.1fs" % [agent_name, _target_duration])


func _tick(delta: float) -> Status:
	_elapsed += delta

	# Log progress every second
	if int(_elapsed) != int(_elapsed - delta) and _elapsed < _target_duration:
		print("[BTDebugWait] TICK - elapsed=%.1fs / %.1fs" % [_elapsed, _target_duration])

	if _elapsed >= _target_duration:
		print("[BTDebugWait] COMPLETE - waited %.1fs" % _elapsed)
		return SUCCESS

	return RUNNING


func _exit() -> void:
	var completed: bool = _elapsed >= _target_duration
	var agent: Node3D = get_agent()
	var agent_name: String = agent.name if agent else "unknown"
	print("[BTDebugWait] EXIT - agent=%s, elapsed=%.1fs / %.1fs, completed=%s" % [agent_name, _elapsed, _target_duration, completed])

	if not completed:
		print("[BTDebugWait] WARNING: Wait was interrupted before completion!")
