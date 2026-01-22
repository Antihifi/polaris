class_name ConstructionSitePanel extends Control
## UI panel for viewing and managing construction sites.
## Shows progress, materials, workers, and allows cancellation.

signal closed
signal site_cancelled(site: ConstructionSite)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var progress_bar: ProgressBar = $Panel/MarginContainer/VBoxContainer/ProgressBar
@onready var materials_label: Label = $Panel/MarginContainer/VBoxContainer/MaterialsLabel
@onready var workers_label: Label = $Panel/MarginContainer/VBoxContainer/WorkersLabel
@onready var cancel_button: Button = $Panel/MarginContainer/VBoxContainer/CancelButton

var _current_site: ConstructionSite = null
var _camera: Camera3D = null

## Height offset above site in world units.
@export var world_height_offset: float = 3.0
## Screen space offset to nudge panel position.
@export var screen_offset: Vector2 = Vector2(0, -20)


func _ready() -> void:
	cancel_button.pressed.connect(_on_cancel_pressed)
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_site and _camera:
		_update_panel_position()
		_update_display()


func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("ui_cancel"):
			hide_panel()
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseButton:
			var mouse := event as InputEventMouseButton
			if mouse.pressed and not _is_point_in_panel(mouse.position):
				hide_panel()


func _is_point_in_panel(point: Vector2) -> bool:
	## Check if a screen point is inside the panel bounds.
	if not panel:
		return false
	var panel_rect := Rect2(panel.global_position, panel.size)
	return panel_rect.has_point(point)


func show_for_site(site: ConstructionSite, camera: Camera3D = null) -> void:
	## Display the panel for a construction site.
	if not site or not is_instance_valid(site):
		return

	_current_site = site

	# Connect to site signals.
	if not site.progress_changed.is_connected(_on_progress_changed):
		site.progress_changed.connect(_on_progress_changed)
	if not site.construction_complete.is_connected(_on_construction_complete):
		site.construction_complete.connect(_on_construction_complete)
	if not site.construction_cancelled.is_connected(_on_construction_cancelled):
		site.construction_cancelled.connect(_on_construction_cancelled)

	if camera:
		_camera = camera
	else:
		_camera = get_viewport().get_camera_3d()

	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the panel.
	if _current_site and is_instance_valid(_current_site):
		if _current_site.progress_changed.is_connected(_on_progress_changed):
			_current_site.progress_changed.disconnect(_on_progress_changed)
		if _current_site.construction_complete.is_connected(_on_construction_complete):
			_current_site.construction_complete.disconnect(_on_construction_complete)
		if _current_site.construction_cancelled.is_connected(_on_construction_cancelled):
			_current_site.construction_cancelled.disconnect(_on_construction_cancelled)

	_current_site = null
	visible = false
	closed.emit()


func _update_panel_position() -> void:
	## Position panel near the site in screen space.
	if not _current_site or not _camera:
		return

	var world_pos: Vector3 = _current_site.global_position + Vector3(0, world_height_offset, 0)

	if not _camera.is_position_in_frustum(world_pos):
		visible = false
		return

	var screen_pos: Vector2 = _camera.unproject_position(world_pos)
	var panel_size: Vector2 = panel.size
	position = screen_pos - panel_size / 2.0 + screen_offset

	# Clamp to screen bounds.
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, 0, viewport_size.y - panel_size.y)


func _update_display() -> void:
	## Update the panel content.
	if not _current_site or not is_instance_valid(_current_site):
		hide_panel()
		return

	# Title.
	var recipe_name: String = "Construction Site"
	if _current_site.recipe:
		recipe_name = _current_site.recipe.display_name
	title_label.text = recipe_name

	# Progress.
	var progress: float = _current_site.get_progress_percent()
	progress_bar.value = progress

	# Materials.
	var materials_text: String = "Materials: "
	if _current_site.recipe:
		var parts: Array[String] = []
		for mat_id: String in _current_site.recipe.required_materials:
			var deposited: int = _current_site.materials_deposited.get(mat_id, 0)
			var required: int = _current_site.recipe.required_materials[mat_id]
			parts.append("%s: %d/%d" % [mat_id, deposited, required])
		materials_text += ", ".join(parts)
	else:
		materials_text += "N/A"
	materials_label.text = materials_text

	# Workers.
	var worker_count: int = _current_site.get_worker_count()
	var max_workers: int = _current_site.MAX_CONSTRUCTORS
	workers_label.text = "Workers: %d / %d" % [worker_count, max_workers]


func _on_cancel_pressed() -> void:
	## Handle cancel button pressed.
	if _current_site and is_instance_valid(_current_site):
		var site: ConstructionSite = _current_site
		hide_panel()
		site.cancel_construction()
		site_cancelled.emit(site)


func _on_progress_changed(_percent: float) -> void:
	## Handle progress update.
	_update_display()


func _on_construction_complete(_result_scene: PackedScene) -> void:
	## Handle construction completed.
	hide_panel()


func _on_construction_cancelled() -> void:
	## Handle construction cancelled (externally).
	hide_panel()
