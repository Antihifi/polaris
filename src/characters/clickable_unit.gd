class_name ClickableUnit extends CharacterBody3D
## Simple click-to-move unit for RTS-style control.
## Uses NavigationAgent3D for pathfinding.

signal selected
signal deselected
signal reached_destination

@export var movement_speed: float = 4.0
@export var rotation_speed: float = 10.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var is_selected: bool = false
var is_moving: bool = false
var _debug_frame_count: int = 0


func _ready() -> void:
	print("[ClickableUnit] _ready() called on: ", name)
	print("[ClickableUnit] Position: ", global_position)
	print("[ClickableUnit] NavigationAgent3D: ", navigation_agent)

	# Setup navigation callbacks
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_finished)

	# Add to selectable group
	add_to_group("selectable_units")
	print("[ClickableUnit] Ready complete, added to selectable_units group")


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
		reached_destination.emit()
		return

	var next_position := navigation_agent.get_next_path_position()
	var current_pos := global_position

	# Debug every 60 frames (~1 second)
	if _debug_frame_count % 60 == 0:
		print("[ClickableUnit] Frame ", _debug_frame_count, " | pos: ", current_pos, " -> next: ", next_position)

	# Calculate direction to next waypoint (XZ plane only)
	var direction := Vector3(
		next_position.x - current_pos.x,
		0.0,
		next_position.z - current_pos.z
	)

	var distance := direction.length()
	if distance < 0.1:
		# Very close horizontally - snap to target Y and wait for next waypoint
		# This handles the case where nav agent wants us to adjust height first
		return

	direction = direction.normalized()

	# Rotate towards movement direction
	var target_rotation := atan2(direction.x, direction.z)
	rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

	# Calculate velocity
	var desired_velocity := direction * movement_speed

	# Apply movement
	velocity = desired_velocity
	move_and_slide()

	# Debug: show actual movement
	if _debug_frame_count % 60 == 0:
		print("[ClickableUnit] velocity: ", velocity, " | new pos: ", global_position)


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_navigation_finished() -> void:
	is_moving = false
	velocity = Vector3.ZERO
	reached_destination.emit()


func move_to(target_position: Vector3) -> void:
	## Navigate to target position.
	print("[ClickableUnit] move_to called with target: ", target_position)
	print("[ClickableUnit] Current position: ", global_position)
	navigation_agent.target_position = target_position
	is_moving = true
	print("[ClickableUnit] Navigation target set, is_moving = ", is_moving)
	print("[ClickableUnit] Nav agent is_target_reachable: ", navigation_agent.is_target_reachable())
	print("[ClickableUnit] Nav agent is_navigation_finished: ", navigation_agent.is_navigation_finished())


func stop() -> void:
	is_moving = false
	velocity = Vector3.ZERO


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
