class_name BuildRecipe
extends Resource
## Defines a buildable item recipe for the construction system.

@export var id: StringName = &""
@export var display_name: String = ""
@export var description: String = ""

@export_group("Construction")
## Scene to spawn when construction completes.
@export var result_scene: PackedScene
## Path to result scene (for lazy loading and mesh extraction).
@export var result_scene_path: String = ""
## Mesh to use for construction site placeholder (cached from scene).
@export var placeholder_mesh: Mesh
## Number of in-game days to complete (1-10).
@export_range(1, 10) var construction_days: int = 2
## Materials required: {"scrap_wood": 5, "nails": 2}
@export var required_materials: Dictionary = {}

@export_group("Display")
@export var icon: Texture2D


func get_total_work_hours() -> float:
	## Returns total work hours needed (24 hours per day).
	return construction_days * 24.0


func get_material_cost(material_id: String) -> int:
	## Returns the amount of a specific material needed.
	return required_materials.get(material_id, 0) as int


func has_all_materials(available: Dictionary) -> bool:
	## Check if available materials meet requirements.
	for mat_id: String in required_materials:
		var needed: int = required_materials[mat_id]
		var have: int = available.get(mat_id, 0) as int
		if have < needed:
			return false
	return true


func get_missing_materials(available: Dictionary) -> Dictionary:
	## Returns dictionary of materials still needed.
	var missing: Dictionary = {}
	for mat_id: String in required_materials:
		var needed: int = required_materials[mat_id]
		var have: int = available.get(mat_id, 0) as int
		if have < needed:
			missing[mat_id] = needed - have
	return missing


func get_placeholder_mesh() -> Mesh:
	## Get placeholder mesh, extracting from scene if needed.
	if placeholder_mesh:
		return placeholder_mesh

	# Try to extract mesh from scene.
	if result_scene_path.is_empty():
		return null

	if not ResourceLoader.exists(result_scene_path):
		push_warning("BuildRecipe: Scene not found: %s" % result_scene_path)
		return null

	var scene: PackedScene = load(result_scene_path)
	if not scene:
		return null

	# Instantiate temporarily to extract mesh.
	var instance: Node = scene.instantiate()
	var mesh: Mesh = _find_first_mesh(instance)
	instance.queue_free()

	# Cache for future use.
	if mesh:
		placeholder_mesh = mesh

	return mesh


func _find_first_mesh(node: Node) -> Mesh:
	## Recursively find the first MeshInstance3D and return its mesh.
	if node is MeshInstance3D:
		var mi: MeshInstance3D = node
		if mi.mesh:
			return mi.mesh

	for child in node.get_children():
		var found: Mesh = _find_first_mesh(child)
		if found:
			return found

	return null
