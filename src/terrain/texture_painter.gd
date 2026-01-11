class_name TexturePainter
extends RefCounted
## Paints textures on the terrain based on height and slope.
## Uses Terrain3D's control map API to assign texture IDs.

## Texture slot IDs (must match Terrain3D material configuration)
const TEXTURE_SNOW: int = 0
const TEXTURE_ROCK: int = 1
const TEXTURE_ICE: int = 2
const TEXTURE_GRAVEL: int = 3

## Height thresholds (meters)
const BEACH_MAX_HEIGHT: float = 5.0
const GRAVEL_MAX_HEIGHT: float = 15.0
const SNOW_MIN_HEIGHT: float = 30.0

## Slope thresholds (degrees)
const CLIFF_MIN_SLOPE: float = 38.0
const STEEP_MIN_SLOPE: float = 25.0


## Get meters per pixel from TerrainGenerator (dynamic to support different resolutions)
static func _get_meters_per_pixel() -> float:
	return TerrainGenerator.METERS_PER_PIXEL


## Paint textures on the entire terrain
## This uses Terrain3D's data API to set control map values
## NOTE: Currently DISABLED - Terrain3D's set_control_* methods crash when
## called on positions without active regions, and import_images doesn't
## create regions covering the full procedural terrain area.
## TODO: Re-enable once we understand how to properly create terrain regions.
static func paint_terrain(
	_terrain_data,  # Terrain3DData
	_heightmap: Image,
	_island_mask: Image,
	_texture_rng: RandomNumberGenerator
) -> void:
	# TEMPORARILY DISABLED - causes hard crash due to missing terrain regions
	# The existing terrain in world_map.tscn has limited regions that don't
	# cover the full 10km x 10km procedural area.
	print("[TexturePainter] Texture painting SKIPPED (temporarily disabled)")
	print("[TexturePainter] Terrain will use existing textures from world_map.tscn")
	return


## Paint textures using direct heightmap data (without Terrain3D API)
## Returns a control map Image for later import
static func generate_control_map(
	heightmap: Image,
	island_mask: Image,
	texture_rng: RandomNumberGenerator
) -> Image:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	# Control map stores texture ID in red channel, blend in green
	var control_map := Image.create(width, height, false, Image.FORMAT_RG8)

	# Variation noise
	var variation_noise := FastNoiseLite.new()
	variation_noise.seed = texture_rng.randi()
	variation_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	variation_noise.frequency = 0.08

	var blend_noise := FastNoiseLite.new()
	blend_noise.seed = texture_rng.randi()
	blend_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	blend_noise.frequency = 0.15

	for y in range(1, height - 1):
		for x in range(1, width - 1):
			var mask_value: float = island_mask.get_pixel(x, y).r
			var h: float = heightmap.get_pixel(x, y).r
			var slope := _calculate_slope(heightmap, x, y)
			var variation := variation_noise.get_noise_2d(float(x), float(y))
			var blend_var := blend_noise.get_noise_2d(float(x), float(y))

			var texture_id := _determine_texture(h, slope, mask_value, variation)

			# Calculate blend amount
			var blend := 0.0
			if absf(blend_var) > 0.25 and mask_value > 0.3:
				blend = (absf(blend_var) - 0.25) / 0.75 * 0.35

			# Encode in color: R = texture ID (normalized), G = blend
			var r := float(texture_id) / 31.0  # Terrain3D supports 0-31
			var g := blend

			control_map.set_pixel(x, y, Color(r, g, 0.0, 1.0))

	return control_map


## Determine which texture to use based on terrain properties
static func _determine_texture(height_m: float, slope_deg: float, mask: float, variation: float) -> int:
	# Outside island: ice
	if mask < 0.1:
		return TEXTURE_ICE

	# Very steep slopes: rock (cliffs)
	if slope_deg > CLIFF_MIN_SLOPE:
		return TEXTURE_ROCK

	# Near sea level: gravel/beach zone
	if height_m < BEACH_MAX_HEIGHT:
		# Mix of gravel and ice based on variation
		return TEXTURE_GRAVEL if variation > -0.2 else TEXTURE_ICE

	# Low elevation with some slope: gravel transition
	if height_m < GRAVEL_MAX_HEIGHT:
		if slope_deg > STEEP_MIN_SLOPE:
			return TEXTURE_GRAVEL
		# Gravel patches based on variation
		return TEXTURE_GRAVEL if variation > 0.4 else TEXTURE_SNOW

	# Moderately steep areas: rock/snow mix
	if slope_deg > STEEP_MIN_SLOPE:
		return TEXTURE_ROCK if variation > 0.2 else TEXTURE_SNOW

	# Default: snow
	return TEXTURE_SNOW


## Calculate slope at a point from neighboring heights
static func _calculate_slope(heightmap: Image, x: int, y: int) -> float:
	# Get neighboring heights
	var h_left: float = heightmap.get_pixel(x - 1, y).r
	var h_right: float = heightmap.get_pixel(x + 1, y).r
	var h_up: float = heightmap.get_pixel(x, y - 1).r
	var h_down: float = heightmap.get_pixel(x, y + 1).r

	# Calculate gradient (height change per pixel)
	var dx := (h_right - h_left) / 2.0
	var dy := (h_down - h_up) / 2.0

	# Gradient magnitude
	var gradient := sqrt(dx * dx + dy * dy)

	# Convert to angle (considering meters per pixel)
	# tan(slope) = rise / run
	var slope_rad := atan(gradient / _get_meters_per_pixel())
	return rad_to_deg(slope_rad)


## Convert pixel coordinates to world position
static func _pixel_to_world(x: int, y: int, height_m: float, width: int, height: int) -> Vector3:
	# Terrain centered at origin
	var mpp := _get_meters_per_pixel()
	var world_x := (float(x) - float(width) / 2.0) * mpp
	var world_z := (float(y) - float(height) / 2.0) * mpp
	return Vector3(world_x, height_m, world_z)


## Get texture distribution statistics for debugging
static func get_texture_stats(heightmap: Image, island_mask: Image) -> Dictionary:
	var counts := {
		TEXTURE_SNOW: 0,
		TEXTURE_ROCK: 0,
		TEXTURE_ICE: 0,
		TEXTURE_GRAVEL: 0
	}

	var width := heightmap.get_width()
	var height := heightmap.get_height()

	for y in range(1, height - 1):
		for x in range(1, width - 1):
			var mask_value: float = island_mask.get_pixel(x, y).r
			var h: float = heightmap.get_pixel(x, y).r
			var slope := _calculate_slope(heightmap, x, y)

			var texture_id := _determine_texture(h, slope, mask_value, 0.0)
			counts[texture_id] += 1

	var total := 0
	for key in counts:
		total += counts[key]

	return {
		"snow_percent": float(counts[TEXTURE_SNOW]) / total * 100.0 if total > 0 else 0.0,
		"rock_percent": float(counts[TEXTURE_ROCK]) / total * 100.0 if total > 0 else 0.0,
		"ice_percent": float(counts[TEXTURE_ICE]) / total * 100.0 if total > 0 else 0.0,
		"gravel_percent": float(counts[TEXTURE_GRAVEL]) / total * 100.0 if total > 0 else 0.0,
		"total_pixels": total
	}
