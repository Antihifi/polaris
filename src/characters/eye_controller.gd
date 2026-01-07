class_name EyeController
extends Node

## Controls eye movement patterns for a character's eye shader.
## Attach as a child of the mesh that has the eye shader material.

enum EyeState {
	IDLE,          ## Slow, relaxed wandering
	SEARCHING,     ## Side to side scanning
	ALERT,         ## Quick darting movements
	FOCUSED,       ## Looking at a specific direction
	TIRED,         ## Slow, droopy movements
	NERVOUS,       ## Rapid small movements
}

@export var eye_mesh_path: NodePath

var current_state: EyeState = EyeState.IDLE
var target_look: Vector2 = Vector2.ZERO
var current_look: Vector2 = Vector2.ZERO
var state_timer: float = 0.0
var next_change: float = 0.0

var _material: ShaderMaterial
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

	if eye_mesh_path:
		var mesh: MeshInstance3D = get_node(eye_mesh_path)
		if mesh:
			# Try material_override first (single material for whole mesh)
			_material = mesh.material_override as ShaderMaterial
			# Fall back to surface override if needed
			if not _material:
				_material = mesh.get_surface_override_material(0) as ShaderMaterial

	if not _material:
		push_warning("EyeController: Could not find eye shader material")
		set_process(false)
		return

	# Disable the shader's built-in movement since we're controlling it
	_material.set_shader_parameter("movement_amount", 0.0)

	_pick_new_target()


func _process(delta: float) -> void:
	state_timer += delta

	# Check if we should pick a new target
	if state_timer >= next_change:
		_pick_new_target()

	# Smoothly move toward target
	var speed := _get_lerp_speed()
	current_look = current_look.lerp(target_look, speed * delta)

	# Apply to shader
	_apply_look(current_look)


func set_state(new_state: EyeState) -> void:
	current_state = new_state
	state_timer = 0.0
	_pick_new_target()


func look_at_direction(direction: Vector2, duration: float = 1.0) -> void:
	current_state = EyeState.FOCUSED
	target_look = direction.clampf(-1.0, 1.0)
	next_change = state_timer + duration


func _pick_new_target() -> void:
	state_timer = 0.0

	match current_state:
		EyeState.IDLE:
			# Gentle wandering, mostly centered
			target_look = Vector2(
				_rng.randf_range(-0.3, 0.3),
				_rng.randf_range(-0.2, 0.2)
			)
			next_change = _rng.randf_range(2.0, 5.0)

		EyeState.SEARCHING:
			# Side to side scanning
			var side := 1.0 if target_look.x < 0 else -1.0
			target_look = Vector2(
				side * _rng.randf_range(0.5, 0.8),
				_rng.randf_range(-0.1, 0.1)
			)
			next_change = _rng.randf_range(1.0, 2.0)

		EyeState.ALERT:
			# Quick movements to random positions
			target_look = Vector2(
				_rng.randf_range(-0.7, 0.7),
				_rng.randf_range(-0.5, 0.5)
			)
			next_change = _rng.randf_range(0.3, 0.8)

		EyeState.FOCUSED:
			# Stay on current target, will be set by look_at_direction
			next_change = _rng.randf_range(1.0, 3.0)

		EyeState.TIRED:
			# Mostly looking down, slow
			target_look = Vector2(
				_rng.randf_range(-0.2, 0.2),
				_rng.randf_range(0.2, 0.5)  # Looking down
			)
			next_change = _rng.randf_range(3.0, 6.0)

		EyeState.NERVOUS:
			# Small rapid movements
			target_look = current_look + Vector2(
				_rng.randf_range(-0.2, 0.2),
				_rng.randf_range(-0.2, 0.2)
			)
			target_look = target_look.clampf(-0.6, 0.6)
			next_change = _rng.randf_range(0.1, 0.3)


func _get_lerp_speed() -> float:
	match current_state:
		EyeState.IDLE:
			return 2.0
		EyeState.SEARCHING:
			return 3.0
		EyeState.ALERT:
			return 8.0
		EyeState.FOCUSED:
			return 5.0
		EyeState.TIRED:
			return 1.0
		EyeState.NERVOUS:
			return 10.0
	return 3.0


func _apply_look(look: Vector2) -> void:
	if not _material:
		return

	# Get iris sizes to scale movement appropriately
	var left_iris: float = _material.get_shader_parameter("left_iris_size")
	var right_iris: float = _material.get_shader_parameter("right_iris_size")

	# Scale look by iris size (movement is relative to eye size)
	var left_offset := look * left_iris * 0.5
	var right_offset := look * right_iris * 0.5

	# Apply flip/swap settings for right eye
	var right_look := look
	if _material.get_shader_parameter("right_swap_xy"):
		right_look = Vector2(right_look.y, right_look.x)
	if _material.get_shader_parameter("right_flip_x"):
		right_look.x = -right_look.x
	if _material.get_shader_parameter("right_flip_y"):
		right_look.y = -right_look.y
	right_offset = right_look * right_iris * 0.5

	# Apply flip/swap settings for left eye
	var left_look := look
	if _material.get_shader_parameter("left_swap_xy"):
		left_look = Vector2(left_look.y, left_look.x)
	if _material.get_shader_parameter("left_flip_x"):
		left_look.x = -left_look.x
	if _material.get_shader_parameter("left_flip_y"):
		left_look.y = -left_look.y
	left_offset = left_look * left_iris * 0.5

	# Get base centers
	var left_center: Vector2 = _material.get_shader_parameter("left_eye_center")
	var right_center: Vector2 = _material.get_shader_parameter("right_eye_center")

	# We need to modify the shader to accept dynamic offsets
	# For now, update the centers directly (store originals on first run)
	if not has_meta("original_left_center"):
		set_meta("original_left_center", left_center)
		set_meta("original_right_center", right_center)

	var orig_left: Vector2 = get_meta("original_left_center")
	var orig_right: Vector2 = get_meta("original_right_center")

	_material.set_shader_parameter("left_eye_center", orig_left + left_offset)
	_material.set_shader_parameter("right_eye_center", orig_right + right_offset)
