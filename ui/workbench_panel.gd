class_name WorkbenchPanel extends Control
## UI panel for workbench interaction - allows initiating construction projects.
## Shows when right-clicking a workbench.
## Positions itself near the workbench in screen space.

signal closed
signal item_crafted(item_id: String, cost: int)
signal placement_started(recipe: BuildRecipe)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var craft_grid: GridContainer = $Panel/MarginContainer/VBoxContainer/CraftGrid
@onready var status_label: Label = $Panel/MarginContainer/VBoxContainer/StatusLabel

# Craft buttons
@onready var sled_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/SledButton
@onready var tent_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/TentButton
@onready var crate_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/CrateButton
@onready var barrel_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/BarrelButton
@onready var firewood_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/FirewoodButton
@onready var upgrade_button: Button = $Panel/MarginContainer/VBoxContainer/CraftGrid/UpgradeButton

var _current_workbench: Node = null
var _workbench_component: WorkbenchComponent = null
var _camera: Camera3D = null

## Height offset above workbench in world units
@export var world_height_offset: float = 2.0
## Screen space offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)

## Recipe ID mapping for buttons
const BUTTON_RECIPES: Dictionary = {
	"sled": &"sled",
	"tent_frame": &"tent_frame",
	"crate": &"crate",
	"barrel": &"barrel",
	"firewood": &"firewood_bundle",
	"upgrade": null  # Not yet implemented
}


func _ready() -> void:
	# Connect button signals
	sled_button.pressed.connect(_on_craft_pressed.bind("sled"))
	tent_button.pressed.connect(_on_craft_pressed.bind("tent_frame"))
	crate_button.pressed.connect(_on_craft_pressed.bind("crate"))
	barrel_button.pressed.connect(_on_craft_pressed.bind("barrel"))
	firewood_button.pressed.connect(_on_craft_pressed.bind("firewood"))
	upgrade_button.pressed.connect(_on_craft_pressed.bind("upgrade"))

	# Start hidden
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_workbench and _camera:
		_update_panel_position()


func _input(event: InputEvent) -> void:
	# Close panel on Escape or click outside
	if visible:
		if event.is_action_pressed("ui_cancel"):
			hide_panel()
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseButton:
			var mouse := event as InputEventMouseButton
			# Close on any click outside the panel
			if mouse.pressed and not _is_point_in_panel(mouse.position):
				hide_panel()


func _is_point_in_panel(point: Vector2) -> bool:
	## Check if a screen point is inside the panel bounds.
	if not panel:
		return false
	var panel_rect := Rect2(panel.global_position, panel.size)
	return panel_rect.has_point(point)


func show_for_workbench(workbench: Node, camera: Camera3D = null) -> void:
	## Display the workbench panel for the given workbench.
	if not workbench:
		return

	_current_workbench = workbench

	# Try to find WorkbenchComponent
	_workbench_component = _find_workbench_component(workbench)

	# Connect to material changes if component exists
	if _workbench_component and not _workbench_component.materials_changed.is_connected(_update_display):
		_workbench_component.materials_changed.connect(_update_display)
		_workbench_component.placement_started.connect(_on_component_placement_started)
		_workbench_component.placement_completed.connect(_on_component_placement_completed)
		_workbench_component.placement_cancelled.connect(_on_component_placement_cancelled)

	if camera:
		_camera = camera
	else:
		_camera = get_viewport().get_camera_3d()

	_update_display()
	_update_panel_position()
	visible = true


func hide_panel() -> void:
	## Hide the workbench panel.
	# Disconnect signals
	if _workbench_component:
		if _workbench_component.materials_changed.is_connected(_update_display):
			_workbench_component.materials_changed.disconnect(_update_display)
		if _workbench_component.placement_started.is_connected(_on_component_placement_started):
			_workbench_component.placement_started.disconnect(_on_component_placement_started)
		if _workbench_component.placement_completed.is_connected(_on_component_placement_completed):
			_workbench_component.placement_completed.disconnect(_on_component_placement_completed)
		if _workbench_component.placement_cancelled.is_connected(_on_component_placement_cancelled):
			_workbench_component.placement_cancelled.disconnect(_on_component_placement_cancelled)

	_current_workbench = null
	_workbench_component = null
	visible = false
	closed.emit()


func _update_panel_position() -> void:
	## Position panel near the workbench in screen space.
	if not _current_workbench or not _camera:
		return

	var world_pos: Vector3 = _current_workbench.global_position + Vector3(0, world_height_offset, 0)

	if not _camera.is_position_in_frustum(world_pos):
		visible = false
		return

	var screen_pos: Vector2 = _camera.unproject_position(world_pos)
	var panel_size: Vector2 = panel.size
	position = screen_pos - panel_size / 2.0 + screen_offset

	# Clamp to screen bounds
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, 0, viewport_size.y - panel_size.y)


func _update_display() -> void:
	## Update the panel content.
	if not _current_workbench:
		return

	title_label.text = "Workbench"

	# Get materials from WorkbenchComponent if available
	var wood_count: int = _get_available_wood()
	var nail_count: int = _get_available_nails()
	status_label.text = "Scrap Wood: %d  Nails: %d" % [wood_count, nail_count]

	_update_buttons()


func _update_buttons() -> void:
	## Enable/disable buttons based on available materials.
	for button_id: String in BUTTON_RECIPES:
		var recipe_id: Variant = BUTTON_RECIPES[button_id]
		var button: Button = _get_button_for_id(button_id)
		if not button:
			continue

		if recipe_id == null:
			# Not implemented
			button.disabled = true
			continue

		var recipe: BuildRecipe = BuildRecipes.get_recipe(recipe_id as StringName)
		if not recipe:
			button.disabled = true
			continue

		# Check if we have materials
		if _workbench_component:
			button.disabled = not _workbench_component.can_build(recipe)
		else:
			# Fallback: use local material check
			var materials: Dictionary = {
				"scrap_wood": _get_available_wood(),
				"nails": _get_available_nails()
			}
			button.disabled = not recipe.has_all_materials(materials)


func _get_button_for_id(button_id: String) -> Button:
	## Get the button node for a given ID.
	match button_id:
		"sled":
			return sled_button
		"tent_frame":
			return tent_button
		"crate":
			return crate_button
		"barrel":
			return barrel_button
		"firewood":
			return firewood_button
		"upgrade":
			return upgrade_button
	return null


func _get_available_wood() -> int:
	## Get total scrap wood available.
	if _workbench_component:
		return _workbench_component.get_stored_material_count("scrap_wood")
	# Fallback: return 0 if no component
	return 0


func _get_available_nails() -> int:
	## Get total nails available.
	if _workbench_component:
		return _workbench_component.get_stored_material_count("nails")
	# Fallback: return 0 if no component
	return 0


func _on_craft_pressed(button_id: String) -> void:
	## Handle craft button press - start placement mode.
	var recipe_id: Variant = BUTTON_RECIPES.get(button_id, null)
	if recipe_id == null:
		print("[WorkbenchPanel] Recipe not implemented: %s" % button_id)
		return

	var recipe: BuildRecipe = BuildRecipes.get_recipe(recipe_id as StringName)
	if not recipe:
		print("[WorkbenchPanel] Unknown recipe: %s" % recipe_id)
		return

	if _workbench_component:
		if not _workbench_component.can_build(recipe):
			print("[WorkbenchPanel] Not enough materials for %s" % recipe.display_name)
			return
		# Start placement mode through component
		_workbench_component.start_placement_mode(recipe)
		# Hide panel during placement
		hide_panel()
	else:
		# Fallback: emit signal for old behavior
		var cost: int = recipe.get_material_cost("scrap_wood")
		item_crafted.emit(button_id, cost)


func _on_component_placement_started(recipe: BuildRecipe) -> void:
	## Handle placement mode started.
	placement_started.emit(recipe)


func _on_component_placement_completed(_site: ConstructionSite) -> void:
	## Handle placement completed - show panel again.
	if _current_workbench:
		show_for_workbench(_current_workbench, _camera)


func _on_component_placement_cancelled() -> void:
	## Handle placement cancelled - show panel again.
	if _current_workbench:
		show_for_workbench(_current_workbench, _camera)


func _find_workbench_component(workbench: Node) -> WorkbenchComponent:
	## Find WorkbenchComponent child of workbench.
	for child in workbench.get_children():
		if child is WorkbenchComponent:
			return child as WorkbenchComponent
	return null
