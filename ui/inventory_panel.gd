class_name InventoryPanel extends PanelContainer
## Reusable inventory panel that wraps CtrlInventoryGrid.
## Used for both container and unit inventories.
## Instantiate from inventory_panel.tscn.

signal panel_closed
signal item_action_requested(item: InventoryItem, action: String)

@export var title: String = "Inventory":
	set(value):
		title = value
		if _title_label:
			_title_label.text = value

@export var field_size: Vector2 = Vector2(48, 48)
## Custom scene for rendering inventory items. Must extend CtrlInventoryItemBase.
@export var custom_item_scene: PackedScene = null

var _inventory: Inventory = null
var _title_label: Label = null
var _grid_ctrl: CtrlInventoryGrid = null
var _close_button: Button = null
var _grid_container: Control = null
var _action_button: Button = null
var _action_item: InventoryItem = null
var _vbox: VBoxContainer = null
var _carve_enabled: bool = false
var _header: HBoxContainer = null
var _flourish_top: NinePatchRect = null

# Drag-to-detach support
var _dragger: PanelDragger = PanelDragger.new()
## Whether this panel has been dragged away from auto-follow position.
var is_detached: bool:
	get: return _dragger.is_detached


func _ready() -> void:
	_title_label = %TitleLabel
	_close_button = %CloseButton
	_grid_container = %GridContainer
	_vbox = _grid_container.get_parent() as VBoxContainer
	_header = _title_label.get_parent() as HBoxContainer

	_flourish_top = _vbox.get_node("FlourishTop") as NinePatchRect

	_close_button.pressed.connect(_on_close_pressed)
	_title_label.text = title

	_header.gui_input.connect(_on_header_drag_input)
	_flourish_top.mouse_filter = Control.MOUSE_FILTER_STOP
	_flourish_top.gui_input.connect(_on_header_drag_input)

	_setup_grid_control(_grid_container)

	_action_button = %ActionButton
	_action_button.pressed.connect(_on_action_button_pressed)

	# Shrink panel to fit grid content, don't stay at scene default width
	size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	custom_minimum_size = Vector2.ZERO
	reset_size()

	# Hide the root Control (hides both flourish and panel)
	visible = false
	get_parent().hide()


func _setup_grid_control(parent: Control) -> void:
	## Create and add the CtrlInventoryGrid to a parent container.
	_grid_ctrl = CtrlInventoryGrid.new()
	_grid_ctrl.field_dimensions = field_size
	_grid_ctrl.stretch_item_icons = true
	# Shrink to fit content, don't expand to fill
	_grid_ctrl.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	_grid_ctrl.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	# Don't let grid block mouse from reaching other controls
	_grid_ctrl.mouse_filter = Control.MOUSE_FILTER_PASS
	# Use custom item scene if provided
	if custom_item_scene:
		_grid_ctrl.custom_item_control_scene = custom_item_scene
	parent.add_child(_grid_ctrl)
	# Connect item click for placeable items
	_grid_ctrl.inventory_item_clicked.connect(_on_grid_item_clicked)
	# Re-fit panel whenever grid resizes (gloot defers rebuilds to _process)
	_grid_ctrl.resized.connect(reset_size)


func _process(_delta: float) -> void:
	if not visible:
		return
	var drag_data: Variant = get_viewport().gui_get_drag_data()
	if drag_data is InventoryItem:
		var item := drag_data as InventoryItem
		if item.get_inventory() != _inventory:
			# Another panel is dragging - lower this panel
			z_index = -10
			return
	z_index = 0  # Default: no drag or this panel is the source


func _on_header_drag_input(event: InputEvent) -> void:
	## Handle drag on header/flourish to detach panel from auto-follow.
	## Moves the parent Control (root) so flourish and panel move together.
	_dragger.handle_input(event, get_parent())


func reset_drag() -> void:
	## Re-attach panel to auto-follow mode.
	_dragger.reset()


func show_inventory(inv: Inventory, display_title: String = "") -> void:
	## Display the given inventory.
	_inventory = inv
	_grid_ctrl.inventory = inv
	_dragger.reset()

	if not display_title.is_empty():
		title = display_title
	_hide_action_button()
	visible = true
	get_parent().show()


func hide_panel() -> void:
	_inventory = null
	_dragger.reset()
	_hide_action_button()
	visible = false
	get_parent().hide()  # Hide root Control to hide flourish + panel
	if _grid_ctrl:
		# Defer inventory cleanup to avoid gloot crash during mouse_exited processing
		call_deferred("_deferred_clear_grid")
	panel_closed.emit()


func _deferred_clear_grid() -> void:
	## Clear grid inventory after frame completes. Skips if show_inventory() was called since.
	if _inventory == null and _grid_ctrl:
		_grid_ctrl.inventory = null


func _on_close_pressed() -> void:
	hide_panel()


func get_displayed_inventory() -> Inventory:
	return _inventory


# =========================
# Item action button
# =========================
func set_carve_enabled(enabled: bool) -> void:
	## Set whether the [CARVE] action button is enabled for remains items.
	_carve_enabled = enabled


func _on_grid_item_clicked(item: InventoryItem, _at_position: Vector2, _button_index: int) -> void:
	## Show action button when a placeable or carveable item is clicked.
	if not is_instance_valid(item):
		_hide_action_button()
		return
	if item.get_property("placeable", false):
		var item_name: String = item.get_property("name", "Item")
		_action_item = item
		_action_button.text = "PLACE %s" % item_name.to_upper()
		_action_button.disabled = false
		_action_button.visible = true
	elif item.get_property("category", "") == "remains":
		_action_item = item
		_action_button.text = "CARVE"
		_action_button.disabled = not _carve_enabled
		_action_button.visible = true
	else:
		_hide_action_button()


func _hide_action_button() -> void:
	_action_item = null
	if _action_button:
		_action_button.visible = false


func _on_action_button_pressed() -> void:
	if _action_item and is_instance_valid(_action_item):
		var category: String = _action_item.get_property("category", "")
		if category == "remains":
			item_action_requested.emit(_action_item, "carve")
		else:
			item_action_requested.emit(_action_item, "place")
	_hide_action_button()
