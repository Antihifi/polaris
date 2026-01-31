extends Node
class_name RiggingCleanupManager
## Manages falling rigging pieces - detects when they hit ground and queues them for deletion.
##
## Add this as a child of your main scene. It monitors all nodes in the "rigging" group
## and removes them when they fall below the ground threshold.
##
## Usage:
##   1. Add this node to your scene
##   2. Set ground_y to your deck/water level
##   3. Call activate_rigging() when destruction begins

@export var ground_y: float = -5.0  # Absolute ground level - set BELOW your floor (water/terrain)
@export var use_fall_distance: bool = false  # If true, also delete after falling too far
@export var fall_distance_threshold: float = 200.0  # Only used if use_fall_distance is true
@export var delete_delay: float = 0.5  # Seconds after hitting ground before deletion
@export var check_interval: float = 0.1  # How often to check positions (performance)
@export var debug_output: bool = false  # Print debug info when pieces are deleted

var _active_pieces: Array[RigidBody3D] = []
var _piece_start_y: Dictionary = {}  # RigidBody3D -> starting Y position
var _pending_deletion: Dictionary = {}  # RigidBody3D -> deletion_time
var _check_timer: float = 0.0


func _ready() -> void:
	# Don't process until activated
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_check_timer += delta
	if _check_timer < check_interval:
		return
	_check_timer = 0.0

	var current_time := Time.get_ticks_msec() / 1000.0

	# Check active pieces for ground contact
	var to_remove: Array[RigidBody3D] = []
	for piece in _active_pieces:
		if not is_instance_valid(piece):
			to_remove.append(piece)
			continue

		var below_ground := piece.global_position.y < ground_y
		var should_delete := below_ground

		# Optional: also check fall distance (disabled by default)
		if use_fall_distance:
			var start_y: float = _piece_start_y.get(piece, piece.global_position.y)
			var has_fallen_far := (start_y - piece.global_position.y) > fall_distance_threshold
			should_delete = below_ground or has_fallen_far

		if should_delete:
			# Mark for delayed deletion
			if piece not in _pending_deletion:
				if debug_output:
					print("Rigging piece '", piece.name, "' marked for deletion at y=", piece.global_position.y)
				piece.freeze = true  # Stop physics
				_pending_deletion[piece] = current_time + delete_delay
			to_remove.append(piece)

	# Remove from active list
	for piece in to_remove:
		_active_pieces.erase(piece)

	# Process pending deletions
	var to_delete: Array[RigidBody3D] = []
	for piece in _pending_deletion:
		if not is_instance_valid(piece):
			to_delete.append(piece)
			continue
		if current_time >= _pending_deletion[piece]:
			to_delete.append(piece)

	for piece in to_delete:
		_pending_deletion.erase(piece)
		_piece_start_y.erase(piece)
		if is_instance_valid(piece):
			piece.queue_free()

	# Stop processing if nothing left
	if _active_pieces.is_empty() and _pending_deletion.is_empty():
		set_physics_process(false)
		print("RiggingCleanupManager: All rigging pieces cleaned up")


## Activates all rigging pieces - unfreezes them so they start falling
func activate_all_rigging() -> void:
	var rigging_nodes := get_tree().get_nodes_in_group("rigging")
	for node in rigging_nodes:
		if node is RigidBody3D:
			activate_piece(node)
	print("RiggingCleanupManager: Activated ", _active_pieces.size(), " rigging pieces")


## Activates rigging pieces under a specific parent node
func activate_rigging_under(parent: Node) -> void:
	var count := 0
	for child in parent.get_children():
		if child is RigidBody3D and child.is_in_group("rigging"):
			activate_piece(child)
			count += 1
		# Also check grandchildren
		for grandchild in child.get_children():
			if grandchild is RigidBody3D and grandchild.is_in_group("rigging"):
				activate_piece(grandchild)
				count += 1
	print("RiggingCleanupManager: Activated ", count, " rigging pieces under ", parent.name)


## Activates a single rigging piece
func activate_piece(piece: RigidBody3D) -> void:
	if piece not in _active_pieces:
		# Store starting Y position for fall distance calculation
		_piece_start_y[piece] = piece.global_position.y
		piece.freeze = false
		_active_pieces.append(piece)
		set_physics_process(true)


## Returns count of currently active (falling) pieces
func get_active_count() -> int:
	return _active_pieces.size()


## Returns count of pieces pending deletion
func get_pending_count() -> int:
	return _pending_deletion.size()
