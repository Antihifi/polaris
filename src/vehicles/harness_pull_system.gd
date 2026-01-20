## Harness Pull System
## Physics-based sled pulling - applies forces to RigidBody3D sled based on puller positions.
## Much simpler than PinJoint3D approach and avoids complex joint setup timing issues.
extends Node
class_name HarnessPullSystem

signal pulling_started
signal pulling_stopped

## Rope length in meters - pullers beyond this distance will pull the sled
@export var rope_length: float = 6.0
## Base pull force per puller in Newtons
@export var pull_force_per_puller: float = 400.0
## Maximum sled speed when being pulled (m/s) - matches unit walk speed
@export var max_pull_speed: float = 5.0
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
	print("[HarnessPullSystem] Initialized with rope_length=%.1fm, max_speed=%.1fm/s" % [rope_length, max_pull_speed])


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

	# Only pull if rope is taut (puller beyond rope length)
	if distance < rope_length * 0.9:  # Small slack zone
		_stop_pulling()
		# Apply friction/drag to slow down when not being pulled
		sled.linear_velocity.x = lerpf(sled.linear_velocity.x, 0.0, 3.0 * delta)
		sled.linear_velocity.z = lerpf(sled.linear_velocity.z, 0.0, 3.0 * delta)
		return

	# Start pulling
	if not is_pulling:
		is_pulling = true
		pulling_started.emit()

	# Calculate total pull force from all pullers
	var total_force: float = _calculate_total_pull_force()

	# Get pull direction (toward lead puller)
	var pull_direction: Vector3 = to_puller.normalized()

	# Calculate target velocity based on force and mass
	# More force = faster, heavier sled = slower
	var force_ratio: float = total_force / (sled.mass * 9.81 * 0.3)  # vs friction force
	var target_speed: float = clampf(force_ratio * max_pull_speed * 0.5, 0.0, max_pull_speed)

	# Target velocity in pull direction
	var target_velocity: Vector3 = pull_direction * target_speed

	# Smoothly accelerate toward target velocity
	sled.linear_velocity.x = lerpf(sled.linear_velocity.x, target_velocity.x, 5.0 * delta)
	sled.linear_velocity.z = lerpf(sled.linear_velocity.z, target_velocity.z, 5.0 * delta)

	# Rotate sled so front (-Z) faces the pull direction (slowly align)
	# Add PI because atan2 gives angle where +Z faces target, but we want -Z (front) to face it
	if target_speed > 0.1:
		var target_angle: float = atan2(pull_direction.x, pull_direction.z) + PI
		var current_angle: float = sled.rotation.y
		sled.rotation.y = lerp_angle(current_angle, target_angle, 2.0 * delta)


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
