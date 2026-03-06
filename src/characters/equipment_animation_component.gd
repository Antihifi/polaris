class_name EquipmentAnimationComponent extends Node
## Manages equipment visibility between back and hand for combat.
## For each weapon type, TWO instances should be placed in editor:
## one under BackAttachment, one under RightHand.
## This component toggles visibility - NO reparenting.

var weapon_equipped: bool = false  ## BT checks this via BTCheckAgentProperty

var _unit: Node = null
var _back_hatchet: Node3D = null
var _hand_hatchet: Node3D = null
var _back_knife: Node3D = null
var _hand_knife: Node3D = null


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
	## Find weapon nodes in their bone attachments.
	var skeleton: Node = _unit.get_node_or_null("UnitModel/Skeleton")
	if not skeleton:
		return

	var back_attachment: Node = skeleton.get_node_or_null("BackAttachment")
	var hand_attachment: Node = skeleton.get_node_or_null("RightHand")

	if back_attachment:
		for child in back_attachment.get_children():
			if not child is Node3D:
				continue
			var lower_name: String = child.name.to_lower()
			if "hatchet" in lower_name and not _back_hatchet:
				_back_hatchet = child
				_disable_collision(child)
			elif "knife" in lower_name and not _back_knife:
				_back_knife = child
				_disable_collision(child)

	if hand_attachment:
		for child in hand_attachment.get_children():
			if not child is Node3D:
				continue
			var lower_name: String = child.name.to_lower()
			if "hatchet" in lower_name and not _hand_hatchet:
				_hand_hatchet = child
				_disable_collision(child)
			elif "knife" in lower_name and not _hand_knife:
				_hand_knife = child
				_disable_collision(child)


func _connect_inventory_signals() -> void:
	if not _unit:
		return
	if _unit.has_signal("inventory_changed"):
		_unit.inventory_changed.connect(_on_inventory_changed)


func _on_inventory_changed() -> void:
	_update_visibility()


func _update_visibility() -> void:
	## Update equipment visibility based on inventory and combat state.
	var has_hatchet := _unit_has_item_in_inventory("hatchet")
	var has_knife := _unit_has_item_in_inventory("knife")
	var active_is_hatchet: bool = has_hatchet and (_back_hatchet or _hand_hatchet)
	var active_is_knife: bool = has_knife and not active_is_hatchet and (_back_knife or _hand_knife)

	if weapon_equipped:
		# In combat: show active weapon in hand, hide its back version
		# Non-active weapon stays on back
		if _back_hatchet:
			_back_hatchet.visible = false if active_is_hatchet else has_hatchet
		if _hand_hatchet:
			_hand_hatchet.visible = active_is_hatchet
		if _back_knife:
			_back_knife.visible = false if active_is_knife else has_knife
		if _hand_knife:
			_hand_knife.visible = active_is_knife
	else:
		# Not in combat: show all owned weapons on back, hide hands
		if _back_hatchet:
			_back_hatchet.visible = has_hatchet
		if _hand_hatchet:
			_hand_hatchet.visible = false
		if _back_knife:
			_back_knife.visible = has_knife
		if _hand_knife:
			_hand_knife.visible = false


func _unit_has_item_in_inventory(prototype_id: String) -> bool:
	if not _unit:
		return false
	if _unit.has_method("has_item_by_id"):
		return _unit.has_item_by_id(prototype_id)
	if "inventory" in _unit and _unit.inventory:
		return _unit.inventory.has_item_with_prototype_id(prototype_id)
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
	## Stop unit, play equip animation, then show active weapon in hand.
	if weapon_equipped:
		return

	# Stop unit movement during equip
	if _unit.has_method("stop"):
		_unit.stop()
	if "is_moving" in _unit:
		_unit.is_moving = false

	# Determine equip animation based on active weapon
	var equip_anim: String = _get_equip_animation()

	# Play equip animation if available
	var anim_player: AnimationPlayer = null
	if "animation_tree" in _unit and _unit.animation_tree:
		anim_player = _unit.animation_tree.get_node_or_null("../AnimationPlayer")
	if not anim_player and _unit.has_method("_play_animation"):
		_unit._play_animation(equip_anim)
		await _unit.get_tree().create_timer(1.0).timeout
	elif anim_player and anim_player.has_animation(equip_anim):
		anim_player.play(equip_anim)
		await anim_player.animation_finished

	# NOW toggle visibility after animation completes
	weapon_equipped = true
	_update_visibility()


func move_to_back() -> void:
	## Show back weapons, hide hand weapons.
	if not weapon_equipped:
		return
	weapon_equipped = false
	_update_visibility()


func has_melee_weapon() -> bool:
	## Returns true if unit has any melee weapon in inventory with matching equipment nodes.
	if _unit_has_item_in_inventory("hatchet") and (_back_hatchet or _hand_hatchet):
		return true
	if _unit_has_item_in_inventory("knife") and (_back_knife or _hand_knife):
		return true
	return false


func trigger_blood_particles() -> void:
	## Trigger blood splatter particles on the active hand weapon at attack impact moment.
	var active_hand: Node3D = _get_active_hand_weapon()
	if not active_hand or not active_hand.visible:
		return

	for child in active_hand.get_children():
		if child is GPUParticles3D:
			child.emitting = true
			break


func _get_active_hand_weapon() -> Node3D:
	## Returns the hand weapon node for the active (preferred) weapon.
	if _unit_has_item_in_inventory("hatchet") and _hand_hatchet:
		return _hand_hatchet
	if _unit_has_item_in_inventory("knife") and _hand_knife:
		return _hand_knife
	return null


func _get_equip_animation() -> String:
	## Returns the equip animation name based on active weapon.
	if _unit_has_item_in_inventory("hatchet") and (_back_hatchet or _hand_hatchet):
		return "unarmed_equip_over_shoulder"
	return "drawing_knife"
