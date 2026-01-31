@tool
extends EditorScript
## One-time fix for fragments with mesh geometry offset from their RigidBody3D origins.
## This fixes physics rotation happening around the wrong point.
##
## Usage:
##   1. Open erebus_physics_ready.tscn in editor
##   2. Script > Run (Ctrl+Shift+X)
##   3. Save scene (Ctrl+S)

# Groups with known origin issues
const GROUPS_TO_FIX: Array[String] = [
	"Rigging_Foremast", "Rigging_MainMast", "Mast_MizzenMast"
]


func _run() -> void:
	var scene := get_editor_interface().get_edited_scene_root()
	if not scene:
		printerr("No scene open!")
		return

	# Handle both cases: ErebusFragmentedV1 as root or as child
	var ship: Node
	if scene.name == "ErebusFragmentedV1":
		ship = scene
	else:
		ship = scene.get_node_or_null("ErebusFragmentedV1")

	if not ship:
		printerr("ErebusFragmentedV1 not found in scene")
		return

	var fixed := 0
	for group_name in GROUPS_TO_FIX:
		var group := ship.get_node_or_null(group_name)
		if not group:
			print("Group not found: ", group_name)
			continue

		for child in group.get_children():
			if child is RigidBody3D:
				fixed += _fix_rigidbody_origin(child)

	print("Fixed ", fixed, " rigidbody origins. Save the scene to persist changes.")


func _fix_rigidbody_origin(rb: RigidBody3D) -> int:
	# Find MeshInstance3D child
	var mesh_instance: MeshInstance3D
	var collision_shape: CollisionShape3D
	for child in rb.get_children():
		if child is MeshInstance3D:
			mesh_instance = child
		elif child is CollisionShape3D:
			collision_shape = child

	if not mesh_instance or not mesh_instance.mesh:
		return 0

	# Get mesh center from AABB
	var aabb := mesh_instance.mesh.get_aabb()
	var center := aabb.get_center()

	# Skip if already centered (center near zero)
	if center.length() < 0.1:
		return 0

	# Move RigidBody to mesh center, offset children back to keep visual/collision position
	rb.position += center
	mesh_instance.position -= center
	if collision_shape:
		collision_shape.position -= center
	return 1
