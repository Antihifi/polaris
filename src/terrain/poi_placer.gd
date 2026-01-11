class_name POIPlacer
extends RefCounted
## Places Points of Interest (POIs) on the generated terrain.
## Ensures POIs are at valid positions and reachable from the ship.

## Distance constraints (meters)
const INUIT_MIN_DISTANCE: float = 2000.0   # 2km minimum from ship
const INUIT_MAX_DISTANCE: float = 4000.0   # 4km maximum from ship
const INUIT_MIN_SEPARATION: float = 1500.0 # 1.5km between villages

const HBC_MIN_DISTANCE: float = 8000.0     # 8km minimum from ship
const HBC_MAX_DISTANCE: float = 10000.0    # 10km maximum from ship

## Elevation constraints (meters)
const HBC_MIN_ELEVATION: float = 2.0
const HBC_MAX_ELEVATION: float = 25.0
const INUIT_MIN_ELEVATION: float = 5.0
const INUIT_MAX_ELEVATION: float = 80.0

## Mask thresholds (how far onto island)
const HBC_MIN_MASK: float = 0.25
const INUIT_MIN_MASK: float = 0.4

## Placement attempts before giving up
const MAX_PLACEMENT_ATTEMPTS: int = 150

## Terrain scale
const METERS_PER_PIXEL: float = 10.0


## Place all POIs on the terrain
## Returns Dictionary with POI positions
static func place_pois(
	heightmap: Image,
	island_mask: Image,
	ship_position: Vector3,
	poi_rng: RandomNumberGenerator
) -> Dictionary:
	var pois := {}

	# Ship is already placed
	pois["ship"] = ship_position
	print("[POIPlacer] Ship at: %s" % ship_position)

	# Place HBC whaling station on south coast
	var hbc_pos := _place_hbc_station(heightmap, island_mask, ship_position, poi_rng)
	if hbc_pos != Vector3.INF:
		pois["hbc_station"] = hbc_pos
		print("[POIPlacer] HBC station at: %s (%.1f km from ship)" % [
			hbc_pos,
			ship_position.distance_to(hbc_pos) / 1000.0
		])
	else:
		push_warning("[POIPlacer] Failed to place HBC station!")

	# Place 1-2 Inuit villages
	var village_count := poi_rng.randi_range(1, 2)
	pois["inuit_villages"] = []

	for i in range(village_count):
		var village_pos := _place_inuit_village(
			heightmap,
			island_mask,
			ship_position,
			pois.get("inuit_villages", []),
			poi_rng
		)
		if village_pos != Vector3.INF:
			pois["inuit_villages"].append(village_pos)
			print("[POIPlacer] Inuit village %d at: %s (%.1f km from ship)" % [
				i + 1,
				village_pos,
				ship_position.distance_to(village_pos) / 1000.0
			])

	if pois["inuit_villages"].is_empty():
		push_warning("[POIPlacer] Failed to place any Inuit villages!")

	return pois


## Place the HBC whaling station on the south coast
static func _place_hbc_station(
	heightmap: Image,
	island_mask: Image,
	ship_pos: Vector3,
	rng: RandomNumberGenerator
) -> Vector3:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	var best_pos := Vector3.INF
	var best_score := -INF

	for _attempt in range(MAX_PLACEMENT_ATTEMPTS):
		# Focus on southern 20% of map (south coast)
		var px := rng.randi_range(int(width * 0.15), int(width * 0.85))
		var py := rng.randi_range(int(height * 0.78), int(height * 0.95))

		var mask: float = island_mask.get_pixel(px, py).r
		if mask < HBC_MIN_MASK:
			continue

		var h: float = heightmap.get_pixel(px, py).r
		if h < HBC_MIN_ELEVATION or h > HBC_MAX_ELEVATION:
			continue

		var world_pos := _pixel_to_world(px, py, h, width, height)
		var dist := ship_pos.distance_to(world_pos)

		if dist < HBC_MIN_DISTANCE or dist > HBC_MAX_DISTANCE:
			continue

		# Calculate slope at this point
		var slope := _calculate_slope(heightmap, px, py)
		if slope > 20.0:  # Too steep for a station
			continue

		# Score: prefer flat, coastal, at ideal distance (~9km)
		var score := 0.0
		score -= abs(h - 8.0)  # Prefer ~8m elevation
		score -= slope * 0.5   # Prefer flat
		score -= abs(dist - 9000.0) / 500.0  # Prefer ~9km distance
		score += mask * 5.0    # Prefer more solidly on island

		if score > best_score:
			best_score = score
			best_pos = world_pos

	return best_pos


## Place an Inuit village
static func _place_inuit_village(
	heightmap: Image,
	island_mask: Image,
	ship_pos: Vector3,
	existing_villages: Array,
	rng: RandomNumberGenerator
) -> Vector3:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	var best_pos := Vector3.INF
	var best_score := -INF

	for _attempt in range(MAX_PLACEMENT_ATTEMPTS):
		# Can be anywhere on island except far south (leave that for HBC)
		var px := rng.randi_range(int(width * 0.1), int(width * 0.9))
		var py := rng.randi_range(int(height * 0.15), int(height * 0.75))

		var mask: float = island_mask.get_pixel(px, py).r
		if mask < INUIT_MIN_MASK:
			continue

		var h: float = heightmap.get_pixel(px, py).r
		if h < INUIT_MIN_ELEVATION or h > INUIT_MAX_ELEVATION:
			continue

		var world_pos := _pixel_to_world(px, py, h, width, height)
		var dist_to_ship := ship_pos.distance_to(world_pos)

		if dist_to_ship < INUIT_MIN_DISTANCE or dist_to_ship > INUIT_MAX_DISTANCE:
			continue

		# Check distance from other villages
		var too_close := false
		for existing in existing_villages:
			if world_pos.distance_to(existing) < INUIT_MIN_SEPARATION:
				too_close = true
				break

		if too_close:
			continue

		# Calculate slope
		var slope := _calculate_slope(heightmap, px, py)
		if slope > 25.0:  # Too steep for a village
			continue

		# Score: prefer moderate elevation, flat, good access
		var score := 0.0
		score -= abs(h - 30.0) * 0.1  # Prefer ~30m elevation
		score -= slope * 0.3   # Prefer flat
		score -= abs(dist_to_ship - 3000.0) / 500.0  # Prefer ~3km distance
		score += mask * 3.0    # Prefer more solidly on island

		if score > best_score:
			best_score = score
			best_pos = world_pos

	return best_pos


## Validate that all POIs are reachable from the ship via navigation
## Call this after NavMesh is baked
static func validate_poi_accessibility(
	nav_region: NavigationRegion3D,
	ship_pos: Vector3,
	pois: Dictionary
) -> Dictionary:
	var results := {
		"all_valid": true,
		"unreachable": []
	}

	if not nav_region:
		push_error("[POIPlacer] NavigationRegion3D is null!")
		results.all_valid = false
		return results

	var nav_map := nav_region.get_navigation_map()
	if not nav_map.is_valid():
		push_error("[POIPlacer] Navigation map is invalid!")
		results.all_valid = false
		return results

	for poi_name in pois:
		if poi_name == "ship":
			continue

		var poi_data = pois[poi_name]

		if poi_data is Array:
			# Multiple POIs (like villages)
			for i in range(poi_data.size()):
				var pos: Vector3 = poi_data[i]
				if not _is_reachable(nav_map, ship_pos, pos):
					push_warning("[POIPlacer] %s[%d] unreachable at %s" % [poi_name, i, pos])
					results.unreachable.append({
						"name": "%s[%d]" % [poi_name, i],
						"position": pos
					})
					results.all_valid = false
				else:
					print("[POIPlacer] %s[%d] is reachable" % [poi_name, i])

		elif poi_data is Vector3:
			if not _is_reachable(nav_map, ship_pos, poi_data):
				push_warning("[POIPlacer] %s unreachable at %s" % [poi_name, poi_data])
				results.unreachable.append({
					"name": poi_name,
					"position": poi_data
				})
				results.all_valid = false
			else:
				print("[POIPlacer] %s is reachable" % poi_name)

	return results


## Check if a position is reachable from another via navigation
static func _is_reachable(nav_map: RID, from: Vector3, to: Vector3) -> bool:
	# Get path from navigation server
	var path := NavigationServer3D.map_get_path(nav_map, from, to, true)

	if path.is_empty():
		return false

	# Check that path actually gets close to destination
	var final_pos: Vector3 = path[path.size() - 1]
	var dist_to_goal := final_pos.distance_to(to)

	# Allow some tolerance (50m) for NavMesh imprecision
	return dist_to_goal < 50.0


## Calculate slope at a pixel position
static func _calculate_slope(heightmap: Image, x: int, y: int) -> float:
	if x <= 0 or x >= heightmap.get_width() - 1:
		return 0.0
	if y <= 0 or y >= heightmap.get_height() - 1:
		return 0.0

	var h_left: float = heightmap.get_pixel(x - 1, y).r
	var h_right: float = heightmap.get_pixel(x + 1, y).r
	var h_up: float = heightmap.get_pixel(x, y - 1).r
	var h_down: float = heightmap.get_pixel(x, y + 1).r

	var dx := (h_right - h_left) / 2.0
	var dy := (h_down - h_up) / 2.0
	var gradient := sqrt(dx * dx + dy * dy)

	return rad_to_deg(atan(gradient / METERS_PER_PIXEL))


## Convert pixel coordinates to world position
static func _pixel_to_world(x: int, y: int, height_m: float, width: int, height: int) -> Vector3:
	var world_x := (float(x) - float(width) / 2.0) * METERS_PER_PIXEL
	var world_z := (float(y) - float(height) / 2.0) * METERS_PER_PIXEL
	return Vector3(world_x, height_m, world_z)


## Get summary of POI placements for debugging
static func get_poi_summary(pois: Dictionary, ship_pos: Vector3) -> String:
	var lines := PackedStringArray()
	lines.append("=== POI Summary ===")

	for poi_name in pois:
		var poi_data = pois[poi_name]

		if poi_name == "ship":
			lines.append("Ship: %s" % poi_data)
		elif poi_data is Array:
			for i in range(poi_data.size()):
				var pos: Vector3 = poi_data[i]
				var dist := ship_pos.distance_to(pos) / 1000.0
				lines.append("%s[%d]: %s (%.2f km)" % [poi_name, i, pos, dist])
		elif poi_data is Vector3:
			var dist := ship_pos.distance_to(poi_data) / 1000.0
			lines.append("%s: %s (%.2f km)" % [poi_name, poi_data, dist])

	return "\n".join(lines)
