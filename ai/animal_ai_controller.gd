extends Node
## AnimalAIController - Controls animal AI using LimboAI behavior tree.
## Uses MANUAL tick updates with state-based throttling for performance.
## Attach as child of Animal (CharacterBody3D).

@export var behavior_tree: BehaviorTree
@export var enabled: bool = true

## Tick intervals based on AI state (seconds between BT updates)
const IDLE_TICK_INTERVAL: float = 1.0       # 1 tick/sec when idle (roaming)
const INVESTIGATE_TICK_INTERVAL: float = 0.2  # 5 ticks/sec when investigating
const COMBAT_TICK_INTERVAL: float = 0.1     # 10 ticks/sec in combat
const FAR_DISTANCE_MULTIPLIER: float = 2.0  # Double interval when far from camera
const FAR_DISTANCE_THRESHOLD: float = 200.0  # Distance to apply multiplier

var _animal: Node3D = null
var _bt_player: BTPlayer = null
var _blackboard: Blackboard = null
var _tick_timer: float = 0.0
var _current_tick_interval: float = IDLE_TICK_INTERVAL


func _ready() -> void:
	_animal = get_parent()
	if not _animal:
		push_error("[AnimalAIController] Must be child of Animal")
		return

	if not behavior_tree:
		push_warning("[AnimalAIController] No behavior tree assigned")
		return

	await get_tree().process_frame
	_setup_behavior_tree()


func _setup_behavior_tree() -> void:
	_bt_player = BTPlayer.new()
	_bt_player.name = "BTPlayer"
	_bt_player.set_scene_root_hint(_animal)
	_bt_player.agent_node = NodePath("../..")
	_bt_player.behavior_tree = behavior_tree

	add_child(_bt_player)

	await get_tree().physics_frame

	_blackboard = _bt_player.blackboard
	_blackboard.set_var(&"threat_target", null)
	_blackboard.set_var(&"roam_target", Vector3.INF)
	_blackboard.set_var(&"investigation_target", null)
	_blackboard.set_var(&"investigation_position", Vector3.INF)

	# CRITICAL: Use MANUAL updates instead of automatic physics updates
	# This allows us to throttle tick rate based on AI state
	_bt_player.update_mode = BTPlayer.UpdateMode.MANUAL
	_bt_player.active = enabled

	# Stagger initial tick to spread load across frames
	# This prevents all animals from ticking on the same frame
	_tick_timer = randf() * IDLE_TICK_INTERVAL


func _physics_process(delta: float) -> void:
	if not enabled or not _bt_player or not _bt_player.active:
		return

	_tick_timer -= delta
	if _tick_timer <= 0.0:
		# Sync investigation state from animal to blackboard
		_sync_investigation_state()

		# Run one BT tick
		_bt_player.update(delta)

		# Update tick interval based on current state
		_update_tick_interval()
		_tick_timer = _current_tick_interval


func _sync_investigation_state() -> void:
	## Sync investigation target from Animal to blackboard for BT to use.
	if not _animal:
		return

	if _animal.has_method("get_investigation_target"):
		var target: Node3D = _animal.get_investigation_target()
		_blackboard.set_var(&"investigation_target", target)

	if _animal.has_method("get_investigation_position"):
		var pos: Vector3 = _animal.get_investigation_position()
		_blackboard.set_var(&"investigation_position", pos)


func _update_tick_interval() -> void:
	## Update tick interval based on current AI state.
	## Combat > Investigating > Idle (from fastest to slowest tick rate)

	# Check if in combat (threat_target set by AttackThreat sequence)
	var threat_target: Node3D = _blackboard.get_var(&"threat_target")
	if threat_target and is_instance_valid(threat_target):
		_current_tick_interval = COMBAT_TICK_INTERVAL
		return

	# Check if investigating (investigation_target set by Area3D signal)
	var investigation_target: Node3D = _blackboard.get_var(&"investigation_target")
	if investigation_target and is_instance_valid(investigation_target):
		_current_tick_interval = INVESTIGATE_TICK_INTERVAL
		return

	# Idle state - apply distance multiplier for far animals
	_current_tick_interval = IDLE_TICK_INTERVAL

	var camera := get_viewport().get_camera_3d()
	if camera and _animal:
		var dist := _animal.global_position.distance_to(camera.global_position)
		if dist > FAR_DISTANCE_THRESHOLD:
			_current_tick_interval *= FAR_DISTANCE_MULTIPLIER


func set_enabled(value: bool) -> void:
	enabled = value
	if _bt_player:
		_bt_player.active = value


func get_blackboard() -> Blackboard:
	return _blackboard
