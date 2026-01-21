class_name RuntimeNavBaker extends Node
## Chunk-based NavMesh baker that bakes around ALL units.
## Chunks persist forever in memory - never removed.
## Each chunk is a separate NavigationRegion3D.

signal bake_finished

@export var enabled: bool = true : set = set_enabled
@export var enter_cost: float = 0.0
@export var travel_cost: float = 1.0
@export_flags_3d_navigation var navigation_layers: int = 1
@export var template: NavigationMesh : set = set_template

## Reference to Terrain3D node (set by controller after terrain creation)
var terrain: Node = null

## Size of each NavMesh chunk (256x512x256 = 256m wide, 512m tall, 256m deep)
@export var chunk_size := Vector3(256, 512, 256)

## How often to check for new chunks needed (seconds)
@export var check_interval: float = 0.5

## Minimum distance unit must be from any chunk center to trigger new bake
@export var chunk_trigger_distance: float = 100.0

@export_group("Debug")
@export var log_timing: bool = true

## Baked chunks stored by grid position (Vector2i -> NavigationRegion3D)
var _chunks: Dictionary = {}

## Chunk centers that are currently being baked (to prevent duplicates)
var _pending_chunks: Dictionary = {}

## Queue of chunk centers to bake
var _bake_queue: Array[Vector3] = []

## Current bake task
var _bake_task_id: int = -1
var _bake_task_timer: float = 0.0
var _current_bake_center: Vector3 = Vector3.ZERO

## Timer for periodic unit checks
var _check_timer: float = 0.0

## Scene geometry cache
var _scene_geometry: NavigationMeshSourceGeometryData3D


func _ready() -> void:
	add_to_group("nav_baker")

	if not template:
		template = NavigationMesh.new()
		template.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
		template.agent_height = 2.0
		template.agent_max_slope = 30.0

	_update_map_cell_size()

	print("[RuntimeNavBaker] Chunk system initialized: chunk_size=%s, trigger_dist=%.0f" % [chunk_size, chunk_trigger_distance])

	parse_scene.call_deferred()

	# Ensure processing is enabled if enabled flag is already true
	# (set_enabled may have been called before _ready when template was null)
	if enabled:
		set_process(true)
		print("[RuntimeNavBaker] Processing enabled in _ready()")


func set_enabled(p_value: bool) -> void:
	enabled = p_value
	set_process(enabled and template)


func set_template(p_value: NavigationMesh) -> void:
	template = p_value
	set_process(enabled and template)
	_update_map_cell_size()


func parse_scene() -> void:
	_scene_geometry = NavigationMeshSourceGeometryData3D.new()
	NavigationServer3D.parse_source_geometry_data(template, _scene_geometry, self)


func _update_map_cell_size() -> void:
	if get_viewport() and template:
		var map := get_viewport().find_world_3d().navigation_map
		NavigationServer3D.map_set_cell_size(map, template.cell_size)
		NavigationServer3D.map_set_cell_height(map, template.cell_height)
		# Note: edge_connection_margin not needed - border_size creates aligned edges
		print("[RuntimeNavBaker] Map cell size configured: %.3f / %.3f" % [template.cell_size, template.cell_height])


func _process(p_delta: float) -> void:
	# Track bake timer
	if _bake_task_id != -1:
		_bake_task_timer += p_delta
		return  # Don't start new bakes while one is in progress

	# Process bake queue
	if not _bake_queue.is_empty():
		var center: Vector3 = _bake_queue.pop_front()
		_start_chunk_bake(center)
		return

	# Periodic check for units needing chunks
	_check_timer += p_delta
	if _check_timer >= check_interval:
		_check_timer = 0.0
		_check_all_units()


func _check_all_units() -> void:
	## Check all survivors and queue chunks for any not covered.
	## Also pre-bakes adjacent chunks when units are near chunk boundaries.
	var survivors := get_tree().get_nodes_in_group("survivors")

	# Debug: Log occasionally to verify checking is happening
	if log_timing and randf() < 0.02:  # 2% chance to log
		print("[RuntimeNavBaker] Checking %d survivors, %d chunks exist" % [survivors.size(), _chunks.size()])

	for unit in survivors:
		if not is_instance_valid(unit) or not unit is Node3D:
			continue

		var pos: Vector3 = unit.global_position
		var grid_pos := _world_to_grid(pos)

		# Ensure current chunk exists
		if not _chunks.has(grid_pos) and not _pending_chunks.has(grid_pos):
			var chunk_center := _grid_to_world(grid_pos)
			_queue_chunk(chunk_center, grid_pos)

		# Pre-bake adjacent chunks if unit is near edge
		_check_adjacent_chunks(pos, grid_pos)


func _check_adjacent_chunks(unit_pos: Vector3, current_grid: Vector2i) -> void:
	## Pre-bake adjacent chunks if unit is near chunk boundary.
	## This ensures pathfinding targets in adjacent areas have NavMesh coverage.
	var edge_threshold: float = 64.0  # Pre-bake when within 64m of chunk edge

	# Calculate position within current chunk (0 to chunk_size)
	var local_x: float = fmod(unit_pos.x, chunk_size.x)
	var local_z: float = fmod(unit_pos.z, chunk_size.z)
	if local_x < 0:
		local_x += chunk_size.x
	if local_z < 0:
		local_z += chunk_size.z

	# Check each direction and queue missing neighbors
	# Near left edge (small local_x)?
	if local_x < edge_threshold:
		var neighbor := Vector2i(current_grid.x - 1, current_grid.y)
		if not _chunks.has(neighbor) and not _pending_chunks.has(neighbor):
			_queue_chunk(_grid_to_world(neighbor), neighbor)

	# Near right edge (large local_x)?
	if local_x > chunk_size.x - edge_threshold:
		var neighbor := Vector2i(current_grid.x + 1, current_grid.y)
		if not _chunks.has(neighbor) and not _pending_chunks.has(neighbor):
			_queue_chunk(_grid_to_world(neighbor), neighbor)

	# Near bottom edge (small local_z)?
	if local_z < edge_threshold:
		var neighbor := Vector2i(current_grid.x, current_grid.y - 1)
		if not _chunks.has(neighbor) and not _pending_chunks.has(neighbor):
			_queue_chunk(_grid_to_world(neighbor), neighbor)

	# Near top edge (large local_z)?
	if local_z > chunk_size.z - edge_threshold:
		var neighbor := Vector2i(current_grid.x, current_grid.y + 1)
		if not _chunks.has(neighbor) and not _pending_chunks.has(neighbor):
			_queue_chunk(_grid_to_world(neighbor), neighbor)


func _world_to_grid(world_pos: Vector3) -> Vector2i:
	## Convert world position to chunk grid position.
	var gx := int(floor(world_pos.x / chunk_size.x))
	var gz := int(floor(world_pos.z / chunk_size.z))
	return Vector2i(gx, gz)


func _grid_to_world(grid_pos: Vector2i) -> Vector3:
	## Convert grid position to world chunk center.
	var wx := (float(grid_pos.x) + 0.5) * chunk_size.x
	var wz := (float(grid_pos.y) + 0.5) * chunk_size.z
	return Vector3(wx, 0, wz)


func _queue_chunk(center: Vector3, grid_pos: Vector2i) -> void:
	## Queue a chunk for baking.
	if _pending_chunks.has(grid_pos):
		return  # Already queued

	_pending_chunks[grid_pos] = true
	_bake_queue.append(center)

	if log_timing:
		print("[RuntimeNavBaker] Queued chunk at grid %s (world %s), queue size: %d" % [grid_pos, center, _bake_queue.size()])


func _start_chunk_bake(center: Vector3) -> void:
	## Start baking a chunk on worker thread.
	if not template:
		push_error("[RuntimeNavBaker] No template NavigationMesh!")
		return

	_current_bake_center = center
	_bake_task_id = WorkerThreadPool.add_task(_task_bake_chunk.bind(center), false, "RuntimeNavBaker")
	_bake_task_timer = 0.0


func _task_bake_chunk(p_center: Vector3) -> void:
	## Worker thread: bake a single chunk.
	var nav_mesh: NavigationMesh = template.duplicate()

	# CRITICAL: Grow AABB to include neighboring geometry, then trim with border_size
	# This prevents agent_radius from shrinking edges at chunk boundaries
	# Result: gap-free, perfectly aligned chunk edges
	var border: float = chunk_size.x  # Use chunk width as border
	var grown_size := Vector3(chunk_size.x + border * 2, chunk_size.y, chunk_size.z + border * 2)
	nav_mesh.filter_baking_aabb = AABB(-grown_size * 0.5, grown_size)
	nav_mesh.filter_baking_aabb_offset = p_center
	nav_mesh.border_size = border  # Trim back to actual chunk size

	var source_geometry: NavigationMeshSourceGeometryData3D
	if _scene_geometry:
		source_geometry = _scene_geometry.duplicate()
	else:
		source_geometry = NavigationMeshSourceGeometryData3D.new()

	if terrain and terrain.has_method("generate_nav_mesh_source_geometry"):
		# Use grown AABB to fetch terrain geometry (includes neighbor areas)
		var aabb: AABB = nav_mesh.filter_baking_aabb
		aabb.position += nav_mesh.filter_baking_aabb_offset
		var faces: PackedVector3Array = terrain.generate_nav_mesh_source_geometry(aabb, false)
		if faces.size() > 0:
			source_geometry.add_faces(faces, Transform3D.IDENTITY)

	if source_geometry.has_data():
		NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)
		_chunk_bake_finished.call_deferred(nav_mesh, p_center)
	else:
		_chunk_bake_finished.call_deferred(null, p_center)


func _chunk_bake_finished(p_nav_mesh: NavigationMesh, p_center: Vector3) -> void:
	## Main thread: process completed chunk bake.
	var grid_pos := _world_to_grid(p_center)
	_pending_chunks.erase(grid_pos)

	if log_timing:
		print("[RuntimeNavBaker] Chunk bake at %s took %.3fs" % [grid_pos, _bake_task_timer])

	_bake_task_timer = 0.0
	_bake_task_id = -1

	if p_nav_mesh:
		# Apply post-processing
		_postprocess_nav_mesh(p_nav_mesh)

		# Create new NavigationRegion3D for this chunk
		var region := NavigationRegion3D.new()
		region.name = "NavChunk_%d_%d" % [grid_pos.x, grid_pos.y]
		region.navigation_layers = navigation_layers
		region.enabled = true
		region.enter_cost = enter_cost
		region.travel_cost = travel_cost
		region.use_edge_connections = false  # Not needed with border_size aligned edges
		region.navigation_mesh = p_nav_mesh

		add_child(region)
		_chunks[grid_pos] = region

		var polygon_count := p_nav_mesh.get_polygon_count()
		print("[RuntimeNavBaker] Chunk %s ready: %d polygons (total chunks: %d)" % [grid_pos, polygon_count, _chunks.size()])
	else:
		print("[RuntimeNavBaker] WARNING: Chunk %s bake failed!" % grid_pos)

	bake_finished.emit()


## Force bake a chunk at specific position (called externally)
func force_bake_at(position: Vector3) -> void:
	var grid_pos := _world_to_grid(position)
	if not _chunks.has(grid_pos) and not _pending_chunks.has(grid_pos):
		var center := _grid_to_world(grid_pos)
		_queue_chunk(center, grid_pos)


## Request coverage at position - queues chunk if needed
func ensure_coverage(target_position: Vector3) -> void:
	force_bake_at(target_position)


## Get the navigation map RID
func get_navigation_map() -> RID:
	if get_viewport():
		return get_viewport().find_world_3d().navigation_map
	return RID()


## Get chunk count for debugging
func get_chunk_count() -> int:
	return _chunks.size()


# ============================================================================
# POST-PROCESSING FUNCTIONS
# From addons/terrain_3d/menu/baker.gd - fixes Godot issue #85548
# ============================================================================

func _postprocess_nav_mesh(p_nav_mesh: NavigationMesh) -> void:
	var vertices: PackedVector3Array = _postprocess_round_vertices(p_nav_mesh)
	var polygons: Array[PackedInt32Array] = _postprocess_remove_empty_polygons(p_nav_mesh, vertices)
	_postprocess_remove_overlapping_polygons(p_nav_mesh, vertices, polygons)

	p_nav_mesh.clear_polygons()
	p_nav_mesh.set_vertices(vertices)
	for polygon in polygons:
		p_nav_mesh.add_polygon(polygon)


func _postprocess_round_vertices(p_nav_mesh: NavigationMesh) -> PackedVector3Array:
	assert(p_nav_mesh != null)
	assert(p_nav_mesh.cell_size > 0.0)
	assert(p_nav_mesh.cell_height > 0.0)

	var cell_size: Vector3 = Vector3(p_nav_mesh.cell_size, p_nav_mesh.cell_height, p_nav_mesh.cell_size)
	var round_factor := cell_size * 1.001

	var vertices: PackedVector3Array = p_nav_mesh.get_vertices()
	for i in range(vertices.size()):
		vertices[i] = (vertices[i] / round_factor).floor() * round_factor
	return vertices


func _postprocess_remove_empty_polygons(p_nav_mesh: NavigationMesh, p_vertices: PackedVector3Array) -> Array[PackedInt32Array]:
	var polygons: Array[PackedInt32Array] = []

	for i in range(p_nav_mesh.get_polygon_count()):
		var old_polygon: PackedInt32Array = p_nav_mesh.get_polygon(i)
		var new_polygon: PackedInt32Array = []

		var polygon_vertices: PackedVector3Array = []
		for index in old_polygon:
			var vertex: Vector3 = p_vertices[index]
			if polygon_vertices.has(vertex):
				continue
			polygon_vertices.push_back(vertex)
			new_polygon.push_back(index)

		if new_polygon.size() <= 2:
			continue
		polygons.push_back(new_polygon)

	return polygons


func _postprocess_remove_overlapping_polygons(p_nav_mesh: NavigationMesh, p_vertices: PackedVector3Array, p_polygons: Array[PackedInt32Array]) -> void:
	var cell_size: Vector3 = Vector3(p_nav_mesh.cell_size, p_nav_mesh.cell_height, p_nav_mesh.cell_size)

	var edges: Dictionary = {}

	for polygon_index in range(p_polygons.size()):
		var polygon: PackedInt32Array = p_polygons[polygon_index]
		for j in range(polygon.size()):
			var vertex: Vector3 = p_vertices[polygon[j]]
			var next_vertex: Vector3 = p_vertices[polygon[(j + 1) % polygon.size()]]

			var edge_key: Array = [Vector3i(vertex / cell_size), Vector3i(next_vertex / cell_size)]
			edge_key.sort()

			if not edges.has(edge_key):
				edges[edge_key] = []
			edges[edge_key].push_back(polygon_index)

	var overlap_count: Dictionary = {}
	for connections in edges.values():
		if connections.size() <= 2:
			continue
		for polygon_index in connections:
			overlap_count[polygon_index] = overlap_count.get(polygon_index, 0) + 1

	var bad_polygons: Array = []
	for polygon_index in overlap_count.keys():
		if overlap_count[polygon_index] >= 2:
			bad_polygons.push_back(polygon_index)

	bad_polygons.sort()
	for i in range(bad_polygons.size() - 1, -1, -1):
		p_polygons.remove_at(bad_polygons[i])
