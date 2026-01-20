class_name TutorialPanel extends CanvasLayer
## Single-page tutorial overview with hoverable category buttons.
## Each category shows a tooltip with details about that game element.

signal back_requested

@onready var title_label: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var grid_container: GridContainer = $CenterContainer/Panel/MarginContainer/VBoxContainer/GridContainer
@onready var back_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/BackButton

## Tutorial categories with their status and tooltip descriptions
const TUTORIAL_CATEGORIES := [
	{
		"name": "Survival Stats",
		"icon": "",  # Could add icon path
		"implemented": true,
		"tooltip": "Five vital stats (0-100): Hunger, Warmth, Health, Morale, Energy.\nStats cascade - low energy increases hunger drain.\nAny stat reaching 0 means death."
	},
	{
		"name": "Characters",
		"icon": "",
		"implemented": true,
		"tooltip": "Captain: You control directly, provides morale aura.\nOfficers: Controllable units you command.\nMen: AI-controlled, handle survival autonomously."
	},
	{
		"name": "Controls",
		"icon": "",
		"implemented": true,
		"tooltip": "Left-click: Select unit\nCtrl+click or drag: Multi-select\nRight-click ground: Move\nRight-click object: Interact\nWASD/Arrows: Camera pan\nMouse wheel: Zoom"
	},
	{
		"name": "Time System",
		"icon": "",
		"implemented": true,
		"tooltip": "Survive 365+ days until rescue arrives.\nSeasons: Summer (mild) → Winter (deadly) → Spring (rescue)\nSpace: Pause | 1x/2x/4x: Speed controls"
	},
	{
		"name": "Temperature",
		"icon": "",
		"implemented": true,
		"tooltip": "Warmth drains in cold weather, faster at night.\nShelter reduces cold damage.\nFire provides warmth (+5/hr within 5m).\nBelow -40°C is deadly even with gear."
	},
	{
		"name": "Sleds",
		"icon": "",
		"implemented": true,
		"tooltip": "Right-click sled with unit selected to attach.\nLead puller navigates, sled follows.\nEssential for hauling supplies on expeditions."
	},
	{
		"name": "Inventory",
		"icon": "",
		"implemented": true,
		"tooltip": "Right-click containers to open inventory.\nDrag items between inventories.\nUnits have personal 3x3 inventory."
	},
	{
		"name": "Buildings",
		"icon": "",
		"implemented": false,
		"tooltip": "[Coming Soon]\nTents: Basic shelter from cold.\nFire Pits: Warmth and cooking.\nWorkshop: Craft sleds and tools."
	},
	{
		"name": "Expeditions",
		"icon": "",
		"implemented": false,
		"tooltip": "[Coming Soon]\nSend groups south to find rescue.\nRequires sled with supplies.\nFind Hudson's Bay Company outpost for salvation."
	},
	{
		"name": "Combat",
		"icon": "",
		"implemented": false,
		"tooltip": "[Coming Soon]\nWolves hunt the weak and alone.\nPolar bears are extremely dangerous.\nArmed units auto-attack threats."
	},
	{
		"name": "Natives",
		"icon": "",
		"implemented": false,
		"tooltip": "[Coming Soon]\nDiscover Inuit camp to trade.\nWestern goods → Superior cold gear.\nWestern goods → Food (seal, whale meat)."
	},
	{
		"name": "Morale Events",
		"icon": "",
		"implemented": false,
		"tooltip": "[Coming Soon]\nLow morale (<25%) triggers mental breaks.\nBerserk: Attacks others.\nWendigo: Cannibalism in starvation."
	}
]


func _ready() -> void:
	layer = 50  # Same layer as scenario panel

	# Connect back button
	back_button.pressed.connect(_on_back_pressed)

	# Populate grid with category buttons
	_create_category_buttons()

	# Start hidden
	visible = false


func _create_category_buttons() -> void:
	## Create a button for each tutorial category with tooltip.
	for category in TUTORIAL_CATEGORIES:
		var button := Button.new()
		button.text = category.name

		# Mark unimplemented features
		if not category.implemented:
			button.text += " *"
			button.modulate = Color(0.7, 0.7, 0.7, 1.0)  # Slightly dimmed

		# Set tooltip
		button.tooltip_text = category.tooltip

		# Sizing
		button.custom_minimum_size = Vector2(180, 50)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		grid_container.add_child(button)


func show_tutorial() -> void:
	## Display the tutorial screen.
	visible = true
	back_button.grab_focus()


func hide_tutorial() -> void:
	## Hide the tutorial screen.
	visible = false


func _on_back_pressed() -> void:
	## Return to scenario screen.
	hide_tutorial()
	back_requested.emit()
