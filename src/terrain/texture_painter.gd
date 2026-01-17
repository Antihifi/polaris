class_name TexturePainter
extends RefCounted
## Paints textures on the terrain based on height and slope.
## Generates a control map for Terrain3D's import_images() API.
##
## TEXTURE SLOT MAPPING (must match procedural_terrain_config.tscn Terrain3DAssets):
##   Slot 0: Snow (snow_01) - detiling enabled, main surface texture
##   Slot 1: Rock (rock_dark_01) - detiling enabled, exposed cliffs
##   Slot 2: Gravel (gravel01) - detiling enabled, wind-swept lowlands
##   Slot 3: Ice (ice01) - detiling enabled, frozen sea base layer

## Texture slot IDs (MUST MATCH procedural_terrain_config.tscn Terrain3DAssets texture_list order!)
const TEXTURE_SNOW: int = 0    # Snow layer - base for most terrain
const TEXTURE_ROCK: int = 1    # Rock - steep cliffs, outcrops
const TEXTURE_GRAVEL: int = 2  # Gravel - lowlands, wind-swept areas
const TEXTURE_ICE: int = 3     # Ice - frozen sea surface (under snow overlay)

## Height thresholds (meters)
const COASTAL_MAX_HEIGHT: float = 8.0   # Coastline zone
const LOWLAND_MAX_HEIGHT: float = 40.0  # Low flats (gravel/rock mix)
const MIDLAND_MAX_HEIGHT: float = 100.0 # Mid elevation (snow with rock exposure)
# Above MIDLAND = high peaks (mostly snow, rock on steep faces)

## Slope thresholds (degrees)
const CLIFF_MIN_SLOPE: float = 40.0   # Steep cliffs - exposed rock
const STEEP_MIN_SLOPE: float = 28.0   # Moderate slopes - some rock showing
const GENTLE_MAX_SLOPE: float = 15.0  # Gentle slopes - snow accumulates here


## Get meters per pixel from TerrainGenerator (dynamic to support different resolutions)
static func _get_meters_per_pixel() -> float:
	return TerrainGenerator.METERS_PER_PIXEL


## Paint textures on the entire terrain using set_control_base_id() API
## This is the official recommended approach per Terrain3D Discord.
## Call this AFTER terrain import to set textures pixel by pixel.
static func paint_terrain_post_import(
	terrain_data,  # Terrain3DData - the .data property of Terrain3D node
	heightmap: Image,
	island_mask: Image,
	texture_rng: RandomNumberGenerator,
	vertex_spacing: float = 2.5  # From TerrainGenerator.VERTEX_SPACING
) -> void:
	var width := heightmap.get_width()
	var height := heightmap.get_height()
	var half_width := float(width) / 2.0
	var half_height := float(height) / 2.0

	# Variation noise for natural texture breakup
	var variation_noise := FastNoiseLite.new()
	variation_noise.seed = texture_rng.randi()
	variation_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	variation_noise.frequency = 0.08

	print("[TexturePainter] Painting textures via set_control_base_id (%dx%d)..." % [width, height])
	var start_time := Time.get_ticks_msec()

	# Sample every Nth vertex for performance on large maps
	# At 4096x4096 with step=4, we paint ~1M points (4096/4 = 1024, 1024^2 = 1M)
	# This is still slow but manageable. Each point affects surrounding area.
	var step := 4  # Skip pixels for performance (every 4th = ~10m spacing)
	var pixels_painted := 0

	for y in range(1, height - 1, step):
		for x in range(1, width - 1, step):
			var mask_value: float = island_mask.get_pixel(x, y).r
			var h: float = heightmap.get_pixel(x, y).r
			var slope := _calculate_slope(heightmap, x, y)
			var variation := variation_noise.get_noise_2d(float(x), float(y))

			# Normalized Y coordinate (0=north, 1=south)
			var ny := float(y) / float(height)

			# Determine texture
			var texture_id := _determine_texture(h, slope, mask_value, variation, ny)

			# Convert pixel to world position (terrain centered at origin)
			var world_x := (float(x) - half_width) * vertex_spacing
			var world_z := (float(y) - half_height) * vertex_spacing
			var world_pos := Vector3(world_x, 0, world_z)

			# Use official API to set texture
			if terrain_data.has_method("set_control_base_id"):
				terrain_data.set_control_base_id(world_pos, texture_id)
				pixels_painted += 1

	# Force update after painting
	if terrain_data.has_method("update_maps"):
		terrain_data.update_maps()

	var elapsed := (Time.get_ticks_msec() - start_time) / 1000.0
	print("[TexturePainter] Painted %d pixels in %.1f seconds" % [pixels_painted, elapsed])


## DEPRECATED: Old paint function
static func paint_terrain(
	_terrain_data,  # Terrain3DData
	_heightmap: Image,
	_island_mask: Image,
	_texture_rng: RandomNumberGenerator
) -> void:
	# This method is deprecated - use paint_terrain_post_import() instead
	print("[TexturePainter] paint_terrain() is deprecated - use paint_terrain_post_import()")
	return


## Generate control map for Terrain3D import using 32-bit packed format
## CRITICAL: Terrain3D control maps use a bit-packed uint32 stored as float, NOT simple RGB!
## See src/terrain/CLAUDE.md "Control Map Format" section for bit field documentation.
##
## Returns: Image with FORMAT_RF containing bit-packed control values
static func generate_control_map_for_import(
	heightmap: Image,
	island_mask: Image,
	texture_rng: RandomNumberGenerator
) -> Image:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	# MUST use FORMAT_RF for Terrain3D control map (32-bit float holding packed uint32)
	var control_map := Image.create(width, height, false, Image.FORMAT_RF)

	# Variation noise for natural texture breakup
	var variation_noise := FastNoiseLite.new()
	variation_noise.seed = texture_rng.randi()
	variation_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	variation_noise.frequency = 0.08

	# Blend noise for texture transitions
	var blend_noise := FastNoiseLite.new()
	blend_noise.seed = texture_rng.randi()
	blend_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	blend_noise.frequency = 0.15

	print("[TexturePainter] Generating control map %dx%d..." % [width, height])

	# Debug: count texture distribution
	var texture_counts := {0: 0, 1: 0, 2: 0, 3: 0}  # Snow, Rock, Gravel, Ice
	var sample_logged := false

	for y in range(1, height - 1):
		for x in range(1, width - 1):
			var mask_value: float = island_mask.get_pixel(x, y).r
			var h: float = heightmap.get_pixel(x, y).r
			var slope := _calculate_slope(heightmap, x, y)
			var variation := variation_noise.get_noise_2d(float(x), float(y))
			var blend_var := blend_noise.get_noise_2d(float(x), float(y))

			# Normalized Y coordinate (0=north, 1=south) for south coast detection
			var ny := float(y) / float(height)

			# Determine base texture based on terrain properties
			var base_texture_id := _determine_texture(h, slope, mask_value, variation, ny)

			# Determine overlay texture for blending (usually adjacent texture type)
			var overlay_texture_id := _determine_overlay_texture(base_texture_id, h, slope, mask_value)

			# Calculate blend amount (0-255 for 8-bit field)
			# IMPORTANT: Higher blend = MORE overlay texture shows through!
			# For ice (base) with snow (overlay), high blend = mostly snow visible
			var blend_amount := 0

			# Check if this is an inlet/harbor zone (low elevation, gentle slope, not south coast)
			# Must match the thresholds in _determine_texture() for consistency
			var is_inlet_zone := h < 20.0 and slope < 25.0 and ny < 0.85

			# FROZEN SEA/COASTLINE/INLET: Heavy snow coverage over ice (85-95% snow visible)
			# This creates the natural arctic look of snow drifts over frozen sea
			# Inlet uses SAME blend as frozen sea for consistent appearance
			if mask_value < 0.3 or is_inlet_zone:
				# Use noise to create natural snow drift patterns over ice
				# Range: 0.85 to 0.95 (mostly snow, occasional ice peeking through)
				var ice_blend := (blend_var + 1.0) * 0.5  # Normalize to 0-1
				ice_blend = ice_blend * 0.10 + 0.85  # Range: 0.85 to 0.95
				blend_amount = int(ice_blend * 255.0)

			# INLAND TERRAIN: Strong blending for natural texture transitions
			else:
				# Apply strong blending for smooth transitions between textures
				var inland_blend := (blend_var + 1.0) * 0.5  # Normalize to 0-1
				# More blending on gentle slopes, less on steep cliffs (sharper rock edges)
				var slope_factor := 1.0 - clampf(slope / CLIFF_MIN_SLOPE, 0.0, 1.0)
				# Range: 0.5 to 0.9 for smooth natural appearance
				inland_blend = inland_blend * 0.4 * slope_factor + 0.5
				blend_amount = int(inland_blend * 255.0)

			# Encode as 32-bit packed value and store as float
			var control_uint := _encode_control_pixel(base_texture_id, overlay_texture_id, blend_amount)
			var control_float := _int_to_float_bits(control_uint)

			control_map.set_pixel(x, y, Color(control_float, 0.0, 0.0, 1.0))

			# Count textures for debug
			if base_texture_id in texture_counts:
				texture_counts[base_texture_id] += 1

			# Log one sample for debugging
			if not sample_logged and x == width / 2 and y == height / 2:
				print("[TexturePainter] Sample at center: base=%d, overlay=%d, blend=%d" % [base_texture_id, overlay_texture_id, blend_amount])
				print("[TexturePainter]   Encoded uint32: %d (0x%X)" % [control_uint, control_uint])
				print("[TexturePainter]   As float bits: %f" % control_float)
				sample_logged = true

	var total: int = texture_counts[0] + texture_counts[1] + texture_counts[2] + texture_counts[3]
	print("[TexturePainter] Control map generation complete")
	print("[TexturePainter] Texture counts: Snow=%d (%.1f%%), Rock=%d (%.1f%%), Gravel=%d (%.1f%%), Ice=%d (%.1f%%)" % [
		texture_counts[0], float(texture_counts[0]) / total * 100.0,
		texture_counts[1], float(texture_counts[1]) / total * 100.0,
		texture_counts[2], float(texture_counts[2]) / total * 100.0,
		texture_counts[3], float(texture_counts[3]) / total * 100.0
	])
	return control_map


## DEPRECATED: Use generate_control_map_for_import() instead
## Returns a control map Image for later import (OLD FORMAT - DO NOT USE)
static func generate_control_map(
	heightmap: Image,
	island_mask: Image,
	texture_rng: RandomNumberGenerator
) -> Image:
	push_warning("[TexturePainter] generate_control_map() is DEPRECATED - use generate_control_map_for_import()")
	return generate_control_map_for_import(heightmap, island_mask, texture_rng)


## Encode a control map pixel value using Terrain3D's 32-bit packed format
## Bit layout (from Terrain3D docs):
##   Bits 27-31: Base texture ID (5 bits, 0-31)
##   Bits 22-26: Overlay texture ID (5 bits, 0-31)
##   Bits 14-21: Blend amount (8 bits, 0-255)
##   Bit 2: Hole flag (1 = hole)
##   Bit 1: Navigation flag (1 = navigable)
##   Bit 0: Autoshader flag (1 = use auto shader)
static func _encode_control_pixel(base_id: int, overlay_id: int = 0, blend: int = 0, autoshader: bool = false) -> int:
	var value: int = 0
	value |= (base_id & 0x1F) << 27       # Base texture (bits 27-31)
	value |= (overlay_id & 0x1F) << 22    # Overlay texture (bits 22-26)
	value |= (blend & 0xFF) << 14         # Blend (bits 14-21)
	# Bit 2 = hole (0 = not a hole)
	value |= 1 << 1                        # Nav flag (bit 1) = navigable
	if autoshader:
		value |= 1                         # Autoshader flag (bit 0)
	return value


## Convert int to float without changing bits (reinterpret cast)
## This is required because Terrain3D stores packed uint32 values as floats
static func _int_to_float_bits(i: int) -> float:
	var bytes := PackedByteArray()
	bytes.resize(4)
	bytes.encode_u32(0, i)
	return bytes.decode_float(0)


## Determine overlay texture for blending transitions
## Returns a complementary texture ID for smooth transitions
## IMPORTANT: Frozen sea and inlet MUST be ice/snow blend ONLY (no rock!)
static func _determine_overlay_texture(base_id: int, height_m: float, slope_deg: float, mask: float) -> int:
	# === FROZEN SEA/COASTLINE - Always ice/snow blend, NEVER rock ===
	if mask < 0.3:
		if base_id == TEXTURE_ICE:
			return TEXTURE_SNOW  # Snow drifts over ice
		else:
			return TEXTURE_ICE  # Ice showing through snow (or under gravel at south coast)

	# === INLET/HARBOR ZONE - ICE/SNOW blend ONLY ===
	# Low, flat areas within the island are frozen water (inlet, harbor)
	# Ships get stuck in ice, not rock/gravel!
	if height_m < 5.0 and slope_deg < 15.0:
		if base_id == TEXTURE_ICE:
			return TEXTURE_SNOW
		elif base_id == TEXTURE_SNOW:
			return TEXTURE_ICE
		# If somehow rock/gravel base got through, blend with snow
		return TEXTURE_SNOW

	# === LOWLANDS (above sea level) - blend between gravel and snow ===
	if height_m < LOWLAND_MAX_HEIGHT:
		if base_id == TEXTURE_GRAVEL:
			return TEXTURE_SNOW
		elif base_id == TEXTURE_SNOW:
			return TEXTURE_GRAVEL
		else:
			return TEXTURE_SNOW  # Rock blends with snow

	# === HIGHER ELEVATIONS - blend rock with snow ===
	if slope_deg > GENTLE_MAX_SLOPE:
		return TEXTURE_SNOW if base_id == TEXTURE_ROCK else TEXTURE_ROCK

	# Default: blend with snow for coherent appearance
	return TEXTURE_SNOW if base_id != TEXTURE_SNOW else base_id


## Determine which texture to use based on terrain properties
## ARCTIC TERRAIN RULES (2026-01-12):
## Using 4 textures: SNOW (0), ROCK (1), GRAVEL (2), ICE (3)
##
## - Frozen sea (outside island): ICE base ONLY (no rock!) - overlay blends snow on top
## - Inlet/harbor (also frozen): ICE base with SNOW overlay - CRITICAL: ships stuck in ice, not rock!
## - South coast only: gravel/rock (ice-free shore, future water feature)
## - Coastlines (N/E/W): snow-covered
## - Low flat areas: gravel/rock where wind-swept, snow in sheltered areas
## - Mid-elevation: snow on gentle slopes, gravel on moderate, rock on steep
## - High elevation: snow dominant, rock on steep faces
static func _determine_texture(height_m: float, slope_deg: float, mask: float, variation: float, ny: float = 0.5) -> int:
	# === FROZEN SEA (outside island) - ICE ONLY, no rock! ===
	# The overlay system will blend snow on top for natural appearance
	if mask < 0.1:
		return TEXTURE_ICE  # Pure frozen sea surface

	# === INLET/HARBOR ZONE - ICE AND SNOW ONLY! ===
	# The inlet is carved from frozen sea level (-2m) through a ramp up to ~20m.
	# This is where the ship is frozen - MUST be ice/snow, NOT rock/gravel!
	# A ship cannot get stuck in stone and gravel.
	# Extended height threshold (20m) covers the entire inlet + ramp transition.
	# Allow slopes up to 25 deg (ramp is ~20 deg max slope).
	# SAME RULE AS FROZEN SEA: Predominantly SNOW (85-95%) with occasional ice patches
	if height_m < 20.0 and slope_deg < 25.0:
		# Low, gentle-slope areas = frozen water or snow-covered ramp
		# Only exception: south coast (ny > 0.85) which is ice-free
		if ny < 0.85:
			# Gradient: more ice at lower elevations, transition to snow higher up
			# Below 5m = frozen channel floor (more ice visible)
			# 5-20m = ramp transition (snow dominant, blending with surroundings)
			if height_m < 5.0:
				return TEXTURE_ICE  # Frozen channel floor - ice with snow overlay
			else:
				# Ramp area: mostly snow with occasional ice patches at lower end
				var snow_probability := clampf((height_m - 5.0) / 15.0, 0.0, 1.0)
				if variation > snow_probability:
					return TEXTURE_ICE  # Ice patches, less common as height increases
				return TEXTURE_SNOW  # Snow-covered ramp

	# === COASTLINE TRANSITION ZONE ===
	if mask < 0.3:
		# South coast (ny > 0.85): gravel/rock (ice-free shore - future open water)
		if ny > 0.85:
			return TEXTURE_GRAVEL if variation > -0.2 else TEXTURE_ROCK

		# North/East/West coastlines: ICE transitioning to snow-covered land
		# NO ROCK in these areas - just ice/snow blend
		if variation > 0.3:
			return TEXTURE_ICE  # Ice patches near coastline
		return TEXTURE_SNOW  # Snow covering the ice edge

	# === STEEP SLOPES (any height) - Rock exposed, snow can't accumulate ===
	if slope_deg > CLIFF_MIN_SLOPE:
		return TEXTURE_ROCK

	# === SOUTH COAST ZONE (beach area - ice free, gravel/rock) ===
	if ny > 0.85 and height_m < COASTAL_MAX_HEIGHT:
		if slope_deg > STEEP_MIN_SLOPE:
			return TEXTURE_ROCK
		return TEXTURE_GRAVEL

	# === COASTAL ZONE (low elevation, NOT south coast) ===
	if height_m < COASTAL_MAX_HEIGHT:
		# Snow-covered coastal areas (N/E/W coasts)
		if slope_deg > STEEP_MIN_SLOPE:
			return TEXTURE_ROCK
		if variation > 0.5:
			return TEXTURE_ROCK  # Exposed rock patches
		return TEXTURE_SNOW  # Snow-covered coast

	# === LOWLAND ZONE (flat low areas inland) ===
	if height_m < LOWLAND_MAX_HEIGHT:
		# Mix of gravel, rock, and snow patches
		if slope_deg > STEEP_MIN_SLOPE:
			return TEXTURE_ROCK  # Exposed rock faces
		if variation > 0.5:
			return TEXTURE_ROCK  # Rocky outcrops
		if variation > 0.2:
			return TEXTURE_GRAVEL  # Wind-swept gravel
		return TEXTURE_SNOW  # Snow in sheltered areas

	# === MIDLAND ZONE (mid elevation) ===
	if height_m < MIDLAND_MAX_HEIGHT:
		# Snow dominant, with gravel on moderate slopes, rock on steep
		if slope_deg > STEEP_MIN_SLOPE:
			return TEXTURE_ROCK  # Steep = exposed rock
		if slope_deg > GENTLE_MAX_SLOPE:
			# Moderate slopes: gravel/snow mix
			return TEXTURE_GRAVEL if variation > 0.3 else TEXTURE_SNOW
		# Gentle slopes: snow accumulates
		return TEXTURE_SNOW

	# === HIGHLAND ZONE (mountain peaks) ===
	# Predominantly snow-covered, rock on steep faces
	if slope_deg > STEEP_MIN_SLOPE:
		return TEXTURE_ROCK if variation > -0.2 else TEXTURE_SNOW
	# Gentle high areas: thick snow cover
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
		TEXTURE_GRAVEL: 0,
		TEXTURE_ICE: 0
	}

	var width := heightmap.get_width()
	var height := heightmap.get_height()

	for y in range(1, height - 1):
		for x in range(1, width - 1):
			var mask_value: float = island_mask.get_pixel(x, y).r
			var h: float = heightmap.get_pixel(x, y).r
			var slope := _calculate_slope(heightmap, x, y)
			var ny := float(y) / float(height)

			var texture_id := _determine_texture(h, slope, mask_value, 0.0, ny)
			counts[texture_id] += 1

	var total := 0
	for key in counts:
		total += counts[key]

	return {
		"snow_percent": float(counts[TEXTURE_SNOW]) / total * 100.0 if total > 0 else 0.0,
		"rock_percent": float(counts[TEXTURE_ROCK]) / total * 100.0 if total > 0 else 0.0,
		"gravel_percent": float(counts[TEXTURE_GRAVEL]) / total * 100.0 if total > 0 else 0.0,
		"ice_percent": float(counts[TEXTURE_ICE]) / total * 100.0 if total > 0 else 0.0,
		"total_pixels": total
	}
