# Terrain Generation System

## Overview

The terrain generation system creates unique procedurally-generated arctic islands for each survival run. It uses Terrain3D's API for heightmap import, texture painting, and NavMesh baking. Each island is generated from a numeric seed that players can share.

**Key Design Goals:**
- Teardrop-shaped island (~12km x 9km) resembling King William Island
- Unique terrain every playthrough while maintaining gameplay balance
- Deadly ice zones surrounding the island (no artificial walls)
- 8-week journey from ship to HBC whaling station rescue point

---

## Files

| File | Purpose | Key Functions |
|------|---------|---------------|
| `terrain_generator.gd` | Main orchestrator | `generate(seed_manager)`, progress signals |
| `island_shape.gd` | Teardrop mask | `generate_mask(width, height, rng)` |
| `heightmap_generator.gd` | Height generation | `generate_heightmap()`, `generate_inlet()` |
| `texture_painter.gd` | Texture assignment | `paint_terrain(terrain_data, heightmap, mask, rng)` |
| `poi_placer.gd` | POI placement | `place_pois()`, `validate_poi_accessibility()` |
| `seed_manager.gd` | Seed management | `set_seed()`, `get_seed_string()`, sub-RNGs |

---

## Generation Pipeline

The terrain generation runs at new game start and takes approximately 45-90 seconds.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         TerrainGenerator                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ 1. SeedSetup │→ │ 2. Shape     │→ │ 3. Heightmap │→ │ 4. Inlet     │ │
│  │              │  │    Mask      │  │    Noise     │  │    Carve     │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘ │
│         │                                                     │         │
│         ▼                                                     ▼         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ 5. Terrain   │→ │ 6. Texture   │→ │ 7. NavMesh   │→ │ 8. POI       │ │
│  │    Import    │  │    Paint     │  │    Bake      │  │    Placement │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘ │
│                                                               │         │
│                                                               ▼         │
│                                                        ┌──────────────┐ │
│                                                        │ 9. Validate  │ │
│                                                        │    + Done    │ │
│                                                        └──────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Stage 1: Seed Setup

The `SeedManager` handles all randomness to ensure reproducibility.

```gdscript
class_name SeedManager extends RefCounted

var current_seed: int = 0
var rng: RandomNumberGenerator

func _init() -> void:
    rng = RandomNumberGenerator.new()

func set_seed(seed_value: int) -> void:
    current_seed = seed_value
    rng.seed = seed_value
    print("[SeedManager] Seed set to: %d" % seed_value)

func generate_random_seed() -> int:
    var new_seed := int(Time.get_unix_time_from_system() * 1000) ^ randi()
    set_seed(new_seed)
    return new_seed

func get_seed_string() -> String:
    # Returns hex string for sharing (e.g., "A3F7BC12")
    return "%X" % current_seed

func set_seed_from_string(seed_string: String) -> bool:
    if seed_string.is_valid_hex_number():
        set_seed(seed_string.hex_to_int())
        return true
    elif seed_string.is_valid_int():
        set_seed(seed_string.to_int())
        return true
    return false
```

### Sub-RNGs for Reproducibility

Each generation phase uses a separate RNG derived from the main seed. This ensures that changes to one phase don't affect others.

```gdscript
func get_shape_rng() -> RandomNumberGenerator:
    var sub_rng := RandomNumberGenerator.new()
    sub_rng.seed = current_seed ^ 0x12345678
    return sub_rng

func get_height_rng() -> RandomNumberGenerator:
    var sub_rng := RandomNumberGenerator.new()
    sub_rng.seed = current_seed ^ 0x87654321
    return sub_rng

func get_texture_rng() -> RandomNumberGenerator:
    var sub_rng := RandomNumberGenerator.new()
    sub_rng.seed = current_seed ^ 0xABCDEF01
    return sub_rng

func get_poi_rng() -> RandomNumberGenerator:
    var sub_rng := RandomNumberGenerator.new()
    sub_rng.seed = current_seed ^ 0xFEDCBA98
    return sub_rng
```

---

## Stage 2: Island Shape Mask

Generate a 1024x1024 grayscale image representing the island shape:
- `1.0` = center of island
- `0.0` = outside island (ice zone)
- Gradient values = coastline transition

### Teardrop Algorithm

The teardrop shape is created by:
1. Base ellipse centered slightly north of center
2. Distortion factor that widens the south
3. Coastal noise for natural coastline variation
4. Smooth falloff at edges

```gdscript
class_name IslandShape extends RefCounted

const ISLAND_WIDTH_KM: float = 9.0   # 8-10km E-W
const ISLAND_HEIGHT_KM: float = 11.0 # 10-12km N-S

static func generate_mask(width_px: int, height_px: int, rng: RandomNumberGenerator) -> Image:
    var mask := Image.create(width_px, height_px, false, Image.FORMAT_RF)

    # Create noise for coastline variation
    var coast_noise := FastNoiseLite.new()
    coast_noise.seed = rng.randi()
    coast_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
    coast_noise.frequency = 0.02

    # Island center (slightly north of center for teardrop)
    var center_x := width_px / 2.0
    var center_y := height_px * 0.45  # Shifted north

    # Radii in pixels (assuming ~10m per pixel at 1024px for ~10km)
    var radius_x := (ISLAND_WIDTH_KM * 100.0) / 2.0
    var radius_y := (ISLAND_HEIGHT_KM * 100.0) / 2.0

    for y in range(height_px):
        for x in range(width_px):
            # Normalize coordinates relative to center
            var nx := (x - center_x) / radius_x
            var ny := (y - center_y) / radius_y

            # Teardrop distortion: narrow at north (ny < 0), wide at south (ny > 0)
            var teardrop_factor := 1.0 + 0.4 * ny
            nx *= teardrop_factor

            # Distance from center (ellipse equation)
            var dist := sqrt(nx * nx + ny * ny)

            # Smooth falloff at edges
            var mask_value := smoothstep(1.2, 0.7, dist)

            # Add noise to coastline for natural variation
            var coast_variation := coast_noise.get_noise_2d(x, y)
            mask_value *= (1.0 + coast_variation * 0.15)

            mask.set_pixel(x, y, Color(clampf(mask_value, 0.0, 1.0), 0, 0, 1))

    return mask
```

---

## Stage 3: Heightmap Generation

Generate terrain heights using multi-octave noise combined with the island mask.

### Height Configuration

```gdscript
const MAX_MOUNTAIN_HEIGHT: float = 400.0  # Under 1000m, moderate peaks
const SEA_LEVEL: float = 0.0
const ICE_LEVEL: float = -5.0  # Surrounding ice slightly below sea level
```

### Noise Layers

| Layer | Type | Amplitude | Purpose |
|-------|------|-----------|---------|
| Base terrain | Simplex FBM | 0-50m | Rolling hills, valleys |
| Mountain | Simplex | 0-400m | Peaks, masked to center |
| Detail | High-frequency | 0-5m | Micro-terrain variation |

### Generation Algorithm

```gdscript
class_name HeightmapGenerator extends RefCounted

const OCTAVES: int = 6
const PERSISTENCE: float = 0.5
const LACUNARITY: float = 2.0

static func generate_heightmap(
    width_px: int,
    height_px: int,
    island_mask: Image,
    rng: RandomNumberGenerator
) -> Image:
    var heightmap := Image.create(width_px, height_px, false, Image.FORMAT_RF)

    # Create noise instances
    var base_noise := _create_noise(rng.randi(), 0.01, OCTAVES)
    var mountain_noise := _create_noise(rng.randi(), 0.005, 4)
    var detail_noise := _create_noise(rng.randi(), 0.05, 2)

    for y in range(height_px):
        for x in range(width_px):
            var mask_value: float = island_mask.get_pixel(x, y).r

            if mask_value < 0.01:
                # Outside island: flat ice
                heightmap.set_pixel(x, y, Color(ICE_LEVEL, 0, 0, 1))
                continue

            # Normalized coordinates (0-1)
            var ny := float(y) / height_px

            # Base terrain (rolling hills)
            var base_height := base_noise.get_noise_2d(x, y) * 50.0

            # Mountain regions (stronger in center, weaker at edges)
            var mountain_factor := mask_value * mask_value
            var mountain_height := mountain_noise.get_noise_2d(x, y)
            mountain_height = maxf(0.0, mountain_height) * MAX_MOUNTAIN_HEIGHT * mountain_factor

            # Southern slope bias (easier travel to south)
            var south_bias := (1.0 - ny) * 0.3

            # Detail noise
            var detail := detail_noise.get_noise_2d(x, y) * 5.0

            # Combine all layers
            var height := base_height + mountain_height + detail
            height *= mask_value  # Fade to ice at edges
            height *= (1.0 - south_bias)  # Lower in south
            height = maxf(height, SEA_LEVEL * mask_value)

            heightmap.set_pixel(x, y, Color(height, 0, 0, 1))

    return heightmap

static func _create_noise(seed: int, frequency: float, octaves: int) -> FastNoiseLite:
    var noise := FastNoiseLite.new()
    noise.seed = seed
    noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
    noise.fractal_type = FastNoiseLite.FRACTAL_FBM
    noise.fractal_octaves = octaves
    noise.fractal_persistence = PERSISTENCE
    noise.fractal_lacunarity = LACUNARITY
    noise.frequency = frequency
    return noise
```

---

## Stage 4: Inlet Generation

Carve an inlet on the north coast for the ship spawn location.

### Inlet Specifications
- **Side**: Random east or west of north coast
- **Position**: ~15% from top of map
- **Diameter**: ~800m
- **Depth**: Lowered to near sea level

```gdscript
static func generate_inlet(
    heightmap: Image,
    island_mask: Image,
    rng: RandomNumberGenerator
) -> Dictionary:
    var width := heightmap.get_width()
    var height := heightmap.get_height()

    # Choose east or west side of north coast
    var east_side := rng.randf() > 0.5
    var inlet_x := width * (0.7 if east_side else 0.3)
    var inlet_y := height * 0.15  # Northern 15%

    # Inlet parameters
    var inlet_radius := 80  # ~800m diameter

    for dy in range(-inlet_radius, inlet_radius):
        for dx in range(-inlet_radius, inlet_radius):
            var px := int(inlet_x + dx)
            var py := int(inlet_y + dy)

            if px < 0 or px >= width or py < 0 or py >= height:
                continue

            var dist := sqrt(dx * dx + dy * dy)
            if dist > inlet_radius:
                continue

            # Carve down to near sea level with smooth falloff
            var current_height: float = heightmap.get_pixel(px, py).r
            var carve_factor := 1.0 - (dist / inlet_radius)
            var new_height := lerpf(current_height, 2.0, carve_factor * 0.8)
            heightmap.set_pixel(px, py, Color(new_height, 0, 0, 1))

    # Convert pixel position to world coordinates
    # Assuming terrain centered at origin, ~10m per pixel
    var world_pos := Vector3(
        inlet_x * 10.0 - 5000.0,
        2.0,
        inlet_y * 10.0 - 5500.0
    )

    return {
        "position": world_pos,
        "east_side": east_side
    }
```

---

## Stage 5: Terrain3D Import

Apply the generated heightmap to Terrain3D.

### Import Process

```gdscript
func _import_heightmap_to_terrain(heightmap: Image) -> void:
    # Clear existing terrain data
    for region in _terrain.data.get_regions_active():
        _terrain.data.remove_region(region, false)

    # Create image array for import
    # [0] = Height map
    # [1] = Control map (textures - will be painted separately)
    # [2] = Color map (vertex colors)
    var images: Array[Image] = []
    images.resize(3)
    images[0] = heightmap
    images[1] = null  # Painted in texture stage
    images[2] = null  # Not used

    # Import at origin with no rotation, scale 1.0
    _terrain.data.import_images(images, Vector3.ZERO, 0.0, 1.0)

    # Recalculate height bounds
    _terrain.data.calc_height_range(true)
```

### Terrain3D Data Structure

Terrain3D stores data in regions (chunks). After import:
- Heightmap data is stored in `res://terrain/terrain3d_*.res` files
- Control maps define texture IDs at each point
- Regions are automatically created/managed

---

## Stage 6: Texture Painting

Assign textures based on height and slope.

### Texture Slot Configuration

| ID | Texture Asset | Usage |
|----|---------------|-------|
| 0 | snow_01 | Default, high elevation |
| 1 | rock_dark_01 | Steep slopes (>35°), cliff faces |
| 2 | ice01 | Sea level edges, surrounding ice |
| 3 | gravel01 | Low elevation, beaches, transitions |
| 4 | beach_sand | Southern beaches (optional) |

### Painting Rules

| Condition | Texture | Priority |
|-----------|---------|----------|
| Outside island (mask < 0.1) | Ice | Highest |
| Slope > 35° | Rock | High |
| Height < 5m | Gravel/Ice blend | Medium |
| Height 5-15m, Slope > 25° | Gravel | Medium |
| Default | Snow | Lowest |

### Implementation

```gdscript
class_name TexturePainter extends RefCounted

const TEXTURE_SNOW: int = 0
const TEXTURE_ROCK: int = 1
const TEXTURE_ICE: int = 2
const TEXTURE_GRAVEL: int = 3

const BEACH_MAX_HEIGHT: float = 5.0
const GRAVEL_MAX_HEIGHT: float = 15.0
const CLIFF_MIN_SLOPE: float = 35.0
const STEEP_MIN_SLOPE: float = 25.0

static func paint_terrain(
    terrain_data: Terrain3DData,
    heightmap: Image,
    island_mask: Image,
    rng: RandomNumberGenerator
) -> void:
    var width := heightmap.get_width()
    var height := heightmap.get_height()

    # Variation noise prevents uniform textures
    var variation_noise := FastNoiseLite.new()
    variation_noise.seed = rng.randi()
    variation_noise.frequency = 0.1

    for y in range(1, height - 1):
        for x in range(1, width - 1):
            var mask_value: float = island_mask.get_pixel(x, y).r
            var h: float = heightmap.get_pixel(x, y).r
            var slope := _calculate_slope(heightmap, x, y)
            var variation := variation_noise.get_noise_2d(x, y)

            # Convert pixel to world position
            var world_pos := Vector3(
                x * 10.0 - 5000.0,
                h,
                y * 10.0 - 5500.0
            )

            var texture_id := _determine_texture(h, slope, mask_value, variation)

            # Apply texture using Terrain3D API
            terrain_data.set_control_base_id(world_pos, texture_id)

            # Add blend variation to avoid hard edges
            if absf(variation) > 0.3:
                var blend := (absf(variation) - 0.3) / 0.7 * 0.3
                terrain_data.set_control_blend(world_pos, blend)

    # Apply changes
    terrain_data.update_maps()

static func _determine_texture(height: float, slope: float, mask: float, variation: float) -> int:
    # Outside island: ice
    if mask < 0.1:
        return TEXTURE_ICE

    # Steep slopes: rock
    if slope > CLIFF_MIN_SLOPE:
        return TEXTURE_ROCK

    # Near sea level: gravel/beach
    if height < BEACH_MAX_HEIGHT:
        return TEXTURE_GRAVEL if variation < 0.5 else TEXTURE_ICE

    # Low elevation with steep slope: gravel
    if height < GRAVEL_MAX_HEIGHT and slope > STEEP_MIN_SLOPE:
        return TEXTURE_GRAVEL

    # High steep areas: rock/snow mix
    if slope > STEEP_MIN_SLOPE:
        return TEXTURE_ROCK if variation > 0.3 else TEXTURE_SNOW

    return TEXTURE_SNOW

static func _calculate_slope(heightmap: Image, x: int, y: int) -> float:
    # Calculate slope from neighboring pixels using gradient
    var h_left := heightmap.get_pixel(x - 1, y).r
    var h_right := heightmap.get_pixel(x + 1, y).r
    var h_up := heightmap.get_pixel(x, y - 1).r
    var h_down := heightmap.get_pixel(x, y + 1).r

    var dx := (h_right - h_left) / 2.0
    var dy := (h_down - h_up) / 2.0

    var gradient := sqrt(dx * dx + dy * dy)
    return rad_to_deg(atan(gradient / 10.0))  # 10m per pixel
```

---

## Stage 7: NavMesh Baking

Bake navigation mesh for unit pathfinding. This is the slowest stage (30-60 seconds).

### Critical Configuration

| Setting | Value | Reason |
|---------|-------|--------|
| Bake AABB | Island only | Excludes infinite ice zone |
| Agent radius | 0.5m | Character size |
| Agent height | 1.8m | Character height |
| Agent max slope | 40° | Reasonable for arctic terrain |
| Cell size | 0.5m | Balance precision vs bake time |

### Bake AABB Calculation

The baking area should only cover the island, not the surrounding ice:

```gdscript
# For a ~12km x 9km island centered at origin
var bake_aabb := AABB(
    Vector3(-6000, -100, -6500),  # Min corner
    Vector3(12000, 600, 13000)    # Size
)
```

### Baking Implementation

```gdscript
func _bake_navigation_mesh() -> void:
    print("[TerrainGenerator] Starting NavMesh bake...")
    var start_time := Time.get_ticks_msec()

    # Get NavigationRegion3D (parent of Terrain3D)
    var nav_region: NavigationRegion3D = _terrain.get_parent()
    if not nav_region is NavigationRegion3D:
        push_error("Terrain3D must be child of NavigationRegion3D")
        return

    # Configure NavigationMesh
    var nav_mesh: NavigationMesh = nav_region.navigation_mesh
    if not nav_mesh:
        nav_mesh = NavigationMesh.new()

    # Set baking AABB to cover only the island
    nav_mesh.filter_baking_aabb = AABB(
        Vector3(-6000, -100, -6500),
        Vector3(12000, 600, 13000)
    )

    # Agent settings
    nav_mesh.agent_radius = 0.5
    nav_mesh.agent_height = 1.8
    nav_mesh.agent_max_climb = 0.4
    nav_mesh.agent_max_slope = 40.0

    # Cell settings
    nav_mesh.cell_size = 0.5
    nav_mesh.cell_height = 0.3

    # Parse source geometry from terrain
    var source_geometry := NavigationMeshSourceGeometryData3D.new()
    NavigationServer3D.parse_source_geometry_data(
        nav_mesh,
        source_geometry,
        nav_region
    )

    # Get terrain faces using Terrain3D's method
    if _terrain.has_method("generate_nav_mesh_source_geometry"):
        var terrain_faces: PackedVector3Array = _terrain.generate_nav_mesh_source_geometry(
            nav_mesh.filter_baking_aabb
        )
        if not terrain_faces.is_empty():
            source_geometry.add_faces(terrain_faces, Transform3D.IDENTITY)

    # Bake the navigation mesh
    NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)

    # Apply to region
    nav_region.navigation_mesh = nav_mesh

    var elapsed := (Time.get_ticks_msec() - start_time) / 1000.0
    print("[TerrainGenerator] NavMesh baked in %.1f seconds" % elapsed)
```

### Threading

For better UX, run baking in a background thread:

```gdscript
func _bake_navigation_mesh_async() -> void:
    var thread := Thread.new()
    thread.start(_bake_navigation_mesh)

    # Wait with timeout
    var timeout := 120.0  # 2 minutes max
    var start := Time.get_ticks_msec()
    while thread.is_alive():
        await get_tree().process_frame
        if (Time.get_ticks_msec() - start) / 1000.0 > timeout:
            push_error("NavMesh baking timeout!")
            break

    thread.wait_to_finish()
```

---

## Stage 8: POI Placement

Place key locations with distance constraints and validation.

### POI Specifications

| POI | Count | Distance from Ship | Elevation | Location |
|-----|-------|--------------------|-----------|----------|
| Ship Wreck | 1 | 0 (origin) | ~2m | Generated inlet |
| HBC Whaling Station | 1 | 8-10km | 2-20m | South coast |
| Inuit Village | 1-2 | 2-4km | 5-100m | Accessible terrain |

### Placement Algorithm

```gdscript
class_name POIPlacer extends RefCounted

const INUIT_MIN_DISTANCE: float = 2000.0  # 2km
const INUIT_MAX_DISTANCE: float = 4000.0  # 4km
const HBC_MIN_DISTANCE: float = 8000.0    # 8km
const HBC_MAX_DISTANCE: float = 10000.0   # 10km

static func place_pois(
    heightmap: Image,
    island_mask: Image,
    ship_position: Vector3,
    rng: RandomNumberGenerator
) -> Dictionary:
    var pois := {}

    # Ship already placed
    pois["ship"] = ship_position

    # Place HBC station on south coast
    pois["hbc_station"] = _place_hbc_station(heightmap, island_mask, ship_position, rng)

    # Place 1-2 Inuit villages
    var village_count := rng.randi_range(1, 2)
    pois["inuit_villages"] = []
    for i in range(village_count):
        var village_pos := _place_inuit_village(
            heightmap,
            island_mask,
            ship_position,
            pois.get("inuit_villages", []),
            rng
        )
        if village_pos != Vector3.INF:
            pois["inuit_villages"].append(village_pos)

    return pois

static func _place_hbc_station(
    heightmap: Image,
    island_mask: Image,
    ship_pos: Vector3,
    rng: RandomNumberGenerator
) -> Vector3:
    var best_pos := Vector3.INF
    var best_score := -INF
    var attempts := 100

    var width := heightmap.get_width()
    var height := heightmap.get_height()

    for i in range(attempts):
        # Focus on southern 20% of map
        var px := rng.randi_range(int(width * 0.2), int(width * 0.8))
        var py := rng.randi_range(int(height * 0.8), int(height * 0.95))

        var mask: float = island_mask.get_pixel(px, py).r
        if mask < 0.3:  # Must be on island
            continue

        var h: float = heightmap.get_pixel(px, py).r
        if h < 2.0 or h > 20.0:  # Must be near sea level
            continue

        var world_pos := Vector3(
            px * 10.0 - 5000.0,
            h,
            py * 10.0 - 5500.0
        )

        var dist := ship_pos.distance_to(world_pos)
        if dist < HBC_MIN_DISTANCE or dist > HBC_MAX_DISTANCE:
            continue

        # Score: prefer flat, coastal, at target distance
        var score := -abs(h - 5.0)  # Prefer ~5m elevation
        score -= abs(dist - 9000.0) / 1000.0  # Prefer ~9km distance

        if score > best_score:
            best_score = score
            best_pos = world_pos

    return best_pos

static func _place_inuit_village(
    heightmap: Image,
    island_mask: Image,
    ship_pos: Vector3,
    existing_villages: Array,
    rng: RandomNumberGenerator
) -> Vector3:
    var attempts := 100
    var width := heightmap.get_width()
    var height := heightmap.get_height()

    for i in range(attempts):
        var px := rng.randi_range(int(width * 0.1), int(width * 0.9))
        var py := rng.randi_range(int(height * 0.2), int(height * 0.7))

        var mask: float = island_mask.get_pixel(px, py).r
        if mask < 0.5:
            continue

        var h: float = heightmap.get_pixel(px, py).r
        if h < 5.0 or h > 100.0:
            continue

        var world_pos := Vector3(
            px * 10.0 - 5000.0,
            h,
            py * 10.0 - 5500.0
        )

        var dist_to_ship := ship_pos.distance_to(world_pos)
        if dist_to_ship < INUIT_MIN_DISTANCE or dist_to_ship > INUIT_MAX_DISTANCE:
            continue

        # Check distance from other villages
        var too_close := false
        for existing in existing_villages:
            if world_pos.distance_to(existing) < 1500.0:  # Min 1.5km apart
                too_close = true
                break

        if too_close:
            continue

        return world_pos

    return Vector3.INF
```

---

## Stage 9: POI Validation

After NavMesh bake, verify all POIs are reachable from the ship.

```gdscript
static func validate_poi_accessibility(
    nav_region: NavigationRegion3D,
    ship_pos: Vector3,
    pois: Dictionary
) -> bool:
    var nav_map := nav_region.get_navigation_map()
    var all_valid := true

    for poi_name in pois:
        if poi_name == "ship":
            continue

        var poi_pos: Variant = pois[poi_name]
        if poi_pos is Array:
            for pos in poi_pos:
                if not _is_reachable(nav_map, ship_pos, pos):
                    push_warning("POI unreachable: %s at %s" % [poi_name, pos])
                    all_valid = false
        elif poi_pos is Vector3:
            if not _is_reachable(nav_map, ship_pos, poi_pos):
                push_warning("POI unreachable: %s at %s" % [poi_name, poi_pos])
                all_valid = false

    return all_valid

static func _is_reachable(nav_map: RID, from: Vector3, to: Vector3) -> bool:
    var path := NavigationServer3D.map_get_path(nav_map, from, to, true)
    return path.size() > 0
```

---

## Terrain3D API Reference

### Height Operations

```gdscript
# Set height at world position
terrain.data.set_height(position: Vector3, height: float)

# Query height (with interpolation)
terrain.data.get_height(position: Vector3) -> float

# Import heightmap images
terrain.data.import_images(images: Array[Image], offset: Vector3, rotation: float, scale: float)

# Recalculate height bounds
terrain.data.calc_height_range(update_mesh: bool)
```

### Texture Operations

```gdscript
# Set base texture (0-31)
terrain.data.set_control_base_id(position: Vector3, id: int)

# Set overlay texture
terrain.data.set_control_overlay_id(position: Vector3, id: int)

# Blend between base and overlay (0.0-1.0)
terrain.data.set_control_blend(position: Vector3, blend: float)

# UV rotation (0-7 = 0°, 22.5°, 45°, ... 157.5°)
terrain.data.set_control_angle(position: Vector3, step: int)

# UV scale adjustment (-60% to +80%)
terrain.data.set_control_scale(position: Vector3, scale: float)
```

### Region Management

```gdscript
# Get active region positions
terrain.data.get_regions_active() -> Array

# Remove a region
terrain.data.remove_region(position: Vector3, update: bool)

# Apply changes after painting
terrain.data.update_maps()
```

---

## Integration Points

### MainController Hook

```gdscript
# In src/main_controller.gd
func _ready() -> void:
    if GameManager.is_new_game:
        var generator := TerrainGenerator.new()
        add_child(generator)
        generator.generation_completed.connect(_on_terrain_ready)
        generator.generation_progress.connect(_on_generation_progress)
        await generator.generate(GameManager.seed_manager)

    _spawn_survivors()

func _on_terrain_ready(pois: Dictionary) -> void:
    spawn_center = pois.ship
    GameManager.set_poi_locations(pois)

func _on_generation_progress(stage: String, percent: float) -> void:
    # Update loading screen
    loading_label.text = stage
    loading_bar.value = percent
```

### GameManager Integration

```gdscript
# In src/game_manager.gd
var seed_manager: SeedManager
var poi_locations: Dictionary = {}
var is_new_game: bool = true

signal poi_locations_set(pois: Dictionary)

func _ready() -> void:
    seed_manager = SeedManager.new()

func start_new_game(seed: int = 0) -> void:
    is_new_game = true
    if seed == 0:
        seed_manager.generate_random_seed()
    else:
        seed_manager.set_seed(seed)

func set_poi_locations(pois: Dictionary) -> void:
    poi_locations = pois
    poi_locations_set.emit(pois)
```

### CharacterSpawner Integration

```gdscript
# In src/systems/character_spawner.gd
func spawn_survivors_at_ship(count: int) -> Array[Node]:
    var ship_pos: Vector3 = GameManager.poi_locations.get("ship", Vector3.ZERO)
    return spawn_survivors(count, ship_pos)
```

---

## Error Handling

### Generation Failures

If terrain generation fails at any stage:
1. Log detailed error with stage information
2. Load fallback hand-crafted terrain (`terrain/world_map.tscn`)
3. Set default POI positions

```gdscript
func _on_generation_failed(reason: String) -> void:
    push_error("[TerrainGenerator] Generation failed: %s" % reason)
    push_warning("Loading fallback terrain...")
    _load_fallback_terrain()

func _load_fallback_terrain() -> void:
    var fallback := load("res://terrain/world_map.tscn").instantiate()
    get_tree().current_scene.add_child(fallback)

    # Set default POI positions for fallback terrain
    GameManager.set_poi_locations({
        "ship": Vector3(0, 5, 0),
        "hbc_station": Vector3(0, 5, 9000),
        "inuit_villages": [Vector3(2000, 10, 1500)]
    })
```

### Unreachable POIs

If pathfinding validation fails:
1. Log warning with POI name and position
2. Attempt repositioning within constraints (up to 3 attempts)
3. If still failing, consider regenerating with different seed
4. Log warning if fallback used

### NavMesh Timeout

If baking exceeds 2 minutes:
1. Log warning
2. Continue with partial mesh
3. POIs may be unreachable - warn player in UI

---

## Performance Considerations

### Generation Time Budget

| Stage | Estimated Time | Notes |
|-------|---------------|-------|
| Seed Setup | <1s | Instant |
| Shape Mask | 1-2s | 1024x1024 pixels |
| Heightmap | 2-4s | Multi-octave noise |
| Inlet Carving | <1s | Local modification |
| Terrain Import | 5-10s | Terrain3D processing |
| Texture Painting | 10-20s | Per-pixel control map |
| NavMesh Bake | 30-60s | **Main bottleneck** |
| POI Placement | <1s | Sampling + validation |
| **Total** | **45-90s** | Show loading screen |

### Memory Usage

| Data | Size | Notes |
|------|------|-------|
| Heightmap Image (1024x1024, FORMAT_RF) | ~4MB | Float32 per pixel |
| Island Mask Image | ~4MB | Same format |
| NavMesh data | 10-50MB | Depends on complexity |
| Peak during generation | 60-100MB | All images in memory |

### Optimization Strategies

1. **Threaded NavMesh**: Run baking in background thread
2. **Chunked painting**: Process texture painting in batches with `await get_tree().process_frame` to avoid freezing
3. **Progress signals**: Emit progress updates for loading screen
4. **Early region pruning**: Don't generate terrain data outside island bounds

---

## Testing

### Unit Tests

1. **Seed reproducibility**: Same seed produces identical mask/heightmap
2. **Height ranges**: All heights within expected bounds
3. **Texture rules**: Correct texture assigned for given height/slope
4. **POI distances**: POIs within specified distance ranges

### Integration Tests

1. **POI accessibility**: All POIs reachable from ship via pathfinding
2. **Height queries**: `terrain.data.get_height()` returns valid values at any position
3. **NavMesh coverage**: NavMesh covers entire island area

### Visual Tests

1. **Island shape**: Looks like teardrop, narrow north, wide south
2. **Texture distribution**: Snow on peaks, rock on cliffs, gravel on beaches
3. **Coastline**: Natural-looking, not perfectly geometric
4. **No artifacts**: No holes, spikes, or obvious seams

---

## Common Issues

### "Terrain3D not found"

**Cause**: Scene hierarchy doesn't have NavigationRegion3D → Terrain3D structure.

**Solution**:
- Ensure Terrain3D is child of NavigationRegion3D
- Add Terrain3D to "terrain" group for discovery
- Check `_find_terrain_nodes()` logic

### NavMesh not covering terrain

**Cause**: Baking AABB doesn't include all terrain, or agent settings too restrictive.

**Solution**:
- Verify `filter_baking_aabb` covers entire island
- Check `agent_max_slope` matches terrain steepness (40° recommended)
- Ensure terrain collision is enabled

### POIs spawning in water/ice

**Cause**: Mask threshold too low or elevation check incorrect.

**Solution**:
- Increase mask threshold (0.3 for HBC, 0.5 for villages)
- Verify elevation checks match terrain heights
- Add logging to placement attempts

### Textures not painting

**Cause**: Control maps not updated after painting.

**Solution**:
- Call `terrain.data.update_maps()` after all painting complete
- Verify texture slots are configured in Terrain3D material
- Check that texture IDs match configured slots

### Slope calculation returning wrong values

**Cause**: Pixel spacing not matching terrain scale.

**Solution**:
- Verify `10.0` divisor in slope calculation matches actual meters per pixel
- Check heightmap has correct resolution for terrain size

---

## Known Issues and Workarounds

### Texture Painting DISABLED (Causes Crash)

**Status**: DISABLED in `texture_painter.gd`

**Issue**: Terrain3D's `set_control_*` methods crash when called on positions without active terrain regions. The `import_images` call doesn't create regions covering the full 10km procedural area.

**Error**: 4096+ errors of "No active region found at: (X, Y, Z)" followed by hard crash.

**Workaround**: Texture painting is completely disabled. Terrain uses existing textures from `world_map.tscn` base scene.

**TODO**: Investigate how to properly create terrain regions before painting, or import a control map image alongside the heightmap.

### Island Scale (Fixed)

**Previous Issue**: Island was tiny (~1km) surrounded by vast ice wasteland.

**Root Cause**: The mask algorithm was creating a small teardrop feature in the center of a 10km terrain, instead of filling the terrain with the island.

**Fix**: Rewrote `island_shape.gd` to make the island fill most of the terrain (~9km x 10km) with only a 500m ice border on N/E/W edges.

### Mountain Spikiness (Fixed)

**Previous Issue**: Terrain had aggressive spiky peaks inappropriate for arctic landscape.

**Root Cause**: Ridge noise (FRACTAL_RIDGED) created sharp mountain features.

**Fix**:
- Removed ridge noise entirely
- Reduced max height from 350m to 150m
- Reduced octaves from 5 to 3
- Increased noise smoothness

### Captain Spawning at Origin (Fixed)

**Previous Issue**: Captain spawned at (0, 0, 0) instead of ship position.

**Root Cause**: `debug_menu.gd` checked `ship_pos != Vector3.ZERO` which could fail if ship was near origin.

**Fix**:
- Removed the Vector3.ZERO check
- Added terrain height query for accurate Y position
- Better debug logging

### Godot 4.x API Changes

**Issue**: `fractal_persistence` property doesn't exist in Godot 4.x FastNoiseLite.

**Fix**: Use `fractal_gain` instead (renamed in Godot 4.x).

---

## Signals

The `TerrainGenerator` emits these signals for UI integration:

```gdscript
signal generation_started
signal generation_progress(stage: String, percent: float)
signal generation_completed(pois: Dictionary)
signal generation_failed(reason: String)
```

### Progress Stages

| Stage | Percent | Description |
|-------|---------|-------------|
| "Initializing" | 0.0 | Starting generation |
| "Generating island shape" | 0.1 | Creating mask |
| "Generating heightmap" | 0.2 | Noise generation |
| "Carving inlet" | 0.3 | Ship spawn location |
| "Importing terrain" | 0.4 | Applying to Terrain3D |
| "Painting textures" | 0.5 | Height/slope texturing |
| "Updating terrain" | 0.6 | Finalizing maps |
| "Baking navigation" | 0.7 | NavMesh (slow) |
| "Placing POIs" | 0.9 | Key locations |
| "Complete" | 1.0 | Done |
