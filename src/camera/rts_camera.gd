extends Camera3D
## RTS-style camera with WASD movement, edge scrolling, zoom, and MMB orbit.
## Spyglass mode (Z): telephoto zoom. Sextant mode (M): top-down map view.

signal zoom_changed(zoom_level: float, zoom_ratio: float)

# =========================
# Camera movement settings
# =========================
@export_category("Camera movement")
@export var camera_speed: float = 20.0
@export var camera_zoom_speed: float = 20.0
@export var camera_zoom_min: float = 10.0
@export var camera_zoom_max: float = 50.0

# =========================
# Edge scrolling settings
# =========================
@export_category("Edge scrolling")
@export var edge_scroll_margin: float = 0.0
@export var edge_scroll_speed: float = 15.0

# =========================
# Rotation (MMB) settings
# =========================
@export_category("Rotation")
@export var yaw_sensitivity: float = 0.50
@export var pitch_sensitivity: float = 0.18
@export var max_step_deg: float = 3.0
@export var pitch_min_deg: float = 10.0
@export var pitch_max_deg: float = 80.0
@export var capture_mouse_on_mmb: bool = false

# =========================
# Focus/Follow settings
# =========================
@export_category("Focus")
@export var focus_lerp_speed: float = 5.0
@export var follow_selected: bool = false

# =========================
# Movement bounds
# =========================
@export_category("Bounds")
@export var max_distance_from_units: float = 75.0
@export var bounds_group: String = "selectable_units"

# =========================
# Terrain collision
# =========================
@export_category("Terrain Collision")
@export var min_height_above_terrain: float = 3.0
@export var terrain_collision_enabled: bool = false
@export var terrain_follow_enabled: bool = true
@export var terrain_follow_speed: float = 8.0

# =========================
# Runtime state
# =========================
var orbit_center: Vector3 = Vector3.ZERO
var orbit_distance: float = 25.0
var current_height: float = 20.0
var orbit_radius: float = 20.0

var _is_mmb_rotating := false
var _yaw: float = 0.0
var _pitch: float = 0.8

var _focus_target: Node3D = null
var _is_focusing: bool = false
var _focus_destination: Vector3 = Vector3.ZERO
var _terrain: Node = null

# Screen shake
var _shake_intensity: float = 0.0
var _shake_duration: float = 0.0
var _shake_timer: float = 0.0
var _shake_offset: Vector3 = Vector3.ZERO

# =========================
# Item modes (Z = spyglass, M = map/sextant)
# =========================
var _spyglass_mode: bool = false
var _sextant_mode: bool = false
var _saved_fov: float = 75.0
var _saved_pitch: float = 0.0
var _saved_orbit_distance: float = 25.0
var _saved_orbit_center: Vector3 = Vector3.ZERO
var _spyglass_overlay: CanvasLayer = null
var _spyglass_unit: Node3D = null
var _spyglass_origin: Node3D = null  # Reference to SpyGlassOrigin marker
var _spyglass_base_yaw: float = 0.0  # Starting yaw when entering spyglass (for neck limit)
var _spyglass_sway_time: float = 0.0  # Timer for natural camera sway
const SPYGLASS_FOV: float = 25.0  # Narrow telephoto
const SPYGLASS_YAW_LIMIT: float = 1.57  # ±90 degrees (PI/2) from center
const SPYGLASS_SWAY_INTENSITY: float = 0.003  # Subtle sway amount
const SPYGLASS_SWAY_SPEED: float = 1.2
const SPYGLASS_OVERLAY_TEXTURE: String = "res://textures/spyglass_overlay.png"
const SEXTANT_PITCH: float = 1.4  # ~80 degrees (near top-down)
const SEXTANT_DISTANCE: float = 45.0  # Reduced from 80


func _ready() -> void:
	# Camera must keep processing during pause so player can look around
	process_mode = Node.PROCESS_MODE_ALWAYS
	_find_terrain()
	_saved_fov = fov
	var pmin := deg_to_rad(pitch_min_deg)
	var pmax := deg_to_rad(pitch_max_deg)
	_pitch = clamp(_pitch, pmin, pmax)
	_update_camera_position()


func _process(delta: float) -> void:
	# Screen shake
	if _shake_timer > 0.0:
		_shake_timer -= delta
		var shake_progress := _shake_timer / _shake_duration if _shake_duration > 0.0 else 0.0
		var current_intensity := _shake_intensity * shake_progress
		_shake_offset = Vector3(
			randf_range(-current_intensity, current_intensity),
			randf_range(-current_intensity, current_intensity) * 0.5,
			randf_range(-current_intensity, current_intensity)
		)
		_update_camera_position()
	else:
		_shake_offset = Vector3.ZERO

	# First-person spyglass mode - lock to SpyGlassOrigin marker
	if _spyglass_mode:
		if _spyglass_origin and is_instance_valid(_spyglass_origin):
			orbit_center = _spyglass_origin.global_position

		# Natural hand-held sway effect
		_spyglass_sway_time += delta
		var sway_x := sin(_spyglass_sway_time * SPYGLASS_SWAY_SPEED) * SPYGLASS_SWAY_INTENSITY
		var sway_y := cos(_spyglass_sway_time * SPYGLASS_SWAY_SPEED * 0.7) * SPYGLASS_SWAY_INTENSITY * 0.6
		_pitch += sway_y * delta * 10.0
		_yaw += sway_x * delta * 10.0
		# Re-clamp after sway
		_pitch = clamp(_pitch, deg_to_rad(-85.0), deg_to_rad(85.0))
		_yaw = clamp(_yaw, _spyglass_base_yaw - SPYGLASS_YAW_LIMIT, _spyglass_base_yaw + SPYGLASS_YAW_LIMIT)

		_update_camera_position()
		return  # Skip normal movement in spyglass mode

	# Smooth focus transition
	if _is_focusing:
		orbit_center = orbit_center.lerp(_focus_destination, focus_lerp_speed * delta)
		if orbit_center.distance_to(_focus_destination) < 0.1:
			orbit_center = _focus_destination
			_is_focusing = false
		_update_camera_position()

	# Orbit around current position (MMB)
	if _is_mmb_rotating:
		_update_camera_position()
		return

	# Follow selected unit
	if follow_selected and _focus_target and is_instance_valid(_focus_target):
		orbit_center = orbit_center.lerp(_focus_target.global_position, focus_lerp_speed * 0.5 * delta)
		_update_camera_position()

	var movement := Vector3.ZERO

	# WASD movement
	if Input.is_physical_key_pressed(KEY_D) or Input.is_action_pressed("ui_right"):
		movement.x += 1
	if Input.is_physical_key_pressed(KEY_A) or Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_physical_key_pressed(KEY_W) or Input.is_action_pressed("ui_up"):
		movement.z -= 1
	if Input.is_physical_key_pressed(KEY_S) or Input.is_action_pressed("ui_down"):
		movement.z += 1

	# Edge scrolling (disabled in sextant/map mode)
	if edge_scroll_margin > 0.0 and not _sextant_mode:
		var mouse_pos := get_viewport().get_mouse_position()
		var viewport_size = get_viewport().size
		if mouse_pos.x < edge_scroll_margin:
			movement.x -= 1
		elif mouse_pos.x > viewport_size.x - edge_scroll_margin:
			movement.x += 1
		if mouse_pos.y < edge_scroll_margin:
			movement.z -= 1
		elif mouse_pos.y > viewport_size.y - edge_scroll_margin:
			movement.z += 1

	var speed_multiplier := 2.0 if Input.is_action_pressed("ui_shift") else 1.0

	if movement.length() > 0.0:
		movement = movement.normalized().rotated(Vector3.UP, _yaw)
		var new_center := orbit_center + movement * camera_speed * speed_multiplier * delta
		orbit_center = _constrain_to_units(new_center)
		_focus_target = null
		_update_camera_position()


func _unhandled_input(event: InputEvent) -> void:
	# Item mode toggles
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Z:
			_toggle_spyglass_mode()
			get_viewport().set_input_as_handled()
			return
		elif event.keycode == KEY_M:
			_toggle_sextant_mode()
			get_viewport().set_input_as_handled()
			return

	# Mouse button handling
	if event is InputEventMouseButton:
		# Block all mouse input in sextant mode
		if _sextant_mode:
			get_viewport().set_input_as_handled()
			return

		# Block mouse zoom in spyglass mode (first-person, no zoom allowed)
		if _spyglass_mode:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				get_viewport().set_input_as_handled()
				return

		# Mouse wheel zoom (normal mode only)
		var zoom_multiplier := 3.0 if Input.is_action_pressed("ui_shift") else 1.0
		var zoom_amount := camera_zoom_speed * zoom_multiplier * get_process_delta_time()

		if event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			orbit_distance = max(camera_zoom_min, orbit_distance - zoom_amount)
			_update_camera_position()
			_emit_zoom_changed()
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			orbit_distance = min(camera_zoom_max, orbit_distance + zoom_amount)
			_update_camera_position()
			_emit_zoom_changed()

		# MMB rotate (not needed in spyglass mode - free look is always on)
		if event.button_index == MOUSE_BUTTON_MIDDLE and not _spyglass_mode:
			_is_mmb_rotating = event.pressed
			if capture_mouse_on_mmb:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)

	# Mouse motion rotation - free look in spyglass mode, MMB drag otherwise
	elif event is InputEventMouseMotion:
		if _sextant_mode:
			return  # No rotation in sextant mode

		# Allow free mouse look in spyglass mode (no MMB needed)
		if _spyglass_mode or _is_mmb_rotating:
			var vp = get_viewport().size
			var vmin := float(min(vp.x, vp.y))
			var dt := get_process_delta_time()
			var sixty_fps := 60.0 * dt

			var dx = (event.relative.x / vmin) * yaw_sensitivity * TAU * sixty_fps
			var dy = (event.relative.y / vmin) * pitch_sensitivity * TAU * sixty_fps

			var max_step := deg_to_rad(max_step_deg)
			dx = clamp(dx, -max_step, max_step)
			dy = clamp(dy, -max_step, max_step)

			_yaw -= dx
			_pitch += dy

			# Different limits for spyglass mode
			if _spyglass_mode:
				# Pitch: near-full vertical range
				_pitch = clamp(_pitch, deg_to_rad(-85.0), deg_to_rad(85.0))
				# Yaw: limited to human neck range (±90° from starting direction)
				_yaw = clamp(_yaw, _spyglass_base_yaw - SPYGLASS_YAW_LIMIT, _spyglass_base_yaw + SPYGLASS_YAW_LIMIT)
			else:
				var pmin := deg_to_rad(pitch_min_deg)
				var pmax := deg_to_rad(pitch_max_deg)
				_pitch = clamp(_pitch, pmin, pmax)
			_update_camera_position()


# =========================
# Item Modes
# =========================
func _get_unit_for_item_check() -> Node:
	## Get a unit to check for items - prioritize focus target, fallback to selected units.
	# Try focus target first
	if _focus_target and is_instance_valid(_focus_target):
		return _focus_target

	# Fallback: check SelectionManager for selected units
	if has_node("/root/SelectionManager"):
		var selection_manager := get_node("/root/SelectionManager")
		if selection_manager.has_method("get_selected_units"):
			var selected: Array = selection_manager.get_selected_units()
			for unit in selected:
				if is_instance_valid(unit) and unit.has_method("has_item_by_id"):
					return unit

	# Fallback: search for selected units in scene
	var selected_units := get_tree().get_nodes_in_group("selectable_units")
	for unit in selected_units:
		if is_instance_valid(unit) and "is_selected" in unit and unit.is_selected:
			if unit.has_method("has_item_by_id"):
				return unit

	return null


func _has_spyglass() -> bool:
	## Check if any selected unit has spyglass equipped.
	var unit := _get_unit_for_item_check()
	if unit and unit.has_method("has_item_by_id"):
		return unit.has_item_by_id("spyglass")
	return false


func _has_sextant() -> bool:
	## Check if any selected unit has sextant equipped.
	var unit := _get_unit_for_item_check()
	if unit and unit.has_method("has_item_by_id"):
		return unit.has_item_by_id("sextant")
	return false


func _toggle_spyglass_mode() -> void:
	# Require spyglass to use zoom mode
	if not _spyglass_mode and not _has_spyglass():
		print("[Camera] No spyglass equipped")
		return

	if _sextant_mode:
		_exit_sextant_mode()

	if _spyglass_mode:
		_exit_spyglass_mode()
	else:
		_enter_spyglass_mode()


func _enter_spyglass_mode() -> void:
	var unit := _get_unit_for_item_check()
	if not unit:
		print("[Camera] No unit found for spyglass")
		return

	# Only allow spyglass when unit is stopped
	if not _is_unit_stopped(unit):
		print("[Camera] Unit must be stopped to use spyglass")
		return

	# Find SpyGlassOrigin marker on the unit
	var origin: Node3D = unit.get_node_or_null("SpyGlassOrigin")
	if not origin:
		print("[Camera] No SpyGlassOrigin marker found on unit")
		return

	_spyglass_unit = unit
	_spyglass_origin = origin

	# Save current state
	_saved_fov = fov
	_saved_orbit_center = orbit_center
	_saved_orbit_distance = orbit_distance
	_saved_pitch = _pitch

	# Get yaw from marker's +Z direction (forward)
	var marker_basis: Basis = origin.global_transform.basis
	var forward: Vector3 = -marker_basis.z  # -Z is forward in Godot
	_spyglass_base_yaw = atan2(forward.x, forward.z)
	_yaw = _spyglass_base_yaw
	_spyglass_sway_time = 0.0

	# First-person setup
	fov = SPYGLASS_FOV
	orbit_distance = 0.1
	orbit_center = origin.global_position
	_pitch = 0.0

	# Capture mouse for free look
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	_spyglass_mode = true
	_update_camera_position()
	_create_spyglass_overlay()
	print("[Camera] Spyglass mode ON - at SpyGlassOrigin")


func _exit_spyglass_mode() -> void:
	fov = _saved_fov
	orbit_center = _saved_orbit_center
	orbit_distance = _saved_orbit_distance
	_pitch = _saved_pitch
	_spyglass_unit = null
	_spyglass_origin = null
	_spyglass_mode = false

	# Restore normal mouse mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	_update_camera_position()
	_destroy_spyglass_overlay()
	print("[Camera] Spyglass mode OFF")


func _is_unit_stopped(unit: Node) -> bool:
	## Check if unit is stationary - just check velocity.
	if not unit or not is_instance_valid(unit):
		return false
	if "velocity" in unit:
		return unit.velocity.length_squared() < 0.01
	return true


func _toggle_sextant_mode() -> void:
	# Require sextant to use map mode
	if not _sextant_mode and not _has_sextant():
		print("[Camera] No sextant equipped")
		return

	if _spyglass_mode:
		_exit_spyglass_mode()

	if _sextant_mode:
		_exit_sextant_mode()
	else:
		_enter_sextant_mode()


func _enter_sextant_mode() -> void:
	_saved_pitch = _pitch
	_saved_orbit_distance = orbit_distance
	_pitch = SEXTANT_PITCH
	orbit_distance = SEXTANT_DISTANCE
	_sextant_mode = true
	_update_camera_position()
	print("[Camera] Sextant mode ON (bird's eye)")


func _exit_sextant_mode() -> void:
	_pitch = _saved_pitch
	orbit_distance = _saved_orbit_distance
	_sextant_mode = false
	_update_camera_position()
	print("[Camera] Sextant mode OFF")


func is_spyglass_mode() -> bool:
	return _spyglass_mode


func is_sextant_mode() -> bool:
	return _sextant_mode


func _create_spyglass_overlay() -> void:
	## Create fullscreen shader overlay for spyglass visual effect.
	if _spyglass_overlay:
		return

	_spyglass_overlay = CanvasLayer.new()
	_spyglass_overlay.layer = 100

	var rect := ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var shader := load("res://shaders/spyglass_overlay.gdshader")
	if shader:
		var mat := ShaderMaterial.new()
		mat.shader = shader
		var vp_size: Vector2i = get_viewport().size
		mat.set_shader_parameter("screen_size", Vector2(vp_size.x, vp_size.y))
		# Load overlay texture if it exists
		if ResourceLoader.exists(SPYGLASS_OVERLAY_TEXTURE):
			mat.set_shader_parameter("overlay_texture", load(SPYGLASS_OVERLAY_TEXTURE))
		rect.material = mat

	_spyglass_overlay.add_child(rect)
	get_tree().root.add_child(_spyglass_overlay)


func _destroy_spyglass_overlay() -> void:
	if _spyglass_overlay:
		_spyglass_overlay.queue_free()
		_spyglass_overlay = null


# =========================
# Helpers
# =========================
func _constrain_to_units(pos: Vector3) -> Vector3:
	if max_distance_from_units <= 0.0:
		return pos

	var units := get_tree().get_nodes_in_group(bounds_group)
	if units.is_empty():
		return pos

	var nearest_unit: Node3D = null
	var nearest_dist_sq: float = INF
	var pos_xz := Vector2(pos.x, pos.z)

	for unit in units:
		if unit is Node3D:
			var unit_xz := Vector2(unit.global_position.x, unit.global_position.z)
			var dist_sq := pos_xz.distance_squared_to(unit_xz)
			if dist_sq < nearest_dist_sq:
				nearest_dist_sq = dist_sq
				nearest_unit = unit

	if not nearest_unit:
		return pos

	var nearest_dist := sqrt(nearest_dist_sq)
	if nearest_dist <= max_distance_from_units:
		return pos

	var unit_pos := nearest_unit.global_position
	var dir_xz := (pos_xz - Vector2(unit_pos.x, unit_pos.z)).normalized()
	var constrained_xz := Vector2(unit_pos.x, unit_pos.z) + dir_xz * max_distance_from_units

	return Vector3(constrained_xz.x, pos.y, constrained_xz.y)


func _update_camera_position() -> void:
	# Terrain follow
	if terrain_follow_enabled:
		var target_terrain_height := _get_terrain_height(orbit_center)
		if target_terrain_height > -1000.0:
			var delta := get_process_delta_time()
			if delta > 0.0:
				orbit_center.y = lerpf(orbit_center.y, target_terrain_height, terrain_follow_speed * delta)
			else:
				orbit_center.y = target_terrain_height

	# Spherical position
	var dir := Vector3(
		sin(_yaw) * cos(_pitch),
		sin(_pitch),
		cos(_yaw) * cos(_pitch)
	).normalized()

	var new_pos := orbit_center + dir * orbit_distance

	# Terrain collision
	if terrain_collision_enabled:
		var terrain_height := _get_terrain_height(new_pos)
		var min_y := terrain_height + min_height_above_terrain
		if new_pos.y < min_y:
			new_pos.y = min_y

	position = new_pos + _shake_offset
	look_at(orbit_center, Vector3.UP)

	current_height = orbit_distance * sin(_pitch)
	orbit_radius = orbit_distance * cos(_pitch)


# =========================
# Public API
# =========================
func focus_on(target: Node3D, instant: bool = false) -> void:
	_focus_target = target
	_focus_destination = target.global_position
	if instant:
		orbit_center = _focus_destination
		_is_focusing = false
		_update_camera_position()
	else:
		_is_focusing = true


func focus_on_position(pos: Vector3, instant: bool = false) -> void:
	_focus_target = null
	_focus_destination = _constrain_to_units(pos)
	if instant:
		orbit_center = _focus_destination
		_is_focusing = false
		_update_camera_position()
	else:
		_is_focusing = true


func set_focus_target(target: Node3D) -> void:
	_focus_target = target


func clear_focus_target() -> void:
	_focus_target = null


func get_focus_target() -> Node3D:
	return _focus_target


func shake(intensity: float, duration: float) -> void:
	_shake_intensity = intensity
	_shake_duration = duration
	_shake_timer = duration


func get_zoom_ratio() -> float:
	return (orbit_distance - camera_zoom_min) / (camera_zoom_max - camera_zoom_min)


func _emit_zoom_changed() -> void:
	zoom_changed.emit(orbit_distance, get_zoom_ratio())


# =========================
# Terrain Helpers
# =========================
func _find_terrain() -> void:
	var terrain_nodes := get_tree().get_nodes_in_group("terrain")
	for node in terrain_nodes:
		if node.get_class() == "Terrain3D" or "Terrain3D" in node.name:
			_terrain = node
			return
	var scene := get_tree().current_scene
	if scene:
		_terrain = _find_node_by_class(scene, "Terrain3D")


func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	if node.get_class() == class_name_str or class_name_str in node.name:
		return node
	for child in node.get_children():
		var found := _find_node_by_class(child, class_name_str)
		if found:
			return found
	return null


func _get_terrain_height(world_pos: Vector3) -> float:
	if not _terrain:
		_find_terrain()
	if _terrain and "data" in _terrain and _terrain.data:
		if _terrain.data.has_method("get_height"):
			var height: float = _terrain.data.get_height(world_pos)
			if not is_nan(height) and height > -1000.0:
				return height
	return -INF
