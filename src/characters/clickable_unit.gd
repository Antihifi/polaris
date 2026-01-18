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
## Set by behavior tree tasks during stationary animations (sitting, sleeping).
## When true, physics processing is skipped to prevent drift.
var is_animation_locked: bool = false
var _time_manager: Node = null
var _last_energy_signal: float = 100.0  # Track last energy value for signal emission
var _terrain_cache: Node = null  # Cached Terrain3D reference for floor checks

## Animation offset (0-1) to desync animations between units
var animation_offset: float = 0.0

## Unit inventory (3x3 grid)
var inventory: Inventory = null
var _inventory_protoset: JSON = null
const INVENTORY_GRID_SIZE := Vector2i(3, 3)

## Warmth/shelter tracking (populated by Area3D enter/exit signals)
var _active_heat_sources: Array[Node] = []  # WarmthArea nodes currently in range
var _current_shelter: Node = null  # ShelterArea node if inside shelter


func _ready() -> void:
	# Initialize stats if not set
	if stats == null:
		stats = SurvivorStats.new()

	# Ensure unit starts in idle state (not walking)
	is_moving = false
	velocity = Vector3.ZERO

	# Setup navigation callbacks
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_finished)

	# Find AnimationPlayer in children (CaptainAnimations/AnimationPlayer)
	animation_player = _find_animation_player(self)
	if animation_player:
		# Force idle animation after a frame to ensure scene is ready
		# and to override any autoplay or BT-triggered animations
		call_deferred("_force_idle_animation")

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


func _physics_process(delta: float) -> void:
	# Skip physics during locked animations (sitting, sleeping)
	if is_animation_locked:
		return

	if not is_moving:
		return

	# Standard NavigationAgent3D pattern (from Terrain3D demo)
	if navigation_agent.is_navigation_finished():
		velocity.x = 0.0
		velocity.z = 0.0
		is_moving = false
		_play_animation("idle")
		_stop_footsteps()
		reached_destination.emit()
	else:
		var next_pos: Vector3 = navigation_agent.get_next_path_position()
		# Note: Engine.time_scale handles speed scaling via move_and_slide() delta
		var velocity_xz := (next_pos - global_position).normalized() * movement_speed
		velocity.x = velocity_xz.x
		velocity.z = velocity_xz.z

		# Rotate towards movement direction
		var target_rotation := atan2(velocity_xz.x, velocity_xz.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

		# Drain energy while walking (delta is already scaled by Engine.time_scale)
		_drain_walking_energy(delta)

	# Use avoidance if enabled, otherwise move directly
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(velocity)
	else:
		_on_velocity_computed(velocity)

	# Terrain floor check - improved for slopes
	# On slopes, NavMesh height can diverge from terrain height, causing drift.
	# Actively snap to terrain when height mismatch exceeds threshold.
	var terrain := _find_terrain3d()
	if terrain and "data" in terrain and terrain.data:
		var height: float = terrain.data.get_height(global_position)
		if is_finite(height):
			var height_delta := global_position.y - height
			if absf(height_delta) > 0.3:
				# Large mismatch on slopes - snap to terrain with small offset
				global_position.y = height + 0.05
			else:
				# Normal floor check - prevent falling below terrain
				global_position.y = maxf(global_position.y, height)


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	# Skip movement during locked animations (sitting, sleeping, etc.)
	if is_animation_locked:
		return
	# Only apply X/Z from avoidance (demo pattern)
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z
	move_and_slide()


func _on_navigation_finished() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	_stop_footsteps()
	reached_destination.emit()
	_clear_player_command()


## =====================================================================
## FLOOR CHECK - DEBUGGING HISTORY (2026-01-11)
## See /home/antih/.claude/plans/fizzy-coalescing-charm.md for full details
## =====================================================================
##
## THE CORE PROBLEM: NavMesh is baked ~0.5-0.6m ABOVE terrain surface.
## Captain standing on terrain (Y=13.5) is BELOW navmesh minimum (Y=13.97).
## Paths return 0 points because captain can't reach the navmesh.
##
## APPROACHES TRIED (ALL FAILED):
##
## 1. maxf(y, terrain_height) - Demo Enemy.gd pattern
##    Result: Captain stays below navmesh, paths=0
##    Why: maxf only prevents falling BELOW, doesn't lift UP to navmesh
##
## 2. Snap to terrain height exactly
##    Result: Captain on terrain but below navmesh
##    Why: NavMesh height != terrain height due to cell_height quantization
##
## 3. Spawn high (Y+50) + gravity
##    Result: Captain barely falls (0.11m instead of 0.56m expected)
##    Why: move_and_slide() needs collision, terrain collision may be wrong
##
## 4. Snap to navmesh height during spawn
##    Result: Teleported to (0,0,0)
##    Why: Called before navmesh was ready
##
## 5. Reduce cell_height to 0.1
##    Result: Partial success ~10 seconds, then stuck
##    Why: Gap reduced but still too large
##
## CURRENT APPROACH (2026-01-17): Standard Terrain3D demo pattern
## - Use Terrain3D demo Enemy.gd pattern exactly
## - Only set velocity.x and velocity.z from navigation
## - Use maxf(y, terrain_height) as floor check at end of _physics_process
## =====================================================================


func _find_terrain3d() -> Node:
	## Find Terrain3D node in scene (cached for performance).
	if _terrain_cache and is_instance_valid(_terrain_cache):
		return _terrain_cache

	var nodes := get_tree().get_nodes_in_group("terrain")
	if nodes.size() > 0:
		_terrain_cache = nodes[0]
		return _terrain_cache

	# Fallback: search for Terrain3D by class
	_terrain_cache = _find_node_by_class(get_tree().current_scene, "Terrain3D")
	return _terrain_cache


func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	## Recursively find node by class name.
	if node.get_class() == class_name_str:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_str)
		if result:
			return result
	return null


func move_to(target_position: Vector3) -> void:
	## Navigate to target position.
	navigation_agent.target_position = target_position
	is_moving = true
	_play_animation("walking")
	_start_footsteps()
	_update_speed_scale()


func stop() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	# CRITICAL: Must also stop NavigationAgent to prevent drift!
	# Setting target to current position stops path computation.
	# Setting velocity to zero stops avoidance computation.
	navigation_agent.target_position = global_position
	navigation_agent.set_velocity(Vector3.ZERO)
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


func _force_idle_animation() -> void:
	## Called deferred to ensure idle animation after scene is fully ready.
	## Prevents units spawning in walking animation.
	if animation_player and not is_moving and not is_animation_locked:
		animation_player.stop()
		_play_animation("idle")


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
	# Animation speed_scale can be 0 (paused), but we use maxf to prevent negative values
	if animation_player:
		animation_player.speed_scale = maxf(0.0, base_animation_speed * movement_speed * time_scale)

	# Footsteps: scale pitch by both movement speed and time scale
	# IMPORTANT: pitch_scale must be > 0 or Godot throws an error
	# When paused (time_scale=0), we stop footsteps instead of setting pitch to 0
	if is_instance_valid(_footstep_player):
		var pitch := base_footstep_speed * movement_speed * time_scale
		if pitch > 0.01:  # Minimum viable pitch
			_footstep_player.pitch_scale = pitch
		else:
			# Can't set pitch to 0, so stop playback when paused
			if _footstep_player.playing:
				_footstep_player.stop()


# --- Survival Needs ---

## Energy drain per real second of walking at 1x time scale and perfect condition.
## Walking for 1 real minute at 1x = 0.5 energy. 1 hour real time = 30 energy.
## At 4x speed, delta is scaled by Engine.time_scale, so drain is automatically 4x faster.
const BASE_WALKING_ENERGY_DRAIN: float = 0.5

func _drain_walking_energy(delta: float) -> void:
	## Drain energy while walking. Delta is already scaled by Engine.time_scale.
	if not stats or delta <= 0.0:
		return

	# Base drain per second (delta is already scaled by Engine.time_scale)
	var drain := BASE_WALKING_ENERGY_DRAIN * delta

	# Multiply by condition-based drain modifier
	drain *= stats.get_energy_drain_multiplier()

	# Apply the drain
	stats.energy -= drain

	# Emit signal if significant change (every 1 energy lost) to update UI
	if absf(stats.energy - _last_energy_signal) >= 1.0:
		_last_energy_signal = stats.energy
		stats_changed.emit()


func update_needs(delta_hours: float, in_shelter: bool, near_fire: bool, ambient_temp: float, in_sunlight: bool = true) -> void:
	## Called by TimeManager each in-game hour to update survival needs.
	if not stats:
		return

	var is_working := is_moving  # For now, moving counts as working
	var in_bed := is_in_bed()  # Check if sleeping in actual bed for 2X bonus
	stats.apply_hourly_decay(is_working, in_shelter, in_bed, near_fire, ambient_temp, in_sunlight)
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

# --- Environmental Detection (Warmth/Shelter) ---
# Tracking is populated by WarmthArea/ShelterArea body_entered/exited signals.

func enter_fire_warmth(warmth_area: Node) -> void:
	## Called by WarmthArea when unit enters heat source range.
	if warmth_area and warmth_area not in _active_heat_sources:
		_active_heat_sources.append(warmth_area)
		print("[ClickableUnit] %s entered fire warmth (sources: %d)" % [unit_name, _active_heat_sources.size()])


func exit_fire_warmth(warmth_area: Node) -> void:
	## Called by WarmthArea when unit exits heat source range.
	_active_heat_sources.erase(warmth_area)
	print("[ClickableUnit] %s exited fire warmth (sources: %d)" % [unit_name, _active_heat_sources.size()])


func enter_shelter(shelter_area: Node) -> void:
	## Called by ShelterArea when unit enters shelter.
	_current_shelter = shelter_area
	print("[ClickableUnit] %s entered shelter" % unit_name)


func exit_shelter() -> void:
	## Called by ShelterArea when unit exits shelter.
	_current_shelter = null
	print("[ClickableUnit] %s exited shelter" % unit_name)


func is_in_bed() -> bool:
	## Returns true if unit is within 1.5m of a bed's foot_of__bed marker.
	## Used for 2X energy recovery bonus.
	for bed in get_tree().get_nodes_in_group("beds"):
		var marker: Marker3D = bed.find_child("foot_of__bed", true, false)
		if marker and global_position.distance_to(marker.global_position) < 1.5:
			return true
	return false


func is_in_shelter() -> bool:
	## Returns true if unit is inside a shelter structure.
	return _current_shelter != null


func get_shelter_type() -> int:
	## Returns shelter type: 0=TENT, 1=IMPROVED_SHELTER, 2=CAVE
	if _current_shelter and _current_shelter.has_method("get_shelter_type"):
		return _current_shelter.get_shelter_type()
	return 0


func is_near_fire() -> bool:
	## Returns true if unit is near a heat source (campfire, etc).
	# Clean up invalid references first
	var valid_sources: Array[Node] = []
	for source in _active_heat_sources:
		if is_instance_valid(source):
			valid_sources.append(source)
	_active_heat_sources = valid_sources
	return _active_heat_sources.size() > 0


func is_in_sunlight() -> bool:
	## Returns true if unit is exposed to sunlight (not in shelter, daytime).
	if is_in_shelter():
		return false
	if _time_manager and _time_manager.has_method("is_daytime"):
		return _time_manager.is_daytime()
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


# --- AI Integration ---

func _clear_player_command() -> void:
	## Clears the player command flag in the AI controller when destination reached.
	var ai_controller: Node = get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("set_player_command_active"):
		ai_controller.set_player_command_active(false)


func get_current_action() -> String:
	## Returns the current AI action for UI display.
	var ai_controller: Node = get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("get_current_action"):
		return ai_controller.get_current_action()
	return "Idle"


# ============================================================================
# STAT PROPERTY ACCESSORS (for BTCheckAgentProperty)
# ============================================================================
# These expose nested stats.* values as direct properties so LimboAI's
# BTCheckAgentProperty can check them without custom tasks.
# Example: BTCheckAgentProperty with property="warmth", check_type=CHECK_LESS_THAN, value=25.0

var warmth: float:
	get: return stats.warmth if stats else 100.0

var hunger: float:
	get: return stats.hunger if stats else 100.0

var energy: float:
	get: return stats.energy if stats else 100.0

var health: float:
	get: return stats.health if stats else 100.0

var morale: float:
	get: return stats.morale if stats else 75.0

var is_dead: bool:
	get: return stats.is_dead() if stats else false

# Threshold checks (convenience for BT - can check is_warmth_critical == true)
var is_warmth_critical: bool:
	get: return warmth < 25.0

var is_hunger_critical: bool:
	get: return hunger < 25.0

var is_energy_critical: bool:
	get: return energy < 25.0

var is_warmth_satisfied: bool:
	get: return warmth >= 80.0

var is_hunger_satisfied: bool:
	get: return hunger >= 80.0

var is_energy_satisfied: bool:
	get: return energy >= 80.0


# ============================================================================
# PROXIMITY PROPERTY ACCESSORS (for BTCheckAgentProperty distance checks)
# ============================================================================
# Set _bt_target_position from blackboard before checking distance_to_target.
# Use BTSetAgentProperty to copy target_position to _bt_target_position.

## Internal: target position copied from blackboard for proximity checks
var _bt_target_position: Vector3 = Vector3.INF

## Distance from agent to current blackboard target position
var distance_to_target: float:
	get:
		if _bt_target_position == Vector3.INF:
			return INF
		return global_position.distance_to(_bt_target_position)

## True if within 3m of target (standard arrival distance)
var is_at_target: bool:
	get: return distance_to_target < 3.0

## True if within 5m of target (looser proximity)
var is_near_target: bool:
	get: return distance_to_target < 5.0
