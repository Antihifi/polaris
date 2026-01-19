# Vehicles System

## Overview
Vehicles are physics-based transport objects that can be pulled by units (men, dogs).

## Sled Setup (User Must Complete in Godot Editor)

### Step 1: Configure RigidBody3D Physics
Open `objects/sled1/sled_1.tscn` and select the Sled1 root node:

1. **Inspector → RigidBody3D:**
   - `mass = 150.0` (kg, base empty sled)
   - `gravity_scale = 1.0`
   - `freeze = false` (CRITICAL: must be unchecked)

2. **Inspector → Collision:**
   - `collision_layer = 16` (layer 5: vehicles)
   - `collision_mask = 11` (layers 1+2+8: terrain, units, containers)

### Step 2: Apply Friction Material
1. Select Sled1 root node (NOT CollisionShape3D)
2. Inspector → `physics_material_override`
3. Load `res://materials/physics/snow_friction.tres`

### Step 3: Attach Controller Script
1. Select Sled1 root node
2. Attach script: `res://src/vehicles/sled_controller.gd`

### Step 4: Add Direction Markers (Required)

The sled controller needs front/rear markers to determine the sled's orientation
for directional resistance (forward easy, backward hard, sideways impossible).

**Required Markers:**
1. Right-click Sled1 → Add Child Node → Marker3D → Rename to "SledFront"
2. Position at the front of the sled (where rope attaches)
3. Right-click Sled1 → Add Child Node → Marker3D → Rename to "SledRear"
4. Position at the back of the sled

**Final Structure:**
```
Sled1 (RigidBody3D) + sled_controller.gd
├── CollisionShape3D (BoxShape3D)
├── Sled (MeshInstance3D)
├── SledFront (Marker3D) - front of sled
└── SledRear (Marker3D) - back of sled
```

### Step 5: Add CargoArea (Optional - for weight detection)

**Add CargoArea node:**
1. Right-click Sled1 → Add Child Node → Area3D
2. Rename to "CargoArea"
3. Add CollisionShape3D child with BoxShape3D
4. Size the box to match the boat interior where cargo sits
5. Configure Area3D:
   - `collision_layer = 0`
   - `collision_mask = 10` (layers 2+8: units + containers)

---

## Collision Layers Reference

| Layer | Decimal | Purpose |
|-------|---------|---------|
| 1 | 1 | Terrain/static geometry |
| 2 | 2 | Units (survivors) |
| 3 | 4 | Navigation |
| 4 | 8 | Containers |
| 5 | 16 | Vehicles/Sleds |

---

## API Reference

### SledController

**Signals:**
- `puller_attached(unit: Node3D)` - Emitted when a unit attaches
- `puller_detached(unit: Node3D)` - Emitted when a unit detaches
- `cargo_changed(total_weight: float)` - Emitted when cargo weight changes

**Methods:**
- `attach_puller(unit: Node3D) -> bool` - Attach a unit as puller
- `detach_puller(unit: Node3D)` - Remove a unit from pulling
- `detach_all_pullers()` - Remove all pullers
- `get_cargo_weight() -> float` - Get cargo weight only
- `get_total_weight() -> float` - Get sled + cargo weight
- `can_add_cargo(weight: float) -> bool` - Check capacity

**Properties:**
- `pullers: Array[Node3D]` - Currently attached pullers
- `lead_puller: Node3D` - Navigation leader
- `is_being_pulled: bool` - Movement state

### ClickableUnit (Sled Pulling)

**Methods:**
- `attach_to_sled(sled: Node) -> bool` - Attach unit as puller
- `detach_from_sled()` - Detach from current sled
- `is_pulling_sled() -> bool` - Check if attached
- `get_nearest_sled(max_distance: float = 10.0) -> Node` - Find nearby sled

**Properties:**
- `attached_sled: Node` - Current sled (null if not pulling)
- `is_lead_puller: bool` - True if this unit leads navigation

**Usage Example (GDScript):**
```gdscript
# Attach unit to sled
var sled = unit.get_nearest_sled(5.0)
if sled:
    unit.attach_to_sled(sled)

# Move while pulling (lead puller navigates, sled follows)
unit.move_to(target_position)

# Detach when done
unit.detach_from_sled()
```

---

## Terrain Friction Values

| Texture ID | Surface | Friction |
|------------|---------|----------|
| 0 | Snow | 0.6-0.7 |
| 1 | Rock | 0.95+ |
| 2 | Gravel | 0.8-0.9 |
| 3 | Ice | 0.3-0.4 |

Currently using fixed snow friction (0.3). Future: query terrain texture and adjust dynamically.
