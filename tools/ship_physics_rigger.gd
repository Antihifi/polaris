@tool
extends EditorScript
## Ship Physics Rigger Tool
##
## Processes a ship destruction scene and wraps each MeshInstance3D in a RigidBody3D
## with appropriate collision shapes based on the parent group type.
##
## Usage: Open the scene in editor, then run this script via:
##   Project → Tools → Execute Current Script (or Ctrl+Shift+X)
##
## Groups:
##   - Rigging_* / Shroud_* : No collision, visual-only physics, tagged "rigging"
##   - Everything else: Box collision at 80% mesh size, tagged "debris"

const COLLISION_SCALE := 0.8  # 80% of mesh AABB size
const WOOD_DENSITY := 500.0   # kg/m³
const METAL_DENSITY := 2000.0 # kg/m³

# Collision layers
const LAYER_GROUND := 1      # Static geometry
const LAYER_DEBRIS := 2      # Falling debris

var processed_count := 0
var rigging_count := 0
var debris_count := 0
var skipped_count := 0


func _run() -> void:
	var root := get_editor_interface().get_edited_scene_root()
	if not root:
		printerr("No scene open! Open erebus_fragmented_v_1.tscn first.")
		return

	print("=== Ship Physics Rigger ===")
	print("Processing scene: ", root.name)

	# Reset counters
	processed_count = 0
	rigging_count = 0
	debris_count = 0
	skipped_count = 0

	# Collect all MeshInstance3D nodes first (to avoid modifying tree while iterating)
	var meshes: Array[MeshInstance3D] = []
	collect_meshes(root, meshes)

	print("Found ", meshes.size(), " MeshInstance3D nodes to process")

	# Process each mesh
	for mesh in meshes:
		if is_valid_for_processing(mesh):
			rig_mesh(mesh)
		else:
			skipped_count += 1

	print("")
	print("=== Processing Complete ===")
	print("Total processed: ", processed_count)
	print("  - Rigging pieces (no collision): ", rigging_count)
	print("  - Debris pieces (with collision): ", debris_count)
	print("  - Skipped: ", skipped_count)
	print("")
	print("Remember to save the scene as a new file!")


func collect_meshes(node: Node, meshes: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D:
		meshes.append(node)
	for child in node.get_children():
		collect_meshes(child, meshes)


func is_valid_for_processing(mesh: MeshInstance3D) -> bool:
	# Skip if already has a RigidBody3D parent
	if mesh.get_parent() is RigidBody3D:
		return false
	# Skip if mesh has no actual mesh data
	if not mesh.mesh:
		return false
	return true


func is_rigging_group(mesh: MeshInstance3D) -> bool:
	# Check parent and ancestors for Rigging_ or Shroud_ naming
	var node: Node = mesh.get_parent()
	while node:
		var name_lower := node.name.to_lower()
		if name_lower.begins_with("rigging_") or name_lower.begins_with("shroud_"):
			return true
		node = node.get_parent()
	return false


func rig_mesh(mesh: MeshInstance3D) -> void:
	var is_rigging := is_rigging_group(mesh)
	var aabb := mesh.get_aabb()

	# Skip tiny meshes (likely artifacts)
	if aabb.size.length() < 0.01:
		skipped_count += 1
		return

	# Create RigidBody3D
	var body := RigidBody3D.new()
	body.name = mesh.name + "_body"
	body.freeze = true  # Start frozen until triggered
	body.mass = calculate_mass(aabb, mesh)

	# Get parent info before reparenting
	var parent := mesh.get_parent()
	var idx := mesh.get_index()
	var mesh_transform := mesh.transform

	# Set ownership root
	var scene_root := get_editor_interface().get_edited_scene_root()

	# Reparent: remove mesh from parent, add body to parent, add mesh to body
	parent.remove_child(mesh)
	parent.add_child(body)
	parent.move_child(body, idx)
	body.add_child(mesh)

	# Transfer transform: body gets mesh's original transform, mesh becomes identity
	body.transform = mesh_transform
	mesh.transform = Transform3D.IDENTITY

	# Set ownership for scene saving
	body.owner = scene_root
	mesh.owner = scene_root

	if is_rigging:
		# Rigging: no collision, just gravity fall
		body.add_to_group("rigging")
		body.collision_layer = 0  # No collision layer
		body.collision_mask = 0   # Doesn't detect anything
		rigging_count += 1
	else:
		# Structural debris: box collision, interacts with ground only
		body.add_to_group("debris")
		body.collision_layer = LAYER_DEBRIS
		body.collision_mask = LAYER_GROUND  # Only collides with ground/static
		add_box_collision(body, aabb, scene_root)
		debris_count += 1

	processed_count += 1

	# Progress indicator every 100 meshes
	if processed_count % 100 == 0:
		print("  Processed ", processed_count, " meshes...")


func add_box_collision(body: RigidBody3D, aabb: AABB, scene_root: Node) -> void:
	var col := CollisionShape3D.new()
	col.name = "CollisionShape3D"

	var shape := BoxShape3D.new()
	shape.size = aabb.size * COLLISION_SCALE
	col.shape = shape

	# Position collision shape at AABB center
	col.position = aabb.get_center()

	body.add_child(col)
	col.owner = scene_root


func calculate_mass(aabb: AABB, mesh: MeshInstance3D) -> float:
	# Calculate volume in cubic meters
	var volume := aabb.size.x * aabb.size.y * aabb.size.z

	# Determine material type by name
	var density := WOOD_DENSITY
	if mesh.mesh:
		for i in range(mesh.mesh.get_surface_count()):
			var mat := mesh.mesh.surface_get_material(i)
			if mat and mat.resource_name:
				var mat_name := mat.resource_name.to_lower()
				if "metal" in mat_name or "iron" in mat_name or "steel" in mat_name:
					density = METAL_DENSITY
					break

	# Calculate mass, with minimum of 0.1 kg
	var mass := volume * density
	return maxf(mass, 0.1)
