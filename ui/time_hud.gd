extends Control
## HUD element displaying current time, date, temperature, and time scale.
## Always visible in the top-right corner.

@onready var time_label: Label = $Panel/MarginContainer/VBoxContainer/TimeLabel
@onready var date_label: Label = $Panel/MarginContainer/VBoxContainer/DateLabel
@onready var temp_label: Label = $Panel/MarginContainer/VBoxContainer/TempLabel
@onready var speed_label: Label = $Panel/MarginContainer/VBoxContainer/SpeedLabel

# Speed control buttons
@onready var pause_button: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/Pause"
@onready var speed_1x_button: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/1X"
@onready var speed_2x_button: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/2X"
@onready var speed_4x_button: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/4X"

# Screen scroll toggle
@onready var scroll_toggle: CheckButton = $"Panel/MarginContainer/VBoxContainer/CheckButton"

var _time_manager: Node = null
var _camera: Node = null


func _ready() -> void:
	# Get TimeManager autoload
	_time_manager = get_node_or_null("/root/TimeManager")
	if not _time_manager:
		print("[TimeHUD] WARNING: TimeManager autoload not found")
		return

	# Connect to time signals
	if _time_manager.has_signal("hour_passed"):
		_time_manager.hour_passed.connect(_on_hour_passed)
	if _time_manager.has_signal("time_scale_changed"):
		_time_manager.time_scale_changed.connect(_on_time_scale_changed)

	# Connect speed buttons
	pause_button.pressed.connect(_on_pause_pressed)
	speed_1x_button.pressed.connect(_on_speed_1x_pressed)
	speed_2x_button.pressed.connect(_on_speed_2x_pressed)
	speed_4x_button.pressed.connect(_on_speed_4x_pressed)

	# Find camera and connect scroll toggle
	_camera = get_viewport().get_camera_3d()
	if _camera and scroll_toggle:
		# Initialize toggle to current camera state
		scroll_toggle.button_pressed = _camera.edge_scroll_margin > 0.0
		scroll_toggle.toggled.connect(_on_scroll_toggled)

	# Initial update
	_update_display()
	_update_speed_buttons()


func _process(_delta: float) -> void:
	# Update time display every frame for smooth clock
	if _time_manager:
		_update_time_display()


func _on_hour_passed(_hour: int, _day: int) -> void:
	_update_display()


func _on_time_scale_changed(_scale: float) -> void:
	_update_speed_display()
	_update_speed_buttons()


func _update_display() -> void:
	_update_time_display()
	_update_date_display()
	_update_temp_display()
	_update_speed_display()


func _update_time_display() -> void:
	if not _time_manager or not time_label:
		return
	time_label.text = _time_manager.get_formatted_time()


func _update_date_display() -> void:
	if not _time_manager or not date_label:
		return
	date_label.text = _time_manager.get_formatted_date()


func _update_temp_display() -> void:
	if not _time_manager or not temp_label:
		return

	var temp: float = _time_manager.get_current_temperature()
	var temp_str: String = "%d°C" % int(temp)

	# Color based on temperature severity
	if temp <= -30:
		temp_label.add_theme_color_override("font_color", Color(0.4, 0.6, 1.0))  # Blue - deadly cold
	elif temp <= -15:
		temp_label.add_theme_color_override("font_color", Color(0.6, 0.8, 1.0))  # Light blue - very cold
	elif temp <= 0:
		temp_label.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))  # Pale blue - cold
	else:
		temp_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))  # White - mild

	temp_label.text = temp_str


func _update_speed_display() -> void:
	if not _time_manager or not speed_label:
		return
	speed_label.text = _time_manager.get_time_scale_label()

	# Color paused state
	if _time_manager.is_paused:
		speed_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))  # Red
	else:
		speed_label.remove_theme_color_override("font_color")


func _update_speed_buttons() -> void:
	## Update button toggle states to match current time scale.
	if not _time_manager:
		return

	var current_scale: float = _time_manager.time_scale

	# Set button_pressed without triggering signals (buttons are in a ButtonGroup)
	if _time_manager.is_paused:
		pause_button.button_pressed = true
	elif current_scale < 1.5:
		speed_1x_button.button_pressed = true
	elif current_scale < 3.0:
		speed_2x_button.button_pressed = true
	else:
		speed_4x_button.button_pressed = true


func _on_speed_1x_pressed() -> void:
	if _time_manager and _time_manager.has_method("set_time_scale"):
		_time_manager.set_time_scale(1.0)


func _on_speed_2x_pressed() -> void:
	if _time_manager and _time_manager.has_method("set_time_scale"):
		_time_manager.set_time_scale(2.0)


func _on_speed_4x_pressed() -> void:
	if _time_manager and _time_manager.has_method("set_time_scale"):
		_time_manager.set_time_scale(4.0)


func _on_pause_pressed() -> void:
	if _time_manager and _time_manager.has_method("pause"):
		_time_manager.pause()


func _on_scroll_toggled(enabled: bool) -> void:
	## Enable/disable edge scrolling on the camera.
	if _camera and "edge_scroll_margin" in _camera:
		# Store original margin when disabling, restore when enabling
		if enabled:
			_camera.edge_scroll_margin = 20.0  # Default value from rts_camera.gd
		else:
			_camera.edge_scroll_margin = 0.0


