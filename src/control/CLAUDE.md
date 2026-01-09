# Control System

RTS-style input handling: click selection, right-click movement, multi-select, and control groups.

## Files

| File | Purpose |
|------|---------|
| `rts_input_handler.gd` | Click/right-click handling, Terrain3D queries |
| `selection_manager.gd` | Autoload: multi-selection, control groups |

## RTSInputHandler

Handles RTS-style mouse input for selecting units and commanding movement.

### Configuration
```gdscript
@export var camera: Camera3D
@export var terrain_collision_mask: int = 1  # Layer for terrain/ground
@export var unit_collision_mask: int = 2     # Layer for selectable units
```

### Signals
```gdscript
signal unit_double_clicked(unit: ClickableUnit)  # For opening stats panel
```

### Double-Click Detection
```gdscript
const DOUBLE_CLICK_THRESHOLD_MS: int = 400

func _select_unit(unit: ClickableUnit) -> void:
    var current_time := Time.get_ticks_msec()
    if unit == _last_clicked_unit:
        var time_diff := current_time - _last_click_time
        if time_diff <= DOUBLE_CLICK_THRESHOLD_MS:
            unit_double_clicked.emit(unit)
```

### Input Handling
```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            _handle_left_click(event.position)
        elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            _handle_right_click(event.position)
```

## Left Click (Selection)

Raycasts to find units:
```gdscript
func _handle_left_click(screen_position: Vector2) -> void:
    var from := camera.project_ray_origin(screen_position)
    var to := from + camera.project_ray_normal(screen_position) * 1000.0

    # Try to hit a unit first
    var unit_query := PhysicsRayQueryParameters3D.create(from, to, unit_collision_mask)
    var unit_result := space_state.intersect_ray(unit_query)

    if not unit_result.is_empty():
        var hit: Object = unit_result.collider
        if hit is ClickableUnit:
            _select_unit(hit)
            return
        # Check parent (in case we hit a child collider)
        var parent: Node = hit.get_parent()
        if parent is ClickableUnit:
            _select_unit(parent)
            return

    # Clicked on nothing selectable
    _deselect_current()
```

### Selection Side Effects
```gdscript
func _select_unit(unit: ClickableUnit) -> void:
    # Deselect previous
    if selected_unit and selected_unit != unit:
        selected_unit.deselect()

    selected_unit = unit
    selected_unit.select()

    # Set camera focus target for MMB orbit
    if camera and camera.has_method("set_focus_target"):
        camera.set_focus_target(unit)
```

## Right Click (Movement)

### Terrain Position Query

Three-method approach for robust terrain hit detection:

```gdscript
func _get_terrain_position(screen_position: Vector2) -> Vector3:
    var from := camera.project_ray_origin(screen_position)
    var direction := camera.project_ray_normal(screen_position)

    # Method 1: Terrain3D direct height query (preferred)
    if terrain_3d and "data" in terrain_3d and terrain_3d.data:
        # Iterative refinement for accurate height
        var t := -from.y / direction.y
        var ground_pos := from + direction * t
        var height: float = terrain_3d.data.get_height(ground_pos)
        if not is_nan(height):
            return Vector3(ground_pos.x, height, ground_pos.z)

    # Method 2: Physics raycast fallback
    var terrain_query := PhysicsRayQueryParameters3D.create(from, to, terrain_collision_mask)
    var terrain_result := space_state.intersect_ray(terrain_query)
    if not terrain_result.is_empty():
        return terrain_result.position

    # Method 3: Ground plane intersection (last resort)
    var t := -from.y / direction.y
    return from + direction * t
```

### Finding Terrain3D
```gdscript
func _find_terrain3d() -> void:
    # Check "terrain" group first
    var nodes := get_tree().get_nodes_in_group("terrain")
    if nodes.size() > 0:
        terrain_3d = nodes[0]
        return
    # Search by class name
    terrain_3d = _find_node_by_class(get_tree().current_scene, "Terrain3D")
```

### Movement Command
```gdscript
func _handle_right_click(screen_position: Vector2) -> void:
    if not selected_unit:
        return

    var target_position := _get_terrain_position(screen_position)
    if target_position != Vector3.INF:
        selected_unit.move_to(target_position)
        _show_move_indicator(target_position)
```

---

## SelectionManager (Autoload)

Singleton for multi-selection and control groups.

### Signals
```gdscript
signal selection_changed(selected: Array[Survivor])
signal survivor_selected(survivor: Survivor)
signal survivor_deselected(survivor: Survivor)
signal group_assigned(group_number: int, survivors: Array[Survivor])
```

### State
```gdscript
var selected_survivors: Array[Survivor] = []
var control_groups: Dictionary = {}  # {1-9: Array[Survivor]}
var is_dragging_selection: bool = false
```

## Selection API

```gdscript
func select(survivor: Survivor, add_to_selection: bool = false) -> void
func deselect(survivor: Survivor) -> void
func clear_selection() -> void
func select_multiple(survivors: Array[Survivor], add_to_selection: bool = false) -> void
func select_all() -> void
func toggle_selection(survivor: Survivor) -> void
```

### Select with Add Mode
```gdscript
func select(survivor: Survivor, add_to_selection: bool = false) -> void:
    if not add_to_selection:
        clear_selection()

    if survivor not in selected_survivors:
        selected_survivors.append(survivor)
        survivor.select()
        survivor_selected.emit(survivor)

    selection_changed.emit(selected_survivors)
```

## Control Groups (1-9)

### Hotkey Handling
```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        var number := _get_number_from_keycode(event.keycode)
        if number > 0 and number <= 9:
            if Input.is_key_pressed(KEY_CTRL):
                assign_control_group(number)  # Ctrl+1-9: Assign
            else:
                recall_control_group(number)  # 1-9: Recall
```

### Assign Group
```gdscript
func assign_control_group(group_number: int) -> void:
    control_groups[group_number] = selected_survivors.duplicate()
    group_assigned.emit(group_number, control_groups[group_number])
```

### Recall Group
```gdscript
func recall_control_group(group_number: int) -> void:
    var group: Array = control_groups[group_number]

    # Filter out dead or removed survivors
    var valid_survivors: Array[Survivor] = []
    for survivor in group:
        if is_instance_valid(survivor) and survivor.current_state != Survivor.State.DEAD:
            valid_survivors.append(survivor)

    control_groups[group_number] = valid_survivors
    select_multiple(valid_survivors)
```

## Box Selection

### API
```gdscript
func start_box_selection(screen_position: Vector2) -> void
func update_box_selection(current_position: Vector2) -> Rect2
func finish_box_selection(camera: Camera3D, selection_rect: Rect2, add_to_selection: bool = false) -> void
```

### Implementation
```gdscript
func finish_box_selection(camera: Camera3D, selection_rect: Rect2, add_to_selection: bool = false) -> void:
    if selection_rect.size.length() < 5.0:
        return  # Too small, treat as click

    var survivors_in_box: Array[Survivor] = []
    var all_survivors := get_tree().get_nodes_in_group("survivors")

    for node in all_survivors:
        if node is Survivor:
            var screen_pos := camera.unproject_position(node.global_position)
            if selection_rect.has_point(screen_pos):
                survivors_in_box.append(node)

    if not survivors_in_box.is_empty():
        select_multiple(survivors_in_box, add_to_selection)
```

## Raycast Selection

Alternative selection via raycast (uses unit collision layer):
```gdscript
func try_select_at_position(camera: Camera3D, screen_position: Vector2, add_to_selection: bool = false) -> bool:
    var from := camera.project_ray_origin(screen_position)
    var to := from + camera.project_ray_normal(screen_position) * 1000.0

    var query := PhysicsRayQueryParameters3D.create(from, to, SURVIVOR_COLLISION_LAYER)
    var result := space_state.intersect_ray(query)

    if not result.is_empty():
        if result.collider is Survivor:
            select(result.collider, add_to_selection)
            return true
    return false
```

## Group Movement

Spreads units around target in formation:
```gdscript
func command_selected_to_move(target_position: Vector3) -> void:
    var count := selected_survivors.size()
    if count == 1:
        selected_survivors[0].move_to(target_position)
    else:
        var spacing := 1.5
        var angle_step := TAU / count
        for i in range(count):
            var offset := Vector3(
                cos(angle_step * i) * spacing,
                0,
                sin(angle_step * i) * spacing
            )
            selected_survivors[i].move_to(target_position + offset)
```

## Utility Functions

```gdscript
func get_selected_count() -> int
func has_selection() -> bool
func get_first_selected() -> Survivor
func get_selection_center() -> Vector3
func get_control_group(group_number: int) -> Array[Survivor]
```

---

## Integration Points

### RTSInputHandler -> Camera
```gdscript
# On selection
camera.set_focus_target(unit)  # For MMB orbit

# On deselection
camera.clear_focus_target()
```

### RTSInputHandler -> GameHUD
```gdscript
# Double-click opens stats panel
unit_double_clicked.emit(unit)
```

### SelectionManager -> Game Systems
```gdscript
# Use selection for commands
SelectionManager.command_selected_to_move(target)

# Query selection state
if SelectionManager.has_selection():
    var leader := SelectionManager.get_first_selected()
```

## Collision Layers

| Layer | Purpose | Used By |
|-------|---------|---------|
| 1 | Terrain | `terrain_collision_mask` |
| 2 | Units | `unit_collision_mask`, `SURVIVOR_COLLISION_LAYER` |

Ensure units have their collision layer set to 2 for selection to work.

## Common Modifications

### Add shift-click multi-select
In `_handle_left_click`:
```gdscript
var add_mode := Input.is_action_pressed("ui_shift")
if hit is ClickableUnit:
    _select_unit(hit, add_mode)
```

### Add visual selection box
Create a `ColorRect` child and update in `_process`:
```gdscript
if SelectionManager.is_dragging_selection:
    var rect := SelectionManager.update_box_selection(get_viewport().get_mouse_position())
    selection_box_rect.position = rect.position
    selection_box_rect.size = rect.size
```

### Custom formation patterns
Modify `command_selected_to_move`:
```gdscript
# Line formation
var offset := Vector3(i * spacing, 0, 0).rotated(Vector3.UP, facing_angle)
```
