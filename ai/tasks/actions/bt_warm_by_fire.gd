@tool
class_name BTWarmByFire extends BTAction
## Warming behavior - unit stands/crouches in circle around fire, facing it.
## State machine: move to spot -> (optional) crouch transition -> idle loop -> stand transition -> exit

@export var warm_radius: float = 4.0  # Distance from fire center
@export var min_warm_time: float = 5.0  # Minimum seconds to warm
@export var max_warm_time: float = 15.0  # Maximum seconds to warm
## Chance to crouch instead of stand (0.0-1.0)
@export var crouch_chance: float = 0.5
## Animation speed for crouch transitions
@export var transition_anim_speed: float = 1.0

## States: 0=find spot, 1=moving, 2=crouch down transition, 3=warming idle, 4=stand up transition
var _state: int = 0
var _warm_timer: float = 0.0
var _warm_duration: float = 0.0  # How long to warm (set once)
var _move_timeout: float = 0.0  # Movement timeout tracker
var _is_crouching: bool = false
var _fire_node: Node3D = null
var _warm_spot: Vector3 = Vector3.ZERO

const MAX_MOVE_TIME: float = 10.0  # Max seconds to wait for arrival


func _generate_name() -> String:
	return "WarmByFire (%.0fm)" % warm_radius


func _enter() -> void:
	_state = 0
	_warm_timer = 0.0
	_warm_duration = 0.0
	_move_timeout = 0.0
	_is_crouching = false
	_fire_node = null
	_warm_spot = Vector3.ZERO


func _tick(delta: float) -> Status:
	var unit: Node = blackboard.get_var(&"unit")
	if not unit:
		return FAILURE

	# Get fire from blackboard (set by BTSeekResource) OR find nearest
	if not _fire_node:
		_fire_node = blackboard.get_var(&"target_node")
		# If no target_node (e.g., we were already near fire), find nearest heat source
		if not _fire_node or not is_instance_valid(_fire_node):
			_fire_node = _find_nearest_fire(unit)
		if not _fire_node or not is_instance_valid(_fire_node):
			return FAILURE

	match _state:
		0:  # Find warming spot in circle around fire
			_warm_spot = _find_warming_spot(unit)
			if _warm_spot == Vector3.ZERO:
				return FAILURE

			# Move to the spot
			if unit.has_method("move_to"):
				unit.move_to(_warm_spot)
			_state = 1
			return RUNNING

		1:  # Moving to warming spot
			_move_timeout += delta

			# Check if arrived OR timed out
			var arrived: bool = "is_moving" in unit and not unit.is_moving
			var timed_out: bool = _move_timeout >= MAX_MOVE_TIME

			if arrived or timed_out:
				if timed_out:
					# Force stop movement if timed out
					if unit.has_method("stop"):
						unit.stop()

				# Arrived - face fire and decide crouch/stand
				_face_fire(unit)
				_is_crouching = randf() < crouch_chance
				_warm_duration = randf_range(min_warm_time, max_warm_time)
				_warm_timer = 0.0

				if _is_crouching:
					# Play crouch_to_stand in REVERSE (stand to crouch)
					_play_animation_reverse(unit, "crouch_to_stand", transition_anim_speed)
					_state = 2  # Crouch down transition
				else:
					# Standing idle - skip crouch transition
					_play_animation_if_exists(unit, "idle")
					_state = 3  # Jump to warming idle
			return RUNNING

		2:  # Crouch down transition (reverse crouch_to_stand)
			_warm_timer += delta
			if _warm_timer >= 1.5:  # Transition animation time
				# Transition complete, start crouching_idle
				_play_animation_if_exists(unit, "crouching_idle")
				_warm_timer = 0.0
				_state = 3
			return RUNNING

		3:  # Warming idle (standing or crouching)
			_warm_timer += delta

			# Keep playing appropriate idle animation
			if _is_crouching:
				_play_animation_if_exists(unit, "crouching_idle")
			else:
				_play_animation_if_exists(unit, "idle")

			# Check if warmed long enough
			if _warm_timer >= _warm_duration:
				if _is_crouching:
					# Need to stand up first
					_play_animation_if_exists(unit, "crouch_to_stand", transition_anim_speed)
					_warm_timer = 0.0
					_state = 4
				else:
					# Standing - done
					return SUCCESS
			return RUNNING

		4:  # Stand up from crouch
			_warm_timer += delta
			if _warm_timer >= 1.5:  # crouch_to_stand animation time
				_play_animation_if_exists(unit, "idle")
				return SUCCESS
			return RUNNING

	return RUNNING


func _find_nearest_fire(unit: Node) -> Node3D:
	## Find the nearest heat source when target_node is not set.
	var unit_pos: Vector3 = unit.global_position if unit is Node3D else Vector3.ZERO
	var fires: Array[Node] = agent.get_tree().get_nodes_in_group("heat_sources")

	var nearest: Node3D = null
	var nearest_dist: float = 20.0  # Max search distance

	for fire in fires:
		if not fire is Node3D:
			continue
		var dist: float = unit_pos.distance_to(fire.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = fire

	return nearest


func _find_warming_spot(unit: Node) -> Vector3:
	## Find an unoccupied spot within warm_radius of fire.
	## Uses simple angle-based circle positioning.
	if not _fire_node or not is_instance_valid(_fire_node):
		return Vector3.ZERO

	var fire_pos: Vector3 = _fire_node.global_position
	var unit_pos: Vector3 = unit.global_position if unit is Node3D else Vector3.ZERO

	# Calculate angle from fire to unit (keeps them roughly in same direction)
	var to_unit: Vector3 = unit_pos - fire_pos
	to_unit.y = 0.0
	var base_angle: float = atan2(to_unit.z, to_unit.x)

	# Try to find unoccupied spot, starting from unit's approach angle
	for i in range(8):  # Try 8 positions around circle
		var angle: float = base_angle + (i * TAU / 8.0)
		var spot := Vector3(
			fire_pos.x + cos(angle) * warm_radius,
			fire_pos.y,
			fire_pos.z + sin(angle) * warm_radius
		)

		# Check if spot is unoccupied (no other unit within 1m)
		if _is_spot_free(spot, unit):
			return spot

	# Fallback: random spot if all occupied
	var random_angle: float = randf() * TAU
	return Vector3(
		fire_pos.x + cos(random_angle) * warm_radius,
		fire_pos.y,
		fire_pos.z + sin(random_angle) * warm_radius
	)


func _is_spot_free(spot: Vector3, exclude_unit: Node) -> bool:
	## Check if a warming spot is unoccupied by other units.
	var survivors: Array[Node] = agent.get_tree().get_nodes_in_group("survivors")
	for survivor in survivors:
		if survivor == exclude_unit:
			continue
		if not survivor is Node3D:
			continue
		var dist: float = spot.distance_to(survivor.global_position)
		if dist < 1.5:  # Too close to another survivor
			return false
	return true


func _face_fire(unit: Node) -> void:
	## Rotate unit to face the fire.
	if not unit is Node3D or not _fire_node:
		return

	var unit_pos: Vector3 = unit.global_position
	var fire_pos: Vector3 = _fire_node.global_position

	var dir_to_fire: Vector3 = (fire_pos - unit_pos).normalized()
	dir_to_fire.y = 0.0

	if dir_to_fire.length_squared() > 0.001:
		unit.global_rotation.y = atan2(dir_to_fire.x, dir_to_fire.z)


func _play_animation_if_exists(unit: Node, anim_name: String, speed_scale: float = 1.0) -> void:
	## Play animation if unit has AnimationPlayer with that animation.
	var anim_player: AnimationPlayer = _find_animation_player(unit)
	if not anim_player:
		return

	if anim_player.has_animation(anim_name):
		anim_player.speed_scale = speed_scale
		if anim_player.current_animation != anim_name:
			anim_player.play(anim_name)


func _play_animation_reverse(unit: Node, anim_name: String, speed_scale: float = 1.0) -> void:
	## Play animation in reverse (negative speed).
	var anim_player: AnimationPlayer = _find_animation_player(unit)
	if not anim_player:
		return

	if anim_player.has_animation(anim_name):
		# Set negative speed for reverse playback
		anim_player.speed_scale = -speed_scale
		# Start from end of animation
		anim_player.play(anim_name)
		anim_player.seek(anim_player.current_animation_length, true)


func _find_animation_player(node: Node) -> AnimationPlayer:
	## Recursively find AnimationPlayer in children.
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var found := _find_animation_player(child)
		if found:
			return found
	return null


func _exit() -> void:
	var unit: Node = blackboard.get_var(&"unit")
	if unit:
		# Restore normal animation speed and play idle
		var anim_player: AnimationPlayer = _find_animation_player(unit)
		if anim_player:
			anim_player.speed_scale = 1.0
		_play_animation_if_exists(unit, "idle")

	_state = 0
	_warm_timer = 0.0
	_warm_duration = 0.0
	_move_timeout = 0.0
	_is_crouching = false
	_fire_node = null
