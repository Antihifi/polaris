@tool
class_name CustomInventoryItem
extends CtrlInventoryItemBase
## Custom inventory item - copy of gloot's CtrlInventoryItem with inversion shader.

const _Utils = preload("res://addons/gloot/core/utils.gd")

## Padding around the icon (creates border effect)
const PADDING: int = 2

var _background: ColorRect
var _texture_rect: TextureRect
var _stack_size_label: Label
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

	# Black background (inset by PADDING to create border effect)
	_background = ColorRect.new()
	_background.color = Color.BLACK
	_background.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_texture_rect = TextureRect.new()
	_texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_texture_rect.stretch_mode = icon_stretch_mode

	# Apply inversion shader (PNG files are black, we need white)
	var shader := Shader.new()
	shader.code = "shader_type canvas_item;\nvoid fragment() {\n\tvec4 tex = texture(TEXTURE, UV);\n\tCOLOR = vec4(1.0 - tex.rgb, tex.a);\n}"
	var mat := ShaderMaterial.new()
	mat.shader = shader
	_texture_rect.material = mat

	_stack_size_label = Label.new()
	_stack_size_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stack_size_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_stack_size_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM

	add_child(_background)
	add_child(_texture_rect)
	add_child(_stack_size_label)

	resized.connect(_on_resized)
	_on_resized()
	_refresh()


func _on_resized() -> void:
	# Background is inset by PADDING on all sides
	_background.position = Vector2(PADDING, PADDING)
	_background.size = size - Vector2(PADDING * 2, PADDING * 2)
	_stack_size_label.size = size


func _on_item_changed() -> void:
	_disconnect_item_signals(_old_item)
	_old_item = item
	_connect_item_signals(item)
	_refresh()


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
