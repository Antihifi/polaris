class_name DiscoveryArea extends Area3D
## Detects undiscovered units and recruits them when they enter range.
## Attach as child of captain or officers to enable recruitment.

## Discovery radius in meters (GDD: 10-15m)
@export var discovery_radius: float = 15.0

var _collision_shape: CollisionShape3D


func _ready() -> void:
	_setup_collision()
	_connect_signals()
	print("[DiscoveryArea] Ready with radius %.1fm" % discovery_radius)


func _setup_collision() -> void:
	var shape := SphereShape3D.new()
	shape.radius = discovery_radius
	_collision_shape = CollisionShape3D.new()
	_collision_shape.shape = shape
	add_child(_collision_shape)

	# Detect survivor bodies (layer 2)
	collision_layer = 0
	collision_mask = 2
	monitoring = true
	# Use deferred to avoid "Function blocked during in/out signal" error
	# when discovery area is created inside a physics callback (discover())
	set_deferred("monitorable", false)


func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	## When a body enters, check if it's an undiscovered unit and recruit it.
	if not body.has_method("discover"):
		return

	# Check if unit is undiscovered
	if "is_discovered" in body and not body.is_discovered:
		var unit_name: String = body.unit_name if "unit_name" in body else body.name
		print("[DiscoveryArea] Discovered %s!" % unit_name)
		body.discover()


func set_radius(new_radius: float) -> void:
	discovery_radius = new_radius
	if _collision_shape and _collision_shape.shape:
		(_collision_shape.shape as SphereShape3D).radius = discovery_radius
