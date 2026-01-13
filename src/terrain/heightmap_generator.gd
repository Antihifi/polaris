class_name HeightmapGenerator
extends RefCounted
## Generates heightmap for the terrain using multi-octave noise.
## Combines base terrain, hills, mountains, and detail layers.
## GDD Requirements:
##   - Mountains: peaks up to 400m, concentrated in central areas
##   - Cliffs: steep slopes >45° creating natural barriers
##   - Flat plains: common in central and southern regions
##   - Southern region: gentle downhill slope, beaches, easy travel
##   - Northern region: narrow, rugged, higher elevation

## Height constraints (in meters) - GDD says mountains under 400m
const MAX_MOUNTAIN_HEIGHT: float = 350.0  # Central mountain peaks (leave headroom for noise)
const MAX_HILL_HEIGHT: float = 120.0  # Rolling hills throughout island
const BASE_TERRAIN_AMPLITUDE: float = 25.0  # Gentle base variation
const DETAIL_AMPLITUDE: float = 3.0  # Micro-terrain
const SEA_LEVEL: float = 0.0
const ICE_LEVEL: float = -2.0  # Surrounding ice slightly below sea level
const BEACH_HEIGHT: float = 8.0  # Southern beaches

## Noise configuration
const BASE_FREQUENCY: float = 0.004  # Smooth base terrain
const HILL_FREQUENCY: float = 0.003  # Rolling hills
const MOUNTAIN_FREQUENCY: float = 0.002  # Large mountain features
const DETAIL_FREQUENCY: float = 0.02  # Micro-terrain
const CLIFF_FREQUENCY: float = 0.006  # Jagged cliff ridges
const OCTAVES: int = 3
const PERSISTENCE: float = 0.4
const LACUNARITY: float = 2.0

## Regional parameters (normalized Y: 0=north, 1=south)
const MOUNTAIN_BAND_CENTER: float = 0.4  # Mountains concentrated in central-north
const MOUNTAIN_BAND_WIDTH: float = 0.3  # Width of mountain band (increased for coverage)
const FLAT_PLAINS_START: float = 0.65  # Where flat plains begin (south-central)
const BEACH_START: float = 0.88  # Where beaches begin (southern edge)

## Mountain peak positions (2-3 distinct peaks as per GDD)
## These are normalized positions (0-1) where mountain peaks will be placed
const PEAK_POSITIONS: Array = [
	{"nx": 0.35, "ny": 0.30, "height": 350.0, "radius": 0.15},  # Northwest peak
	{"nx": 0.55, "ny": 0.40, "height": 280.0, "radius": 0.12},  # Central peak
	{"nx": 0.45, "ny": 0.25, "height": 320.0, "radius": 0.10},  # North peak
]

## Inlet/Cove carving parameters
## Creates an erosion-style cove from coastline into island
## Increased 3x per user feedback - needs to be large enough for ship + landing area
const INLET_WIDTH_PIXELS: int = 180  # ~450m wide cove mouth at 2.5m/pixel (was 60)
const INLET_LENGTH_PIXELS: int = 400  # ~1000m long cove into island (was 200)
const INLET_FLOOR_HEIGHT: float = 3.0  # Cove floor height (above sea level for ship)
const FROZEN_SEA_HEIGHT: float = -2.0  # Flat frozen sea level around island

## Smooth blending radius to prevent spike artifacts at cove edges
const INLET_BLEND_RADIUS: int = 40  # ~100m smooth transition zone


## Generate the heightmap based on island mask
## Returns Image with FORMAT_RF (32-bit float, height in meters)
## Creates terrain with:
##   - Northern region: rugged, higher elevation
##   - Central region: mountain band with peaks up to 350m (ridged, not conical)
##   - Southern region: flat plains descending to beaches
static func generate_heightmap(
	width_px: int,
	height_px: int,
	island_mask: Image,
	height_rng: RandomNumberGenerator
) -> Image:
	var heightmap := Image.create(width_px, height_px, false, Image.FORMAT_RF)

	# Create noise instances for different terrain features
	var base_noise := _create_noise(height_rng.randi(), BASE_FREQUENCY, OCTAVES)
	var hill_noise := _create_noise(height_rng.randi(), HILL_FREQUENCY, 2)
	var mountain_noise := _create_noise(height_rng.randi(), MOUNTAIN_FREQUENCY, 3)
	var detail_noise := _create_noise(height_rng.randi(), DETAIL_FREQUENCY, 2)

	# Cliff noise for jagged ridge features (higher frequency, more dramatic)
	var cliff_noise := _create_noise(height_rng.randi(), CLIFF_FREQUENCY, 4)
	var cliff_detail := _create_noise(height_rng.randi(), CLIFF_FREQUENCY * 2.0, 3)

	# Ridge noise for creating cliff-like features in mountain band
	var ridge_noise := _create_noise(height_rng.randi(), 0.004, 2)

	# Warp noise for breaking up uniform patterns
	var warp_noise := _create_noise(height_rng.randi(), 0.003, 2)

	# NEW: Ridge/valley noise for non-conical mountain shapes
	var ridge_pattern := _create_noise(height_rng.randi(), 0.008, 2)  # Creates ridge lines
	var valley_noise := _create_noise(height_rng.randi(), 0.005, 3)   # Creates valley channels
	var erosion_noise := _create_noise(height_rng.randi(), 0.012, 2)  # Erosion detail

	for y in range(height_px):
		for x in range(width_px):
			var mask_value: float = island_mask.get_pixel(x, y).r

			# Outside island: flat ice
			if mask_value < 0.01:
				heightmap.set_pixel(x, y, Color(ICE_LEVEL, 0.0, 0.0, 1.0))
				continue

			# Normalized coordinates (0 = north/west, 1 = south/east)
			var ny := float(y) / float(height_px)
			var nx := float(x) / float(width_px)

			# ========== REGIONAL HEIGHT CALCULATION ==========

			# 1. Base terrain (gentle undulation everywhere)
			var base_height := base_noise.get_noise_2d(float(x), float(y))
			base_height = (base_height + 1.0) * 0.5  # Normalize to 0-1
			base_height *= BASE_TERRAIN_AMPLITUDE

			# 2. Hill layer (rolling hills, reduced in flat plains region)
			var hill_raw := hill_noise.get_noise_2d(float(x), float(y))
			hill_raw = (hill_raw + 1.0) * 0.5

			# Reduce hills in southern flat plains region
			var hill_reduction: float = 1.0
			if ny > FLAT_PLAINS_START:
				hill_reduction = 1.0 - (ny - FLAT_PLAINS_START) / (1.0 - FLAT_PLAINS_START)
				hill_reduction = clampf(hill_reduction, 0.2, 1.0)

			var hill_height := hill_raw * MAX_HILL_HEIGHT * mask_value * hill_reduction

			# 3. DISTINCT MOUNTAIN PEAKS WITH RIDGES (not conical!)
			# Uses ridged noise and domain warping for realistic alpine terrain
			var peak_height := 0.0
			for peak in PEAK_POSITIONS:
				var peak_nx: float = peak.nx
				var peak_ny: float = peak.ny
				var peak_max_h: float = peak.height
				var peak_radius: float = peak.radius

				# Distance from this peak center
				var dx := nx - peak_nx
				var dy := ny - peak_ny
				var peak_dist := sqrt(dx * dx + dy * dy)

				if peak_dist < peak_radius * 1.3:  # Extend influence for ridges
					# Base elevation factor (still uses distance, but less dominant)
					var dist_factor := 1.0 - clampf(peak_dist / peak_radius, 0.0, 1.0)

					# === RIDGED NOISE for non-conical peaks ===
					# Create ridge lines radiating from peak using absolute value trick
					var ridge_raw := ridge_pattern.get_noise_2d(float(x), float(y))
					var ridge_val := 1.0 - absf(ridge_raw)  # Ridges where noise crosses zero
					ridge_val = ridge_val * ridge_val  # Sharpen the ridges

					# === DOMAIN WARPING to break up uniformity ===
					var warp_x := warp_noise.get_noise_2d(float(x), float(y)) * 100.0
					var warp_y := warp_noise.get_noise_2d(float(x) + 500.0, float(y)) * 100.0
					var warped_ridge := ridge_pattern.get_noise_2d(float(x) + warp_x, float(y) + warp_y)
					warped_ridge = 1.0 - absf(warped_ridge)
					warped_ridge = warped_ridge * warped_ridge

					# Combine both ridge patterns
					var combined_ridge := maxf(ridge_val, warped_ridge * 0.8)

					# === VALLEY CHANNELS between ridges ===
					var valley_raw := valley_noise.get_noise_2d(float(x), float(y))
					var valley_factor := absf(valley_raw)  # Valleys where noise is near zero
					valley_factor = 1.0 - valley_factor * valley_factor  # Invert and sharpen

					# === EROSION DETAIL for natural weathering ===
					var erosion := erosion_noise.get_noise_2d(float(x), float(y))
					erosion = (erosion + 1.0) * 0.5
					erosion = erosion * 0.3 + 0.7  # Range 0.7 to 1.0

					# === COMBINE FACTORS ===
					# Near peak center: high but not perfectly conical
					# Further out: ridges become more prominent
					var ridge_influence := clampf(peak_dist / peak_radius * 1.5, 0.0, 1.0)

					# Height = base elevation + ridge enhancement - valley erosion
					var base_height_factor := dist_factor * dist_factor  # Softer than squared
					var ridge_boost := combined_ridge * ridge_influence * 0.6
					var valley_cut := valley_factor * ridge_influence * 0.3

					var peak_factor := (base_height_factor * (1.0 - ridge_influence * 0.3) +
									   ridge_boost - valley_cut)
					peak_factor = clampf(peak_factor, 0.0, 1.0)

					# Apply erosion detail
					peak_factor *= erosion

					# Standard noise variation (reduced importance)
					var peak_noise := mountain_noise.get_noise_2d(float(x) * 0.5, float(y) * 0.5)
					peak_noise = (peak_noise + 1.0) * 0.5
					var noise_mod := 0.85 + peak_noise * 0.3  # 0.85 to 1.15

					var this_peak := peak_max_h * peak_factor * noise_mod * mask_value
					peak_height = maxf(peak_height, this_peak)

			# 4. Mountain band (rolling highlands between peaks)
			var mountain_height := 0.0
			var mountain_dist := absf(ny - MOUNTAIN_BAND_CENTER) / MOUNTAIN_BAND_WIDTH
			if mountain_dist < 1.0:
				var mountain_factor := 1.0 - mountain_dist
				mountain_factor *= mountain_factor

				# Center of island has stronger mountains (avoid edges)
				var center_x_factor := 1.0 - absf(nx - 0.5) * 2.0
				center_x_factor = clampf(center_x_factor, 0.2, 1.0)
				mountain_factor *= center_x_factor

				var mtn_raw := mountain_noise.get_noise_2d(float(x), float(y))
				mtn_raw = (mtn_raw + 1.0) * 0.5
				mtn_raw = mtn_raw * mtn_raw * mtn_raw

				mountain_height = mtn_raw * MAX_HILL_HEIGHT * 1.5 * mountain_factor * mask_value

			# 5. JAGGED CLIFFS (not gum-drops!)
			# Use domain warping + absolute value for sharp ridge lines
			var cliff_height := 0.0
			if ny < FLAT_PLAINS_START and mask_value > 0.5:
				# Warp the sample position for more organic cliff patterns
				var warp_x := warp_noise.get_noise_2d(float(x), float(y)) * 50.0
				var warp_y := warp_noise.get_noise_2d(float(x) + 1000.0, float(y)) * 50.0

				# Get cliff noise with warped coordinates
				var cliff_raw := cliff_noise.get_noise_2d(float(x) + warp_x, float(y) + warp_y)

				# Absolute value creates sharp ridges (like Swiss Alps)
				var cliff_ridge := absf(cliff_raw)
				cliff_ridge = 1.0 - cliff_ridge  # Invert so ridges are high

				# Square it for sharper peaks
				cliff_ridge = cliff_ridge * cliff_ridge * cliff_ridge

				# Add detail layer for jaggedness
				var cliff_detail_val := cliff_detail.get_noise_2d(float(x) + warp_x * 0.5, float(y) + warp_y * 0.5)
				cliff_detail_val = absf(cliff_detail_val) * 0.3

				# Stronger cliffs in mountain band, weaker elsewhere
				var cliff_strength := 0.3
				if mountain_dist < 1.0:
					cliff_strength = 0.6 * (1.0 - mountain_dist)

				cliff_height = (cliff_ridge + cliff_detail_val) * MAX_HILL_HEIGHT * cliff_strength * mask_value

			# Combine peak and mountain heights (take max to preserve distinct peaks)
			var total_mountain := maxf(peak_height, mountain_height + cliff_height)

			# 5.5. TRAVERSABLE VALLEYS (midland corridors for navigation)
			# Creates gentler passages through the midland terrain for pathfinding
			# These are wide, shallow valleys that connect regions of the island
			var valley_reduction := 0.0
			if ny > 0.25 and ny < FLAT_PLAINS_START and mask_value > 0.4:
				# Use a different noise pattern for valley locations
				var valley_corridor := valley_noise.get_noise_2d(float(x) * 0.8, float(y) * 0.8)

				# Create valleys where noise crosses zero (absolute value trick, inverted)
				var valley_strength := absf(valley_corridor)
				valley_strength = 1.0 - valley_strength  # Valleys where noise ~ 0

				# Sharpen the valleys slightly
				valley_strength = valley_strength * valley_strength

				# Only carve valleys where strength is significant
				if valley_strength > 0.3:
					# Normalize to 0-1 range from the 0.3-1.0 range
					var normalized := (valley_strength - 0.3) / 0.7

					# Valley depth varies: deeper in midlands, shallower near edges
					var midland_factor := 1.0 - absf(ny - 0.45) * 3.0  # Peak at ny=0.45
					midland_factor = clampf(midland_factor, 0.0, 1.0)

					# Also reduce depth near island edges (X axis)
					var edge_factor := 1.0 - absf(nx - 0.5) * 3.0
					edge_factor = clampf(edge_factor, 0.2, 1.0)

					# Maximum valley depth: 30% of local height
					valley_reduction = normalized * 0.30 * midland_factor * edge_factor

			# 6. Northern region boost (rugged, higher elevation)
			var north_boost := 0.0
			if ny < 0.3:
				var north_factor := (0.3 - ny) / 0.3  # 1.0 at north edge, 0.0 at ny=0.3
				north_boost = north_factor * 50.0 * mask_value  # +50m max at north edge

			# 7. Southern slope and beach (gentle descent)
			var south_reduction := 0.0
			if ny > FLAT_PLAINS_START:
				var south_factor := (ny - FLAT_PLAINS_START) / (1.0 - FLAT_PLAINS_START)
				south_reduction = south_factor * 0.5  # Reduce height by up to 50%

				# Beach zone: flatten even more
				if ny > BEACH_START:
					var beach_factor := (ny - BEACH_START) / (1.0 - BEACH_START)
					south_reduction = lerpf(south_reduction, 0.85, beach_factor)

			# 8. Detail noise (micro-terrain, subtle)
			var detail := detail_noise.get_noise_2d(float(x), float(y)) * DETAIL_AMPLITUDE

			# ========== COMBINE HEIGHT COMPONENTS ==========
			var height := base_height + hill_height + total_mountain + north_boost + detail

			# Apply valley reduction for traversable corridors
			# Valley carving happens AFTER mountain heights to create passages through terrain
			if valley_reduction > 0.0:
				height *= (1.0 - valley_reduction)

			# Apply southern slope reduction
			height *= (1.0 - south_reduction)

			# Beach zone: lerp towards beach height
			if ny > BEACH_START:
				var beach_blend := (ny - BEACH_START) / (1.0 - BEACH_START)
				beach_blend = beach_blend * beach_blend  # Smooth transition
				height = lerpf(height, BEACH_HEIGHT, beach_blend * 0.7)

			# Fade to ice level at island edges using mask
			height = lerpf(ICE_LEVEL, height, mask_value)

			# Ensure minimum walkable height on solid island
			if mask_value > 0.5:
				height = maxf(height, 2.0)

			heightmap.set_pixel(x, y, Color(height, 0.0, 0.0, 1.0))

	return heightmap


## Carve a cove/channel from the FROZEN SEA through the coastline INTO the island.
## NEW APPROACH: Uses a smooth 2D Gaussian influence field instead of path-based carving.
## This eliminates spike artifacts by creating ONE continuous smooth surface.
## Modifies the heightmap in place.
## Returns Dictionary with cove position info.
static func carve_inlet(
	heightmap: Image,
	island_mask: Image,
	inlet_rng: RandomNumberGenerator
) -> Dictionary:
	var img_width := heightmap.get_width()
	var img_height := heightmap.get_height()

	# Get inlet position from island shape analysis
	var inlet_info := IslandShape.find_inlet_position(island_mask, inlet_rng)
	var spawn_pixel: Vector2i = inlet_info.pixel_position
	var coastline_pixel: Vector2i = inlet_info.get("coastline_pixel", spawn_pixel)
	var east_side: bool = inlet_info.east_side

	# Direction from coastline INTO the island (roughly south)
	var direction := Vector2(
		float(spawn_pixel.x - coastline_pixel.x),
		float(spawn_pixel.y - coastline_pixel.y)
	)
	if direction.length() < 1.0:
		direction = Vector2(0, 1)  # Default: straight south into island
	direction = direction.normalized()

	# Perpendicular direction for width calculations
	var perp := Vector2(-direction.y, direction.x)

	# Calculate START POINT - extend PAST coastline into frozen sea
	var sea_extension := 150  # ~375m out into frozen sea
	var sea_start := Vector2(coastline_pixel) - direction * float(sea_extension)

	# Total length: from sea start through coastline to inland
	var total_length := float(INLET_LENGTH_PIXELS) + float(sea_extension)

	# Calculate bounding box for the cove area (with generous margin)
	var margin := INLET_WIDTH_PIXELS + INLET_BLEND_RADIUS * 2
	var min_x := int(minf(sea_start.x, spawn_pixel.x + direction.x * INLET_LENGTH_PIXELS)) - margin
	var max_x := int(maxf(sea_start.x, spawn_pixel.x + direction.x * INLET_LENGTH_PIXELS)) + margin
	var min_y := int(minf(sea_start.y, spawn_pixel.y + direction.y * INLET_LENGTH_PIXELS)) - margin
	var max_y := int(maxf(sea_start.y, spawn_pixel.y + direction.y * INLET_LENGTH_PIXELS)) + margin

	min_x = clampi(min_x, 0, img_width - 1)
	max_x = clampi(max_x, 0, img_width - 1)
	min_y = clampi(min_y, 0, img_height - 1)
	max_y = clampi(max_y, 0, img_height - 1)

	print("[HeightmapGenerator] Carving inlet with smooth field approach:")
	print("  Sea start: (%.0f, %.0f), Spawn: (%d, %d)" % [sea_start.x, sea_start.y, spawn_pixel.x, spawn_pixel.y])
	print("  Direction: %s, Total length: %.0f px" % [direction, total_length])
	print("  Bounding box: (%d,%d) to (%d,%d)" % [min_x, min_y, max_x, max_y])

	var pixels_modified := 0

	# SINGLE PASS: For each pixel in bounding box, calculate smooth influence
	for py in range(min_y, max_y + 1):
		for px in range(min_x, max_x + 1):
			var pixel_pos := Vector2(float(px), float(py))

			# Project pixel onto the cove centerline
			var to_pixel := pixel_pos - sea_start
			var along_channel := to_pixel.dot(direction)
			var across_channel := absf(to_pixel.dot(perp))

			# Skip if before sea start or beyond inland terminus
			if along_channel < -50 or along_channel > total_length + 50:
				continue

			# Calculate progress along channel (0 = sea mouth, 1 = inland end)
			var progress := clampf(along_channel / total_length, 0.0, 1.0)

			# Channel width varies: widest at mouth, tapers inland
			var width_factor := 1.0 - progress * 0.4
			var half_width := float(INLET_WIDTH_PIXELS) * width_factor

			# Floor height: rises gently from sea to inland
			var floor_height: float
			if progress < 0.25:
				floor_height = FROZEN_SEA_HEIGHT + 0.5
			else:
				var inland_progress := (progress - 0.25) / 0.75
				floor_height = lerpf(FROZEN_SEA_HEIGHT + 0.5, INLET_FLOOR_HEIGHT + 3.0, inland_progress * inland_progress)

			# Calculate influence using SMOOTH FALLOFF (Gaussian-like)
			var influence: float = 0.0

			if across_channel < half_width * 0.7:
				# Core area: full influence (flat floor)
				influence = 1.0
			elif across_channel < half_width + float(INLET_BLEND_RADIUS):
				# Transition zone: smooth falloff using cosine interpolation
				var edge_start := half_width * 0.7
				var edge_end := half_width + float(INLET_BLEND_RADIUS)
				var t := (across_channel - edge_start) / (edge_end - edge_start)
				# Cosine interpolation for extra smoothness
				influence = 0.5 * (1.0 + cos(t * PI))

			# Smooth fadeout at channel ends
			if along_channel < 0:
				# Before sea start - gentle fade
				var fade := 1.0 - absf(along_channel) / 50.0
				influence *= clampf(fade, 0.0, 1.0)
			elif progress > 0.8:
				# Near inland end - smooth taper
				var end_fade := 1.0 - (progress - 0.8) / 0.2
				influence *= end_fade * end_fade  # Quadratic falloff

			if influence < 0.001:
				continue

			# Get current height and apply smooth blend
			var current_height: float = heightmap.get_pixel(px, py).r

			# Only carve DOWN, never raise terrain
			if current_height > floor_height:
				# Blend between current terrain and cove floor
				var new_height := lerpf(current_height, floor_height, influence)
				heightmap.set_pixel(px, py, Color(new_height, 0.0, 0.0, 1.0))
				pixels_modified += 1

	print("[HeightmapGenerator] Smooth field carving: %d pixels modified" % pixels_modified)

	# Final pass: Gaussian blur on the carved region to eliminate any remaining discontinuities
	_gaussian_blur_region(heightmap, min_x, min_y, max_x, max_y, 3)

	# Ensure the frozen sea buffer around the island is FLAT
	_ensure_flat_frozen_sea(heightmap, island_mask)

	# Calculate world position for spawn point (center of cove)
	var meters_per_pixel: float = TerrainGenerator.METERS_PER_PIXEL
	var world_x := (float(spawn_pixel.x) - float(img_width) / 2.0) * meters_per_pixel
	var world_z := (float(spawn_pixel.y) - float(img_height) / 2.0) * meters_per_pixel
	var world_y := INLET_FLOOR_HEIGHT + 2.0

	return {
		"position": Vector3(world_x, world_y, world_z),
		"pixel_position": spawn_pixel,
		"coastline_pixel": coastline_pixel,
		"sea_start_pixel": Vector2i(int(sea_start.x), int(sea_start.y)),
		"east_side": east_side,
		"cove_width_meters": INLET_WIDTH_PIXELS * meters_per_pixel
	}


## Apply a simple Gaussian blur to a region of the heightmap.
## This smooths out any remaining height discontinuities.
static func _gaussian_blur_region(heightmap: Image, min_x: int, min_y: int, max_x: int, max_y: int, radius: int) -> void:
	var img_width := heightmap.get_width()
	var img_height := heightmap.get_height()

	# Create a copy of the region to read from
	var temp_heights := {}
	for py in range(min_y, max_y + 1):
		for px in range(min_x, max_x + 1):
			temp_heights[Vector2i(px, py)] = heightmap.get_pixel(px, py).r

	# Gaussian kernel weights (3x3 approximation)
	var kernel := [
		[1.0, 2.0, 1.0],
		[2.0, 4.0, 2.0],
		[1.0, 2.0, 1.0]
	]
	var kernel_sum := 16.0

	# Apply blur
	for py in range(min_y + radius, max_y - radius + 1):
		for px in range(min_x + radius, max_x - radius + 1):
			var weighted_sum := 0.0

			for ky in range(-1, 2):
				for kx in range(-1, 2):
					var sample_key := Vector2i(px + kx, py + ky)
					if temp_heights.has(sample_key):
						weighted_sum += temp_heights[sample_key] * kernel[ky + 1][kx + 1]

			var blurred_height := weighted_sum / kernel_sum
			heightmap.set_pixel(px, py, Color(blurred_height, 0.0, 0.0, 1.0))


## Ensure the frozen sea (ice buffer) around the island is perfectly flat.
## This creates the 500m+ buffer of flat ice at FROZEN_SEA_HEIGHT.
static func _ensure_flat_frozen_sea(heightmap: Image, island_mask: Image) -> void:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	for y in range(height):
		for x in range(width):
			var mask_value: float = island_mask.get_pixel(x, y).r

			# If completely outside island (mask = 0), force to flat frozen sea level
			if mask_value < 0.1:
				heightmap.set_pixel(x, y, Color(FROZEN_SEA_HEIGHT, 0.0, 0.0, 1.0))
			# Transition zone: blend towards frozen sea
			elif mask_value < 0.3:
				var current_height: float = heightmap.get_pixel(x, y).r
				var blend := (0.3 - mask_value) / 0.2  # 1.0 at mask=0.1, 0.0 at mask=0.3
				var new_height := lerpf(current_height, FROZEN_SEA_HEIGHT, blend * 0.8)
				heightmap.set_pixel(x, y, Color(new_height, 0.0, 0.0, 1.0))


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
