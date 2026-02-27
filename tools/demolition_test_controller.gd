extends Node
class_name DemolitionTestController

signal impact_occurred(intensity: float, duration: float)
## Realistic staged destruction controller for ship demolition testing.
##
## Simulates progressive structural failure with dependencies:
## - Shrouds must be destroyed before their mast can fall
## - Masts fail top-down, then collapse when bottom is compromised
## - Hull/deck fail from edges inward, then cascade
##
## Controls:
##   1: Rigging (cycles through groups, all-or-nothing)
##   2: Shroud (cycles through groups, all-or-nothing)
##   3: Mast (progressive, top-down, shroud dependency)
##   4: Hull (progressive, edges first)
##   5: Deck (progressive, edges first)
##   6: Fascia (all at once)
##   7: Misc externals (all at once)
##   Space: DESTROY EVERYTHING
##   R: Reset all

@export var ship_root: Node3D
@export var rigging_manager: RiggingCleanupManager
@export var auto_assign := true
@export var auto_fix_collision := true

@export_group("Impulse Settings")
@export var impulse_strength: float = 3.0
@export var impulse_randomness: float = 0.5
@export var torque_strength: float = 5.0
@export var upward_bias: float = 0.5

@export_group("Progressive Destruction")
@export var mast_destroy_percent: float = 0.5  # 50% per press
@export var hull_destroy_percent: float = 0.3  # 30% per press
@export var hull_cascade_threshold: float = 0.6  # 60% triggers full collapse
@export var mast_stability_threshold: float = 0.75  # 75% bottom damage = unstable

@export_group("Mast Shake Effect")
@export var shake_amplitude: float = 0.15  # Max displacement in meters
@export var shake_frequency: float = 12.0  # Oscillations per second
@export var shake_duration: float = 1.2  # Total shake time
@export var shake_damping: float = 4.0  # How quickly vibration dies down

@export_group("Sound Settings")
@export var ground_y: float = 0.0  # Y=0 in real game (frozen ocean), adjust for testing
@export var sound_max_camera_distance: float = 1000.0  # Only play sounds if camera is within this range

@export_group("Debris Cleanup")
@export var debris_cleanup_enabled: bool = true
@export var debris_min_volume: float = 1.0  # AABB volume threshold for cleanup
@export var debris_cleanup_hours_min: int = 6  # Min game-hours before fade-out
@export var debris_cleanup_hours_max: int = 8  # Max game-hours before fade-out

# Sound preloads
var _wood_crash_sound: AudioStream = preload("res://sounds/wood_crash.mp3")
var _ground_crash_sound: AudioStream = preload("res://sounds/crash_on_ground.mp3")
var _creak_sound: AudioStream = preload("res://sounds/ship_wood_creak.mp3")
var _low_rumble_sound: AudioStream = preload("res://sounds/low_rumble.mp3")
var _mid_rumble_sound: AudioStream = preload("res://sounds/mid_rumble_loop.mp3")
var _rigging_snap_sound: AudioStream = preload("res://sounds/rigging_snap.mp3")

# Ground impact detection (masts only)
var _mast_ground_impacts: Dictionary = {}  # mast_name -> bool (already impacted)
var _falling_mast_bodies: Array[RigidBody3D] = []  # Track unfrozen mast pieces

# Creaking system
var _creak_timer: float = 0.0
var _next_creak_interval: float = 30.0
var _creak_player: AudioStreamPlayer = null

# Sinking system
var _is_sinking: bool = false
var _sink_elapsed: float = 0.0
var _sink_delay: float = 0.0
var _sink_duration: float = 0.0
var _sink_target: float = 0.0
var _sink_roll_delta: float = 0.0  # Change in roll for THIS sink event
var _sink_pitch_delta: float = 0.0  # Change in pitch for THIS sink event
var _sink_start_y: float = 0.0  # Y position at start of this sink
var _sink_start_roll: float = 0.0  # Roll at start of this sink
var _sink_start_pitch: float = 0.0  # Pitch at start of this sink
var _low_rumble_player: AudioStreamPlayer = null
var _mid_rumble_player: AudioStreamPlayer = null

# Collision layers
const LAYER_GROUND := 1
const LAYER_DEBRIS := 2
const LAYER_SHIP_BODY := 4  # Ship capsule collider — separate so debris ignores it

# Shroud-mast dependency map
const MAST_SHROUDS: Dictionary = {
	"Mast_Foremast": ["Shroud_Foremast_Port", "Shroud_Foremast_Starboard"],
	"Mast_MainMast": ["Shroud_Mainmast_Port", "Shroud_MainMast_Starboard"],
	"Mast_MizzenMast": ["Shroud_MizzenMast_Port", "Shroud_MizzenMast_Starboard"],
	"Mast_Bowsprit": [],
}

# Rigging-mast dependency map (rigging must go before its mast)
const MAST_RIGGING: Dictionary = {
	"Mast_Foremast": ["Rigging_Foremast"],
	"Mast_MainMast": ["Rigging_MainMast"],
	"Mast_MizzenMast": ["Rigging_MizzenMast"],
	"Mast_Bowsprit": ["Rigging_Bowsprit", "Rigging_Bowsprit_Top"],
}

# Rigging/shroud to mast mapping for shake effect
const RIGGING_TO_MAST: Dictionary = {
	"Rigging_MizzenMast": "Mast_MizzenMast",
	"Rigging_Foremast": "Mast_Foremast",
	"Rigging_MainMast": "Mast_MainMast",
	"Rigging_Bowsprit": "Mast_Bowsprit",
	"Rigging_Bowsprit_Top": "Mast_Bowsprit",
}

const SHROUD_TO_MAST: Dictionary = {
	"Shroud_Foremast_Port": "Mast_Foremast",
	"Shroud_Foremast_Starboard": "Mast_Foremast",
	"Shroud_Mainmast_Port": "Mast_MainMast",
	"Shroud_MainMast_Starboard": "Mast_MainMast",
	"Shroud_MizzenMast_Port": "Mast_MizzenMast",
	"Shroud_MizzenMast_Starboard": "Mast_MizzenMast",
}

# Group lists
const MAST_GROUPS: Array[String] = ["Mast_MizzenMast", "Mast_MainMast", "Mast_Foremast", "Mast_Bowsprit"]
const RIGGING_GROUPS: Array[String] = [
	"Rigging_MizzenMast", "Rigging_Foremast", "Rigging_MainMast",
	"Rigging_Bowsprit", "Rigging_Bowsprit_Top"
]
const SHROUD_GROUPS: Array[String] = [
	"Shroud_Foremast_Port", "Shroud_Foremast_Starboard",
	"Shroud_Mainmast_Port", "Shroud_MainMast_Starboard",
	"Shroud_MizzenMast_Port", "Shroud_MizzenMast_Starboard"
]
const HULL_GROUPS: Array[String] = ["Hull_Starboard", "Hull_Port"]

# State tracking
var _initial_transforms: Dictionary = {}
var _destroyed_bodies: Dictionary = {}  # RigidBody3D -> bool
var _shroud_destroyed: Dictionary = {}  # group_name -> bool
var _rigging_destroyed: Dictionary = {}  # group_name -> bool

# Cycle indices
var _current_mast_index: int = 0
var _current_shroud_index: int = 0
var _current_rigging_index: int = 0

# Hull/deck tracking
var _hull_fragments: Array[RigidBody3D] = []
var _deck_fragments: Array[RigidBody3D] = []
var _ship_center: Vector3 = Vector3.ZERO

# Active shake tweens (for cleanup on reset)
var _active_shakes: Array[Tween] = []

# Debris auto-cleanup
var _debris_cleanup_queue: Array[Dictionary] = []  # [{body: RigidBody3D, expire: int}]
var _debris_check_timer: float = 0.0
const DEBRIS_CHECK_INTERVAL: float = 2.0  # Check every 2 seconds (performant)



func _ready() -> void:
	if auto_assign:
		if not ship_root:
			ship_root = get_parent().get_node_or_null("ErebusFragmentedV1")
		if not rigging_manager:
			rigging_manager = get_parent().get_node_or_null("RiggingCleanupManager")

	if not ship_root:
		push_warning("DemolitionTestController: ship_root not assigned!")
		return
	if not rigging_manager:
		push_warning("DemolitionTestController: rigging_manager not assigned!")

	if auto_fix_collision:
		_fix_collision_layers()

	_store_initial_transforms()
	_cache_hull_deck_fragments()
	_init_state()
	_print_controls()


func _init_state() -> void:
	_destroyed_bodies.clear()
	for group in SHROUD_GROUPS:
		_shroud_destroyed[group] = false
	for group in RIGGING_GROUPS:
		_rigging_destroyed[group] = false


func _print_controls() -> void:
	print("")
	print("=== Staged Demolition Controller ===")
	print("Keys:")
	print("  1: Rigging (cycles through groups)")
	print("  2: Shroud (cycles through groups)")
	print("  3: Mast (progressive, top-down)")
	print("  4: Hull (progressive, edges first)")
	print("  5: Deck (progressive, edges first)")
	print("  6: Fascia (all at once)")
	print("  7: Misc externals (all at once)")
	print("  S: Trigger sink event")
	print("  Space: DESTROY EVERYTHING")
	print("  R: Reset")
	print("====================================")


func _process(delta: float) -> void:
	_check_mast_ground_impacts()
	_update_creaking(delta)
	_update_sinking(delta)
	_check_debris_cleanup(delta)


# ============ SOUND SYSTEM ============

func _play_ship_sound(sound: AudioStream, volume_db: float = 0.0) -> void:
	## Play a sound if camera is within range of the ship.
	## Uses regular AudioStreamPlayer (non-positional) for reliable playback.
	var camera := get_viewport().get_camera_3d()
	if not camera:
		return
	var ref_pos: Vector3 = _ship_center if _ship_center != Vector3.ZERO else (ship_root.global_position if ship_root else Vector3.ZERO)
	if camera.global_position.distance_to(ref_pos) > sound_max_camera_distance:
		return
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()


func _check_mast_ground_impacts() -> void:
	## Check if any falling mast pieces have hit the ground.
	var bodies_to_remove: Array[RigidBody3D] = []
	for body in _falling_mast_bodies:
		if not is_instance_valid(body):
			bodies_to_remove.append(body)
			continue
		if body.global_position.y <= ground_y + 1.0:  # Within 1m of ground
			_trigger_ground_impact(body)
			bodies_to_remove.append(body)

	for body in bodies_to_remove:
		_falling_mast_bodies.erase(body)


func _trigger_ground_impact(body: RigidBody3D) -> void:
	## Trigger ground impact effects for a mast piece.
	var mast_name := _get_mast_name_for_body(body)
	if _mast_ground_impacts.get(mast_name, false):
		return  # Already triggered for this mast

	_mast_ground_impacts[mast_name] = true

	# Play ground crash sound at impact position
	_play_ship_sound(_ground_crash_sound, 0.0)

	# Large camera shake via signal
	impact_occurred.emit(0.5, 0.8)

	print("MAST GROUND IMPACT: ", mast_name)


func _get_mast_name_for_body(body: RigidBody3D) -> String:
	## Get the mast group name for a body by checking its parent hierarchy.
	var parent := body.get_parent()
	while parent and parent != ship_root:
		if parent.name in MAST_GROUPS:
			return parent.name
		parent = parent.get_parent()
	return "Unknown"


func _update_creaking(delta: float) -> void:
	## Update the continuous creaking system.
	_creak_timer += delta
	if _creak_timer >= _next_creak_interval:
		_creak_timer = 0.0
		_play_creak_segment()
		_recalculate_creak_interval()


func _recalculate_creak_interval() -> void:
	## Adjust creak interval based on destruction progress.
	var destruction := _get_destruction_progress()
	var ship_integrity := 1.0 - destruction

	if ship_integrity > 0.7:
		# Early: rare creaks (20-40s)
		_next_creak_interval = randf_range(20.0, 40.0)
	elif ship_integrity > 0.3:
		# Mid: more frequent as tension builds (5-15s)
		_next_creak_interval = randf_range(5.0, 15.0)
	else:
		# Late: ship mostly gone, creaking subsides (30-60s)
		_next_creak_interval = randf_range(30.0, 60.0)


func _play_creak_segment() -> void:
	## Play a random segment of the creaking sound.
	if not _creak_sound:
		return

	# Stop any existing creak
	if _creak_player and is_instance_valid(_creak_player):
		_creak_player.queue_free()

	_creak_player = AudioStreamPlayer.new()
	_creak_player.stream = _creak_sound
	_creak_player.volume_db = -12.0  # Quiet ambient sound
	add_child(_creak_player)

	# Pick random start position (sound is ~5 min long)
	var start_pos := randf_range(0.0, 280.0)
	_creak_player.play(start_pos)

	# Schedule stop after 5-10 seconds
	var duration := randf_range(5.0, 10.0)
	get_tree().create_timer(duration).timeout.connect(func():
		if _creak_player and is_instance_valid(_creak_player):
			# Fade out using tween
			var tween := create_tween()
			tween.tween_property(_creak_player, "volume_db", -40.0, 1.0)
			tween.tween_callback(_creak_player.queue_free)
	)


func _get_destruction_progress() -> float:
	## Calculate overall destruction progress (0.0 = pristine, 1.0 = fully destroyed).
	var total := _initial_transforms.size()
	if total == 0:
		return 0.0
	var destroyed := _destroyed_bodies.size()
	return float(destroyed) / float(total)


func _fix_collision_layers() -> void:
	var rigging_count := 0
	var debris_count := 0

	# Move ship's capsule collider to its own layer so debris ignores it
	for child in ship_root.get_children():
		if child is StaticBody3D:
			child.collision_layer = LAYER_SHIP_BODY
			child.collision_mask = LAYER_SHIP_BODY

	for group_node in ship_root.get_children():
		var is_rigging := _is_rigging_group(group_node)

		for child in group_node.get_children():
			if child is RigidBody3D:
				_setup_collision(child, is_rigging)
				if is_rigging:
					rigging_count += 1
				else:
					debris_count += 1
			for grandchild in child.get_children():
				if grandchild is RigidBody3D:
					_setup_collision(grandchild, is_rigging)
					if is_rigging:
						rigging_count += 1
					else:
						debris_count += 1

	print("Collision layers: ", rigging_count, " rigging, ", debris_count, " debris")


func _setup_collision(body: RigidBody3D, is_rigging: bool) -> void:
	if is_rigging:
		body.collision_layer = 0
		body.collision_mask = 0
		if not body.is_in_group("rigging"):
			body.add_to_group("rigging")
	else:
		body.collision_layer = LAYER_DEBRIS
		body.collision_mask = LAYER_GROUND
		if not body.is_in_group("debris"):
			body.add_to_group("debris")


func _is_rigging_group(node: Node) -> bool:
	var name_lower := node.name.to_lower()
	return name_lower.begins_with("rigging_") or name_lower.begins_with("shroud_")


func _store_initial_transforms() -> void:
	for group_node in ship_root.get_children():
		for child in group_node.get_children():
			if child is RigidBody3D:
				_initial_transforms[child] = child.global_transform
			for grandchild in child.get_children():
				if grandchild is RigidBody3D:
					_initial_transforms[grandchild] = grandchild.global_transform


func _cache_hull_deck_fragments() -> void:
	_hull_fragments.clear()
	_deck_fragments.clear()

	# Calculate ship center from all fragments
	var all_positions: Array[Vector3] = []

	for group_name in HULL_GROUPS:
		var group := ship_root.get_node_or_null(group_name)
		if group:
			for child in group.get_children():
				if child is RigidBody3D:
					_hull_fragments.append(child)
					all_positions.append(child.global_position)

	var deck := ship_root.get_node_or_null("MainDeck")
	if deck:
		for child in deck.get_children():
			if child is RigidBody3D:
				_deck_fragments.append(child)
				all_positions.append(child.global_position)
			for grandchild in child.get_children():
				if grandchild is RigidBody3D:
					_deck_fragments.append(grandchild)
					all_positions.append(grandchild.global_position)

	# Calculate center
	if all_positions.size() > 0:
		for pos in all_positions:
			_ship_center += pos
		_ship_center /= all_positions.size()


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return

	match event.keycode:
		KEY_1:
			_destroy_rigging_single()
		KEY_2:
			_destroy_shroud_single()
		KEY_3:
			_destroy_mast_progressive()
		KEY_4:
			_destroy_hull_progressive()
		KEY_5:
			_destroy_deck_progressive()
		KEY_6:
			_destroy_group_all("Fascia")
		KEY_7:
			_destroy_group_all("Misc_Externals")
		KEY_S:
			_trigger_sink_event()
		KEY_SPACE:
			destroy_all()
		KEY_R:
			reset_all()


# ============ RIGGING (all-or-nothing, cycles through groups) ============

func _destroy_rigging_single() -> void:
	# Find next undestroyed rigging group (cycles like shrouds)
	var start_index := _current_rigging_index
	for i in range(RIGGING_GROUPS.size()):
		var idx := (start_index + i) % RIGGING_GROUPS.size()
		var group_name: String = RIGGING_GROUPS[idx]

		if not _rigging_destroyed.get(group_name, false):
			var group := ship_root.get_node_or_null(group_name)
			if group:
				var count := _destroy_group_bodies(group, true)
				_rigging_destroyed[group_name] = true
				_current_rigging_index = (idx + 1) % RIGGING_GROUPS.size()
				print("Destroyed rigging: ", group_name, " (", count, " pieces)")
				_play_ship_sound(_rigging_snap_sound, -6.0)
				# Shake the mast that lost tension - sharp initial jolt
				var mast_name: String = RIGGING_TO_MAST.get(group_name, "")
				if mast_name:
					_shake_mast(mast_name, 1.5, 0.8)  # 1.5x amplitude, shorter duration
				return

	print("All rigging already destroyed")


# ============ SHROUDS (one group per press, all-or-nothing) ============

func _destroy_shroud_single() -> void:
	# Find next undestroyed shroud group
	var start_index := _current_shroud_index
	for i in range(SHROUD_GROUPS.size()):
		var idx := (start_index + i) % SHROUD_GROUPS.size()
		var group_name: String = SHROUD_GROUPS[idx]

		if not _shroud_destroyed.get(group_name, false):
			var group := ship_root.get_node_or_null(group_name)
			if group:
				var count := _destroy_group_bodies(group, true)
				_shroud_destroyed[group_name] = true
				_current_shroud_index = (idx + 1) % SHROUD_GROUPS.size()
				print("Destroyed shroud: ", group_name, " (", count, " pieces)")
				_play_ship_sound(_rigging_snap_sound, -3.0)
				# Shake the mast that lost tension - longer, more dramatic sway
				var mast_name: String = SHROUD_TO_MAST.get(group_name, "")
				if mast_name:
					_shake_mast(mast_name, 2.0, 1.8)  # 2x amplitude, longer duration
				return

	print("All shrouds already destroyed")


# ============ MASTS (progressive, top-down, with stability) ============

func _destroy_mast_progressive() -> void:
	# Find next mast with remaining fragments
	var start_index := _current_mast_index
	for i in range(MAST_GROUPS.size()):
		var idx := (start_index + i) % MAST_GROUPS.size()
		var mast_name: String = MAST_GROUPS[idx]

		var group := ship_root.get_node_or_null(mast_name)
		if not group:
			continue

		var remaining := _get_remaining_bodies(group)
		if remaining.is_empty():
			continue

		# Check rigging dependency (rigging must go before mast)
		if not _check_rigging_destroyed(mast_name):
			print("Cannot destroy ", mast_name, " - rigging still intact!")
			_current_mast_index = (idx + 1) % MAST_GROUPS.size()
			continue

		# Check shroud dependency
		if not _check_shrouds_destroyed(mast_name):
			print("Cannot destroy ", mast_name, " - shrouds still intact!")
			_current_mast_index = (idx + 1) % MAST_GROUPS.size()
			continue

		# Sort by Y (descending - top first)
		remaining.sort_custom(func(a: RigidBody3D, b: RigidBody3D) -> bool:
			return a.global_position.y > b.global_position.y
		)

		# Check stability - if bottom is compromised, destroy all
		if _check_mast_unstable(group, remaining):
			print("Mast ", mast_name, " COLLAPSED! (structural failure)")
			for body in remaining:
				_activate_body(body, false, true)  # is_mast=true for ground impact tracking
				_destroyed_bodies[body] = true
		else:
			# Destroy top portion
			var to_destroy := int(ceil(remaining.size() * mast_destroy_percent))
			to_destroy = max(1, to_destroy)
			print("Damaging ", mast_name, ": ", to_destroy, "/", remaining.size(), " fragments (top-down)")
			for j in range(to_destroy):
				_activate_body(remaining[j], false, true)  # is_mast=true for ground impact tracking
				_destroyed_bodies[remaining[j]] = true

		# ONE sound + shake per mast destruction event
		_play_ship_sound(_wood_crash_sound, -12.0)
		impact_occurred.emit(0.15, 0.4)

		_current_mast_index = (idx + 1) % MAST_GROUPS.size()
		return

	print("All masts fully destroyed")


func _check_rigging_destroyed(mast_name: String) -> bool:
	var rigging: Array = MAST_RIGGING.get(mast_name, [])
	if rigging.is_empty():
		return true

	for rigging_name in rigging:
		if not _rigging_destroyed.get(rigging_name, false):
			return false
	return true


func _check_shrouds_destroyed(mast_name: String) -> bool:
	var shrouds: Array = MAST_SHROUDS.get(mast_name, [])
	if shrouds.is_empty():
		return true  # No shrouds required (e.g., bowsprit)

	for shroud_name in shrouds:
		if not _shroud_destroyed.get(shroud_name, false):
			return false
	return true


func _check_mast_unstable(group: Node, remaining: Array[RigidBody3D]) -> bool:
	if remaining.size() < 2:
		return true  # Almost gone, collapse it

	# Get all bodies (destroyed + remaining) to calculate total
	var all_bodies := _get_all_bodies(group)
	if all_bodies.is_empty():
		return false

	# Sort all by Y to find bottom half
	all_bodies.sort_custom(func(a: RigidBody3D, b: RigidBody3D) -> bool:
		return a.global_position.y < b.global_position.y  # Ascending - bottom first
	)

	var bottom_half_count := int(ceil(all_bodies.size() / 2.0))
	var bottom_destroyed := 0

	for i in range(bottom_half_count):
		if _destroyed_bodies.get(all_bodies[i], false):
			bottom_destroyed += 1

	var damage_ratio := float(bottom_destroyed) / float(bottom_half_count)
	return damage_ratio >= mast_stability_threshold


# ============ HULL (progressive, edges first) ============

func _destroy_hull_progressive() -> void:
	var remaining: Array[RigidBody3D] = []
	for body in _hull_fragments:
		if not _destroyed_bodies.get(body, false):
			remaining.append(body)

	if remaining.is_empty():
		print("Hull fully destroyed")
		return

	var total := _hull_fragments.size()
	var destroyed_count := total - remaining.size()
	var destroyed_ratio := float(destroyed_count) / float(total) if total > 0 else 0.0

	# Check for cascade
	if destroyed_ratio >= hull_cascade_threshold:
		print("Hull CASCADE! Structural failure!")
		for body in remaining:
			_activate_body(body, false)
			_destroyed_bodies[body] = true
		return

	# Sort by distance from center (descending - edges first)
	remaining.sort_custom(func(a: RigidBody3D, b: RigidBody3D) -> bool:
		var dist_a := Vector2(a.global_position.x - _ship_center.x, a.global_position.z - _ship_center.z).length()
		var dist_b := Vector2(b.global_position.x - _ship_center.x, b.global_position.z - _ship_center.z).length()
		return dist_a > dist_b
	)

	var to_destroy := int(ceil(remaining.size() * hull_destroy_percent))
	to_destroy = max(1, to_destroy)
	print("Damaging hull: ", to_destroy, "/", remaining.size(), " fragments (edges first)")

	for i in range(to_destroy):
		_activate_body(remaining[i], false)
		_destroyed_bodies[remaining[i]] = true

	# ONE sound + shake per hull destruction event
	_play_ship_sound(_wood_crash_sound, -12.0)
	impact_occurred.emit(0.15, 0.4)


# ============ DECK (progressive, edges first) ============

func _destroy_deck_progressive() -> void:
	var remaining: Array[RigidBody3D] = []
	for body in _deck_fragments:
		if not _destroyed_bodies.get(body, false):
			remaining.append(body)

	if remaining.is_empty():
		print("Deck fully destroyed")
		return

	var total := _deck_fragments.size()
	var destroyed_count := total - remaining.size()
	var destroyed_ratio := float(destroyed_count) / float(total) if total > 0 else 0.0

	# Check for cascade
	if destroyed_ratio >= hull_cascade_threshold:
		print("Deck CASCADE! Structural failure!")
		for body in remaining:
			_activate_body(body, false)
			_destroyed_bodies[body] = true
		return

	# Sort by distance from center (descending - edges first)
	remaining.sort_custom(func(a: RigidBody3D, b: RigidBody3D) -> bool:
		var dist_a := Vector2(a.global_position.x - _ship_center.x, a.global_position.z - _ship_center.z).length()
		var dist_b := Vector2(b.global_position.x - _ship_center.x, b.global_position.z - _ship_center.z).length()
		return dist_a > dist_b
	)

	var to_destroy := int(ceil(remaining.size() * hull_destroy_percent))
	to_destroy = max(1, to_destroy)
	print("Damaging deck: ", to_destroy, "/", remaining.size(), " fragments (edges first)")

	for i in range(to_destroy):
		_activate_body(remaining[i], false)
		_destroyed_bodies[remaining[i]] = true

	# ONE sound + shake per deck destruction event
	_play_ship_sound(_wood_crash_sound, -12.0)
	impact_occurred.emit(0.15, 0.4)


# ============ MAST SHAKE EFFECT ============

func _shake_mast(mast_name: String, amp_mult: float = 1.0, dur_mult: float = 1.0) -> void:
	## Shake a mast to simulate sudden tension release from rigging/shrouds.
	## amp_mult: amplitude multiplier (1.0 = normal, 2.0 = double)
	## dur_mult: duration multiplier (1.0 = normal, 2.0 = twice as long)
	var mast_group := ship_root.get_node_or_null(mast_name)
	if not mast_group:
		return

	var bodies: Array[RigidBody3D] = []
	for child in mast_group.get_children():
		if child is RigidBody3D and child.freeze and not _destroyed_bodies.get(child, false):
			bodies.append(child)

	if bodies.is_empty():
		return

	# Sort by height to get base/top for amplitude scaling
	bodies.sort_custom(func(a: RigidBody3D, b: RigidBody3D) -> bool:
		return a.global_position.y < b.global_position.y
	)

	var base_y: float = bodies[0].global_position.y
	var mast_height: float = max(bodies[-1].global_position.y - base_y, 1.0)

	# Random shake direction for this mast
	var shake_dir := Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	if shake_dir.length() < 0.5:
		shake_dir = Vector3.RIGHT

	var duration := shake_duration * dur_mult
	var tween := create_tween().set_parallel(true)
	_active_shakes.append(tween)

	for body in bodies:
		var original_pos := body.position
		var height_ratio := (body.global_position.y - base_y) / mast_height
		var amp := shake_amplitude * amp_mult * height_ratio * height_ratio

		tween.tween_method(func(t: float) -> void:
			var time := t * duration
			var osc := sin(TAU * shake_frequency * time) * exp(-shake_damping * time)
			body.position = original_pos + shake_dir * amp * osc
		, 0.0, 1.0, duration)

	tween.finished.connect(func() -> void: _active_shakes.erase(tween))
	print("Shaking mast: ", mast_name, " (", bodies.size(), " pieces, amp=", amp_mult, "x, dur=", dur_mult, "x)")


# ============ UTILITY FUNCTIONS ============

func _destroy_group_all(prefix: String) -> void:
	var count := 0
	for child in ship_root.get_children():
		if child.name.begins_with(prefix):
			count += _destroy_group_bodies(child, false)
	if count > 0:
		print("Destroyed ", prefix, ": ", count, " pieces")
	else:
		print("No pieces found for '", prefix, "'")


func _destroy_group_bodies(group: Node, is_rigging: bool) -> int:
	var count := 0
	for child in group.get_children():
		if child is RigidBody3D:
			if not _destroyed_bodies.get(child, false):
				_activate_body(child, is_rigging)
				_destroyed_bodies[child] = true
				count += 1
		for grandchild in child.get_children():
			if grandchild is RigidBody3D:
				if not _destroyed_bodies.get(grandchild, false):
					_activate_body(grandchild, is_rigging)
					_destroyed_bodies[grandchild] = true
					count += 1
	return count


func _get_remaining_bodies(group: Node) -> Array[RigidBody3D]:
	var result: Array[RigidBody3D] = []
	for child in group.get_children():
		if child is RigidBody3D and not _destroyed_bodies.get(child, false):
			result.append(child)
		for grandchild in child.get_children():
			if grandchild is RigidBody3D and not _destroyed_bodies.get(grandchild, false):
				result.append(grandchild)
	return result


func _get_all_bodies(group: Node) -> Array[RigidBody3D]:
	var result: Array[RigidBody3D] = []
	for child in group.get_children():
		if child is RigidBody3D:
			result.append(child)
		for grandchild in child.get_children():
			if grandchild is RigidBody3D:
				result.append(grandchild)
	return result


func _activate_body(body: RigidBody3D, is_rigging: bool, is_mast: bool = false) -> void:
	body.freeze = false
	_register_debris_for_cleanup(body)

	if is_rigging:
		var gentle_push := Vector3(
			randf_range(-0.3, 0.3),
			randf_range(0.0, 0.2),
			randf_range(-0.3, 0.3)
		) * body.mass * 0.5
		body.apply_central_impulse(gentle_push)
		body.angular_velocity = Vector3(
			randf_range(-0.5, 0.5),
			randf_range(-0.2, 0.2),
			randf_range(-0.5, 0.5)
		)
		if rigging_manager:
			rigging_manager.activate_piece(body)
	else:
		var impulse := _generate_impulse(body)
		var torque := _generate_torque(body)
		body.apply_central_impulse(impulse)
		body.apply_torque_impulse(torque)
		var spin_strength := torque_strength * 2.0
		body.angular_velocity = Vector3(
			randf_range(-spin_strength, spin_strength),
			randf_range(-spin_strength, spin_strength) * 0.5,
			randf_range(-spin_strength, spin_strength)
		)

		# Track mast pieces for ground impact detection (sound/shake handled by caller)
		if is_mast:
			_falling_mast_bodies.append(body)


func _generate_impulse(body: RigidBody3D) -> Vector3:
	var rng := randf_range(1.0 - impulse_randomness, 1.0 + impulse_randomness)
	var angle := randf() * TAU
	var lateral := Vector3(cos(angle), 0.0, sin(angle))
	var vertical := randf_range(-0.2, upward_bias)
	var direction := (lateral + Vector3.UP * vertical).normalized()
	return direction * impulse_strength * rng * body.mass


func _generate_torque(body: RigidBody3D) -> Vector3:
	var random_axis := Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-0.5, 0.5),
		randf_range(-1.0, 1.0)
	).normalized()
	return random_axis * torque_strength * body.mass * 2.0


# ============ DEBRIS CLEANUP ============

func _register_debris_for_cleanup(body: RigidBody3D) -> void:
	if not debris_cleanup_enabled:
		return
	for child in body.get_children():
		if child is MeshInstance3D:
			var aabb: AABB = child.get_aabb()
			var vol: float = aabb.size.x * aabb.size.y * aabb.size.z
			if vol >= debris_min_volume:
				var tm: Node = get_node_or_null("/root/TimeManager")
				var total_h: int = 0
				if tm:
					total_h = tm.current_day * 24 + tm.current_hour
				var delay: int = randi_range(debris_cleanup_hours_min, debris_cleanup_hours_max)
				_debris_cleanup_queue.append({"id": body.get_instance_id(), "expire": total_h + delay})
			break  # Only check first mesh child


func _check_debris_cleanup(delta: float) -> void:
	if not debris_cleanup_enabled or _debris_cleanup_queue.is_empty():
		return
	_debris_check_timer += delta
	if _debris_check_timer < DEBRIS_CHECK_INTERVAL:
		return
	_debris_check_timer = 0.0

	var tm: Node = get_node_or_null("/root/TimeManager")
	if not tm:
		return
	var now: int = tm.current_day * 24 + tm.current_hour

	var i: int = _debris_cleanup_queue.size() - 1
	while i >= 0:
		var entry: Dictionary = _debris_cleanup_queue[i]
		var body_id: int = entry.id
		var body: RigidBody3D = instance_from_id(body_id) as RigidBody3D
		if body == null:
			_debris_cleanup_queue.remove_at(i)
		elif now >= entry.expire:
			_debris_cleanup_queue.remove_at(i)
			var tween: Tween = body.create_tween()
			tween.tween_property(body, "scale", Vector3.ZERO, 3.0)
			tween.tween_callback(body.queue_free)
		i -= 1


func destroy_all() -> void:
	if not ship_root:
		return

	print("=== DESTROYING EVERYTHING ===")

	for node in get_tree().get_nodes_in_group("rigging"):
		if node is RigidBody3D and not _destroyed_bodies.get(node, false):
			_activate_body(node, true)
			_destroyed_bodies[node] = true

	for node in get_tree().get_nodes_in_group("debris"):
		if node is RigidBody3D and not _destroyed_bodies.get(node, false):
			_activate_body(node, false)
			_destroyed_bodies[node] = true

	for group in SHROUD_GROUPS:
		_shroud_destroyed[group] = true
	for group in RIGGING_GROUPS:
		_rigging_destroyed[group] = true


func reset_all() -> void:
	if not ship_root:
		return

	print("=== RESETTING ALL ===")

	# Kill any active shake tweens
	for tween in _active_shakes:
		if tween and tween.is_valid():
			tween.kill()
	_active_shakes.clear()

	# Reset sound state
	_falling_mast_bodies.clear()
	_mast_ground_impacts.clear()
	_debris_cleanup_queue.clear()
	_debris_check_timer = 0.0
	_creak_timer = 0.0
	_next_creak_interval = randf_range(20.0, 40.0)
	if _creak_player and is_instance_valid(_creak_player):
		_creak_player.queue_free()
		_creak_player = null

	for node in get_tree().get_nodes_in_group("rigging"):
		if node is RigidBody3D:
			node.freeze = true
			node.linear_velocity = Vector3.ZERO
			node.angular_velocity = Vector3.ZERO
			if node in _initial_transforms:
				node.global_transform = _initial_transforms[node]

	for node in get_tree().get_nodes_in_group("debris"):
		if node is RigidBody3D:
			node.freeze = true
			node.linear_velocity = Vector3.ZERO
			node.angular_velocity = Vector3.ZERO
			if node in _initial_transforms:
				node.global_transform = _initial_transforms[node]

	_init_state()
	_current_mast_index = 0
	_current_shroud_index = 0
	_current_rigging_index = 0
	print("Reset complete")


func trigger_destruction(group_prefix: String) -> void:
	_destroy_group_all(group_prefix)


# ============ SINKING SYSTEM ============

func _trigger_sink_event() -> void:
	## Trigger a ship sinking event with rumble sounds and gradual descent.
	## Each sink is INCREMENTAL - Y continues dropping, rotation accumulates.
	if _is_sinking:
		print("Sink already in progress")
		return

	if not ship_root:
		print("No ship_root assigned")
		return

	_is_sinking = true
	_sink_elapsed = 0.0
	_sink_delay = randf_range(5.0, 7.0)
	_sink_duration = randf_range(8.0, 15.0)
	_sink_target = randf_range(0.5, 1.5)

	# Reduced severity: ±7.5° roll, ±3.75° pitch (half of original)
	_sink_roll_delta = deg_to_rad(randf_range(-7.5, 7.5))
	_sink_pitch_delta = deg_to_rad(randf_range(-3.75, 3.75))

	# Store CURRENT state as starting point (enables incremental sinking)
	_sink_start_y = ship_root.global_position.y
	_sink_start_roll = ship_root.rotation.z
	_sink_start_pitch = ship_root.rotation.x

	# Start low rumble immediately
	_low_rumble_player = AudioStreamPlayer.new()
	_low_rumble_player.stream = _low_rumble_sound
	_low_rumble_player.volume_db = -6.0
	add_child(_low_rumble_player)
	_low_rumble_player.play()

	print("=== SINK EVENT STARTED ===")
	print("  Delay: %.1fs, Duration: %.1fs" % [_sink_delay, _sink_duration])
	print("  Target sink: %.2fm, Roll delta: %.1f°, Pitch delta: %.1f°" % [_sink_target, rad_to_deg(_sink_roll_delta), rad_to_deg(_sink_pitch_delta)])


func _update_sinking(delta: float) -> void:
	## Process sinking animation each frame.
	## Applies incremental changes from starting position/rotation.
	if not _is_sinking:
		return

	_sink_elapsed += delta

	# Phase 1: Delay (rumble only, no movement)
	if _sink_elapsed < _sink_delay:
		return

	var sink_time := _sink_elapsed - _sink_delay
	var actual_duration := _sink_duration - _sink_delay
	var progress := clampf(sink_time / actual_duration, 0.0, 1.0)

	# Start mid rumble loop when actual sinking begins
	if sink_time < delta * 2 and not _mid_rumble_player:
		_mid_rumble_player = AudioStreamPlayer.new()
		_mid_rumble_player.stream = _mid_rumble_sound
		_mid_rumble_player.volume_db = -3.0
		add_child(_mid_rumble_player)
		_mid_rumble_player.play()

		# Explode some hull pieces outward
		_explode_hull_pieces(randi_range(2, 6))

	# Apply sink transform with easing
	var eased := ease(progress, 0.3)  # Ease-out for natural feel

	var current_sink := _sink_target * eased
	var current_roll_delta := _sink_roll_delta * eased
	var current_pitch_delta := _sink_pitch_delta * eased

	# Add vibration (decreases as sink settles)
	var vibration_strength := 0.05 * (1.0 - progress)  # Reduced vibration
	var vibration_y := randf_range(-vibration_strength, vibration_strength)

	# Apply INCREMENTAL changes from starting position
	ship_root.global_position.y = _sink_start_y - current_sink + vibration_y
	ship_root.rotation.z = _sink_start_roll + current_roll_delta
	ship_root.rotation.x = _sink_start_pitch + current_pitch_delta

	# End sink event
	if progress >= 1.0:
		_end_sink_event()


func _end_sink_event() -> void:
	## Clean up after sink event completes.
	## Ship retains new position/rotation for next incremental sink.
	_is_sinking = false

	# Fade out rumbles
	if _low_rumble_player and is_instance_valid(_low_rumble_player):
		var tween := create_tween()
		tween.tween_property(_low_rumble_player, "volume_db", -40.0, 3.0)
		tween.tween_callback(_low_rumble_player.queue_free)
		_low_rumble_player = null

	if _mid_rumble_player and is_instance_valid(_mid_rumble_player):
		var tween := create_tween()
		tween.tween_property(_mid_rumble_player, "volume_db", -40.0, 3.0)
		tween.tween_callback(_mid_rumble_player.queue_free)
		_mid_rumble_player = null

	print("=== SINK EVENT COMPLETED ===")
	print("  Ship now at Y=%.2f, Roll=%.1f°, Pitch=%.1f°" % [
		ship_root.global_position.y,
		rad_to_deg(ship_root.rotation.z),
		rad_to_deg(ship_root.rotation.x)
	])


func _explode_hull_pieces(count: int) -> void:
	## Explode random hull pieces outward during sink.
	var available: Array[RigidBody3D] = []
	for body in _hull_fragments:
		if not _destroyed_bodies.get(body, false):
			available.append(body)

	available.shuffle()
	var to_explode := mini(count, available.size())

	for i in range(to_explode):
		var body: RigidBody3D = available[i]
		var outward_dir := (body.global_position - ship_root.global_position).normalized()
		outward_dir.y = randf_range(0.3, 0.8)  # Upward bias
		outward_dir = outward_dir.normalized()

		body.freeze = false
		body.apply_central_impulse(outward_dir * body.mass * 15.0)
		_destroyed_bodies[body] = true

	# ONE sound for all exploded pieces
	if to_explode > 0:
		_play_ship_sound(_wood_crash_sound, -12.0)
		print("Exploded %d hull pieces during sink" % to_explode)
