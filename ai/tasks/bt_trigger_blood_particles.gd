@tool
extends BTAction
class_name BTTriggerBloodParticles
## Trigger blood particle effect on agent's equipped weapon.
## Place this in BT sequence at the exact frame you want particles.
## Decoupled from animation names - BT controls timing.


func _generate_name() -> String:
	return "TriggerBloodParticles"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Find EquipmentAnimationComponent and trigger particles
	var equipment = agent.get_node_or_null("EquipmentAnimationComponent")
	if equipment and equipment.has_method("trigger_blood_particles"):
		equipment.trigger_blood_particles()
		return SUCCESS

	# Fallback: try to find any GPUParticles3D in hand attachments
	var hand := agent.find_child("RightHand", true, false)
	if hand:
		for child in hand.get_children():
			if child is GPUParticles3D:
				child.emitting = true
				return SUCCESS

	# No particles found - still succeed (unarmed attacks have no weapon particles)
	return SUCCESS
