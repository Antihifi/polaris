class_name SeveredLimb extends RigidBody3D
## Collectible severed body part. Right-click with knife to collect.
## Attach this script to each dismembered limb RigidBody3D scene.

const CORPSE_LAYER: int = 16

var item_id: String:
	get:
		return get_meta("item_id", "human_arm")


func _ready() -> void:
	collision_layer = 1 << (CORPSE_LAYER - 1)
	add_to_group("severed_limbs")
	add_to_group("butcherable")

	var interaction := get_node_or_null("InteractionCollider")
	if interaction:
		interaction.collision_layer = 1 << (CORPSE_LAYER - 1)


func collect(collector: Node3D) -> void:
	## Called when unit with knife right-clicks this limb.
	if "inventory" in collector and collector.inventory:
		collector.inventory.create_and_add_item(item_id)
		print("[SeveredLimb] %s collected %s" % [collector.name, item_id])
	queue_free()


func get_butcher_yield() -> Dictionary:
	## Returns what this limb yields when butchered.
	return {item_id: 1}
