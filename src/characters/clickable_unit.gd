class_name ClickableUnit extends CharacterBody3D
## Simple click-to-move unit for RTS-style control.
## Uses NavigationAgent3D for pathfinding.
## Includes survival stats for gameplay.

signal selected
signal deselected
signal reached_destination
signal stats_changed  # Emitted when stats are updated
signal inventory_changed  # Emitted when unit inventory contents change
signal mental_break(unit: ClickableUnit, break_type: String)
signal died(unit: ClickableUnit, cause: SurvivorStats.DeathCause)

@export_category("Identity")
@export var unit_name: String = "Survivor"
## If true, this unit is THE Captain and gets a large (100m) morale aura automatically
@export var is_captain: bool = false

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

## Mental state tracking
enum MentalState { STABLE, STRESSED, BROKEN }
var mental_state: MentalState = MentalState.STABLE

## Buff tracking (Area3D-based, can have multiple sources)
var _captain_aura_count: int = 0
var _personable_aura_count: int = 0
var _fire_sources: Array = []  # Array of WarmthArea references
var _current_shelter: Node = null  # ShelterArea reference
var _is_in_sunlight: bool = true  # Updated by TimeManager each hour

## Unit inventory (3x3 grid)
var inventory: Inventory = null
var _inventory_protoset: JSON = null
const INVENTORY_GRID_SIZE := Vector2i(3, 3)

## Player command override for AI-controlled units
## When true, AI behavior pauses until manual movement completes
var player_command_active: bool = false


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

	# If this is the Captain, add the Captain's Morale Aura (100m radius)
	if is_captain:
		_setup_captain_aura()

	print("[ClickableUnit] Ready complete, added to selectable_units and survivors groups")


func _physics_process(delta: float) -> void:
	_debug_frame_count += 1

	if not is_moving:
		return

	if navigation_agent.is_navigation_finished():
		is_moving = false
		velocity = Vector3.ZERO
		_play_animation("idle")
		_stop_footsteps()
		reached_destination.emit()
		return

	var next_position := navigation_agent.get_next_path_position()
	var current_pos := global_position

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

	# Calculate DESIRED velocity (what we want to move at)
	var time_scale := _get_time_scale()
	var desired_velocity := direction * movement_speed * time_scale

	# Set velocity on NavigationAgent - it computes safe velocity avoiding obstacles
	# and emits velocity_computed signal which triggers _on_velocity_computed()
	navigation_agent.velocity = desired_velocity

	# Drain energy while walking (scales with time and condition)
	_drain_walking_energy(delta, time_scale)


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_navigation_finished() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	_stop_footsteps()
	reached_destination.emit()


func move_to(target_position: Vector3, is_player_command: bool = false) -> void:
	## Navigate to target position.
	## If is_player_command is true, this is a manual player order that overrides AI.

	# Set player override flag for AI-controlled units
	if is_player_command:
		player_command_active = true

	navigation_agent.target_position = target_position
	is_moving = true
	_play_animation("walking")
	_start_footsteps()
	_update_speed_scale()


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


func _show_selection_indicator(visible: bool) -> void:
	# Look for a SelectionIndicator child node
	var indicator := get_node_or_null("SelectionIndicator")
	if indicator:
		indicator.visible = visible


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
		var time_scale_value: float = _time_manager.time_scale
		return time_scale_value if time_scale_value > 0.0 else 0.0
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
		var anim_speed := base_animation_speed * movement_speed * time_scale
		animation_player.speed_scale = maxf(anim_speed, 0.001)  # Prevent 0

	# Footsteps: scale pitch by both movement speed and time scale
	# pitch_scale must be > 0 or Godot throws an error
	if is_instance_valid(_footstep_player):
		var pitch := base_footstep_speed * movement_speed * time_scale
		_footstep_player.pitch_scale = maxf(pitch, 0.001)  # Prevent <= 0 error


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


func update_needs(_delta_hours: float, sunlight_state: bool, ambient_temp: float) -> void:
	## Called by TimeManager each in-game hour to update survival needs.
	## Uses Area3D-based buff tracking for shelter/fire proximity.
	if not stats:
		return

	# Track sunlight state for UI display
	_is_in_sunlight = sunlight_state

	var is_working := is_moving  # For now, moving counts as working

	# Apply hourly decay with buff-based shelter/fire state
	stats.apply_hourly_decay(is_working, is_in_shelter(), is_near_fire(), ambient_temp, sunlight_state)

	# Apply morale buffs from proximity (captain, personable, fire social)
	stats.morale += get_morale_buff_rate()

	# Apply warmth buffs from fire/shelter
	stats.warmth += get_warmth_buff_rate()

	stats_changed.emit()

	# Check for mental break (morale hits 0)
	_check_mental_state()

	# Check for death
	if stats.is_dead():
		_on_death()


func _on_death() -> void:
	## Handle unit death from needs.
	var cause := stats.get_dying_cause() if stats else SurvivorStats.DeathCause.NONE
	print("[ClickableUnit] %s has died! Cause: %s" % [unit_name, SurvivorStats.DeathCause.keys()[cause]])

	_play_animation("dying")
	_stop_footsteps()
	is_moving = false

	# Emit death signal
	died.emit(self, cause)

	# Remove from survivors group, add to corpses
	remove_from_group("survivors")
	add_to_group("corpses")

	# Spawn corpse container with lootable human meat
	_spawn_corpse_container()

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


# --- Captain Aura ---

func _setup_captain_aura() -> void:
	## Create Captain's Morale Aura (100m radius) for THE Captain.
	var MoraleAuraScript: GDScript = preload("res://src/systems/morale_aura.gd")

	var aura: Area3D = Area3D.new()
	aura.set_script(MoraleAuraScript)
	aura.name = "MoraleAura"
	aura.aura_type = 0  # CAPTAIN enum value
	aura.radius = 100.0  # Captain has 100m morale aura
	add_child(aura)

	print("[ClickableUnit] Captain's Morale Aura created (100m radius)")


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


# --- Buff Tracking (Area3D Event-Driven) ---

func is_near_captain() -> bool:
	return _captain_aura_count > 0


func is_near_personable() -> bool:
	return _personable_aura_count > 0


func is_near_fire() -> bool:
	return not _fire_sources.is_empty()


func is_in_shelter() -> bool:
	return _current_shelter != null


func is_in_sunlight() -> bool:
	return _is_in_sunlight


func get_shelter_type() -> int:
	## Returns shelter type enum value, or -1 if not in shelter.
	if _current_shelter and _current_shelter.has_method("get_shelter_type"):
		return _current_shelter.get_shelter_type()
	return -1


func enter_captain_aura() -> void:
	_captain_aura_count += 1


func exit_captain_aura() -> void:
	_captain_aura_count = maxi(0, _captain_aura_count - 1)


func enter_personable_aura() -> void:
	_personable_aura_count += 1


func exit_personable_aura() -> void:
	_personable_aura_count = maxi(0, _personable_aura_count - 1)


func enter_fire_warmth(fire: Node) -> void:
	if fire not in _fire_sources:
		_fire_sources.append(fire)


func exit_fire_warmth(fire: Node) -> void:
	_fire_sources.erase(fire)


func enter_shelter(shelter: Node) -> void:
	_current_shelter = shelter


func exit_shelter() -> void:
	_current_shelter = null


func witness_hunting_kill(bonus: float) -> void:
	## Called when this unit witnesses a hunting kill.
	if stats:
		stats.morale += bonus
		stats_changed.emit()


func get_morale_buff_rate() -> float:
	## Returns hourly morale buff from proximity buffs.
	var buff := 0.0
	if is_near_captain():
		buff += 1.0
	if is_near_personable():
		buff += 0.5
	# Fire social bonus (if near fire with others - simplified for now)
	if is_near_fire():
		buff += 0.25
	return buff


func get_warmth_buff_rate() -> float:
	## Returns hourly warmth buff from fire proximity.
	var buff := 0.0
	for fire in _fire_sources:
		if fire.has_method("get_warmth_bonus"):
			buff += fire.get_warmth_bonus()
	if _current_shelter and _current_shelter.has_method("get_warmth_bonus"):
		buff += _current_shelter.get_warmth_bonus()
	return buff


func get_cold_reduction() -> float:
	## Returns cold damage multiplier from shelter (1.0 = no reduction).
	if _current_shelter and _current_shelter.has_method("get_cold_reduction"):
		return _current_shelter.get_cold_reduction()
	return 1.0


func has_morale_aura() -> bool:
	## Returns true if this unit has a MoraleAura child (is Captain or Well Liked).
	return get_node_or_null("MoraleAura") != null


func get_morale_aura() -> Node:
	## Returns the MoraleAura node if this unit has one, null otherwise.
	return get_node_or_null("MoraleAura")


func get_morale_aura_name() -> String:
	## Returns display name of this unit's morale aura, or empty string if none.
	var aura := get_node_or_null("MoraleAura")
	if aura and aura.has_method("get_display_name"):
		return aura.get_display_name()
	return ""


func get_morale_aura_radius() -> float:
	## Returns radius of this unit's morale aura, or 0 if none.
	var aura := get_node_or_null("MoraleAura")
	if aura and aura.has_method("get_aura_radius"):
		return aura.get_aura_radius()
	return 0.0


# --- Mental Break System ---

func _check_mental_state() -> void:
	## Check for mental break when morale hits 0.
	if not stats:
		return

	if stats.morale <= 0.0 and mental_state != MentalState.BROKEN:
		mental_state = MentalState.BROKEN
		var break_type := _determine_break_type()
		mental_break.emit(self, break_type)
		_execute_mental_break(break_type)


func _determine_break_type() -> String:
	## Determine which mental break behavior based on hunger level.
	if stats.hunger <= 0.0:
		return "wendigo"  # Cannibalism
	elif stats.hunger <= 25.0:
		return "binge"  # Consume all available food
	else:
		return "berserk"  # Attack others


func _execute_mental_break(break_type: String) -> void:
	## Execute mental break behavior (AI-controlled).
	print("[ClickableUnit] %s has had a mental break: %s" % [unit_name, break_type])
	match break_type:
		"wendigo":
			# TODO: Find nearest survivor, attack and consume
			pass
		"binge":
			# TODO: Find food stockpile, consume everything
			pass
		"berserk":
			# TODO: Attack nearest survivor
			pass


# --- Death & Corpse System ---

func _spawn_corpse_container() -> void:
	## Replace dead character with lootable corpse containing human meat.
	var corpse_scene := load("res://objects/corpse_container.tscn")
	if not corpse_scene:
		print("[ClickableUnit] ERROR: Could not load corpse_container.tscn")
		return

	var corpse: Node3D = corpse_scene.instantiate()
	corpse.global_position = global_position
	corpse.global_rotation = global_rotation

	# Get the StorageContainer and populate with human meat
	var storage: Node = corpse.get_node_or_null("StorageContainer")
	if storage and storage.has_method("get") and "inventory" in storage:
		if "display_name" in storage:
			storage.display_name = unit_name + "'s Remains"

		var inv: Inventory = storage.inventory
		if inv:
			# Random 2-6 human meat items (1x1 each)
			var meat_count: int = randi_range(2, 6)
			var protoset: JSON = load("res://data/items_protoset.json")
			for i in meat_count:
				var meat := InventoryItem.new()
				meat.protoset = protoset
				meat.prototype_id = "human_meat"
				inv.add_item(meat)
			print("[ClickableUnit] Spawned corpse with %d human meat" % meat_count)

	get_parent().add_child(corpse)
	print("[ClickableUnit] Corpse container spawned for ", unit_name)
