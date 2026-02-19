class_name TutorialPanel extends CanvasLayer
## Tutorial overview with hoverable category buttons and clickable detail views.
## Categories are defined as TutorialEntry resources assigned in the Inspector.

signal back_requested

## Drag TutorialEntry .tres files here in the Inspector to populate the grid.
@export var entries: Array[TutorialEntry] = []

@onready var grid_panel: CenterContainer = $CenterContainer
@onready var grid_container: GridContainer = $CenterContainer/Panel/MarginContainer/VBoxContainer/GridContainer
@onready var back_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/BackButton
@onready var detail_panel: TutorialDetailPanel = $TutorialDetailPanel


func _ready() -> void:
	layer = 50
	back_button.pressed.connect(_on_back_pressed)
	detail_panel.back_pressed.connect(_on_detail_back)
	_create_category_buttons()
	visible = false


func _create_category_buttons() -> void:
	## Create a button for each tutorial entry with tooltip.
	for entry: TutorialEntry in entries:
		var button := Button.new()
		button.text = entry.title

		if not entry.implemented:
			button.text += " *"
			button.modulate = Color(0.7, 0.7, 0.7, 1.0)

		button.tooltip_text = entry.brief_tooltip
		button.custom_minimum_size = Vector2(180, 50)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_on_category_pressed.bind(entry))

		grid_container.add_child(button)


func show_tutorial() -> void:
	## Display the tutorial grid screen.
	visible = true
	grid_panel.visible = true
	detail_panel.hide_entry()
	back_button.grab_focus()


func hide_tutorial() -> void:
	## Hide the entire tutorial layer.
	visible = false


func _on_category_pressed(entry: TutorialEntry) -> void:
	## Open the detail view for a category.
	grid_panel.visible = false
	detail_panel.show_entry(entry)


func _on_detail_back() -> void:
	## Return from detail view to the category grid.
	detail_panel.hide_entry()
	grid_panel.visible = true
	back_button.grab_focus()


func _on_back_pressed() -> void:
	## Return to scenario screen.
	hide_tutorial()
	back_requested.emit()
