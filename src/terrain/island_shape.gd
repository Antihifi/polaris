class_name IslandShape
extends RefCounted
## Generates a teardrop-shaped island mask.
## The mask is a grayscale image where:
## - 1.0 = center of island (most of the terrain)
## - 0.0 = outside island (ice zone, ~500m border on N/E/W)
## - Gradient values = coastline transition
##
## IMPORTANT: The island fills MOST of the terrain (~9x12km).
## The ice wasteland is just a thin border around the edges.

## Ice border width in meters (N/E/W edges only)
const ICE_BORDER_METERS: float = 500.0

## How much the teardrop widens towards the south (0.0 = ellipse, higher = more teardrop)
const TEARDROP_FACTOR: float = 0.25  # Reduced for more natural shape

## How far north the center is shifted (0.5 = centered, lower = more north)
const CENTER_Y_RATIO: float = 0.45

## Coastline noise amplitude (higher = more jagged coastline)
const COAST_NOISE_AMPLITUDE: float = 0.08  # Reduced for smoother coastline

## Falloff parameters for smooth coastline transition
const FALLOFF_OUTER: float = 1.05  # Where falloff starts (just outside base ellipse)
const FALLOFF_INNER: float = 0.85   # Where falloff ends (full island) - narrower transition


## Generate the island shape mask
## Returns Image with FORMAT_RF (32-bit float per pixel)
## The island fills most of the terrain with only ~500m ice border on N/E/W edges.
static func generate_mask(width_px: int, height_px: int, shape_rng: RandomNumberGenerator) -> Image:
	var mask := Image.create(width_px, height_px, false, Image.FORMAT_RF)

	# Create noise for coastline variation
	var coast_noise := FastNoiseLite.new()
	coast_noise.seed = shape_rng.randi()
	coast_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	coast_noise.frequency = 0.012  # Lower frequency for smoother coastline
	coast_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	coast_noise.fractal_octaves = 2  # Fewer octaves for less jagged edges

	# Calculate meters per pixel dynamically from terrain size and resolution
	var terrain_size_meters: float = TerrainGenerator.WORLD_SIZE_METERS  # 10240m
	var meters_per_pixel: float = terrain_size_meters / float(width_px)

	# Ice border in pixels
	var ice_border_px: float = ICE_BORDER_METERS / meters_per_pixel

	# Island fills most of the terrain, with ice border on N/E/W
	# The island is centered but slightly north (teardrop narrow end north)
	var center_x := float(width_px) / 2.0
	var center_y := float(height_px) * CENTER_Y_RATIO

	# Island radii - fill terrain minus ice border
	# X radius: half of width minus ice border on both sides
	var radius_x := (float(width_px) - ice_border_px * 2.0) / 2.0
	# Y radius: most of height, ice border only on north, ocean on south
	var radius_y := (float(height_px) - ice_border_px) / 2.0

	for y in range(height_px):
		for x in range(width_px):
			# Normalize coordinates relative to center (-1 to 1 range within island)
			var nx := (float(x) - center_x) / radius_x
			var ny := (float(y) - center_y) / radius_y

			# Teardrop distortion: narrow at north (ny < 0), wide at south (ny > 0)
			var teardrop := 1.0 + TEARDROP_FACTOR * ny
			nx *= teardrop

			# Distance from center (ellipse equation)
			var dist := sqrt(nx * nx + ny * ny)

			# Get coastline noise (varies the edge slightly)
			var coast_variation := coast_noise.get_noise_2d(float(x), float(y))

			# Apply noise to distance (pushes coastline in/out)
			var noise_offset := coast_variation * COAST_NOISE_AMPLITUDE
			dist -= noise_offset

			# Smooth falloff at edges using smoothstep
			var mask_value := _smoothstep(FALLOFF_OUTER, FALLOFF_INNER, dist)

			# South edge is ocean - make it sharper falloff at bottom
			var south_edge := float(y) / float(height_px)
			if south_edge > 0.92:
				# Blend to 0 at very bottom (ocean)
				var ocean_blend := (south_edge - 0.92) / 0.08
				mask_value *= (1.0 - ocean_blend)

			# Clamp and store
			mask.set_pixel(x, y, Color(clampf(mask_value, 0.0, 1.0), 0.0, 0.0, 1.0))

	return mask


## Attempt to create inlets/fjords on the coastline
## This modifies the mask to add water intrusions
static func add_fjords(mask: Image, fjord_rng: RandomNumberGenerator, num_fjords: int = 2) -> void:
	var width := mask.get_width()
	var height := mask.get_height()

	for _i in range(num_fjords):
		# Pick a random coastal point
		var start_x := fjord_rng.randi_range(int(width * 0.2), int(width * 0.8))
		var start_y := fjord_rng.randi_range(int(height * 0.3), int(height * 0.7))

		# Find the actual coastline from this point
		var coast_point := _find_coastline(mask, start_x, start_y)
		if coast_point == Vector2i(-1, -1):
			continue

		# Carve a fjord inward
		var fjord_length := fjord_rng.randi_range(30, 80)
		var fjord_width := fjord_rng.randi_range(8, 20)
		var direction := Vector2(
			fjord_rng.randf_range(-0.3, 0.3),
			fjord_rng.randf_range(-0.5, 0.5)
		).normalized()

		# Point fjord towards center
		var to_center := Vector2(width / 2.0 - coast_point.x, height / 2.0 - coast_point.y).normalized()
		direction = (direction + to_center * 2.0).normalized()

		_carve_fjord(mask, coast_point, direction, fjord_length, fjord_width)


## Find the nearest coastline point from a starting position
static func _find_coastline(mask: Image, start_x: int, start_y: int) -> Vector2i:
	var width := mask.get_width()
	var height := mask.get_height()

	# Search outward in a spiral pattern
	for radius in range(1, 100):
		for angle_step in range(16):
			var angle := float(angle_step) * TAU / 16.0
			var check_x := start_x + int(cos(angle) * radius)
			var check_y := start_y + int(sin(angle) * radius)

			if check_x < 0 or check_x >= width or check_y < 0 or check_y >= height:
				continue

			var value: float = mask.get_pixel(check_x, check_y).r
			# Coastline is where mask transitions (0.3 to 0.7 range)
			if value > 0.3 and value < 0.7:
				return Vector2i(check_x, check_y)

	return Vector2i(-1, -1)


## Carve a fjord into the mask
static func _carve_fjord(mask: Image, start: Vector2i, direction: Vector2, length: int, width_px: int) -> void:
	var img_width := mask.get_width()
	var img_height := mask.get_height()

	for dist in range(length):
		var pos := Vector2(start) + direction * float(dist)
		var current_width := width_px * (1.0 - float(dist) / float(length) * 0.7)  # Taper

		for w in range(int(-current_width), int(current_width) + 1):
			var perpendicular := Vector2(-direction.y, direction.x)
			var carve_pos := pos + perpendicular * float(w)
			var px := int(carve_pos.x)
			var py := int(carve_pos.y)

			if px < 0 or px >= img_width or py < 0 or py >= img_height:
				continue

			var carve_strength: float = 1.0 - abs(float(w)) / current_width
			var current_value: float = mask.get_pixel(px, py).r
			var new_value := lerpf(current_value, 0.0, carve_strength * 0.8)
			mask.set_pixel(px, py, Color(new_value, 0.0, 0.0, 1.0))


## Find inlet position on the ACTUAL COASTLINE of the north coast.
## The inlet should start AT the coast and carve INTO the island like a river mouth.
## Returns the coastline point where the inlet begins, plus direction into island.
static func find_inlet_position(mask: Image, inlet_rng: RandomNumberGenerator) -> Dictionary:
	var width := mask.get_width()
	var height := mask.get_height()

	# Choose east or west side of north coast
	var east_side := inlet_rng.randf() > 0.5

	# Target X position on north coast (60% or 40% from left)
	var target_x := int(width * (0.60 if east_side else 0.40))

	# FIND THE ACTUAL COASTLINE by scanning from north edge downward
	# The coastline is where mask transitions from 0 (ice) to >0.5 (island)
	var coastline_y := -1
	for y in range(0, height):
		var value: float = mask.get_pixel(target_x, y).r
		if value > 0.3:  # Found the coast transition
			coastline_y = y
			break

	if coastline_y == -1:
		# Fallback: use 15% from north
		coastline_y = int(height * 0.15)
		push_warning("[IslandShape] Could not find coastline at x=%d, using fallback y=%d" % [target_x, coastline_y])

	# Fine-tune: search horizontally for best coastline point
	var best_coast := Vector2i(target_x, coastline_y)
	var best_coast_value := mask.get_pixel(target_x, coastline_y).r

	for dx in range(-100, 100):
		var check_x := target_x + dx
		if check_x < 0 or check_x >= width:
			continue

		# Find coastline at this X
		for y in range(0, height):
			var value: float = mask.get_pixel(check_x, y).r
			if value > 0.3 and value < 0.7:  # Coastline transition zone
				# Prefer points closer to target_x
				var dist_penalty: float = absf(float(dx)) * 0.001
				var adjusted_value: float = value - dist_penalty
				if adjusted_value > best_coast_value - 0.1:  # Allow some variation
					best_coast = Vector2i(check_x, y)
					best_coast_value = value
				break

	# The ship spawn point should be JUST INSIDE the coastline (on walkable terrain)
	# Move ~100 pixels (250m) into the island from the coastline
	var spawn_offset := 80  # ~200m inland
	var spawn_pos := Vector2i(best_coast.x, best_coast.y + spawn_offset)

	# Verify spawn position is on solid island
	if spawn_pos.y < height:
		var spawn_value: float = mask.get_pixel(spawn_pos.x, spawn_pos.y).r
		if spawn_value < 0.5:
			# Move further inland if needed
			for extra in range(20, 200, 20):
				spawn_pos.y = best_coast.y + spawn_offset + extra
				if spawn_pos.y >= height:
					break
				spawn_value = mask.get_pixel(spawn_pos.x, spawn_pos.y).r
				if spawn_value >= 0.5:
					break

	print("[IslandShape] Inlet coastline at pixel (%d, %d), spawn at (%d, %d)" % [
		best_coast.x, best_coast.y, spawn_pos.x, spawn_pos.y])

	return {
		"position": Vector2(float(spawn_pos.x) / float(width), float(spawn_pos.y) / float(height)),
		"pixel_position": spawn_pos,
		"coastline_pixel": best_coast,
		"east_side": east_side
	}


## Attempt at smoothstep function (GLSL-style)
static func _smoothstep(edge0: float, edge1: float, x: float) -> float:
	var t := clampf((x - edge0) / (edge1 - edge0), 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)
