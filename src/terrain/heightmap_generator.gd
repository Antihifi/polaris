@tool
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
const CLIFF_FREQUENCY: float = 0.006  # Cliff ridges (full strength for coastal areas)
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
const INLET_WIDTH_PIXELS: int = 80  # ~200m wide cove mouth at 2.5m/pixel
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
## If config is null, uses const defaults
static func generate_heightmap(
	width_px: int,
	height_px: int,
	island_mask: Image,
	height_rng: RandomNumberGenerator,
	config: Resource = null
) -> Image:
	var heightmap := Image.create(width_px, height_px, false, Image.FORMAT_RF)

	# Extract config values (use const defaults if no config)
	var cfg_max_mountain_height: float = config.max_mountain_height if config else MAX_MOUNTAIN_HEIGHT
	var cfg_max_hill_height: float = config.max_hill_height if config else MAX_HILL_HEIGHT
	var cfg_base_terrain_amplitude: float = config.base_terrain_amplitude if config else BASE_TERRAIN_AMPLITUDE
	var cfg_detail_amplitude: float = config.detail_amplitude if config else DETAIL_AMPLITUDE
	var cfg_ice_level: float = config.ice_level if config else ICE_LEVEL
	var cfg_beach_height: float = config.beach_height if config else BEACH_HEIGHT

	var cfg_base_frequency: float = config.base_frequency if config else BASE_FREQUENCY
	var cfg_hill_frequency: float = config.hill_frequency if config else HILL_FREQUENCY
	var cfg_mountain_frequency: float = config.mountain_frequency if config else MOUNTAIN_FREQUENCY
	var cfg_detail_frequency: float = config.detail_frequency if config else DETAIL_FREQUENCY
	var cfg_cliff_frequency: float = config.cliff_frequency if config else CLIFF_FREQUENCY
	var cfg_octaves: int = config.octaves if config else OCTAVES
	var cfg_persistence: float = config.persistence if config else PERSISTENCE
	var cfg_lacunarity: float = config.lacunarity if config else LACUNARITY

	var cfg_ridge_frequency: float = config.ridge_frequency if config else 0.008
	var cfg_ridge_amplitude: float = config.ridge_amplitude if config else 0.3
	var cfg_use_ridged_noise: bool = config.use_ridged_noise if config else true
	var cfg_valley_frequency: float = config.valley_frequency if config else 0.005
	var cfg_valley_cut_strength: float = config.valley_cut_strength if config else 0.3
	var cfg_erosion_frequency: float = config.erosion_frequency if config else 0.012

	var cfg_coastal_cliff_strength: float = config.coastal_cliff_strength if config else 0.3
	var cfg_mountain_cliff_strength: float = config.mountain_cliff_strength if config else 0.5
	var cfg_midland_cliff_strength: float = config.midland_cliff_strength if config else 0.0

	var cfg_mountain_band_center: float = config.mountain_band_center if config else MOUNTAIN_BAND_CENTER
	var cfg_mountain_band_width: float = config.mountain_band_width if config else MOUNTAIN_BAND_WIDTH
	var cfg_flat_plains_start: float = config.flat_plains_start if config else FLAT_PLAINS_START
	var cfg_beach_start: float = config.beach_start if config else BEACH_START
	var cfg_midland_start: float = config.midland_start if config else 0.35
	var cfg_midland_hill_smoothing: float = config.midland_hill_smoothing if config else 0.7

	# Get peak positions from config or use defaults
	var cfg_peak_positions: Array = []
	if config and config.has_method("get_peak_positions"):
		cfg_peak_positions = config.get_peak_positions()
	else:
		cfg_peak_positions = PEAK_POSITIONS

	# Create noise instances for different terrain features
	var base_noise := _create_noise(height_rng.randi(), cfg_base_frequency, cfg_octaves, cfg_persistence, cfg_lacunarity)
	var hill_noise := _create_noise(height_rng.randi(), cfg_hill_frequency, 2, cfg_persistence, cfg_lacunarity)
	var mountain_noise := _create_noise(height_rng.randi(), cfg_mountain_frequency, 3, cfg_persistence, cfg_lacunarity)
	var detail_noise := _create_noise(height_rng.randi(), cfg_detail_frequency, 2, cfg_persistence, cfg_lacunarity)

	# Cliff noise for jagged ridge features (higher frequency, more dramatic)
	var cliff_noise := _create_noise(height_rng.randi(), cfg_cliff_frequency, 4, cfg_persistence, cfg_lacunarity)
	var cliff_detail := _create_noise(height_rng.randi(), cfg_cliff_frequency * 2.0, 3, cfg_persistence, cfg_lacunarity)

	# Ridge noise for creating cliff-like features in mountain band
	var ridge_noise := _create_noise(height_rng.randi(), 0.004, 2, cfg_persistence, cfg_lacunarity)

	# Warp noise for breaking up uniform patterns
	var warp_noise := _create_noise(height_rng.randi(), 0.003, 2, cfg_persistence, cfg_lacunarity)

	# NEW: Ridge/valley noise for non-conical mountain shapes
	var ridge_pattern := _create_noise(height_rng.randi(), cfg_ridge_frequency, 2, cfg_persistence, cfg_lacunarity)
	var valley_noise := _create_noise(height_rng.randi(), cfg_valley_frequency, 3, cfg_persistence, cfg_lacunarity)
	var erosion_noise := _create_noise(height_rng.randi(), cfg_erosion_frequency, 2, cfg_persistence, cfg_lacunarity)

	# Biome boundary noise - warps the latitude lines to prevent straight seams
	var boundary_noise := _create_noise(height_rng.randi(), 0.006, 2, cfg_persistence, cfg_lacunarity)
	var boundary_noise_fine := _create_noise(height_rng.randi(), 0.015, 2, cfg_persistence, cfg_lacunarity)

	for y in range(height_px):
		for x in range(width_px):
			var mask_value: float = island_mask.get_pixel(x, y).r

			# Outside island: flat ice
			if mask_value < 0.01:
				heightmap.set_pixel(x, y, Color(cfg_ice_level, 0.0, 0.0, 1.0))
				continue

			# Normalized coordinates (0 = north/west, 1 = south/east)
			var ny := float(y) / float(height_px)
			var nx := float(x) / float(width_px)

			# === WARP BIOME BOUNDARIES with noise to prevent straight lines ===
			# Large-scale warping (broad curves in the boundary)
			var boundary_warp := boundary_noise.get_noise_2d(float(x), float(y)) * 0.08
			# Fine-scale warping (jagged edges)
			var boundary_warp_fine := boundary_noise_fine.get_noise_2d(float(x), float(y)) * 0.03
			# Combined warp applied to latitude for biome calculations
			var ny_warped := ny + boundary_warp + boundary_warp_fine

			# ========== REGIONAL HEIGHT CALCULATION ==========

			# 1. Base terrain (gentle undulation everywhere)
			var base_height := base_noise.get_noise_2d(float(x), float(y))
			base_height = (base_height + 1.0) * 0.5  # Normalize to 0-1
			base_height *= cfg_base_terrain_amplitude

			# 2. Hill layer (rolling hills - SMOOTHER in midlands for navigation)
			var hill_raw := hill_noise.get_noise_2d(float(x), float(y))
			hill_raw = (hill_raw + 1.0) * 0.5

			# Reduce hills in southern flat plains region (use warped NY for organic boundary)
			var hill_reduction: float = 1.0
			if ny_warped > cfg_flat_plains_start:
				# Smooth transition over a wider band instead of hard cutoff
				var plains_blend := (ny_warped - cfg_flat_plains_start) / (1.0 - cfg_flat_plains_start)
				plains_blend = clampf(plains_blend, 0.0, 1.0)
				# Smoothstep for gradual transition
				plains_blend = plains_blend * plains_blend * (3.0 - 2.0 * plains_blend)
				hill_reduction = lerpf(1.0, 0.2, plains_blend)

			# ALSO reduce hills in midlands (between mountains and plains) for smoother terrain
			# This creates the navigable corridor zone (use warped NY)
			var midland_end := cfg_flat_plains_start  # Before flat plains
			if ny_warped > cfg_midland_start and ny_warped < midland_end:
				# Midlands get reduced hills for smoother traversal (configurable)
				var midland_progress := (ny_warped - cfg_midland_start) / (midland_end - cfg_midland_start)
				# Peak reduction in middle of midlands, less at edges
				var midland_smoothing := sin(midland_progress * PI) * cfg_midland_hill_smoothing
				hill_reduction *= (1.0 - midland_smoothing)

			var hill_height := hill_raw * cfg_max_hill_height * mask_value * hill_reduction

			# 3. DISTINCT MOUNTAIN PEAKS WITH RIDGES (not conical!)
			# Uses ridged noise and domain warping for realistic alpine terrain
			var peak_height := 0.0
			for peak in cfg_peak_positions:
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
					var ridge_val: float
					if cfg_use_ridged_noise:
						ridge_val = 1.0 - absf(ridge_raw)  # Ridges where noise crosses zero
						ridge_val = ridge_val * ridge_val  # Sharpen the ridges
					else:
						# Standard smooth noise (no castle walls)
						ridge_val = (ridge_raw + 1.0) * 0.5

					# === DOMAIN WARPING to break up uniformity ===
					var warp_x := warp_noise.get_noise_2d(float(x), float(y)) * 100.0
					var warp_y := warp_noise.get_noise_2d(float(x) + 500.0, float(y)) * 100.0
					var warped_ridge := ridge_pattern.get_noise_2d(float(x) + warp_x, float(y) + warp_y)
					var warped_val: float
					if cfg_use_ridged_noise:
						warped_val = 1.0 - absf(warped_ridge)
						warped_val = warped_val * warped_val
					else:
						warped_val = (warped_ridge + 1.0) * 0.5

					# Combine both ridge patterns
					var combined_ridge := maxf(ridge_val, warped_val * 0.8)

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
					var ridge_boost := combined_ridge * ridge_influence * cfg_ridge_amplitude
					var valley_cut := valley_factor * ridge_influence * cfg_valley_cut_strength

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
			# Use warped NY for organic mountain band boundary
			var mountain_height := 0.0
			var mountain_dist := absf(ny_warped - cfg_mountain_band_center) / cfg_mountain_band_width
			if mountain_dist < 1.0:
				# Smoother falloff at mountain band edges using smoothstep
				var mountain_factor := 1.0 - mountain_dist
				mountain_factor = mountain_factor * mountain_factor * (3.0 - 2.0 * mountain_factor)  # smoothstep

				# Center of island has stronger mountains (avoid edges)
				var center_x_factor := 1.0 - absf(nx - 0.5) * 2.0
				center_x_factor = clampf(center_x_factor, 0.2, 1.0)
				mountain_factor *= center_x_factor

				var mtn_raw := mountain_noise.get_noise_2d(float(x), float(y))
				mtn_raw = (mtn_raw + 1.0) * 0.5
				mtn_raw = mtn_raw * mtn_raw * mtn_raw

				mountain_height = mtn_raw * cfg_max_hill_height * 1.5 * mountain_factor * mask_value

			# 5. CLIFF RIDGES - Full jagged cliffs on COAST, smoother in MIDLANDS
			# Coastal cliffs (mask_value 0.5-0.8) should be JAGGED
			# Midlands (interior, ny 0.35-0.65) should have OCCASIONAL sparse cliffs only
			# Use ny_warped for organic biome boundaries
			var cliff_height := 0.0
			if ny_warped < cfg_flat_plains_start and mask_value > 0.5:
				# Domain warp for natural cliff shapes (jagged look)
				var warp_offset_x := cliff_detail.get_noise_2d(float(x) * 0.5, float(y) * 0.5) * 40.0
				var warp_offset_y := cliff_detail.get_noise_2d(float(x) * 0.5 + 100.0, float(y) * 0.5) * 40.0
				var cliff_raw := cliff_noise.get_noise_2d(float(x) + warp_offset_x, float(y) + warp_offset_y)

				# Determine if we're in COASTAL zone vs MIDLANDS zone (use warped boundaries)
				# Coastal: near edges (mask_value < 0.8) OR in mountain band (ny_warped < cfg_midland_start)
				# Midlands: interior terrain (mask_value > 0.8) AND (ny_warped between midland_start and flat_plains)
				var is_coastal := mask_value < 0.8 or ny_warped < cfg_midland_start
				var is_midlands := mask_value > 0.8 and ny_warped > cfg_midland_start and ny_warped < midland_end

				var cliff_factor: float
				var cliff_strength: float

				if is_coastal:
					# COASTAL CLIFFS: Full jagged noise, no thresholding
					cliff_factor = (cliff_raw + 1.0) * 0.5  # Full 0-1 range
					var cliff_detail_val := cliff_detail.get_noise_2d(float(x), float(y))
					cliff_detail_val = (cliff_detail_val + 1.0) * 0.5 * 0.3
					cliff_factor = cliff_factor * cliff_factor + cliff_detail_val

					# Strong cliffs in mountain band, medium elsewhere on coast
					cliff_strength = cfg_coastal_cliff_strength
					if mountain_dist < 1.0:
						cliff_strength = cfg_mountain_cliff_strength * (1.0 - mountain_dist)
				elif is_midlands:
					# MIDLANDS: Use configurable cliff strength (default 0 = smooth)
					cliff_factor = (cliff_raw + 1.0) * 0.5
					cliff_factor = cliff_factor * cliff_factor
					cliff_strength = cfg_midland_cliff_strength
				else:
					# Fallback (shouldn't reach here often)
					cliff_factor = (cliff_raw + 1.0) * 0.5
					cliff_factor = cliff_factor * cliff_factor
					cliff_strength = 0.2

				cliff_height = cliff_factor * cfg_max_hill_height * cliff_strength * mask_value

			# Combine peak and mountain heights (take max to preserve distinct peaks)
			var total_mountain := maxf(peak_height, mountain_height + cliff_height)

			# 5.5. TRAVERSABLE VALLEYS (midland corridors for navigation)
			# Creates gentler passages through the midland terrain for pathfinding
			# These are WIDE valleys that create the primary navigation network
			# Use ny_warped for organic valley boundaries
			var valley_reduction := 0.0
			if ny_warped > 0.20 and ny_warped < cfg_flat_plains_start and mask_value > 0.3:
				# Use lower frequency for WIDER valley corridors
				var valley_corridor := valley_noise.get_noise_2d(float(x) * 0.5, float(y) * 0.5)

				# Create valleys where noise crosses zero (absolute value trick, inverted)
				var valley_strength := absf(valley_corridor)
				valley_strength = 1.0 - valley_strength  # Valleys where noise ~ 0

				# Softer valley edges (less sharpening than before)
				valley_strength = pow(valley_strength, 1.5)  # Gentler than squaring

				# Lower threshold = MORE valleys (was 0.3)
				if valley_strength > 0.2:
					# Normalize to 0-1 range from the 0.2-1.0 range
					var normalized := (valley_strength - 0.2) / 0.8

					# Valley depth varies: deeper in midlands, shallower near edges (use warped)
					var midland_factor := 1.0 - absf(ny_warped - 0.45) * 2.5  # Wider influence
					midland_factor = clampf(midland_factor, 0.2, 1.0)

					# Also reduce depth near island edges (X axis)
					var edge_factor := 1.0 - absf(nx - 0.5) * 2.5  # Wider influence
					edge_factor = clampf(edge_factor, 0.3, 1.0)

					# Maximum valley depth: 45% of local height
					# This creates more pronounced, navigable valleys
					valley_reduction = normalized * 0.45 * midland_factor * edge_factor

			# 6. Northern region boost (rugged, higher elevation)
			# Use warped NY for organic north boundary
			var north_boost := 0.0
			if ny_warped < 0.3:
				var north_factor := (0.3 - ny_warped) / 0.3  # 1.0 at north edge, 0.0 at ny=0.3
				# Smoothstep for gradual transition
				north_factor = north_factor * north_factor * (3.0 - 2.0 * north_factor)
				north_boost = north_factor * 50.0 * mask_value  # +50m max at north edge

			# 7. Southern slope and beach (gentle descent)
			# Use warped NY for organic south transition
			var south_reduction := 0.0
			if ny_warped > cfg_flat_plains_start:
				var south_factor := (ny_warped - cfg_flat_plains_start) / (1.0 - cfg_flat_plains_start)
				south_factor = clampf(south_factor, 0.0, 1.0)
				# Smoothstep for gradual transition
				south_factor = south_factor * south_factor * (3.0 - 2.0 * south_factor)
				south_reduction = south_factor * 0.5  # Reduce height by up to 50%

				# Beach zone: flatten even more (use warped)
				if ny_warped > cfg_beach_start:
					var beach_factor := (ny_warped - cfg_beach_start) / (1.0 - cfg_beach_start)
					beach_factor = clampf(beach_factor, 0.0, 1.0)
					beach_factor = beach_factor * beach_factor * (3.0 - 2.0 * beach_factor)
					south_reduction = lerpf(south_reduction, 0.85, beach_factor)

			# 8. Detail noise (micro-terrain, subtle)
			var detail := detail_noise.get_noise_2d(float(x), float(y)) * cfg_detail_amplitude

			# ========== COMBINE HEIGHT COMPONENTS ==========
			var height := base_height + hill_height + total_mountain + north_boost + detail

			# Apply valley reduction for traversable corridors
			# Valley carving happens AFTER mountain heights to create passages through terrain
			if valley_reduction > 0.0:
				height *= (1.0 - valley_reduction)

			# Apply southern slope reduction
			height *= (1.0 - south_reduction)

			# Beach zone: lerp towards beach height (use warped for organic coastline)
			if ny_warped > cfg_beach_start:
				var beach_blend := (ny_warped - cfg_beach_start) / (1.0 - cfg_beach_start)
				beach_blend = clampf(beach_blend, 0.0, 1.0)
				beach_blend = beach_blend * beach_blend  # Smooth transition
				height = lerpf(height, cfg_beach_height, beach_blend * 0.7)

			# Fade to ice level at island edges using mask
			height = lerpf(cfg_ice_level, height, mask_value)

			# Ensure minimum walkable height on solid island
			if mask_value > 0.5:
				height = maxf(height, 2.0)

			heightmap.set_pixel(x, y, Color(height, 0.0, 0.0, 1.0))

	return heightmap


## Carve a MEANDERING channel from the FROZEN SEA through the coastline INTO the island.
## The channel curves naturally like a real waterway that froze over, not a rectangular cutout.
## Also carves a gentle ramp at the inland end to ensure units can climb out.
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

	# Base direction from coastline INTO the island (roughly south)
	var base_direction := Vector2(
		float(spawn_pixel.x - coastline_pixel.x),
		float(spawn_pixel.y - coastline_pixel.y)
	)
	if base_direction.length() < 1.0:
		base_direction = Vector2(0, 1)  # Default: straight south into island
	base_direction = base_direction.normalized()

	# Calculate START POINT - extend PAST coastline into frozen sea
	var sea_extension := 150  # ~375m out into frozen sea
	var sea_start := Vector2(coastline_pixel) - base_direction * float(sea_extension)

	# Total length of the channel
	var total_length := float(INLET_LENGTH_PIXELS) + float(sea_extension)

	# === GENERATE MEANDERING WAYPOINTS ===
	# Create a series of waypoints that curve naturally
	var waypoints: Array[Vector2] = []
	var num_segments := 8  # More segments = smoother curve
	var meander_amplitude := 40.0  # How far the channel can deviate sideways (pixels)

	# Perpendicular to base direction for meandering
	var perp_base := Vector2(-base_direction.y, base_direction.x)

	for i in range(num_segments + 1):
		var t := float(i) / float(num_segments)
		var base_pos := sea_start + base_direction * (t * total_length)

		# Add meandering offset using smooth noise-like function
		# Use multiple sine waves with different frequencies for natural look
		var meander_offset := 0.0
		meander_offset += sin(t * PI * 2.0 + inlet_rng.randf() * TAU) * 0.5
		meander_offset += sin(t * PI * 3.5 + inlet_rng.randf() * TAU) * 0.3
		meander_offset += sin(t * PI * 5.0 + inlet_rng.randf() * TAU) * 0.2

		# Reduce meandering at the very start (in the sea) and end (landing area)
		var meander_strength := 1.0
		if t < 0.15:
			meander_strength = t / 0.15  # Fade in from sea
		elif t > 0.85:
			meander_strength = (1.0 - t) / 0.15  # Fade out at landing

		var offset := perp_base * meander_offset * meander_amplitude * meander_strength
		waypoints.append(base_pos + offset)

	# Calculate bounding box for the channel (with generous margin for meandering)
	var margin := INLET_WIDTH_PIXELS + INLET_BLEND_RADIUS * 2 + int(meander_amplitude)
	var min_x := img_width
	var max_x := 0
	var min_y := img_height
	var max_y := 0
	for wp in waypoints:
		min_x = mini(min_x, int(wp.x) - margin)
		max_x = maxi(max_x, int(wp.x) + margin)
		min_y = mini(min_y, int(wp.y) - margin)
		max_y = maxi(max_y, int(wp.y) + margin)

	min_x = clampi(min_x, 0, img_width - 1)
	max_x = clampi(max_x, 0, img_width - 1)
	min_y = clampi(min_y, 0, img_height - 1)
	max_y = clampi(max_y, 0, img_height - 1)

	print("[HeightmapGenerator] Carving MEANDERING inlet channel:")
	print("  Sea start: (%.0f, %.0f), Spawn: (%d, %d)" % [sea_start.x, sea_start.y, spawn_pixel.x, spawn_pixel.y])
	print("  Waypoints: %d, Total length: %.0f px" % [waypoints.size(), total_length])
	print("  Bounding box: (%d,%d) to (%d,%d)" % [min_x, min_y, max_x, max_y])

	var pixels_modified := 0

	# For each pixel, find distance to the nearest point on the meandering path
	for py in range(min_y, max_y + 1):
		for px in range(min_x, max_x + 1):
			var pixel_pos := Vector2(float(px), float(py))

			# Find closest point on the meandering path (check each segment)
			var min_dist := INF
			var best_progress := 0.0  # 0 = sea mouth, 1 = inland end

			for seg_idx in range(waypoints.size() - 1):
				var seg_start := waypoints[seg_idx]
				var seg_end := waypoints[seg_idx + 1]
				var seg_dir := seg_end - seg_start
				var seg_len := seg_dir.length()
				if seg_len < 0.001:
					continue
				seg_dir /= seg_len

				# Project pixel onto this segment
				var to_pixel := pixel_pos - seg_start
				var along_seg := clampf(to_pixel.dot(seg_dir), 0.0, seg_len)
				var closest_point := seg_start + seg_dir * along_seg
				var dist := pixel_pos.distance_to(closest_point)

				if dist < min_dist:
					min_dist = dist
					# Calculate overall progress along the full path
					var seg_progress := float(seg_idx) / float(num_segments)
					var within_seg := along_seg / seg_len / float(num_segments)
					best_progress = seg_progress + within_seg

			# Skip pixels too far from the channel
			var max_channel_dist := float(INLET_WIDTH_PIXELS) + float(INLET_BLEND_RADIUS) * 1.5
			if min_dist > max_channel_dist:
				continue

			# Channel width varies: widest at mouth, tapers inland
			var width_factor := 1.0 - best_progress * 0.35
			var half_width := float(INLET_WIDTH_PIXELS) * width_factor * 0.5

			# Floor height: rises gently from sea to inland
			var floor_height: float
			if best_progress < 0.2:
				# Sea section: flat frozen sea level
				floor_height = FROZEN_SEA_HEIGHT + 0.5
			elif best_progress < 0.9:
				# Main channel: gradual rise
				var rise_progress := (best_progress - 0.2) / 0.7
				floor_height = lerpf(FROZEN_SEA_HEIGHT + 0.5, INLET_FLOOR_HEIGHT + 2.0, rise_progress * rise_progress)
			else:
				# Inland terminus: level landing area
				floor_height = INLET_FLOOR_HEIGHT + 2.0

			# Calculate influence using SMOOTH FALLOFF
			var influence: float = 0.0

			if min_dist < half_width * 0.6:
				# Core area: full influence (flat floor)
				influence = 1.0
			elif min_dist < half_width + float(INLET_BLEND_RADIUS):
				# Transition zone: smooth falloff using cosine interpolation
				var edge_start := half_width * 0.6
				var edge_end := half_width + float(INLET_BLEND_RADIUS)
				var t := (min_dist - edge_start) / (edge_end - edge_start)
				t = clampf(t, 0.0, 1.0)
				influence = 0.5 * (1.0 + cos(t * PI))

			if influence < 0.001:
				continue

			# Get current height and apply smooth blend
			var current_height: float = heightmap.get_pixel(px, py).r

			# Only carve DOWN, never raise terrain
			if current_height > floor_height:
				var new_height := lerpf(current_height, floor_height, influence)
				heightmap.set_pixel(px, py, Color(new_height, 0.0, 0.0, 1.0))
				pixels_modified += 1

	print("[HeightmapGenerator] Meandering channel carving: %d pixels modified" % pixels_modified)

	# === CARVE WALKABLE RAMP at inland end ===
	# Create a gentle slope leading from the inlet floor up to the island terrain
	var ramp_start := waypoints[waypoints.size() - 1]  # Inland terminus
	var ramp_direction := base_direction  # Continue in same general direction
	var ramp_length := 120.0  # ~300m ramp
	var ramp_width := float(INLET_WIDTH_PIXELS) * 0.8  # Slightly narrower than channel

	_carve_walkable_ramp(heightmap, ramp_start, ramp_direction, ramp_length, ramp_width, inlet_rng)

	# Final pass: Gaussian blur on the carved region to smooth transitions
	_gaussian_blur_region(heightmap, min_x, min_y, max_x, max_y, 3)

	# Ensure the frozen sea buffer around the island is FLAT
	_ensure_flat_frozen_sea(heightmap, island_mask)

	# Calculate world position for SHIP spawn point
	# Ship should be in the FROZEN CHANNEL - past the coastline but before the inland ramp.
	# The waypoints go: sea_start (0%) -> coastline (~27%) -> inland terminus (100%)
	# Sea extension is 150px, total length is ~550px, so coastline is at ~27%.
	# Use waypoint at ~45% - this places the ship:
	#   - Well past the coastline (inside the inlet)
	#   - In the frozen ice/snow channel (not on the gravel ramp which starts ~70%)
	#   - At low elevation (proper "trapped in ice" aesthetic)
	var ship_waypoint_index := int(waypoints.size() * 0.45)  # 45% = solidly inside inlet channel
	var ship_waypoint := waypoints[ship_waypoint_index]
	var meters_per_pixel: float = TerrainGenerator.METERS_PER_PIXEL
	var world_x := (ship_waypoint.x - float(img_width) / 2.0) * meters_per_pixel
	var world_z := (ship_waypoint.y - float(img_height) / 2.0) * meters_per_pixel
	# Ship sits at frozen sea level (not the higher inland floor height)
	var world_y := FROZEN_SEA_HEIGHT + 2.0

	# Also return inland terminus for unit spawning (units start near ship but can walk inland)
	var inland_terminus := waypoints[waypoints.size() - 1]

	return {
		"position": Vector3(world_x, world_y, world_z),
		"pixel_position": Vector2i(int(ship_waypoint.x), int(ship_waypoint.y)),
		"coastline_pixel": coastline_pixel,
		"sea_start_pixel": Vector2i(int(sea_start.x), int(sea_start.y)),
		"east_side": east_side,
		"cove_width_meters": INLET_WIDTH_PIXELS * meters_per_pixel,
		"waypoints": waypoints,
		"inland_terminus": Vector2i(int(inland_terminus.x), int(inland_terminus.y))
	}


## Carve a gentle walkable ramp from the inlet floor up to the surrounding terrain.
## This ensures units can always climb out of the inlet.
static func _carve_walkable_ramp(
	heightmap: Image,
	start_pos: Vector2,
	direction: Vector2,
	length: float,
	width: float,
	ramp_rng: RandomNumberGenerator
) -> void:
	var img_width := heightmap.get_width()
	var img_height := heightmap.get_height()

	var perp := Vector2(-direction.y, direction.x)
	var half_width := width * 0.5

	# Get the starting height (inlet floor)
	var start_x := clampi(int(start_pos.x), 0, img_width - 1)
	var start_y := clampi(int(start_pos.y), 0, img_height - 1)
	var start_height: float = heightmap.get_pixel(start_x, start_y).r

	# Find the target height at the end of the ramp (sample terrain ahead)
	var end_pos := start_pos + direction * length
	var end_x := clampi(int(end_pos.x), 0, img_width - 1)
	var end_y := clampi(int(end_pos.y), 0, img_height - 1)
	var target_height: float = heightmap.get_pixel(end_x, end_y).r

	# Ensure the ramp goes UP (if terrain is lower, just level it)
	if target_height < start_height + 5.0:
		target_height = start_height + 10.0  # Minimum 10m rise

	# Maximum slope for walkability: ~30 degrees = tan(30) * horizontal = 0.577 * horizontal
	# For a gentle ramp, use ~20 degrees = tan(20) * horizontal = 0.364 * horizontal
	var max_slope := 0.35
	var height_diff := target_height - start_height
	var min_length_needed := height_diff / max_slope
	var actual_length := maxf(length, min_length_needed)

	print("[HeightmapGenerator] Carving walkable ramp: %.0f px long, %.1fm rise" % [actual_length, height_diff])

	# Carve the ramp
	var margin := int(half_width) + 20
	var min_x := clampi(int(minf(start_pos.x, end_pos.x)) - margin, 0, img_width - 1)
	var max_x := clampi(int(maxf(start_pos.x, end_pos.x)) + margin, 0, img_width - 1)
	var min_y := clampi(int(minf(start_pos.y, end_pos.y)) - margin, 0, img_height - 1)
	var max_y := clampi(int(maxf(start_pos.y, end_pos.y)) + margin, 0, img_height - 1)

	for py in range(min_y, max_y + 1):
		for px in range(min_x, max_x + 1):
			var pixel_pos := Vector2(float(px), float(py))
			var to_pixel := pixel_pos - start_pos

			# Project onto ramp direction
			var along_ramp := to_pixel.dot(direction)
			var across_ramp := absf(to_pixel.dot(perp))

			# Skip if outside ramp bounds
			if along_ramp < -10 or along_ramp > actual_length + 10:
				continue
			if across_ramp > half_width + 30:
				continue

			var progress := clampf(along_ramp / actual_length, 0.0, 1.0)

			# Ramp height: smooth interpolation from start to target
			# Use smoothstep for gradual start and end
			var smooth_progress := progress * progress * (3.0 - 2.0 * progress)
			var ramp_height := lerpf(start_height, target_height, smooth_progress)

			# Width falloff: full width at center, taper at edges
			var width_influence: float = 1.0
			if across_ramp > half_width * 0.5:
				var edge_t := (across_ramp - half_width * 0.5) / (half_width * 0.5 + 30.0)
				edge_t = clampf(edge_t, 0.0, 1.0)
				width_influence = 0.5 * (1.0 + cos(edge_t * PI))

			# Blend influence: stronger at start, gentler at end
			var blend_strength := lerpf(0.95, 0.6, progress) * width_influence

			var current_height: float = heightmap.get_pixel(px, py).r

			# Only modify if we're lowering terrain OR if current is too steep
			if current_height > ramp_height:
				var new_height := lerpf(current_height, ramp_height, blend_strength)
				heightmap.set_pixel(px, py, Color(new_height, 0.0, 0.0, 1.0))


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
static func _create_noise(seed_val: int, frequency: float, octaves: int, persistence: float = PERSISTENCE, lacunarity: float = LACUNARITY) -> FastNoiseLite:
	var noise := FastNoiseLite.new()
	noise.seed = seed_val
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = octaves
	noise.fractal_gain = persistence  # Was fractal_persistence in Godot 3.x
	noise.fractal_lacunarity = lacunarity
	noise.frequency = frequency
	return noise
