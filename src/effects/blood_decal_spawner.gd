class_name BloodDecalSpawner extends Node
## Spawns blood decals when entities take damage.
## Add as child to any combatant with CombatComponent.

enum DecalType { GROUND_POOL, ENTITY_DRIP }

@export_category("Scenes")
@export var pool_decal_scene: PackedScene
@export var drip_decal_scene: PackedScene

@export_category("Timing")
@export var lifetime_seconds: float = 900.0  # 1 game day = 15 real minutes
@export var expand_duration: float = 5.0  # Slower pooling effect
@export var fade_duration: float = 10.0

@export_category("Sizes")
@export var pool_min_size: float = 1.5  # Larger pools
@export var pool_max_size: float = 4.0
@export var drip_height: float = 3.0  # Needs to be large enough to hit the mesh

@export_category("Limits")
@export var max_decals: int = 50
@export var spawn_chance: float = 0.85  # More blood
@export var drip_damage_threshold: float = 3.0  # Lower = more drips

var _active_decals: Array[Node3D] = []
var _combat_component: Node = null
var _terrain: Node = null


func _ready() -> void:
	_find_combat_component()
	_find_terrain()


func _find_combat_component() -> void:
	var parent := get_parent()
	# Check for CombatComponent as child node
	if parent.has_node("CombatComponent"):
		_combat_component = parent.get_node("CombatComponent")
		_combat_component.took_damage.connect(_on_took_damage)
	# Check for combat property (some units expose it directly)
	elif "combat" in parent and parent.combat:
		_combat_component = parent.combat
		_combat_component.took_damage.connect(_on_took_damage)


func _find_terrain() -> void:
	var terrain_nodes := get_tree().get_nodes_in_group("terrain")
	if terrain_nodes.size() > 0:
		_terrain = terrain_nodes[0]


func _on_took_damage(amount: float, _attacker: Node3D) -> void:
	if randf() > spawn_chance:
		return

	var parent_pos: Vector3 = get_parent().global_position

	# Always spawn ground pool
	if pool_decal_scene:
		_spawn_pool(parent_pos)

	# Spawn drip on entity for significant hits
	if drip_decal_scene and amount >= drip_damage_threshold:
		_spawn_drip()


func _spawn_pool(position: Vector3) -> void:
	_enforce_limit()

	var decal: Node3D = pool_decal_scene.instantiate()
	var final_radius := randf_range(pool_min_size, pool_max_size)
	var target_size := Vector3(final_radius, 2.0, final_radius)

	# Position on terrain
	if _terrain and "data" in _terrain and _terrain.data:
		var terrain_y: float = _terrain.data.get_height(position)
		if not is_nan(terrain_y):
			position.y = terrain_y + 0.05

	decal.set("size", Vector3(0.1, 2.0, 0.1))  # Start small

	# Add to tree BEFORE setting global_position
	get_tree().current_scene.add_child(decal)
	decal.global_position = position
	decal.rotation.y = randf() * TAU  # Random rotation
	_active_decals.append(decal)

	# Expand outward
	var tween: Tween = decal.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(decal, "size", target_size, expand_duration)

	_schedule_cleanup(decal)


func _spawn_drip() -> void:
	_enforce_limit()

	var decal: Node3D = drip_decal_scene.instantiate()
	var target_size := Vector3(0.8, drip_height, 0.8)

	# Parent to entity so it follows them
	var parent := get_parent()
	decal.position = Vector3(0, 2.0, 0)  # Above entity center
	decal.rotation.y = randf() * TAU
	decal.set("size", Vector3(0.5, 1.0, 0.5))  # Start with enough Y to hit mesh

	parent.add_child(decal)
	_active_decals.append(decal)

	# Expand downward
	var tween: Tween = decal.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(decal, "size", target_size, expand_duration * 1.5)

	_schedule_cleanup(decal)


func _enforce_limit() -> void:
	while _active_decals.size() >= max_decals:
		var oldest: Node3D = _active_decals.pop_front()
		if is_instance_valid(oldest):
			oldest.queue_free()


func _schedule_cleanup(decal: Node3D) -> void:
	var timer := get_tree().create_timer(lifetime_seconds)
	timer.timeout.connect(func(): _fade_and_remove(decal))


func _fade_and_remove(decal: Node3D) -> void:
	if not is_instance_valid(decal):
		_active_decals.erase(decal)
		return

	var tween: Tween = decal.create_tween()
	tween.tween_property(decal, "albedo_mix", 0.0, fade_duration)
	tween.tween_callback(func(): _remove_decal(decal))


func _remove_decal(decal: Node3D) -> void:
	_active_decals.erase(decal)
	if is_instance_valid(decal):
		decal.queue_free()
