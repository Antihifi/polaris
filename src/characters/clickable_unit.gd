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
## Slope penalty curve: X = slope angle (0-60° mapped to 0-1), Y = speed multiplier
@export var slope_penalty_curve: Curve
## Speed multiplier (set by BT for carrying penalty, etc.)
var speed_multiplier: float = 1.0

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
var _weather_controller_cache: Node = null  # Cached DynamicWeatherController
var _terrain_mod_cache: float = 1.0  # Cached terrain/stat modifier for animation sync
var _last_nav_warning_target: Vector3 = Vector3.INF  # Rate-limit nav warnings
var _nav_finish_warned: bool = false  # Only warn once per navigation attempt

## Auto-unstick system: detects when unit is moving but not making progress
var _stuck_check_interval: float = 0.5  # Check every 0.5 seconds
var _stuck_check_timer: float = 0.0
var _stuck_last_position: Vector3 = Vector3.INF
var _stuck_no_progress_time: float = 0.0  # Accumulated time without progress
const STUCK_THRESHOLD_DISTANCE: float = 0.3  # Must move at least this far per check
const STUCK_TIMEOUT: float = 2.0  # Auto-nudge after this many seconds stuck
const STUCK_NUDGE_HEIGHT: float = 0.3  # How high to lift when nudging
const STUCK_NUDGE_HORIZONTAL: float = 0.5  # Max horizontal displacement

## Animation offset (0-1) to desync animations between units
var animation_offset: float = 0.0

## Unit inventory (3x3 grid)
var inventory: Inventory = null
var _inventory_protoset: JSON = null
const INVENTORY_GRID_SIZE := Vector2i(3, 3)

## Warmth/shelter tracking (populated by Area3D enter/exit signals)
var _active_heat_sources: Array[Node] = []  # WarmthArea nodes currently in range
var _current_shelter: Node = null  # ShelterArea node if inside shelter

## Trait system
var traits: Array[SurvivorTrait] = []

## Morale aura tracking (set by MoraleAura Area3D enter/exit signals)
var _in_captain_aura: bool = false
var _in_personable_aura: bool = false

## Aurora morale buff (set when aurora event fires, counts down over time)
var _aurora_morale_buff_active: bool = false
var _aurora_buff_hours_remaining: float = 0.0

## Butchering horror (indefinite morale decay until counteracted)
var _butchering_horror_active: bool = false

## Destination indicator tracking
var _reparented_destination_indicator: Node3D = null

## Leash system - restricts AI movement to area around camp (for errant groups)
@export var leash_center: Vector3 = Vector3.INF
@export var leash_radius: float = 20.0

## Combat system - delegates to CombatComponent
## These signals forward from CombatComponent for backwards compatibility
signal combat_started(target: Node3D)
signal combat_ended
signal took_damage(amount: float, attacker: Node3D)

## CombatComponent handles combat state; set in _ready()
var combat: CombatComponent = null

var _is_fleeing: bool = false
var _last_attacker: Node3D = null  ## For auto-defend (men only)

## Computed properties delegate to CombatComponent
var _combat_target: Node3D:
	get: return combat.combat_target if combat else null
	set(value):
		if combat:
			combat.combat_target = value

var combat_target: Node3D:
	get: return combat.combat_target if combat else null

var _is_in_combat: bool:
	get: return combat.is_in_combat if combat else false
	set(value):
		if combat and value:
			combat.is_in_combat = value
		elif combat and not value:
			combat.stop_combat()

var is_in_combat: bool:
	get: return combat.is_in_combat if combat else false

var is_fleeing: bool:
	get: return _is_fleeing

var last_attacker: Node3D:
	get: return _last_attacker

## Mental break system
signal mental_break_started(break_type: int)
signal mental_break_ended

enum MentalBreakType { NONE, BERSERK, WENDIGO }
var _mental_break: MentalBreakType = MentalBreakType.NONE

var is_berserk: bool:
	get: return _mental_break == MentalBreakType.BERSERK

var is_wendigo: bool:
	get: return _mental_break == MentalBreakType.WENDIGO

var mental_break_type: MentalBreakType:
	get: return _mental_break


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
		# Override standing animations when legs are missing
		animation_player.animation_started.connect(_on_animation_started)

	#REFACTOR: This works well but should be a node component in editor.
	# Create 3D positional footstep audio player
	_footstep_player = AudioStreamPlayer3D.new()
	_footstep_player.stream = footstep_sound
	_footstep_player.volume_db = linear_to_db(footstep_volume)
	_footstep_player.max_distance = footstep_max_distance
	_footstep_player.unit_size = footstep_unit_size
	_footstep_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	add_child(_footstep_player)
	_footstep_player.finished.connect(_on_footstep_finished)

	#REFACTOR: No reason not to be adding to groups in editor
	# Add to groups for easy querying
	# Only discovered units appear in roster - errant groups must be found first
	if is_discovered:
		add_to_group("selectable_units")
	add_to_group("survivors")  # For TimeManager needs updates (even undiscovered)

	# Captain and discovered officers can discover errant units
	if rank == UnitRank.CAPTAIN or (rank == UnitRank.OFFICER and is_discovered):
		_setup_discovery_area()

	#REFACTOR: No reason not to just have the controller in editor, this is so unnecessary...
	# Add passive AI for player-controlled units (Captain, discovered Officers)
	# Men have ManAIController; undiscovered officers get PassiveAI when discovered
	if _should_have_passive_ai():
		call_deferred("_add_passive_ai_controller")

	# Get TimeManager reference for time scale
	_time_manager = get_node_or_null("/root/TimeManager")
	if _time_manager and _time_manager.has_signal("time_scale_changed"):
		_time_manager.time_scale_changed.connect(_on_time_scale_changed)

	# Setup inventory
	_setup_inventory()

	# Get sled puller component if present
	sled_puller = get_node_or_null("SledPullerComponent")

	#REFACTOR: We don't need backward compatibility for anything, we're not in a live enviromonet and I'm a solo dev
	# Get CombatComponent and forward signals for backwards compatibility
	combat = get_node_or_null("CombatComponent")
	if combat:
		combat.external_stats = stats  # Delegate health to SurvivorStats
		combat.combat_started.connect(func(t): combat_started.emit(t))
		combat.combat_ended.connect(func(): combat_ended.emit())
		combat.took_damage.connect(func(a, b): took_damage.emit(a, b))
		combat.died.connect(_on_combat_death)  # Trigger death animation immediately
	else:
		push_warning("[ClickableUnit] %s missing CombatComponent - combat won't work" % unit_name)

	# Connect to dismemberment signal for collapse-to-crawl transition
	var dc := get_node_or_null("DismembermentComponent")
	if dc and dc.has_signal("limb_dismembered"):
		dc.limb_dismembered.connect(_on_limb_dismembered)

	#REFACTOR: not sure what this is, have never used it once
func _unhandled_input(event: InputEvent) -> void:
	# F9 toggles debug physics mode (bypasses navigation)
	if event is InputEventKey and event.pressed and event.keycode == KEY_F9:
		debug_bypass_navigation = not debug_bypass_navigation
		print("[%s] DEBUG MODE: %s (F9 toggle)" % [unit_name, "ON - walking forward only" if debug_bypass_navigation else "OFF - using navigation"])
		get_viewport().set_input_as_handled()

	#REFACTOR: This is an absolute disaster and could be a huge performance hit, this is a lot for physics_process, 
	#do NOT break anything but optimize, streamline, eliminate redundancies, deprecate and archive out no longer 
	# needed/solved debug (navigation and collision, make an archive directory for this so we have documentation to fall back on should issues reoccur
func _physics_process(delta: float) -> void:
	# Align selection indicator to terrain slope (before early returns so idle units align too)
	if is_selected:
		var sel_indicator := get_node_or_null("SelectionIndicator")
		if sel_indicator and sel_indicator.visible:
			_align_indicator_to_terrain(sel_indicator, global_position)

	# Skip physics during locked animations (sitting, sleeping)
	if is_animation_locked:
		return

	# Safety: Ensure death is processed even if take_damage() somehow didn't trigger it
	if stats and stats.health <= 0.0 and not is_dead:
		stats.dying_cause = SurvivorStats.DeathCause.VIOLENCE
		_on_death()
		return

	# =========================================================================
	# COMBAT - Handled by PassiveAIController behavior tree (passive_bt.tres)
	# BT tasks: BTFindEnemy -> BTHasCombatTarget -> BTAttack -> BTChaseToAttackRange -> BTDealDamage
	# =========================================================================

	# Auto-end combat if target is dead or invalid (hides health bar)
	if combat and combat.is_in_combat:
		var target := combat.combat_target
		if not target or not is_instance_valid(target):
			stop_combat()
		elif _is_target_dead(target):
			stop_combat()

	# =========================================================================
	# SLED PULLING BEHAVIOR
	# Support pullers bypass navigation - they just mirror the leader
	# =========================================================================
	if sled_puller and sled_puller.should_follow_leader():
		sled_puller.follow_leader(delta)
		return

	if not is_moving:
		# Reset speed multiplier when idle
		if speed_multiplier != 1.0 and not _is_encumbered():
			speed_multiplier = 1.0
			_update_speed_scale()
		return

	# Update speed multiplier for encumbrance (sled pulling or carrying)
	_update_encumbrance_speed()

	# =========================================================================
	# DEBUG MODE: Bypass navigation, walk in facing direction
	# Used to isolate PHYSICS vs NAVIGATION issues
	# =========================================================================
	if debug_bypass_navigation:
		# Walk in current facing direction (no pathfinding)
		var forward: Vector3 = -global_transform.basis.z.normalized()
		forward.y = 0.0
		var debug_crawl: float = 1.0
		if legs_remaining < 2:
			debug_crawl = 0.075 if legs_remaining == 0 else 0.15
		velocity.x = forward.x * movement_speed * debug_crawl
		velocity.z = forward.z * movement_speed * debug_crawl

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
			if dist_to_target > 5.0 and not _nav_finish_warned:
				print("[%s] NAV FINISHED but %.1fm from target! Pos: %s Target: %s" % [
					unit_name, dist_to_target, global_position, navigation_agent.target_position])
				_nav_finish_warned = true
			velocity.x = 0.0
			velocity.z = 0.0
			is_moving = false
			# Stay in carry pose if still carrying, otherwise idle
			if not is_carrying():
				_play_animation("idle")
			_stop_footsteps()
			hide_destination_indicator()
			reached_destination.emit()
		else:
			var next_pos: Vector3 = navigation_agent.get_next_path_position()
			var dist_to_next := global_position.distance_to(next_pos)

			# Compute terrain/stat movement modifier
			var stat_mult: float = stats.get_work_efficiency() if stats else 1.0
			var slope_mult: float = _get_slope_modifier()
			var weather_ctrl := _find_weather_controller()
			var weather_mult: float = weather_ctrl.get_movement_penalty(velocity) if weather_ctrl else 1.0
			_terrain_mod_cache = maxf(0.25, stat_mult * slope_mult * weather_mult)

			# Note: Engine.time_scale handles speed scaling via move_and_slide() delta
			# Crawl penalty: independent of speed_multiplier (which is owned by encumbrance system)
			var crawl_penalty: float = 1.0
			if legs_remaining < 2:
				crawl_penalty = 0.075 if legs_remaining == 0 else 0.15
			var velocity_xz := (next_pos - global_position).normalized() * movement_speed * speed_multiplier * crawl_penalty * _terrain_mod_cache
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

	# Auto-unstick detection: check if we're moving but not making progress
	_check_auto_unstick(delta)

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


func _on_navigation_finished() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	_stop_footsteps()
	hide_destination_indicator()
	reached_destination.emit()
	_clear_player_command()

## 	#REFACTOR: Move this to archive

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

	#REFACTOR: Is this necessary?  Determine the RIGHT method and eliminate unneded fallback
func _find_node_by_class(node: Node, class_name_str: String) -> Node:
	## Recursively find node by class name.
	if node.get_class() == class_name_str:
		return node
	for child in node.get_children():
		var result := _find_node_by_class(child, class_name_str)
		if result:
			return result
	return null


func _find_weather_controller() -> Node:
	## Find DynamicWeatherController (cached).
	if _weather_controller_cache and is_instance_valid(_weather_controller_cache):
		return _weather_controller_cache
	var root := get_tree().current_scene
	if root:
		var nodes := root.find_children("*", "DynamicWeatherController", true, false)
		if nodes.size() > 0:
			_weather_controller_cache = nodes[0]
	return _weather_controller_cache



#REFACTOR: All of these movement functions should completely be it's own move system component, AND should rely MUCH more on LimboAI BTs....
func _get_slope_modifier() -> float:
	## Get speed multiplier based on terrain slope. Uses exported curve.
	var terrain := _find_terrain3d()
	if not terrain or not "data" in terrain or not terrain.data:
		return 1.0
	var normal: Vector3 = terrain.data.get_normal(global_position)
	if is_nan(normal.x) or normal.length_squared() < 0.5:
		return 1.0
	var slope_deg: float = rad_to_deg(acos(clampf(normal.dot(Vector3.UP), 0.0, 1.0)))
	if slope_penalty_curve:
		return slope_penalty_curve.sample(clampf(slope_deg / 60.0, 0.0, 1.0))
	# Fallback if no curve: linear penalty above 15 degrees
	return lerpf(1.0, 0.3, clampf((slope_deg - 15.0) / 45.0, 0.0, 1.0))


func move_to(target_position: Vector3, is_combat_chase: bool = false, skip_animation: bool = false) -> void:
	## Navigate to target position.
	## Dead and undiscovered units cannot move.
	## is_combat_chase: if true, don't disengage combat (used by BTChaseToAttackRange).
	## skip_animation: if true, don't set walking animation (let BT handle it).
	if is_dead:
		return
	if not is_discovered:
		return
	if not can_move:
		return

	# Disengage combat when receiving regular movement command (not combat chase)
	if _is_in_combat and not is_combat_chase:
		stop_combat()

	# Clear any leftover animation lock from aborted BT sequences
	# (e.g., BTDynamicSelector aborting SitOnCrate mid-animation)
	is_animation_locked = false

	# Reset nav warning flag for new navigation attempt
	_nav_finish_warned = false

	navigation_agent.target_position = target_position
	is_moving = true
	# Set animation unless BT is handling it
	if not skip_animation:
		if is_carrying():
			_play_animation("carry_walk")
		else:
			_play_animation("walking")
	_start_footsteps()
	_update_speed_scale()

	# Debug: Log path info to diagnose NavMesh issues (rate-limited per unique target)
	# PERF: Only run expensive nav queries for NEW targets (not every tick during chase)
	if target_position.distance_to(_last_nav_warning_target) > 0.5:
		var nav_map := navigation_agent.get_navigation_map()
		if nav_map.is_valid():
			var closest_on_nav := NavigationServer3D.map_get_closest_point(nav_map, target_position)
			var snap_distance := target_position.distance_to(closest_on_nav)
			if snap_distance > 1.0:
				_last_nav_warning_target = target_position
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
	# Crawling units: pause in place (no idle-on-ground animation exists)
	if legs_remaining < 2:
		if animation_player:
			animation_player.pause()
	elif not is_carrying():
		_play_animation("idle")
	_stop_footsteps()
	# Reset stuck tracking
	_stuck_no_progress_time = 0.0
	_stuck_last_position = Vector3.INF


func _check_auto_unstick(delta: float) -> void:
	## Auto-unstick detection for Officers and Captain only.
	## Men use BT-based stuck detection in bt_move_to_blackboard.gd.
	if rank == UnitRank.MAN:
		return
	# Crawling units move too slowly to meet the stuck threshold — skip
	if legs_remaining < 2:
		return
	if not is_moving:
		_stuck_no_progress_time = 0.0
		_stuck_last_position = Vector3.INF
		return

	_stuck_check_timer += delta
	if _stuck_check_timer < _stuck_check_interval:
		return
	_stuck_check_timer = 0.0

	# First check - initialize position
	if _stuck_last_position == Vector3.INF:
		_stuck_last_position = global_position
		return

	# Check distance moved since last check
	var distance_moved: float = global_position.distance_to(_stuck_last_position)
	_stuck_last_position = global_position

	if distance_moved < STUCK_THRESHOLD_DISTANCE:
		_stuck_no_progress_time += _stuck_check_interval
		if _stuck_no_progress_time >= STUCK_TIMEOUT:
			print("[%s] Auto-unstick triggered after %.1fs with no progress" % [unit_name, _stuck_no_progress_time])
			_perform_subtle_nudge()
			_stuck_no_progress_time = 0.0
	else:
		# Making progress, reset timer
		_stuck_no_progress_time = 0.0


func _perform_subtle_nudge() -> void:
	## Subtle nudge to unstick: small vertical lift + random horizontal displacement.
	## Used by auto-unstick system.
	var nudge_offset := Vector3(
		randf_range(-STUCK_NUDGE_HORIZONTAL, STUCK_NUDGE_HORIZONTAL),
		STUCK_NUDGE_HEIGHT,
		randf_range(-STUCK_NUDGE_HORIZONTAL, STUCK_NUDGE_HORIZONTAL)
	)
	global_position += nudge_offset
	# Re-request navigation to same target to get fresh path
	if navigation_agent.target_position != Vector3.ZERO:
		var target := navigation_agent.target_position
		navigation_agent.target_position = global_position  # Reset
		call_deferred("move_to", target)  # Re-navigate next frame


func nudge(aggressive: bool = false) -> void:
	## Manual nudge to unstick unit. Called by UI UNSTUCK button.
	## aggressive=false: subtle nudge (0.3m up, 0.5m horizontal)
	## aggressive=true: strong nudge (1m up, 1m horizontal)
	var height: float = 1.0 if aggressive else STUCK_NUDGE_HEIGHT
	var horizontal: float = 1.0 if aggressive else STUCK_NUDGE_HORIZONTAL

	var nudge_offset := Vector3(
		randf_range(-horizontal, horizontal),
		height,
		randf_range(-horizontal, horizontal)
	)
	global_position += nudge_offset
	print("[%s] Manual nudge applied (aggressive=%s)" % [unit_name, aggressive])

	# Reset stuck tracking
	_stuck_no_progress_time = 0.0
	_stuck_last_position = Vector3.INF

	# Re-request navigation if we were moving
	if is_moving and navigation_agent.target_position != Vector3.ZERO:
		var target := navigation_agent.target_position
		navigation_agent.target_position = global_position
		call_deferred("move_to", target)


	#REFACTOR: Should completely be it's own combat system component, what is the combat component even FOR?!?!?  or the BTs in LimboAI!??!?!
# --- Combat System ---

func attack_target(target: Node3D) -> void:
	## Start attacking a target. Sets blackboard var for BT to handle combat.
	## Combat sequence (chase, animate, damage) is handled by passive_bt.tres.
	if not target or not is_instance_valid(target):
		return
	if stats and stats.is_dead():
		return
	if not combat:
		push_error("[ClickableUnit] %s has no CombatComponent!" % unit_name)
		return

	combat.start_combat(target)
	_is_fleeing = false

	# Set blackboard vars for PassiveAIController BT to pick up
	# Clear flee state (threat data) so Combat BT branch can run
	# NOTE: player_command_active must be false — otherwise PlayerOverride
	# wins in the BTSelector and the Combat branch never executes
	var ai: Node = get_node_or_null("PassiveAIController")
	if ai and ai.has_method("get_blackboard"):
		var bb: Blackboard = ai.get_blackboard()
		if bb:
			bb.set_var(&"combat_target", target)
			bb.set_var(&"player_command_active", false)
			bb.set_var(&"threat_target", null)
			bb.set_var(&"threat_position", Vector3.INF)

	# Face the target
	var dir := (target.global_position - global_position).normalized()
	if dir.length_squared() > 0.01:
		rotation.y = atan2(dir.x, dir.z)


func take_damage(amount: float, attacker: Node3D = null) -> void:
	## Receive combat damage. Called by attacker's _perform_attack().
	if not stats or stats.is_dead():
		return

	# Apply damage via CombatComponent (emits took_damage signal)
	if combat:
		combat.take_damage(amount, attacker)
		# Explicitly emit health_changed for health bar updates (SurvivorStats max is always 100)
		combat.health_changed.emit(stats.health, 100.0)
	else:
		# Fallback if no CombatComponent
		stats.health = maxf(0.0, stats.health - amount)
		took_damage.emit(amount, attacker)

	# Track attacker for auto-defend (men only)
	if attacker and is_instance_valid(attacker):
		_last_attacker = attacker

	# Check if we should flee
	if _check_flee():
		_start_flee()
		return

	# Check for death
	if stats.health <= 0.0:
		stats.dying_cause = SurvivorStats.DeathCause.VIOLENCE
		_on_death()
		return

	stats_changed.emit()


func stop_combat() -> void:
	## End combat state and return to idle.
	if not is_in_combat:
		return

	if combat:
		combat.stop_combat()  # Emits combat_ended signal
	_is_fleeing = false
	_last_attacker = null

	# Unequip weapon back to back
	var equipment = get_node_or_null("EquipmentAnimationComponent")
	if equipment and equipment.weapon_equipped:
		equipment.move_to_back()

	# Clear blackboard combat target
	var ai: Node = get_node_or_null("PassiveAIController")
	if ai and ai.has_method("get_blackboard"):
		var bb: Blackboard = ai.get_blackboard()
		if bb:
			bb.set_var(&"combat_target", null)

	stop()


func get_equipped_weapon() -> WeaponStats:
	## Returns the best weapon in inventory, or unarmed if none.
	if inventory:
		if inventory.has_item_with_prototype_id("hatchet"):
			return WeaponDatabase.get_weapon(&"hatchet")
		if inventory.has_item_with_prototype_id("knife"):
			return WeaponDatabase.get_weapon(&"knife")
	return WeaponDatabase.get_unarmed()


func get_damage_modifier() -> float:
	## Returns total damage modifier from traits (multiplicative).
	var modifier: float = 1.0
	for t: SurvivorTrait in traits:
		modifier *= t.damage_modifier
	return modifier


func _is_target_dead(target: Node3D) -> bool:
	## Check if combat target is dead (works for both units and animals).
	if "is_dead" in target and target.is_dead:
		return true
	if "stats" in target and target.stats and target.stats.has_method("is_dead"):
		return target.stats.is_dead()
	return false


func _check_flee() -> bool:
	## Check if unit should flee based on health and traits.
	if not stats:
		return false

	var health_pct := stats.health / 100.0

	# Combative trait: never flee
	for t: SurvivorTrait in traits:
		if t.damage_modifier > 1.0:  # Combative has 1.3x damage
			return false

	# Coward trait: flee at 50% HP
	for t: SurvivorTrait in traits:
		if t.flees_combat and health_pct < 0.5:
			return true

	# Default: flee at 15% HP
	return health_pct < 0.15


func _start_flee() -> void:
	## Begin fleeing from combat.
	if _is_fleeing:
		return

	_is_fleeing = true
	_is_in_combat = false

	# Flee away from combat target
	if _combat_target and is_instance_valid(_combat_target):
		var flee_dir := (global_position - _combat_target.global_position).normalized()
		var flee_target := global_position + flee_dir * 30.0
		move_to(flee_target)

	_combat_target = null
	combat_ended.emit()

#REFACTOR: mental break system should be BTs in LimboAI...
# --- Mental Break System ---

func trigger_mental_break(break_type: MentalBreakType) -> void:
	## Trigger a violent mental break (Berserk or Wendigo).
	if _mental_break != MentalBreakType.NONE:
		return  # Already broken

	_mental_break = break_type
	mental_break_started.emit(break_type)

	match break_type:
		MentalBreakType.BERSERK:
			print("[%s] has gone BERSERK!" % unit_name)
		MentalBreakType.WENDIGO:
			print("[%s] has become a WENDIGO!" % unit_name)

	# Broken units attack nearby survivors via BT
	# The BT will handle finding targets and attacking


func end_mental_break() -> void:
	## End the mental break state (morale recovered or subdued).
	if _mental_break == MentalBreakType.NONE:
		return

	print("[%s] mental break ended" % unit_name)
	_mental_break = MentalBreakType.NONE
	stop_combat()
	mental_break_ended.emit()


func check_mental_break() -> void:
	## Check if unit should enter a mental break state.
	## Called periodically (e.g., hourly by TimeManager).
	if not stats:
		return
	if stats.is_dead():
		return
	if _mental_break != MentalBreakType.NONE:
		# Already broken - check for recovery
		if stats.morale >= 35.0:
			end_mental_break()
		return

	# Only check if morale is critically low
	if stats.morale >= 25.0:
		return

	# Calculate break chance
	var break_chance: float = 0.10  # 10% base per check

	# +5% per additional critical stat
	if stats.hunger < 25.0:
		break_chance += 0.05
	if stats.warmth < 25.0:
		break_chance += 0.05
	if stats.energy < 25.0:
		break_chance += 0.05

	# Trait modifiers
	if has_trait("combative"):
		break_chance += 0.10
	if has_trait("leader"):
		break_chance -= 0.05

	break_chance = clampf(break_chance, 0.0, 0.5)

	# Roll for break
	if randf() < break_chance:
		# Determine break type based on hunger
		if stats.hunger <= 0.0:
			trigger_mental_break(MentalBreakType.WENDIGO)
		else:
			trigger_mental_break(MentalBreakType.BERSERK)


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
		if show:
			_align_indicator_to_terrain(indicator, global_position)

#REFACTOR: All indicator systems should be in it's own component, perhaps extending the Mesh3D SelectionIndicator node, should have never been this many functions in here...
func _align_indicator_to_terrain(indicator: Node3D, world_pos: Vector3) -> void:
	## Align a flat disc indicator's Y axis to terrain surface normal.
	## Uses global_transform.basis so parent rotation (unit yaw) doesn't interfere.
	var terrain := _find_terrain3d()
	if not terrain or not "data" in terrain or not terrain.data or not terrain.data.has_method("get_normal"):
		return
	var normal: Vector3 = terrain.data.get_normal(world_pos)
	if is_nan(normal.x) or normal.length_squared() < 0.5:
		return
	var up := normal.normalized()
	var right := up.cross(Vector3.FORWARD).normalized()
	if right.length_squared() < 0.001:
		right = up.cross(Vector3.RIGHT).normalized()
	var forward := right.cross(up).normalized()
	indicator.global_transform.basis = Basis(right, up, forward)


func show_destination_indicator(target_pos: Vector3) -> void:
	## Show the destination indicator at the target position.
	## Reparents to scene root so it stays stationary while unit moves.
	## Aligns to terrain slope via Terrain3D normal query.

	# Hide any existing indicator before showing at the new position
	if _reparented_destination_indicator and is_instance_valid(_reparented_destination_indicator):
		hide_destination_indicator()

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
		
		# Store the reparented reference
		_reparented_destination_indicator = indicator

		# Position at destination (world space) slightly above terrain
		indicator.global_position = target_pos + Vector3(0, 0.1, 0)
		_align_indicator_to_terrain(indicator, target_pos)
		indicator.visible = true

		# Safety timeout — hide indicator if unit never reaches destination
		var ind_ref := indicator
		get_tree().create_timer(60.0).timeout.connect(func() -> void:
			if _reparented_destination_indicator == ind_ref and is_instance_valid(ind_ref):
				hide_destination_indicator()
				print("[ClickableUnit] Destination indicator timed out for %s" % unit_name)
		)
	else:
		# If indicator somehow doesn't exist at all, print a warning
		push_warning("DestinationIndicator node not found for unit %s (ID: %s)" % [unit_name, str(get_instance_id())])


func hide_destination_indicator() -> void:
	## Hide the destination indicator (stays in scene root for reuse).
	if _reparented_destination_indicator and is_instance_valid(_reparented_destination_indicator):
		_reparented_destination_indicator.visible = false
	_reparented_destination_indicator = null


#REFACTOR: Animations should be handled by the BTs in LimboAI
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


## Animations that require standing — forced to low_crawl when legs are missing.
const _STANDING_ANIMS: Array[String] = [
	"idle", "walking", "running", "carry_walk", "injured_run",
	"standing_melee_attack_horizontal", "bash", "jab_cross", "punching",
	"unarmed_equip_over_shoulder", "taking_item",
]

## Melee attack animations that should use ground strike when target is crawling/downed.
const _MELEE_ATTACK_ANIMS: Array[String] = [
	"standing_melee_attack_horizontal", "bash", "jab_cross", "punching",
]


func _play_animation(anim_name: String) -> void:
	if not animation_player:
		return

	# Fully immobile (all limbs gone) — freeze in last pose
	if not can_move:
		animation_player.pause()
		return

	# Ground strike: swap attack anim when target is crawling/downed
	if anim_name in _MELEE_ATTACK_ANIMS and _is_target_on_ground():
		if animation_player.has_animation("standing_melee_attack_360_low"):
			anim_name = "standing_melee_attack_360_low"

	# Force crawl when legs are missing — but pause when idle (not moving)
	var is_crawl_override: bool = false
	if legs_remaining < 2 and anim_name in _STANDING_ANIMS:
		if anim_name == "idle":
			# Stopped moving — freeze in current crawl pose
			if animation_player.current_animation == "low_crawl":
				animation_player.pause()
			return
		anim_name = "low_crawl"
		is_crawl_override = true

	# Don't restart the same animation
	if animation_player.current_animation == anim_name:
		return

	if animation_player.has_animation(anim_name):
		if is_crawl_override:
			animation_player.speed_scale = 1.0
			animation_player.play(anim_name, -1, 0.7)
			var anim: Animation = animation_player.get_animation(anim_name)
			if anim and anim.loop_mode == Animation.LOOP_NONE:
				anim.loop_mode = Animation.LOOP_LINEAR
		else:
			animation_player.play(anim_name)
			if animation_offset > 0.0:
				var anim_length := animation_player.current_animation_length
				if anim_length > 0:
					animation_player.seek(animation_offset * anim_length, true)


func _on_animation_started(anim_name: StringName) -> void:
	## Catches BT-driven animations (BTPlayAnimation bypasses _play_animation).
	# Fully immobile — freeze immediately
	if not can_move:
		animation_player.pause()
		return

	# Ground strike: if attacking a downed target, use low sweep animation
	if String(anim_name) in _MELEE_ATTACK_ANIMS and _is_target_on_ground():
		if animation_player.has_animation(&"standing_melee_attack_360_low"):
			animation_player.play(&"standing_melee_attack_360_low", -1, 0.3)
			return

	# Crawl overrides only apply to dismembered units
	if legs_remaining >= 2:
		return
	if String(anim_name) == "low_crawl":
		animation_player.speed_scale = 1.0
		return
	if String(anim_name) == "idle":
		# Stopped moving — freeze in current crawl pose
		if animation_player.current_animation == "low_crawl":
			animation_player.pause()
		return
	if String(anim_name) in _STANDING_ANIMS:
		animation_player.speed_scale = 1.0
		animation_player.play(&"low_crawl", -1, 0.7)
		var anim: Animation = animation_player.get_animation(&"low_crawl")
		if anim and anim.loop_mode == Animation.LOOP_NONE:
			anim.loop_mode = Animation.LOOP_LINEAR


func _is_target_on_ground() -> bool:
	## Check if current combat target is crawling or downed (lost legs).
	var target: Node3D = combat_target
	if not target or not is_instance_valid(target):
		return false
	if "legs_remaining" in target:
		return target.legs_remaining < 2
	return false


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

#REFACTOR: Wildly unorganized, single responsibility violation, carry weights should not be in here but be pulled from the inventory protosets... 
# what happens when we add more inventory items for example, why are they hard coded here?  this whole section needs massive drastic improvement
func _update_speed_scale() -> void:
	## Sync animation and footstep playback speed to movement speed and time scale.
	## IMPORTANT: Only apply movement speed modifiers when actually moving.
	## Stationary animations (eating, working, etc.) should play at normal speed.
	var time_scale := _get_time_scale()

	if animation_player:
		# Crawl animation manages its own speed — don't override it
		if legs_remaining < 2 and animation_player.current_animation == "low_crawl":
			pass
		elif is_moving:
			# Walking/running: apply base_animation_speed and all modifiers
			var terrain_mod := _terrain_mod_cache
			animation_player.speed_scale = maxf(0.0, base_animation_speed * movement_speed * speed_multiplier * terrain_mod * time_scale)
		else:
			# Stationary: play at normal speed (just time scale)
			# This allows taking_item, closing_a_lid, eating, etc. to play correctly
			animation_player.speed_scale = maxf(0.0, time_scale)

	# Footsteps: only apply when moving (they don't play when stationary anyway)
	if is_instance_valid(_footstep_player):
		if is_moving:
			var terrain_mod := _terrain_mod_cache
			var pitch := base_footstep_speed * movement_speed * speed_multiplier * terrain_mod * time_scale
			if pitch > 0.01:  # Minimum viable pitch
				_footstep_player.pitch_scale = pitch
			else:
				if _footstep_player.playing:
					_footstep_player.stop()
		else:
			# Not moving - ensure footsteps are stopped
			if _footstep_player.playing:
				_footstep_player.stop()


# --- Survival Needs ---

## Carry weights (kg) for encumbrance calculations
const CARRY_WEIGHTS: Dictionary = {
	"scrap_wood": 15.0, "wood": 15.0, "planks": 15.0,
	"nails": 5.0, "nails_box": 5.0,
	"scrap_sails": 10.0, "sails": 10.0, "sail_cloth": 10.0,
}

## Energy drain per real second of walking at 1x time scale and perfect condition.
## Walking for 1 real minute at 1x = 0.5 energy. 1 hour real time = 30 energy.
## At 4x speed, delta is scaled by Engine.time_scale, so drain is automatically 4x faster.
const BASE_WALKING_ENERGY_DRAIN: float = 0.5

## Base hunger drain per real second while walking encumbered (sled or carrying heavy items)
const BASE_WALKING_HUNGER_DRAIN: float = 0.1

func _drain_walking_energy(delta: float) -> void:
	## Drain energy while walking. Delta is already scaled by Engine.time_scale.
	## Encumbered units (sled pulling or carrying) drain 15-25% more energy
	## and also drain hunger while walking. Running (speed_multiplier > 1) drains more.
	if not stats or delta <= 0.0:
		return

	# Base drain per second (delta is already scaled by Engine.time_scale)
	var drain := BASE_WALKING_ENERGY_DRAIN * delta

	# Multiply by condition-based drain modifier
	drain *= stats.get_energy_drain_multiplier()

	# Running (fleeing, sprinting) drains more energy proportional to speed
	drain *= speed_multiplier

	# Encumbrance penalty: 15-25% extra energy drain when pulling sled or carrying
	var encumbrance_mult := _get_encumbrance_multiplier()
	drain *= encumbrance_mult

	# Apply the drain
	stats.energy -= drain

	# Encumbered walking also drains hunger (hauling burns more calories)
	if encumbrance_mult > 1.0:
		var hunger_drain := BASE_WALKING_HUNGER_DRAIN * delta * encumbrance_mult
		stats.hunger -= hunger_drain

	# Emit signal if significant change (every 1 energy lost) to update UI
	if absf(stats.energy - _last_energy_signal) >= 1.0:
		_last_energy_signal = stats.energy
		stats_changed.emit()


func _is_encumbered() -> bool:
	## Returns true if unit is pulling a sled or carrying heavy items.
	if sled_puller and sled_puller.is_pulling():
		return true
	if is_carrying() and _carried_item_weight > 0.0:
		return true
	return false


func _get_encumbrance_multiplier() -> float:
	## Returns energy/hunger drain multiplier for encumbered state.
	## 1.0 = not encumbered. 1.15-1.25 = pulling sled or carrying heavy items.
	## Scales with both current strength and item weight.
	if not stats:
		return 1.0

	if sled_puller and sled_puller.is_pulling():
		# Sled: scale with strength only (sled is inherently heavy)
		var str_weakness: float = 1.0 - stats.current_strength / 100.0
		return 1.0 + lerpf(0.15, 0.25, str_weakness)

	if is_carrying() and _carried_item_weight > 0.0:
		# Carrying: combine strength weakness and weight burden
		var str_weakness: float = 1.0 - stats.current_strength / 100.0
		var weight_burden: float = _carried_item_weight / 15.0  # 15kg = max carry weight
		var combined: float = (str_weakness + weight_burden) / 2.0
		return 1.0 + lerpf(0.15, 0.25, clampf(combined, 0.0, 1.0))

	return 1.0


func _update_encumbrance_speed() -> void:
	## Recalculate speed_multiplier based on encumbrance state.
	## Called each physics frame to keep speed in sync with strength changes.
	## ONLY overwrites speed_multiplier when actually encumbered (carrying/pulling).
	## When not encumbered, leaves speed_multiplier alone so BT-set values
	## (injury limp, exhaustion crawl, etc.) persist.
	var new_mult: float = -1.0  # Sentinel: -1 means "don't touch"

	if sled_puller and sled_puller.is_pulling():
		# Sled pulling: group speed based on weakest puller
		if sled_puller.attached_sled and sled_puller.attached_sled.has_method("get_group_speed_multiplier"):
			new_mult = sled_puller.attached_sled.get_group_speed_multiplier()
		else:
			new_mult = stats.current_strength / 100.0 if stats else 1.0
	elif is_carrying() and _carried_item_weight > 0.0:
		# Carrying: strength factor * weight factor
		var str_factor: float = stats.current_strength / 100.0 if stats else 1.0
		var weight_factor: float = 1.0 - (_carried_item_weight / 50.0)
		new_mult = str_factor * weight_factor

	# Only update when actually encumbered
	if new_mult >= 0.0 and not is_equal_approx(speed_multiplier, new_mult):
		speed_multiplier = new_mult
		_update_speed_scale()


func update_needs(delta_hours: float, in_shelter: bool, near_fire: bool, ambient_temp: float, in_sunlight: bool = true, is_blizzard: bool = false) -> void:
	## Called by TimeManager every 10 in-game minutes to update survival needs.
	if not stats:
		return

	var activity_level := get_activity_level()
	var in_bed := is_in_bed()  # Check if sleeping in actual bed for 2X bonus
	stats.apply_hourly_decay(delta_hours, activity_level, in_shelter, in_bed, near_fire, ambient_temp, in_sunlight, is_blizzard,
		_in_captain_aura, _in_personable_aura, _butchering_horror_active)

	# Tick aurora buff countdown
	tick_aurora_buff(delta_hours)

	# Butchering horror counteraction checks (generous — any morale-positive condition clears it)
	if _butchering_horror_active:
		if _in_captain_aura:
			clear_butchering_horror()
			_trigger_bark_category("butchering_cheer_captain")
		elif _in_personable_aura:
			clear_butchering_horror()
			_trigger_bark_category("butchering_cheer_well_liked")
		elif _aurora_morale_buff_active:
			clear_butchering_horror()

	stats_changed.emit()

	# Check for death
	if stats.is_dead():
		_on_death()


func _on_combat_death() -> void:
	## Called immediately when CombatComponent detects death (signal-based, no polling).
	if stats:
		stats.dying_cause = SurvivorStats.DeathCause.VIOLENCE
	_on_death()


func _on_death() -> void:
	## Handle unit death from needs or combat.
	## Unit remains selectable but cannot move or receive commands.
	## Guard against multiple calls.
	if not is_physics_processing():
		return  # Already dead
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

	# Disable AI behavior trees (both ManAIController for Men and PassiveAIController for Officers)
	var ai_controller := get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("set_enabled"):
		ai_controller.set_enabled(false)
	var passive_controller := get_node_or_null("PassiveAIController")
	if passive_controller and passive_controller.has_method("set_enabled"):
		passive_controller.set_enabled(false)

	# Switch InteractionCollider to corpse layer for click detection
	var interaction_area := find_child("InteractionCollider", true, false) as Area3D
	if interaction_area:
		interaction_area.collision_layer = 1 << 15  # Layer 16
	# Change CharacterBody3D collision layer to corpse-only (layer 16) - for physics only
	collision_layer = 1 << 15  # Layer 16 (0-indexed as 15)
	collision_mask = 1  # Only collide with terrain

	# Stop bleeding and particle effects
	var dc := get_node_or_null("DismembermentComponent")
	if dc and dc.has_method("on_unit_died"):
		dc.on_unit_died()

	# Disable physics processing (movement, gravity, etc.)
	set_physics_process(false)

	# Notify CombatComponent so it emits died signal (hides health bar)
	if combat and not combat._is_dead:
		combat._on_death()

	# Remove from survivors group (TimeManager won't update stats anymore)
	remove_from_group("survivors")


func _on_limb_dismembered(part: int, _position: Vector3, _limb: RigidBody3D) -> void:
	var is_leg := part == DismembermentComponent.BodyPart.LEFT_LEG or part == DismembermentComponent.BodyPart.RIGHT_LEG
	if is_leg and animation_player:
		animation_player.speed_scale = 1.0
		animation_player.play(&"low_crawl", -1, 0.7)


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

#REFACTOR: Should completely be it's own inventory component, are we using and calling Gloot effectively here???
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
	var item_id: String = item.get_property("id", "")

	stats.hunger = minf(stats.hunger + nutrition, 100.0)
	stats.morale = minf(stats.morale + morale_boost, 100.0)
	stats.warmth = minf(stats.warmth + warmth_boost, 100.0)

	# Food/drink with morale value counteracts butchering horror
	if _butchering_horror_active and morale_boost > 0.0:
		clear_butchering_horror()
		# Alcohol triggers specific bark; regular food just clears the horror
		if item_id == "rum":
			_trigger_bark_category("butchering_drink")

	inventory.remove_item(item)
	stats_changed.emit()
	print("[ClickableUnit] %s ate %s (+%.0f hunger)" % [unit_name, item.get_property("name", "food"), nutrition])


## Computed property for BT stat checks - exposes has_food_in_inventory() as property
var inventory_has_food: bool:
	get: return has_food_in_inventory()


func has_item_by_category(category: String) -> bool:
	## Check if unit has any item of the specified category.
	## Used for item prerequisite checks (e.g., "tool" for melee combat).
	if not inventory:
		return false
	for item in inventory.get_items():
		if item.get_property("category", "misc") == category:
			return true
	return false


func has_item_by_id(prototype_id: String) -> bool:
	## Check if unit has a specific item by prototype ID.
	## Used for item prerequisite checks (e.g., "knife" for cannibalism).
	if not inventory:
		return false
	return inventory.has_item_with_prototype_id(prototype_id)


func get_item_by_id(prototype_id: String) -> InventoryItem:
	## Get first item matching prototype ID, or null if not found.
	if not inventory:
		return null
	return inventory.get_item_with_prototype_id(prototype_id)


# --- Environmental Detection (Warmth/Shelter) ---
# Tracking is populated by WarmthArea/ShelterArea body_entered/exited signals.

func enter_fire_warmth(warmth_area: Node) -> void:
	## Called by WarmthArea when unit enters heat source range.
	if warmth_area and warmth_area not in _active_heat_sources:
		_active_heat_sources.append(warmth_area)


func exit_fire_warmth(warmth_area: Node) -> void:
	## Called by WarmthArea when unit exits heat source range.
	_active_heat_sources.erase(warmth_area)


func enter_shelter(shelter_area: Node) -> void:
	## Called by ShelterArea when unit enters shelter.
	_current_shelter = shelter_area


func exit_shelter() -> void:
	## Called by ShelterArea when unit exits shelter.
	_current_shelter = null


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
	return _in_captain_aura


func is_near_personable() -> bool:
	## Returns true if unit is within range of a personable crew member's aura.
	return _in_personable_aura


func get_activity_level() -> int:
	## Returns current activity level for energy recovery calculation.
	## See SurvivorStats.ActivityLevel enum.
	## SLEEPING: In bed - fastest recovery (25/hr)
	## RESTING: Crouching by fire or sitting - moderate recovery (15/hr)
	## LIGHT: Idle/standing - slow passive regen (5/hr)
	## INTENSIVE: Walking, combat, hauling, building - no regen, drains energy

	# SLEEPING: In bed
	if is_in_bed():
		return SurvivorStats.ActivityLevel.SLEEPING

	# INTENSIVE: Combat, moving, or carrying
	if is_in_combat or is_moving or is_carrying():
		return SurvivorStats.ActivityLevel.INTENSIVE

	# Check current animation for resting poses
	var anim := animation_player.current_animation if animation_player else ""

	# RESTING: Crouching by fire
	if anim == "crouching_idle" and is_near_fire():
		return SurvivorStats.ActivityLevel.RESTING

	# RESTING: Sitting on crate (regardless of fire)
	if anim == "sitting_depressed":
		return SurvivorStats.ActivityLevel.RESTING

	# Check BT for intensive work (building, gathering)
	if is_animation_locked:
		var ai: Node = get_node_or_null("ManAIController")
		if ai and ai.has_method("get_blackboard"):
			var bb = ai.get_blackboard()
			if bb:
				var action: String = bb.get_var(&"current_action", "")
				if "Building" in action or "Gathering" in action:
					return SurvivorStats.ActivityLevel.INTENSIVE

	# LIGHT: Default idle state
	return SurvivorStats.ActivityLevel.LIGHT


func enter_captain_aura() -> void:
	## Called by MoraleAura when this unit enters captain's aura radius.
	_in_captain_aura = true
	# Captain presence counteracts butchering horror
	if _butchering_horror_active:
		clear_butchering_horror()
		_trigger_bark_category("butchering_cheer_captain")
	stats_changed.emit()


func exit_captain_aura() -> void:
	## Called by MoraleAura when this unit exits captain's aura radius.
	_in_captain_aura = false
	stats_changed.emit()


func enter_personable_aura() -> void:
	## Called by MoraleAura when this unit enters a personable crew member's aura.
	_in_personable_aura = true
	# Well-liked crew counteract butchering horror
	if _butchering_horror_active:
		clear_butchering_horror()
		_trigger_bark_category("butchering_cheer_well_liked")
	stats_changed.emit()


func exit_personable_aura() -> void:
	## Called by MoraleAura when this unit exits a personable crew member's aura.
	_in_personable_aura = false
	stats_changed.emit()


func has_morale_aura() -> bool:
	## Returns true if this unit provides a morale aura to nearby units.
	for t: SurvivorTrait in traits:
		if t.morale_aura != 0.0:
			return true
	# Captain has MoraleAura as scene child, not via traits
	if rank == UnitRank.CAPTAIN:
		return true
	return false


func get_morale_aura_name() -> String:
	## Returns the name of this unit's morale aura (e.g., "Captain", "Personable").
	if rank == UnitRank.CAPTAIN:
		return "Captain's Morale Boost"
	for t: SurvivorTrait in traits:
		if t.morale_aura != 0.0:
			return t.display_name
	return ""


func get_morale_aura_radius() -> float:
	## Returns the radius of this unit's morale aura in meters.
	if rank == UnitRank.CAPTAIN:
		return MoraleAura.DEFAULT_CAPTAIN_RADIUS
	for t: SurvivorTrait in traits:
		if t.morale_aura != 0.0:
			return MoraleAura.DEFAULT_WELL_LIKED_RADIUS
	return 0.0


# --- Trait System ---

func add_trait(t: SurvivorTrait) -> void:
	## Add a trait to this unit. Creates MoraleAura child if trait has morale_aura.
	traits.append(t)
	if t.morale_aura > 0.0:
		var aura := MoraleAura.new()
		aura.name = "PersonableAura"
		aura.aura_type = MoraleAura.AuraType.WELL_LIKED
		aura.radius = MoraleAura.DEFAULT_WELL_LIKED_RADIUS
		add_child(aura)


func has_trait(trait_id: String) -> bool:
	## Returns true if this unit has a trait with the given id.
	for t: SurvivorTrait in traits:
		if t.id == trait_id:
			return true
	return false


# --- Aurora Morale Buff ---

func apply_aurora_boost(duration_hours: int) -> void:
	## Apply aurora morale boost: +25 flat points, lasts duration_hours.
	if not stats:
		return
	stats.boost_morale(25.0)
	_aurora_morale_buff_active = true
	_aurora_buff_hours_remaining = float(duration_hours)
	# Aurora also counteracts butchering horror
	if _butchering_horror_active:
		clear_butchering_horror()
	stats_changed.emit()


func tick_aurora_buff(delta_hours: float = 1.0) -> void:
	## Called each stat update tick to count down aurora buff duration.
	if not _aurora_morale_buff_active:
		return
	_aurora_buff_hours_remaining -= delta_hours
	if _aurora_buff_hours_remaining <= 0.0:
		_aurora_morale_buff_active = false
		_aurora_buff_hours_remaining = 0.0
		stats_changed.emit()


func is_aurora_buffed() -> bool:
	return _aurora_morale_buff_active


# --- Butchering Horror ---

func apply_butchering_horror() -> void:
	## Apply butchering witness morale hit: instant 50% reduction + ongoing decay.
	if not stats:
		return
	stats.morale *= 0.5
	_butchering_horror_active = true
	stats_changed.emit()


func is_butchering_horrified() -> bool:
	return _butchering_horror_active


func clear_butchering_horror() -> void:
	## Clear the butchering horror debuff (counteracted by captain, personable, alcohol, food, aurora).
	_butchering_horror_active = false
	stats_changed.emit()


func _trigger_bark_category(category: String) -> void:
	## Helper to trigger an important bark on this unit.
	## Uses the unit's own bark() method which delegates to BarkManager.
	bark(category, 4.0)

#REFACTOR: Should be its own system component
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

	# Discovery bark from the found unit
	var rank_prefix := ""
	match rank:
		UnitRank.OFFICER: rank_prefix = "Lt. "
		UnitRank.CAPTAIN: rank_prefix = "Captain "
	bark_now("It's %s%s! We're saved!" % [rank_prefix, unit_name], 4.0)

	discovered.emit(self)
	print("[ClickableUnit] %s has been discovered and recruited!" % unit_name)


func _transition_to_player_control() -> void:
	## Remove AI controller from officer when discovered.
	## Officers become directly controllable like captain.
	## Add passive AI for self-care behaviors (eating from inventory).
	var ai_controller := get_node_or_null("ManAIController")
	if ai_controller:
		ai_controller.queue_free()
		print("[ClickableUnit] %s transitioned to player control" % unit_name)

	# Add passive AI controller for self-care (eating when hungry)
	_add_passive_ai_controller()


func _should_have_passive_ai() -> bool:
	## Returns true if unit should have PassiveAIController.
	## Captain and discovered officers are player-controlled and need passive AI.
	## Men have ManAIController; undiscovered officers get it when discovered.
	if rank == UnitRank.CAPTAIN:
		return true
	if rank == UnitRank.OFFICER and is_discovered:
		# Only if no ManAIController (spawned directly as discovered officer)
		return get_node_or_null("ManAIController") == null
	return false


func _add_passive_ai_controller() -> void:
	## Add PassiveAIController for self-care behaviors (eating when hungry).
	## Skip if already present.
	if get_node_or_null("PassiveAIController"):
		return

	var passive_script: GDScript = load("res://ai/passive_ai_controller.gd")
	if passive_script:
		var passive_controller := Node.new()
		passive_controller.name = "PassiveAIController"
		passive_controller.set_script(passive_script)
		add_child(passive_controller)
		print("[ClickableUnit] %s now has passive AI" % unit_name)


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

#REFACTOR: Should completely be it's own component, part of above since this is tied to discoverable groups of errant men
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
	## Player-controlled units (Officers/Captain) check PassiveAIController first,
	## then fall back to movement state.
	var ai_controller: Node = get_node_or_null("ManAIController")
	if ai_controller and ai_controller.has_method("get_current_action"):
		return ai_controller.get_current_action()

	# Check passive AI controller (Officers/Captain self-care behaviors)
	var passive_controller: Node = get_node_or_null("PassiveAIController")
	if passive_controller and passive_controller.has_method("get_current_action"):
		var action: String = passive_controller.get_current_action()
		if action != "Idle":
			return action

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

var energy_percent: float:  ## Alias for BT compatibility
	get: return stats.energy if stats else 100.0

var health: float:
	get: return stats.health if stats else 100.0

var health_percent: float:  ## Alias for BT compatibility
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

# Dismemberment state (read from DismembermentComponent for BT checks)
var is_dismembered: bool:
	get:
		var dc := get_node_or_null("DismembermentComponent")
		if not dc: return false
		for val in dc._dismembered.values():
			if val: return true
		return false

var right_arm_dismembered: bool:
	get:
		var dc := get_node_or_null("DismembermentComponent")
		if not dc: return false
		return dc._dismembered.get(DismembermentComponent.BodyPart.RIGHT_ARM, false) or dc._dismembered.get(DismembermentComponent.BodyPart.RIGHT_HAND, false)

var legs_remaining: int:
	get:
		var dc := get_node_or_null("DismembermentComponent")
		if not dc: return 2
		var count := 2
		if dc._dismembered.get(DismembermentComponent.BodyPart.LEFT_LEG, false):
			count -= 1
		if dc._dismembered.get(DismembermentComponent.BodyPart.RIGHT_LEG, false):
			count -= 1
		return count

var arms_remaining: int:
	get:
		var dc := get_node_or_null("DismembermentComponent")
		if not dc: return 2
		var count := 2
		if dc._dismembered.get(DismembermentComponent.BodyPart.LEFT_ARM, false):
			count -= 1
		if dc._dismembered.get(DismembermentComponent.BodyPart.RIGHT_ARM, false):
			count -= 1
		return count

var can_move: bool:
	get: return legs_remaining > 0 or arms_remaining > 0


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
	## Dead and undiscovered units cannot be commanded.
	## Non-lead sled pullers cannot be commanded directly - they follow the leader.
	if is_dead:
		return false
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

# ============================================================================
# CARRY SYSTEM (hauling materials)
# ============================================================================

## Currently carried item (attached to hands)
var _carried_item: Node3D = null
## Material being carried (for BT tasks)
var _carried_material_id: String = ""
var _carried_amount: int = 0
## Weight of currently carried item (kg) - used for encumbrance debuffs
var _carried_item_weight: float = 0.0
## Bone attachments for carrying (found at runtime)
var _right_hand_attachment: BoneAttachment3D = null
var _left_hand_attachment: BoneAttachment3D = null
## Scenes for hauling materials
var _plank_scene: PackedScene = preload("res://objects/wood_planks/plank_1.tscn")
var _nails_box_scene: PackedScene = preload("res://objects/nails_box1/nails_box1.tscn")
var _bundled_sails_scene: PackedScene = preload("res://objects/bundled_sails1/bundled_sails1.tscn")

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


#REFACTOR: Should completely be it's own  system component, 
# ============================================================================
# CARRY SYSTEM METHODS
# ============================================================================

func _find_hand_attachments() -> void:
	## Find bone attachments for hands (called lazily on first carry).
	if _right_hand_attachment and _left_hand_attachment:
		return

	# Look for UnitModel/Skeleton/RightHand and LeftHand
	var skeleton: Node = get_node_or_null("UnitModel/Skeleton")
	if skeleton:
		_right_hand_attachment = skeleton.get_node_or_null("RightHand") as BoneAttachment3D
		_left_hand_attachment = skeleton.get_node_or_null("LeftHand") as BoneAttachment3D


func start_carrying(material_id: String, amount: int) -> void:
	## Start carrying materials - instantiates visual and plays carry animation.
	## Called by BT haul tasks after gathering.
	if _carried_item:
		return

	_carried_material_id = material_id
	_carried_amount = amount
	_carried_item_weight = CARRY_WEIGHTS.get(material_id, 0.0)
	_find_hand_attachments()

	var item: Node3D = _create_carried_item(material_id)
	if not item:
		return

	_carried_item = item

	# Attach to bone for realistic hand-following movement.
	if _right_hand_attachment:
		_right_hand_attachment.add_child(item)
		item.position = Vector3(0.0, 0.0, 0.1)
		item.rotation_degrees = Vector3(0, 90, 0)
	else:
		# Fallback to fixed position if no bone attachment
		add_child(item)
		item.position = Vector3(0, 1.0, 0.35)
		item.rotation_degrees = Vector3(0, 0, 0)
	item.scale = Vector3(0.6, 0.6, 0.6)

	_disable_item_collision(item)


func stop_carrying() -> Dictionary:
	## Stop carrying and return what was carried.
	## Returns {"material_id": String, "amount": int}
	var result: Dictionary = {
		"material_id": _carried_material_id,
		"amount": _carried_amount
	}

	# Remove visual
	if _carried_item and is_instance_valid(_carried_item):
		_carried_item.queue_free()
	_carried_item = null

	# Clear state
	_carried_material_id = ""
	_carried_amount = 0
	_carried_item_weight = 0.0
	speed_multiplier = 1.0

	# Return to normal animation
	if is_moving:
		_play_animation("walking")
	else:
		_play_animation("idle")

	return result

## Property wrapper for BTCheckAgentProperty.
var carrying: bool:
	get: return is_carrying()

## Property wrappers for equipment system (BTCheckAgentProperty).
var weapon_equipped: bool:
	get:
		var equipment = get_node_or_null("EquipmentAnimationComponent")
		return equipment.weapon_equipped if equipment else false

var has_melee_weapon: bool:
	get:
		var equipment = get_node_or_null("EquipmentAnimationComponent")
		return equipment.has_melee_weapon() if equipment else false


func is_carrying() -> bool:
	## Check if unit is currently carrying something.
	return _carried_item != null and is_instance_valid(_carried_item)


func get_carried_material() -> Dictionary:
	## Get info about what's being carried.
	return {
		"material_id": _carried_material_id,
		"amount": _carried_amount
	}


func pick_up_item(item: Node3D) -> void:
	## Pick up an existing item from the world (generalized carry).
	if _carried_item:
		drop_item()

	_find_hand_attachments()
	_carried_item = item

	var attachment: BoneAttachment3D = _right_hand_attachment if _right_hand_attachment else _left_hand_attachment
	if attachment:
		item.reparent(attachment)
		item.transform = Transform3D.IDENTITY
	else:
		item.reparent(self)
		item.position = Vector3(0, 1.5, 0.3)

	_disable_item_collision(item)
	_play_animation("carry_walk")


func drop_item() -> Node3D:
	## Drop carried item in front of unit. Returns the dropped item.
	if not _carried_item or not is_instance_valid(_carried_item):
		_carried_item = null
		return null

	var item: Node3D = _carried_item
	_carried_item = null
	_carried_material_id = ""
	_carried_amount = 0
	_carried_item_weight = 0.0
	speed_multiplier = 1.0

	# Reparent to scene and position in front
	item.reparent(get_tree().current_scene)
	var forward: Vector3 = -global_transform.basis.z.normalized()
	item.global_position = global_position + forward * 1.0 + Vector3(0, 0.5, 0)

	# Re-enable collision
	_enable_item_collision(item)

	if is_moving:
		_play_animation("walking")
	else:
		_play_animation("idle")

	return item


func _create_carried_item(material_id: String) -> Node3D:
	## Create visual for carried material.
	match material_id:
		"scrap_wood", "wood", "planks":
			if _plank_scene:
				return _plank_scene.instantiate()
		"nails", "nails_box":
			if _nails_box_scene:
				return _nails_box_scene.instantiate()
		"scrap_sails", "sails", "sail_cloth":
			if _bundled_sails_scene:
				return _bundled_sails_scene.instantiate()

	# Fallback: simple box mesh
	var mesh_instance := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(0.3, 0.1, 0.6)
	mesh_instance.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.6, 0.4, 0.2)  # Brown for generic material
	mesh_instance.material_override = mat
	return mesh_instance


func _disable_item_collision(item: Node) -> void:
	## Recursively disable collision on carried item.
	if item is CollisionShape3D:
		(item as CollisionShape3D).disabled = true
	elif item is CollisionPolygon3D:
		(item as CollisionPolygon3D).disabled = true
	elif item is StaticBody3D:
		(item as StaticBody3D).collision_layer = 0
		(item as StaticBody3D).collision_mask = 0
	elif item is RigidBody3D:
		var rb: RigidBody3D = item as RigidBody3D
		rb.collision_layer = 0
		rb.collision_mask = 0
		rb.freeze = true
	elif item is Area3D:
		(item as Area3D).collision_layer = 0
		(item as Area3D).collision_mask = 0

	for child in item.get_children():
		_disable_item_collision(child)


func _enable_item_collision(item: Node) -> void:
	## Re-enable collision on dropped item.
	if item is CollisionShape3D:
		(item as CollisionShape3D).disabled = false
	elif item is RigidBody3D:
		var rb: RigidBody3D = item as RigidBody3D
		rb.freeze = false

	for child in item.get_children():
		_enable_item_collision(child)
