## Snow weather controller that integrates with Sky3D.
## Manages snow intensity, volumetric fog, and particle effects for arctic conditions.
## Uses Godot's volumetric fog (not Sky3D's screen-space fog) for proper blizzard effects.
class_name SnowController
extends Node

signal snow_started(intensity: SnowIntensity)
signal snow_stopped
signal snow_intensity_changed(from: SnowIntensity, to: SnowIntensity)

enum SnowIntensity {
	NONE,
	LIGHT,
	HEAVY
}

const SNOW_PARTICLES_SCENE: PackedScene = preload("res://src/systems/weather/snow_particles.tscn")
const BLIZZARD_POST_PROCESS_SHADER: Shader = preload("res://src/systems/weather/blizzard_post_process.gdshader")

## Reference to Sky3D node for lighting and wind
@export var sky3d: Node  # Sky3D type

## How long transitions between snow states take (seconds)
@export var transition_duration: float = 5.0

## Height above camera to spawn particles
@export var spawn_height_offset: float = 25.0

## Camera far plane at clear weather
@export var normal_far_distance: float = 4000.0

# =============================================================================
# BASELINE FOG (Always-on ambient atmosphere)
# =============================================================================
@export_category("Baseline Fog")

## Enable baseline atmospheric fog that's always present
@export var baseline_fog_enabled: bool = true

## Baseline volumetric fog density (~1/3 of light snow for subtle atmosphere)
@export_range(0.0, 0.1, 0.001) var baseline_fog_density: float = 0.025

## Baseline fog emission color (affects visibility from all angles)
@export var baseline_fog_emission: Color = Color(0.15, 0.15, 0.18)

# =============================================================================
# LIGHT SNOW SETTINGS
# =============================================================================
@export_category("Light Snow")

## Snow particle density (0-1)
@export_range(0.0, 1.0, 0.01) var light_particle_ratio: float = 0.4

## Wind speed during light snow
@export_range(0.0, 30.0, 0.5) var light_wind_speed: float = 8.0

## Particle wind multiplier
@export_range(0.0, 5.0, 0.1) var light_particle_wind_mult: float = 0.8

## Sun energy during light snow
@export_range(0.0, 1.0, 0.01) var light_sun_energy: float = 0.7

## Ambient light energy during light snow
@export_range(0.0, 1.0, 0.01) var light_ambient_energy: float = 0.85

## Volumetric fog density during light snow
@export_range(0.0, 0.2, 0.001) var light_volumetric_fog_density: float = 0.04

## Volumetric fog emission color during light snow
@export var light_fog_emission: Color = Color(0.2, 0.2, 0.22)

## Post-process fog shader density during light snow (lower = more subtle)
@export_range(0.0, 0.5, 0.001) var light_fog_shader_density: float = 0.015

## Animated fog shader emission during light snow
@export var light_fog_shader_emission: Color = Color(0.25, 0.25, 0.28)

## Camera visibility ratio (1.0 = normal, 0.1 = 10% of normal)
@export_range(0.01, 1.0, 0.01) var light_camera_far_ratio: float = 0.4

## Cloud coverage during light snow
@export_range(0.0, 1.0, 0.01) var light_cumulus_coverage: float = 0.75

## Atmosphere darkness during light snow
@export_range(0.0, 1.0, 0.01) var light_atm_darkness: float = 0.65

# =============================================================================
# HEAVY BLIZZARD SETTINGS
# =============================================================================
@export_category("Heavy Blizzard")

## Snow particle density (0-1)
@export_range(0.0, 1.0, 0.01) var heavy_particle_ratio: float = 1.0

## Wind speed during blizzard
@export_range(0.0, 50.0, 0.5) var heavy_wind_speed: float = 25.0

## Particle wind multiplier
@export_range(0.0, 5.0, 0.1) var heavy_particle_wind_mult: float = 2.0

## Sun energy during blizzard
@export_range(0.0, 1.0, 0.01) var heavy_sun_energy: float = 0.25

## Ambient light energy during blizzard
@export_range(0.0, 1.0, 0.01) var heavy_ambient_energy: float = 0.4

## Volumetric fog density during blizzard
@export_range(0.0, 0.3, 0.001) var heavy_volumetric_fog_density: float = 0.08

## Volumetric fog emission color during blizzard
@export var heavy_fog_emission: Color = Color(0.25, 0.25, 0.27)

## Post-process fog shader density during blizzard (lower = more subtle)
@export_range(0.0, 0.5, 0.001) var heavy_fog_shader_density: float = 0.04

## Animated fog shader emission during blizzard
@export var heavy_fog_shader_emission: Color = Color(0.35, 0.35, 0.38)

## Camera visibility ratio (0.0375 = ~150m visibility)
@export_range(0.01, 1.0, 0.001) var heavy_camera_far_ratio: float = 0.0375

## Cloud coverage during blizzard
@export_range(0.0, 1.0, 0.01) var heavy_cumulus_coverage: float = 1.0

## Atmosphere darkness during blizzard
@export_range(0.0, 1.0, 0.01) var heavy_atm_darkness: float = 0.85

# =============================================================================
# VOLUMETRIC FOG SHADER (Triangle noise blizzard effect)
# =============================================================================
@export_category("Volumetric Fog Shader")

## Triangle noise scale - smaller values = larger sweeping bands
@export_range(0.001, 0.05, 0.001) var fog_noise_scale: float = 0.008

## Fog wind speed (m/s) - how fast fog bands drift horizontally
@export_range(0.0, 20.0, 0.5) var fog_wind_speed: float = 7.0

## Vertical drift speed - snow falling/swirling vertically
@export_range(0.0, 3.0, 0.1) var fog_vertical_drift: float = 0.5

## Maximum fog opacity (0.7 = semi-transparent, 1.0 = can be opaque)
## KEY: This prevents the "opaque curtain" effect
@export_range(0.1, 1.0, 0.05) var fog_max_opacity: float = 0.7

## Wave amplitude for organic turbulence movement
@export_range(0.0, 10.0, 0.5) var fog_wave_amplitude: float = 3.0

## Wave frequency for turbulence
@export_range(0.0, 1.0, 0.05) var fog_wave_frequency: float = 0.3

## Fog albedo color (reflected light color)
@export var fog_albedo: Color = Color(0.75, 0.77, 0.8)

## Fog emission color (self-illumination)
@export var fog_emission_color: Color = Color(0.6, 0.62, 0.65)

## Current snow intensity
var current_intensity: SnowIntensity = SnowIntensity.NONE

## Target snow intensity (for transitions)
var _target_intensity: SnowIntensity = SnowIntensity.NONE

## Transition progress (0-1)
var _transition_progress: float = 1.0

## Active particle system
var _snow_particles: GPUParticles3D

## Camera reference for particle positioning
var _camera: Camera3D

## Particle process material for wind updates
var _particle_material: ParticleProcessMaterial

## Environment for volumetric fog control
var _environment: Environment = null

## Screen-space post-process mesh for volumetric blizzard fog
var _fog_mesh: MeshInstance3D = null
var _fog_shader_material: ShaderMaterial = null

## Smoothed fog wind speed to prevent hurricane effect during transitions
var _smoothed_fog_wind_speed: float = 0.0

## Original camera far distance
var _original_camera_far: float = 4000.0

## Original settings from Sky3D (restored when snow stops)
var _original_wind_speed: float = 0.0
var _original_sun_energy: float = 1.0
var _original_ambient_energy: float = 1.0

## Original volumetric fog settings
var _original_volumetric_fog_enabled: bool = false
var _original_volumetric_fog_density: float = 0.01
var _original_volumetric_fog_emission: Color = Color(0, 0, 0)

## SkyDome reference for overcast effect
var _sky_dome: Node = null

## Original SkyDome settings (restored when snow stops)
var _original_cumulus_coverage: float = 0.55
var _original_cumulus_intensity: float = 0.6
var _original_cirrus_coverage: float = 0.5
var _original_atm_darkness: float = 0.5
var _original_atm_thickness: float = 0.7
var _original_atm_sun_intensity: float = 18.0


## Build intensity config from exported variables
func _get_intensity_config(intensity: SnowIntensity) -> Dictionary:
	match intensity:
		SnowIntensity.NONE:
			return {
				"particle_amount_ratio": 0.0,
				"sky3d_wind_speed": 0.0,
				"particle_wind_mult": 0.0,
				"sun_energy": 1.0,
				"ambient_energy": 1.0,
				# Baseline fog (always-on atmospheric effect)
				"volumetric_fog_enabled": baseline_fog_enabled,
				"volumetric_fog_density": baseline_fog_density,
				"volumetric_fog_emission": baseline_fog_emission,
				# No animated fog during clear weather
				"fog_shader_density": 0.0,
				"fog_shader_emission": Vector3.ZERO,
				# Full camera distance
				"camera_far_ratio": 1.0,
				# SkyDome uses originals (-1 = use original)
				"cumulus_coverage": -1.0,
				"cumulus_intensity": -1.0,
				"cirrus_coverage": -1.0,
				"atm_darkness": -1.0,
				"atm_thickness": -1.0,
				"atm_sun_intensity": -1.0,
			}
		SnowIntensity.LIGHT:
			return {
				"particle_amount_ratio": light_particle_ratio,
				"sky3d_wind_speed": light_wind_speed,
				"particle_wind_mult": light_particle_wind_mult,
				"sun_energy": light_sun_energy,
				"ambient_energy": light_ambient_energy,
				"volumetric_fog_enabled": true,
				"volumetric_fog_density": light_volumetric_fog_density,
				"volumetric_fog_emission": light_fog_emission,
				"fog_shader_density": light_fog_shader_density,
				"fog_shader_emission": Vector3(light_fog_shader_emission.r, light_fog_shader_emission.g, light_fog_shader_emission.b),
				"camera_far_ratio": light_camera_far_ratio,
				"cumulus_coverage": light_cumulus_coverage,
				"cumulus_intensity": 0.45,
				"cirrus_coverage": 0.7,
				"atm_darkness": light_atm_darkness,
				"atm_thickness": 1.2,
				"atm_sun_intensity": 10.0,
			}
		SnowIntensity.HEAVY:
			return {
				"particle_amount_ratio": heavy_particle_ratio,
				"sky3d_wind_speed": heavy_wind_speed,
				"particle_wind_mult": heavy_particle_wind_mult,
				"sun_energy": heavy_sun_energy,
				"ambient_energy": heavy_ambient_energy,
				"volumetric_fog_enabled": true,
				"volumetric_fog_density": heavy_volumetric_fog_density,
				"volumetric_fog_emission": heavy_fog_emission,
				"fog_shader_density": heavy_fog_shader_density,
				"fog_shader_emission": Vector3(heavy_fog_shader_emission.r, heavy_fog_shader_emission.g, heavy_fog_shader_emission.b),
				"camera_far_ratio": heavy_camera_far_ratio,
				"cumulus_coverage": heavy_cumulus_coverage,
				"cumulus_intensity": 0.25,
				"cirrus_coverage": 0.9,
				"atm_darkness": heavy_atm_darkness,
				"atm_thickness": 2.0,
				"atm_sun_intensity": 4.0,
			}
		_:
			return _get_intensity_config(SnowIntensity.NONE)


func _ready() -> void:
	if not sky3d:
		sky3d = _find_sky3d()

	if sky3d:
		# Defer lookup - Sky3D sets properties during _initialize()
		await get_tree().process_frame
		_store_original_values()
		print("[SnowController] sky3d: ", sky3d)
		print("[SnowController] environment: ", _environment)


func _store_original_values() -> void:
	# Store original values from Sky3D
	if sky3d:
		if "wind_speed" in sky3d:
			_original_wind_speed = sky3d.wind_speed
		if "sun_energy" in sky3d:
			_original_sun_energy = sky3d.sun_energy
		if "ambient_energy" in sky3d:
			_original_ambient_energy = sky3d.ambient_energy

		# Get Environment from Sky3D (it extends WorldEnvironment)
		if "environment" in sky3d and sky3d.environment:
			_environment = sky3d.environment
			_original_volumetric_fog_enabled = _environment.volumetric_fog_enabled
			_original_volumetric_fog_density = _environment.volumetric_fog_density
			_original_volumetric_fog_emission = _environment.volumetric_fog_emission
			print("[SnowController] Stored fog originals - enabled: ", _original_volumetric_fog_enabled, ", density: ", _original_volumetric_fog_density, ", emission: ", _original_volumetric_fog_emission)

		# Get SkyDome from Sky3D for overcast effect
		if "sky" in sky3d and sky3d.sky:
			_sky_dome = sky3d.sky
			if "cumulus_coverage" in _sky_dome:
				_original_cumulus_coverage = _sky_dome.cumulus_coverage
			if "cumulus_intensity" in _sky_dome:
				_original_cumulus_intensity = _sky_dome.cumulus_intensity
			if "cirrus_coverage" in _sky_dome:
				_original_cirrus_coverage = _sky_dome.cirrus_coverage
			if "atm_darkness" in _sky_dome:
				_original_atm_darkness = _sky_dome.atm_darkness
			if "atm_thickness" in _sky_dome:
				_original_atm_thickness = _sky_dome.atm_thickness
			if "atm_sun_intensity" in _sky_dome:
				_original_atm_sun_intensity = _sky_dome.atm_sun_intensity
			print("[SnowController] Stored SkyDome originals - cumulus: ", _original_cumulus_coverage, ", atm_darkness: ", _original_atm_darkness)

	# Store original camera far distance
	_camera = get_viewport().get_camera_3d()
	if _camera:
		_original_camera_far = _camera.far
		normal_far_distance = _original_camera_far
		print("[SnowController] Stored camera far: ", _original_camera_far)

	# Apply baseline fog immediately (always-on atmospheric effect)
	_apply_baseline_fog()


func _apply_baseline_fog() -> void:
	## Apply baseline atmospheric fog on startup.
	if not baseline_fog_enabled:
		return

	if _environment:
		_environment.volumetric_fog_enabled = true
		_environment.volumetric_fog_density = baseline_fog_density
		_environment.volumetric_fog_emission = baseline_fog_emission
		_environment.volumetric_fog_albedo = Color(0.9, 0.9, 0.95)
		_environment.volumetric_fog_emission_energy = 1.0
		print("[SnowController] Applied baseline fog - density: ", baseline_fog_density, ", emission: ", baseline_fog_emission)


func _process(delta: float) -> void:
	_update_particle_position()
	_update_fog_position()
	_update_wind()

	if _transition_progress < 1.0:
		_transition_progress = minf(_transition_progress + delta / transition_duration, 1.0)
		_apply_transition()

		if _transition_progress >= 1.0:
			current_intensity = _target_intensity
			if current_intensity == SnowIntensity.NONE:
				_cleanup_particles()
				_cleanup_fog_volume()


func start_snow(intensity: SnowIntensity = SnowIntensity.LIGHT) -> void:
	print("[SnowController] start_snow called with intensity: ", intensity)
	print("[SnowController] environment: ", _environment)

	if intensity == SnowIntensity.NONE:
		stop_snow()
		return

	var previous := current_intensity
	_target_intensity = intensity
	_transition_progress = 0.0

	if not is_instance_valid(_snow_particles):
		_create_particles()

	if not is_instance_valid(_fog_mesh):
		_create_fog_volume()

	if previous == SnowIntensity.NONE:
		snow_started.emit(intensity)
	else:
		snow_intensity_changed.emit(previous, intensity)


func stop_snow() -> void:
	if current_intensity == SnowIntensity.NONE and _target_intensity == SnowIntensity.NONE:
		return

	_target_intensity = SnowIntensity.NONE
	_transition_progress = 0.0
	snow_stopped.emit()


func set_snow_immediate(intensity: SnowIntensity) -> void:
	var previous := current_intensity
	current_intensity = intensity
	_target_intensity = intensity
	_transition_progress = 1.0

	if intensity != SnowIntensity.NONE:
		if not is_instance_valid(_snow_particles):
			_create_particles()
		if not is_instance_valid(_fog_mesh):
			_create_fog_volume()
		_apply_intensity_config(intensity)
		if previous == SnowIntensity.NONE:
			snow_started.emit(intensity)
	else:
		_apply_intensity_config(SnowIntensity.NONE)
		_cleanup_particles()
		_cleanup_fog_volume()
		if previous != SnowIntensity.NONE:
			snow_stopped.emit()


func is_snowing() -> bool:
	return current_intensity != SnowIntensity.NONE or _target_intensity != SnowIntensity.NONE


func _find_sky3d() -> Node:
	var root := get_tree().current_scene
	if root:
		var nodes := root.find_children("*", "Sky3D", true, false)
		if nodes.size() > 0:
			return nodes[0]
	return null


func _create_particles() -> void:
	_snow_particles = SNOW_PARTICLES_SCENE.instantiate()
	add_child(_snow_particles)
	_snow_particles.emitting = true
	_camera = get_viewport().get_camera_3d()

	# Duplicate material so we can modify gravity for wind
	if _snow_particles.process_material is ParticleProcessMaterial:
		_particle_material = _snow_particles.process_material.duplicate()
		_snow_particles.process_material = _particle_material


func _cleanup_particles() -> void:
	if is_instance_valid(_snow_particles):
		_snow_particles.queue_free()
		_snow_particles = null
		_particle_material = null


func _create_fog_volume() -> void:
	# Create a fullscreen MeshInstance3D for screen-space post-process fog
	_fog_mesh = MeshInstance3D.new()

	# Create fullscreen quad mesh
	var quad := QuadMesh.new()
	quad.size = Vector2(2.0, 2.0)  # Fullscreen in NDC
	_fog_mesh.mesh = quad

	# Create ShaderMaterial with raymarched volumetric fog
	_fog_shader_material = ShaderMaterial.new()
	_fog_shader_material.shader = BLIZZARD_POST_PROCESS_SHADER

	# Set up shader parameters from exported variables
	_fog_shader_material.set_shader_parameter("noise_scale", fog_noise_scale)
	_fog_shader_material.set_shader_parameter("detail_scale", 0.03)  # Fine detail layer
	_fog_shader_material.set_shader_parameter("fog_density", 0.0)  # Start at 0, will be set by intensity
	_fog_shader_material.set_shader_parameter("wind_speed", fog_wind_speed)
	_fog_shader_material.set_shader_parameter("wind_direction", 0.0)  # Will be synced from Sky3D
	_fog_shader_material.set_shader_parameter("vertical_drift", fog_vertical_drift)
	_fog_shader_material.set_shader_parameter("wave_amplitude", fog_wave_amplitude)
	_fog_shader_material.set_shader_parameter("wave_frequency", fog_wave_frequency)
	_fog_shader_material.set_shader_parameter("fog_max_opacity", fog_max_opacity)
	_fog_shader_material.set_shader_parameter("fog_color", Vector3(fog_albedo.r, fog_albedo.g, fog_albedo.b))
	_fog_shader_material.set_shader_parameter("fog_emission", Vector3(fog_emission_color.r, fog_emission_color.g, fog_emission_color.b))
	_fog_shader_material.set_shader_parameter("max_distance", 150.0)
	_fog_shader_material.set_shader_parameter("ray_steps", 24)
	_fog_shader_material.set_shader_parameter("fog_height", 20.0)  # Ground-hugging fog
	_fog_shader_material.set_shader_parameter("fog_falloff", 0.04)  # Fades above ground level

	_fog_mesh.material_override = _fog_shader_material

	# Disable shadow casting and ensure it renders on top
	_fog_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Add to camera so it's always in view
	if _camera:
		_camera.add_child(_fog_mesh)
		# Position slightly in front of camera near plane
		_fog_mesh.position = Vector3(0, 0, -1.0)
	else:
		add_child(_fog_mesh)

	print("[SnowController] Created screen-space post-process fog mesh")


func _cleanup_fog_volume() -> void:
	if is_instance_valid(_fog_mesh):
		_fog_mesh.queue_free()
		_fog_mesh = null
		_fog_shader_material = null


func _update_particle_position() -> void:
	if not is_instance_valid(_snow_particles):
		return

	if not _camera:
		_camera = get_viewport().get_camera_3d()

	if _camera:
		var cam_pos := _camera.global_position

		# Guard against NaN/Inf camera position (prevents "!v.is_finite()" error spam)
		if not cam_pos.is_finite():
			return

		# Spawn particles above camera (camera-relative, not absolute Y)
		var spawn_y := cam_pos.y + spawn_height_offset

		# Offset upwind so particles drift toward camera
		var offset := Vector3.ZERO
		if sky3d and "wind_direction" in sky3d and "wind_speed" in sky3d:
			var wind_dir: float = sky3d.wind_direction
			var wind_speed: float = sky3d.wind_speed
			# Guard against bad wind values
			if is_finite(wind_dir) and is_finite(wind_speed):
				# Offset upwind (opposite of wind direction) so snow drifts into view
				offset.x = -sin(wind_dir) * wind_speed * 1.5
				offset.z = -cos(wind_dir) * wind_speed * 1.5

		var new_pos := Vector3(cam_pos.x + offset.x, spawn_y, cam_pos.z + offset.z)
		if new_pos.is_finite():
			_snow_particles.global_position = new_pos


func _update_fog_position() -> void:
	# Post-process fog is attached to camera, no position update needed
	# But ensure it's parented to the camera if not already
	if not is_instance_valid(_fog_mesh):
		return

	if not _camera:
		_camera = get_viewport().get_camera_3d()

	# Reparent to camera if needed (camera may have changed)
	if _camera and _fog_mesh.get_parent() != _camera:
		_fog_mesh.reparent(_camera)
		_fog_mesh.position = Vector3(0, 0, -1.0)


func _update_wind() -> void:
	if not sky3d:
		return
	if not is_snowing():
		return

	var wind_dir: float = 0.0
	if "wind_direction" in sky3d:
		wind_dir = sky3d.wind_direction

	var wind_speed: float = 0.0
	if "wind_speed" in sky3d:
		wind_speed = sky3d.wind_speed

	# Update snow particle gravity to match wind
	if _particle_material:
		var config: Dictionary = _get_intensity_config(_target_intensity if _transition_progress < 1.0 else current_intensity)
		var mult: float = config["particle_wind_mult"]

		var wind_x: float = sin(wind_dir) * wind_speed * mult
		var wind_z: float = cos(wind_dir) * wind_speed * mult

		_particle_material.gravity = Vector3(wind_x, -9.8, wind_z)

	# Sync fog shader wind direction and speed so fog drifts same way as snow
	if _fog_shader_material:
		_fog_shader_material.set_shader_parameter("wind_direction", wind_dir)

		# Smoothly interpolate fog wind speed to prevent hurricane effect during transitions
		# Fog moves slower than particles but should still be visible
		# Heavy blizzard wind ~25 m/s -> fog wind ~5-7 m/s for nice drift
		var target_fog_wind: float = wind_speed * 0.25
		# Faster lerp (0.08) so fog reaches target speed in reasonable time
		# At 60fps: 0.08 per frame reaches 95% of target in ~37 frames (~0.6 seconds)
		_smoothed_fog_wind_speed = lerpf(_smoothed_fog_wind_speed, target_fog_wind, 0.08)
		_fog_shader_material.set_shader_parameter("wind_speed", _smoothed_fog_wind_speed)

	# Sync light tint from Sky3D for sunrise/sunset color matching
	_update_fog_light_tint()


func _update_fog_light_tint() -> void:
	## Sync fog color tint with Sky3D's sun/ambient color for sunrise/sunset matching.
	if not _fog_shader_material:
		return
	if not sky3d:
		return

	# Try to get the sun color from Sky3D's DirectionalLight or SkyDome
	var light_color := Color(1.0, 1.0, 1.0)

	# Check for sun node in Sky3D
	if "sun" in sky3d and sky3d.sun:
		var sun_node: Node = sky3d.sun
		if sun_node is DirectionalLight3D:
			light_color = sun_node.light_color
			# Blend with white based on sun energy (low energy = more tinted)
			var energy: float = sun_node.light_energy
			var tint_amount: float = clamp(1.0 - energy * 0.5, 0.0, 1.0)
			_fog_shader_material.set_shader_parameter("light_tint_strength", tint_amount * 0.6)
	elif _sky_dome and "atm_day_tint" in _sky_dome:
		# Fallback to atmosphere tint
		light_color = _sky_dome.atm_day_tint

	_fog_shader_material.set_shader_parameter("light_tint", Vector3(light_color.r, light_color.g, light_color.b))


func _apply_transition() -> void:
	var from_config: Dictionary = _get_intensity_config(current_intensity)
	var to_config: Dictionary = _get_intensity_config(_target_intensity)
	var t: float = _transition_progress

	# Determine from/to values, using originals when transitioning from/to NONE
	# Note: For fog, we now use config values directly (NONE has baseline fog)
	var is_from_none := current_intensity == SnowIntensity.NONE
	var is_to_none := _target_intensity == SnowIntensity.NONE

	# Particles
	if is_instance_valid(_snow_particles):
		var from_ratio: float = from_config["particle_amount_ratio"]
		var to_ratio: float = to_config["particle_amount_ratio"]
		_snow_particles.amount_ratio = lerpf(from_ratio, to_ratio, t)

	# Sky3D properties (just lighting and wind)
	if sky3d:
		# Wind
		if "wind_speed" in sky3d:
			var from_wind: float = _original_wind_speed if is_from_none else from_config["sky3d_wind_speed"]
			var to_wind: float = _original_wind_speed if is_to_none else to_config["sky3d_wind_speed"]
			sky3d.wind_speed = lerpf(from_wind, to_wind, t)

		# Sun energy
		if "sun_energy" in sky3d:
			var from_sun: float = _original_sun_energy if is_from_none else from_config["sun_energy"]
			var to_sun: float = _original_sun_energy if is_to_none else to_config["sun_energy"]
			sky3d.sun_energy = lerpf(from_sun, to_sun, t)

		# Ambient energy
		if "ambient_energy" in sky3d:
			var from_ambient: float = _original_ambient_energy if is_from_none else from_config["ambient_energy"]
			var to_ambient: float = _original_ambient_energy if is_to_none else to_config["ambient_energy"]
			sky3d.ambient_energy = lerpf(from_ambient, to_ambient, t)

	# Volumetric fog (Godot native - transitions to baseline fog, not zero)
	if _environment:
		# Use config values directly - NONE config now has baseline fog values
		var from_fog_density: float = from_config["volumetric_fog_density"]
		var to_fog_density: float = to_config["volumetric_fog_density"]
		var target_fog_density: float = lerpf(from_fog_density, to_fog_density, t)

		var from_fog_emission: Color = from_config["volumetric_fog_emission"]
		var to_fog_emission: Color = to_config["volumetric_fog_emission"]
		var target_fog_emission: Color = from_fog_emission.lerp(to_fog_emission, t)

		# Enable/disable based on target config
		var should_enable: bool = to_config["volumetric_fog_enabled"]
		_environment.volumetric_fog_enabled = should_enable or target_fog_density > 0.001
		_environment.volumetric_fog_density = target_fog_density
		_environment.volumetric_fog_emission = target_fog_emission
		_environment.volumetric_fog_albedo = Color(0.9, 0.9, 0.95)
		_environment.volumetric_fog_emission_energy = 1.0

	# Post-process fog shader (screen-space raymarched effect)
	if _fog_shader_material:
		var from_density: float = from_config["fog_shader_density"]
		var to_density: float = to_config["fog_shader_density"]
		_fog_shader_material.set_shader_parameter("fog_density", lerpf(from_density, to_density, t))

		var from_emission: Vector3 = from_config["fog_shader_emission"]
		var to_emission: Vector3 = to_config["fog_shader_emission"]
		_fog_shader_material.set_shader_parameter("fog_emission", from_emission.lerp(to_emission, t))

	# Camera far plane reduction (use config values)
	if _camera:
		var from_far_ratio: float = from_config["camera_far_ratio"]
		var to_far_ratio: float = to_config["camera_far_ratio"]
		var target_ratio: float = lerpf(from_far_ratio, to_far_ratio, t)
		_camera.far = normal_far_distance * target_ratio

	# SkyDome overcast effect (cloud coverage and atmosphere darkening)
	if _sky_dome:
		# Cumulus coverage
		var from_cumulus: float = _original_cumulus_coverage if is_from_none else from_config["cumulus_coverage"]
		var to_cumulus: float = _original_cumulus_coverage if is_to_none else to_config["cumulus_coverage"]
		# -1 means use original
		if from_cumulus < 0.0:
			from_cumulus = _original_cumulus_coverage
		if to_cumulus < 0.0:
			to_cumulus = _original_cumulus_coverage
		if "cumulus_coverage" in _sky_dome:
			_sky_dome.cumulus_coverage = lerpf(from_cumulus, to_cumulus, t)

		# Cumulus intensity
		var from_cumulus_int: float = _original_cumulus_intensity if is_from_none else from_config["cumulus_intensity"]
		var to_cumulus_int: float = _original_cumulus_intensity if is_to_none else to_config["cumulus_intensity"]
		if from_cumulus_int < 0.0:
			from_cumulus_int = _original_cumulus_intensity
		if to_cumulus_int < 0.0:
			to_cumulus_int = _original_cumulus_intensity
		if "cumulus_intensity" in _sky_dome:
			_sky_dome.cumulus_intensity = lerpf(from_cumulus_int, to_cumulus_int, t)

		# Cirrus coverage
		var from_cirrus: float = _original_cirrus_coverage if is_from_none else from_config["cirrus_coverage"]
		var to_cirrus: float = _original_cirrus_coverage if is_to_none else to_config["cirrus_coverage"]
		if from_cirrus < 0.0:
			from_cirrus = _original_cirrus_coverage
		if to_cirrus < 0.0:
			to_cirrus = _original_cirrus_coverage
		if "cirrus_coverage" in _sky_dome:
			_sky_dome.cirrus_coverage = lerpf(from_cirrus, to_cirrus, t)

		# Atmosphere darkness
		var from_atm_dark: float = _original_atm_darkness if is_from_none else from_config["atm_darkness"]
		var to_atm_dark: float = _original_atm_darkness if is_to_none else to_config["atm_darkness"]
		if from_atm_dark < 0.0:
			from_atm_dark = _original_atm_darkness
		if to_atm_dark < 0.0:
			to_atm_dark = _original_atm_darkness
		if "atm_darkness" in _sky_dome:
			_sky_dome.atm_darkness = lerpf(from_atm_dark, to_atm_dark, t)

		# Atmosphere thickness
		var from_atm_thick: float = _original_atm_thickness if is_from_none else from_config["atm_thickness"]
		var to_atm_thick: float = _original_atm_thickness if is_to_none else to_config["atm_thickness"]
		if from_atm_thick < 0.0:
			from_atm_thick = _original_atm_thickness
		if to_atm_thick < 0.0:
			to_atm_thick = _original_atm_thickness
		if "atm_thickness" in _sky_dome:
			_sky_dome.atm_thickness = lerpf(from_atm_thick, to_atm_thick, t)

		# Atmosphere sun intensity
		var from_sun_int: float = _original_atm_sun_intensity if is_from_none else from_config["atm_sun_intensity"]
		var to_sun_int: float = _original_atm_sun_intensity if is_to_none else to_config["atm_sun_intensity"]
		if from_sun_int < 0.0:
			from_sun_int = _original_atm_sun_intensity
		if to_sun_int < 0.0:
			to_sun_int = _original_atm_sun_intensity
		if "atm_sun_intensity" in _sky_dome:
			_sky_dome.atm_sun_intensity = lerpf(from_sun_int, to_sun_int, t)


func _apply_intensity_config(intensity: SnowIntensity) -> void:
	var config: Dictionary = _get_intensity_config(intensity)
	var is_none := intensity == SnowIntensity.NONE

	if is_instance_valid(_snow_particles):
		_snow_particles.amount_ratio = config["particle_amount_ratio"]

	# Sky3D properties (lighting and wind restore to originals for NONE)
	if sky3d:
		if "wind_speed" in sky3d:
			sky3d.wind_speed = _original_wind_speed if is_none else config["sky3d_wind_speed"]
		if "sun_energy" in sky3d:
			sky3d.sun_energy = _original_sun_energy if is_none else config["sun_energy"]
		if "ambient_energy" in sky3d:
			sky3d.ambient_energy = _original_ambient_energy if is_none else config["ambient_energy"]

	# Volumetric fog (use config values - NONE has baseline fog)
	if _environment:
		_environment.volumetric_fog_enabled = config["volumetric_fog_enabled"]
		_environment.volumetric_fog_density = config["volumetric_fog_density"]
		_environment.volumetric_fog_emission = config["volumetric_fog_emission"]
		if config["volumetric_fog_enabled"]:
			_environment.volumetric_fog_albedo = Color(0.9, 0.9, 0.95)
			_environment.volumetric_fog_emission_energy = 1.0

	# Post-process fog shader (use config values)
	if _fog_shader_material:
		_fog_shader_material.set_shader_parameter("fog_density", config["fog_shader_density"])
		_fog_shader_material.set_shader_parameter("fog_emission", config["fog_shader_emission"])

	# Camera far plane (use config values)
	if _camera:
		_camera.far = normal_far_distance * config["camera_far_ratio"]

	# SkyDome overcast effect
	if _sky_dome:
		var cumulus_val: float = config["cumulus_coverage"]
		if "cumulus_coverage" in _sky_dome:
			_sky_dome.cumulus_coverage = _original_cumulus_coverage if (is_none or cumulus_val < 0.0) else cumulus_val

		var cumulus_int_val: float = config["cumulus_intensity"]
		if "cumulus_intensity" in _sky_dome:
			_sky_dome.cumulus_intensity = _original_cumulus_intensity if (is_none or cumulus_int_val < 0.0) else cumulus_int_val

		var cirrus_val: float = config["cirrus_coverage"]
		if "cirrus_coverage" in _sky_dome:
			_sky_dome.cirrus_coverage = _original_cirrus_coverage if (is_none or cirrus_val < 0.0) else cirrus_val

		var atm_dark_val: float = config["atm_darkness"]
		if "atm_darkness" in _sky_dome:
			_sky_dome.atm_darkness = _original_atm_darkness if (is_none or atm_dark_val < 0.0) else atm_dark_val

		var atm_thick_val: float = config["atm_thickness"]
		if "atm_thickness" in _sky_dome:
			_sky_dome.atm_thickness = _original_atm_thickness if (is_none or atm_thick_val < 0.0) else atm_thick_val

		var atm_sun_val: float = config["atm_sun_intensity"]
		if "atm_sun_intensity" in _sky_dome:
			_sky_dome.atm_sun_intensity = _original_atm_sun_intensity if (is_none or atm_sun_val < 0.0) else atm_sun_val
