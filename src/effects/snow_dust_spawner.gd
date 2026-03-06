class_name SnowDustSpawner extends GPUParticles3D
## Attach to snow_impact_effect.tscn. Place as child of any BoneAttachment3D.
## Finds CombatComponent on the owning combatant and triggers on attack hits.
## The dust spawns at this node's position (the bone attachment), projected to ground.

var _combat_component: Node = null
var _terrain: Node = null


func _ready() -> void:
	emitting = false
	one_shot = true
	_find_combat_component()
	_find_terrain()


func _find_combat_component() -> void:
	# Walk up the tree to find the combatant root with CombatComponent
	var node := get_parent()
	while node:
		if node.has_node("CombatComponent"):
			_combat_component = node.get_node("CombatComponent")
			_combat_component.took_damage.connect(_on_took_damage)
			return
		if "combat" in node and node.combat:
			_combat_component = node.combat
			_combat_component.took_damage.connect(_on_took_damage)
			return
		node = node.get_parent()


func _find_terrain() -> void:
	var terrain_nodes := get_tree().get_nodes_in_group("terrain")
	if terrain_nodes.size() > 0:
		_terrain = terrain_nodes[0]


func _on_took_damage(_amount: float, _attacker: Node3D) -> void:
	# Spawn a copy at our bone position, projected to ground
	var dust: GPUParticles3D = duplicate()
	var pos: Vector3 = global_position

	# Snap Y to terrain so dust sits on the ground
	if _terrain and "data" in _terrain and _terrain.data:
		var terrain_y: float = _terrain.data.get_height(pos)
		if not is_nan(terrain_y):
			pos.y = terrain_y

	get_tree().current_scene.add_child(dust)
	dust.global_position = pos
	dust.emitting = true

	# Auto-cleanup after particles finish
	get_tree().create_timer(dust.lifetime + 0.5).timeout.connect(dust.queue_free)
