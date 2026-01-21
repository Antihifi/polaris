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


## Follow leader - bypass navigation, just mirror the leader's movement.
func follow_leader(delta: float) -> void:
	if attached_sled == null or attached_sled.lead_puller == null:
		return

	var leader: CharacterBody3D = attached_sled.lead_puller as CharacterBody3D
	if not is_instance_valid(leader):
		return

	# Mirror the leader's velocity exactly
	unit.velocity = leader.velocity

	# Apply physics
	unit.move_and_slide()

	# Mirror the leader's rotation
	unit.rotation.y = leader.rotation.y

	# Mirror the leader's animation state
	unit.is_moving = leader.is_moving
	if "animation_player" in leader and leader.animation_player:
		if "animation_player" in unit and unit.animation_player:
			var anim: String = leader.animation_player.current_animation
			if anim and unit.animation_player.current_animation != anim:
				unit.animation_player.play(anim)
			unit.animation_player.speed_scale = leader.animation_player.speed_scale


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


func _play_animation(anim_name: String) -> void:
	if unit.has_method("_play_animation"):
		unit._play_animation(anim_name)


func _start_footsteps() -> void:
	if unit.has_method("_start_footsteps"):
		unit._start_footsteps()


func _stop_footsteps() -> void:
	if unit.has_method("_stop_footsteps"):
		unit._stop_footsteps()
