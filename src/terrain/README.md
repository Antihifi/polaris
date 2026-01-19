# Procedural Terrain Generation System

## Overview

The Polaris terrain system generates realistic arctic island terrain procedurally using multi-octave noise, regional zones, and configurable parameters. The system integrates with Terrain3D for rendering and supports live parameter editing through a Godot editor plugin.

## Architecture

```
src/terrain/
├── terrain_generator.gd      # Main orchestrator - coordinates all generation stages
├── heightmap_generator.gd    # Core height generation using noise algorithms
├── island_shape.gd           # Teardrop island mask generation
├── texture_painter.gd        # Height/slope-based texture assignment
├── poi_placer.gd             # Point of interest placement with pathfinding validation
├── seed_manager.gd           # Seed handling and persistence
├── terrain_config.gd         # Configuration resource with all tweakable parameters
└── CLAUDE.md                 # Developer documentation

addons/terrain_params/
├── plugin.cfg                # Editor plugin definition
├── plugin.gd                 # EditorPlugin that adds dock panel
├── terrain_params_dock.gd    # Dock UI with sliders for all parameters
└── terrain_params_dock.tscn  # Scene file for the dock
```

## Quick Start

1. **Enable the Plugin**: Project Settings → Plugins → Enable "Terrain Parameters"
2. **Open the Dock**: A "Terrain Parameters" dock appears in the editor (usually right side)
3. **Adjust Parameters**: Use sliders to modify terrain generation settings
4. **Save Config**: Click "Save Config" to persist to `res://terrain/terrain_params.tres`
5. **Run Game**: Terrain generates using your saved parameters

---

## Terrain Parameters Reference

### Ridge Parameters (Castle Wall Fix)

These parameters control the ridged noise that creates mountain ridge lines. **The "castle wall" artifact was caused by overly aggressive ridge settings.**

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `ridge_amplitude` | 0.0 - 1.0 | 0.3 | **Strength of ridge features on mountain peaks.** Higher values create more pronounced ridges. Values above 0.5 can cause the "castle wall" artifact where ridges become too regular and mechanical. Recommended: 0.1-0.4 for natural terrain. |
| `ridge_frequency` | 0.001 - 0.02 | 0.008 | **Spacing between ridge lines.** Lower values = wider spacing between ridges. At 0.008, ridges appear roughly every 312 meters. Increase for more detailed ridge patterns, decrease for broader mountain shapes. |
| `valley_cut_strength` | 0.0 - 0.5 | 0.3 | **Depth of valleys carved between ridges.** Higher values create deeper V-shaped valleys between ridge lines. Works in conjunction with ridge_amplitude to create the mountain's profile. |
| `use_ridged_noise` | bool | true | **Toggle ridged noise algorithm on/off.** When ON, uses the absolute value trick (`1.0 - abs(noise)`) to create sharp ridge lines where noise crosses zero. When OFF, uses standard smooth noise for gentler, more rounded peaks. **Turn OFF to completely eliminate castle walls.** |

#### Technical: How Ridged Noise Works

Standard noise produces smooth undulations. Ridged noise uses the "absolute value trick":

```gdscript
# Standard noise: smooth waves between -1 and +1
var noise_val = noise.get_noise_2d(x, y)

# Ridged noise: creates peaks wherever noise crosses zero
var ridge_val = 1.0 - absf(noise_val)  # Peak at every zero crossing
ridge_val = ridge_val * ridge_val       # Sharpen into ridges
```

The problem: With periodic noise, zero crossings are evenly spaced, creating mechanical "castle wall" ridges. The solution: Reduce `ridge_amplitude` to minimize their visual impact, or disable `use_ridged_noise` entirely.

---

### Cliff Parameters

Control the jagged cliff features that appear on coastlines and mountain bands.

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `cliff_frequency` | 0.001 - 0.02 | 0.006 | **Base frequency for cliff noise.** Controls the scale of cliff features. Higher = more frequent, smaller cliffs. Lower = broader cliff formations. |
| `coastal_cliff_strength` | 0.0 - 1.0 | 0.3 | **Cliff intensity on coastlines.** Affects areas where the island mask is between 0.5-0.8 (transition from sea to land). Higher values create more dramatic coastal cliffs. |
| `mountain_cliff_strength` | 0.0 - 1.0 | 0.5 | **Cliff intensity in mountain band.** Applied when `ny < mountain_band_center`. Creates rugged mountain faces. Scales down with distance from mountain band center. |
| `midland_cliff_strength` | 0.0 - 0.5 | 0.0 | **Cliff intensity in midland corridor.** The midlands (navigable zone between mountains and plains) default to 0.0 for smooth traversal. Increase for rougher midland terrain, but this affects pathfinding. |

#### Cliff Zones Explained

The terrain is divided into zones that receive different cliff treatment:

1. **Coastal Zone** (`mask_value < 0.8` OR `ny < midland_start`): Full jagged cliffs using `coastal_cliff_strength`
2. **Mountain Band** (`mountain_dist < 1.0`): Enhanced cliffs using `mountain_cliff_strength`
3. **Midlands** (`mask_value > 0.8` AND `ny` between `midland_start` and `flat_plains_start`): Minimal cliffs for navigation
4. **Flat Plains** (`ny > flat_plains_start`): No cliffs, gentle terrain

---

### Height Constraints

Control the overall vertical scale of terrain features.

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `max_mountain_height` | 100.0 - 500.0 | 350.0 | **Maximum height of mountain peaks in meters.** The GDD specifies mountains under 400m. This caps the height of distinct peaks defined in the peak positions array. |
| `max_hill_height` | 50.0 - 200.0 | 120.0 | **Maximum height of rolling hills in meters.** Hills appear throughout the island, reduced in flat plains and midlands. Also used as base multiplier for mountain band highlands (×1.5). |
| `base_terrain_amplitude` | 5.0 - 50.0 | 25.0 | **Gentle base undulation everywhere in meters.** Creates the subtle ground-level variation across the entire island. Low frequency, smooth variation. |
| `detail_amplitude` | 1.0 - 10.0 | 3.0 | **Micro-terrain height variation in meters.** High-frequency detail that adds surface texture. Keep low (2-5m) for realistic ground variation. |
| `sea_level` | -5.0 - 5.0 | 0.0 | **Reference height for sea level in meters.** Currently unused in generation but reserved for future water/ice features. |
| `ice_level` | -10.0 - 0.0 | -2.0 | **Height of surrounding frozen sea in meters.** The flat ice surrounding the island sits at this level. Negative to be below the island. |
| `beach_height` | 2.0 - 20.0 | 8.0 | **Target height of southern beaches in meters.** The southern beach zone lerps toward this height. Must be above ice_level for beaches to be visible. |

---

### Regional Parameters

Control how the island is divided into distinct terrain zones from north to south.

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `mountain_band_center` | 0.2 - 0.6 | 0.4 | **North-south position of mountain band center.** Normalized Y coordinate (0 = north edge, 1 = south edge). At 0.4, mountains are concentrated in the upper-middle of the island. |
| `mountain_band_width` | 0.1 - 0.5 | 0.3 | **Width of the mountain band zone.** How far the mountain influence extends from center. At 0.3, mountains influence ny from 0.1 to 0.7. |
| `midland_start` | 0.2 - 0.5 | 0.35 | **Where the navigable midland corridor begins.** Terrain between this and `flat_plains_start` receives hill smoothing for easier traversal. |
| `flat_plains_start` | 0.5 - 0.8 | 0.65 | **Where flat plains begin.** South of this line, hills are progressively reduced. The primary "easy travel" zone. |
| `beach_start` | 0.8 - 0.95 | 0.88 | **Where the southern beach zone begins.** Terrain south of this lerps toward `beach_height`. |
| `midland_hill_smoothing` | 0.0 - 1.0 | 0.7 | **How much to reduce hills in midlands.** 0.0 = no reduction (full hills), 1.0 = maximum reduction (very smooth). Applied as a sine curve peaking in the middle of the midland zone. |

#### Regional Zone Diagram

```
NY = 0.0  ┌─────────────────────────────────┐  NORTH (rugged, +50m boost)
          │         Northern Highlands       │
NY = 0.25 ├─────────────────────────────────┤
          │     ▲ Mountain Peaks (350m)     │  PEAK ZONE
NY = 0.35 ├─────────────────────────────────┤  midland_start
          │       Midland Corridor          │  MIDLANDS (smooth, navigable)
          │    (reduced hills, no cliffs)   │
NY = 0.65 ├─────────────────────────────────┤  flat_plains_start
          │         Flat Plains             │  PLAINS (gentle slope)
NY = 0.88 ├─────────────────────────────────┤  beach_start
          │      Southern Beaches           │  BEACH (lerp to beach_height)
NY = 1.0  └─────────────────────────────────┘  SOUTH
```

---

### Noise Frequencies

Control the scale of various noise layers. Lower frequency = larger features, higher frequency = more detail.

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `base_frequency` | 0.001 - 0.01 | 0.004 | **Base terrain undulation frequency.** Very low for smooth, island-scale variation. One "wave" every ~625 pixels at 0.004. |
| `hill_frequency` | 0.001 - 0.01 | 0.003 | **Rolling hills frequency.** Slightly lower than base for broader hill formations. |
| `mountain_frequency` | 0.001 - 0.01 | 0.002 | **Mountain feature frequency.** Even lower for large-scale mountain shapes. Used for noise variation on peaks. |
| `detail_frequency` | 0.005 - 0.05 | 0.02 | **Micro-terrain frequency.** Higher for ground-level surface detail. Creates the "texture" of the terrain surface. |
| `octaves` | 1 - 6 | 3 | **Number of noise octaves for base terrain.** More octaves = more detail layers. Each octave adds finer detail at higher frequency. Performance impact at high values. |
| `persistence` | 0.1 - 0.8 | 0.4 | **Amplitude reduction per octave.** Controls how much each successive octave contributes. Lower = smoother terrain (higher octaves contribute less). Higher = more rough detail. |
| `lacunarity` | 1.5 - 3.0 | 2.0 | **Frequency multiplier per octave.** How much each octave's frequency increases. 2.0 means each octave is double the frequency of the previous. |

#### Understanding Fractal Noise

The terrain uses Fractal Brownian Motion (fBm) noise, which combines multiple "octaves" of noise:

```
Total = Octave1 + (Octave2 × persistence) + (Octave3 × persistence²) + ...

Where each octave has frequency = base_frequency × lacunarity^octave_number
```

Example with defaults (base_freq=0.004, persistence=0.4, lacunarity=2.0, octaves=3):
- Octave 1: freq=0.004, amplitude=1.0
- Octave 2: freq=0.008, amplitude=0.4
- Octave 3: freq=0.016, amplitude=0.16

---

### Inlet Parameters

Control the ship landing cove carved into the island.

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `inlet_width_pixels` | 40 - 200 | 80 | **Width of the cove mouth in pixels.** At 2.5m/pixel, 80px = 200m wide. Must be large enough for the ship model plus maneuvering room. |
| `inlet_length_pixels` | 100 - 600 | 400 | **How far the cove extends into the island in pixels.** At 2.5m/pixel, 400px = 1000m. Longer inlets provide more sheltered landing area. |
| `inlet_floor_height` | 1.0 - 10.0 | 3.0 | **Height of the cove floor in meters.** The flat bottom of the cove. Must be above ice_level but low enough for ship placement. |
| `frozen_sea_height` | -5.0 - 0.0 | -2.0 | **Flat frozen sea level around island.** Same as ice_level. The cove connects the frozen sea to the island interior. |
| `inlet_blend_radius` | 10 - 80 | 40 | **Smooth transition zone width in pixels.** Prevents sharp edges where cove meets terrain. Larger = smoother but less defined cove edges. |

---

### Mountain Peak Parameters

Define 1-3 distinct mountain peaks. Each peak creates a localized high point with configurable position, height, and influence radius.

#### Peak 1 (Northwest Peak - Highest)

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `peak_1_enabled` | bool | true | Enable/disable this peak entirely. |
| `peak_1_x` | 0.1 - 0.9 | 0.35 | X position (0=west, 1=east). Default places peak in northwest. |
| `peak_1_y` | 0.1 - 0.9 | 0.30 | Y position (0=north, 1=south). Default places peak in northern region. |
| `peak_1_height` | 100.0 - 400.0 | 350.0 | Maximum height of this peak in meters. |
| `peak_1_radius` | 0.05 - 0.3 | 0.15 | Influence radius (normalized). 0.15 = influences 15% of island width. |

#### Peak 2 (Central Peak - Medium)

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `peak_2_enabled` | bool | true | Enable/disable this peak. |
| `peak_2_x` | 0.1 - 0.9 | 0.55 | X position. Default: east of center. |
| `peak_2_y` | 0.1 - 0.9 | 0.40 | Y position. Default: central. |
| `peak_2_height` | 100.0 - 400.0 | 280.0 | Maximum height in meters. |
| `peak_2_radius` | 0.05 - 0.3 | 0.12 | Influence radius. |

#### Peak 3 (North Peak - Secondary)

| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| `peak_3_enabled` | bool | true | Enable/disable this peak. |
| `peak_3_x` | 0.1 - 0.9 | 0.45 | X position. Default: center. |
| `peak_3_y` | 0.1 - 0.9 | 0.25 | Y position. Default: north. |
| `peak_3_height` | 100.0 - 400.0 | 320.0 | Maximum height in meters. |
| `peak_3_radius` | 0.05 - 0.3 | 0.10 | Influence radius. |

#### Peak Height Calculation

Each peak's height at any point is calculated as:

```gdscript
# Distance from peak center (normalized)
var dist = sqrt((nx - peak_x)² + (ny - peak_y)²)

# Only affects terrain within radius × 1.3
if dist < radius * 1.3:
    # Base elevation (falloff from center)
    var dist_factor = 1.0 - clamp(dist / radius, 0, 1)

    # Ridge enhancement (if use_ridged_noise)
    var ridge_boost = combined_ridge * ridge_influence * ridge_amplitude

    # Valley carving
    var valley_cut = valley_factor * ridge_influence * valley_cut_strength

    # Final height
    height = peak_height * (dist_factor² + ridge_boost - valley_cut) * erosion * noise_mod
```

---

## Configuration File Format

The terrain configuration is saved as a Godot Resource (`.tres`) file at `res://terrain/terrain_params.tres`. This file can be:

- Edited via the Terrain Parameters dock in the editor
- Edited directly in the Godot Inspector (select the .tres file)
- Version controlled with your project
- Duplicated to create presets

### Example terrain_params.tres

```gdscript
[gd_resource type="Resource" script_class="TerrainConfig" load_steps=2 format=3]

[ext_resource type="Script" path="res://src/terrain/terrain_config.gd" id="1"]

[resource]
script = ExtResource("1")
max_mountain_height = 350.0
max_hill_height = 120.0
ridge_amplitude = 0.3
ridge_frequency = 0.008
use_ridged_noise = true
# ... etc
```

---

## Generation Pipeline

When the game runs, terrain generation follows this pipeline:

1. **Load Config**: `TerrainGenerator._generate_heightmap()` checks for `res://terrain/terrain_params.tres`
2. **Island Mask**: `IslandShape.generate_mask()` creates the teardrop island shape
3. **Heightmap Generation**: `HeightmapGenerator.generate_heightmap()` produces height values using config
4. **Inlet Carving**: `HeightmapGenerator.carve_inlet()` creates the ship landing cove
5. **Texture Painting**: `TexturePainter.generate_control_map_for_import()` assigns textures based on height/slope
6. **Terrain3D Import**: Data is imported to Terrain3D using `import_images()`
7. **NavMesh Baking**: Navigation mesh is generated for pathfinding
8. **POI Placement**: Points of interest are placed and validated

---

## Troubleshooting

### Castle Wall Ridges

**Symptom**: Repetitive sawtooth ridges that look like castle battlements, especially around mountain peaks.

**Cause**: The ridged noise algorithm creates peaks wherever noise crosses zero. With periodic noise, these crossings are evenly spaced.

**Solutions**:
1. Reduce `ridge_amplitude` to 0.1-0.2
2. Set `use_ridged_noise` to false for smooth peaks
3. Increase `ridge_frequency` for finer, less noticeable ridges

### Terrain Too Flat

**Symptom**: Terrain lacks interesting features, appears boring.

**Solutions**:
1. Increase `max_mountain_height` and `max_hill_height`
2. Increase `ridge_amplitude` (but watch for castle walls)
3. Increase `coastal_cliff_strength` for dramatic coastlines
4. Decrease `midland_hill_smoothing` for rougher midlands

### Navigation Difficult

**Symptom**: Units get stuck, can't find paths through terrain.

**Solutions**:
1. Increase `midland_hill_smoothing` to 0.8-1.0
2. Set `midland_cliff_strength` to 0.0
3. Widen the midland corridor by adjusting `midland_start` and `flat_plains_start`

### Performance Issues

**Symptom**: Terrain generation is slow.

**Causes**: High `octaves` value, large terrain resolution.

**Solutions**:
1. Reduce `octaves` from 3 to 2
2. Terrain resolution is fixed at 4096x4096 for quality; generation time is expected

---

## API Reference

### TerrainConfig Resource

```gdscript
class_name TerrainConfig
extends Resource

# Get peak positions as array for HeightmapGenerator
func get_peak_positions() -> Array

# Save config to file
func save_to_file(path: String) -> Error

# Load config from file (static factory)
static func load_from_file(path: String) -> TerrainConfig

# Create default config
static func create_default() -> TerrainConfig

# Reset all values to defaults
func reset_to_defaults() -> void
```

### HeightmapGenerator

```gdscript
class_name HeightmapGenerator
extends RefCounted

# Generate heightmap with optional config
static func generate_heightmap(
	width_px: int,
	height_px: int,
	island_mask: Image,
	height_rng: RandomNumberGenerator,
	config: Resource = null  # TerrainConfig or null for defaults
) -> Image

# Carve inlet cove
static func carve_inlet(
	heightmap: Image,
	island_mask: Image,
	inlet_rng: RandomNumberGenerator
) -> Dictionary

# Get height statistics
static func get_height_stats(heightmap: Image) -> Dictionary
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-13 | Initial release with full parameter editor |

---

## Credits

- Terrain generation system designed for Polaris arctic survival RTS
- Uses Terrain3D addon for rendering (https://github.com/TokisanGames/Terrain3D)
- Noise algorithms based on FastNoiseLite
