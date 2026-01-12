# UI System

Game HUD, time display, character stats panels, inventory UI, and debug tools.

## Files

| File | Purpose |
|------|---------|
| `game_hud.gd` | Main HUD CanvasLayer manager |
| `game_hud.tscn` | HUD scene with TimeHUD and CharacterStats |
| `time_hud.gd` | Time, date, temperature, speed display |
| `time_hud.tscn` | Time display panel scene |
| `time_hud_buttons.tres` | ButtonGroup for speed toggle buttons |
| `character_stats.gd` | Survivor stats panel (follows unit in screen space) |
| `character_stats.tscn` | Stats panel scene with progress bars |
| `inventory_hud.gd` | CanvasLayer managing inventory panels |
| `inventory_panel.gd` | Reusable panel wrapper for gloot CtrlInventoryGrid |
| `inventory_panel.tscn` | Panel template with title, close button, grid |
| `inventory_item.gd` | CustomInventoryItem with inversion shader for icons |
| `inventory_item.tscn` | Custom item rendering scene |
| `selection_box.gd` | Draws selection rectangle during click-drag |
| `debug_menu.gd` | ESC-toggled debug menu for weather testing |
| `MinimalUI.tres` | Unified theme resource for all UI elements |
| `OpenSans-Regular.ttf` | Main font asset |
| `icons.svg` | Icon assets |

## Scene Hierarchy

```
GameHUD (CanvasLayer)
├── TimeHUD (Control) - Always visible, top-right
│   └── Panel
│       └── MarginContainer
│           └── VBoxContainer
│               ├── TimeLabel
│               ├── DateLabel
│               ├── TempLabel
│               └── SpeedLabel
└── CharacterStats (Control) - Shows on double-click
    └── Panel (positions above selected unit)
        └── MarginContainer
            └── CenterContainer
                └── VBoxContainer
                    ├── Health/ProgressBar
                    ├── Energy/ProgressBar
                    ├── Hunger/ProgressBar
                    ├── Body Temperature/ProgressBar
                    └── Morale/ProgressBar
```

## GameHUD

Main HUD manager that coordinates time display and character stats.

### Setup
Added to scene by `MainController`:
```gdscript
func _ready() -> void:
    var hud_scene := preload("res://src/ui/game_hud.tscn")
    game_hud = hud_scene.instantiate()
    add_child(game_hud)
```

### Double-Click Connection
```gdscript
func _connect_to_input_handler() -> void:
    _input_handler = get_node_or_null("../RTSInputHandler")
    if _input_handler and _input_handler.has_signal("unit_double_clicked"):
        _input_handler.unit_double_clicked.connect(_on_unit_double_clicked)

func _on_unit_double_clicked(unit: ClickableUnit) -> void:
    _selected_unit = unit
    character_stats.show_for_unit(unit)
```

### Deselection Handling
```gdscript
func _connect_to_units() -> void:
    var units := get_tree().get_nodes_in_group("selectable_units")
    for unit in units:
        if unit is ClickableUnit:
            unit.deselected.connect(_on_unit_deselected.bind(unit))

func _on_unit_deselected(unit: ClickableUnit) -> void:
    if unit == _selected_unit:
        character_stats.hide_panel()
```

### Time Control Hotkeys
```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        match event.keycode:
            KEY_SPACE:
                _toggle_pause()
            KEY_1:
                _set_time_scale(1.0)
            KEY_2:
                _set_time_scale(2.0)
            KEY_3:
                _set_time_scale(4.0)
```

---

## TimeHUD

Always-visible panel showing time, date, temperature, and game speed.

### TimeManager Connection
```gdscript
func _ready() -> void:
    _time_manager = get_node_or_null("/root/TimeManager")
    _time_manager.hour_passed.connect(_on_hour_passed)
    _time_manager.time_scale_changed.connect(_on_time_scale_changed)
    _update_display()

func _process(_delta: float) -> void:
    # Smooth clock updates
    if _time_manager:
        _update_time_display()
```

### Display Updates
```gdscript
func _update_time_display() -> void:
    time_label.text = _time_manager.get_formatted_time()  # "HH:MM"

func _update_date_display() -> void:
    date_label.text = _time_manager.get_formatted_date()  # "YYYY-MM-DD - Season"

func _update_temp_display() -> void:
    var temp: float = _time_manager.get_current_temperature()
    temp_label.text = "%d°C" % int(temp)

    # Color based on severity
    if temp <= -30:
        temp_label.add_theme_color_override("font_color", Color(0.4, 0.6, 1.0))  # Blue
    elif temp <= -15:
        temp_label.add_theme_color_override("font_color", Color(0.6, 0.8, 1.0))  # Light blue
    # etc.

func _update_speed_display() -> void:
    speed_label.text = _time_manager.get_time_scale_label()  # "1x", "2x", "PAUSED"
    if _time_manager.is_paused:
        speed_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))  # Red
```

---

## CharacterStats

Floating panel that displays survival stats for selected unit.

### Positioning System
Panel follows unit in screen space:
```gdscript
@export var world_height_offset: float = 4.0
@export var screen_offset: Vector2 = Vector2(0, -20)

func _update_panel_position() -> void:
    # World position above character's head
    var world_pos: Vector3 = _current_unit.global_position + Vector3(0, world_height_offset, 0)

    # Check if visible
    if not _camera.is_position_in_frustum(world_pos):
        visible = false
        return

    # Convert to screen position and center panel
    var screen_pos: Vector2 = _camera.unproject_position(world_pos)
    panel.position = screen_pos - panel.size / 2.0 + screen_offset

    # Clamp to screen bounds
    panel.position.x = clampf(panel.position.x, 0, viewport_size.x - panel.size.x)
    panel.position.y = clampf(panel.position.y, 0, viewport_size.y - panel.size.y)
```

### Showing Stats Panel
```gdscript
func show_for_unit(unit: ClickableUnit, camera: Camera3D = null) -> void:
    if not unit or not unit.stats:
        return

    # Disconnect from previous unit
    if _current_unit and _current_unit.stats_changed.is_connected(_on_stats_changed):
        _current_unit.stats_changed.disconnect(_on_stats_changed)

    _current_unit = unit
    _current_unit.stats_changed.connect(_on_stats_changed)

    _camera = camera if camera else get_viewport().get_camera_3d()

    _update_display()
    _update_panel_position()
    visible = true
```

### Stats Display Update
```gdscript
func _update_display() -> void:
    var stats: SurvivorStats = _current_unit.stats
    health_bar.value = stats.health
    energy_bar.value = stats.energy
    hunger_bar.value = stats.hunger
    warmth_bar.value = stats.warmth
    morale_bar.value = stats.morale
```

### Trend Indicators

Each stat progress bar has a 1px ColorRect child that shows predicted trends:
- **RED line** at bar end = stat is declining
- **GREEN line** at bar end = stat is increasing
- **Hidden** = stat is stable (no significant change)

Trends are **predicted** based on current conditions, not actual stat changes (which only occur hourly). This gives immediate visual feedback when entering/leaving auras, fires, shelters, etc.

```gdscript
# Created once in _ready()
_health_trend = _create_trend_indicator(health_bar)

func _create_trend_indicator(bar: ProgressBar) -> ColorRect:
    var indicator := ColorRect.new()
    indicator.custom_minimum_size = Vector2(1, 0)
    indicator.size_flags_vertical = Control.SIZE_FILL
    bar.add_child(indicator)
    return indicator

# Updated every frame via _process -> _update_display
func _update_trend_indicator(indicator: ColorRect, bar: ProgressBar, trend: float) -> void:
    if absf(trend) < 0.001:
        indicator.visible = false
        return
    indicator.visible = true
    indicator.color = Color.GREEN if trend > 0 else Color.RED
    # Position at end of filled portion
    var fill_width: float = bar.size.x * (bar.value / bar.max_value)
    indicator.position = Vector2(fill_width - 1, 0)
    indicator.size = Vector2(1, bar.size.y)
```

Trend prediction functions (all use cached O(1) lookups from ClickableUnit):
| Function | Logic |
|----------|-------|
| `_get_hunger_trend()` | Always -1.0 (hunger always decays) |
| `_get_warmth_trend()` | +5 fire, +1-3 shelter, +1 sunlight, -3 base cold |
| `_get_energy_trend()` | -1 if moving, +3-6 if resting |
| `_get_morale_trend()` | Base decay + captain/personable auras - darkness - suffering |
| `_get_health_trend()` | 0 unless starving (-2) or freezing (-3) or dying (-5) |

### Real-Time Updates
Connects to unit's `stats_changed` signal:
```gdscript
func _on_stats_changed() -> void:
    _update_display()
```

### Closing Panel
```gdscript
func _input(event: InputEvent) -> void:
    if visible and event.is_action_pressed("ui_cancel"):
        hide_panel()
        get_viewport().set_input_as_handled()

func hide_panel() -> void:
    if _current_unit and _current_unit.stats_changed.is_connected(_on_stats_changed):
        _current_unit.stats_changed.disconnect(_on_stats_changed)
    _current_unit = null
    visible = false
    closed.emit()
```

---

## Signal Flow

```
User double-clicks unit
        │
        ▼
RTSInputHandler.unit_double_clicked
        │
        ▼
GameHUD._on_unit_double_clicked
        │
        ▼
CharacterStats.show_for_unit(unit)
        │
        ├─► Connects to unit.stats_changed
        ├─► Gets camera reference
        ├─► Updates display
        └─► visible = true

Unit stats change (walking, hourly decay)
        │
        ▼
ClickableUnit.stats_changed.emit()
        │
        ▼
CharacterStats._on_stats_changed()
        │
        ▼
CharacterStats._update_display()
```

---

## Progress Bar Configuration

All bars use 0-100 range matching `SurvivorStats`:

```gdscript
# In character_stats.tscn, each ProgressBar has:
min_value = 0
max_value = 100
step = 1
```

Node paths:
```gdscript
health_bar = $Panel/MarginContainer/CenterContainer/VBoxContainer/Health/ProgressBar
energy_bar = $Panel/MarginContainer/CenterContainer/VBoxContainer/Energy/ProgressBar
hunger_bar = $Panel/MarginContainer/CenterContainer/VBoxContainer/Hunger/ProgressBar
warmth_bar = $Panel/MarginContainer/CenterContainer/VBoxContainer/"Body Temperature"/ProgressBar
morale_bar = $Panel/MarginContainer/CenterContainer/VBoxContainer/Morale/ProgressBar
```

---

## Common Modifications

### Add new stat to panel
1. Add HBoxContainer with Label + ProgressBar to `character_stats.tscn`
2. Add reference in `character_stats.gd`:
```gdscript
var new_stat_bar: ProgressBar

func _ready() -> void:
    new_stat_bar = vbox.get_node("NewStat/ProgressBar")

func _update_display() -> void:
    new_stat_bar.value = stats.new_stat
```

### Color-code progress bars by threshold
```gdscript
func _update_display() -> void:
    health_bar.value = stats.health
    if stats.health <= 15.0:
        health_bar.modulate = Color.RED
    elif stats.health <= 35.0:
        health_bar.modulate = Color.YELLOW
    else:
        health_bar.modulate = Color.WHITE
```

### Add minimap
1. Create new Control scene
2. Add to GameHUD.tscn as child
3. Use `SubViewport` with orthographic camera for top-down view

### Add resource display
```gdscript
# In game_hud.gd
@onready var resource_panel: Control = $ResourcePanel

func _ready() -> void:
    GameManager.resource_changed.connect(_update_resources)
```

### Make panel draggable
```gdscript
var _dragging := false
var _drag_offset := Vector2.ZERO

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            _dragging = event.pressed
            _drag_offset = event.position
    elif event is InputEventMouseMotion and _dragging:
        panel.position += event.relative
```

---

## InventoryHUD

CanvasLayer managing two inventory panels (container and unit).

### Signals
```gdscript
signal container_opened(container: StorageContainer)
signal container_closed
signal unit_inventory_opened(unit: ClickableUnit)
signal unit_inventory_closed
```

### Controls
| Key | Action |
|-----|--------|
| `I` | Toggle selected unit's inventory |
| `ESC` | Close any open panels |
| Click container | Open container inventory |
| Drag & drop | Transfer items between inventories |

### API
```gdscript
func open_container(container: StorageContainer) -> void
func close_container() -> void
func open_unit_inventory(unit: ClickableUnit) -> void
func close_unit_inventory() -> void
func is_any_panel_open() -> bool
```

---

## CustomInventoryItem (inventory_item.gd)

Custom gloot inventory item renderer with inversion shader and descriptive tooltips.

### Gloot Mouse Filter Quirk

**IMPORTANT:** Gloot's `CtrlDraggableInventoryItem` sets `mouse_filter = MOUSE_FILTER_IGNORE` on child inventory item controls (line 39 of `ctrl_draggable_inventory_item.gd`). This prevents the `CustomInventoryItem` from receiving mouse events, which breaks Godot's native tooltip system.

**Workaround:** `_update_tooltip()` propagates the tooltip to the parent control:
```gdscript
func _update_tooltip() -> void:
    # ... build tooltip string ...
    tooltip_text = tooltip
    var parent: Control = get_parent() as Control
    if parent:
        parent.tooltip_text = tooltip  # Set on draggable wrapper
```

### Features
- Inversion shader for black PNG icons (displays as white)
- Black background with padding for border effect
- Stack size label (bottom-right)
- Descriptive tooltips per item category (food, fuel, tool)

### Tooltip Content
Tooltips are flavorful descriptions, not stat numbers:
```gdscript
func _get_food_tooltip(item_name: String) -> String:
    match item_name:
        "Hardtack":
            return "HARDTACK\nA dry, long-lasting biscuit.\nNot tasty, but it keeps."
        "Rum":
            return "RUM\nNaval rum ration.\nLifts spirits and warms\nthe body, if briefly."
        "Human Meat":
            return "HUMAN MEAT\nThe flesh of a fallen\ncomrade. A desperate act\nwith terrible consequences\nfor the mind."
```

---

## SelectionBox

Draws selection rectangle during click-drag selection.

### Configuration
```gdscript
@export var box_color: Color = Color(0.9, 0.9, 0.85, 0.8)
@export var border_color: Color = Color(0.95, 0.95, 0.9, 1.0)
@export var border_width: float = 2.0
```

### Integration
- Reads `_input_handler.is_box_selecting` state
- Uses `_input_handler.box_start` and `box_current` for rect
- Calls `queue_redraw()` every frame during selection

---

## DebugMenu

ESC-toggled menu for testing weather system.

### Features
- **Light Snow:** Start light snow
- **Heavy Blizzard:** Start heavy snow
- **Stop Snow (Fade):** Smooth transition to clear
- **Stop Snow (Immediate):** Instant clear

### Pause Behavior
- Pauses game tree when open
- Calls `TimeManager.pause()`
- Resumes on close

### Process Mode
Uses `PROCESS_MODE_ALWAYS` to run while tree is paused.

---

## Keyboard Shortcuts Summary

| Key | Component | Action |
|-----|-----------|--------|
| `Space` | GameHUD | Toggle pause |
| `1` | GameHUD | Set 1x speed |
| `2` | GameHUD | Set 2x speed |
| `3` | GameHUD | Set 4x speed |
| `I` | InventoryHUD | Toggle unit inventory |
| `ESC` | Multiple | Close panels / Open debug menu |
| `Ctrl+A` | SelectionManager | Select all units |
| `Ctrl+1-9` | SelectionManager | Assign control group |
| `1-9` | SelectionManager | Recall control group |

---

## Known Issues & Fixes

### UI Click Handling Failures (RECURRING ISSUE)

**Symptom:** After playing for several minutes, UI buttons (Skills, Effects, close button) stop responding to clicks. The cursor appears to interact but nothing happens.

**Root Causes Identified:**

1. **Signal Connection Leaks** - Repeated `show_for_unit()` calls without disconnecting previous signals cause duplicate connections to accumulate. Eventually, the signal handler gets overwhelmed.

2. **gloot Mouse Filter Blocking** - gloot's `CtrlDraggableInventoryItem` (line 39) sets `mouse_filter = MOUSE_FILTER_IGNORE` on child controls. This blocks mouse events from reaching buttons overlaid on inventory grids.

3. **Z-Index Issues** - Close buttons drawn at same z-level as grid elements get hidden or blocked by other controls.

4. **Missing Instance Validity Checks** - When units die or are removed, connected signals can reference invalid objects, causing silent failures.

5. **Full-Screen Container Without MOUSE_FILTER_IGNORE** - Creating a CenterContainer with `PRESET_FULL_RECT` to center a popup leaves an invisible full-screen blocker when the popup is hidden. The container's default `mouse_filter = MOUSE_FILTER_STOP` blocks all clicks to underlying UI. **ALWAYS set `mouse_filter = MOUSE_FILTER_IGNORE` on full-screen layout containers.**

**Fixes Applied (January 2026):**

In `character_stats.gd`:
```gdscript
func show_for_unit(unit: ClickableUnit, camera: Camera3D = null) -> void:
    # Defensive: check validity before disconnecting
    if _current_unit and is_instance_valid(_current_unit):
        if _current_unit.stats_changed.is_connected(_on_stats_changed):
            _current_unit.stats_changed.disconnect(_on_stats_changed)

    _current_unit = unit
    # Prevent duplicate connections
    if not _current_unit.stats_changed.is_connected(_on_stats_changed):
        _current_unit.stats_changed.connect(_on_stats_changed)
```

In `inventory_panel.gd`:
```gdscript
# In _ready(), after finding/creating close button:
if _close_button:
    _close_button.mouse_filter = Control.MOUSE_FILTER_STOP
    _close_button.z_index = 10  # Draw above grid elements
```

**Debugging Tips:**
- Add `print()` in button handlers to verify clicks are reaching the handler
- Check if `is_connected()` returns true before connecting
- Always use `is_instance_valid()` before accessing potentially-freed nodes
- Watch for "object freed" errors in console during extended play

**Workaround:** ESC key always works to close panels regardless of click handling issues.

---

### Inventory Close Button Not Responding

**Symptom:** The X button on container/barrel inventories doesn't respond to clicks, but ESC works.

**Root Cause:** gloot's `CtrlInventoryGrid` and drag-drop system set aggressive `mouse_filter` values that block clicks from reaching the close button.

**Fix Applied:**
```gdscript
# Ensure close button has explicit click handling and z-order
_close_button.mouse_filter = Control.MOUSE_FILTER_STOP
_close_button.z_index = 10
```

**Note:** This is a gloot addon quirk. When using gloot inventory grids, always explicitly set `mouse_filter` and `z_index` on any overlay controls.
