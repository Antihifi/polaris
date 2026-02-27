@tool
class_name CustomInventoryItem
extends CtrlInventoryItemBase
## Custom inventory item - copy of gloot's CtrlInventoryItem with inversion shader.

const _Utils = preload("res://addons/gloot/core/utils.gd")

## Padding around the icon (creates border effect)
const PADDING: int = 2

@onready var _background: ColorRect = %Background
@onready var _texture_rect: TextureRect = %IconRect
@onready var _stack_size_label: Label = %Label

var _old_item: InventoryItem = null


func _connect_item_signals(new_item: InventoryItem) -> void:
	if not is_instance_valid(new_item):
		return
	_Utils.safe_connect(new_item.property_changed, _on_item_property_changed)


func _disconnect_item_signals(old_item: InventoryItem) -> void:
	if not is_instance_valid(old_item):
		return
	_Utils.safe_disconnect(old_item.property_changed, _on_item_property_changed)


func _on_item_property_changed(_property: String) -> void:
	_refresh()


func _ready() -> void:
	item_changed.connect(_on_item_changed)
	icon_stretch_mode_changed.connect(_on_icon_stretch_mode_changed)

	_texture_rect.stretch_mode = icon_stretch_mode

	resized.connect(_on_resized)
	_on_resized()
	_refresh()

	# Update tooltip after frame to ensure parent relationship is established
	# (gloot sets item before adding us to tree, so signal misses first assignment)
	call_deferred("_update_tooltip")


func _on_resized() -> void:
	if not is_instance_valid(_background):
		return
	# Background is inset by PADDING on all sides
	_background.position = Vector2(PADDING, PADDING)
	_background.size = size - Vector2(PADDING * 2, PADDING * 2)
	_stack_size_label.size = size


func _on_item_changed() -> void:
	_disconnect_item_signals(_old_item)
	_old_item = item
	_connect_item_signals(item)
	_refresh()
	_update_tooltip()


func _on_icon_stretch_mode_changed() -> void:
	if is_instance_valid(_texture_rect):
		_texture_rect.stretch_mode = icon_stretch_mode


func _update_texture() -> void:
	if not is_instance_valid(_texture_rect):
		return

	if is_instance_valid(item):
		_texture_rect.texture = item.get_texture()
	else:
		_texture_rect.texture = null
		return

	# Texture is inset by PADDING to match the background
	var inset := Vector2(PADDING, PADDING)
	var inner_size := size - Vector2(PADDING * 2, PADDING * 2)

	if is_instance_valid(item) and GridConstraint.is_item_rotated(item):
		_texture_rect.size = Vector2(inner_size.y, inner_size.x)
		if GridConstraint.is_item_rotation_positive(item):
			_texture_rect.position = Vector2(_texture_rect.size.y + PADDING, PADDING)
			_texture_rect.rotation = PI / 2
		else:
			_texture_rect.position = Vector2(PADDING, _texture_rect.size.x + PADDING)
			_texture_rect.rotation = -PI / 2
	else:
		_texture_rect.size = inner_size
		_texture_rect.position = inset
		_texture_rect.rotation = 0


func _update_stack_size() -> void:
	if not is_instance_valid(_stack_size_label):
		return
	if not is_instance_valid(item):
		_stack_size_label.text = ""
		return
	var stack_size: int = item.get_stack_size()
	if stack_size <= 1:
		_stack_size_label.text = ""
	else:
		_stack_size_label.text = "%d" % stack_size
	_stack_size_label.size = size


func _refresh() -> void:
	_update_texture()
	_update_stack_size()


func _update_tooltip() -> void:
	## Build descriptive tooltip text from item properties.
	## Sets tooltip on parent (CtrlDraggableInventoryItem) since gloot sets
	## mouse_filter = IGNORE on this control, preventing direct tooltip display.
	var tooltip: String = ""

	if is_instance_valid(item):
		var item_name: String = item.get_property("name", "Unknown")
		var category: String = item.get_property("category", "misc")

		# Build description based on item type
		match category:
			"food":
				tooltip = _get_food_tooltip(item_name)
			"fuel":
				tooltip = _get_fuel_tooltip(item_name)
			"tool":
				tooltip = _get_tool_tooltip(item_name)
			"material":
				tooltip = _get_material_tooltip(item_name)
			_:
				tooltip = item_name

	# Set on self (for direct usage) and parent (for gloot draggable wrapper)
	tooltip_text = tooltip
	var parent: Control = get_parent() as Control
	if parent:
		parent.tooltip_text = tooltip


func _get_food_tooltip(item_name: String) -> String:
	## Return descriptive tooltip for food items.
	match item_name:
		"Hardtack":
			return "HARDTACK\nA dry, long-lasting biscuit.\nNot tasty, but it keeps."
		"Salt Pork":
			return "SALT PORK\nSalted and preserved pork.\nA staple of naval rations."
		"Pemmican":
			return "PEMMICAN\nDried meat mixed with fat.\nHighly nutritious and portable."
		"Tinned Meat":
			return "TINNED MEAT\nPreserved meat in a tin.\nConvenient but heavy."
		"Rum":
			return "RUM\nNaval rum ration.\nLifts spirits and warms\nthe body, if briefly."
		"Human Meat":
			return "HUMAN MEAT\nThe flesh of a fallen\ncomrade. A desperate act\nwith terrible consequences\nfor the mind."
		_:
			return item_name + "\nFood item."


func _get_fuel_tooltip(item_name: String) -> String:
	## Return descriptive tooltip for fuel items.
	match item_name:
		"Firewood":
			return "FIREWOOD\nBundles of dried wood.\nBurns quickly but provides\ngood heat for a fire."
		"Coal":
			return "COAL\nDense and long-burning.\nThe best fuel for keeping\na fire going through\nthe arctic night."
		_:
			return item_name + "\nFuel for fires."


func _get_tool_tooltip(item_name: String) -> String:
	## Return descriptive tooltip for tool items.
	match item_name:
		"Knife":
			return "KNIFE\nA versatile blade.\nUseful for hunting,\nbutchering, and crafting."
		"Hatchet":
			return "HATCHET\nA small axe.\nEssential for chopping\nwood and construction."
		_:
			return item_name + "\nA useful tool."


func _get_material_tooltip(item_name: String) -> String:
	## Return descriptive tooltip for material items.
	match item_name:
		"Scrap Wood":
			return "SCRAP WOOD\nSalvaged timber from\nthe ship. Used at a\nworkbench for crafting."
		_:
			return item_name + "\nCrafting material."
