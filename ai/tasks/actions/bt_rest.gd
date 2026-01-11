@tool
class_name BTRest extends BTAction
## Rests to recover energy over time.
## Uses "idle" animation while resting.
## Faces random direction when starting to rest (prevents all-facing-north issue).

@export var energy_target: float = 80.0
@export var energy_per_second: float = 5.0

var _resting: bool = false


func _generate_name() -> String:
	return "Rest (until %.0f%%)" % energy_target


func _enter() -> void:
	_resting = false


func _tick(delta: float) -> Status:
	var unit: Node = blackboard.get_var(&"unit")
	var stats: Resource = blackboard.get_var(&"stats")

	if not unit or not stats:
		return FAILURE

	# Start resting animation if not started
	if not _resting:
		# Face random direction to prevent all-facing-north issue in shelter
		_face_random_direction(unit)

		if unit.has_node("AnimationPlayer"):
			var anim_player: AnimationPlayer = unit.get_node("AnimationPlayer")
			if anim_player.has_animation("idle"):
				anim_player.play("idle")
		_resting = true

	# Check if energy target reached
	if stats.energy >= energy_target:
		_resting = false
		return SUCCESS

	# Recover energy (stats handles clamping)
	stats.energy += energy_per_second * delta

	return RUNNING


func _face_random_direction(unit: Node) -> void:
	## Face a random direction to prevent all units facing north.
	if unit is Node3D:
		unit.global_rotation.y = randf() * TAU


func _exit() -> void:
	_resting = false
