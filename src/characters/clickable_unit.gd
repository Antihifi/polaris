class_name ClickableUnit extends CharacterBody3D
## Simple click-to-move unit for RTS-style control.
## Uses NavigationAgent3D for pathfinding.
## Includes survival stats for gameplay.

signal selected
signal deselected
signal reached_destination
signal stats_changed  # Emitted when stats are updated
signal inventory_changed  # Emitted when unit inventory contents change

@export_category("Identity")
@export var unit_name: String = "Survivor"

@export_category("Movement")
## Movement speed in units/second. Also controls animation and footstep sound speed.
@export var movement_speed: float = 1.0
@export var rotation_speed: float = 10.0

@export_category("Survival")
## Survival stats resource. Created automatically if not set.
@export var stats: SurvivorStats

@export_category("Animation")
## Base animation speed at movement_speed=1. Adjust until walk animation looks right at speed 1.
@export_range(0.01, 2.0, 0.01) var base_animation_speed: float = 0.15

@export_category("Audio")
## Base footstep playback speed at movement_speed=1. Adjust until footsteps match animation at speed 1.
@export_range(0.1, 2.0, 0.01) var base_footstep_speed: float = 0.5
## Base volume for footstep sounds (0.0 to 1.0).
@export_range(0.0, 1.0, 0.05) var footstep_volume: float = 1.0
## Maximum distance at which footsteps can be heard.
@export var footstep_max_distance: float = 50.0
## Reference distance for volume falloff (larger = louder at distance).
@export var footstep_unit_size: float = 10.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = null

# Footstep audio (3D positional)
var footstep_sound: AudioStream = preload("res://sounds/snow-walk-1.mp3")
var _footstep_player: AudioStreamPlayer3D

var is_selected: bool = false
var is_moving: bool = false
var _debug_frame_count: int = 0
var _time_manager: Node = null
var _last_energy_signal: float = 100.0  # Track last energy value for signal emission

## Animation offset (0-1) to desync animations between units
var animation_offset: float = 0.0

## Unit inventory (3x3 grid)
var inventory: Inventory = null
var _inventory_protoset: JSON = null
const INVENTORY_GRID_SIZE := Vector2i(3, 3)


func _ready() -> void:
	print("[ClickableUnit] _ready() called on: ", name)
	print("[ClickableUnit] Position: ", global_position)
	print("[ClickableUnit] NavigationAgent3D: ", navigation_agent)

	# Initialize stats if not set
	if stats == null:
		stats = SurvivorStats.new()
		print("[ClickableUnit] Created new SurvivorStats")

	# Setup navigation callbacks
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_finished)

	# Find AnimationPlayer in children (CaptainAnimations/AnimationPlayer)
	animation_player = _find_animation_player(self)
	if animation_player:
		print("[ClickableUnit] Found AnimationPlayer: ", animation_player.name)
		_play_animation("idle")
	else:
		print("[ClickableUnit] WARNING: No AnimationPlayer found")

	# Create 3D positional footstep audio player
	_footstep_player = AudioStreamPlayer3D.new()
	_footstep_player.stream = footstep_sound
	_footstep_player.volume_db = linear_to_db(footstep_volume)
	_footstep_player.max_distance = footstep_max_distance
	_footstep_player.unit_size = footstep_unit_size
	_footstep_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	add_child(_footstep_player)
	_footstep_player.finished.connect(_on_footstep_finished)

	# Add to groups for easy querying
	add_to_group("selectable_units")
	add_to_group("survivors")  # For TimeManager needs updates

	# Get TimeManager reference for time scale
	_time_manager = get_node_or_null("/root/TimeManager")
	if _time_manager and _time_manager.has_signal("time_scale_changed"):
		_time_manager.time_scale_changed.connect(_on_time_scale_changed)

	# Setup inventory
	_setup_inventory()

	print("[ClickableUnit] Ready complete, added to selectable_units and survivors groups")


func _physics_process(delta: float) -> void:
	_debug_frame_count += 1

	# Debug every 120 frames to confirm _physics_process is running
	if _debug_frame_count % 120 == 1:
		print("[ClickableUnit] _physics_process running, frame: ", _debug_frame_count, " is_moving: ", is_moving)

	if not is_moving:
		return

	if navigation_agent.is_navigation_finished():
		print("[ClickableUnit] Navigation finished at: ", global_position)
		is_moving = false
		velocity = Vector3.ZERO
		_play_animation("idle")
		_stop_footsteps()
		reached_destination.emit()
		return

	var next_position := navigation_agent.get_next_path_position()
	var current_pos := global_position

	# Debug every 60 frames (~1 second)
	if _debug_frame_count % 60 == 0:
		print("[ClickableUnit] Frame ", _debug_frame_count, " | pos: ", current_pos, " -> next: ", next_position)

	# Calculate direction to next waypoint (full 3D - NavigationAgent provides correct Y from NavMesh)
	var direction := next_position - current_pos

	var distance := direction.length()
	if distance < 0.1:
		# Very close to waypoint - wait for next one
		return

	direction = direction.normalized()

	# Rotate towards movement direction
	var target_rotation := atan2(direction.x, direction.z)
	rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

	# Calculate and apply velocity using proper physics (scaled by time)
	var time_scale := _get_time_scale()
	velocity = direction * movement_speed * time_scale
	move_and_slide()

	# Drain energy while walking (scales with time and condition)
	_drain_walking_energy(delta, time_scale)

	# Debug: show actual movement
	if _debug_frame_count % 60 == 0:
		print("[ClickableUnit] velocity: ", velocity, " | new pos: ", global_position)


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_navigation_finished() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	_stop_footsteps()
	reached_destination.emit()


func move_to(target_position: Vector3) -> void:
	## Navigate to target position.
	print("[ClickableUnit] move_to called with target: ", target_position)
	print("[ClickableUnit] Current position: ", global_position)
	navigation_agent.target_position = target_position
	is_moving = true
	_play_animation("walking")
	_start_footsteps()
	_update_speed_scale()
	print("[ClickableUnit] Navigation target set, is_moving = ", is_moving)
	print("[ClickableUnit] Nav agent is_target_reachable: ", navigation_agent.is_target_reachable())
	print("[ClickableUnit] Nav agent is_navigation_finished: ", navigation_agent.is_navigation_finished())


func stop() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	_play_animation("idle")
	_stop_footsteps()


func select() -> void:
	is_selected = true
	selected.emit()
	_show_selection_indicator(true)


func deselect() -> void:
	is_selected = false
	deselected.emit()
	_show_selection_indicator(false)


func _show_selection_indicator(show: bool) -> void:
	# Look for a SelectionIndicator child node
	var indicator := get_node_or_null("SelectionIndicator")
	if indicator:
		indicator.visible = show


func _find_animation_player(node: Node) -> AnimationPlayer:
	## Recursively search for an AnimationPlayer in the node tree.
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var found := _find_animation_player(child)
		if found:
			return found
	return null


func _play_animation(anim_name: String) -> void:
	## Play an animation if the AnimationPlayer exists and has the animation.
	## Applies animation_offset to desync animations between multiple units.
	if not animation_player:
		return
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
		# Apply offset to desync animations between units
		if animation_offset > 0.0:
			var anim_length := animation_player.current_animation_length
			if anim_length > 0:
				animation_player.seek(animation_offset * anim_length, true)
	else:
		print("[ClickableUnit] Animation not found: ", anim_name)


# --- Footstep Audio ---

func _start_footsteps() -> void:
	## Start looping footstep sound with speed-matched pitch.
	if is_instance_valid(_footstep_player) and not _footstep_player.playing:
		_footstep_player.play()


func _stop_footsteps() -> void:
	## Stop footstep sound.
	if is_instance_valid(_footstep_player):
		_footstep_player.stop()


func _on_footstep_finished() -> void:
	## Loop footsteps while moving.
	if is_moving and is_instance_valid(_footstep_player):
		_footstep_player.play()


func _get_time_scale() -> float:
	## Get current time scale from TimeManager (1.0 if not available or paused).
	if _time_manager and "time_scale" in _time_manager:
		var scale: float = _time_manager.time_scale
		return scale if scale > 0.0 else 0.0
	return 1.0


func _on_time_scale_changed(_scale: float) -> void:
	## Called when time scale changes - update animation/audio speeds.
	_update_speed_scale()


func _update_speed_scale() -> void:
	## Sync animation and footstep playback speed to movement speed and time scale.
	## At movement_speed=1 and time_scale=1, animation plays at base_animation_speed
	## and footsteps play at base_footstep_speed.
	var time_scale := _get_time_scale()

	# Animation: scale by both movement speed and time scale
	if animation_player:
		animation_player.speed_scale = base_animation_speed * movement_speed * time_scale

	# Footsteps: scale pitch by both movement speed and time scale
	if is_instance_valid(_footstep_player):
		_footstep_player.pitch_scale = base_footstep_speed * movement_speed * time_scale


# --- Survival Needs ---

## Energy drain per real second of walking at 1x time scale and perfect condition.
## Walking for 1 real minute at 1x = 0.5 energy. 1 hour real time = 30 energy.
## At 4x speed, that's 2 energy per real second, so 1 minute = 120 energy (but time passes faster).
const BASE_WALKING_ENERGY_DRAIN: float = 0.5

func _drain_walking_energy(delta: float, time_scale: float) -> void:
	## Drain energy while walking. Amount depends on condition and time scale.
	if not stats or time_scale <= 0.0:
		return

	# Base drain per second, scaled by game time
	var drain := BASE_WALKING_ENERGY_DRAIN * delta * time_scale

	# Multiply by condition-based drain modifier
	drain *= stats.get_energy_drain_multiplier()

	# Apply the drain
	stats.energy -= drain

	# Emit signal if significant change (every 1 energy lost) to update UI
	if absf(stats.energy - _last_energy_signal) >= 1.0:
		_last_energy_signal = stats.energy
		stats_changed.emit()


func update_needs(delta_hours: float, is_in_shelter: bool, is_near_fire: bool, ambient_temp: float) -> void:
	## Called by TimeManager each in-game hour to update survival needs.
	if not stats:
		return

	var is_working := is_moving  # For now, moving counts as working
	stats.apply_hourly_decay(is_working, is_in_shelter, is_near_fire, ambient_temp)
	stats_changed.emit()

	# Check for death
	if stats.is_dead():
		_on_death()


func _on_death() -> void:
	## Handle unit death from needs.
	print("[ClickableUnit] ", unit_name, " has died!")
	_play_animation("dying")
	_stop_footsteps()
	is_moving = false
	# Disable further input/processing
	set_physics_process(false)


func get_display_info() -> Dictionary:
	## Returns info for UI display.
	if not stats:
		return {}
	return {
		"name": unit_name,
		"health": stats.health,
		"hunger": stats.hunger,
		"warmth": stats.warmth,
		"energy": stats.energy,
		"morale": stats.morale,
		"is_moving": is_moving
	}


# --- Inventory ---

func _setup_inventory() -> void:
	## Create unit inventory with GridConstraint.
	_inventory_protoset = load("res://data/items_protoset.json")

	inventory = Inventory.new()
	inventory.name = "Inventory"
	inventory.protoset = _inventory_protoset
	add_child(inventory)

	var grid := GridConstraint.new()
	grid.name = "GridConstraint"
	grid.size = INVENTORY_GRID_SIZE
	inventory.add_child(grid)

	inventory.item_added.connect(_on_inventory_changed)
	inventory.item_removed.connect(_on_inventory_changed)


func _on_inventory_changed(_item: InventoryItem) -> void:
	inventory_changed.emit()


func has_food_in_inventory() -> bool:
	## Check if unit has any food items.
	if not inventory:
		return false
	for item in inventory.get_items():
		if item.get_property("category", "misc") == "food":
			return true
	return false


func get_food_from_inventory() -> InventoryItem:
	## Get first food item from inventory (does NOT remove it).
	if not inventory:
		return null
	for item in inventory.get_items():
		if item.get_property("category", "misc") == "food":
			return item
	return null


func eat_food_item(item: InventoryItem) -> void:
	## Consume a food item, restoring hunger/morale.
	if not item or not inventory or not stats:
		return

	var nutrition: float = item.get_property("nutritional_value", 10.0)
	var morale_boost: float = item.get_property("morale_value", 0.0)
	var warmth_boost: float = item.get_property("warmth_value", 0.0)

	stats.hunger = minf(stats.hunger + nutrition, 100.0)
	stats.morale = minf(stats.morale + morale_boost, 100.0)
	stats.warmth = minf(stats.warmth + warmth_boost, 100.0)

	inventory.remove_item(item)
	stats_changed.emit()
	print("[ClickableUnit] %s ate %s (+%.0f hunger)" % [unit_name, item.get_property("name", "food"), nutrition])

# --- Environmental/Aura Detection Stubs ---
# TODO: Properly implement these when shelter/fire/aura systems are rebuilt

func is_in_shelter() -> bool:
	## Returns true if unit is inside a shelter structure.
	return false


func get_shelter_type() -> int:
	## Returns shelter type: 0=TENT, 1=IMPROVED_SHELTER, 2=CAVE
	return 0


func is_near_fire() -> bool:
	## Returns true if unit is near a heat source (campfire, etc).
	return false


func is_in_sunlight() -> bool:
	## Returns true if unit is exposed to sunlight (not in shelter, daytime).
	# Could check TimeManager.is_daytime() here when implemented
	return true


func is_near_captain() -> bool:
	## Returns true if unit is within range of a captain's morale aura.
	return false


func is_near_personable() -> bool:
	## Returns true if unit is within range of a personable crew member's aura.
	return false


func has_morale_aura() -> bool:
	## Returns true if this unit provides a morale aura to nearby units.
	return false


func get_morale_aura_name() -> String:
	## Returns the name of this unit's morale aura (e.g., "Captain", "Well-Liked").
	return ""


func get_morale_aura_radius() -> float:
	## Returns the radius of this unit's morale aura in meters.
	return 0.0
