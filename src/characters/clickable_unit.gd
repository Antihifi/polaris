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

@export_category("Debug")
## DEBUG: Bypass navigation and walk in facing direction. Used to isolate physics vs navigation issues.
## When true, clicking just sets is_moving=true and unit walks forward (no pathfinding).
@export var debug_bypass_navigation: bool = false

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


func _unhandled_input(event: InputEvent) -> void:
	# F9 toggles debug physics mode (bypasses navigation)
	if event is InputEventKey and event.pressed and event.keycode == KEY_F9:
		debug_bypass_navigation = not debug_bypass_navigation
		print("[%s] DEBUG MODE: %s (F9 toggle)" % [unit_name, "ON - walking forward only" if debug_bypass_navigation else "OFF - using navigation"])
		get_viewport().set_input_as_handled()


func _physics_process(delta: float) -> void:
	# Skip physics during locked animations (sitting, sleeping)
	if is_animation_locked:
		return

	# Non-lead sled pullers automatically follow the leader
	_update_sled_follower()

	if not is_moving:
		return

	# =========================================================================
	# DEBUG MODE: Bypass navigation, walk in facing direction
	# Used to isolate PHYSICS vs NAVIGATION issues
	# =========================================================================
	if debug_bypass_navigation:
		# Walk in current facing direction (no pathfinding)
		var forward: Vector3 = -global_transform.basis.z.normalized()
		forward.y = 0.0
		velocity.x = forward.x * movement_speed
		velocity.z = forward.z * movement_speed

		# Log movement for debugging (once per second to reduce spam)
		if Engine.get_physics_frames() % 60 == 0:
			var path_info := navigation_agent.get_current_navigation_path()
			print("[%s] DEBUG PHYSICS: vel=(%.2f,%.2f) facing=%s path_points=%d" % [
				unit_name, velocity.x, velocity.z, forward, path_info.size()])
	else:
		# =========================================================================
		# NORMAL MODE: Use NavigationAgent3D
		# =========================================================================
		# Standard NavigationAgent3D pattern (from Terrain3D demo)
		if navigation_agent.is_navigation_finished():
			# Debug: Check if we actually reached the target or gave up early
			var dist_to_target := global_position.distance_to(navigation_agent.target_position)
			if dist_to_target > 5.0:
				print("[%s] NAV FINISHED but %.1fm from target! Pos: %s Target: %s" % [
					unit_name, dist_to_target, global_position, navigation_agent.target_position])
			velocity.x = 0.0
			velocity.z = 0.0
			is_moving = false
			_play_animation("idle")
			_stop_footsteps()
			reached_destination.emit()
		else:
			var next_pos: Vector3 = navigation_agent.get_next_path_position()
			var dist_to_next := global_position.distance_to(next_pos)

			# DEBUG: Log navigation state every frame when moving
			var path_info := navigation_agent.get_current_navigation_path()
			if Engine.get_physics_frames() % 60 == 0:  # Log once per second
				print("[%s] NAV: path_points=%d next_pos=%s dist=%.2f target=%s" % [
					unit_name, path_info.size(), next_pos, dist_to_next, navigation_agent.target_position])

			# DEBUG: Detect potential stuck state (path position too close)
			if dist_to_next < 0.1:
				print("[%s] STUCK: next_pos=%.3fm away! pos=%s next=%s path_points=%d" % [
					unit_name, dist_to_next, global_position, next_pos, path_info.size()])

			# Note: Engine.time_scale handles speed scaling via move_and_slide() delta
			var velocity_xz := (next_pos - global_position).normalized() * movement_speed
			velocity.x = velocity_xz.x
			velocity.z = velocity_xz.z

			# Apply sled pulling constraints - SIMPLIFIED
			# Only slow down based on weight, let sled physics handle rope tension
			if is_pulling_sled():
				var speed_mod: float = _get_sled_speed_modifier()
				velocity.x *= speed_mod
				velocity.z *= speed_mod

			# Rotate towards movement direction
			var target_rotation := atan2(velocity_xz.x, velocity_xz.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

			# Drain energy while walking (delta is already scaled by Engine.time_scale)
			_drain_walking_energy(delta)

	# Apply gravity (required for move_and_slide to handle slopes - from Terrain3D demo)
	# Without Y velocity, move_and_slide bumps into slope faces instead of sliding up them
	velocity.y -= 40.0 * delta

	# Use avoidance if enabled, otherwise move directly
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(velocity)
	else:
		_on_velocity_computed(velocity)

	# Terrain floor check (from Terrain3D demo) - ESSENTIAL to prevent falling through terrain
	# This is a safety net when move_and_slide() collision detection fails
	var terrain := _find_terrain3d()
	if terrain and "data" in terrain and terrain.data:
		var height: float = terrain.data.get_height(global_position)
		if is_finite(height):
			global_position.y = maxf(global_position.y, height)


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	# Skip movement during locked animations (sitting, sleeping, etc.)
	if is_animation_locked:
		return
	# Only apply X/Z from avoidance (demo pattern)
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z
	move_and_slide()

	# DEBUG: Check if we actually moved (detect collision blocking)
	# Note: At 1 m/s and 60fps, expect ~0.017m per frame. Threshold adjusted accordingly.
	if is_moving and velocity.length() > 0.1:
		var moved := get_position_delta().length()
		var expected := velocity.length() / 60.0  # Rough expected movement per frame
		if moved < expected * 0.1 and Engine.get_physics_frames() % 60 == 0:  # Less than 10% of expected = truly blocked
			print("[%s] BLOCKED: velocity=%.2f but moved=%.3fm (expected ~%.3fm) on_floor=%s on_wall=%s" % [
				unit_name, velocity.length(), moved, expected, is_on_floor(), is_on_wall()])


func _on_navigation_finished() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	_stop_footsteps()
	hide_destination_indicator()
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
	## Dead units cannot move.
	if is_dead:
		return

	navigation_agent.target_position = target_position
	is_moving = true
	_play_animation("walking")
	_start_footsteps()
	_update_speed_scale()

	# Debug: Log path info to diagnose NavMesh issues
	var nav_map := navigation_agent.get_navigation_map()
	if nav_map.is_valid():
		var closest_on_nav := NavigationServer3D.map_get_closest_point(nav_map, target_position)
		var snap_distance := target_position.distance_to(closest_on_nav)
		if snap_distance > 1.0:
			print("[%s] WARNING: Target snapped %.1fm! Clicked: %s -> NavMesh: %s" % [
				unit_name, snap_distance, target_position, closest_on_nav])
		var path := NavigationServer3D.map_get_path(nav_map, global_position, target_position, true)
		if path.size() < 2:
			print("[%s] ERROR: No path found to target!" % unit_name)


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


func show_destination_indicator(target_pos: Vector3) -> void:
	## Show the destination indicator at the target position.
	## Reparents to scene root so it stays stationary while unit moves.
	var indicator := get_node_or_null("DestinationIndicator")
	if not indicator:
		# Check if already reparented to scene root
		indicator = get_tree().current_scene.get_node_or_null("DestinationIndicator_" + str(get_instance_id()))
	if indicator:
		# Reparent to scene root if still our child
		if indicator.get_parent() == self:
			remove_child(indicator)
			indicator.name = "DestinationIndicator_" + str(get_instance_id())
			get_tree().current_scene.add_child(indicator)
		# Position at destination (world space) slightly above terrain
		indicator.global_position = target_pos + Vector3(0, 0.1, 0)
		indicator.visible = true


func hide_destination_indicator() -> void:
	## Hide the destination indicator.
	var indicator := get_node_or_null("DestinationIndicator")
	if not indicator:
		# Check scene root if already reparented
		indicator = get_tree().current_scene.get_node_or_null("DestinationIndicator_" + str(get_instance_id()))
	if indicator:
		indicator.visible = false


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
	## Unit remains selectable but cannot move or receive commands.
	print("[ClickableUnit] ", unit_name, " has died!")

	# Stop all movement and lock position
	_stop_footsteps()
	is_moving = false
	velocity = Vector3.ZERO
	is_animation_locked = true

	# Stop NavigationAgent to prevent any drift
	if navigation_agent:
		navigation_agent.target_position = global_position
		navigation_agent.set_velocity(Vector3.ZERO)

	# Play death animation
	_play_animation("dying")

	# Disable AI behavior tree
	var ai_controller := get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("set_enabled"):
		ai_controller.set_enabled(false)

	# Disable physics processing (movement, gravity, etc.)
	set_physics_process(false)

	# Remove from survivors group (TimeManager won't update stats anymore)
	remove_from_group("survivors")


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


# ============================================================================
# SLED PULLING SYSTEM
# ============================================================================
# Units can attach to and pull sleds. The sled controller handles physics.
# Non-lead pullers automatically follow the lead puller.

## Reference to the sled this unit is currently pulling (null if not pulling)
var attached_sled: Node = null

## Whether this unit is the lead puller (determines navigation)
var is_lead_puller: bool = false

## Lateral offset from leader when in formation (side-by-side pulling)
const SLED_FOLLOW_LATERAL_OFFSET: float = 1.5
## How close follower needs to be to target position before stopping
const SLED_FOLLOW_ARRIVAL: float = 1.0


func attach_to_sled(sled: Node) -> bool:
	## Attach this unit to a sled as a puller.
	## Returns true if successfully attached.
	if attached_sled != null:
		push_warning("[%s] Already attached to a sled" % unit_name)
		return false

	if not sled.has_method("attach_puller"):
		push_warning("[%s] Target is not a valid sled" % unit_name)
		return false

	if sled.attach_puller(self):
		attached_sled = sled
		# Check if we became the lead puller
		if "lead_puller" in sled and sled.lead_puller == self:
			is_lead_puller = true
		print("[%s] Attached to sled as %s" % [unit_name, "lead" if is_lead_puller else "support"])
		return true

	return false


func detach_from_sled() -> void:
	## Detach this unit from its current sled.
	if attached_sled == null:
		return

	if attached_sled.has_method("detach_puller"):
		attached_sled.detach_puller(self)

	print("[%s] Detached from sled" % unit_name)
	attached_sled = null
	is_lead_puller = false


func is_pulling_sled() -> bool:
	## Returns true if this unit is currently attached to and pulling a sled.
	return attached_sled != null


func can_receive_move_command() -> bool:
	## Returns true if this unit can receive direct movement commands.
	## Non-lead sled pullers cannot be commanded directly - they follow the leader.
	if is_pulling_sled() and not is_lead_puller:
		return false
	return true


func _update_sled_follower() -> void:
	## Called each frame for non-lead pullers to follow the lead puller.
	## Positions follower NEXT TO the leader (side-by-side formation), not behind.
	if not is_pulling_sled() or is_lead_puller:
		return

	if attached_sled == null or not "lead_puller" in attached_sled:
		return

	var leader: Node3D = attached_sled.lead_puller
	if leader == null or leader == self:
		return

	# Get leader's forward direction (where they're facing/moving)
	var leader_forward: Vector3 = -leader.global_transform.basis.z.normalized()
	leader_forward.y = 0.0
	if leader_forward.length_squared() < 0.01:
		leader_forward = Vector3.FORWARD
	leader_forward = leader_forward.normalized()

	# Calculate lateral offset direction (perpendicular to leader's facing)
	var lateral_dir: Vector3 = leader_forward.cross(Vector3.UP).normalized()

	# Determine which side this follower should be on based on puller index
	var puller_index: int = 1
	if "pullers" in attached_sled:
		puller_index = attached_sled.pullers.find(self)
		if puller_index < 1:
			puller_index = 1  # Safety: ensure non-zero index for followers

	# Alternate sides: index 1 goes right, index 2 goes left, etc.
	var side: float = 1.0 if (puller_index % 2 == 1) else -1.0
	# Stack further out for more pullers (row 1, 1, 2, 2, 3, 3...)
	var row: int = (puller_index - 1) / 2 + 1
	var lateral_offset: float = SLED_FOLLOW_LATERAL_OFFSET * row * side

	# Slight stagger behind - followers slightly behind leader per row
	var behind_offset: float = 0.3 * row

	# Target position: NEXT TO leader (not at rope distance from harness)
	var follow_pos: Vector3 = leader.global_position + lateral_dir * lateral_offset - leader_forward * behind_offset

	# Check distance to follow position
	var dist_to_follow: float = global_position.distance_to(follow_pos)

	# More aggressive re-triggering with tighter threshold
	if dist_to_follow > 0.5:
		# Always update nav target to track leader movement
		navigation_agent.target_position = follow_pos
		if not is_moving:
			is_moving = true
			_play_animation("walking")
			_start_footsteps()
		_sync_animation_to_leader()
	elif dist_to_follow < 0.3 and is_moving:
		# Very close to target, can stop
		is_moving = false
		velocity = Vector3.ZERO
		_play_animation("idle")
		_stop_footsteps()

	# Always sync animation speed to leader when moving
	if is_moving:
		_sync_animation_to_leader()


func get_nearest_sled(max_distance: float = 10.0) -> Node:
	## Find the nearest sled within max_distance.
	var nearest: Node = null
	var nearest_dist: float = max_distance

	for sled in get_tree().get_nodes_in_group("sleds"):
		var dist: float = global_position.distance_to(sled.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = sled

	return nearest


func get_movement_velocity() -> Vector3:
	## Return current movement velocity for external systems (sled pulling).
	## Returns zero when not actively moving to prevent stale velocity reads.
	if is_moving:
		return velocity
	return Vector3.ZERO


func _get_sled_harness_position() -> Vector3:
	## Get the harness attachment point on the sled (front marker or sled center).
	if attached_sled == null:
		return global_position
	if "sled_front" in attached_sled and attached_sled.sled_front != null:
		return attached_sled.sled_front.global_position
	return attached_sled.global_position


func _get_sled_speed_modifier() -> float:
	## Calculate movement speed modifier based on sled weight.
	## Heavier loads = slower movement. Multiple pullers share the burden.
	if attached_sled == null:
		return 1.0

	# Get sled total weight and number of pullers
	var total_weight: float = 150.0  # Default base
	if attached_sled.has_method("get_total_weight"):
		total_weight = attached_sled.get_total_weight()

	var num_pullers: int = 1
	if "pullers" in attached_sled:
		num_pullers = maxi(attached_sled.pullers.size(), 1)

	# Each puller can comfortably pull ~100kg at full speed
	var comfortable_weight_per_puller: float = 100.0
	var weight_per_puller: float = total_weight / num_pullers

	# Speed modifier: 1.0 at comfortable weight, decreasing as weight increases
	# Minimum 0.3 (30% speed) even for very heavy loads
	var modifier: float = comfortable_weight_per_puller / maxf(weight_per_puller, 1.0)
	return clampf(modifier, 0.3, 1.0)


func _sync_animation_to_leader() -> void:
	## Sync this follower's animation speed to match the leader's effective speed.
	## All pullers should move at the same pace since they're pulling together.
	if attached_sled == null or not "lead_puller" in attached_sled:
		return

	var leader: Node3D = attached_sled.lead_puller
	if leader == null or leader == self:
		return

	# Get leader's effective movement speed (their base speed * sled modifier)
	var leader_speed: float = 1.0
	if "movement_speed" in leader:
		leader_speed = leader.movement_speed

	# Apply sled weight modifier (same as leader experiences)
	var speed_mod: float = _get_sled_speed_modifier()
	var effective_speed: float = leader_speed * speed_mod

	# Cap our speed to not exceed leader's effective speed
	var our_effective_speed: float = minf(movement_speed * speed_mod, effective_speed)

	# Update animation speed to match the capped effective speed
	var time_scale := _get_time_scale()
	if animation_player:
		animation_player.speed_scale = maxf(0.0, base_animation_speed * our_effective_speed * time_scale)

	# Also sync footstep pitch
	if is_instance_valid(_footstep_player):
		var pitch := base_footstep_speed * our_effective_speed * time_scale
		if pitch > 0.01:
			_footstep_player.pitch_scale = pitch


func _is_rope_taut() -> bool:
	## Check if rope is at max tension (used by rope visual for taut appearance).
	if attached_sled == null:
		return false
	var rope_len: float = attached_sled.rope_length if "rope_length" in attached_sled else 2.0
	var harness_pos: Vector3 = _get_sled_harness_position()
	return global_position.distance_to(harness_pos) >= rope_len * 0.8
