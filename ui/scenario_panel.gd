class_name ScenarioPanel extends CanvasLayer
## Scenario introduction screen shown at game start (procedural mode only).
## Displays narrative text and provides buttons to begin game or view tutorial.

signal game_started
signal tutorial_requested

@onready var header_label: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/HeaderLabel
@onready var body_label: RichTextLabel = $CenterContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/BodyLabel
@onready var begin_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonContainer/BeginButton
@onready var tutorial_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonContainer/TutorialButton

const SCENARIO_HEADER := "Late Summer, 1846. King William Island"

const SCENARIO_TEXT := """Confident that the Northwest Passage lay south along this channel, I steered Terror into what has proved her frozen grave. She is now hopelessly beset, groaning under the relentless pressure of the pack ice. She cannot shelter us much longer; soon she will be lost entirely, and we must salvage what provisions, wood, and stores we are able before she is claimed by the deep.

In the night, as the gale reached its fullest fury, her hull gave way at last. The sound was as terrible as any I have heard in all my years at sea. In the chaos and blinding snow, the order to abandon ship scattered our company to the winds. When dawn broke and the storm abated, I found myself with scarcely half our number. The rest, I am told, fled north in the darkness and have taken refuge somewhere among the coastal highlands of the island's northern shore.

Our course is now clear, though it pains me to delay. Our only hope of deliverance lies in man-hauling one of our ship's boats across the interior of King William Island, that we might reach open water to the south before the full fury of winter descends upon us. There is no time to circumnavigate the island by sea. We must strike overland, make for Back's Fish River, and send word to bring relief to those men who remain. But such a journey is impossible with our company so diminished. We must first find our scattered officers and men; and bring them back into the fold, or we shall none of us survive what lies ahead.

I confess I know not what trials await us in that Great White Nothing. But we are Englishmen, and we shall meet them as such.

May Providence watch over us, and that all is well.

[right]— Captain Francis Crozier, HMS Terror[/right]"""


func _ready() -> void:
	layer = 50  # Above game UI, below loading screen

	# Connect buttons
	begin_button.pressed.connect(_on_begin_pressed)
	tutorial_button.pressed.connect(_on_tutorial_pressed)

	# Set text colors explicitly (theme may not cover Label/RichTextLabel)
	var text_color := Color(0.9, 0.9, 0.9, 1.0)
	header_label.add_theme_color_override("font_color", text_color)
	body_label.add_theme_color_override("default_color", text_color)

	# Set content
	header_label.text = SCENARIO_HEADER
	# RichTextLabel with bbcode_enabled needs clear() then append_text() or set text property
	body_label.clear()
	body_label.append_text(SCENARIO_TEXT)

	# Start hidden
	visible = false


func show_scenario() -> void:
	## Display the scenario screen.
	visible = true
	# Ensure buttons are focused for keyboard navigation
	begin_button.grab_focus()


func hide_scenario() -> void:
	## Hide the scenario screen.
	visible = false


func _on_begin_pressed() -> void:
	## Player clicked "Let's Begin" - start the game.
	hide_scenario()
	game_started.emit()


func _on_tutorial_pressed() -> void:
	## Player clicked "Tutorial" - show tutorial screen.
	tutorial_requested.emit()
