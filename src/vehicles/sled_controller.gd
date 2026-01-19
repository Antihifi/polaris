## Sled Controller
## Handles physics-based sled movement, cargo weight tracking, and puller attachment.
## Sleds are pulled by men (or dogs) using a force-based system.
## Directional damping simulates ski physics (easy forward, hard backward, impossible sideways).
extends RigidBody3D
class_name SledController

signal puller_attached(unit: Node3D)
signal puller_detached(unit: Node3D)
signal cargo_changed(total_weight: float)

## Base mass of empty sled in kg
@export var base_mass: float = 150.0
## Maximum cargo weight the sled can carry in kg
@export var max_cargo_weight: float = 500.0
## Length of the rope from harness to sled front in meters
@export var rope_length: float = 2.0
## Maximum number of units that can pull this sled
@export var max_pullers: int = 4
## Base pull force per puller in Newtons (must overcome friction: ~450N for 150kg sled on snow)
@export var pull_force_per_puller: float = 800.0
## Friction multiplier applied when stationary (prevents sliding on slopes)
@export var static_friction_multiplier: float = 2.0

## Directional Resistance Settings
## Sleds have skis that only slide forward/backward, not sideways
@export_group("Directional Resistance")
## Lateral (sideways) damping - very high because skis don't slide sideways
@export var lateral_damping: float = 80.0
## Lateral damping when being pulled - lower to allow pivoting toward pull direction
@export var lateral_damping_while_pulled: float = 15.0
## Reverse movement damping - harder to push backwards than pull forward
@export var reverse_damping: float = 25.0
## Forward movement damping - minimal resistance in intended direction
@export var forward_damping: float = 0.5
## Angular damping for rotation resistance (yaw) - base multiplier
@export var angular_damping_multiplier: float = 5.0
## Extra torque resistance when lateral force is applied (prevents spinning on a dime)
@export var lateral_torque_resistance: float = 50.0
## Torque applied to turn sled toward pull direction (higher = faster pivot)
@export var pivot_torque_strength: float = 200.0

## Rope Visual Settings
@export_group("Rope Visuals")
## Scene to instantiate for each rope connection
@export var rope_visual_scene: PackedScene = null
## Whether to show rope visuals (can be toggled for performance)
@export var show_rope_visuals: bool = true

## Reference to front marker for direction calculation
@onready var sled_front: Marker3D = $SledFront if has_node("SledFront") else null
## Reference to rear marker for direction calculation
@onready var sled_rear: Marker3D = $SledRear if has_node("SledRear") else null

## Reference to the cargo detection area (child node)
@onready var cargo_area: Area3D = $CargoArea if has_node("CargoArea") else null

## Array of units currently attached as pullers
var pullers: Array[Node3D] = []
## The designated lead puller who determines navigation
var lead_puller: Node3D = null
## Current cargo items detected in the cargo area
var cargo_items: Array[Node3D] = []
## Cached total cargo weight
var _cached_cargo_weight: float = 0.0
## Whether the sled is currently being pulled
var is_being_pulled: bool = false

## Sled length for harness positioning (calculated from markers)
var _sled_length: float = 10.0
## Dictionary mapping puller -> RopeVisual instance
var _rope_visuals: Dictionary = {}
## Cached reference to Terrain3D for floor checks
var _terrain_cache: Node = null


func _ready() -> void:
	# Calculate sled length from markers
	if sled_front and sled_rear:
		_sled_length = sled_front.position.distance_to(sled_rear.position)
	# Set the base mass
	mass = base_mass

	# Connect cargo area signals if available
	if cargo_area:
		cargo_area.body_entered.connect(_on_cargo_entered)
		cargo_area.body_exited.connect(_on_cargo_exited)

	# Add to sleds group for easy querying
	add_to_group("sleds")


func _physics_process(delta: float) -> void:
	# CRITICAL: Terrain floor check to prevent falling through terrain
	# RigidBody3D collision can fail on spawn or during physics settling
	_enforce_terrain_floor()

	# Always apply directional resistance based on velocity
	_apply_directional_damping(delta)

	if pullers.is_empty():
		is_being_pulled = false
		return

	is_being_pulled = _are_pullers_moving()

	if is_being_pulled:
		var pull_force: Vector3 = _calculate_pull_force()
		apply_central_force(pull_force)
		# Apply pivot torque to turn sled toward pull direction
		_apply_pivot_torque(delta)


## Attach a unit as a puller. Returns true if successful.
func attach_puller(unit: Node3D) -> bool:
	if pullers.size() >= max_pullers:
		push_warning("SledController: Cannot attach puller, max pullers reached")
		return false

	if unit in pullers:
		push_warning("SledController: Unit already attached as puller")
		return false

	pullers.append(unit)

	# First puller becomes the lead
	if lead_puller == null:
		lead_puller = unit

	# Create rope visual for this puller
	_create_rope_visual(unit)

	puller_attached.emit(unit)
	return true


## Detach a unit from pulling duty.
func detach_puller(unit: Node3D) -> void:
	var idx: int = pullers.find(unit)
	if idx == -1:
		return

	# Destroy rope visual before removing puller
	_destroy_rope_visual(unit)

	pullers.remove_at(idx)

	# If lead puller was removed, assign new lead
	if unit == lead_puller:
		lead_puller = pullers[0] if not pullers.is_empty() else null

	puller_detached.emit(unit)


## Detach all pullers.
func detach_all_pullers() -> void:
	var pullers_copy: Array[Node3D] = pullers.duplicate()
	for puller in pullers_copy:
		detach_puller(puller)


## Get the current total weight of cargo.
func get_cargo_weight() -> float:
	return _cached_cargo_weight


## Get the total weight including base sled mass.
func get_total_weight() -> float:
	return base_mass + _cached_cargo_weight


## Check if the sled can accept more cargo.
func can_add_cargo(weight: float) -> bool:
	return (_cached_cargo_weight + weight) <= max_cargo_weight


## Calculate the pull force based on attached pullers.
## Uses POSITION-BASED tension: force increases as rope stretches beyond slack length.
func _calculate_pull_force() -> Vector3:
	if pullers.is_empty() or lead_puller == null:
		return Vector3.ZERO

	# Calculate pull direction from sled (harness) to lead puller
	var harness_pos: Vector3 = sled_front.global_position if sled_front else global_position
	var to_lead: Vector3 = lead_puller.global_position - harness_pos
	to_lead.y = 0.0  # Keep horizontal
	var distance: float = to_lead.length()

	if distance < 0.1:
		return Vector3.ZERO  # Too close, no tension

	var pull_direction: Vector3 = to_lead.normalized()

	# POSITION-BASED TENSION: Force increases as distance exceeds slack threshold
	# Slack zone: 0 to 30% of rope_length = no force (rope is loose)
	# Tension zone: 30% to 100% = force ramps up
	# Max tension: beyond 100% = full force
	var slack_threshold: float = rope_length * 0.3
	var tension_factor: float = 0.0

	if distance <= slack_threshold:
		# Rope is slack - no pulling force
		tension_factor = 0.0
	elif distance < rope_length:
		# Rope is tensioning - force ramps up linearly
		tension_factor = (distance - slack_threshold) / (rope_length - slack_threshold)
	else:
		# Rope is at or beyond max length - full tension
		tension_factor = 1.0

	if tension_factor < 0.01:
		return Vector3.ZERO

	# Calculate base force from number of pullers
	var total_force: float = pull_force_per_puller * pullers.size()

	# Reduce force based on cargo weight (heavier = slower acceleration)
	var weight_ratio: float = get_total_weight() / base_mass
	var weight_factor: float = 1.0 / weight_ratio  # Inversely proportional

	# Check if lead puller is trying to move (has movement intent)
	# This prevents the sled from being pulled when everyone is standing still
	var has_movement_intent: bool = false
	if "is_moving" in lead_puller and lead_puller.is_moving:
		has_movement_intent = true
	elif "velocity" in lead_puller:
		var vel: Vector3 = lead_puller.velocity
		if Vector3(vel.x, 0, vel.z).length_squared() > 0.01:
			has_movement_intent = true

	# Even without movement intent, apply force if rope is taut
	# This helps the sled "catch up" when units are stopped at rope limit
	# CRITICAL: Without this, there's a deadlock:
	#   - Unit stops at rope limit (velocity=0)
	#   - Sled sees no movement → no force → never moves
	#   - Unit can never move again
	if not has_movement_intent:
		if distance > rope_length * 0.7:
			# Rope is taut - apply catch-up force (70% power)
			# Needs to be strong enough to overcome static friction
			tension_factor *= 0.7
		else:
			return Vector3.ZERO  # No movement intent and rope not taut

	return pull_direction * total_force * weight_factor * tension_factor


## Apply directional damping to simulate ski physics.
## Skis slide easily forward, harder backward, and almost not at all sideways.
func _apply_directional_damping(delta: float) -> void:
	var vel: Vector3 = linear_velocity
	if vel.length_squared() < 0.001:
		return

	# Get the sled's forward direction (from rear to front marker, or use -Z if no markers)
	var forward_dir: Vector3
	if sled_front and sled_rear:
		forward_dir = (sled_front.global_position - sled_rear.global_position).normalized()
	else:
		# Fallback: use local -Z axis (front of sled)
		forward_dir = -global_transform.basis.z.normalized()

	# Ensure forward direction is horizontal
	forward_dir.y = 0.0
	forward_dir = forward_dir.normalized()

	# Calculate lateral direction (perpendicular to forward, horizontal)
	var lateral_dir: Vector3 = forward_dir.cross(Vector3.UP).normalized()

	# Decompose velocity into forward and lateral components (ignore Y for now)
	var vel_horizontal: Vector3 = Vector3(vel.x, 0.0, vel.z)
	var forward_speed: float = vel_horizontal.dot(forward_dir)
	var lateral_speed: float = vel_horizontal.dot(lateral_dir)

	# Calculate damping forces
	var damping_force: Vector3 = Vector3.ZERO

	# Lateral damping - very strong when stationary, reduced when being pulled to allow pivoting
	var effective_lateral_damping := lateral_damping_while_pulled if is_being_pulled else lateral_damping
	damping_force -= lateral_dir * lateral_speed * effective_lateral_damping

	# Forward/reverse damping depends on direction
	if forward_speed > 0.0:
		# Moving forward (in the direction from rear to front) - easy, minimal damping
		damping_force -= forward_dir * forward_speed * forward_damping
	else:
		# Moving backward - harder, more damping
		damping_force -= forward_dir * forward_speed * reverse_damping

	# Apply the damping force (scaled by delta for physics stability)
	# Without delta scaling, forces would be 60x too strong at 60fps
	apply_central_force(damping_force * mass * delta * 60.0)

	# Apply angular damping to resist rotation/spinning
	var ang_vel: Vector3 = angular_velocity

	# Base angular damping (always active)
	if ang_vel.length_squared() > 0.001:
		var yaw_damping: Vector3 = Vector3(0.0, -ang_vel.y * angular_damping_multiplier, 0.0)
		apply_torque(yaw_damping * mass * delta * 60.0)

	# Additional torque resistance proportional to lateral movement
	# This simulates the entire length of the sled's skis digging into the snow
	# preventing it from spinning like a top when pushed from the side
	if absf(lateral_speed) > 0.1:
		# The harder you push sideways, the more the sled resists rotating
		# This is because both front and rear skis are dragging sideways
		var lateral_torque_damping: float = absf(lateral_speed) * lateral_torque_resistance
		var rotation_resistance: Vector3 = Vector3(0.0, -ang_vel.y * lateral_torque_damping, 0.0)
		apply_torque(rotation_resistance * mass * delta * 60.0)


## Apply torque to turn sled toward the pull direction.
## This actively rotates the sled to face where it's being pulled.
func _apply_pivot_torque(delta: float) -> void:
	if lead_puller == null:
		return

	# Get sled's current forward direction
	var forward_dir: Vector3
	if sled_front and sled_rear:
		forward_dir = (sled_front.global_position - sled_rear.global_position).normalized()
	else:
		forward_dir = -global_transform.basis.z.normalized()
	forward_dir.y = 0.0
	if forward_dir.length_squared() < 0.001:
		return
	forward_dir = forward_dir.normalized()

	# Get direction to lead puller (desired forward direction)
	var to_lead: Vector3 = lead_puller.global_position - global_position
	to_lead.y = 0.0
	if to_lead.length_squared() < 0.01:
		return
	var pull_dir: Vector3 = to_lead.normalized()

	# Calculate signed angle between forward and pull direction
	var angle: float = forward_dir.signed_angle_to(pull_dir, Vector3.UP)

	# Apply torque to rotate toward pull direction
	# Torque is proportional to angle difference (scaled by delta for stability)
	var torque_magnitude: float = angle * pivot_torque_strength
	apply_torque(Vector3(0.0, torque_magnitude, 0.0) * mass * delta * 60.0)


## Check if any pullers are currently moving.
func _are_pullers_moving() -> bool:
	for puller in pullers:
		if "is_moving" in puller and puller.is_moving:
			return true
		if "velocity" in puller:
			var vel: Vector3 = puller.velocity
			if vel.length_squared() > 0.1:
				return true
	return false


## Called when a body enters the cargo area.
func _on_cargo_entered(body: Node3D) -> void:
	if body == self:
		return

	# Check if it's a valid cargo item (crate, barrel, or unit)
	if body.is_in_group("containers") or body.is_in_group("survivors"):
		cargo_items.append(body)
		_recalculate_cargo_weight()


## Called when a body exits the cargo area.
func _on_cargo_exited(body: Node3D) -> void:
	var idx: int = cargo_items.find(body)
	if idx != -1:
		cargo_items.remove_at(idx)
		_recalculate_cargo_weight()


## Recalculate the total cargo weight from all items.
func _recalculate_cargo_weight() -> void:
	var old_weight: float = _cached_cargo_weight
	_cached_cargo_weight = 0.0

	for item in cargo_items:
		_cached_cargo_weight += _get_item_weight(item)

	# Update physics mass
	mass = base_mass + _cached_cargo_weight

	if not is_equal_approx(old_weight, _cached_cargo_weight):
		cargo_changed.emit(_cached_cargo_weight)


## Get the weight of a cargo item.
func _get_item_weight(item: Node3D) -> float:
	# Check for explicit weight property
	if "weight" in item:
		return item.weight

	# Default weights by type
	if item.is_in_group("survivors"):
		return 80.0  # Average human weight
	elif item.is_in_group("containers"):
		# Could check for barrel vs crate
		if "barrel" in item.name.to_lower():
			return 45.0
		else:
			return 30.0  # Crate

	return 20.0  # Default


## Create a rope visual connecting the sled to a puller.
func _create_rope_visual(unit: Node3D) -> void:
	if not show_rope_visuals:
		return

	if rope_visual_scene == null:
		return

	if not sled_front:
		push_warning("SledController: Cannot create rope visual, no SledFront marker")
		return

	# Instantiate the rope visual
	var rope: RopeVisual = rope_visual_scene.instantiate() as RopeVisual
	if rope == null:
		push_warning("SledController: rope_visual_scene is not a RopeVisual")
		return

	# Add to scene tree (as sibling, not child, so it doesn't move with sled rotation)
	get_parent().add_child(rope)

	# Setup the rope with start/end points
	rope.setup(sled_front, unit, rope_length)

	# Track in dictionary
	_rope_visuals[unit] = rope


## Destroy the rope visual for a specific puller.
func _destroy_rope_visual(unit: Node3D) -> void:
	if unit not in _rope_visuals:
		return

	var rope: RopeVisual = _rope_visuals[unit]
	if is_instance_valid(rope):
		rope.queue_free()

	_rope_visuals.erase(unit)


## Toggle rope visual visibility.
func set_rope_visuals_enabled(enabled: bool) -> void:
	show_rope_visuals = enabled

	if enabled:
		# Create ropes for existing pullers
		for puller in pullers:
			if puller not in _rope_visuals:
				_create_rope_visual(puller)
	else:
		# Destroy all existing ropes
		for puller in _rope_visuals.keys():
			_destroy_rope_visual(puller)


## Enforce terrain floor to prevent falling through.
## This is a safety net when RigidBody3D collision fails (common on spawn).
func _enforce_terrain_floor() -> void:
	var terrain := _find_terrain3d()
	if terrain == null or not "data" in terrain or terrain.data == null:
		return

	var height: float = terrain.data.get_height(global_position)
	if not is_finite(height):
		return

	# Add a small offset for the sled's collision shape height
	# The sled's collision center is about 0.6m above the ground
	var floor_offset: float = 0.6

	# If sled is below terrain, teleport it back up and kill downward velocity
	if global_position.y < height + floor_offset:
		global_position.y = height + floor_offset
		# Also reset downward velocity to prevent bouncing/jittering
		if linear_velocity.y < 0:
			linear_velocity.y = 0.0


## Find Terrain3D node in scene (cached for performance).
func _find_terrain3d() -> Node:
	if _terrain_cache and is_instance_valid(_terrain_cache):
		return _terrain_cache

	var nodes := get_tree().get_nodes_in_group("terrain")
	if nodes.size() > 0:
		_terrain_cache = nodes[0]
		return _terrain_cache

	# Fallback: search for Terrain3D by class
	_terrain_cache = _find_node_by_class(get_tree().current_scene, "Terrain3D")
	return _terrain_cache


## Recursively find node by class name.
func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	if node == null:
		return null
	if node.get_class() == class_name_str:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_str)
		if result:
			return result
	return null
