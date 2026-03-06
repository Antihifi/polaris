class_name PolarBear extends Animal
## Polar bear - territorial predator that attacks anything within range.
## High HP, high damage, drops lots of meat and valuable pelt/fat.

## Roaming distance for this bear (set by spawner, used by BTAnimalPickRoamTarget)
@export var roam_radius: float = 20.0

## Aggro range multiplier (0.6 = docile, 1.4 = aggressive). Applied by BTAnimalHasThreat.
@export var aggro_multiplier: float = 1.0

## Size scale (5.0 = small, 7.0 = normal, 8.5 = large). Set by spawner, used for butchering yield.
@export var size_scale: float = 7.0

# Sound effects
var _roar_sound: AudioStream = preload("res://sounds/bear_roar_1.mp3")
var _strike_sound: AudioStream = preload("res://sounds/bear_strike_hit1.mp3")
var _roar_player: AudioStreamPlayer3D
var _strike_player: AudioStreamPlayer3D

# Attack timing - strike sound plays near end of attack animation
const ATTACK_ANIM_DURATION: float = 3.28
const STRIKE_SOUND_DURATION: float = 1.15
const STRIKE_DELAY: float = ATTACK_ANIM_DURATION - STRIKE_SOUND_DURATION  # ~2.13s

# Random roar during combat
var _next_combat_roar_time: float = 0.0
const COMBAT_ROAR_MIN_INTERVAL: float = 8.0
const COMBAT_ROAR_MAX_INTERVAL: float = 15.0


func _init() -> void:
	# Override default values
	animal_name = "Polar Bear"

	# Stats from GDD
	max_health = 200.0
	damage = 35.0
	attack_speed = 1.8
	attack_range = 2.5
	movement_speed = 5.0
	turn_speed = 5.0

	# Behavior - base aggro_range, gets multiplied by aggro_multiplier in BT
	aggro_range = 30.0
	flee_threshold = 0.25  # Bears flee at 25% HP
	is_passive = false
	is_territorial = true  # Attacks anything in range

	# Drops from GDD
	meat_min = 6
	meat_max = 10
	meat_item_id = "bear_meat"
	pelt_chance = 1.0
	pelt_item_id = "bear_pelt"
	special_drop_id = "bear_fat"
	special_drop_chance = 1.0


func _ready() -> void:
	super._ready()
	add_to_group("polar_bears")
	_setup_audio()
	_connect_animation_signals()
	_setup_hitbox()


func _setup_hitbox() -> void:
	# CRITICAL: AttackHitBox needs collision_mask = 2 to DETECT units on layer 2
	# Without this, get_overlapping_bodies() returns nothing and damage fails
	if attack_hitbox:
		attack_hitbox.collision_mask = 2  # Detect units (layer 2)
		attack_hitbox.monitoring = true


func _setup_audio() -> void:
	# Create 3D audio players for positional sound
	_roar_player = AudioStreamPlayer3D.new()
	_roar_player.name = "RoarPlayer"
	_roar_player.stream = _roar_sound
	_roar_player.max_distance = 150.0
	_roar_player.unit_size = 20.0  # Loud roar
	add_child(_roar_player)

	_strike_player = AudioStreamPlayer3D.new()
	_strike_player.name = "StrikePlayer"
	_strike_player.stream = _strike_sound
	_strike_player.max_distance = 60.0
	_strike_player.unit_size = 15.0  # Loud strike
	add_child(_strike_player)


func _connect_animation_signals() -> void:
	if animation_player:
		animation_player.animation_started.connect(_on_animation_started)


func _on_animation_started(anim_name: StringName) -> void:
	match anim_name:
		&"PolarBearALL_Idle":
			# Stop movement, face target, and roar during the wind-up idle before attack
			stop()
			_face_target()
			_play_roar()
		&"PolarBearALL_Attack", &"PolarBearALL_Attack2", &"PolarBearALL_Attack3":
			# Face target and schedule strike sound
			_face_target()
			_schedule_strike_sound()


func _face_target() -> void:
	# Face the current threat target (combat or investigation)
	var target: Node3D = null
	if combat and combat.combat_target and is_instance_valid(combat.combat_target):
		target = combat.combat_target
	elif _investigation_target and is_instance_valid(_investigation_target):
		target = _investigation_target

	if not target:
		return

	var dir := (target.global_position - global_position).normalized()
	dir.y = 0.0
	if dir.length_squared() > 0.01:
		rotation.y = atan2(dir.x, dir.z)


func _play_roar() -> void:
	if _roar_player and not _roar_player.playing:
		_roar_player.pitch_scale = randf_range(0.9, 1.1)
		_roar_player.play()


func _schedule_strike_sound() -> void:
	# Play strike sound after delay so it coincides with attack impact
	if is_dead:
		return
	await get_tree().create_timer(STRIKE_DELAY).timeout
	if is_instance_valid(self) and not is_dead and _strike_player:
		_strike_player.pitch_scale = randf_range(0.95, 1.05)
		_strike_player.play()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_update_combat_roar(delta)
	_apply_charge_knockback()


func _apply_charge_knockback() -> void:
	## Knock units aside when charging (chasing). Uses existing AttackHitBox Area3D.
	if not _is_chasing or is_dead or not attack_hitbox:
		return
	for body in attack_hitbox.get_overlapping_bodies():
		if not body.is_in_group("survivors"):
			continue
		var ragdoll := body.get_node_or_null("RagdollComponent")
		if not ragdoll or ragdoll.is_ragdolling:
			continue
		# Push sideways relative to bear's heading so bear runs through
		var bear_forward := -global_transform.basis.z.normalized()
		var side := bear_forward.cross(Vector3.UP).normalized()
		var to_unit := (body.global_position - global_position).normalized()
		if to_unit.dot(side) < 0.0:
			side = -side
		side.y = 0.15
		ragdoll.trigger_ragdoll(side.normalized(),20.0)


func _update_combat_roar(delta: float) -> void:
	# Random roars during active combat
	if not combat or not combat.is_in_combat or is_dead:
		return

	_next_combat_roar_time -= delta
	if _next_combat_roar_time <= 0.0:
		_play_roar()
		_next_combat_roar_time = randf_range(COMBAT_ROAR_MIN_INTERVAL, COMBAT_ROAR_MAX_INTERVAL)


func _on_death() -> void:
	# Play death roar before parent death handling
	_play_death_roar()
	super._on_death()


func _play_death_roar() -> void:
	# Loud, low-pitched death roar
	if _roar_player:
		_roar_player.pitch_scale = 0.7  # Lower pitch for death
		_roar_player.play()
