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
const OCTAVES: int = 3
const PERSISTENCE: float = 0.4
const LACUNARITY: float = 2.0

## Regional parameters (normalized Y: 0=north, 1=south)
const MOUNTAIN_BAND_CENTER: float = 0.4  # Mountains concentrated in central-north
const MOUNTAIN_BAND_WIDTH: float = 0.25  # Width of mountain band
const FLAT_PLAINS_START: float = 0.6  # Where flat plains begin (south-central)
const BEACH_START: float = 0.85  # Where beaches begin (southern edge)

## Inlet/River carving parameters
## Creates an erosion-style river valley from coastline into island
const INLET_WIDTH_PIXELS: int = 60  # ~150m wide river mouth at 2.5m/pixel
const INLET_LENGTH_PIXELS: int = 200  # ~500m long river carving into island
const INLET_FLOOR_HEIGHT: float = 3.0  # River floor height (above sea level for ship)
const FROZEN_SEA_HEIGHT: float = -2.0  # Flat frozen sea level around island


## Generate the heightmap based on island mask
## Returns Image with FORMAT_RF (32-bit float, height in meters)
## Creates terrain with:
##   - Northern region: rugged, higher elevation
##   - Central region: mountain band with peaks up to 350m
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

	# Ridge noise for creating cliff-like features in mountain band
	var ridge_noise := _create_noise(height_rng.randi(), 0.004, 2)

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

			# 3. Mountain band (concentrated in central-north area)
			var mountain_height := 0.0
			var mountain_dist := absf(ny - MOUNTAIN_BAND_CENTER) / MOUNTAIN_BAND_WIDTH
			if mountain_dist < 1.0:
				# Inside mountain band
				var mountain_factor := 1.0 - mountain_dist  # Linear falloff from center
				mountain_factor *= mountain_factor  # Squared for smoother edges

				# Center of island has stronger mountains (avoid edges)
				var center_x_factor := 1.0 - absf(nx - 0.5) * 2.0
				center_x_factor = clampf(center_x_factor, 0.2, 1.0)
				mountain_factor *= center_x_factor

				# Mountain noise (can create peaks)
				var mtn_raw := mountain_noise.get_noise_2d(float(x), float(y))
				mtn_raw = (mtn_raw + 1.0) * 0.5
				mtn_raw = mtn_raw * mtn_raw * mtn_raw  # Cubed for sharper peaks

				# Ridge enhancement for cliff-like features
				var ridge_raw := ridge_noise.get_noise_2d(float(x), float(y))
				ridge_raw = absf(ridge_raw)  # Creates ridge patterns
				var ridge_boost := ridge_raw * ridge_raw * 0.4  # Subtle ridge enhancement

				mountain_height = mtn_raw * MAX_MOUNTAIN_HEIGHT * mountain_factor * mask_value
				mountain_height += ridge_boost * MAX_MOUNTAIN_HEIGHT * mountain_factor * mask_value

			# 4. Northern region boost (rugged, higher elevation)
			var north_boost := 0.0
			if ny < 0.3:
				var north_factor := (0.3 - ny) / 0.3  # 1.0 at north edge, 0.0 at ny=0.3
				north_boost = north_factor * 40.0 * mask_value  # +40m max at north edge

			# 5. Southern slope and beach (gentle descent)
			var south_reduction := 0.0
			if ny > FLAT_PLAINS_START:
				var south_factor := (ny - FLAT_PLAINS_START) / (1.0 - FLAT_PLAINS_START)
				south_reduction = south_factor * 0.5  # Reduce height by up to 50%

				# Beach zone: flatten even more
				if ny > BEACH_START:
					var beach_factor := (ny - BEACH_START) / (1.0 - BEACH_START)
					# Force height towards BEACH_HEIGHT in beach zone
					south_reduction = lerpf(south_reduction, 0.85, beach_factor)

			# 6. Detail noise (micro-terrain, subtle)
			var detail := detail_noise.get_noise_2d(float(x), float(y)) * DETAIL_AMPLITUDE

			# ========== COMBINE HEIGHT COMPONENTS ==========
			var height := base_height + hill_height + mountain_height + north_boost + detail

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


## Carve an inlet/river valley from the coastline INTO the island.
## Uses erosion-style carving: starts wide at coast, tapers inland.
## The river valley creates gentle slopes for navigation.
## Modifies the heightmap in place.
## Returns Dictionary with inlet position info.
static func carve_inlet(
	heightmap: Image,
	island_mask: Image,
	inlet_rng: RandomNumberGenerator
) -> Dictionary:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	# Get inlet position from island shape analysis
	# This now returns both the coastline point AND the spawn point
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

	# Add slight curve to river (randomized)
	var curve_factor := inlet_rng.randf_range(-0.15, 0.15)

	# Carve the river valley from coastline to spawn point (and a bit beyond)
	var total_length := coastline_pixel.distance_to(spawn_pixel) + INLET_LENGTH_PIXELS * 0.3
	total_length = maxf(total_length, INLET_LENGTH_PIXELS)

	print("[HeightmapGenerator] Carving inlet river from (%d,%d) to (%d,%d), length=%.0f px" % [
		coastline_pixel.x, coastline_pixel.y, spawn_pixel.x, spawn_pixel.y, total_length])

	for dist in range(int(total_length)):
		# Progress along river (0 = coast, 1 = end)
		var progress := float(dist) / total_length

		# Apply curve to direction
		var curved_dir := direction.rotated(curve_factor * sin(progress * PI))

		# Current position along river
		var river_pos := Vector2(coastline_pixel) + curved_dir * float(dist)
		var px := int(river_pos.x)
		var py := int(river_pos.y)

		if px < 0 or px >= width or py < 0 or py >= height:
			continue

		# River width: wide at mouth, narrower inland (but still navigable)
		# Mouth is ~150m (60px), narrows to ~80m (32px) inland
		var width_factor := 1.0 - progress * 0.5  # Tapers to 50% of original width
		var current_width := int(INLET_WIDTH_PIXELS * width_factor)
		current_width = maxi(current_width, 32)  # Minimum 80m wide for ship

		# River floor height: rises slightly inland (but stays flat for ship)
		var floor_height := lerpf(INLET_FLOOR_HEIGHT, INLET_FLOOR_HEIGHT + 3.0, progress)

		# Carve across the width of the river
		for w in range(-current_width, current_width + 1):
			# Perpendicular direction
			var perp := Vector2(-curved_dir.y, curved_dir.x)
			var carve_pos := river_pos + perp * float(w)
			var cx := int(carve_pos.x)
			var cy := int(carve_pos.y)

			if cx < 0 or cx >= width or cy < 0 or cy >= height:
				continue

			# Erosion profile: flat bottom with sloped walls (V-shape valley)
			var dist_from_center := absf(float(w)) / float(current_width)

			# Flat floor in center 40%, then slope up on walls
			var carve_depth: float
			if dist_from_center < 0.4:
				# Flat river floor
				carve_depth = 1.0
			else:
				# Sloped walls (erosion profile)
				var wall_progress := (dist_from_center - 0.4) / 0.6
				carve_depth = 1.0 - (wall_progress * wall_progress)  # Smooth falloff

			var current_height: float = heightmap.get_pixel(cx, cy).r
			var target_height := floor_height

			# Blend based on carve depth
			var new_height := lerpf(current_height, target_height, carve_depth * 0.9)

			# Don't carve below frozen sea level
			new_height = maxf(new_height, FROZEN_SEA_HEIGHT + 1.0)

			heightmap.set_pixel(cx, cy, Color(new_height, 0.0, 0.0, 1.0))

	# Also ensure the frozen sea buffer around the island is FLAT
	_ensure_flat_frozen_sea(heightmap, island_mask)

	# Calculate world position for spawn point
	var meters_per_pixel: float = TerrainGenerator.METERS_PER_PIXEL
	var world_x := (float(spawn_pixel.x) - float(width) / 2.0) * meters_per_pixel
	var world_z := (float(spawn_pixel.y) - float(height) / 2.0) * meters_per_pixel
	var world_y := INLET_FLOOR_HEIGHT + 2.0  # Slightly above river floor

	return {
		"position": Vector3(world_x, world_y, world_z),
		"pixel_position": spawn_pixel,
		"coastline_pixel": coastline_pixel,
		"east_side": east_side,
		"river_width_meters": INLET_WIDTH_PIXELS * meters_per_pixel
	}


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
