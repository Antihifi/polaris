class_name Animal extends CharacterBody3D
## Base class for all wildlife creatures. Requires AnimalAIController + CombatComponent.
## Combat state is managed by CombatComponent - add as child node in scene.

@export_category("Identity")
@export var animal_name: String = "Animal"

@export_category("Stats")
@export var max_health: float = 100.0
@export var damage: float = 10.0
@export var attack_speed: float = 1.5
@export var attack_range: float = 2.0
@export var movement_speed: float = 3.0
@export var chase_speed_multiplier: float = 1.5

@export_category("Behavior")
@export var aggro_range: float = 50.0
@export var flee_threshold: float = 0.25
@export var is_passive: bool = false
@export var is_territorial: bool = false
## Investigation persistence (0.4-0.8). Higher = more likely to keep hunting.
@export var investigation_persistence: float = 0.6
## Detection range multiplier for investigation sphere (base aggro_range * this)
@export var detection_range_multiplier: float = 3.0

@export_category("Drops")
@export var meat_min: int = 2
@export var meat_max: int = 4
@export var meat_item_id: String = "seal_meat"
@export var pelt_chance: float = 1.0
@export var pelt_item_id: String = "pelt"
@export var special_drop_id: String = ""
@export var special_drop_chance: float = 0.0

var _is_chasing: bool = false

## LOD optimization - distance thresholds for update frequency
const LOD_FULL_DISTANCE: float = 100.0  # Full physics within 100m
const LOD_MEDIUM_DISTANCE: float = 300.0  # Half rate within 300m
const LOD_FAR_DISTANCE: float = 600.0  # Quarter rate beyond 300m
var _lod_frame_counter: int = 0
var _is_idle: bool = true  # Track if we're actually moving

## Investigation system - event-driven detection (cheap Area3D signals)
var _detection_area: Area3D
var _investigation_target: Node3D = null
var _investigation_position: Vector3 = Vector3.INF

signal target_detected(target: Node3D)
signal investigation_started(position: Vector3)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var combat: CombatComponent = $CombatComponent
## Attack hitbox Area3D (optional - set in scene for melee range detection)
@onready var attack_hitbox: Area3D = get_node_or_null("AttackHitBox")


func _ready() -> void:
	add_to_group("animals")
	add_to_group("hostile")

	# Initialize CombatComponent
	if combat:
		combat.max_health = max_health
		combat._health = max_health
		combat.died.connect(_on_death)
	else:
		push_error("[Animal] %s missing CombatComponent child!" % animal_name)

	if navigation_agent:
		navigation_agent.velocity_computed.connect(_on_velocity_computed)

	# Setup event-driven detection (cheap - only fires on enter/exit)
	if is_territorial:
		_setup_detection_area()


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# LOD-based update throttling - distant animals update less frequently
	_lod_frame_counter += 1
	var skip_frame := _should_skip_frame()

	# Auto-end combat if target is dead or invalid (always check, lightweight)
	if combat and combat.is_in_combat:
		var target := combat.combat_target
		if not target or not is_instance_valid(target):
			combat.stop_combat()
		elif "is_dead" in target and target.is_dead:
			combat.stop_combat()

	# Skip expensive movement processing based on LOD
	if not skip_frame:
		_process_movement(delta)


func _should_skip_frame() -> bool:
	# Always process if in combat or chasing
	if _is_chasing or (combat and combat.is_in_combat):
		return false

	# Get camera distance for LOD
	var camera := get_viewport().get_camera_3d()
	if not camera:
		return false

	var dist_sq := global_position.distance_squared_to(camera.global_position)

	# Full update rate within LOD_FULL_DISTANCE
	if dist_sq < LOD_FULL_DISTANCE * LOD_FULL_DISTANCE:
		return false

	# Half rate (every 2 frames) within LOD_MEDIUM_DISTANCE
	if dist_sq < LOD_MEDIUM_DISTANCE * LOD_MEDIUM_DISTANCE:
		return (_lod_frame_counter % 2) != 0

	# Quarter rate (every 4 frames) within LOD_FAR_DISTANCE
	if dist_sq < LOD_FAR_DISTANCE * LOD_FAR_DISTANCE:
		return (_lod_frame_counter % 4) != 0

	# Eighth rate (every 8 frames) beyond LOD_FAR_DISTANCE
	return (_lod_frame_counter % 8) != 0


# Delegate health/combat to CombatComponent
var health: float:
	get: return combat.health if combat else 0.0
	set(value):
		if combat:
			combat.health = value

var is_dead: bool:
	get: return combat.is_dead() if combat else true

var is_in_combat: bool:
	get: return combat.is_in_combat if combat else false

var combat_target: Node3D:
	get: return combat.combat_target if combat else null


func take_damage(amount: float, attacker: Node3D = null) -> void:
	if combat:
		combat.take_damage(amount, attacker)


func start_combat(target: Node3D) -> void:
	if combat:
		combat.start_combat(target)


func stop_combat() -> void:
	if combat:
		combat.stop_combat()


func _move_to(target: Vector3) -> void:
	if navigation_agent:
		navigation_agent.target_position = target


func stop() -> void:
	velocity = Vector3.ZERO
	if navigation_agent:
		navigation_agent.target_position = global_position


func set_chasing(value: bool) -> void:
	_is_chasing = value


func _process_movement(delta: float) -> void:
	if not navigation_agent:
		return

	# Check if navigation is finished FIRST to avoid expensive pathfinding queries
	var nav_finished := navigation_agent.is_navigation_finished()

	# Apply gravity only if not on floor (check is cheap)
	if not is_on_floor():
		velocity.y -= 40.0 * delta
		_is_idle = false
	else:
		velocity.y = 0.0

	if nav_finished:
		# Only call move_and_slide if we have residual velocity
		if velocity.length_squared() > 0.01:
			velocity.x = 0.0
			velocity.z = 0.0
			move_and_slide()
			_is_idle = true
		elif not _is_idle:
			# One final move_and_slide to settle, then mark idle
			velocity = Vector3.ZERO
			move_and_slide()
			_is_idle = true
		# Skip move_and_slide entirely when truly idle
		return

	_is_idle = false
	var next_pos := navigation_agent.get_next_path_position()
	var direction := (next_pos - global_position).normalized()
	direction.y = 0.0

	var current_speed := movement_speed
	if _is_chasing:
		current_speed *= chase_speed_multiplier
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	if direction.length_squared() > 0.01:
		rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), 10.0 * delta)

	move_and_slide()


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	# Only update velocity - move_and_slide is called in _process_movement
	# Calling it here too causes expensive duplicate physics calculations
	velocity = safe_velocity


func _on_death() -> void:
	velocity = Vector3.ZERO

	if navigation_agent:
		navigation_agent.target_position = global_position

	# Disable AI
	var ai_controller := get_node_or_null("AnimalAIController")
	if ai_controller and ai_controller.has_method("set_enabled"):
		ai_controller.set_enabled(false)

	# Change collision layers to corpse-only (layer 16) - units can walk through
	collision_layer = 1 << 15  # Layer 16 (corpse layer)
	collision_mask = 1  # Only collide with terrain

	# Also set InteractionCollider (bone-attached Area3D) to corpse layer for click detection
	var interaction_area := _find_interaction_collider()
	if interaction_area:
		interaction_area.collision_layer = 1 << 15  # Layer 16

	# Play death animation if available
	if animation_player:
		for anim_name in ["PolarBearALL_Die", "die", "death"]:
			if animation_player.has_animation(anim_name):
				animation_player.play(anim_name)
				await animation_player.animation_finished
				break

	_spawn_loot()
	_spawn_hunting_kill_area()
	remove_from_group("hostile")
	set_physics_process(false)


func _spawn_loot() -> void:
	var meat_count := randi_range(meat_min, meat_max)
	print("[Animal] %s died, would drop %d %s" % [animal_name, meat_count, meat_item_id])


func _spawn_hunting_kill_area() -> void:
	var hunting_kill_script := load("res://src/systems/hunting_kill_area.gd")
	if hunting_kill_script:
		var area: Node = hunting_kill_script.new()
		get_parent().add_child(area)
		area.global_position = global_position
		if area.has_method("initialize"):
			area.initialize(null)


func get_animation_player() -> AnimationPlayer:
	return animation_player


func _find_interaction_collider() -> Area3D:
	## Find InteractionCollider Area3D in the skeleton hierarchy.
	## Returns null if not found.
	return find_child("InteractionCollider", true, false) as Area3D


# =============================================================================
# INVESTIGATION SYSTEM (Event-driven detection via Area3D signals)
# =============================================================================

func _setup_detection_area() -> void:
	## Create detection sphere for event-driven target detection.
	## This is CHEAP - signals only fire when bodies enter/exit, not every frame.
	_detection_area = Area3D.new()
	_detection_area.name = "DetectionArea"
	_detection_area.collision_layer = 0  # Don't collide with anything
	_detection_area.collision_mask = 2   # Detect units on layer 2
	_detection_area.monitoring = true

	var shape := SphereShape3D.new()
	# Large detection radius - triggers investigation, not instant aggro
	shape.radius = aggro_range * detection_range_multiplier
	var collision := CollisionShape3D.new()
	collision.shape = shape
	_detection_area.add_child(collision)
	add_child(_detection_area)

	_detection_area.body_entered.connect(_on_body_detected)
	_detection_area.body_exited.connect(_on_body_lost)


func _on_body_detected(body: Node3D) -> void:
	## Called when a body enters detection sphere (FREE - event-driven).
	if not body.is_in_group("survivors"):
		return
	if is_dead or _investigation_target != null:
		return  # Already investigating something

	# Dead survivors don't attract attention
	if "stats" in body and body.stats and body.stats.has_method("is_dead"):
		if body.stats.is_dead():
			return

	_investigation_target = body
	_investigation_position = body.global_position
	target_detected.emit(body)
	investigation_started.emit(_investigation_position)


func _on_body_lost(body: Node3D) -> void:
	## Called when a body exits detection sphere.
	if body == _investigation_target:
		# Target left detection range - keep investigating last known position
		pass  # Don't clear target, let BT decide when to give up


func get_investigation_target() -> Node3D:
	## Returns current investigation target (or null if none).
	return _investigation_target


func get_investigation_position() -> Vector3:
	## Returns position to investigate (target's last known position).
	return _investigation_position


func update_investigation_position() -> void:
	## Update investigation position to target's current location (if still valid).
	if _investigation_target and is_instance_valid(_investigation_target):
		_investigation_position = _investigation_target.global_position


func clear_investigation() -> void:
	## Clear investigation state (bear gave up or killed target).
	_investigation_target = null
	_investigation_position = Vector3.INF


func should_continue_investigating() -> bool:
	## Roll probability to continue investigating. Returns true if bear persists.
	return randf() < investigation_persistence


func is_investigating() -> bool:
	## Check if currently investigating a target.
	return _investigation_target != null
