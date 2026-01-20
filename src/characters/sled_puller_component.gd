## Sled Puller Component
## Handles sled attachment and formation following.
## Attach as child of ClickableUnit to enable sled pulling capability.
extends Node
class_name SledPullerComponent

signal attached_to_sled(sled: Node)
signal detached_from_sled

## Reference to parent unit
var unit: CharacterBody3D = null
## Reference to the sled this unit is pulling (null if not pulling)
var attached_sled: Node = null
## Whether this unit is the lead puller
var is_lead_puller: bool = false
## Formation offset when pulling as support
var sled_formation_offset: Vector3 = Vector3.ZERO
## Cached terrain reference
var _terrain_cache: Node = null


func _ready() -> void:
	unit = get_parent() as CharacterBody3D
	if unit == null:
		push_error("[SledPullerComponent] Parent must be a CharacterBody3D")


## Attach this unit to a sled as a puller.
func attach_to_sled(sled: Node) -> bool:
	if attached_sled != null:
		push_warning("[%s] Already attached to a sled" % _get_unit_name())
		return false

	if not sled.has_method("attach_puller"):
		push_warning("[%s] Target is not a valid sled" % _get_unit_name())
		return false

	if sled.attach_puller(unit):
		attached_sled = sled
		is_lead_puller = "lead_puller" in sled and sled.lead_puller == unit
		print("[%s] Attached to sled as %s" % [_get_unit_name(), "lead" if is_lead_puller else "support"])
		attached_to_sled.emit(sled)
		return true

	return false


## Detach this unit from its current sled.
func detach_from_sled() -> void:
	if attached_sled == null:
		return

	if attached_sled.has_method("detach_puller"):
		attached_sled.detach_puller(unit)

	print("[%s] Detached from sled" % _get_unit_name())
	attached_sled = null
	is_lead_puller = false
	sled_formation_offset = Vector3.ZERO
	detached_from_sled.emit()


## Returns true if this unit is currently attached to a sled.
func is_pulling() -> bool:
	return attached_sled != null


## Returns true if this unit is a support puller (not leader).
func is_support_puller() -> bool:
	return attached_sled != null and not is_lead_puller


## Returns true if this unit should follow the leader in formation.
func should_follow_leader() -> bool:
	return attached_sled != null and not is_lead_puller and attached_sled.lead_puller != null


## Follow the lead puller in formation (called by support pullers).
func follow_leader(delta: float) -> void:
	if attached_sled == null or attached_sled.lead_puller == null:
		return

	var leader: Node3D = attached_sled.lead_puller
	if not is_instance_valid(leader):
		return

	# Calculate target position in leader's local space
	var target_pos: Vector3 = leader.global_position + leader.global_transform.basis * sled_formation_offset

	# Get terrain height at target position
	var terrain := _find_terrain3d()
	if terrain and "data" in terrain and terrain.data:
		var height: float = terrain.data.get_height(target_pos)
		if is_finite(height):
			target_pos.y = height

	# Calculate direction and distance to target
	var to_target: Vector3 = target_pos - unit.global_position
	to_target.y = 0.0
	var distance: float = to_target.length()

	# Get leader's movement state
	var leader_speed: float = 0.0
	if "movement_speed" in leader:
		leader_speed = leader.movement_speed
	if "is_moving" in leader and not leader.is_moving:
		leader_speed = 0.0

	var rotation_speed: float = 10.0
	if "rotation_speed" in unit:
		rotation_speed = unit.rotation_speed

	# If close enough, match leader
	if distance < 0.3:
		unit.velocity.x = 0.0
		unit.velocity.z = 0.0
		unit.rotation.y = lerp_angle(unit.rotation.y, leader.rotation.y, rotation_speed * delta)

		if leader_speed < 0.01:
			_play_animation("idle")
			_stop_footsteps()
		return

	# Move toward formation position
	var move_dir: Vector3 = to_target.normalized()
	# Move faster if falling behind
	var catch_up_mult: float = clampf(distance / 1.5, 1.0, 2.0)
	var move_speed: float = leader_speed * catch_up_mult

	unit.velocity.x = move_dir.x * move_speed
	unit.velocity.z = move_dir.z * move_speed
	unit.velocity.y -= 40.0 * delta  # Gravity

	# Rotate toward movement direction
	var target_rotation: float = atan2(move_dir.x, move_dir.z)
	unit.rotation.y = lerp_angle(unit.rotation.y, target_rotation, rotation_speed * delta)

	unit.move_and_slide()

	# Terrain floor check
	if terrain and "data" in terrain and terrain.data:
		var height: float = terrain.data.get_height(unit.global_position)
		if is_finite(height):
			unit.global_position.y = maxf(unit.global_position.y, height)

	# Animation - use correct name and sync speed
	if move_speed > 0.01:
		_play_animation("walking")
		_start_footsteps()
		_update_speed_scale(move_speed)
	else:
		_play_animation("idle")
		_stop_footsteps()


## Find the nearest sled within max_distance.
func get_nearest_sled(max_distance: float = 10.0) -> Node:
	var nearest: Node = null
	var nearest_dist: float = max_distance

	for sled in unit.get_tree().get_nodes_in_group("sleds"):
		var dist: float = unit.global_position.distance_to(sled.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = sled

	return nearest


func _get_unit_name() -> String:
	if unit and "unit_name" in unit:
		return unit.unit_name
	return "Unknown"


func _find_terrain3d() -> Node:
	if _terrain_cache and is_instance_valid(_terrain_cache):
		return _terrain_cache

	var nodes := unit.get_tree().get_nodes_in_group("terrain")
	if nodes.size() > 0:
		_terrain_cache = nodes[0]
		return _terrain_cache

	return null


func _play_animation(anim_name: String) -> void:
	if unit.has_method("_play_animation"):
		unit._play_animation(anim_name)


func _start_footsteps() -> void:
	if unit.has_method("_start_footsteps"):
		unit._start_footsteps()


func _stop_footsteps() -> void:
	if unit.has_method("_stop_footsteps"):
		unit._stop_footsteps()


func _update_speed_scale(current_speed: float) -> void:
	## Sync animation speed to actual movement speed.
	if not unit:
		return

	# Get base values from unit
	var base_anim_speed: float = 0.15
	var base_footstep_speed: float = 0.5
	var base_movement_speed: float = 5.0

	if "base_animation_speed" in unit:
		base_anim_speed = unit.base_animation_speed
	if "base_footstep_speed" in unit:
		base_footstep_speed = unit.base_footstep_speed
	if "movement_speed" in unit:
		base_movement_speed = unit.movement_speed

	# Calculate speed ratio (current vs unit's normal speed)
	var speed_ratio: float = current_speed / base_movement_speed if base_movement_speed > 0.01 else 1.0

	# Get time scale
	var time_scale: float = 1.0
	var time_manager := unit.get_node_or_null("/root/TimeManager")
	if time_manager and "time_scale" in time_manager:
		time_scale = time_manager.time_scale

	# Apply to animation
	if "animation_player" in unit and unit.animation_player:
		unit.animation_player.speed_scale = maxf(0.0, base_anim_speed * speed_ratio * time_scale)

	# Apply to footsteps
	if "_footstep_player" in unit and is_instance_valid(unit._footstep_player):
		var pitch: float = base_footstep_speed * speed_ratio * time_scale
		if pitch > 0.01:
			unit._footstep_player.pitch_scale = pitch
