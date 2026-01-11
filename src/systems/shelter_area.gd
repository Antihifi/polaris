class_name ShelterArea extends Area3D
## Area3D script for marking shelter zones. Attach to any Area3D node.
##
## USAGE:
## 1. Create an Area3D node in your scene (ship, cave, tent, etc.)
## 2. Add a CollisionShape3D child with shape matching the shelter footprint
## 3. Attach this script to the Area3D
## 4. Set shelter_type in Inspector (TENT, IMPROVED_SHELTER, or CAVE)
##
## Survivors inside get warmth bonuses and cold damage reduction based on type.
## The script auto-configures collision layers to detect survivors (layer 2).

enum ShelterType {
	TENT,              ## Basic shelter: +2 warmth/hr, 50% cold damage
	IMPROVED_SHELTER,  ## Ship/building: +3 warmth/hr, 25% cold damage
	CAVE               ## Natural shelter: +1 warmth/hr, 40% cold damage
}

@export var shelter_type: ShelterType = ShelterType.TENT


func _ready() -> void:
	_connect_signals()
	# Auto-configure collision to detect survivor bodies (layer 2)
	collision_layer = 0
	collision_mask = 2
	monitoring = true
	monitorable = false
	# Add SELF to shelters group for AI resource seeking
	# (not parent, so AI navigates to the actual shelter area center)
	add_to_group("shelters")
	print("[ShelterArea] Ready at %s, type=%s, monitoring=%s" % [
		global_position, ShelterType.keys()[shelter_type], monitoring
	])


func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("enter_shelter"):
		print("[ShelterArea] %s entered shelter (type=%d)" % [body.name, shelter_type])
		body.enter_shelter(self)


func _on_body_exited(body: Node3D) -> void:
	if body.has_method("exit_shelter"):
		print("[ShelterArea] %s exited shelter" % body.name)
		body.exit_shelter()


func get_shelter_type() -> ShelterType:
	return shelter_type


func get_warmth_bonus() -> float:
	## Returns hourly warmth bonus based on shelter type.
	match shelter_type:
		ShelterType.TENT:
			return 2.0
		ShelterType.IMPROVED_SHELTER:
			return 3.0
		ShelterType.CAVE:
			return 1.0
	return 0.0


func get_cold_reduction() -> float:
	## Returns cold damage multiplier (lower = less cold damage).
	match shelter_type:
		ShelterType.TENT:
			return 0.5  # 50% cold damage
		ShelterType.IMPROVED_SHELTER:
			return 0.25  # 25% cold damage
		ShelterType.CAVE:
			return 0.4  # 40% cold damage
	return 1.0
