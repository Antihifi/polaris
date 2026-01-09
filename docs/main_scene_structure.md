# Main Scene Structure

Both `main.tscn` (9KB) and `terrain/world_map.tscn` (3.5KB) are fully readable by Claude agents.

## Node Hierarchy

```
main.tscn (9KB)
├── script: res://src/main_controller.gd
│
├── DirectionalLight3D (disabled, Sky3D handles lighting)
│
├── Captain [instance: res://captain.tscn]
│   └── The player's initial controllable character
│
├── RTScamera [instance: res://src/camera/rts_camera.tscn]
│   └── RTS-style camera with WASD, zoom, orbit
│
├── Sky3D (WorldEnvironment)
│   ├── script: res://addons/sky_3d/src/Sky3D.gd
│   ├── SunLight (DirectionalLight3D)
│   ├── MoonLight (DirectionalLight3D)
│   ├── SkyDome (Node)
│   └── TimeOfDay (Node)
│
├── Crates [instance: res://objects/crates1.tscn]
│
├── SnowController [instance: res://src/systems/weather/snow_controller.tscn]
│
└── world_map [instance: res://terrain/world_map.tscn]
    └── See below
```

## World Map Structure (terrain/world_map.tscn)

```
world_map (3.5KB)
├── NavigationRegion3D
│   ├── navigation_mesh: res://terrain/navigation_mesh.tres (external)
│   └── Terrain3D
│       ├── data_directory: res://terrain/
│       ├── material: Terrain3DMaterial (inline)
│       └── assets: Terrain3DAssets (inline)
│
└── Texture Assets (2):
    ├── snow_01: albedo + normal (external PNGs)
    └── rock_dark_01: albedo + normal (external PNGs)
```

## External Resources

### main.tscn
| Type | Path |
|------|------|
| Script | res://src/main_controller.gd |
| PackedScene | res://captain.tscn |
| PackedScene | res://src/camera/rts_camera.tscn |
| PackedScene | res://objects/crates1.tscn |
| PackedScene | res://src/systems/weather/snow_controller.tscn |
| PackedScene | res://terrain/world_map.tscn |
| Shader | res://addons/sky_3d/shaders/SkyMaterial.gdshader |
| Texture2D | Sky3D textures (moon, stars, noise, clouds) |
| Script | Sky3D scripts |

### terrain/world_map.tscn
| Type | Path |
|------|------|
| NavigationMesh | res://terrain/navigation_mesh.tres |
| Texture2D | res://terrain/snow01/snow_01_albedo_height.png |
| Texture2D | res://terrain/snow01/snow_01_normal_roughness.png |
| Texture2D | res://terrain/rock_dark01/rock_dark_01_albedo_height.png |
| Texture2D | res://terrain/rock_dark01/rock_dark_01_packed_normal_roughness.png |

## Key Node Details

### Root Node (main.tscn)
- Script: `main_controller.gd`
- Bootstraps the game, adds GameHUD via code
- Connects camera to input handler

### world_map/NavigationRegion3D
- NavigationMesh is external: `res://terrain/navigation_mesh.tres`
- Provides pathfinding for click-to-move

### world_map/Terrain3D
- Data directory: `res://terrain/` (binary .res region files)
- Uses 2 texture assets: snow_01 (id=0), rock_dark_01 (id=1)
- All textures use ExtResource (external PNG files)

### Sky3D (WorldEnvironment)
- Manages day/night cycle, sun/moon positions
- TimeManager autoload syncs game time to this
- Arctic latitude (74°N) configured for polar day/night

## Collision Layers

| Layer | Purpose |
|-------|---------|
| 1 | Terrain (ground for raycasts) |
| 2 | Units (selectable characters) |

## Scene Loading

The main scene is set in `project.godot`:
```
run/main_scene="uid://bkla2k7f850nt"
```
