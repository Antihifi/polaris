class_name ClickableUnit extends CharacterBody3D
## Simple click-to-move unit for RTS-style control.
## Uses NavigationAgent3D for pathfinding.
## Includes survival stats for gameplay.

signal selected
signal deselected
signal reached_destination
signal stats_changed  # Emitted when stats are updated
signal inventory_changed  # Emitted when unit inventory contents change
signal discovered(unit: Node)  # Emitted when errant unit is recruited

## Unit ranks - determines control mode and UI display
enum UnitRank { MAN, OFFICER, CAPTAIN }

@export_category("Identity")
@export var unit_name: String = "Survivor"
@export var rank: UnitRank = UnitRank.MAN

## Discovery state - errant units start undiscovered (not in roster)
@export var is_discovered: bool = true

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
## Sled pulling component (optional child node)
var sled_puller: Node = null  # SledPullerComponent

# Footstep audio (3D positional)
var footstep_sound: AudioStream = preload("res://sounds/snow-walk-1.mp3")
var _footstep_player: AudioStreamPlayer3D

# Discovery UI popup
var _man_found_scene: PackedScene = preload("res://ui/man_found.tscn")

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

## Leash system - restricts AI movement to area around camp (for errant groups)
@export var leash_center: Vector3 = Vector3.INF
@export var leash_radius: float = 20.0


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
	# Only discovered units appear in roster - errant groups must be found first
	if is_discovered:
		add_to_group("selectable_units")
	add_to_group("survivors")  # For TimeManager needs updates (even undiscovered)

	# Captain and discovered officers can discover errant units
	if rank == UnitRank.CAPTAIN or (rank == UnitRank.OFFICER and is_discovered):
		_setup_discovery_area()

	# Get TimeManager reference for time scale
	_time_manager = get_node_or_null("/root/TimeManager")
	if _time_manager and _time_manager.has_signal("time_scale_changed"):
		_time_manager.time_scale_changed.connect(_on_time_scale_changed)

	# Setup inventory
	_setup_inventory()

	# Get sled puller component if present
	sled_puller = get_node_or_null("SledPullerComponent")


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

	# =========================================================================
	# SLED PULLING BEHAVIOR
	# Support pullers bypass navigation - they just mirror the leader
	# =========================================================================
	if sled_puller and sled_puller.should_follow_leader():
		sled_puller.follow_leader(delta)
		return

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

			# Rotate towards movement direction
			var target_rotation := atan2(velocity_xz.x, velocity_xz.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

			# Drain energy while walking (delta is already scaled by Engine.time_scale)
			_drain_walking_energy(delta)

	# Terrain floor check - handle BEFORE physics for undiscovered units
	# DYNAMIC_GAME mode only generates collision near camera, so errant units have no floor
	var terrain := _find_terrain3d()
	var terrain_height: float = NAN
	if terrain and "data" in terrain and terrain.data:
		terrain_height = terrain.data.get_height(global_position)

	# Undiscovered units: snap to terrain, skip physics (no collision available)
	if not is_discovered and is_finite(terrain_height):
		global_position.y = terrain_height
		velocity.y = 0  # No gravity for snapped units
	else:
		# Apply gravity (required for move_and_slide to handle slopes - from Terrain3D demo)
		velocity.y -= 40.0 * delta

	# Use avoidance if enabled, otherwise move directly
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(velocity)
	else:
		_on_velocity_computed(velocity)

	# Post-physics terrain safety net for discovered units
	# Only correct if we've fallen below terrain (don't fight slopes going up)
	if is_discovered and is_finite(terrain_height):
		if global_position.y < terrain_height - 0.1:  # Small tolerance to avoid jitter
			global_position.y = terrain_height


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	# Skip movement during locked animations (sitting, sleeping, etc.)
	if is_animation_locked:
		return
	# Skip avoidance for support pullers - they mirror leader only
	if sled_puller and sled_puller.should_follow_leader():
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
	## Dead and undiscovered units cannot move.
	if is_dead:
		return
	if not is_discovered:
		return

	# Clear any leftover animation lock from aborted BT sequences
	# (e.g., BTDynamicSelector aborting SitOnCrate mid-animation)
	is_animation_locked = false

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


func update_needs(delta_hours: float, in_shelter: bool, near_fire: bool, ambient_temp: float, in_sunlight: bool = true, is_blizzard: bool = false) -> void:
	## Called by TimeManager each in-game hour to update survival needs.
	if not stats:
		return

	var is_working := is_moving  # For now, moving counts as working
	var in_bed := is_in_bed()  # Check if sleeping in actual bed for 2X bonus
	stats.apply_hourly_decay(is_working, in_shelter, in_bed, near_fire, ambient_temp, in_sunlight, is_blizzard)
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


# --- Discovery System (Errant Groups) ---

func _setup_discovery_area() -> void:
	## Add DiscoveryArea to captain/officers for recruiting errant units.
	var discovery_area := DiscoveryArea.new()
	discovery_area.name = "DiscoveryArea"
	discovery_area.discovery_radius = 15.0  # GDD: 10-15m recruitment range
	add_child(discovery_area)


func discover() -> void:
	## Called when a captain/officer comes within recruitment range.
	## Adds unit to selectable_units group and UI roster.
	if is_discovered:
		return

	is_discovered = true
	add_to_group("selectable_units")
	clear_leash()  # Free unit from camp restriction

	# If this is an officer, transition from AI to player control
	if rank == UnitRank.OFFICER:
		_transition_to_player_control()
		# Officers can now discover other errant units
		_setup_discovery_area()

	# Show discovery UI popup
	_show_discovery_popup()

	discovered.emit(self)
	print("[ClickableUnit] %s has been discovered and recruited!" % unit_name)


func _transition_to_player_control() -> void:
	## Remove AI controller from officer when discovered.
	## Officers become directly controllable like captain.
	var ai_controller := get_node_or_null("ManAIController")
	if ai_controller:
		ai_controller.queue_free()
		print("[ClickableUnit] %s transitioned to player control" % unit_name)


func _show_discovery_popup() -> void:
	## Show "MAN FOUND" UI popup that floats up and fades out.
	var camera := get_viewport().get_camera_3d()
	if not camera:
		return

	# Create popup instance
	var popup: Control = _man_found_scene.instantiate()

	# Set the unit's name in the label
	var label: Label = popup.get_node_or_null("Name/MarginContainer/Label")
	if label:
		label.text = "%s FOUND" % unit_name.to_upper()

	# Add to viewport as overlay
	get_tree().current_scene.add_child(popup)

	# Position popup above unit's head (0.25m above)
	var start_world_pos := global_position + Vector3(0, 2.25, 0)  # ~2m character height + 0.25m
	var start_screen_pos := camera.unproject_position(start_world_pos)

	# Get the Name panel and position it
	var panel: Control = popup.get_node_or_null("Name")
	if panel:
		panel.position = start_screen_pos - panel.size / 2.0

	# Create tween for float-up and fade-out animation (3 seconds)
	var tween := popup.create_tween()
	tween.set_parallel(true)

	# Float up animation - move panel upward on screen
	if panel:
		var end_screen_y := panel.position.y - 100.0  # Float up 100 pixels
		tween.tween_property(panel, "position:y", end_screen_y, 3.0).set_ease(Tween.EASE_OUT)

	# Fade out animation using self_modulate alpha
	tween.tween_property(popup, "modulate:a", 0.0, 3.0).set_ease(Tween.EASE_IN)

	# Queue free after animation completes
	tween.chain().tween_callback(popup.queue_free)


# --- Leash System (Errant Groups) ---

func is_leashed() -> bool:
	## Returns true if unit is restricted to a camp area.
	return leash_center != Vector3.INF


func clear_leash() -> void:
	## Remove camp restriction.
	leash_center = Vector3.INF


func is_within_leash(target_pos: Vector3) -> bool:
	## Check if target position is within leash radius.
	## Returns true if not leashed or if target is within bounds.
	if not is_leashed():
		return true
	return leash_center.distance_to(target_pos) <= leash_radius


func get_leash_constrained_position(target_pos: Vector3) -> Vector3:
	## Return position clamped to leash boundary.
	## If target is outside leash, returns closest point on boundary.
	if not is_leashed():
		return target_pos

	var to_target := target_pos - leash_center
	var distance := to_target.length()

	if distance <= leash_radius:
		return target_pos

	# Clamp to boundary
	return leash_center + to_target.normalized() * leash_radius


# --- AI Integration ---

func _clear_player_command() -> void:
	## Clears the player command flag in the AI controller when destination reached.
	var ai_controller: Node = get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("set_player_command_active"):
		ai_controller.set_player_command_active(false)


func get_current_action() -> String:
	## Returns the current action for UI display.
	## AI-controlled units (Men) delegate to ManAIController.
	## Player-controlled units (Officers/Captain) check movement state.
	var ai_controller: Node = get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("get_current_action"):
		return ai_controller.get_current_action()

	# Player-controlled units: check movement state
	if is_moving:
		return "Moving to a point"
	if is_pulling_sled():
		return "Attached to sled"
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
# SLED ATTACHMENT SYSTEM (delegated to SledPullerComponent)
# ============================================================================
# Sled pulling is handled by optional SledPullerComponent child node.
# These methods delegate to the component for backwards compatibility.

## Formation offset when pulling as support (set by SledController)
var sled_formation_offset: Vector3 = Vector3.ZERO:
	get:
		return sled_puller.sled_formation_offset if sled_puller else Vector3.ZERO
	set(value):
		if sled_puller:
			sled_puller.sled_formation_offset = value


var attached_sled: Node:
	get:
		return sled_puller.attached_sled if sled_puller else null


func attach_to_sled(sled: Node) -> bool:
	## Attach this unit to a sled as a puller.
	if sled_puller:
		return sled_puller.attach_to_sled(sled)
	push_warning("[%s] No SledPullerComponent - cannot attach to sled" % unit_name)
	return false


func detach_from_sled() -> void:
	## Detach this unit from its current sled.
	if sled_puller:
		sled_puller.detach_from_sled()


func is_pulling_sled() -> bool:
	## Returns true if this unit is currently attached to and pulling a sled.
	return sled_puller != null and sled_puller.is_pulling()


func can_receive_move_command() -> bool:
	## Returns true if this unit can receive direct movement commands.
	## Undiscovered units cannot be commanded until recruited.
	## Non-lead sled pullers cannot be commanded directly - they follow the leader.
	if not is_discovered:
		return false
	if sled_puller and sled_puller.is_support_puller():
		return false
	return true


func get_nearest_sled(max_distance: float = 10.0) -> Node:
	## Find the nearest sled within max_distance.
	if sled_puller:
		return sled_puller.get_nearest_sled(max_distance)
	# Fallback if no component
	var nearest: Node = null
	var nearest_dist: float = max_distance
	for sled in get_tree().get_nodes_in_group("sleds"):
		var dist: float = global_position.distance_to(sled.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = sled
	return nearest


func get_movement_velocity() -> Vector3:
	## Return current movement velocity for external systems.
	if is_moving:
		return velocity
	return Vector3.ZERO


# ============================================================================
# BARK SYSTEM (flavor dialog)
# ============================================================================

## Cached BarkManager reference
var _bark_manager: Node = null

func bark(category: String, duration: float = -1.0) -> bool:
	## Show a random bark from category above this unit.
	## Returns false if on cooldown or BarkManager unavailable.
	if not _bark_manager:
		_bark_manager = get_node_or_null("/root/BarkManager")
	if _bark_manager:
		return _bark_manager.bark(self, category, duration)
	return false


func bark_text(text: String, duration: float = -1.0) -> bool:
	## Show specific bark text above this unit.
	## Returns false if on cooldown or BarkManager unavailable.
	if not _bark_manager:
		_bark_manager = get_node_or_null("/root/BarkManager")
	if _bark_manager:
		return _bark_manager.bark_specific(self, text, duration)
	return false


func bark_now(text: String, duration: float = -1.0) -> void:
	## Show bark immediately, ignoring cooldown.
	## Use for important events (discovery, etc.)
	if not _bark_manager:
		_bark_manager = get_node_or_null("/root/BarkManager")
	if _bark_manager:
		_bark_manager.bark_immediate(self, text, duration)
