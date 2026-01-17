# Terrain Generation System

## Overview

Procedural arctic island generation using Terrain3D. Creates unique ~10km teardrop-shaped islands for each survival run.

**Key Files:**
| File | Purpose |
|------|---------|
| `terrain_generator.gd` | Main orchestrator |
| `island_shape.gd` | Teardrop mask generation |
| `heightmap_generator.gd` | Multi-octave noise heights |
| `texture_painter.gd` | Height/slope-based textures |
| `terrain_config.gd` | Configurable parameters (@tool resource) |

---

## Reference Resources

### Terrain3D Demo (WORKING REFERENCE)
**Location**: `tmp/demo/src/`

| File | Use For |
|------|---------|
| `RuntimeNavigationBaker.gd` | Dynamic NavMesh baking |
| `CodeGenerated.gd` | Procedural Terrain3D setup |
| `Enemy.gd` | NavigationAgent3D + terrain floor checks |

### Terrain3D Discord Archive
**Location**: `terrain3d_discord_archive/` - Search with grep for troubleshooting.

---

## Generation Pipeline

```
SeedSetup → IslandMask → Heightmap → InletCarve → TerrainImport → TexturePaint → NavMeshBake → POIPlace
```

**Time Budget**: ~45-90 seconds total (NavMesh bake is slowest at 30-60s)

---

## Key Constants

```
Resolution:       4096 x 4096 pixels
Vertex spacing:   2.5 meters/pixel
World size:       10,240 x 10,240 meters
Center:           pixel (2048, 2048) = world (0, 0)

Pixel → World:  world_x = (pixel_x - 2048) * 2.5
World → Pixel:  pixel_x = (world_x / 2.5) + 2048
```

---

## Critical API Notes

### import_images() Offset is PIXEL Coordinates
```gdscript
# CORRECT - offset in pixels, not world meters
var half_size := float(image_size) / 2.0
var offset := Vector3(-half_size, 0, -half_size)
terrain.data.import_images(images, offset, 0.0, height_scale)
```

### generate_nav_mesh_source_geometry() Second Parameter
```gdscript
# WRONG - returns 0 faces for procedural terrain
var faces := terrain.generate_nav_mesh_source_geometry(aabb)  # default=true

# CORRECT - false = generate for entire terrain
var faces := terrain.generate_nav_mesh_source_geometry(aabb, false)
```

### Control Map Format
Uses 32-bit packed uint stored as float (FORMAT_RF). See [Terrain3D docs](https://terrain3d.readthedocs.io/en/stable/docs/controlmap_format.html).

---

## Texture Slots

**Must match `procedural_terrain_config.tscn` texture_list order:**

| ID | Texture | Usage |
|----|---------|-------|
| 0 | snow_01 | Default, high elevation |
| 1 | rock_dark_01 | Steep slopes (>40°) |
| 2 | gravel01 | Low elevation, wind-swept |
| 3 | ice01 | Frozen sea (base under snow) |

---

## Inlet/Channel System

The inlet is a **meandering frozen channel** carved from the north coast into the island:
- Extends ~375m into frozen sea
- ~400px (~1km) channel into island
- Meandering waypoints using sine waves
- Tapers from wide mouth to narrow terminus
- Walkable ramp at inland end (~35% max slope)

**Ship spawns in the frozen channel** (ice/snow texture), not on land.

---

## Runtime Navigation (SOLVED)

Navigation works via RuntimeNavBaker. Key discovery: **NavigationRegion3D must be ENABLED before bake**.

```gdscript
# In procedural_game_controller.gd
runtime_nav_baker.enabled = true  # Enable BEFORE bake
runtime_nav_baker.force_bake_at(spawn_pos)
await runtime_nav_baker.bake_finished
```

---

## 🚧 PENDING REQUIREMENTS (2026-01-17)

### 1. Ship Spawn Position Fix
**Issue**: Ship spawns at ramp exit (gravel/snow) instead of frozen channel (ice/snow).
**Fix needed**: Return spawn position earlier in channel where floor is at frozen sea level.

### 2. Guaranteed Ship → HBC Path
Must have at least ONE traversable interior path from ship to HBC station (southern coast). Cannot require circumnavigation.

### 3. POI Accessibility Validation
All POIs must be pathfind-reachable from ship. Test paths on placement, relocate if unreachable.

| POI Type | Location |
|----------|----------|
| Ship + Base | Frozen inlet (north) |
| HBC Station | South coast |
| Inuit Villages | Near coasts |
| Polar Bears | Roaming/inland |
| Wolves | Inland |
| Caribou | Inland flats |
| Shipwrecks | Frozen water (reachable from shore) |
| Cairns/Caches | Various |

### 4. NavMesh Baking Order
**Problem**: NavMesh baked before POIs → units stuck on ship/crates.

**Recommended fix** (Hybrid):
1. Generate terrain
2. Place ship + base camp objects
3. Bake NavMesh for starting area (~500m)
4. Spawn captain
5. Place distant POIs in background
6. Use RuntimeNavBaker for progressive baking

### 5. Add Erosion Effects
Terrain too smooth. Need gullies, weathered outcrops, drainage channels.

### 6. Remove Ridged Noise
Completely eliminate - causes "castle wall" artifacts. Arctic terrain should be weathered, not sharp.

---

## Signals

```gdscript
signal generation_started
signal generation_progress(stage: String, percent: float)
signal generation_completed(pois: Dictionary)
signal generation_failed(reason: String)
```

---

## Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| NavMesh 0 polygons | Missing `false` param | Use `generate_nav_mesh_source_geometry(aabb, false)` |
| Units floating | Height mismatch | Spawn high + let gravity drop them |
| Textures blocky | Post-import painting | Use control map in import_images() |
| No regions created | Wrong offset | Use pixel coords not world coords |
| Region disabled during bake | Enable after bake | Enable region BEFORE calling force_bake_at() |
