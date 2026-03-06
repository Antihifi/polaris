@tool
extends BTCondition
class_name BTCheckRagdoll
## Returns FAILURE if agent is currently ragdolling (knocked down).
## Place at top of BT to gate all behavior during ragdoll.


func _generate_name() -> String:
	return "NotRagdolling?"


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE
	var ragdoll := agent.get_node_or_null("RagdollComponent")
	if ragdoll and ragdoll.is_ragdolling:
		return FAILURE
	return SUCCESS
