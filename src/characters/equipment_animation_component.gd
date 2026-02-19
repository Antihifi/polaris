class_name EquipmentAnimationComponent extends Node
## Manages equipment visibility between back and hand for combat.
## TWO hatchets should be placed in editor: one under BackAttachment, one under RightHand.
## This component toggles visibility - NO reparenting.

var weapon_equipped: bool = false  ## BT checks this via BTCheckAgentProperty

var _unit: Node = null
var _back_hatchet: Node3D = null  ## Hatchet under BackAttachment
var _hand_hatchet: Node3D = null  ## Hatchet under RightHand


func _ready() -> void:
	_unit = get_parent()
	if not _unit:
		push_error("[EquipmentAnimationComponent] Must be child of unit")
		return

	call_deferred("_initialize")


func _initialize() -> void:
	_find_equipment()
	_connect_inventory_signals()
	_update_visibility()


func _find_equipment() -> void:
	## Find both hatchets in their bone attachments.
	var skeleton: Node = _unit.get_node_or_null("UnitModel/Skeleton")
	if not skeleton:
		return

	var back_attachment: Node = skeleton.get_node_or_null("BackAttachment")
	var hand_attachment: Node = skeleton.get_node_or_null("RightHand")

	if back_attachment:
		for child in back_attachment.get_children():
			if child is Node3D and "hatchet" in child.name.to_lower():
				_back_hatchet = child
				_disable_collision(child)
				break

	if hand_attachment:
		for child in hand_attachment.get_children():
			if child is Node3D and "hatchet" in child.name.to_lower():
				_hand_hatchet = child
				_disable_collision(child)
				break


func _connect_inventory_signals() -> void:
	if not _unit:
		return
	if _unit.has_signal("inventory_changed"):
		_unit.inventory_changed.connect(_on_inventory_changed)


func _on_inventory_changed() -> void:
	_update_visibility()


func _update_visibility() -> void:
	## Update equipment visibility based on inventory and combat state.
	var has_hatchet := _unit_has_hatchet_in_inventory()

	if weapon_equipped:
		# In combat: show hand, hide back
		if _back_hatchet:
			_back_hatchet.visible = false
		if _hand_hatchet:
			_hand_hatchet.visible = has_hatchet
	else:
		# Not in combat: show back, hide hand
		if _back_hatchet:
			_back_hatchet.visible = has_hatchet
		if _hand_hatchet:
			_hand_hatchet.visible = false


func _unit_has_hatchet_in_inventory() -> bool:
	if not _unit:
		return false
	if _unit.has_method("has_item_by_id"):
		return _unit.has_item_by_id("hatchet")
	if "inventory" in _unit and _unit.inventory:
		return _unit.inventory.has_item_with_prototype_id("hatchet")
	return false


func _disable_collision(node: Node3D) -> void:
	for child in node.get_children():
		if child is CollisionShape3D:
			child.disabled = true
		elif child is Area3D:
			child.monitoring = false
			child.monitorable = false
		_disable_collision(child)


# --- Public API (called by BT tasks) ---

func move_to_hand() -> void:
	## Stop unit, play equip animation, then show hand hatchet.
	if weapon_equipped:
		return

	# Stop unit movement during equip
	if _unit.has_method("stop"):
		_unit.stop()
	if "is_moving" in _unit:
		_unit.is_moving = false

	# Play equip animation if available
	var anim_player: AnimationPlayer = null
	if "animation_tree" in _unit and _unit.animation_tree:
		# Use animation tree's animation player
		anim_player = _unit.animation_tree.get_node_or_null("../AnimationPlayer")
	if not anim_player and _unit.has_method("_play_animation"):
		# Use unit's built-in animation method
		_unit._play_animation("unarmed_equip_over_shoulder")
		# Wait for animation (approximate duration)
		await _unit.get_tree().create_timer(1.0).timeout
	elif anim_player and anim_player.has_animation("unarmed_equip_over_shoulder"):
		anim_player.play("unarmed_equip_over_shoulder")
		await anim_player.animation_finished

	# NOW toggle visibility after animation completes
	weapon_equipped = true
	_update_visibility()


func move_to_back() -> void:
	## Show back hatchet, hide hand hatchet.
	if not weapon_equipped:
		return
	weapon_equipped = false
	_update_visibility()


func has_melee_weapon() -> bool:
	## Returns true if unit has a hatchet in inventory AND equipment exists.
	if not _unit_has_hatchet_in_inventory():
		return false
	return _back_hatchet != null or _hand_hatchet != null


func trigger_blood_particles() -> void:
	## Trigger blood splatter particles on hatchet at attack impact moment.
	## Called by BTTriggerBloodParticles task - timing controlled by BT, not animation listener.
	if not _hand_hatchet or not _hand_hatchet.visible:
		return

	for child in _hand_hatchet.get_children():
		if child is GPUParticles3D:
			child.emitting = true
			break
