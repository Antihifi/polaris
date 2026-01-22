class_name ProgressBar3D
extends Node3D
## Floating progress bar that billboards towards camera.

## Width of the progress bar in meters.
@export var width: float = 2.0
## Height of the progress bar in meters.
@export var height: float = 0.2
## Y offset above parent position.
@export var offset_y: float = 2.5
## Background color.
@export var background_color: Color = Color(0.2, 0.2, 0.2, 0.8)
## Fill color when progress is low.
@export var fill_color_low: Color = Color(0.8, 0.2, 0.2, 1.0)
## Fill color when progress is high.
@export var fill_color_high: Color = Color(0.2, 0.8, 0.2, 1.0)

var _background: MeshInstance3D
var _fill: MeshInstance3D
var _progress: float = 0.0
var _camera: Camera3D = null


func _ready() -> void:
	_create_meshes()
	# Find camera.
	await get_tree().process_frame
	_camera = get_viewport().get_camera_3d()


func _process(_delta: float) -> void:
	# Billboard towards camera.
	if _camera and is_instance_valid(_camera):
		var cam_pos: Vector3 = _camera.global_position
		var bar_pos: Vector3 = global_position
		# Look at camera but keep upright.
		var direction: Vector3 = (cam_pos - bar_pos).normalized()
		direction.y = 0.0
		if direction.length_squared() > 0.001:
			look_at(bar_pos - direction, Vector3.UP)


func set_progress(value: float) -> void:
	## Set progress from 0.0 to 1.0.
	_progress = clampf(value, 0.0, 1.0)
	_update_fill()


func get_progress() -> float:
	## Get current progress (0.0 to 1.0).
	return _progress


func _create_meshes() -> void:
	## Create the background and fill meshes.
	# Background mesh.
	_background = MeshInstance3D.new()
	var bg_mesh := QuadMesh.new()
	bg_mesh.size = Vector2(width, height)
	_background.mesh = bg_mesh

	var bg_material := StandardMaterial3D.new()
	bg_material.albedo_color = background_color
	bg_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	bg_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bg_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_background.material_override = bg_material

	_background.position = Vector3(0, offset_y, 0)
	add_child(_background)

	# Fill mesh.
	_fill = MeshInstance3D.new()
	var fill_mesh := QuadMesh.new()
	fill_mesh.size = Vector2(0.01, height * 0.8)  # Start nearly invisible.
	_fill.mesh = fill_mesh

	var fill_material := StandardMaterial3D.new()
	fill_material.albedo_color = fill_color_low
	fill_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	fill_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_fill.material_override = fill_material

	# Position fill slightly in front of background.
	_fill.position = Vector3(0, offset_y, 0.01)
	add_child(_fill)

	_update_fill()


func _update_fill() -> void:
	## Update fill bar width and color based on progress.
	if not _fill or not _fill.mesh:
		return

	var fill_mesh: QuadMesh = _fill.mesh as QuadMesh
	var fill_width: float = (width - 0.1) * _progress
	fill_mesh.size = Vector2(maxf(fill_width, 0.01), height * 0.8)

	# Offset fill to align left edge with background left edge.
	var offset_x: float = -(width - 0.1) / 2.0 + fill_width / 2.0
	_fill.position.x = offset_x

	# Lerp color from low to high based on progress.
	var fill_material: StandardMaterial3D = _fill.material_override as StandardMaterial3D
	if fill_material:
		fill_material.albedo_color = fill_color_low.lerp(fill_color_high, _progress)
