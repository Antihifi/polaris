class_name RagdollComponent extends Node
## Ragdoll knockback. Simulate → impulse → wait → stop → recover.

signal ragdoll_started
signal ragdoll_ended

@export var ragdoll_duration: float = 3.5
@export var impulse_strength: float = 18.0
@export var recovery_animation: StringName = &"stand_up_from_laying_down"

var is_simulating: bool = false
var is_ragdolling: bool = false

var _unit: CharacterBody3D
var _simulator: PhysicalBoneSimulator3D
var _hips_bone: PhysicalBone3D
var _anim_player: AnimationPlayer
var _collision_shape: CollisionShape3D
var _timer: float = 0.0
var _pending_impulse: Vector3 = Vector3.ZERO
var _impulse_delay: int = 0


func _ready() -> void:
	_unit = get_parent() as CharacterBody3D
	_anim_player = _unit.get_node("UnitModel/AnimationPlayer")
	_collision_shape = _unit.get_node("CollisionShape3D")
	var skeleton: Skeleton3D = _unit.get_node("UnitModel/Skeleton")
	var hips_id := skeleton.find_bone("Hips")
	for child in skeleton.get_children():
		if child is PhysicalBoneSimulator3D:
			_simulator = child
			for bone in child.get_children():
				if bone is PhysicalBone3D and bone.get_bone_id() == hips_id:
					_hips_bone = bone
			break


func trigger_ragdoll(impulse_dir: Vector3, force: float) -> void:
	if is_ragdolling or not _simulator:
		return

	is_ragdolling = true
	is_simulating = true
	_timer = 0.0
	if _unit.has_method("stop"):
		_unit.stop()
	_unit.velocity = Vector3.ZERO
	_set_bt_enabled(false)
	_collision_shape.disabled = true
	var dismember := _unit.get_node_or_null("DismembermentComponent")
	if dismember:
		dismember._is_simulation = true
	_simulator.physical_bones_start_simulation()
	# Defer impulse — bones need 2 physics frames to fully activate
	if force > 0.0:
		_pending_impulse = impulse_dir.normalized() * force
		_impulse_delay = 2
	ragdoll_started.emit()


func _physics_process(delta: float) -> void:
	if not is_ragdolling:
		return

	# Apply deferred impulse once bones are active
	if _impulse_delay > 0:
		_impulse_delay -= 1
		if _impulse_delay == 0 and _pending_impulse != Vector3.ZERO:
			for bone in _simulator.get_children():
				if bone is PhysicalBone3D:
					bone.apply_impulse(_pending_impulse)
			_pending_impulse = Vector3.ZERO

	_timer += delta

	# Sync unit position to hips during simulation so SelectionIndicator follows
	if is_simulating and _hips_bone:
		_unit.global_position = _hips_bone.global_position

	# Phase 1: Simulating — wait for ragdoll duration
	if is_simulating:
		if _timer < ragdoll_duration:
			return
		_end_simulation()
		return

	# Phase 2: Recovery — safety timeout if animation_finished never fires
	if _timer > ragdoll_duration + 5.0:
		_finish()


func _end_simulation() -> void:
	if _hips_bone:
		_unit.global_position = _hips_bone.global_position
	_simulator.physical_bones_stop_simulation()
	is_simulating = false
	var dismember := _unit.get_node_or_null("DismembermentComponent")
	if dismember:
		dismember._is_simulation = false

	if _unit.is_dead:
		_finish()
		return

	# Skip stand-up animation if legs are missing — just finish and let crawl anim take over
	if "legs_remaining" in _unit and _unit.legs_remaining < 2:
		_finish()
		return

	# Recovery animation
	if _anim_player.animation_finished.is_connected(_on_recovery_finished):
		_anim_player.animation_finished.disconnect(_on_recovery_finished)
	_anim_player.animation_finished.connect(_on_recovery_finished, CONNECT_ONE_SHOT)
	_anim_player.play(recovery_animation)


func _on_recovery_finished(_anim_name: StringName) -> void:
	_finish()


func _finish() -> void:
	if _anim_player.animation_finished.is_connected(_on_recovery_finished):
		_anim_player.animation_finished.disconnect(_on_recovery_finished)
	is_ragdolling = false
	is_simulating = false
	# Dead units stay down — don't restore movement or AI
	if not _unit.is_dead:
		_collision_shape.disabled = false
		_set_bt_enabled(true)
	ragdoll_ended.emit()


func _set_bt_enabled(enabled: bool) -> void:
	for ai_name in ["ManAIController", "PassiveAIController"]:
		var ai := _unit.get_node_or_null(ai_name)
		if ai and ai.has_method("set_enabled"):
			ai.set_enabled(enabled)
