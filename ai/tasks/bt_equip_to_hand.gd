@tool
extends BTAction
class_name BTEquipToHand
## Reparents equipped weapon from back to hand.
## Animation is handled separately by BTPlayAnimation in BT sequence.

func _generate_name() -> String:
	return "EquipToHand"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	var equipment = agent.get_node_or_null("EquipmentAnimationComponent")
	if not equipment:
		return SUCCESS  # No equipment component, skip

	if not equipment.has_melee_weapon():
		return SUCCESS  # No weapon to equip, skip

	if equipment.weapon_equipped:
		return FAILURE  # Already equipped - stop sequence to skip animation

	equipment.move_to_hand()
	return SUCCESS
