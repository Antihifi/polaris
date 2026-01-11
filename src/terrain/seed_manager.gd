class_name SeedManager
extends RefCounted
## Manages terrain generation seeds for reproducibility.
## Provides sub-RNGs for each generation phase to ensure changes
## in one phase don't affect others.

## Current seed for this game session
var current_seed: int = 0

## Main RNG instance seeded from current_seed
var rng: RandomNumberGenerator


func _init() -> void:
	rng = RandomNumberGenerator.new()


## Set the seed for terrain generation
func set_seed(seed_value: int) -> void:
	current_seed = seed_value
	rng.seed = seed_value
	print("[SeedManager] Seed set to: %d (hex: %s)" % [seed_value, get_seed_string()])


## Generate a random seed based on system time
func generate_random_seed() -> int:
	var time_component := int(Time.get_unix_time_from_system() * 1000)
	var random_component := randi()
	var new_seed := time_component ^ random_component
	set_seed(new_seed)
	return new_seed


## Get seed as shareable hex string (e.g., "A3F7BC12")
func get_seed_string() -> String:
	return "%X" % current_seed


## Parse seed from player-entered string (hex or decimal)
func set_seed_from_string(seed_string: String) -> bool:
	var cleaned := seed_string.strip_edges().to_upper()

	if cleaned.is_empty():
		return false

	# Try hex first (most common for sharing)
	if cleaned.is_valid_hex_number():
		set_seed(cleaned.hex_to_int())
		return true

	# Try decimal
	if cleaned.is_valid_int():
		set_seed(cleaned.to_int())
		return true

	push_warning("[SeedManager] Invalid seed format: %s" % seed_string)
	return false


## Get sub-RNG for island shape generation
## XOR with unique constant ensures different random sequence
func get_shape_rng() -> RandomNumberGenerator:
	var sub_rng := RandomNumberGenerator.new()
	sub_rng.seed = current_seed ^ 0x12345678
	return sub_rng


## Get sub-RNG for heightmap noise generation
func get_height_rng() -> RandomNumberGenerator:
	var sub_rng := RandomNumberGenerator.new()
	sub_rng.seed = current_seed ^ 0x87654321
	return sub_rng


## Get sub-RNG for texture variation
func get_texture_rng() -> RandomNumberGenerator:
	var sub_rng := RandomNumberGenerator.new()
	sub_rng.seed = current_seed ^ 0xABCDEF01
	return sub_rng


## Get sub-RNG for POI placement
func get_poi_rng() -> RandomNumberGenerator:
	var sub_rng := RandomNumberGenerator.new()
	sub_rng.seed = current_seed ^ 0xFEDCBA98
	return sub_rng


## Get sub-RNG for inlet placement
func get_inlet_rng() -> RandomNumberGenerator:
	var sub_rng := RandomNumberGenerator.new()
	sub_rng.seed = current_seed ^ 0x13579BDF
	return sub_rng
