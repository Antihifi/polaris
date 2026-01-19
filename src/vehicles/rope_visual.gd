## Rope Visual - Multi-segment catenary rope
## Renders a rope with slack/taut mechanics using cylinder segments.
extends Node3D
class_name RopeVisual

## Height offset for attachment at puller's waist
const WAIST_HEIGHT: float = 1.0
## Rope thickness
const ROPE_RADIUS: float = 0.025
## Number of segments for the rope curve
const SEGMENT_COUNT: int = 6

## Reference to the start attachment point (sled front marker)
var start_node: Node3D = null
## Reference to the end attachment point (puller unit)
var end_node: Node3D = null
## The rope length used to calculate tension (from sled controller)
var rope_length: float = 3.0

## Array of cylinder MeshInstance3D segments
var _segments: Array[MeshInstance3D] = []
## Shared material for all segments
var _material: StandardMaterial3D = null


func _ready() -> void:
	# Create shared material
	_material = StandardMaterial3D.new()
	_material.albedo_color = Color(0.45, 0.35, 0.25)  # Hemp rope brown
	_material.roughness = 0.9

	# Create cylinder segments
	for i in range(SEGMENT_COUNT):
		var segment := MeshInstance3D.new()
		var cylinder := CylinderMesh.new()
		cylinder.top_radius = ROPE_RADIUS
		cylinder.bottom_radius = ROPE_RADIUS
		cylinder.height = 1.0  # Will be scaled per-segment
		cylinder.radial_segments = 6
		cylinder.rings = 1
		segment.mesh = cylinder
		segment.material_override = _material
		segment.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(segment)
		_segments.append(segment)

	print("[RopeVisual] Created %d rope segments" % SEGMENT_COUNT)


func _process(_delta: float) -> void:
	if not is_instance_valid(start_node) or not is_instance_valid(end_node):
		visible = false
		return

	visible = true
	_update_rope()


## Initialize the rope with start and end nodes.
func setup(start: Node3D, end: Node3D, length: float) -> void:
	start_node = start
	end_node = end
	rope_length = length
	print("[RopeVisual] Setup: start=%s, end=%s, rope_length=%.1f" % [start.name, end.name, length])


## Update all rope segments to form a catenary curve.
func _update_rope() -> void:
	var start_pos: Vector3 = start_node.global_position
	var end_pos: Vector3 = end_node.global_position + Vector3.UP * WAIST_HEIGHT

	# Calculate tension (0 = very slack, 1 = taut, >1 = overstretched)
	var distance: float = start_pos.distance_to(end_pos)
	var tension: float = distance / rope_length

	# Calculate catenary points
	var points: Array[Vector3] = _calculate_catenary_points(start_pos, end_pos, tension)

	# Update each segment to connect consecutive points
	for i in range(SEGMENT_COUNT):
		var p1: Vector3 = points[i]
		var p2: Vector3 = points[i + 1]
		_position_segment(_segments[i], p1, p2)

	# Visual feedback: change color based on tension
	_update_tension_color(tension)


## Calculate points along the catenary curve.
func _calculate_catenary_points(start_pos: Vector3, end_pos: Vector3, tension: float) -> Array[Vector3]:
	var points: Array[Vector3] = []

	# Direction and distance
	var horizontal_dir: Vector3 = end_pos - start_pos
	var distance: float = horizontal_dir.length()
	horizontal_dir = horizontal_dir.normalized() if distance > 0.001 else Vector3.FORWARD

	# Sag amount based on tension
	# When slack (tension < 0.7): lots of sag
	# When normal (0.7-1.0): moderate sag
	# When taut (>1.0): minimal sag
	var sag_amount: float = _calculate_sag(tension, distance)

	# Generate points along the curve
	for i in range(SEGMENT_COUNT + 1):
		var t: float = float(i) / float(SEGMENT_COUNT)

		# Linear interpolation for base position
		var pos: Vector3 = start_pos.lerp(end_pos, t)

		# Apply catenary sag (parabola: maximum at center, zero at ends)
		# Formula: sag * 4 * t * (1 - t) gives a nice parabola
		var sag_factor: float = 4.0 * t * (1.0 - t)
		pos.y -= sag_amount * sag_factor

		points.append(pos)

	return points


## Calculate how much the rope should sag based on tension.
func _calculate_sag(tension: float, distance: float) -> float:
	if tension >= 1.2:
		# Very taut - almost no sag
		return distance * 0.02
	elif tension >= 1.0:
		# Taut - minimal sag
		var t: float = (tension - 1.0) / 0.2
		return lerpf(distance * 0.08, distance * 0.02, t)
	elif tension >= 0.7:
		# Normal tension - moderate sag
		var t: float = (tension - 0.7) / 0.3
		return lerpf(distance * 0.25, distance * 0.08, t)
	elif tension >= 0.3:
		# Slack - significant sag
		var t: float = (tension - 0.3) / 0.4
		return lerpf(distance * 0.5, distance * 0.25, t)
	else:
		# Very slack - rope piles on ground
		# Limit sag so rope doesn't go through ground
		var max_sag: float = minf(distance * 0.6, start_node.global_position.y - 0.1)
		return maxf(max_sag, distance * 0.3)


## Position a cylinder segment between two points.
func _position_segment(segment: MeshInstance3D, p1: Vector3, p2: Vector3) -> void:
	var midpoint: Vector3 = (p1 + p2) * 0.5
	var segment_length: float = p1.distance_to(p2)
	var direction: Vector3 = (p2 - p1).normalized()

	# Position at midpoint
	segment.global_position = midpoint

	# Orient to point from p1 to p2
	if direction.length_squared() > 0.001:
		# Use look_at then rotate since cylinder is Y-aligned
		var up: Vector3 = Vector3.UP
		# Avoid gimbal lock when direction is nearly vertical
		if absf(direction.dot(Vector3.UP)) > 0.99:
			up = Vector3.FORWARD
		segment.look_at(midpoint + direction, up)
		segment.rotate_object_local(Vector3.RIGHT, PI / 2.0)

	# Scale to match segment length
	segment.scale = Vector3(1.0, segment_length, 1.0)


## Update rope color based on tension for visual feedback.
func _update_tension_color(tension: float) -> void:
	var color: Color

	if tension > 1.3:
		# Overstrained - reddish tint
		color = Color(0.6, 0.3, 0.2)
	elif tension > 1.0:
		# Taut - slightly lighter
		var t: float = (tension - 1.0) / 0.3
		color = Color(0.45, 0.35, 0.25).lerp(Color(0.6, 0.3, 0.2), t)
	elif tension < 0.5:
		# Very slack - darker
		color = Color(0.35, 0.28, 0.2)
	else:
		# Normal - standard rope color
		color = Color(0.45, 0.35, 0.25)

	_material.albedo_color = color
