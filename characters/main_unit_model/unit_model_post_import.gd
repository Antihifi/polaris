@tool
extends EditorScenePostImport
## Post-import script for unit_model_modular.glb.
## Runs automatically every time the GLB is reimported.
## Fixes motion_scale, skeleton naming, and other import-fragile settings.

## Must match the FBX skeleton's motion_scale for animations to work correctly.
## FBX compresses coordinates by this factor; animations are keyed against it.
const MOTION_SCALE := 0.3143


func _post_import(scene: Node) -> Object:
	var skeleton: Skeleton3D = _find_skeleton(scene)
	if not skeleton:
		push_error("[PostImport] No Skeleton3D found in imported scene!")
		return scene

	# Fix motion_scale — without this, animations make the model float.
	skeleton.motion_scale = MOTION_SCALE
	print("[PostImport] Set motion_scale = %s on %s" % [MOTION_SCALE, skeleton.name])

	# Ensure skeleton is named "Skeleton" for %Skeleton path resolution.
	if skeleton.name != "Skeleton":
		skeleton.name = "Skeleton"
		print("[PostImport] Renamed skeleton to 'Skeleton'")

	# Mark as unique name so animation tracks using %Skeleton resolve correctly.
	skeleton.unique_name_in_owner = true

	return scene


func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var result: Skeleton3D = _find_skeleton(child)
		if result:
			return result
	return null
