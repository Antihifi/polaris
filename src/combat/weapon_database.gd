class_name WeaponDatabase extends RefCounted
## Static database of all weapon definitions.

# Cached weapon instances
static var _weapons: Dictionary = {}
static var _initialized: bool = false


static func _ensure_initialized() -> void:
	if _initialized:
		return
	_initialized = true

	# Melee weapons
	_weapons[&"unarmed"] = _create_unarmed()
	_weapons[&"knife"] = _create_knife()
	_weapons[&"hatchet"] = _create_hatchet()

	# Ranged weapons (future)
	_weapons[&"pistol"] = _create_pistol()
	_weapons[&"shotgun"] = _create_shotgun()
	_weapons[&"musket"] = _create_musket()


static func get_weapon(weapon_id: StringName) -> WeaponStats:
	## Returns weapon stats by ID. Returns unarmed if not found.
	_ensure_initialized()
	if weapon_id in _weapons:
		return _weapons[weapon_id]
	return _weapons[&"unarmed"]


static func get_unarmed() -> WeaponStats:
	_ensure_initialized()
	return _weapons[&"unarmed"]


# ============================================================
# Melee Weapons
# ============================================================

static func _create_unarmed() -> WeaponStats:
	var w := WeaponStats.new()
	w.id = &"unarmed"
	w.display_name = "Fists"
	w.weapon_type = WeaponStats.WeaponType.MELEE
	w.min_damage = 3.0
	w.max_damage = 5.0
	w.attack_speed = 1.0
	w.attack_range = 1.5
	w.attack_animation = "punching"
	return w


static func _create_knife() -> WeaponStats:
	var w := WeaponStats.new()
	w.id = &"knife"
	w.display_name = "Knife"
	w.weapon_type = WeaponStats.WeaponType.MELEE
	w.min_damage = 6.0
	w.max_damage = 10.0
	w.attack_speed = 0.8
	w.attack_range = 1.5
	w.attack_animation = "standing_melee_attack_horizontal"
	return w


static func _create_hatchet() -> WeaponStats:
	var w := WeaponStats.new()
	w.id = &"hatchet"
	w.display_name = "Hatchet"
	w.weapon_type = WeaponStats.WeaponType.MELEE
	w.min_damage = 10.0
	w.max_damage = 15.0
	w.attack_speed = 1.2
	w.attack_range = 2.0
	w.attack_animation = "standing_melee_attack_downward"
	return w


# ============================================================
# Ranged Weapons (Future Implementation)
# ============================================================

static func _create_pistol() -> WeaponStats:
	var w := WeaponStats.new()
	w.id = &"pistol"
	w.display_name = "Pistol"
	w.weapon_type = WeaponStats.WeaponType.RANGED
	w.min_damage = 25.0
	w.max_damage = 35.0
	w.attack_speed = 18.0  # Reload time
	w.attack_range = 15.0
	w.base_accuracy = 0.6
	w.reload_time = 18.0
	w.attack_animation = "firing_rifle"  # Reuse for now
	return w


static func _create_shotgun() -> WeaponStats:
	var w := WeaponStats.new()
	w.id = &"shotgun"
	w.display_name = "Shotgun"
	w.weapon_type = WeaponStats.WeaponType.RANGED
	w.min_damage = 40.0
	w.max_damage = 60.0
	w.attack_speed = 20.0
	w.attack_range = 20.0
	w.base_accuracy = 0.75  # Spread helps at close range
	w.reload_time = 20.0
	w.attack_animation = "firing_rifle"
	return w


static func _create_musket() -> WeaponStats:
	var w := WeaponStats.new()
	w.id = &"musket"
	w.display_name = "Musket"
	w.weapon_type = WeaponStats.WeaponType.RANGED
	w.min_damage = 35.0
	w.max_damage = 50.0
	w.attack_speed = 22.0
	w.attack_range = 40.0
	w.base_accuracy = 0.65
	w.reload_time = 22.0
	w.attack_animation = "firing_rifle"
	return w
