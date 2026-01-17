extends Node3D
## Main menu screen controller.
## Locks camera to editor preview position and handles menu button actions.

## Camera position/rotation to use (set in editor via RTScamera transform).
## These are captured before the RTS camera script overrides them.
@export var camera_position := Vector3(153.36246, 15.538218, -484.36505)
@export var camera_rotation := Vector3(0, 2.823, 0)  # radians

## Menu music settings
@export_category("Music")
@export var menu_music: AudioStream = preload("res://sounds/menu_theme.mp3")
@export var fade_in_duration: float = 2.0
@export var crossfade_duration: float = 4.0  # Fade out/in overlap at loop point (longer = more overlap)

@onready var start_btn: Button = $Menu/Panel/MarginContainer/CenterContainer/VBoxContainer/StartPremade
@onready var procedural_btn: Button = $Menu/Panel/MarginContainer/CenterContainer/VBoxContainer/StartProcedural
@onready var continue_btn: Button = $Menu/Panel/MarginContainer/CenterContainer/VBoxContainer/Continue
@onready var options_btn: Button = $Menu/Panel/MarginContainer/CenterContainer/VBoxContainer/Options
@onready var quit_btn: Button = $Menu/Panel/MarginContainer/CenterContainer/VBoxContainer/Quit
@onready var rts_camera: Camera3D = $RTScamera

# Debug menu instance for options
var _debug_menu: Node = null

# Dual audio players for crossfade looping
var _player_a: AudioStreamPlayer = null
var _player_b: AudioStreamPlayer = null
var _active_player: AudioStreamPlayer = null  # Which one is currently playing
var _track_length: float = 0.0
var _is_crossfading: bool = false


func _ready() -> void:
	_connect_buttons()
	_setup_debug_menu()
	_start_menu_music()
	# Defer camera lock to ensure it happens after camera's _ready completes
	call_deferred("_lock_camera")


func _lock_camera() -> void:
	## Disable all camera movement and lock to menu view position.
	if not rts_camera:
		push_error("[MenuScreen] RTScamera not found!")
		return

	# Disable all processing to stop camera script from responding to input
	rts_camera.set_process(false)
	rts_camera.set_process_unhandled_input(false)
	rts_camera.set_physics_process(false)

	# Force the camera to our desired position/rotation
	rts_camera.global_transform = Transform3D(
		Basis.from_euler(camera_rotation),
		camera_position
	)

	# Disable edge scrolling and bounds constraints
	if "edge_scroll_margin" in rts_camera:
		rts_camera.edge_scroll_margin = 0.0
	if "max_distance_from_units" in rts_camera:
		rts_camera.max_distance_from_units = 0.0

	print("[MenuScreen] Camera locked at position: ", rts_camera.global_position)


func _connect_buttons() -> void:
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
	if procedural_btn:
		procedural_btn.pressed.connect(_on_procedural_pressed)
	if continue_btn:
		continue_btn.pressed.connect(_on_continue_pressed)
		# Disable continue for now (no save system yet)
		continue_btn.disabled = true
	if options_btn:
		options_btn.pressed.connect(_on_options_pressed)
	if quit_btn:
		quit_btn.pressed.connect(_on_quit_pressed)


func _setup_debug_menu() -> void:
	## Create the debug menu for options access.
	var DebugMenu := preload("res://ui/debug_menu.gd")
	_debug_menu = Node.new()
	_debug_menu.set_script(DebugMenu)
	_debug_menu.name = "DebugMenu"
	add_child(_debug_menu)


func _on_start_pressed() -> void:
	## Load the premade main scene.
	_stop_menu_music()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_procedural_pressed() -> void:
	## Load the procedural generation scene.
	_stop_menu_music()
	get_tree().change_scene_to_file("res://scenes/procedural_game.tscn")


func _on_continue_pressed() -> void:
	## Load saved game (not implemented yet).
	pass


func _on_options_pressed() -> void:
	## Open the debug/options menu.
	if _debug_menu and _debug_menu.has_method("_open_menu"):
		_debug_menu._open_menu()


func _on_quit_pressed() -> void:
	## Quit to desktop.
	get_tree().quit()


# =========================
# Music
# =========================
func _start_menu_music() -> void:
	## Start the menu theme with fade-in using dual players for seamless looping.
	if not menu_music:
		return

	_track_length = menu_music.get_length()

	# Create two audio players for crossfade looping
	_player_a = AudioStreamPlayer.new()
	_player_a.stream = menu_music
	_player_a.bus = "Master"
	_player_a.volume_db = -80.0  # Start silent
	add_child(_player_a)

	_player_b = AudioStreamPlayer.new()
	_player_b.stream = menu_music
	_player_b.bus = "Master"
	_player_b.volume_db = -80.0
	add_child(_player_b)

	# Start player A with fade-in
	_active_player = _player_a
	_player_a.play()
	_fade_player(_player_a, -80.0, 0.0, fade_in_duration)
	_is_crossfading = false


func _process(_delta: float) -> void:
	## Monitor music playback for seamless loop with crossfade.
	if not _active_player or not is_instance_valid(_active_player):
		return
	if not _active_player.playing:
		return
	if _is_crossfading:
		return

	var playback_pos: float = _active_player.get_playback_position()
	var time_remaining: float = _track_length - playback_pos

	# Start crossfade when approaching end of track
	if time_remaining <= crossfade_duration and time_remaining > 0.0:
		_is_crossfading = true
		_crossfade_to_next()


func _crossfade_to_next() -> void:
	## Crossfade from active player to the other player.
	var outgoing: AudioStreamPlayer = _active_player
	var incoming: AudioStreamPlayer = _player_b if _active_player == _player_a else _player_a

	# Start incoming player from beginning, fading in
	incoming.play(0.0)
	_fade_player(incoming, -80.0, 0.0, crossfade_duration)

	# Fade out outgoing player
	_fade_player(outgoing, outgoing.volume_db, -80.0, crossfade_duration)

	# Switch active player
	_active_player = incoming

	# Reset crossfade flag after transition completes
	get_tree().create_timer(crossfade_duration + 0.5).timeout.connect(
		func():
			_is_crossfading = false
			# Stop the outgoing player to save resources
			if is_instance_valid(outgoing):
				outgoing.stop()
	)


func _fade_player(player: AudioStreamPlayer, from_db: float, to_db: float, duration: float) -> void:
	## Fade a player's volume over time.
	var tween := create_tween()
	player.volume_db = from_db
	tween.tween_property(player, "volume_db", to_db, duration)


func _stop_menu_music() -> void:
	## Stop menu music with fade-out.
	if _player_a and is_instance_valid(_player_a):
		_fade_player(_player_a, _player_a.volume_db, -80.0, fade_in_duration)
	if _player_b and is_instance_valid(_player_b):
		_fade_player(_player_b, _player_b.volume_db, -80.0, fade_in_duration)
