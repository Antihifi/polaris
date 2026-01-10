class_name MoraleAura extends Area3D
## Area3D component that provides morale buffs to nearby survivors.
## Attach as child of Captain or characters with "Well Liked" trait.
## Uses physics engine for spatial detection - zero polling overhead.

enum AuraType { CAPTAIN, WELL_LIKED }

## Default radii: Captain = 20m (close leadership), Well Liked = 50m (social influence)
const DEFAULT_CAPTAIN_RADIUS: float = 20.0
const DEFAULT_WELL_LIKED_RADIUS: float = 50.0

@export var aura_type: AuraType = AuraType.CAPTAIN
@export var radius: float = 20.0

var _collision_shape: CollisionShape3D


func _ready() -> void:
	_setup_collision()
	_connect_signals()


func _setup_collision() -> void:
	var shape := SphereShape3D.new()
	shape.radius = radius
	_collision_shape = CollisionShape3D.new()
	_collision_shape.shape = shape
	add_child(_collision_shape)

	# Only detect survivor bodies (layer 2)
	collision_layer = 0
	collision_mask = 2


func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	# Don't buff self
	if body == get_parent():
		return

	if body.has_method("enter_captain_aura") and body.has_method("enter_personable_aura"):
		match aura_type:
			AuraType.CAPTAIN:
				body.enter_captain_aura()
			AuraType.WELL_LIKED:
				body.enter_personable_aura()


func _on_body_exited(body: Node3D) -> void:
	if body == get_parent():
		return

	if body.has_method("exit_captain_aura") and body.has_method("exit_personable_aura"):
		match aura_type:
			AuraType.CAPTAIN:
				body.exit_captain_aura()
			AuraType.WELL_LIKED:
				body.exit_personable_aura()


func set_radius(new_radius: float) -> void:
	radius = new_radius
	if _collision_shape and _collision_shape.shape:
		(_collision_shape.shape as SphereShape3D).radius = radius


func get_display_name() -> String:
	## Returns human-readable name for this aura type.
	match aura_type:
		AuraType.CAPTAIN:
			return "Captain's Morale Boost"
		AuraType.WELL_LIKED:
			return "Well Liked"
	return "Unknown Aura"


func get_aura_radius() -> float:
	## Returns the effective radius of this aura.
	return radius


static func get_default_radius(type: AuraType) -> float:
	## Returns the default radius for a given aura type.
	match type:
		AuraType.CAPTAIN:
			return DEFAULT_CAPTAIN_RADIUS
		AuraType.WELL_LIKED:
			return DEFAULT_WELL_LIKED_RADIUS
	return 20.0
