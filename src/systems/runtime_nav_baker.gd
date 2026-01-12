class_name RuntimeNavBaker extends Node
## Dynamic NavMesh baker that follows the player.
## Adapted from Terrain3D demo's RuntimeNavigationBaker.gd
## Bakes NavMesh in chunks around the player for efficient runtime navigation.

signal bake_finished

@export var enabled: bool = true : set = set_enabled
@export var enter_cost: float = 0.0 : set = set_enter_cost
@export var travel_cost: float = 1.0 : set = set_travel_cost
@export_flags_3d_navigation var navigation_layers: int = 1 : set = set_navigation_layers
@export var template: NavigationMesh : set = set_template

## Reference to Terrain3D node (set by controller after terrain creation)
var terrain: Node = null

## Node to track for NavMesh baking (usually the captain/player)
@export var player: Node3D

## Size of NavMesh chunk to bake (256x512x256 = 256m wide, 512m tall, 256m deep)
@export var mesh_size := Vector3(256, 512, 256)

## Minimum distance player must move before re-baking
@export var min_rebake_distance: float = 64.0

## Cooldown between bakes to prevent spam
@export var bake_cooldown: float = 1.0

@export_group("Debug")
@export var log_timing: bool = true  # Enable timing logs by default for debugging

var _scene_geometry: NavigationMeshSourceGeometryData3D
var _current_center := Vector3(INF, INF, INF)

var _bake_task_id: int = -1
var _bake_task_timer: float = 0.0
var _bake_cooldown_timer: float = 0.0
var _nav_region: NavigationRegion3D


func _ready() -> void:
	_nav_region = NavigationRegion3D.new()
	_nav_region.name = "DynamicNavRegion"
	_nav_region.navigation_layers = navigation_layers
	_nav_region.enabled = enabled
	_nav_region.enter_cost = enter_cost
	_nav_region.travel_cost = travel_cost

	# Demo uses edge_connections = false to avoid performance hitches during rebakes.
	# Edge connections cause the main thread to compare every edge when navmesh updates.
	_nav_region.use_edge_connections = false

	add_child(_nav_region)

	# Create default template if not provided - MATCH DEMO EXACTLY
	# See tmp/demo/CodeGeneratedDemo.tscn NavigationMesh_vs6am
	if not template:
		template = NavigationMesh.new()
		# Use STATIC_COLLIDERS since we add terrain faces manually via add_faces()
		template.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
		template.agent_height = 2.0
		template.agent_max_slope = 30.0  # Demo default (not 45)

	# MUST update map cell size AFTER template is set
	_update_map_cell_size()

	print("[RuntimeNavBaker] Initialized with cell_size=%.2f, cell_height=%.2f, slope=%.0f, edge_connections=%s" % [
		template.cell_size, template.cell_height, template.agent_max_slope, _nav_region.use_edge_connections])

	# Parse existing scene geometry after scene is ready
	parse_scene.call_deferred()


func set_enabled(p_value: bool) -> void:
	enabled = p_value
	if _nav_region:
		_nav_region.enabled = enabled
	set_process(enabled and template)


func set_enter_cost(p_value: float) -> void:
	enter_cost = p_value
	if _nav_region:
		_nav_region.enter_cost = enter_cost


func set_travel_cost(p_value: float) -> void:
	travel_cost = p_value
	if _nav_region:
		_nav_region.travel_cost = travel_cost


func set_navigation_layers(p_value: int) -> void:
	navigation_layers = p_value
	if _nav_region:
		_nav_region.navigation_layers = navigation_layers


func set_template(p_value: NavigationMesh) -> void:
	template = p_value
	set_process(enabled and template)
	_update_map_cell_size()


func parse_scene() -> void:
	_scene_geometry = NavigationMeshSourceGeometryData3D.new()
	NavigationServer3D.parse_source_geometry_data(template, _scene_geometry, self)


func _update_map_cell_size() -> void:
	# Match demo: just set cell size/height, nothing else
	if get_viewport() and template:
		var map := get_viewport().find_world_3d().navigation_map
		NavigationServer3D.map_set_cell_size(map, template.cell_size)
		NavigationServer3D.map_set_cell_height(map, template.cell_height)


func _process(p_delta: float) -> void:
	if _bake_task_id != -1:
		_bake_task_timer += p_delta

	if not player or _bake_task_id != -1:
		return

	if _bake_cooldown_timer > 0.0:
		_bake_cooldown_timer -= p_delta
		return

	var track_pos := player.global_position
	if player is CharacterBody3D:
		# Center on where the player is likely _going to be_:
		track_pos += player.velocity * bake_cooldown

	if track_pos.distance_squared_to(_current_center) >= min_rebake_distance * min_rebake_distance:
		_current_center = track_pos
		_rebake(_current_center)


func _rebake(p_center: Vector3) -> void:
	if not template:
		push_error("[RuntimeNavBaker] No template NavigationMesh!")
		return
	_bake_task_id = WorkerThreadPool.add_task(_task_bake.bind(p_center), false, "RuntimeNavBaker")
	_bake_task_timer = 0.0
	_bake_cooldown_timer = bake_cooldown


func _task_bake(p_center: Vector3) -> void:
	var nav_mesh: NavigationMesh = template.duplicate()
	nav_mesh.filter_baking_aabb = AABB(-mesh_size * 0.5, mesh_size)
	nav_mesh.filter_baking_aabb_offset = p_center
	var source_geometry: NavigationMeshSourceGeometryData3D
	if _scene_geometry:
		source_geometry = _scene_geometry.duplicate()
	else:
		source_geometry = NavigationMeshSourceGeometryData3D.new()

	var faces_added := 0
	if terrain and terrain.has_method("generate_nav_mesh_source_geometry"):
		var aabb: AABB = nav_mesh.filter_baking_aabb
		aabb.position += nav_mesh.filter_baking_aabb_offset
		print("[RuntimeNavBaker] Requesting faces for AABB: pos=%s, size=%s" % [aabb.position, aabb.size])
		# CRITICAL: Second param = false to include ALL terrain, not just painted navigable areas
		var faces: PackedVector3Array = terrain.generate_nav_mesh_source_geometry(aabb, false)
		faces_added = faces.size()
		source_geometry.add_faces(faces, Transform3D.IDENTITY)

		# Debug: Check height of first few faces (terrain transform check removed - thread unsafe)
		if faces.size() >= 3:
			var face_y_min := INF
			var face_y_max := -INF
			for i in range(mini(faces.size(), 30)):  # Check first 10 triangles
				face_y_min = minf(face_y_min, faces[i].y)
				face_y_max = maxf(face_y_max, faces[i].y)
			print("[RuntimeNavBaker] Face Y range (sample): %.2f to %.2f" % [face_y_min, face_y_max])

		print("[RuntimeNavBaker] Added %d terrain faces at center %s" % [faces_added, p_center])
	else:
		print("[RuntimeNavBaker] WARNING: No terrain or missing generate_nav_mesh_source_geometry method!")

	if source_geometry.has_data():
		NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)
		_bake_finished.call_deferred(nav_mesh)
	else:
		print("[RuntimeNavBaker] WARNING: No source geometry data!")
		_bake_finished.call_deferred(null)


func _bake_finished(p_nav_mesh: NavigationMesh) -> void:
	if log_timing:
		print("[RuntimeNavBaker] Bake took %.3fs" % _bake_task_timer)

	_bake_task_timer = 0.0
	_bake_task_id = -1

	if p_nav_mesh:
		_nav_region.navigation_mesh = p_nav_mesh

		var polygon_count := p_nav_mesh.get_polygon_count()
		var vertices := p_nav_mesh.get_vertices()
		print("[RuntimeNavBaker] NavMesh ready: %d polygons, %d vertices" % [polygon_count, vertices.size()])

		# Debug: Log vertex height range
		if vertices.size() > 0 and log_timing:
			var min_y := INF
			var max_y := -INF
			for v in vertices:
				min_y = minf(min_y, v.y)
				max_y = maxf(max_y, v.y)
			print("[RuntimeNavBaker] Vertex Y range: %.2f to %.2f" % [min_y, max_y])
	else:
		print("[RuntimeNavBaker] WARNING: Bake returned null NavMesh!")

	bake_finished.emit()


## Force an immediate bake at the given position
func force_bake_at(position: Vector3) -> void:
	_current_center = position
	_rebake(position)


## Get the NavigationRegion3D for agents to use
func get_nav_region() -> NavigationRegion3D:
	return _nav_region


## Get the navigation map RID
func get_navigation_map() -> RID:
	if _nav_region:
		return _nav_region.get_navigation_map()
	return RID()
