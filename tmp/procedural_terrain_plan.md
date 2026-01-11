Claude’s Plan
Terrain Generation Bug Fixes
Current Issues
After implementing procedural terrain generation, the following bugs remain:
Island appears tiny (5%) in vast ice wasteland (95%) - Scale is inverted from design intent
NavMesh baking crash - "Source geometry is suspiciously big for current Cell Size"
String formatting errors - Using %s with Arrays from Dictionary.keys()
Root Cause Analysis
Issue 1: Island Scale Mismatch
The Problem: Terrain3D uses vertex_spacing = 1.0 by default, meaning each vertex (pixel in our heightmap) equals 1 meter. Our 1024x1024 heightmap creates a 1024m x 1024m terrain (~1km), but our code calculates world positions assuming 10 meters per pixel (10km terrain). Evidence:
Ship position calculated: (1020.0, 5.0, -4810.0) (~1km east, 4.8km north)
This position is OUTSIDE the 1km terrain that Terrain3D actually creates
The island mask is correctly filling ~95% of the heightmap image
But when rendered at 1m/vertex, the entire terrain is only 1km
Solution: Set vertex_spacing = 10.0 on the Terrain3D node. This will make each vertex represent 10 meters instead of 1 meter, scaling our 1024x1024 heightmap to ~10km x 10km. The vertex_spacing property is exposed on Terrain3D nodes and can be set via:
Scene file (world_map.tscn)
Runtime in terrain_generator.gd before importing
Issue 2: NavMesh Cell Size
The Problem: Cell size of 0.5m with a 10km terrain creates geometry that is "suspiciously big" for the cell size. Solution: Increase cell_size from 0.5 to 2.0 or higher to match the larger terrain scale.
Issue 3: String Formatting
The Problem: %s format specifier doesn't work directly with Arrays. Solution: Wrap array in str() or use %s % [array] syntax.
Fix Plan
Fix 1: Set Terrain3D vertex_spacing to 10.0
File: src/terrain/terrain_generator.gd Add before import_images() call (around line 240):

# Scale terrain to 10m per vertex (1024px = 10km)
_terrain.vertex_spacing = 10.0
This makes the existing code work correctly - all the constants (10m per pixel, 500m ice border, etc.) are already correct for a 10km terrain.
Fix 2: Rewrite NavMesh Baking to Use Terrain3D API
CRITICAL ISSUE: The current code uses _nav_region.bake_navigation_mesh(true) which does NOT work with Terrain3D. The Terrain3D documentation explicitly states:
"the standard Bake NavMesh button that NavigationRegion3D provides will not generate a nav mesh for Terrain3D."
File: src/terrain/terrain_generator.gd Rewrite _bake_navigation_mesh() to use Terrain3D's proper baking method:

func _bake_navigation_mesh() -> void:
	if not _nav_region or not _terrain:
		push_warning("[TerrainGenerator] No NavigationRegion3D or Terrain3D - skipping NavMesh bake")
		return

	print("[TerrainGenerator] Starting NavMesh bake...")
	var start_time := Time.get_ticks_msec()

	# Get or create NavigationMesh
	var nav_mesh: NavigationMesh = _nav_region.navigation_mesh
	if not nav_mesh:
		nav_mesh = NavigationMesh.new()

	# Configure baking area (only island, not infinite ice)
	var half_size := TERRAIN_RESOLUTION * METERS_PER_PIXEL / 2.0
	nav_mesh.filter_baking_aabb = AABB(
		Vector3(-half_size - 500, -50, -half_size - 500),
		Vector3(half_size * 2 + 1000, 500, half_size * 2 + 1000)
	)

	# Agent settings
	nav_mesh.agent_radius = 0.5
	nav_mesh.agent_height = 1.8
	nav_mesh.agent_max_climb = 0.4
	nav_mesh.agent_max_slope = 40.0

	# Cell settings - larger for big terrain
	nav_mesh.cell_size = 2.0
	nav_mesh.cell_height = 0.5

	# Apply to region
	_nav_region.navigation_mesh = nav_mesh

	# Create source geometry data
	var source_geometry := NavigationMeshSourceGeometryData3D.new()

	# Parse existing scene geometry first
	NavigationServer3D.parse_source_geometry_data(nav_mesh, source_geometry, _nav_region)

	# Get terrain geometry using Terrain3D's method
    var aabb: AABB = nav_mesh.filter_baking_aabb
    aabb.position += nav_mesh.filter_baking_aabb_offset
    aabb = _nav_region.global_transform * aabb

    var faces: PackedVector3Array = _terrain.generate_nav_mesh_source_geometry(aabb)
    if not faces.is_empty():
        source_geometry.add_faces(faces, Transform3D.IDENTITY)
        print("[TerrainGenerator] Added %d terrain faces to source geometry" % (faces.size() / 3))
    else:
        push_warning("[TerrainGenerator] No terrain faces generated!")

    # Bake the navmesh
    NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)

    # Force navigation region to update
    _nav_region.set_navigation_mesh(null)
    _nav_region.set_navigation_mesh(nav_mesh)

    var total_time := (Time.get_ticks_msec() - start_time) / 1000.0
    print("[TerrainGenerator] NavMesh bake completed in %.1f seconds" % total_time)
Key changes:
Uses _terrain.generate_nav_mesh_source_geometry(aabb) instead of generic bake_navigation_mesh()
Manually bakes using NavigationServer3D.bake_from_source_geometry_data()
Increases cell_size to 2.0 and cell_height to 0.5 for the larger terrain
This is the same approach used by Terrain3D's built-in baker.gd
Fix 3: String Formatting
File: src/game_manager.gd line 120:

# OLD
print("[GameManager] POI locations set: %s" % poi_locations.keys())
# NEW
print("[GameManager] POI locations set: %s" % str(poi_locations.keys()))
File: ui/debug_menu.gd line 229:

# OLD
print("[DebugMenu] POIs received: %s" % pois.keys())
# NEW
print("[DebugMenu] POIs received: %s" % str(pois.keys()))
Implementation Order
Fix string formatting errors (quick, independent)
Set _terrain.vertex_spacing = 10.0 in _import_to_terrain() function
Rewrite _bake_navigation_mesh() to use Terrain3D's API (major rewrite)
Test generation
Files to Modify
File	Line/Function	Changes
src/game_manager.gd	line 120	Fix string format: str(poi_locations.keys())
ui/debug_menu.gd	line 229	Fix string format: str(pois.keys())
src/terrain/terrain_generator.gd	_import_to_terrain() after line 228	Add _terrain.vertex_spacing = 10.0
src/terrain/terrain_generator.gd	_bake_navigation_mesh() lines 288-344	Complete rewrite using Terrain3D API
Expected Results After Fix
With vertex_spacing = 10.0:
Terrain dimensions: 1024 vertices × 10m = 10,240m (~10km)
Ship position (1020, 5, -4810) will be INSIDE the terrain (was outside the 1km default)
Island will fill ~95% of visible terrain
Ice border will be only ~500m at edges (5% of terrain)
Captain will spawn on the island, not in the ice wasteland
With proper Terrain3D NavMesh baking:
NavMesh will include actual terrain geometry (was empty before)
No "suspiciously big" error (correct cell size for terrain scale)
POI validation will work (pathfinding possible on baked navmesh)
Original Implementation Plan (Reference)
Phase 0: Documentation (BEFORE IMPLEMENTATION)
Step 1: Update GameDesignDocument.md
Add comprehensive procedural terrain section under "World" covering:
Island geography and shape (teardrop, dimensions)
Historical narrative (ship trapped in inlet, Franklin expedition context)
Boundary system (deadly ice N/E/W, water S)
POI placement rules
Terrain features and textures
Seed system for sharing islands
Step 2: Update Root CLAUDE.md
Add brief overview in Architecture section:
New src/terrain/ directory purpose
Link to terrain/CLAUDE.md for details
Integration points with existing systems
Step 3: Create terrain/CLAUDE.md (Comprehensive Implementation Guide)
This is the PRIMARY documentation - verbose enough for a Claude agent to follow:
Complete system architecture
All files with purposes and key functions
Generation pipeline step-by-step
Algorithm details with code examples
Terrain3D API usage patterns
NavMesh baking procedures
Error handling and fallbacks
Performance considerations
Testing strategies
Island Geography Specification
Shape & Size
Dimensions: ~12km (N-S) x 9km (E-W), teardrop shape
Orientation: Narrow end north, wide end south (like King William Island)
Ship Start: Generated inlet on north coast (east or west side, random)
Southern Shore: Gentle downhill slope, favorable for sled travel
Boundary System (No Artificial Walls)
Direction	Boundary Type	Conditions
North/East/West	Endless flat ice	-60°C, max blizzard, no resources, no NavMesh (traversable but deadly)
South	Water	Impassable, visual only
Key Locations (Procedurally Placed)
POI	Count	Placement Rules
Ship Wreck	1	In generated inlet, north coast
HBC Whaling Station	1	South coast, 8-10km from ship (~8 weeks travel)
Inuit Village	1-2	2-4km from ship (1-2 days travel), on flat terrain
Terrain Features
Cliffs, ice cliffs, beaches, inlets, minor fjords
Hills, slopes, many flat plains
Lower mountains (under 400m for this island)
Rocky outcrops
Textures (5 Core)
ID	Texture	Usage
0	snow_01	Default, high elevation
1	rock_dark_01	Steep slopes (>35°), cliff faces
2	ice01	Sea level edges, surrounding ice
3	gravel01	Low elevation, transitions
4	beach_sand	Southern beaches (needs asset)
Implementation Architecture
New Files to Create

src/terrain/
├── terrain_generator.gd    # Main orchestrator
├── island_shape.gd         # Teardrop mask generation
├── heightmap_generator.gd  # Multi-octave noise + features
├── texture_painter.gd      # Height/slope-based painting
├── poi_placer.gd           # POI placement with validation
├── seed_manager.gd         # Seed handling and UI
└── CLAUDE.md               # Subsystem documentation
Files to Modify
main_controller.gd - Add terrain generation hook
game_manager.gd - Seed persistence, POI storage
character_spawner.gd - Use ship position as spawn center
GameDesignDocument.md - Add procedural terrain section
Generation Pipeline

1. Seed Setup        → Initialize RNG from seed
2. Island Shape      → Generate teardrop mask (1024x1024)
3. Heightmap         → Multi-octave noise with features
4. Inlet Carving     → Create ship spawn inlet on north coast
5. Terrain Import    → Apply heightmap to Terrain3D
6. Texture Painting  → Height/slope-based texture assignment
7. NavMesh Bake      → Full island bake (30-60 seconds)
8. POI Placement     → Place HBC, Inuit villages with distance rules
9. Validation        → Verify POI pathfinding accessibility
Estimated Total Time: 45-90 seconds (loading screen with progress bar)
Key Algorithms
1. Teardrop Island Shape

# Ellipse + teardrop distortion + coastal noise
var teardrop_factor := 1.0 + 0.4 * ny  # Widens towards south
nx *= teardrop_factor
var dist := sqrt(nx * nx + ny * ny)
var mask := smoothstep(1.2, 0.7, dist)
2. Heightmap Generation
Base layer: Simplex noise (rolling hills, 0-50m)
Mountain layer: Masked to center (peaks up to 400m)
Southern bias: Reduce height towards south (easier travel)
Detail layer: High-frequency noise for micro-terrain
3. Inlet Generation
Random choice: east or west of north coast
Carve ~800m diameter inlet
Lower terrain to near sea level for ship placement
4. Texture Painting Rules
Height < 5m: Gravel/ice (beach zone)
Height 5-15m: Gravel transition
Slope > 35°: Rock (cliffs)
Slope > 25°: Rock/snow blend
Default: Snow
5. POI Placement
HBC Station: South coast, 8-10km from ship, elevation 2-20m
Inuit Villages: 2-4km from ship, elevation 5-100m, min 1.5km apart
Validation: Pathfind from ship to each POI after NavMesh bake
Seed System
Features
Visible on game start screen
Shareable as hex string (e.g., "A3F7BC12")
Player can enter seed for specific islands
Saved in save files for recreation
Sub-RNGs (ensure reproducibility)

shape_rng.seed = seed ^ 0x12345678
height_rng.seed = seed ^ 0x87654321
texture_rng.seed = seed ^ 0xABCDEF01
poi_rng.seed = seed ^ 0xFEDCBA98
NavMesh Strategy
Bake Area: Only island (AABB excludes infinite ice)
Agent Settings: radius 0.5m, height 1.8m, max_slope 40°
Cell Size: 0.5m (balance of precision vs bake time)
Threading: Bake in background thread
Infinite Ice: No NavMesh = units can't pathfind there (but can try to walk)
Integration Points
MainController

func _ready():
	if GameManager.is_new_game:
		await _generate_terrain()
	_spawn_survivors_at_ship()
GameManager
Store seed_manager and poi_locations
Persist seed in save files
Emit poi_locations_set signal for minimap
CharacterSpawner

func spawn_survivors_at_ship():
	var ship_pos = GameManager.poi_locations.get("ship")
	spawn_survivors(count, ship_pos)
Performance Budget
Stage	Time
Shape + Height	3-6s
Terrain Import	5-10s
Texture Painting	10-20s
NavMesh Bake	30-60s
POI Placement	<1s
Total	45-90s
Error Handling
If generation fails, load fallback hand-crafted terrain
If POI unreachable, regenerate with different seed
If NavMesh times out (>2min), warn but continue
Visual Only (MVP Deferred)
Icebergs: distant visual props, no collision
Sea ice: static visual, no gameplay impact
Dynamic weather: handled by existing snow_controller
GDD Section to Add
Add to GameDesignDocument.md under World section:
Procedural Terrain Generation
Island Shape: Teardrop-shaped island based on King William Island. ~12km north-south, ~9km east-west. Narrow end north (ship start), wide end south (rescue destination). Boundaries:
North/East/West: Endless arctic ice. Traversable but deadly (-60°C, permanent blizzard, zero resources). No artificial barriers - players can walk to their doom.
South: Ocean water (impassable)
Starting Position: Ship trapped in procedurally generated inlet on north coast (random east or west). The inlet represents where the ship mistakenly sailed in thinking it led to open water before the deep freeze caught them. Key Locations:
1 Hudson's Bay Company whaling station on south coast (~8 weeks travel)
1-2 Inuit villages within 1-2 days travel of ship
Various procedural hunting zones, resource caches
Terrain Features:
Cliffs, ice cliffs, beaches, inlets, fjords
Hills, slopes, flat plains (most common)
Mountains under 400m elevation
Southern portion has gentler downhill slope for easier travel
Generation Seed: Visible and shareable. Players can replay specific island configurations or share challenging seeds.
Implementation Order
Phase 0: Documentation (FIRST - Required before any code)
Update GameDesignDocument.md with procedural terrain section
Update root CLAUDE.md with terrain system overview
Create src/terrain/CLAUDE.md with comprehensive implementation guide
Phase 1: Core Generation
Create src/terrain/seed_manager.gd
Create src/terrain/island_shape.gd
Create src/terrain/heightmap_generator.gd
Phase 2: Terrain3D Integration
Create src/terrain/texture_painter.gd
Create src/terrain/terrain_generator.gd (orchestrator)
Phase 3: NavMesh + POI
Create src/terrain/poi_placer.gd
Implement NavMesh baking and POI validation
Phase 4: System Integration
Modify src/main_controller.gd - generation hook
Modify src/game_manager.gd - seed/POI persistence
Modify src/systems/character_spawner.gd - use ship position
Phase 5: UI + Polish
Add seed display/input to new game UI
Add loading screen with progress bar
Error handling and fallback terrain
Critical Files Summary
File	Purpose
src/terrain/terrain_generator.gd	Main entry point, pipeline orchestration
src/terrain/heightmap_generator.gd	Noise-based height generation
src/terrain/poi_placer.gd	POI placement with pathfinding validation
src/main_controller.gd	Hook for generation on new game
src/game_manager.gd	Seed and POI persistence
GameDesignDocument.md	Add procedural terrain section
Documentation Content Specifications
A. GameDesignDocument.md - Procedural Terrain Section
Add after the existing "Map" section under "World":

### Procedural Island Generation

#### Historical Context
The game is set on a fictionalized King William Island, September 1846. The ship became trapped in an inlet on the northern part of the island near Victory Point. The crew mistakenly sailed in thinking it led to open water. A subsequent quick deep freeze caught them off guard, freezing the ship in place. There is no hope of cutting their way out. They settle in for winter, but ice shifts and crushes the boat irreparably. The ship remains usable as makeshift shelter (not enough for the whole crew), and half their supplies are lost.

#### Island Shape & Dimensions
- **Shape**: Teardrop, narrow end north, wide end south
- **Size**: ~12km (N-S) × ~9km (E-W), approximately 100 km²
- **Starting Position**: Ship trapped in procedurally generated inlet on north coast (random east or west side)

#### Boundaries (No Artificial Walls)

| Direction | Boundary Type | Conditions |
|-----------|---------------|------------|
| North | Endless arctic ice | -60°C, permanent blizzard, total darkness, zero resources, no Inuit, certain death |
| East | Endless arctic ice | Same as North |
| West | Endless arctic ice | Same as North |
| South | Ocean water | Impassable (visual only) |

The ice zones are fully traversable - no invisible walls or force fields. Players can walk north to their doom if they choose. This maintains realism while naturally constraining gameplay.

#### Terrain Features
- **Cliffs & Ice Cliffs**: Rocky and ice faces, creates natural barriers
- **Beaches**: Low elevation coastal areas, primarily on south shore
- **Inlets & Minor Fjords**: Water intrusions into coastline
- **Hills & Slopes**: Rolling terrain throughout
- **Flat Plains**: Common, especially in central and southern regions
- **Mountains**: Lower peaks under 400m, concentrated in central areas

#### Regional Characteristics

| Region | Characteristics |
|--------|-----------------|
| Northern (ship start) | Narrow, rugged, inlet features, higher elevation |
| Central | Mixed terrain, mountains, hills, some flat areas |
| Southern | Wide, gentle downhill slope, favorable for sled travel, beaches |

#### Points of Interest

| POI | Count | Placement | Purpose |
|-----|-------|-----------|---------|
| Ship Wreck | 1 | Generated inlet, north coast | Starting location, partial shelter |
| HBC Whaling Station | 1 | South coast, ~8-10km from ship | Rescue destination (~8 weeks travel) |
| Inuit Village | 1-2 | 2-4km from ship, accessible terrain | Trading, information, survival aid |

**Travel Distances**: At ~1km per week (accounting for blizzards, animal attacks, hunting stops, medical care, etc.), reaching the HBC station takes approximately 8 weeks of dedicated travel.

#### Terrain Textures

| Texture | Location | Notes |
|---------|----------|-------|
| Snow | Default, high elevation | Primary surface |
| Rock | Steep slopes (>35°), cliff faces | Exposed rock |
| Ice | Sea level edges, frozen water | Slippery, cold |
| Gravel | Low elevation, transitions | Beaches, paths |
| Beach Sand | Southern beaches | Limited areas |

#### Seed System
- Each island is generated from a numeric seed
- Seed is visible on game start and in menus
- Players can enter specific seeds to replay islands
- Seeds can be shared between players
- Same seed always generates identical terrain

#### Procedural Elements
- Island coastline shape (within teardrop constraints)
- Mountain and hill placement
- Inlet location and shape
- POI exact positions (within distance rules)
- Texture variation patterns
B. Root CLAUDE.md - Brief Overview Addition
Add to the "Project Structure" section after existing directories:

│   ├── terrain/                  # Procedural terrain generation
│   │   ├── terrain_generator.gd  # Main orchestrator, generation pipeline
│   │   ├── island_shape.gd       # Teardrop island mask generation
│   │   ├── heightmap_generator.gd# Multi-octave noise heightmaps
│   │   ├── texture_painter.gd    # Height/slope-based texture assignment
│   │   ├── poi_placer.gd         # POI placement with validation
│   │   ├── seed_manager.gd       # Seed handling and persistence
│   │   └── CLAUDE.md             # Comprehensive implementation guide
Add to the "Key Addons" table:

| **Terrain3D** | Large terrain with LOD, procedural support | `TerrainGenerator` uses Terrain3D API for heightmap import, texture painting |
Add to "Subsystem Documentation" list:

- [Terrain Generation](src/terrain/CLAUDE.md) - Procedural island generation, Terrain3D integration
C. src/terrain/CLAUDE.md - Comprehensive Implementation Guide
This is the PRIMARY documentation file. Create with the following structure:

# Terrain Generation System

## Overview

The terrain generation system creates unique procedurally-generated arctic islands for each survival run. It uses Terrain3D's API for heightmap import, texture painting, and NavMesh baking.

## Files

| File | Purpose | Key Functions |
|------|---------|---------------|
| `terrain_generator.gd` | Main orchestrator | `generate(seed_manager)`, signals for progress |
| `island_shape.gd` | Teardrop mask | `generate_mask(width, height, rng)` |
| `heightmap_generator.gd` | Height generation | `generate_heightmap()`, `generate_inlet()` |
| `texture_painter.gd` | Texture assignment | `paint_terrain(terrain_data, heightmap, mask, rng)` |
| `poi_placer.gd` | POI placement | `place_pois()`, `validate_poi_accessibility()` |
| `seed_manager.gd` | Seed management | `set_seed()`, `get_seed_string()`, sub-RNGs |

## Generation Pipeline

### Stage 1: Seed Setup
```gdscript
var seed_manager := SeedManager.new()
seed_manager.set_seed(user_seed)  # Or generate_random_seed()
The seed_manager provides separate RNGs for each generation phase to ensure reproducibility:
get_shape_rng() - Island shape generation
get_height_rng() - Heightmap noise
get_texture_rng() - Texture variation
get_poi_rng() - POI placement
Stage 2: Island Shape Mask
Generate a 1024x1024 grayscale image where:
1.0 = center of island
0.0 = outside island (ice zone)
Gradient = coastline transition
Algorithm:
Calculate teardrop shape using ellipse + distortion
Apply coastal noise for natural coastline
Smooth falloff at edges

# Teardrop distortion: narrow at north, wide at south
var teardrop_factor := 1.0 + 0.4 * normalized_y
normalized_x *= teardrop_factor

# Distance from center (ellipse)
var dist := sqrt(nx * nx + ny * ny)

# Smooth falloff
var mask := smoothstep(1.2, 0.7, dist)
Stage 3: Heightmap Generation
Generate terrain heights using multi-octave noise: Noise Layers:
Base terrain (Simplex FBM): Rolling hills, 0-50m amplitude
Mountain layer (Simplex): Peaks up to 400m, masked to island center
Detail layer (High-frequency): Micro-terrain variation
Special Modifications:
Southern slope bias: Reduce height towards south for easier travel
Edge falloff: Blend to ice level at island edges
Inlet carving: Create ship spawn location

# Southern bias for easier travel
var south_bias := (1.0 - normalized_y) * 0.3
height *= (1.0 - south_bias)
Stage 4: Inlet Generation
Carve an inlet on the north coast for the ship:
Random choice: east or west side
Position: ~15% from top of map
Radius: ~800m diameter
Depth: Lower terrain to near sea level
Returns Dictionary with:
position: Vector3 world position of inlet center
east_side: bool indicating which side
Stage 5: Terrain3D Import
Apply heightmap to Terrain3D:

# Clear existing regions
for region in _terrain.data.get_regions_active():
	_terrain.data.remove_region(region, false)

# Import heightmap
var images: Array[Image] = [heightmap, null, null]  # Height, Control, Color
_terrain.data.import_images(images, Vector3.ZERO, 0.0, 1.0)
_terrain.data.calc_height_range(true)
Stage 6: Texture Painting
Assign textures based on height and slope: Texture IDs:
0: Snow (default)
1: Rock (cliffs)
2: Ice (sea level, surrounding)
3: Gravel (beaches, transitions)
4: Beach sand (if available)
Rules:
Height	Slope	Texture
< 5m	any	Gravel/Ice
5-15m	> 25°	Gravel
any	> 35°	Rock
> 50m	< 25°	Snow
default	default	Snow

terrain_data.set_control_base_id(world_pos, texture_id)
terrain_data.set_control_blend(world_pos, blend_amount)
Stage 7: NavMesh Baking
Bake navigation mesh for pathfinding: Critical Settings:
Bake AABB: Only island area (excludes infinite ice)
Agent radius: 0.5m
Agent height: 1.8m
Agent max slope: 40°
Cell size: 0.5m
Performance:
Estimated time: 30-60 seconds for 10km terrain
Run in background thread to avoid freezing
Show progress to player

# Configure baking area (only island, not ice)
nav_mesh.filter_baking_aabb = AABB(
	Vector3(-6000, -100, -6500),
	Vector3(12000, 600, 13000)
)

# Get terrain geometry
var terrain_faces := _terrain.generate_nav_mesh_source_geometry(aabb)
source_geometry.add_faces(terrain_faces, Transform3D.IDENTITY)

# Bake
NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)
Stage 8: POI Placement
Place key locations with distance constraints: HBC Whaling Station:
Location: South coast (80-95% Y position)
Distance: 8-10km from ship
Elevation: 2-20m (near sea level, coastal)
Must be on island (mask > 0.3)
Inuit Villages (1-2):
Distance: 2-4km from ship
Elevation: 5-100m
Minimum 1.5km apart from each other
Must be on island (mask > 0.5)
Stage 9: POI Validation
After NavMesh bake, verify all POIs are reachable from ship:

var path := NavigationServer3D.map_get_path(nav_map, ship_pos, poi_pos, true)
if path.size() == 0:
	push_warning("POI unreachable!")
	# Consider regeneration or fallback
Terrain3D API Reference
Height Operations

terrain.data.set_height(position, height)  # Set height at world position
terrain.data.get_height(position)           # Query height (with interpolation)
terrain.data.import_images(images, offset, rotation, scale)
terrain.data.calc_height_range(update_mesh)
Texture Operations

terrain.data.set_control_base_id(position, id)   # Set base texture (0-31)
terrain.data.set_control_overlay_id(position, id) # Set overlay texture
terrain.data.set_control_blend(position, blend)  # Blend amount (0.0-1.0)
terrain.data.set_control_angle(position, step)   # UV rotation (0-7 = 22.5° steps)
terrain.data.set_control_scale(position, scale)  # UV scale (-60% to +80%)
Region Management

terrain.data.get_regions_active()  # Get active region positions
terrain.data.remove_region(position, update)
terrain.data.update_maps()  # Apply changes
Integration Points
MainController

func _ready():
	if GameManager.is_new_game:
		var generator := TerrainGenerator.new()
		add_child(generator)
		generator.generation_completed.connect(_on_terrain_ready)
		await generator.generate(GameManager.seed_manager)
GameManager

var seed_manager: SeedManager
var poi_locations: Dictionary = {}

func start_new_game(seed: int = 0):
	is_new_game = true
	if seed == 0:
		seed_manager.generate_random_seed()
	else:
		seed_manager.set_seed(seed)
CharacterSpawner

func spawn_survivors_at_ship():
	var ship_pos := GameManager.poi_locations.get("ship", Vector3.ZERO)
	spawn_survivors(count, ship_pos)
Error Handling
Generation Failures
If terrain generation fails:
Log detailed error
Load fallback hand-crafted terrain (terrain/world_map.tscn)
Set default POI positions
Unreachable POIs
If pathfinding validation fails:
Attempt repositioning within constraints
If repeated failures, regenerate with different seed
Log warning if fallback used
NavMesh Timeout
If baking exceeds 2 minutes:
Log warning
Continue with partial mesh
POIs may be unreachable - warn player
Performance Considerations
Generation Time Budget
Stage	Time	Notes
Shape + Height	3-6s	CPU-bound noise generation
Terrain Import	5-10s	Terrain3D processing
Texture Painting	10-20s	Per-pixel control map updates
NavMesh Bake	30-60s	Main bottleneck
POI Placement	<1s	Sampling + validation
Total	45-90s	Show loading screen
Memory Usage
Heightmap Image (1024x1024, FORMAT_RF): ~4MB
Island mask Image: ~4MB
NavMesh data: ~10-50MB
Peak during generation: ~60-100MB
Optimization Strategies
Threaded NavMesh: Run baking in background thread
Chunked painting: Process texture painting in batches with await
Progress signals: Keep UI responsive with stage updates
Testing
Unit Tests
Same seed produces identical mask/heightmap
Height values within expected ranges
Texture assignment rules correct
Integration Tests
POIs reachable from ship via pathfinding
Height queries return valid values
NavMesh covers island area
Visual Tests
Generated terrain looks like teardrop island
Textures assigned appropriately
No obvious artifacts at region boundaries
Common Issues
"Terrain3D not found"
Ensure NavigationRegion3D → Terrain3D hierarchy
Check "terrain" group assignment
NavMesh not covering terrain
Verify baking AABB includes island
Check agent settings match terrain steepness
POIs spawning in water/ice
Mask threshold too low
Increase minimum elevation check
Textures not painting
Call terrain.data.update_maps() after painting
Verify texture slots are configured


---

This documentation structure ensures:
1. **GDD** has complete design specification for procedural terrain
2. **Root CLAUDE.md** provides quick reference and links
3. **terrain/CLAUDE.md** is comprehensive enough for any Claude agent to implement the system from scratch


Terrain Generation - DEFINITIVE FIX
ROOT CAUSE (Confirmed)
import_images() does NOT create regions - it only imports into EXISTING regions. Our code cleared all regions, then called import_images() which silently did nothing.
THE SOLUTION: Use add_region_blankp() to Create Regions at Runtime
Terrain3D HAS a runtime region creation API!

# Create a blank region at any world position
var region: Terrain3DRegion = terrain.data.add_region_blankp(Vector3(x, 0, z), false)
This is exactly what we need for true procedural generation.
IMPLEMENTATION PLAN
Step 1: Rewrite _import_to_terrain() Completely
File: src/terrain/terrain_generator.gd

func _import_to_terrain() -> bool:
	print("[TerrainGenerator] Creating terrain regions and importing heights...")

	if not _terrain or not "data" in _terrain:
		push_error("[TerrainGenerator] No Terrain3D!")
		return false

	var terrain_data = _terrain.data
	if not terrain_data:
		push_error("[TerrainGenerator] No terrain data!")
		return false

	# Clear data_directory to start fresh (no disk-loaded regions)
	if "data_directory" in _terrain:
		_terrain.data_directory = ""

	# Re-fetch terrain_data after clearing (may have been recreated)
	terrain_data = _terrain.data
	if not terrain_data:
		push_error("[TerrainGenerator] Terrain data null after clearing!")
		return false

	# Remove any existing regions
	if terrain_data.has_method("get_regions_active"):
		for region in terrain_data.get_regions_active():
			terrain_data.remove_region(region, false)

	# Set vertex spacing BEFORE creating regions
	_terrain.vertex_spacing = METERS_PER_PIXEL  # 10.0
	print("[TerrainGenerator] Set vertex_spacing to %.1f" % METERS_PER_PIXEL)

	# Re-fetch terrain_data after changing vertex_spacing
	terrain_data = _terrain.data

	# Calculate terrain bounds
	var terrain_size := TERRAIN_RESOLUTION * METERS_PER_PIXEL  # 1024 * 10 = 10240m
	var half_size := terrain_size / 2.0  # 5120m

	# Get region size (default is 1024 vertices, so 1024 * vertex_spacing meters)
	var region_size_vertices: int = 1024
	if _terrain.has_method("get_region_size"):
		region_size_vertices = _terrain.get_region_size()
	var region_size_meters: float = region_size_vertices * METERS_PER_PIXEL

	print("[TerrainGenerator] Region size: %d vertices = %.0fm" % [region_size_vertices, region_size_meters])

	# Create blank regions to cover the entire terrain
	# We need regions from -half_size to +half_size on both X and Z
	var regions_created := 0
	var step := region_size_meters
	var z := -half_size
	while z < half_size:
		var x := -half_size
		while x < half_size:
			var world_pos := Vector3(x + step/2, 0, z + step/2)  # Center of region
			if terrain_data.has_method("add_region_blankp"):
				terrain_data.add_region_blankp(world_pos, false)
				regions_created += 1
			x += step
		z += step

	print("[TerrainGenerator] Created %d blank regions" % regions_created)

	# Verify regions were created
	var region_count: int = terrain_data.get_region_count() if terrain_data.has_method("get_region_count") else 0
	print("[TerrainGenerator] Region count after creation: %d" % region_count)
	if region_count == 0:
		push_error("[TerrainGenerator] Failed to create regions!")
		return false

	# Now set height values from our procedural heightmap
	print("[TerrainGenerator] Applying heightmap data...")
	var width := _heightmap.get_width()
	var height := _heightmap.get_height()
	var half_width := float(width) / 2.0
	var half_height := float(height) / 2.0

	for py in range(height):
		for px in range(width):
			var h: float = _heightmap.get_pixel(px, py).r
			var world_x := (float(px) - half_width) * METERS_PER_PIXEL
			var world_z := (float(py) - half_height) * METERS_PER_PIXEL
			terrain_data.set_height(Vector3(world_x, 0, world_z), h)

		# Progress update every 64 rows
		if py % 64 == 0:
			await get_tree().process_frame
			generation_progress.emit("Applying heights...", 0.35 + 0.15 * (float(py) / float(height)))

	# Finalize terrain
	if terrain_data.has_method("update_maps"):
		terrain_data.update_maps()
	if terrain_data.has_method("calc_height_range"):
		terrain_data.calc_height_range(true)

	# Update collider for physics
	if _terrain.has_method("update_collider"):
		_terrain.update_collider()

	print("[TerrainGenerator] Terrain import complete!")
	return true
Step 2: Fix NavMesh Cell Size
The NavMesh still fails with "suspiciously big" error. Increase cell size significantly:

# In _bake_navigation_mesh():
nav_mesh.cell_size = 4.0   # Was 2.0 - increase for 10km terrain
nav_mesh.cell_height = 1.0  # Was 0.5
Step 3: Verify Height Queries Work
After terrain creation, verify with test queries:

# In _verify_terrain_import():
var test_positions := [
	Vector3(0, 0, 0),           # Center
	Vector3(1000, 0, 1000),     # NE quadrant
	Vector3(-1000, 0, -1000),   # SW quadrant
]
for pos in test_positions:
	var h := terrain_data.get_height(pos)
	print("[TerrainGenerator] Height at %s: %.2f" % [pos, h])
KEY API METHODS DISCOVERED
Method	Purpose
add_region_blankp(Vector3, bool)	Create blank region at world position
add_region_blank(Vector2i, bool)	Create blank region at grid coordinates
set_height(Vector3, float)	Set height at world position
update_maps()	Regenerate terrain textures
calc_height_range(bool)	Recalculate min/max heights
update_collider()	Regenerate physics collision
FILES TO MODIFY
File	Changes
src/terrain/terrain_generator.gd	Complete rewrite of _import_to_terrain() using add_region_blankp() + set_height()
src/terrain/terrain_generator.gd	Increase NavMesh cell_size to 4.0
EXPECTED OUTCOME
Regions created at runtime covering 10km x 10km
Procedural heightmap applied via set_height() calls
Terrain displays actual hills/valleys (not flat)
get_height() returns valid values (not NaN)
NavMesh bakes successfully with terrain geometry
Captain spawns on ground at correct position
Original Implementation Plan (Reference)
Phase 0: Documentation (BEFORE IMPLEMENTATION)
Step 1: Update GameDesignDocument.md
Add comprehensive procedural terrain section under "World" covering:
Island geography and shape (teardrop, dimensions)
Historical narrative (ship trapped in inlet, Franklin expedition context)
Boundary system (deadly ice N/E/W, water S)
POI placement rules
Terrain features and textures
Seed system for sharing islands
Step 2: Update Root CLAUDE.md
Add brief overview in Architecture section:
New src/terrain/ directory purpose
Link to terrain/CLAUDE.md for details
Integration points with existing systems
Step 3: Create terrain/CLAUDE.md (Comprehensive Implementation Guide)
This is the PRIMARY documentation - verbose enough for a Claude agent to follow:
Complete system architecture
All files with purposes and key functions
Generation pipeline step-by-step
Algorithm details with code examples
Terrain3D API usage patterns
NavMesh baking procedures
Error handling and fallbacks
Performance considerations
Testing strategies
Island Geography Specification
Shape & Size
Dimensions: ~12km (N-S) x 9km (E-W), teardrop shape
Orientation: Narrow end north, wide end south (like King William Island)
Ship Start: Generated inlet on north coast (east or west side, random)
Southern Shore: Gentle downhill slope, favorable for sled travel
Boundary System (No Artificial Walls)
Direction	Boundary Type	Conditions
North/East/West	Endless flat ice	-60°C, max blizzard, no resources, no NavMesh (traversable but deadly)
South	Water	Impassable, visual only
Key Locations (Procedurally Placed)
POI	Count	Placement Rules
Ship Wreck	1	In generated inlet, north coast
HBC Whaling Station	1	South coast, 8-10km from ship (~8 weeks travel)
Inuit Village	1-2	2-4km from ship (1-2 days travel), on flat terrain
Terrain Features
Cliffs, ice cliffs, beaches, inlets, minor fjords
Hills, slopes, many flat plains
Lower mountains (under 400m for this island)
Rocky outcrops
Textures (5 Core)
ID	Texture	Usage
0	snow_01	Default, high elevation
1	rock_dark_01	Steep slopes (>35°), cliff faces
2	ice01	Sea level edges, surrounding ice
3	gravel01	Low elevation, transitions
4	beach_sand	Southern beaches (needs asset)
Implementation Architecture
New Files to Create

src/terrain/
├── terrain_generator.gd    # Main orchestrator
├── island_shape.gd         # Teardrop mask generation
├── heightmap_generator.gd  # Multi-octave noise + features
├── texture_painter.gd      # Height/slope-based painting
├── poi_placer.gd           # POI placement with validation
├── seed_manager.gd         # Seed handling and UI
└── CLAUDE.md               # Subsystem documentation
Files to Modify
main_controller.gd - Add terrain generation hook
game_manager.gd - Seed persistence, POI storage
character_spawner.gd - Use ship position as spawn center
GameDesignDocument.md - Add procedural terrain section
Generation Pipeline

1. Seed Setup        → Initialize RNG from seed
2. Island Shape      → Generate teardrop mask (1024x1024)
3. Heightmap         → Multi-octave noise with features
4. Inlet Carving     → Create ship spawn inlet on north coast
5. Terrain Import    → Apply heightmap to Terrain3D
6. Texture Painting  → Height/slope-based texture assignment
7. NavMesh Bake      → Full island bake (30-60 seconds)
8. POI Placement     → Place HBC, Inuit villages with distance rules
9. Validation        → Verify POI pathfinding accessibility
Estimated Total Time: 45-90 seconds (loading screen with progress bar)
Key Algorithms
1. Teardrop Island Shape

# Ellipse + teardrop distortion + coastal noise
var teardrop_factor := 1.0 + 0.4 * ny  # Widens towards south
nx *= teardrop_factor
var dist := sqrt(nx * nx + ny * ny)
var mask := smoothstep(1.2, 0.7, dist)
2. Heightmap Generation
Base layer: Simplex noise (rolling hills, 0-50m)
Mountain layer: Masked to center (peaks up to 400m)
Southern bias: Reduce height towards south (easier travel)
Detail layer: High-frequency noise for micro-terrain
3. Inlet Generation
Random choice: east or west of north coast
Carve ~800m diameter inlet
Lower terrain to near sea level for ship placement
4. Texture Painting Rules
Height < 5m: Gravel/ice (beach zone)
Height 5-15m: Gravel transition
Slope > 35°: Rock (cliffs)
Slope > 25°: Rock/snow blend
Default: Snow
5. POI Placement
HBC Station: South coast, 8-10km from ship, elevation 2-20m
Inuit Villages: 2-4km from ship, elevation 5-100m, min 1.5km apart
Validation: Pathfind from ship to each POI after NavMesh bake
Seed System
Features
Visible on game start screen
Shareable as hex string (e.g., "A3F7BC12")
Player can enter seed for specific islands
Saved in save files for recreation
Sub-RNGs (ensure reproducibility)

shape_rng.seed = seed ^ 0x12345678
height_rng.seed = seed ^ 0x87654321
texture_rng.seed = seed ^ 0xABCDEF01
poi_rng.seed = seed ^ 0xFEDCBA98
NavMesh Strategy
Bake Area: Only island (AABB excludes infinite ice)
Agent Settings: radius 0.5m, height 1.8m, max_slope 40°
Cell Size: 0.5m (balance of precision vs bake time)
Threading: Bake in background thread
Infinite Ice: No NavMesh = units can't pathfind there (but can try to walk)
Integration Points
MainController

func _ready():
    if GameManager.is_new_game:
        await _generate_terrain()
    _spawn_survivors_at_ship()
GameManager
Store seed_manager and poi_locations
Persist seed in save files
Emit poi_locations_set signal for minimap
CharacterSpawner

func spawn_survivors_at_ship():
    var ship_pos = GameManager.poi_locations.get("ship")
    spawn_survivors(count, ship_pos)
Performance Budget
Stage	Time
Shape + Height	3-6s
Terrain Import	5-10s
Texture Painting	10-20s
NavMesh Bake	30-60s
POI Placement	<1s
Total	45-90s
Error Handling
If generation fails, load fallback hand-crafted terrain
If POI unreachable, regenerate with different seed
If NavMesh times out (>2min), warn but continue
Visual Only (MVP Deferred)
Icebergs: distant visual props, no collision
Sea ice: static visual, no gameplay impact
Dynamic weather: handled by existing snow_controller
GDD Section to Add
Add to GameDesignDocument.md under World section:
Procedural Terrain Generation
Island Shape: Teardrop-shaped island based on King William Island. ~12km north-south, ~9km east-west. Narrow end north (ship start), wide end south (rescue destination). Boundaries:
North/East/West: Endless arctic ice. Traversable but deadly (-60°C, permanent blizzard, zero resources). No artificial barriers - players can walk to their doom.
South: Ocean water (impassable)
Starting Position: Ship trapped in procedurally generated inlet on north coast (random east or west). The inlet represents where the ship mistakenly sailed in thinking it led to open water before the deep freeze caught them. Key Locations:
1 Hudson's Bay Company whaling station on south coast (~8 weeks travel)
1-2 Inuit villages within 1-2 days travel of ship
Various procedural hunting zones, resource caches
Terrain Features:
Cliffs, ice cliffs, beaches, inlets, fjords
Hills, slopes, flat plains (most common)
Mountains under 400m elevation
Southern portion has gentler downhill slope for easier travel
Generation Seed: Visible and shareable. Players can replay specific island configurations or share challenging seeds.
Implementation Order
Phase 0: Documentation (FIRST - Required before any code)
Update GameDesignDocument.md with procedural terrain section
Update root CLAUDE.md with terrain system overview
Create src/terrain/CLAUDE.md with comprehensive implementation guide
Phase 1: Core Generation
Create src/terrain/seed_manager.gd
Create src/terrain/island_shape.gd
Create src/terrain/heightmap_generator.gd
Phase 2: Terrain3D Integration
Create src/terrain/texture_painter.gd
Create src/terrain/terrain_generator.gd (orchestrator)
Phase 3: NavMesh + POI
Create src/terrain/poi_placer.gd
Implement NavMesh baking and POI validation
Phase 4: System Integration
Modify src/main_controller.gd - generation hook
Modify src/game_manager.gd - seed/POI persistence
Modify src/systems/character_spawner.gd - use ship position
Phase 5: UI + Polish
Add seed display/input to new game UI
Add loading screen with progress bar
Error handling and fallback terrain
Critical Files Summary
File	Purpose
src/terrain/terrain_generator.gd	Main entry point, pipeline orchestration
src/terrain/heightmap_generator.gd	Noise-based height generation
src/terrain/poi_placer.gd	POI placement with pathfinding validation
src/main_controller.gd	Hook for generation on new game
src/game_manager.gd	Seed and POI persistence
GameDesignDocument.md	Add procedural terrain section
Documentation Content Specifications
A. GameDesignDocument.md - Procedural Terrain Section
Add after the existing "Map" section under "World":

### Procedural Island Generation

#### Historical Context
The game is set on a fictionalized King William Island, September 1846. The ship became trapped in an inlet on the northern part of the island near Victory Point. The crew mistakenly sailed in thinking it led to open water. A subsequent quick deep freeze caught them off guard, freezing the ship in place. There is no hope of cutting their way out. They settle in for winter, but ice shifts and crushes the boat irreparably. The ship remains usable as makeshift shelter (not enough for the whole crew), and half their supplies are lost.

#### Island Shape & Dimensions
- **Shape**: Teardrop, narrow end north, wide end south
- **Size**: ~12km (N-S) × ~9km (E-W), approximately 100 km²
- **Starting Position**: Ship trapped in procedurally generated inlet on north coast (random east or west side)

#### Boundaries (No Artificial Walls)

| Direction | Boundary Type | Conditions |
|-----------|---------------|------------|
| North | Endless arctic ice | -60°C, permanent blizzard, total darkness, zero resources, no Inuit, certain death |
| East | Endless arctic ice | Same as North |
| West | Endless arctic ice | Same as North |
| South | Ocean water | Impassable (visual only) |

The ice zones are fully traversable - no invisible walls or force fields. Players can walk north to their doom if they choose. This maintains realism while naturally constraining gameplay.

#### Terrain Features
- **Cliffs & Ice Cliffs**: Rocky and ice faces, creates natural barriers
- **Beaches**: Low elevation coastal areas, primarily on south shore
- **Inlets & Minor Fjords**: Water intrusions into coastline
- **Hills & Slopes**: Rolling terrain throughout
- **Flat Plains**: Common, especially in central and southern regions
- **Mountains**: Lower peaks under 400m, concentrated in central areas

#### Regional Characteristics

| Region | Characteristics |
|--------|-----------------|
| Northern (ship start) | Narrow, rugged, inlet features, higher elevation |
| Central | Mixed terrain, mountains, hills, some flat areas |
| Southern | Wide, gentle downhill slope, favorable for sled travel, beaches |

#### Points of Interest

| POI | Count | Placement | Purpose |
|-----|-------|-----------|---------|
| Ship Wreck | 1 | Generated inlet, north coast | Starting location, partial shelter |
| HBC Whaling Station | 1 | South coast, ~8-10km from ship | Rescue destination (~8 weeks travel) |
| Inuit Village | 1-2 | 2-4km from ship, accessible terrain | Trading, information, survival aid |

**Travel Distances**: At ~1km per week (accounting for blizzards, animal attacks, hunting stops, medical care, etc.), reaching the HBC station takes approximately 8 weeks of dedicated travel.

#### Terrain Textures

| Texture | Location | Notes |
|---------|----------|-------|
| Snow | Default, high elevation | Primary surface |
| Rock | Steep slopes (>35°), cliff faces | Exposed rock |
| Ice | Sea level edges, frozen water | Slippery, cold |
| Gravel | Low elevation, transitions | Beaches, paths |
| Beach Sand | Southern beaches | Limited areas |

#### Seed System
- Each island is generated from a numeric seed
- Seed is visible on game start and in menus
- Players can enter specific seeds to replay islands
- Seeds can be shared between players
- Same seed always generates identical terrain

#### Procedural Elements
- Island coastline shape (within teardrop constraints)
- Mountain and hill placement
- Inlet location and shape
- POI exact positions (within distance rules)
- Texture variation patterns
B. Root CLAUDE.md - Brief Overview Addition
Add to the "Project Structure" section after existing directories:

│   ├── terrain/                  # Procedural terrain generation
│   │   ├── terrain_generator.gd  # Main orchestrator, generation pipeline
│   │   ├── island_shape.gd       # Teardrop island mask generation
│   │   ├── heightmap_generator.gd# Multi-octave noise heightmaps
│   │   ├── texture_painter.gd    # Height/slope-based texture assignment
│   │   ├── poi_placer.gd         # POI placement with validation
│   │   ├── seed_manager.gd       # Seed handling and persistence
│   │   └── CLAUDE.md             # Comprehensive implementation guide
Add to the "Key Addons" table:

| **Terrain3D** | Large terrain with LOD, procedural support | `TerrainGenerator` uses Terrain3D API for heightmap import, texture painting |
Add to "Subsystem Documentation" list:

- [Terrain Generation](src/terrain/CLAUDE.md) - Procedural island generation, Terrain3D integration
C. src/terrain/CLAUDE.md - Comprehensive Implementation Guide
This is the PRIMARY documentation file. Create with the following structure:

# Terrain Generation System

## Overview

The terrain generation system creates unique procedurally-generated arctic islands for each survival run. It uses Terrain3D's API for heightmap import, texture painting, and NavMesh baking.

## Files

| File | Purpose | Key Functions |
|------|---------|---------------|
| `terrain_generator.gd` | Main orchestrator | `generate(seed_manager)`, signals for progress |
| `island_shape.gd` | Teardrop mask | `generate_mask(width, height, rng)` |
| `heightmap_generator.gd` | Height generation | `generate_heightmap()`, `generate_inlet()` |
| `texture_painter.gd` | Texture assignment | `paint_terrain(terrain_data, heightmap, mask, rng)` |
| `poi_placer.gd` | POI placement | `place_pois()`, `validate_poi_accessibility()` |
| `seed_manager.gd` | Seed management | `set_seed()`, `get_seed_string()`, sub-RNGs |

## Generation Pipeline

### Stage 1: Seed Setup
```gdscript
var seed_manager := SeedManager.new()
seed_manager.set_seed(user_seed)  # Or generate_random_seed()
The seed_manager provides separate RNGs for each generation phase to ensure reproducibility:
get_shape_rng() - Island shape generation
get_height_rng() - Heightmap noise
get_texture_rng() - Texture variation
get_poi_rng() - POI placement
Stage 2: Island Shape Mask
Generate a 1024x1024 grayscale image where:
1.0 = center of island
0.0 = outside island (ice zone)
Gradient = coastline transition
Algorithm:
Calculate teardrop shape using ellipse + distortion
Apply coastal noise for natural coastline
Smooth falloff at edges

# Teardrop distortion: narrow at north, wide at south
var teardrop_factor := 1.0 + 0.4 * normalized_y
normalized_x *= teardrop_factor

# Distance from center (ellipse)
var dist := sqrt(nx * nx + ny * ny)

# Smooth falloff
var mask := smoothstep(1.2, 0.7, dist)
Stage 3: Heightmap Generation
Generate terrain heights using multi-octave noise: Noise Layers:
Base terrain (Simplex FBM): Rolling hills, 0-50m amplitude
Mountain layer (Simplex): Peaks up to 400m, masked to island center
Detail layer (High-frequency): Micro-terrain variation
Special Modifications:
Southern slope bias: Reduce height towards south for easier travel
Edge falloff: Blend to ice level at island edges
Inlet carving: Create ship spawn location

# Southern bias for easier travel
var south_bias := (1.0 - normalized_y) * 0.3
height *= (1.0 - south_bias)
Stage 4: Inlet Generation
Carve an inlet on the north coast for the ship:
Random choice: east or west side
Position: ~15% from top of map
Radius: ~800m diameter
Depth: Lower terrain to near sea level
Returns Dictionary with:
position: Vector3 world position of inlet center
east_side: bool indicating which side
Stage 5: Terrain3D Import
Apply heightmap to Terrain3D:

# Clear existing regions
for region in _terrain.data.get_regions_active():
    _terrain.data.remove_region(region, false)

# Import heightmap
var images: Array[Image] = [heightmap, null, null]  # Height, Control, Color
_terrain.data.import_images(images, Vector3.ZERO, 0.0, 1.0)
_terrain.data.calc_height_range(true)
Stage 6: Texture Painting
Assign textures based on height and slope: Texture IDs:
0: Snow (default)
1: Rock (cliffs)
2: Ice (sea level, surrounding)
3: Gravel (beaches, transitions)
4: Beach sand (if available)
Rules:
Height	Slope	Texture
< 5m	any	Gravel/Ice
5-15m	> 25°	Gravel
any	> 35°	Rock
> 50m	< 25°	Snow
default	default	Snow

terrain_data.set_control_base_id(world_pos, texture_id)
terrain_data.set_control_blend(world_pos, blend_amount)
Stage 7: NavMesh Baking
Bake navigation mesh for pathfinding: Critical Settings:
Bake AABB: Only island area (excludes infinite ice)
Agent radius: 0.5m
Agent height: 1.8m
Agent max slope: 40°
Cell size: 0.5m
Performance:
Estimated time: 30-60 seconds for 10km terrain
Run in background thread to avoid freezing
Show progress to player

# Configure baking area (only island, not ice)
nav_mesh.filter_baking_aabb = AABB(
    Vector3(-6000, -100, -6500),
    Vector3(12000, 600, 13000)
)

# Get terrain geometry
var terrain_faces := _terrain.generate_nav_mesh_source_geometry(aabb)
source_geometry.add_faces(terrain_faces, Transform3D.IDENTITY)

# Bake
NavigationServer3D.bake_from_source_geometry_data(nav_mesh, source_geometry)
Stage 8: POI Placement
Place key locations with distance constraints: HBC Whaling Station:
Location: South coast (80-95% Y position)
Distance: 8-10km from ship
Elevation: 2-20m (near sea level, coastal)
Must be on island (mask > 0.3)
Inuit Villages (1-2):
Distance: 2-4km from ship
Elevation: 5-100m
Minimum 1.5km apart from each other
Must be on island (mask > 0.5)
Stage 9: POI Validation
After NavMesh bake, verify all POIs are reachable from ship:

var path := NavigationServer3D.map_get_path(nav_map, ship_pos, poi_pos, true)
if path.size() == 0:
    push_warning("POI unreachable!")
    # Consider regeneration or fallback
Terrain3D API Reference
Height Operations

terrain.data.set_height(position, height)  # Set height at world position
terrain.data.get_height(position)           # Query height (with interpolation)
terrain.data.import_images(images, offset, rotation, scale)
terrain.data.calc_height_range(update_mesh)
Texture Operations

terrain.data.set_control_base_id(position, id)   # Set base texture (0-31)
terrain.data.set_control_overlay_id(position, id) # Set overlay texture
terrain.data.set_control_blend(position, blend)  # Blend amount (0.0-1.0)
terrain.data.set_control_angle(position, step)   # UV rotation (0-7 = 22.5° steps)
terrain.data.set_control_scale(position, scale)  # UV scale (-60% to +80%)
Region Management

terrain.data.get_regions_active()  # Get active region positions
terrain.data.remove_region(position, update)
terrain.data.update_maps()  # Apply changes
Integration Points
MainController

func _ready():
    if GameManager.is_new_game:
        var generator := TerrainGenerator.new()
        add_child(generator)
        generator.generation_completed.connect(_on_terrain_ready)
        await generator.generate(GameManager.seed_manager)
GameManager

var seed_manager: SeedManager
var poi_locations: Dictionary = {}

func start_new_game(seed: int = 0):
    is_new_game = true
    if seed == 0:
        seed_manager.generate_random_seed()
    else:
        seed_manager.set_seed(seed)
CharacterSpawner

func spawn_survivors_at_ship():
    var ship_pos := GameManager.poi_locations.get("ship", Vector3.ZERO)
    spawn_survivors(count, ship_pos)
Error Handling
Generation Failures
If terrain generation fails:
Log detailed error
Load fallback hand-crafted terrain (terrain/world_map.tscn)
Set default POI positions
Unreachable POIs
If pathfinding validation fails:
Attempt repositioning within constraints
If repeated failures, regenerate with different seed
Log warning if fallback used
NavMesh Timeout
If baking exceeds 2 minutes:
Log warning
Continue with partial mesh
POIs may be unreachable - warn player
Performance Considerations
Generation Time Budget
Stage	Time	Notes
Shape + Height	3-6s	CPU-bound noise generation
Terrain Import	5-10s	Terrain3D processing
Texture Painting	10-20s	Per-pixel control map updates
NavMesh Bake	30-60s	Main bottleneck
POI Placement	<1s	Sampling + validation
Total	45-90s	Show loading screen
Memory Usage
Heightmap Image (1024x1024, FORMAT_RF): ~4MB
Island mask Image: ~4MB
NavMesh data: ~10-50MB
Peak during generation: ~60-100MB
Optimization Strategies
Threaded NavMesh: Run baking in background thread
Chunked painting: Process texture painting in batches with await
Progress signals: Keep UI responsive with stage updates
Testing
Unit Tests
Same seed produces identical mask/heightmap
Height values within expected ranges
Texture assignment rules correct
Integration Tests
POIs reachable from ship via pathfinding
Height queries return valid values
NavMesh covers island area
Visual Tests
Generated terrain looks like teardrop island
Textures assigned appropriately
No obvious artifacts at region boundaries
Common Issues
"Terrain3D not found"
Ensure NavigationRegion3D → Terrain3D hierarchy
Check "terrain" group assignment
NavMesh not covering terrain
Verify baking AABB includes island
Check agent settings match terrain steepness
POIs spawning in water/ice
Mask threshold too low
Increase minimum elevation check
Textures not painting
Call terrain.data.update_maps() after painting
Verify texture slots are configured


---

This documentation structure ensures:
1. **GDD** has complete design specification for procedural terrain
2. **Root CLAUDE.md** provides quick reference and links
3. **terrain/CLAUDE.md** is comprehensive enough for any Claude agent to implement the system from scratch
