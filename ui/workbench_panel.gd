class_name WorkbenchPanel extends Control
## UI panel for workbench interaction - allows initiating construction projects.
## Shows when right-clicking a workbench.
## Left column: build buttons. Right column: full material inventory.

signal closed
signal item_crafted(item_id: String, cost: int)
signal placement_started(recipe: BuildRecipe)

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var storage_list: VBoxContainer = $Panel/MarginContainer/VBoxContainer/Columns/StorageColumn/StorageList

# Craft buttons
@onready var sled_button: Button = $Panel/MarginContainer/VBoxContainer/Columns/BuildColumn/SledButton
@onready var tent_button: Button = $Panel/MarginContainer/VBoxContainer/Columns/BuildColumn/TentButton
@onready var crate_button: Button = $Panel/MarginContainer/VBoxContainer/Columns/BuildColumn/CrateButton
@onready var barrel_button: Button = $Panel/MarginContainer/VBoxContainer/Columns/BuildColumn/BarrelButton
@onready var firewood_button: Button = $Panel/MarginContainer/VBoxContainer/Columns/BuildColumn/FirewoodButton
@onready var upgrade_button: Button = $Panel/MarginContainer/VBoxContainer/Columns/BuildColumn/UpgradeButton

var _current_workbench: Node = null
var _workbench_component: WorkbenchComponent = null
var _camera: Camera3D = null
## Dynamically created labels for each stored material: material_id -> Label
var _storage_labels: Dictionary = {}

## Height offset above workbench in world units
@export var world_height_offset: float = 2.0
## Screen space offset to nudge panel position
@export var screen_offset: Vector2 = Vector2(0, -20)

## Recipe ID mapping for buttons
const BUTTON_RECIPES: Dictionary = {
	"sled": &"sled",
	"tent": &"tent",
	"crate": &"crate",
	"barrel": &"barrel",
	"firewood": &"firewood_bundle",
	"upgrade": null  # Not yet implemented
}

## Human-readable display names for material IDs
const MATERIAL_DISPLAY_NAMES: Dictionary = {
	"scrap_wood": "WOOD SCRAP",
	"nails": "NAILS",
	"scrap_sails": "SAIL SCRAP",
	"seal_oil": "SEAL OIL",
	"drift_wood": "DRIFT WOOD",
	"cloth": "CLOTH",
	"rope": "ROPE",
	"iron": "IRON",
}


func _ready() -> void:
	sled_button.pressed.connect(_on_craft_pressed.bind("sled"))
	tent_button.pressed.connect(_on_craft_pressed.bind("tent"))
	crate_button.pressed.connect(_on_craft_pressed.bind("crate"))
	barrel_button.pressed.connect(_on_craft_pressed.bind("barrel"))
	firewood_button.pressed.connect(_on_craft_pressed.bind("firewood"))
	upgrade_button.pressed.connect(_on_craft_pressed.bind("upgrade"))
	_setup_tooltips()
	visible = false


func _process(_delta: float) -> void:
	if visible and _current_workbench and _camera:
		_update_panel_position()


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
	if not panel:
		return false
	var panel_rect := Rect2(panel.global_position, panel.size)
	return panel_rect.has_point(point)


func show_for_workbench(workbench: Node, camera: Camera3D = null) -> void:
	## Display the workbench panel for the given workbench.
	if not workbench:
		return

	_current_workbench = workbench
	_workbench_component = _find_workbench_component(workbench)

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
	if not _current_workbench or not _camera:
		return

	var world_pos: Vector3 = _current_workbench.global_position + Vector3(0, world_height_offset, 0)

	if not _camera.is_position_in_frustum(world_pos):
		visible = false
		return

	var screen_pos: Vector2 = _camera.unproject_position(world_pos)
	var panel_size: Vector2 = panel.size
	position = screen_pos - panel_size / 2.0 + screen_offset

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position.x = clampf(position.x, 0, viewport_size.x - panel_size.x)
	position.y = clampf(position.y, 0, viewport_size.y - panel_size.y)


func _update_display() -> void:
	if not _current_workbench:
		return
	title_label.text = "Workbench"
	_update_buttons()
	_update_storage_list()


func _update_buttons() -> void:
	for button_id: String in BUTTON_RECIPES:
		var recipe_id: Variant = BUTTON_RECIPES[button_id]
		var button: Button = _get_button_for_id(button_id)
		if not button:
			continue
		if recipe_id == null:
			button.disabled = true
			continue
		var recipe: BuildRecipe = BuildRecipes.get_recipe(recipe_id as StringName)
		if not recipe:
			button.disabled = true
			continue
		if _workbench_component:
			button.disabled = not _workbench_component.can_build(recipe)
		else:
			button.disabled = true


func _get_button_for_id(button_id: String) -> Button:
	match button_id:
		"sled":
			return sled_button
		"tent":
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


func _update_storage_list() -> void:
	## Rebuild the storage list to show all materials in the workbench.
	if not _workbench_component:
		_clear_storage_labels()
		return

	var materials: Dictionary = _workbench_component.get_all_materials()

	# Remove labels for materials that no longer exist
	for mat_id: String in _storage_labels.keys():
		if mat_id not in materials:
			var label: Label = _storage_labels[mat_id]
			label.queue_free()
			_storage_labels.erase(mat_id)

	# Create or update labels for each material
	for mat_id: String in materials:
		var count: int = materials[mat_id] as int
		var display_name: String = MATERIAL_DISPLAY_NAMES.get(mat_id, mat_id.to_upper())

		if mat_id in _storage_labels:
			(_storage_labels[mat_id] as Label).text = "%s  %d" % [display_name, count]
		else:
			var label := Label.new()
			label.add_theme_font_size_override("font_size", 14)
			label.text = "%s  %d" % [display_name, count]
			storage_list.add_child(label)
			_storage_labels[mat_id] = label


func _clear_storage_labels() -> void:
	for label: Label in _storage_labels.values():
		label.queue_free()
	_storage_labels.clear()


func _setup_tooltips() -> void:
	for button_id: String in BUTTON_RECIPES:
		var button: Button = _get_button_for_id(button_id)
		if not button:
			continue
		var recipe_id: Variant = BUTTON_RECIPES[button_id]
		if recipe_id == null:
			button.tooltip_text = "Not yet implemented"
			continue
		var recipe: BuildRecipe = BuildRecipes.get_recipe(recipe_id as StringName)
		if not recipe:
			continue
		var lines: PackedStringArray = PackedStringArray()
		lines.append(recipe.display_name)
		if recipe.description:
			lines.append(recipe.description)
		lines.append("")
		lines.append("Required:")
		for mat_id: String in recipe.required_materials:
			var count: int = recipe.required_materials[mat_id] as int
			var mat_name: String = MATERIAL_DISPLAY_NAMES.get(mat_id, mat_id.to_upper())
			lines.append("  %d %s" % [count, mat_name])
		lines.append("Build time: %d day(s)" % recipe.construction_days)
		button.tooltip_text = "\n".join(lines)


func _on_craft_pressed(button_id: String) -> void:
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
		_workbench_component.start_placement_mode(recipe)
		hide_panel()
	else:
		var cost: int = recipe.get_material_cost("scrap_wood")
		item_crafted.emit(button_id, cost)


func _on_component_placement_started(recipe: BuildRecipe) -> void:
	placement_started.emit(recipe)


func _on_component_placement_completed(_site: ConstructionSite) -> void:
	if _current_workbench:
		show_for_workbench(_current_workbench, _camera)


func _on_component_placement_cancelled() -> void:
	if _current_workbench:
		show_for_workbench(_current_workbench, _camera)


func _find_workbench_component(workbench: Node) -> WorkbenchComponent:
	for child in workbench.get_children():
		if child is WorkbenchComponent:
			return child as WorkbenchComponent
	return null
