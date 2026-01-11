@tool
class_name BTWander extends BTAction
## Idle wandering behavior - picks random nearby point, moves there, then idles.
## Includes contextual idle animations:
## - SLEEPING: Only when in shelter, stays until energy reaches 85-90%
## - SITTING: Only when near containers (crates), sits ON crate with collision disabled
## - STANDING: Default idle when no context available

@export var wander_radius: float = 10.0
@export var min_wait_time: float = 3.0
@export var max_wait_time: float = 8.0
@export var target_var: StringName = &"move_target"

## Distance to container to be considered "near" for sitting
@export var sit_near_container_distance: float = 4.0
## Minimum energy threshold to START sleeping (only sleeps if below this)
@export var sleep_start_threshold: float = 50.0
## Energy threshold to WAKE UP from sleeping
@export var sleep_end_threshold: float = 88.0
## Energy threshold to stop sitting
@export var sit_end_threshold: float = 75.0
## Minimum game hours to stay sitting (if no energy threshold reached)
@export var min_sit_game_hours: float = 1.0
## Morale threshold above which wave animation can play during sitting
@export var wave_morale_threshold: float = 80.0
## Animation speed multiplier while sitting (0.5 = 50% slower)
@export var sitting_anim_speed: float = 0.5

## States: 0=picking target, 1=moving, 2=transitioning to idle, 3=idle/sitting/sleeping, 4=standing up from sitting
var _state: int = 0
var _wait_timer: float = 0.0
var _current_idle_type: String = "standing"  # standing, sitting, sleeping
var _transition_timer: float = 0.0
var _sit_start_game_hour: float = -1.0  # Track when sitting started
var _cached_time_manager: Node = null
var _sitting_container: Node3D = null  # Container we're sitting on
var _original_anim_speed: float = 1.0  # Store original animation speed
var _sit_down_started: bool = false  # Track if sit-down animation has started
var _wander_move_timeout: float = 0.0  # Stuck detection timeout

## Max seconds to wait for wander movement before picking a new target
const MAX_WANDER_MOVE_TIME: float = 5.0


func _generate_name() -> String:
	return "Wander (%.0fm)" % wander_radius


func _enter() -> void:
	_state = 0
	_wait_timer = 0.0
	_current_idle_type = "standing"
	_transition_timer = 0.0
	_sit_start_game_hour = -1.0
	_sitting_container = null
	_sit_down_started = false
	_wander_move_timeout = 0.0


func _tick(delta: float) -> Status:
	var unit: Node = blackboard.get_var(&"unit")
	if not unit:
		return FAILURE

	# If unit started moving (e.g., player command), exit sitting/sleeping immediately
	if _state >= 2 and "is_moving" in unit and unit.is_moving:
		# Unit is moving but we're in idle state - player must have given a command
		if _sitting_container:
			_release_container(_sitting_container)
			_sitting_container = null
		# Restore animation speed
		if unit.has_method("_update_speed_scale"):
			unit._update_speed_scale()
		return SUCCESS  # Exit wander, let movement happen

	match _state:
		0:  # Pick random target
			var unit_pos: Vector3 = blackboard.get_var(&"unit_position", Vector3.ZERO)
			# Randomize wander distance more
			var actual_radius: float = randf_range(wander_radius * 0.3, wander_radius)
			var angle: float = randf() * TAU
			var random_offset := Vector3(
				cos(angle) * actual_radius,
				0.0,
				sin(angle) * actual_radius
			)
			var target_pos: Vector3 = unit_pos + random_offset
			blackboard.set_var(target_var, target_pos)

			# Start moving
			if unit.has_method("move_to"):
				unit.move_to(target_pos)
			_state = 1
			return RUNNING

		1:  # Moving to target
			_wander_move_timeout += delta

			# Check if arrived
			var arrived: bool = "is_moving" in unit and not unit.is_moving

			# Stuck detection: if trying to move for too long, pick new target
			if _wander_move_timeout >= MAX_WANDER_MOVE_TIME:
				# Stop current movement
				if unit.has_method("stop"):
					unit.stop()
				# Reset to state 0 to pick a new random direction
				_state = 0
				_wander_move_timeout = 0.0
				return RUNNING

			if arrived:
				# Reached destination, decide what idle to do based on context
				_decide_idle_type(unit)
				_state = 2
				_transition_timer = 0.0
			return RUNNING

		2:  # Transitioning to idle pose (sitting down)
			_transition_timer += delta
			if _current_idle_type == "sitting":
				# Position unit and start sit-down animation ONCE
				if not _sit_down_started:
					_setup_sitting_on_crate(unit)
					_play_animation_if_exists(unit, "sitting_down_from_standing", sitting_anim_speed)
					_sit_down_started = true
				# Wait for transition animation (~1.5s at 0.5x speed = 3s)
				if _transition_timer >= 3.0:
					_state = 3
					_sit_start_game_hour = _get_current_game_hour()
			elif _current_idle_type == "sleeping":
				# No standing->sleeping transition yet, just go to sleep
				_state = 3
			else:
				# Standing idle - no transition needed
				_play_animation_if_exists(unit, "idle")
				_state = 3
				_wait_timer = randf_range(min_wait_time, max_wait_time)
			return RUNNING

		3:  # Idle/sitting/sleeping
			# Play appropriate idle animation loop and check exit conditions
			match _current_idle_type:
				"sitting":
					_play_sitting_animation(unit)
					if _should_stop_sitting(unit):
						# Transition to standing up (state 4)
						_state = 4
						_transition_timer = 0.0
						_play_animation_if_exists(unit, "stand_up", sitting_anim_speed)
				"sleeping":
					_play_sleeping_animation(unit)
					if _should_stop_sleeping(unit):
						_play_animation_if_exists(unit, "idle")
						return SUCCESS
				_:
					_play_animation_if_exists(unit, "idle")
					_wait_timer -= delta
					if _wait_timer <= 0.0:
						return SUCCESS
			return RUNNING

		4:  # Standing up from sitting
			_transition_timer += delta
			# Wait for stand_up animation to complete (~2s at 0.5x speed = 4s, but be generous)
			if _transition_timer >= 2.5:
				_cleanup_sitting(unit)
				_play_animation_if_exists(unit, "idle")
				return SUCCESS
			return RUNNING

	return RUNNING


func _decide_idle_type(unit: Node) -> void:
	## Decide what type of idle to do based on context:
	## - SLEEPING: Only if in shelter AND energy is low
	## - SITTING: Only if near containers (crates) AND not exhausted
	## - STANDING: Default fallback
	_current_idle_type = "standing"
	_sitting_container = null

	var stats = blackboard.get_var(&"stats")
	if not stats:
		return

	var energy: float = stats.get("energy") if stats else 100.0
	var is_in_shelter: bool = blackboard.get_var(&"is_in_shelter", false)

	# Check for sleeping - ONLY in shelter when energy is low
	if is_in_shelter and energy < sleep_start_threshold:
		_current_idle_type = "sleeping"
		return

	# Check for sitting - ONLY near UNOCCUPIED containers (crates)
	# One man per crate - if no crate available, stand instead
	var nearest_container := _get_nearest_container(unit)
	if nearest_container and energy < 80.0:
		_current_idle_type = "sitting"
		_sitting_container = nearest_container
		# Claim this container so no one else can sit on it
		_claim_container(_sitting_container, unit)
		return

	# Default: standing idle (also when no crate available)


func _get_nearest_container(unit: Node) -> Node3D:
	## Find nearest UNOCCUPIED CRATE within sit_near_container_distance.
	## Only crates are suitable for sitting (flat top). Barrels are not.
	## Uses metadata "sitting_unit" to track which unit is sitting on each crate.
	var unit_pos: Vector3 = blackboard.get_var(&"unit_position", Vector3.ZERO)
	var containers: Array[Node] = agent.get_tree().get_nodes_in_group("containers")

	var nearest: Node3D = null
	var nearest_dist: float = sit_near_container_distance

	for container in containers:
		if not container is Node3D:
			continue
		# ONLY sit on CRATES - must have "crate" in name or scene path
		var container_name: String = container.name.to_lower()
		var scene_path: String = container.scene_file_path.to_lower() if container.scene_file_path else ""

		# Skip barrels - check both name AND scene path
		if "barrel" in container_name or "barrel" in scene_path:
			continue
		# Must be explicitly a crate, not just "not a barrel"
		if not ("crate" in container_name or "crate" in scene_path):
			continue
		# Skip if no SeatPoint markers (can't sit properly)
		var seat_points: Array[Marker3D] = _find_seat_points_recursive(container)
		if seat_points.is_empty():
			continue
		# Skip containers that already have someone sitting on them
		if _is_container_occupied(container):
			continue
		var dist: float = unit_pos.distance_to(container.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = container
	return nearest


func _is_container_occupied(container: Node3D) -> bool:
	## Check if a container already has a unit sitting on it.
	if not container.has_meta("sitting_unit"):
		return false
	var sitting_unit = container.get_meta("sitting_unit")
	# Check if the sitting unit is still valid and actually sitting
	if sitting_unit == null or not is_instance_valid(sitting_unit):
		container.remove_meta("sitting_unit")
		return false
	return true


func _claim_container(container: Node3D, unit: Node) -> void:
	## Mark a container as occupied by this unit.
	container.set_meta("sitting_unit", unit)


func _release_container(container: Node3D) -> void:
	## Release a container so others can use it.
	if container and is_instance_valid(container) and container.has_meta("sitting_unit"):
		container.remove_meta("sitting_unit")


func _is_near_container(_unit: Node) -> bool:
	## Check if unit is within sit_near_container_distance of any container.
	return _sitting_container != null and is_instance_valid(_sitting_container)


func _find_seat_points_recursive(node: Node) -> Array[Marker3D]:
	## Recursively find all SeatPoint_* Marker3D nodes in the hierarchy.
	var result: Array[Marker3D] = []
	for child in node.get_children():
		if child is Marker3D and child.name.begins_with("SeatPoint"):
			result.append(child)
		# Recurse into children
		result.append_array(_find_seat_points_recursive(child))
	return result


func _find_closest_seat_point(unit: Node) -> Marker3D:
	## Find the closest SeatPoint_* marker on the sitting container.
	## Searches recursively since SeatPoints may be nested.
	## Returns null if no SeatPoint markers exist.
	if not _sitting_container:
		return null

	var unit_pos: Vector3 = unit.global_position if unit is Node3D else Vector3.ZERO
	var closest: Marker3D = null
	var closest_dist: float = INF

	var seat_points: Array[Marker3D] = _find_seat_points_recursive(_sitting_container)
	for seat_point in seat_points:
		var dist: float = unit_pos.distance_to(seat_point.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = seat_point

	return closest


func _setup_sitting_on_crate(unit: Node) -> void:
	## Position unit at the closest SeatPoint, facing away from crate.
	## Character stands here, then sit animation moves them onto crate.
	## Industry standard: snap to marker, no collision math.
	if not _sitting_container or not is_instance_valid(_sitting_container):
		return

	# Find the closest SeatPoint marker
	var seat_point: Marker3D = _find_closest_seat_point(unit)
	if not seat_point:
		push_warning("[BTWander] Crate %s has no SeatPoint markers" % _sitting_container.name)
		return

	# Snap character to seat point (standing in front of crate)
	unit.global_position = seat_point.global_position

	# Face AWAY from the crate center (back to the crate so sitting animation works)
	if unit is Node3D:
		var crate_center: Vector3 = _sitting_container.global_position
		var seat_pos: Vector3 = seat_point.global_position
		# Direction from crate to seat point = direction unit should face (away from crate)
		var away_dir: Vector3 = (seat_pos - crate_center).normalized()
		# Calculate Y rotation to face away from crate (only use X/Z plane)
		if away_dir.length_squared() > 0.001:
			unit.global_rotation.y = atan2(away_dir.x, away_dir.z)

	# Store original animation speed
	var anim_player: AnimationPlayer = _find_animation_player(unit)
	if anim_player:
		_original_anim_speed = anim_player.speed_scale


func _cleanup_sitting(unit: Node) -> void:
	## Restore animation speed when done sitting.
	## Also releases the container so another unit can use it.

	# Release the container so others can sit on it
	_release_container(_sitting_container)

	# Restore animation speed by calling unit's update_speed_scale if available
	# This ensures time_scale and energy effects are properly applied
	if unit.has_method("_update_speed_scale"):
		unit._update_speed_scale()
	else:
		# Fallback: restore original speed
		var anim_player: AnimationPlayer = _find_animation_player(unit)
		if anim_player:
			anim_player.speed_scale = _original_anim_speed

	_sitting_container = null


func _should_stop_sleeping(_unit: Node) -> bool:
	## Returns true when unit should wake up from sleeping.
	## Wakes up when energy reaches 85-90% OR no longer in shelter.
	var stats = blackboard.get_var(&"stats")
	if not stats:
		return true

	var energy: float = stats.get("energy") if stats else 100.0
	var is_in_shelter: bool = blackboard.get_var(&"is_in_shelter", false)

	# Wake up if no longer in shelter
	if not is_in_shelter:
		return true

	# Wake up when rested enough
	if energy >= sleep_end_threshold:
		return true

	return false


func _should_stop_sitting(_unit: Node) -> bool:
	## Returns true when unit should stop sitting.
	## Stops when: energy >= 75% OR sat for 1+ game hour OR container gone.
	var stats = blackboard.get_var(&"stats")
	if not stats:
		return true

	var energy: float = stats.get("energy") if stats else 100.0

	# Stop if energy restored
	if energy >= sit_end_threshold:
		return true

	# Stop if container is gone
	if not _sitting_container or not is_instance_valid(_sitting_container):
		return true

	# Check if sat long enough (1+ game hour)
	if _sit_start_game_hour >= 0.0:
		var current_hour: float = _get_current_game_hour()
		var hours_sitting: float = current_hour - _sit_start_game_hour
		# Handle day rollover
		if hours_sitting < 0.0:
			hours_sitting += 24.0
		if hours_sitting >= min_sit_game_hours:
			return true

	return false


func _get_current_game_hour() -> float:
	## Get current game hour from TimeManager.
	if not _cached_time_manager:
		_cached_time_manager = Engine.get_singleton("TimeManager") if Engine.has_singleton("TimeManager") else null
		if not _cached_time_manager:
			_cached_time_manager = agent.get_tree().root.get_node_or_null("TimeManager")

	if _cached_time_manager and "current_hour" in _cached_time_manager:
		return _cached_time_manager.current_hour
	return 0.0


func _play_sitting_animation(unit: Node) -> void:
	## Play sitting animations with occasional wave if morale is high.
	## Uses slower animation speed.
	var stats = blackboard.get_var(&"stats")
	var morale: float = stats.get("morale") if stats else 50.0

	# Very occasionally wave if morale is high
	if morale > wave_morale_threshold and randf() < 0.005:
		_play_animation_if_exists(unit, "sitting_raising_hand", sitting_anim_speed)
	else:
		_play_animation_if_exists(unit, "sitting_depressed", sitting_anim_speed)


func _play_sleeping_animation(unit: Node) -> void:
	## Play sleeping animation - disturbed if low stats.
	var stats = blackboard.get_var(&"stats")
	if not stats:
		_play_animation_if_exists(unit, "sleeping_idle")
		return

	var hunger: float = stats.get("hunger") if stats else 100.0
	var warmth: float = stats.get("warmth") if stats else 100.0
	var morale: float = stats.get("morale") if stats else 100.0

	# Disturbed sleep if suffering
	if hunger < 30.0 or warmth < 30.0 or morale < 30.0:
		_play_animation_if_exists(unit, "sleeping_disturbed")
	else:
		_play_animation_if_exists(unit, "sleeping_idle")


func _play_animation_if_exists(unit: Node, anim_name: String, speed_scale: float = 1.0) -> void:
	## Play animation if unit has AnimationPlayer with that animation.
	## Optionally set custom speed_scale.
	var anim_player: AnimationPlayer = _find_animation_player(unit)
	if not anim_player:
		return

	if anim_player.has_animation(anim_name):
		# Set speed scale before playing
		anim_player.speed_scale = speed_scale
		if anim_player.current_animation != anim_name:
			anim_player.play(anim_name)


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
	# Cleanup if we exit mid-sitting or mid-sleeping
	var unit: Node = blackboard.get_var(&"unit")

	# Always release container if we claimed one
	if _sitting_container:
		_release_container(_sitting_container)

	if unit:
		# Ensure animation speed is restored and idle animation plays
		if unit.has_method("_update_speed_scale"):
			unit._update_speed_scale()
		# Play idle to reset from any sitting/sleeping pose
		_play_animation_if_exists(unit, "idle")

	_state = 0
	_wait_timer = 0.0
	_current_idle_type = "standing"
	_sit_down_started = false
	_transition_timer = 0.0
	_sit_start_game_hour = -1.0
	_sitting_container = null
