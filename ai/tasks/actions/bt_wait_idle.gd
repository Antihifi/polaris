@tool
class_name BTWaitIdle extends BTAction
## Waits for a specified duration before succeeding.
## Use this instead of native BTWait if you need custom behavior.

@export var duration: float = 1.0

var _elapsed: float = 0.0


func _generate_name() -> String:
	return "WaitIdle (%.1fs)" % duration


func _enter() -> void:
	_elapsed = 0.0


func _tick(delta: float) -> Status:
	_elapsed += delta
	if _elapsed >= duration:
		return SUCCESS
	return RUNNING


func _exit() -> void:
	_elapsed = 0.0
