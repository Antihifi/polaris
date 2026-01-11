class_name HeightmapGenerator
extends RefCounted
## Generates heightmap for the terrain using multi-octave noise.
## Combines base terrain, hills, and detail layers.
## Arctic terrain should be rolling and gentle, not spiky mountains.

## Height constraints (in meters)
const MAX_HILL_HEIGHT: float = 150.0  # Gentle arctic hills, not spiky peaks
const BASE_TERRAIN_AMPLITUDE: float = 30.0  # Reduced for gentler base terrain
const DETAIL_AMPLITUDE: float = 4.0  # Reduced for smoother surface
const SEA_LEVEL: float = 0.0
const ICE_LEVEL: float = -2.0  # Surrounding ice slightly below sea level

## Noise configuration - lower frequencies for smoother terrain
const BASE_FREQUENCY: float = 0.005  # Lower = larger, smoother features
const HILL_FREQUENCY: float = 0.003  # Was MOUNTAIN_FREQUENCY
const DETAIL_FREQUENCY: float = 0.02
const OCTAVES: int = 3  # Fewer octaves = smoother
const PERSISTENCE: float = 0.4  # Lower = less high-frequency detail
const LACUNARITY: float = 2.0

## Southern bias - how much to lower terrain towards south (easier travel)
const SOUTH_BIAS_STRENGTH: float = 0.25  # Reduced for more usable terrain

## Inlet carving parameters
## Note: With 4096 resolution and 2.5m/pixel, 80px = 200m radius = 400m diameter inlet
## This is increased from 80 to give more room for ship maneuvering
const INLET_RADIUS_PIXELS: int = 120  # ~300m radius = 600m diameter inlet at 2.5m/pixel
const INLET_TARGET_HEIGHT: float = 5.0  # Slightly above sea level for ship


## Generate the heightmap based on island mask
## Returns Image with FORMAT_RF (32-bit float, height in meters)
## Creates gentle, rolling arctic terrain - no spiky peaks.
static func generate_heightmap(
	width_px: int,
	height_px: int,
	island_mask: Image,
	height_rng: RandomNumberGenerator
) -> Image:
	var heightmap := Image.create(width_px, height_px, false, Image.FORMAT_RF)

	# Create noise instances for different terrain features
	# All use smooth simplex with low octaves for gentle terrain
	var base_noise := _create_noise(height_rng.randi(), BASE_FREQUENCY, OCTAVES)
	var hill_noise := _create_noise(height_rng.randi(), HILL_FREQUENCY, 2)  # Very smooth hills
	var detail_noise := _create_noise(height_rng.randi(), DETAIL_FREQUENCY, 2)

	# NO ridge noise - arctic terrain doesn't have sharp ridges

	for y in range(height_px):
		for x in range(width_px):
			var mask_value: float = island_mask.get_pixel(x, y).r

			# Outside island: flat ice
			if mask_value < 0.01:
				heightmap.set_pixel(x, y, Color(ICE_LEVEL, 0.0, 0.0, 1.0))
				continue

			# Normalized Y coordinate (0 = north, 1 = south)
			var ny := float(y) / float(height_px)
			var nx := float(x) / float(width_px)

			# Base terrain (gentle rolling)
			var base_height := base_noise.get_noise_2d(float(x), float(y))
			base_height = (base_height + 1.0) * 0.5  # Normalize to 0-1
			base_height *= BASE_TERRAIN_AMPLITUDE

			# Hill layer (gentle hills, stronger in center of island)
			var hill_factor := mask_value  # Linear fade, not squared
			# Reduce hills at edges and favor center-north area
			var center_factor: float = 1.0 - abs(nx - 0.5) * 1.5
			center_factor = clampf(center_factor, 0.3, 1.0)
			var lat_factor: float = 1.0 - abs(ny - 0.35) * 1.2  # Hills peak in north-center
			lat_factor = clampf(lat_factor, 0.2, 1.0)
			hill_factor *= center_factor * lat_factor

			var hill_raw := hill_noise.get_noise_2d(float(x), float(y))
			# Use smooth curve, no sharp peaks
			hill_raw = (hill_raw + 1.0) * 0.5  # Normalize to 0-1
			hill_raw = hill_raw * hill_raw  # Smooth curve (squared makes it gentler)
			var hill_height := hill_raw * MAX_HILL_HEIGHT * hill_factor

			# Detail noise for micro-terrain (very subtle)
			var detail := detail_noise.get_noise_2d(float(x), float(y)) * DETAIL_AMPLITUDE

			# Southern slope bias (easier travel to south)
			var south_bias := ny * SOUTH_BIAS_STRENGTH

			# Combine all height components
			var height := base_height + hill_height + detail

			# Apply southern bias (reduce height towards south)
			height *= (1.0 - south_bias)

			# Fade to ice level at edges using mask
			height = lerpf(ICE_LEVEL, height, mask_value)

			# Ensure minimum height on island (but not too high)
			if mask_value > 0.5:
				height = maxf(height, 2.0)

			heightmap.set_pixel(x, y, Color(height, 0.0, 0.0, 1.0))

	return heightmap


## Carve an inlet on the north coast for the ship spawn
## Modifies the heightmap in place
## Returns Dictionary with inlet position info
static func carve_inlet(
	heightmap: Image,
	island_mask: Image,
	inlet_rng: RandomNumberGenerator
) -> Dictionary:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	# Get inlet position from island shape analysis
	var inlet_info := IslandShape.find_inlet_position(island_mask, inlet_rng)
	var inlet_pixel: Vector2i = inlet_info.pixel_position
	var east_side: bool = inlet_info.east_side

	# Carve the inlet into the heightmap
	for dy in range(-INLET_RADIUS_PIXELS, INLET_RADIUS_PIXELS + 1):
		for dx in range(-INLET_RADIUS_PIXELS, INLET_RADIUS_PIXELS + 1):
			var px := inlet_pixel.x + dx
			var py := inlet_pixel.y + dy

			if px < 0 or px >= width or py < 0 or py >= height:
				continue

			var dist := sqrt(float(dx * dx + dy * dy))
			if dist > INLET_RADIUS_PIXELS:
				continue

			# Smooth carving with falloff from center
			var carve_factor := 1.0 - (dist / float(INLET_RADIUS_PIXELS))
			carve_factor = carve_factor * carve_factor  # Smooth falloff

			var current_height: float = heightmap.get_pixel(px, py).r
			var new_height := lerpf(current_height, INLET_TARGET_HEIGHT, carve_factor * 0.85)

			# Don't go below sea level in the inlet center (ship needs to sit on ground)
			new_height = maxf(new_height, INLET_TARGET_HEIGHT * 0.5)

			heightmap.set_pixel(px, py, Color(new_height, 0.0, 0.0, 1.0))

	# Calculate world position
	# Use TerrainGenerator's METERS_PER_PIXEL constant for correct scaling
	# With 4096 resolution and 2.5m spacing, terrain spans -5120 to +5120
	var meters_per_pixel: float = TerrainGenerator.METERS_PER_PIXEL
	var world_x := (float(inlet_pixel.x) - float(width) / 2.0) * meters_per_pixel
	var world_z := (float(inlet_pixel.y) - float(height) / 2.0) * meters_per_pixel
	var world_y := INLET_TARGET_HEIGHT

	return {
		"position": Vector3(world_x, world_y, world_z),
		"pixel_position": inlet_pixel,
		"east_side": east_side,
		"radius_meters": INLET_RADIUS_PIXELS * meters_per_pixel
	}


## Create hills and valleys near specific areas
## Can be used to create sheltered spots near POIs
static func create_sheltered_area(
	heightmap: Image,
	center_pixel: Vector2i,
	radius: int,
	height_rng: RandomNumberGenerator
) -> void:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	# Create a small depression with raised edges (natural shelter)
	for dy in range(-radius, radius + 1):
		for dx in range(-radius, radius + 1):
			var px := center_pixel.x + dx
			var py := center_pixel.y + dy

			if px < 0 or px >= width or py < 0 or py >= height:
				continue

			var dist := sqrt(float(dx * dx + dy * dy))
			if dist > radius:
				continue

			var normalized_dist := dist / float(radius)

			# Create a bowl shape: raised at edges, lower in center
			var bowl_factor: float
			if normalized_dist < 0.5:
				# Inner area: slightly lower
				bowl_factor = -5.0 * (0.5 - normalized_dist)
			else:
				# Outer ring: slightly raised
				bowl_factor = 8.0 * (normalized_dist - 0.5) * (1.0 - normalized_dist)

			var current_height: float = heightmap.get_pixel(px, py).r
			var new_height := current_height + bowl_factor
			new_height = maxf(new_height, 2.0)  # Don't go below sea level

			heightmap.set_pixel(px, py, Color(new_height, 0.0, 0.0, 1.0))


## Get height statistics for debugging
static func get_height_stats(heightmap: Image) -> Dictionary:
	var min_height := INF
	var max_height := -INF
	var total := 0.0
	var count := 0

	for y in range(heightmap.get_height()):
		for x in range(heightmap.get_width()):
			var h: float = heightmap.get_pixel(x, y).r
			min_height = minf(min_height, h)
			max_height = maxf(max_height, h)
			total += h
			count += 1

	return {
		"min": min_height,
		"max": max_height,
		"average": total / float(count) if count > 0 else 0.0
	}


## Create noise with specified parameters
static func _create_noise(seed_val: int, frequency: float, octaves: int) -> FastNoiseLite:
	var noise := FastNoiseLite.new()
	noise.seed = seed_val
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = octaves
	noise.fractal_gain = PERSISTENCE  # Was fractal_persistence in Godot 3.x
	noise.fractal_lacunarity = LACUNARITY
	noise.frequency = frequency
	return noise
