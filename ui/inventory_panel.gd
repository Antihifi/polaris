class_name InventoryPanel extends PanelContainer
## Reusable inventory panel that wraps CtrlInventoryGrid.
## Used for both container and unit inventories.
## Can be instantiated from inventory_panel.tscn or created programmatically.

signal panel_closed

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


func _ready() -> void:
	# Try to find scene nodes first, fallback to building programmatically
	_title_label = get_node_or_null("%TitleLabel")
	_close_button = get_node_or_null("%CloseButton")
	_grid_container = get_node_or_null("%GridContainer")

	if _title_label and _close_button and _grid_container:
		# Scene-based: connect and add grid to container
		_close_button.pressed.connect(_on_close_pressed)
		_title_label.text = title
		_setup_grid_control(_grid_container)
	else:
		# Programmatic fallback
		_build_ui()

	hide()


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


func _build_ui() -> void:
	## Build the panel UI programmatically (fallback for non-scene usage).

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	# Header with title and close button
	var header := HBoxContainer.new()
	vbox.add_child(header)

	_title_label = Label.new()
	_title_label.text = title
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(_title_label)

	_close_button = Button.new()
	_close_button.text = "X"
	_close_button.custom_minimum_size = Vector2(24, 24)
	_close_button.pressed.connect(_on_close_pressed)
	header.add_child(_close_button)

	# Separator
	var sep := HSeparator.new()
	vbox.add_child(sep)

	# Grid container
	_grid_container = MarginContainer.new()
	_grid_container.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	_grid_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	vbox.add_child(_grid_container)

	_setup_grid_control(_grid_container)


func show_inventory(inv: Inventory, display_title: String = "") -> void:
	## Display the given inventory.
	_inventory = inv
	_grid_ctrl.inventory = inv

	if display_title.length() > 0:
		title = display_title
	show()


func hide_panel() -> void:
	_inventory = null
	if _grid_ctrl:
		_grid_ctrl.inventory = null
	hide()
	panel_closed.emit()


func _on_close_pressed() -> void:
	hide_panel()


func get_displayed_inventory() -> Inventory:
	return _inventory
