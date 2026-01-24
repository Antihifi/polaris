class_name PerformanceConsiderations
extends RefCounted
## Performance Audit Documentation
##
## This file documents performance issues identified in the Polaris codebase
## and provides suggested fixes. This is a reference document - not executable code.
##
## Last Updated: January 2026
## Estimated Impact: 1-2ms per frame savings (~5-8 FPS improvement)


# ==============================================================================
# CRITICAL ISSUES (Fix Immediately)
# ==============================================================================

## ISSUE 1: Terrain Height Query Every Frame
## Location: src/characters/clickable_unit.gd:232-235
## Impact: 1-2ms per frame (6-15% of frame budget with 10-16 units)
##
## PROBLEM:
## Each unit calls _find_terrain3d() and terrain.data.get_height() every physics frame.
## With 10-16 units at 60fps, this wastes significant CPU time on:
## - get_tree().get_nodes_in_group("terrain") - allocates new array each call
## - terrain.data.get_height() - physics heightmap query
##
## CURRENT CODE:
## ```gdscript
## func _physics_process(delta: float) -> void:
##     var terrain := _find_terrain3d()  # Searches group EVERY frame
##     var terrain_height: float = NAN
##     if terrain and "data" in terrain and terrain.data:
##         terrain_height = terrain.data.get_height(global_position)
## ```
##
## SUGGESTED FIX:
## Cache terrain height and only re-query when unit moves significantly.
const TERRAIN_QUERY_DISTANCE_THRESHOLD: float = 0.5

## Add these member variables to ClickableUnit:
## var _cached_terrain_height: float = 0.0
## var _last_terrain_query_pos: Vector3 = Vector3.INF
##
## Then in _physics_process():
## ```gdscript
## var dist_moved := global_position.distance_to(_last_terrain_query_pos)
## if dist_moved > TERRAIN_QUERY_DISTANCE_THRESHOLD:
##     _last_terrain_query_pos = global_position
##     var terrain := _find_terrain3d()
##     if terrain and "data" in terrain and terrain.data:
##         _cached_terrain_height = terrain.data.get_height(global_position)
## # Use _cached_terrain_height instead of querying every frame
## ```


## ISSUE 2: Navigation Debug Query Every Frame
## Location: src/characters/clickable_unit.gd:204-211
## Impact: Unnecessary array allocation 60x/sec per moving unit
##
## PROBLEM:
## get_current_navigation_path() is called every frame but only logged once per second.
## This allocates a new array 60 times per second unnecessarily.
##
## CURRENT CODE:
## ```gdscript
## var path_info := navigation_agent.get_current_navigation_path()  # EVERY FRAME
## if Engine.get_physics_frames() % 60 == 0:  # But only logged every 60 frames
##     print("[%s] NAV: path_points=%d..." % [unit_name, path_info.size(), ...])
## ```
##
## SUGGESTED FIX:
## Move the expensive call inside the logging condition:
## ```gdscript
## if Engine.get_physics_frames() % 60 == 0:
##     var path_info := navigation_agent.get_current_navigation_path()
##     print("[%s] NAV: path_points=%d..." % [unit_name, path_info.size(), ...])
## ```


# ==============================================================================
# HIGH PRIORITY ISSUES
# ==============================================================================

## ISSUE 3: SnowController Camera Re-fetch
## Location: src/systems/weather/snow_controller.gd:514, 550
## Impact: ~0.05ms per frame
##
## PROBLEM:
## Three separate functions each call get_viewport().get_camera_3d():
## - _update_particle_position() at line 514
## - _update_fog_position() at line 550
## - _update_wind() also accesses camera
##
## SUGGESTED FIX:
## Cache camera once per frame in _process(), pass to helper functions:
## ```gdscript
## func _process(delta: float) -> void:
##     if not _camera or not is_instance_valid(_camera):
##         _camera = get_viewport().get_camera_3d()
##     if _camera:
##         _update_particle_position(_camera)
##         _update_fog_position(_camera)
##         _update_wind()
## ```


## ISSUE 4: SnowController Dictionary Creation Every Frame
## Location: src/systems/weather/snow_controller.gd:574
## Impact: ~0.05-0.1ms per frame when snowing
##
## PROBLEM:
## _get_intensity_config() creates a dictionary with 15+ entries every frame.
##
## CURRENT CODE:
## ```gdscript
## var config: Dictionary = _get_intensity_config(_target_intensity)
## ```
##
## SUGGESTED FIX:
## Cache the config dictionary and only regenerate when intensity changes:
## ```gdscript
## var _cached_intensity_config: Dictionary = {}
## var _cached_intensity: SnowIntensity = SnowIntensity.NONE
##
## func _get_intensity_config(intensity: SnowIntensity) -> Dictionary:
##     if intensity == _cached_intensity and not _cached_intensity_config.is_empty():
##         return _cached_intensity_config
##     _cached_intensity = intensity
##     # ... generate config ...
##     _cached_intensity_config = { ... }
##     return _cached_intensity_config
## ```


## ISSUE 5: is_in_bed() Recursive Search
## Location: src/characters/clickable_unit.gd:761-768
## Impact: O(N*M) complexity, called hourly per unit
##
## PROBLEM:
## find_child() does recursive tree search for EVERY bed in the loop.
##
## CURRENT CODE:
## ```gdscript
## func is_in_bed() -> bool:
##     for bed in get_tree().get_nodes_in_group("beds"):
##         var marker: Marker3D = bed.find_child("foot_of__bed", true, false)
##         if marker and global_position.distance_to(marker.global_position) < 1.5:
##             return true
##     return false
## ```
##
## SUGGESTED FIX:
## Cache bed markers at startup:
## ```gdscript
## var _bed_markers: Array[Marker3D] = []
##
## func _cache_bed_markers() -> void:
##     _bed_markers.clear()
##     for bed in get_tree().get_nodes_in_group("beds"):
##         var marker: Marker3D = bed.find_child("foot_of__bed", true, false)
##         if marker:
##             _bed_markers.append(marker)
##
## func is_in_bed() -> bool:
##     for marker in _bed_markers:
##         if is_instance_valid(marker) and global_position.distance_to(marker.global_position) < 1.5:
##             return true
##     return false
## ```


# ==============================================================================
# MEDIUM PRIORITY ISSUES
# ==============================================================================

## ISSUE 6: DynamicWeather Signal Every Frame
## Location: src/systems/weather/dynamic_weather_controller.gd:184
## Impact: ~0.02-0.05ms per frame
##
## PROBLEM:
## weather_status_changed.emit(get_weather_status()) called EVERY frame.
## get_weather_status() creates a dictionary each call.
##
## SUGGESTED FIX:
## Throttle to 4x/sec:
## ```gdscript
## var _last_status_emit: float = 0.0
## const STATUS_EMIT_INTERVAL: float = 0.25
##
## func _process(delta: float) -> void:
##     _update_event_timer(delta)
##     _last_status_emit += delta
##     if _last_status_emit >= STATUS_EMIT_INTERVAL:
##         _last_status_emit = 0.0
##         weather_status_changed.emit(get_weather_status())
## ```


## ISSUE 7: RtsCamera Group Query During Movement
## Location: src/camera/rts_camera.gd:207
## Impact: ~0.05-0.1ms per frame while moving
##
## PROBLEM:
## get_tree().get_nodes_in_group(bounds_group) called every frame during WASD movement.
## Allocates new array each time.
##
## SUGGESTED FIX:
## Cache unit references, invalidate on spawn/despawn:
## ```gdscript
## var _cached_units: Array[Node3D] = []
## var _unit_cache_dirty: bool = true
##
## func _on_unit_spawned() -> void:
##     _unit_cache_dirty = true
##
## func _refresh_unit_cache() -> void:
##     if not _unit_cache_dirty:
##         return
##     _cached_units.clear()
##     for unit in get_tree().get_nodes_in_group(bounds_group):
##         if unit is Node3D:
##             _cached_units.append(unit)
##     _unit_cache_dirty = false
## ```


## ISSUE 8: SelectionBox Constant Redraw
## Location: ui/selection_box.gd:37-43
## Impact: ~0.05-0.1ms per frame
##
## PROBLEM:
## queue_redraw() called every frame even when NOT selecting.
##
## CURRENT CODE:
## ```gdscript
## func _process(_delta: float) -> void:
##     if _input_handler and _input_handler.is_box_selecting:
##         queue_redraw()
##     elif is_queued_for_deletion() == false:
##         queue_redraw()  # Called EVERY frame!
## ```
##
## SUGGESTED FIX:
## Only redraw on state transitions:
## ```gdscript
## var _was_selecting: bool = false
##
## func _process(_delta: float) -> void:
##     var is_selecting := _input_handler and _input_handler.is_box_selecting
##     if is_selecting != _was_selecting:
##         _was_selecting = is_selecting
##         queue_redraw()
##     elif is_selecting:
##         queue_redraw()  # Only during active selection
## ```


## ISSUE 9: O(n^2) Unique Check in Selection
## Location: src/control/rts_input_handler.gd:679-686
## Impact: Minor (only on box select release)
##
## PROBLEM:
## "unit not in unique_units" is O(n) per check, making total O(n^2).
##
## CURRENT CODE:
## ```gdscript
## var unique_units: Array[Node] = []
## for unit in all_units:
##     if unit not in unique_units:
##         unique_units.append(unit)
## ```
##
## SUGGESTED FIX:
## Use Dictionary for O(1) lookup:
## ```gdscript
## var seen: Dictionary = {}
## var unique_units: Array[Node] = []
## for unit in all_units:
##     if unit not in seen:
##         seen[unit] = true
##         unique_units.append(unit)
## ```


# ==============================================================================
# LOW PRIORITY ISSUES
# ==============================================================================

## ISSUE 10: TimeManager Debug Logging in _process
## Location: src/systems/time_manager.gd:163-179
## Impact: ~0.01ms per frame
##
## Debug string allocation every 5 seconds via counter in _process().
## Consider moving to Timer node or removing for production builds.


## ISSUE 11: HarnessPull Duplicate Method Call
## Location: src/vehicles/harness_pull_system.gd:65, 96
## Impact: Negligible
##
## _get_lead_puller() called twice per physics frame.
## Pass result as parameter to _calculate_total_pull_force().


## ISSUE 12: Bark Limit Keys Regeneration
## Location: src/systems/bark_manager.gd:204-220
## Impact: Negligible (max 5 barks)
##
## _active_barks.keys()[0] regenerates keys array in while loop.
## Use iteration or store first key before loop.


# ==============================================================================
# SUMMARY: FILES TO MODIFY BY PRIORITY
# ==============================================================================

## CRITICAL:
## - src/characters/clickable_unit.gd (Issues #1, #2, #5)
##
## HIGH:
## - src/systems/weather/snow_controller.gd (Issues #3, #4)
##
## MEDIUM:
## - src/systems/weather/dynamic_weather_controller.gd (Issue #6)
## - src/camera/rts_camera.gd (Issue #7)
## - ui/selection_box.gd (Issue #8)
##
## LOW:
## - src/control/rts_input_handler.gd (Issue #9)
## - src/systems/time_manager.gd (Issue #10)
## - src/vehicles/harness_pull_system.gd (Issue #11)
## - src/systems/bark_manager.gd (Issue #12)


# ==============================================================================
# ESTIMATED IMPACT
# ==============================================================================

## Before optimization: ~1.5-2.5ms per frame in process loops (10-15% of 16ms budget)
## After optimization:  ~0.5-1.0ms per frame (3-6% of budget)
## Expected FPS gain:   +5-8 FPS at 60fps target


# ==============================================================================
# POSITIVE FINDINGS - WELL-OPTIMIZED PATTERNS
# ==============================================================================

## The codebase demonstrates good practices:
## - Proper @onready caching for node references
## - Signals connected at init-time, not repeatedly
## - Good use of groups for unit queries
## - No per-frame object allocations in most hot paths
## - Efficient blackboard patterns in behavior tree system
## - Proper tween usage with cleanup callbacks
