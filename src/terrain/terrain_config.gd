@tool
class_name TerrainConfig
extends Resource
## Configuration resource for procedural terrain generation.
## Save as .tres file and load in TerrainGenerator.
## Edit via Terrain Parameter Editor UI or directly in Godot Inspector.

## ============== HEIGHT CONSTRAINTS ==============
@export_group("Height Constraints")
@export_range(100.0, 500.0, 10.0) var max_mountain_height: float = 350.0
@export_range(50.0, 200.0, 5.0) var max_hill_height: float = 120.0
@export_range(5.0, 50.0, 1.0) var base_terrain_amplitude: float = 25.0
@export_range(1.0, 10.0, 0.5) var detail_amplitude: float = 3.0
@export_range(-5.0, 5.0, 0.5) var sea_level: float = 0.0
@export_range(-10.0, 0.0, 0.5) var ice_level: float = -2.0
@export_range(2.0, 20.0, 1.0) var beach_height: float = 8.0

## ============== NOISE FREQUENCIES ==============
@export_group("Noise Frequencies")
@export_range(0.001, 0.01, 0.001) var base_frequency: float = 0.004
@export_range(0.001, 0.01, 0.001) var hill_frequency: float = 0.003
@export_range(0.001, 0.01, 0.001) var mountain_frequency: float = 0.002
@export_range(0.005, 0.05, 0.005) var detail_frequency: float = 0.02
@export_range(0.001, 0.02, 0.001) var cliff_frequency: float = 0.006
@export_range(1, 6, 1) var octaves: int = 3
@export_range(0.1, 0.8, 0.05) var persistence: float = 0.4
@export_range(1.5, 3.0, 0.1) var lacunarity: float = 2.0

## ============== RIDGE PARAMETERS (Castle Wall Fix) ==============
@export_group("Ridge Parameters")
@export_range(0.001, 0.02, 0.001) var ridge_frequency: float = 0.008
@export_range(0.0, 1.0, 0.05) var ridge_amplitude: float = 0.3  ## Was 0.6, reduced to fix castle walls
@export var use_ridged_noise: bool = true  ## Toggle ridged noise on/off
@export_range(0.001, 0.02, 0.001) var valley_frequency: float = 0.005
@export_range(0.0, 0.5, 0.05) var valley_cut_strength: float = 0.3
@export_range(0.005, 0.03, 0.005) var erosion_frequency: float = 0.012

## ============== CLIFF PARAMETERS ==============
@export_group("Cliff Parameters")
@export_range(0.0, 1.0, 0.05) var coastal_cliff_strength: float = 0.3
@export_range(0.0, 1.0, 0.05) var mountain_cliff_strength: float = 0.5
@export_range(0.0, 0.5, 0.05) var midland_cliff_strength: float = 0.0  ## Disabled for smooth midlands

## ============== REGIONAL PARAMETERS ==============
@export_group("Regional Parameters")
@export_range(0.2, 0.6, 0.05) var mountain_band_center: float = 0.4
@export_range(0.1, 0.5, 0.05) var mountain_band_width: float = 0.3
@export_range(0.5, 0.8, 0.05) var flat_plains_start: float = 0.65
@export_range(0.8, 0.95, 0.01) var beach_start: float = 0.88
@export_range(0.2, 0.5, 0.05) var midland_start: float = 0.35
@export_range(0.0, 1.0, 0.1) var midland_hill_smoothing: float = 0.7  ## 0=none, 1=max smoothing

## ============== INLET/COVE PARAMETERS ==============
@export_group("Inlet Parameters")
@export_range(40, 200, 10) var inlet_width_pixels: int = 80
@export_range(100, 600, 50) var inlet_length_pixels: int = 400
@export_range(1.0, 10.0, 0.5) var inlet_floor_height: float = 3.0
@export_range(-5.0, 0.0, 0.5) var frozen_sea_height: float = -2.0
@export_range(10, 80, 5) var inlet_blend_radius: int = 40

## ============== MOUNTAIN PEAKS ==============
@export_group("Mountain Peaks")
@export var peak_1_enabled: bool = true
@export_range(0.1, 0.9, 0.05) var peak_1_x: float = 0.35
@export_range(0.1, 0.9, 0.05) var peak_1_y: float = 0.30
@export_range(100.0, 400.0, 10.0) var peak_1_height: float = 350.0
@export_range(0.05, 0.3, 0.01) var peak_1_radius: float = 0.15

@export var peak_2_enabled: bool = true
@export_range(0.1, 0.9, 0.05) var peak_2_x: float = 0.55
@export_range(0.1, 0.9, 0.05) var peak_2_y: float = 0.40
@export_range(100.0, 400.0, 10.0) var peak_2_height: float = 280.0
@export_range(0.05, 0.3, 0.01) var peak_2_radius: float = 0.12

@export var peak_3_enabled: bool = true
@export_range(0.1, 0.9, 0.05) var peak_3_x: float = 0.45
@export_range(0.1, 0.9, 0.05) var peak_3_y: float = 0.25
@export_range(100.0, 400.0, 10.0) var peak_3_height: float = 320.0
@export_range(0.05, 0.3, 0.01) var peak_3_radius: float = 0.10


## Get peak positions as array (for HeightmapGenerator compatibility)
func get_peak_positions() -> Array:
	var peaks := []
	if peak_1_enabled:
		peaks.append({"nx": peak_1_x, "ny": peak_1_y, "height": peak_1_height, "radius": peak_1_radius})
	if peak_2_enabled:
		peaks.append({"nx": peak_2_x, "ny": peak_2_y, "height": peak_2_height, "radius": peak_2_radius})
	if peak_3_enabled:
		peaks.append({"nx": peak_3_x, "ny": peak_3_y, "height": peak_3_height, "radius": peak_3_radius})
	return peaks


## Save config to file
func save_to_file(path: String) -> Error:
	return ResourceSaver.save(self, path)


## Load config from file (static factory)
static func load_from_file(path: String) -> TerrainConfig:
	if ResourceLoader.exists(path):
		var loaded = ResourceLoader.load(path)
		if loaded is TerrainConfig:
			return loaded
	# Return default config if file doesn't exist
	return TerrainConfig.new()


## Create default config
static func create_default() -> TerrainConfig:
	return TerrainConfig.new()


## Reset to defaults
func reset_to_defaults() -> void:
	max_mountain_height = 350.0
	max_hill_height = 120.0
	base_terrain_amplitude = 25.0
	detail_amplitude = 3.0
	sea_level = 0.0
	ice_level = -2.0
	beach_height = 8.0

	base_frequency = 0.004
	hill_frequency = 0.003
	mountain_frequency = 0.002
	detail_frequency = 0.02
	cliff_frequency = 0.006
	octaves = 3
	persistence = 0.4
	lacunarity = 2.0

	ridge_frequency = 0.008
	ridge_amplitude = 0.3
	use_ridged_noise = true
	valley_frequency = 0.005
	valley_cut_strength = 0.3
	erosion_frequency = 0.012

	coastal_cliff_strength = 0.3
	mountain_cliff_strength = 0.5
	midland_cliff_strength = 0.0

	mountain_band_center = 0.4
	mountain_band_width = 0.3
	flat_plains_start = 0.65
	beach_start = 0.88
	midland_start = 0.35
	midland_hill_smoothing = 0.7

	inlet_width_pixels = 80
	inlet_length_pixels = 400
	inlet_floor_height = 3.0
	frozen_sea_height = -2.0
	inlet_blend_radius = 40

	peak_1_enabled = true
	peak_1_x = 0.35
	peak_1_y = 0.30
	peak_1_height = 350.0
	peak_1_radius = 0.15

	peak_2_enabled = true
	peak_2_x = 0.55
	peak_2_y = 0.40
	peak_2_height = 280.0
	peak_2_radius = 0.12

	peak_3_enabled = true
	peak_3_x = 0.45
	peak_3_y = 0.25
	peak_3_height = 320.0
	peak_3_radius = 0.10
