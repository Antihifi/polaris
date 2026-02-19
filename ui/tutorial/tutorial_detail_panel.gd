class_name TutorialDetailPanel extends PanelContainer
## Displays detailed tutorial info for a single category.
## Populated from a TutorialEntry resource. Built as a scene in the editor.

signal back_pressed

@onready var title_label: Label = %TitleLabel
@onready var screenshot_rect: TextureRect = %ScreenshotRect
@onready var body_label: RichTextLabel = %BodyLabel
@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(func() -> void: back_pressed.emit())
	visible = false


func show_entry(entry: TutorialEntry) -> void:
	## Populate the detail view from a resource and make visible.
	title_label.text = entry.title

	screenshot_rect.texture = entry.screenshot
	screenshot_rect.visible = entry.screenshot != null

	body_label.clear()
	body_label.append_text(entry.detailed_text)
	visible = true
	back_button.grab_focus()


func hide_entry() -> void:
	visible = false
