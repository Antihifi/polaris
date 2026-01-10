class_name WarmthArea extends Area3D
## Area3D component that provides warmth buffs to nearby survivors.
## Attach as child of campfire, fire pit, or other heat sources.
## Uses physics engine for spatial detection - zero polling overhead.

@export var warmth_radius: float = 5.0
@export var warmth_bonus: float = 5.0  # Per hour when near fire

var _collision_shape: CollisionShape3D


func _ready() -> void:
	_setup_collision()
	_connect_signals()
	# Add parent to heat_sources group for AI resource seeking
	if get_parent():
		get_parent().add_to_group("heat_sources")
	print("[WarmthArea] Ready at %s, radius=%.1fm" % [global_position, warmth_radius])


func _setup_collision() -> void:
	var shape := SphereShape3D.new()
	shape.radius = warmth_radius
	_collision_shape = CollisionShape3D.new()
	_collision_shape.shape = shape
	add_child(_collision_shape)

	# Only detect survivor bodies (layer 2)
	collision_layer = 0
	collision_mask = 2
	monitoring = true
	monitorable = false


func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("enter_fire_warmth"):
		body.enter_fire_warmth(self)


func _on_body_exited(body: Node3D) -> void:
	if body.has_method("exit_fire_warmth"):
		body.exit_fire_warmth(self)


func set_radius(new_radius: float) -> void:
	warmth_radius = new_radius
	if _collision_shape and _collision_shape.shape:
		(_collision_shape.shape as SphereShape3D).radius = warmth_radius


func get_warmth_bonus() -> float:
	return warmth_bonus
