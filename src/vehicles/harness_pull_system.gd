## Harness Pull System
## Physics-based sled pulling - applies forces to RigidBody3D sled based on puller positions.
## Much simpler than PinJoint3D approach and avoids complex joint setup timing issues.
extends Node
class_name HarnessPullSystem

signal pulling_started
signal pulling_stopped

## Rope length in meters - pullers beyond this distance will pull the sled
@export var rope_length: float = 4.0
## Base pull force per puller in Newtons
@export var pull_force_per_puller: float = 400.0
## How much support pullers contribute (0-1)
@export var support_efficiency: float = 0.7

## Reference to parent sled (RigidBody3D)
var sled: RigidBody3D = null
## Whether currently being pulled
var is_pulling: bool = false


func _ready() -> void:
	sled = get_parent() as RigidBody3D
	if sled == null:
		push_error("[HarnessPullSystem] Parent must be a RigidBody3D")
		return

	print("[HarnessPullSystem] Initialized with rope_length=%.1fm" % [rope_length])


func _physics_process(delta: float) -> void:
	if sled == null:
		return

	var lead_puller: Node3D = _get_lead_puller()
	if lead_puller == null:
		_stop_pulling()
		return

	# Get sled harness position (where rope attaches - use SledRear for proper pull direction)
	var harness_pos: Vector3 = _get_harness_position()

	# Calculate direction and distance to lead puller
	var to_puller: Vector3 = lead_puller.global_position - harness_pos
	to_puller.y = 0.0  # Ignore vertical for pulling direction
	var distance: float = to_puller.length()

	# Damp sled velocity based on proximity to pullers
	# Closer = more damping. At rope_length: no damping. At 0: full stop.
	var tension: float = clampf(distance / rope_length, 0.0, 1.0)
	var damp_factor: float = tension * tension  # Exponential falloff
	sled.linear_velocity.x *= damp_factor
	sled.linear_velocity.z *= damp_factor

	# Only apply pull force if rope is taut
	if distance < rope_length * 0.8:
		_stop_pulling()
		return

	if not is_pulling:
		is_pulling = true
		pulling_started.emit()

	# Only apply force if lead puller is actually walking
	if "is_moving" in lead_puller and not lead_puller.is_moving:
		_stop_pulling()
		return

	var total_force: float = _calculate_total_pull_force()
	var pull_direction: Vector3 = to_puller.normalized()

	var force_vector: Vector3 = pull_direction * total_force
	force_vector.y = 0.0
	sled.apply_central_force(force_vector)

	# Clamp sled speed in pull direction to puller's actual speed
	var puller_vel: Vector3 = lead_puller.velocity if "velocity" in lead_puller else Vector3.ZERO
	puller_vel.y = 0.0
	var puller_speed_in_dir: float = maxf(puller_vel.dot(pull_direction), 0.0)
	var sled_speed_in_dir: float = Vector3(sled.linear_velocity.x, 0.0, sled.linear_velocity.z).dot(pull_direction)

	if sled_speed_in_dir > puller_speed_in_dir:
		var excess: float = sled_speed_in_dir - puller_speed_in_dir
		sled.linear_velocity.x -= pull_direction.x * excess
		sled.linear_velocity.z -= pull_direction.z * excess

	# Torque to align sled
	if pull_direction.length() > 0.1:
		var target_angle: float = atan2(pull_direction.x, pull_direction.z) + PI
		var angle_diff: float = wrapf(target_angle - sled.rotation.y, -PI, PI)
		sled.apply_torque(Vector3(0.0, angle_diff * total_force * 0.5, 0.0))


func _calculate_total_pull_force() -> float:
	if sled == null or not "pullers" in sled:
		return 0.0

	var total: float = 0.0
	var pullers: Array = sled.pullers
	var lead: Node3D = _get_lead_puller()

	for puller in pullers:
		if puller == lead:
			total += pull_force_per_puller
		else:
			total += pull_force_per_puller * support_efficiency

	return total


## Get harness attachment point - uses SledRear so sled gets pulled front-first
func _get_harness_position() -> Vector3:
	if sled and sled.has_node("SledRear"):
		return sled.get_node("SledRear").global_position
	if sled:
		return sled.global_position + (sled.global_transform.basis.z * 2.0)
	return Vector3.ZERO


func _get_lead_puller() -> Node3D:
	if sled and "lead_puller" in sled:
		return sled.lead_puller
	return null


func _stop_pulling() -> void:
	if is_pulling:
		is_pulling = false
		pulling_stopped.emit()


## Get the position where pullers should stand (rope_length behind sled rear)
func get_harness_position() -> Vector3:
	var harness_pos: Vector3 = _get_harness_position()
	if sled:
		var backward: Vector3 = sled.global_transform.basis.z.normalized()
		return harness_pos + backward * rope_length
	return harness_pos
