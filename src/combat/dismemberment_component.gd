class_name DismembermentComponent extends Node
## Physics-based dismemberment with pre-placed limb scenes.
## Limbs are hidden children of BoneAttachment3D nodes on the skeleton.
## On dismemberment: reparent to scene root, enable physics, apply impulse.
## Add as child of unit. Connects to CombatComponent.took_damage.

signal limb_dismembered(part: int, position: Vector3, limb: RigidBody3D)

enum BodyPart {
	HEAD, LEFT_ARM, RIGHT_ARM, LEFT_LEG, RIGHT_LEG,
	LEFT_HAND, RIGHT_HAND, LEFT_FOOT, RIGHT_FOOT,
}

const BONE_NAMES := {
	BodyPart.HEAD: "Head",
	BodyPart.LEFT_ARM: "LeftUpperArm",
	BodyPart.RIGHT_ARM: "RightUpperArm",
	BodyPart.LEFT_LEG: "LeftUpperLeg",
	BodyPart.RIGHT_LEG: "RightUpperLeg",
	BodyPart.LEFT_HAND: "LeftHand",
	BodyPart.RIGHT_HAND: "RightHand",
	BodyPart.LEFT_FOOT: "LeftFoot",
	BodyPart.RIGHT_FOOT: "RightFoot",
}

const ITEM_IDS := {
	BodyPart.HEAD: "human_head",
	BodyPart.LEFT_ARM: "human_arm",
	BodyPart.RIGHT_ARM: "human_arm",
	BodyPart.LEFT_LEG: "human_leg",
	BodyPart.RIGHT_LEG: "human_leg",
	BodyPart.LEFT_HAND: "human_hand",
	BodyPart.RIGHT_HAND: "human_hand",
	BodyPart.LEFT_FOOT: "human_foot",
	BodyPart.RIGHT_FOOT: "human_foot",
}

## Skinned clothing meshes on the Skeleton3D mapped to their body part.
## On dismemberment, visible meshes for the severed part are reparented onto the limb.
const CLOTHING_MESHES := {
	BodyPart.LEFT_ARM: ["Fur_LP_Glove_Left", "Glove_Wool_Left", "Mitten_Left"],
	BodyPart.RIGHT_ARM: ["Fur_LP_Glove_Right", "Glove_Wool_Right", "Mitten_Right"],
	BodyPart.LEFT_LEG: ["Boot_Explorer_Left", "Boot_Officer_Left"],
	BodyPart.RIGHT_LEG: ["Boot_Explorer_Right", "Boot_Officer_Right"],
	BodyPart.LEFT_HAND: ["Fur_LP_Glove_Left", "Glove_Wool_Left", "Mitten_Left"],
	BodyPart.RIGHT_HAND: ["Fur_LP_Glove_Right", "Glove_Wool_Right", "Mitten_Right"],
	BodyPart.LEFT_FOOT: ["Boot_Explorer_Left", "Boot_Officer_Left"],
	BodyPart.RIGHT_FOOT: ["Boot_Explorer_Right", "Boot_Officer_Right"],
}

## Probability: [base_unarmed, base_armed, same_limb_bonus]
const PROBS := {
	"animal": [0.60, 0.25, 0.20],
	"human": [0.35, 0.15, 0.35],
	"firearm": [0.20, 0.20, 0.10],
}

@export var skeleton_path: NodePath = ^"UnitModel/Skeleton"

## Outward velocity applied to severed limbs on dismemberment.
@export var sever_impulse: float = 3.0

## TEST MODE: Force 100% dismemberment every hit, cycling through limbs.
## Enable in Inspector to test. Excludes HEAD (no head scene yet).
@export var test_mode: bool = false

## Bleeding: health drain + blood trail after dismemberment. Stopped by tourniquet.
const BLEED_DAMAGE_PER_SECOND: float = 0.2  # 1 HP per 5 seconds

var is_bleeding: bool = false
var _bleed_timer: float = 0.0

var _skeleton: Skeleton3D
var _unit: Node3D
var _physical_bones: Array[PhysicalBone3D] = []
var _is_simulation: bool = false

var _hit_counts: Dictionary = {}
var _dismembered: Dictionary = {}

## Pre-placed limb nodes found on skeleton. Key = BodyPart int, Value = RigidBody3D.
var _limb_nodes: Dictionary = {}


func _ready() -> void:
	_unit = get_parent()
	_skeleton = _unit.get_node_or_null(skeleton_path)

	if _skeleton:
		_cache_physical_bones()
		_scan_pre_placed_limbs()

	for part in BodyPart.values():
		_hit_counts[part] = 0
		_dismembered[part] = false

	var combat := _unit.get_node_or_null("CombatComponent")
	if combat:
		combat.took_damage.connect(_on_took_damage)


func _cache_physical_bones() -> void:
	for child in _skeleton.get_children():
		if child is PhysicalBoneSimulator3D:
			for bone in child.get_children():
				if bone is PhysicalBone3D:
					_physical_bones.append(bone)
			break


func _scan_pre_placed_limbs() -> void:
	## Find pre-placed limb RigidBody3D nodes under BoneAttachment3D children.
	for child in _skeleton.get_children():
		if not child is BoneAttachment3D:
			continue

		var attachment: BoneAttachment3D = child
		var bone_name: String = _skeleton.get_bone_name(attachment.bone_idx)

		# Match bone name to BodyPart
		var part: int = -1
		for p in BONE_NAMES:
			if BONE_NAMES[p] == bone_name:
				part = p
				break

		if part == -1:
			continue

		# Find the RigidBody3D child (the limb scene)
		for limb_child in attachment.get_children():
			if limb_child is RigidBody3D:
				_limb_nodes[part] = limb_child
				limb_child.visible = false
				limb_child.freeze = true
				_disable_limb_collision(limb_child)
				break

	if _limb_nodes.is_empty():
		push_warning("[Dismemberment] No pre-placed limb nodes found on skeleton")
	else:
		print("[Dismemberment] Found %d pre-placed limbs" % _limb_nodes.size())


func _disable_limb_collision(limb: RigidBody3D) -> void:
	limb.collision_layer = 0
	limb.collision_mask = 0
	for child in limb.get_children():
		if child is CollisionShape3D:
			child.disabled = true
		elif child is Area3D:
			child.monitoring = false
			child.monitorable = false


func _enable_limb_collision(limb: RigidBody3D) -> void:
	limb.collision_layer = 1 << 15  # Layer 16
	limb.collision_mask = 1  # Collide with world
	for child in limb.get_children():
		if child is CollisionShape3D:
			child.disabled = false
		elif child is Area3D:
			child.monitoring = true
			child.monitorable = true


func _physics_process(_delta: float) -> void:
	# _follow_bones() is NOT called — PhysicalBoneSimulator3D handles
	# bone sync automatically in Godot 4.5. Manually setting PhysicalBone3D
	# transforms causes their collision shapes to push the CharacterBody3D.
	pass


func _process(delta: float) -> void:
	if not is_bleeding or not is_instance_valid(_unit):
		return

	# Health drain
	if "stats" in _unit and _unit.stats:
		_unit.stats.health -= BLEED_DAMAGE_PER_SECOND * delta
		# Emit health_changed so UI updates
		var combat := _unit.get_node_or_null("CombatComponent")
		if combat:
			combat.health_changed.emit(_unit.stats.health, 100.0)
		# Death from blood loss
		if _unit.stats.health <= 0.0:
			_unit.stats.dying_cause = SurvivorStats.DeathCause.VIOLENCE
			if _unit.has_method("_on_death"):
				_unit._on_death()
			is_bleeding = false
			return

	# Blood trail decals
	_bleed_timer -= delta
	if _bleed_timer <= 0.0:
		_drop_blood_trail()
		_bleed_timer = randf_range(3.0, 5.0)


func stop_bleeding() -> void:
	## Stop bleeding (e.g., tourniquet applied).
	is_bleeding = false


func on_unit_died() -> void:
	## Clean up all active effects on death.
	is_bleeding = false
	# Turn off all particle emitters on the skeleton
	if _skeleton:
		for child in _skeleton.get_children():
			if not child is BoneAttachment3D:
				continue
			for sub in child.get_children():
				if sub is GPUParticles3D:
					sub.emitting = false


func _drop_blood_trail() -> void:
	## Drop a small blood pool decal at the unit's current position.
	var spawner := _unit.get_node_or_null("BloodDecalSpawner")
	if spawner and spawner.has_method("_spawn_pool"):
		spawner._spawn_pool(_unit.global_position)


func _follow_bones() -> void:
	for bone in _physical_bones:
		if not is_instance_valid(bone):
			continue
		var bone_offset: Transform3D = bone.body_offset
		var bone_id: int = bone.get_bone_id()
		var bone_global: Transform3D = _skeleton.global_transform * _skeleton.get_bone_global_pose(bone_id)
		bone.global_transform = bone_global * bone_offset


func _on_took_damage(_amount: float, attacker: Node3D) -> void:
	if not attacker or _is_simulation:
		return
	# Skip dismemberment during ragdoll knockback
	var ragdoll := _unit.get_node_or_null("RagdollComponent")
	if ragdoll and ragdoll.is_ragdolling:
		return

	# Test mode: 100% dismemberment, random limb (no head)
	if test_mode:
		var test_pool: Array[int] = []
		for p in BodyPart.values():
			if p == BodyPart.HEAD:
				continue
			if not _dismembered[p] and _limb_nodes.has(p):
				test_pool.append(p)
		if not test_pool.is_empty():
			_dismember(test_pool.pick_random(), attacker)
		return

	var part := _pick_target()
	if part == -1:
		return

	_hit_counts[part] += 1

	var chance := _calc_chance(attacker, part)
	if randf() < chance:
		_dismember(part, attacker)


func _pick_target() -> int:
	var pool: Array[int] = []
	var weights: Array[float] = []

	for part in [BodyPart.LEFT_ARM, BodyPart.RIGHT_ARM, BodyPart.LEFT_LEG, BodyPart.RIGHT_LEG,
			BodyPart.LEFT_HAND, BodyPart.RIGHT_HAND, BodyPart.LEFT_FOOT, BodyPart.RIGHT_FOOT]:
		if not _dismembered[part] and _limb_nodes.has(part):
			pool.append(part)
			# Hands/feet slightly less likely than full limbs
			var w: float = 0.6 if part >= BodyPart.LEFT_HAND else 1.0
			weights.append(w)

	if not _dismembered[BodyPart.HEAD] and _limb_nodes.has(BodyPart.HEAD):
		pool.append(BodyPart.HEAD)
		weights.append(0.15)

	if pool.is_empty():
		return -1

	var total := 0.0
	for w in weights:
		total += w
	var roll := randf() * total
	var sum := 0.0
	for i in pool.size():
		sum += weights[i]
		if roll <= sum:
			return pool[i]
	return pool[0]


func _calc_chance(attacker: Node3D, part: int) -> float:
	var attacker_type := "human"
	if attacker.is_in_group("animals") or "animal_name" in attacker:
		attacker_type = "animal"

	# Unarmed humans cannot dismember — fists don't sever limbs
	if attacker_type == "human":
		var has_weapon: bool = false
		if "weapon_equipped" in attacker:
			has_weapon = attacker.weapon_equipped
		elif attacker.has_method("get_equipped_weapon"):
			has_weapon = attacker.get_equipped_weapon() != null
		if not has_weapon:
			return 0.0

	var probs: Array = PROBS[attacker_type]
	var target_armed: bool = _unit.has_method("has_item_by_id") and (
		_unit.has_item_by_id("hatchet") or _unit.has_item_by_id("knife"))

	var base: float = probs[1] if target_armed else probs[0]
	var bonus: float = probs[2]
	var hits: int = _hit_counts[part]

	if hits >= 2:
		base += bonus * (hits - 1)

	return minf(base, 1.0)


func _dismember(part: int, attacker: Node3D) -> void:
	_dismembered[part] = true

	var bone_name: String = BONE_NAMES[part]
	var bone_id: int = _skeleton.find_bone(bone_name)

	# Also mark child parts as dismembered (e.g., losing arm = losing hand too)
	_mark_child_parts_dismembered(part)

	# Find physical bone and any child bones
	var physical_bone: PhysicalBone3D = _find_physical_bone(bone_name)
	var child_physical: PhysicalBone3D = _find_child_physical_bone(bone_id)

	# Remove physical bones from scene and array
	_remove_physical_bones([physical_bone, child_physical])

	# Scale down animated bones to hide mesh (recursive)
	_hide_animated_bone(bone_id)

	# Release pre-placed limb into the world
	var limb: RigidBody3D = _release_limb(part, attacker)

	# DISABLED: Clothing transfer produces wrong transforms for most pairs
	# TODO: Fix transform calculation — only officer boots + trousers bind correctly
	#if limb:
	#	_transfer_clothing_to_limb(part, limb)
	#	_cascade_child_attachments(bone_id, limb)

	# Blood effect at bone position
	var bone_pos: Vector3 = (_skeleton.global_transform * _skeleton.get_bone_global_pose(bone_id)).origin
	_spawn_blood(bone_id, bone_pos)

	limb_dismembered.emit(part, bone_pos, limb)
	print("[Dismemberment] %s lost %s" % [_unit.name, bone_name])

	# Start bleeding (skip for decapitation — instant death anyway)
	if part != BodyPart.HEAD and not is_bleeding:
		is_bleeding = true
		_bleed_timer = 0.0  # Immediate first blood drop

	# Force disengage from combat and set flee direction
	var combat := _unit.get_node_or_null("CombatComponent")
	if combat and combat.has_method("stop_combat"):
		combat.stop_combat()

	# Set threat position on blackboard so BTFlee knows which way to run
	var ai: Node = _unit.get_node_or_null("PassiveAIController")
	if not ai:
		ai = _unit.get_node_or_null("BTPlayer")
	if ai and ai.has_method("get_blackboard"):
		var bb: Blackboard = ai.get_blackboard()
		if bb and attacker and is_instance_valid(attacker):
			bb.set_var(&"threat_position", attacker.global_position)
			bb.set_var(&"threat_target", attacker)

	# Decapitation triggers full ragdoll and death
	if part == BodyPart.HEAD:
		_start_ragdoll()
		if combat:
			combat.take_damage(9999.0, attacker)


func _mark_child_parts_dismembered(part: int) -> void:
	## When a parent limb is severed, child parts are also gone.
	match part:
		BodyPart.LEFT_ARM:
			_dismembered[BodyPart.LEFT_HAND] = true
			# Remove child limb node so it doesn't get released separately
			_limb_nodes.erase(BodyPart.LEFT_HAND)
		BodyPart.RIGHT_ARM:
			_dismembered[BodyPart.RIGHT_HAND] = true
			_limb_nodes.erase(BodyPart.RIGHT_HAND)
		BodyPart.LEFT_LEG:
			_dismembered[BodyPart.LEFT_FOOT] = true
			_limb_nodes.erase(BodyPart.LEFT_FOOT)
		BodyPart.RIGHT_LEG:
			_dismembered[BodyPart.RIGHT_FOOT] = true
			_limb_nodes.erase(BodyPart.RIGHT_FOOT)


func _release_limb(part: int, attacker: Node3D) -> RigidBody3D:
	## Reparent pre-placed limb to scene root, enable physics, apply impulse.
	var limb: RigidBody3D = _limb_nodes.get(part)
	if not limb:
		push_warning("[Dismemberment] No pre-placed limb for part %d" % part)
		return null

	# Record current global transform (already at animated position via BoneAttachment3D)
	var limb_transform: Transform3D = limb.global_transform

	# Reparent to scene root so it becomes an independent physics object
	limb.get_parent().remove_child(limb)
	get_tree().current_scene.add_child(limb)

	# Restore transform (reparenting resets it)
	limb.global_transform = limb_transform

	# Enable physics and visibility
	limb.freeze = false
	limb.visible = true
	_enable_limb_collision(limb)

	# Set item ID for butchering/collection
	limb.set_meta("item_id", ITEM_IDS[part])

	# Apply outward impulse away from attacker
	var impulse_dir: Vector3 = Vector3.ZERO
	if attacker and is_instance_valid(attacker):
		impulse_dir = (limb.global_position - attacker.global_position).normalized()
	else:
		impulse_dir = (limb.global_position - _unit.global_position).normalized()

	# Add slight upward component so limb arcs rather than sliding
	impulse_dir.y = absf(impulse_dir.y) + 0.3
	impulse_dir = impulse_dir.normalized()
	limb.apply_impulse(impulse_dir * sever_impulse)

	# Remove from tracking dict
	_limb_nodes.erase(part)

	return limb


func _transfer_clothing_to_limb(part: int, limb: RigidBody3D) -> void:
	## Reparent visible skinned clothing meshes (gloves, boots) onto the severed limb.
	## These are MeshInstance3D children of the Skeleton3D with skin bindings.
	## They'll render in bind pose on the limb — imperfect but acceptable.
	if not CLOTHING_MESHES.has(part):
		return

	var mesh_names: Array = CLOTHING_MESHES[part]
	for mesh_name in mesh_names:
		var mesh_node: MeshInstance3D = _skeleton.get_node_or_null(mesh_name)
		if not mesh_node or not mesh_node.visible:
			continue

		var xform: Transform3D = mesh_node.global_transform
		_skeleton.remove_child(mesh_node)
		limb.add_child(mesh_node)
		mesh_node.global_transform = xform
		# Clear skin reference since there's no skeleton parent anymore
		mesh_node.skin = null
		mesh_node.skeleton = NodePath()


func _cascade_child_attachments(bone_id: int, limb: RigidBody3D) -> void:
	## Find BoneAttachment3D nodes on descendant bones and reparent their
	## visible children (gloves, weapons, boots) onto the severed limb.
	var descendant_ids: Array[int] = _get_all_bone_descendants(bone_id)

	for child in _skeleton.get_children():
		if not child is BoneAttachment3D:
			continue

		# Skip our own limb attachments
		if _limb_nodes.values().has(child) or child == limb.get_parent():
			continue

		if child.bone_idx in descendant_ids:
			var items_to_move: Array[Node] = []
			for item in child.get_children():
				if item is Node3D and item.visible:
					items_to_move.append(item)

			for item in items_to_move:
				var item_xform: Transform3D = item.global_transform
				child.remove_child(item)
				limb.add_child(item)
				item.global_transform = item_xform


func _get_all_bone_descendants(bone_id: int) -> Array[int]:
	var result: Array[int] = []
	for child_id in _skeleton.get_bone_children(bone_id):
		result.append(child_id)
		result.append_array(_get_all_bone_descendants(child_id))
	return result


func _find_physical_bone(bone_name: String) -> PhysicalBone3D:
	for bone in _physical_bones:
		if is_instance_valid(bone) and bone.bone_name == bone_name:
			return bone
	return null


func _find_child_physical_bone(parent_bone_id: int) -> PhysicalBone3D:
	var children: PackedInt32Array = _skeleton.get_bone_children(parent_bone_id)
	if children.is_empty():
		return null

	var child_bone_name: String = _skeleton.get_bone_name(children[0])
	return _find_physical_bone(child_bone_name)


func _remove_physical_bones(bones: Array) -> void:
	for bone in bones:
		if bone and is_instance_valid(bone):
			bone.collision_layer = 0
			bone.collision_mask = 0
			_physical_bones.erase(bone)
			bone.queue_free()


func _hide_animated_bone(bone_id: int) -> void:
	## Hide bone by scaling near-zero. Must be > 0 to avoid NaN transforms
	## in the renderer, but small enough to be invisible.
	_skeleton.set_bone_pose_scale(bone_id, Vector3.ONE * 0.001)

	for child_id in _skeleton.get_bone_children(bone_id):
		_hide_animated_bone(child_id)


func _start_ragdoll() -> void:
	_is_simulation = true
	var ragdoll := _unit.get_node_or_null("RagdollComponent")
	if ragdoll:
		ragdoll.trigger_ragdoll(Vector3.DOWN, 0.0)
	else:
		# Fallback: start simulation directly on the simulator
		for child in _skeleton.get_children():
			if child is PhysicalBoneSimulator3D:
				child.physical_bones_start_simulation()
				break


func _spawn_blood(bone_id: int, pos: Vector3) -> void:
	# Activate pre-placed GPUParticles3D on the BoneAttachment3D
	_activate_bone_particles(bone_id)

	# Ground blood decals
	var spawner := _unit.get_node_or_null("BloodDecalSpawner")
	if spawner and spawner.has_method("_spawn_pool"):
		spawner._spawn_pool(pos)
		spawner._spawn_pool(pos + Vector3(randf_range(-0.4, 0.4), 0, randf_range(-0.4, 0.4)))


func _activate_bone_particles(bone_id: int) -> void:
	## Find and activate GPUParticles3D on the BoneAttachment3D for this bone.
	for child in _skeleton.get_children():
		if not child is BoneAttachment3D:
			continue
		if child.bone_idx != bone_id:
			continue
		for sub in child.get_children():
			if sub is GPUParticles3D:
				sub.emitting = true
