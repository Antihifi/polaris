class_name HuntingKillArea extends Area3D
## Temporary Area3D spawned when a hunting kill occurs.
## Applies one-time morale boost to all survivors within witness range.
## Self-destructs immediately after applying boosts.

@export var witness_radius: float = 150.0
@export var morale_boost: float = 5.0
@export var killer_bonus: float = 20.0  # Extra bonus for the hunter who made the kill


func _ready() -> void:
	_setup_collision()
	# Deferred to ensure physics has updated overlapping bodies
	call_deferred("_apply_witness_boosts")


func _setup_collision() -> void:
	var shape := SphereShape3D.new()
	shape.radius = witness_radius
	var collision := CollisionShape3D.new()
	collision.shape = shape
	add_child(collision)

	# Only detect survivor bodies (layer 2)
	collision_layer = 0
	collision_mask = 2


func _apply_witness_boosts() -> void:
	## Apply morale boost to all survivors currently in range.
	for body in get_overlapping_bodies():
		if body.has_method("witness_hunting_kill"):
			body.witness_hunting_kill(morale_boost)

	# Self-destruct after applying boosts (one-time event)
	queue_free()


static func spawn_at(position: Vector3, parent: Node, killer: Node3D = null) -> HuntingKillArea:
	## Factory method to spawn a hunting kill area at a position.
	## If killer is provided, they get the full killer_bonus instead of witness bonus.
	var area := HuntingKillArea.new()
	area.global_position = position
	parent.add_child(area)

	# Give killer their bonus directly
	if killer and killer.has_method("witness_hunting_kill"):
		killer.witness_hunting_kill(area.killer_bonus)

	return area
