class_name Survivor extends CharacterBody3D
## Base class for survivor characters with navigation, needs, and traits.

signal selected
signal deselected
signal died(survivor: Survivor)
signal need_critical(need_name: String, value: float)
signal reached_destination
signal task_completed(task_type: String)

enum State {
	IDLE,
	MOVING,
	WORKING,
	RESTING,
	EATING,
	WARMING,
	FLEEING,
	DEAD
}

# Identity
@export var survivor_name: String = "Survivor"
@export var portrait_texture: Texture2D

# Stats and traits
@export var stats: SurvivorStats
@export var traits: Array[SurvivorTrait] = []

# Movement
@export var base_movement_speed: float = 4.0
@export var rotation_speed: float = 10.0

# References
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var health_component: Node = $IndieBlueprintHealth  # IndieBlueprintHealth
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

# State
var current_state: State = State.IDLE
var is_selected: bool = false
var current_task: Dictionary = {}  # {type: String, target: Node/Vector3, progress: float}

# Cached trait effects
var _cached_movement_modifier: float = 1.0
var _cached_hunger_modifier: float = 1.0
var _cached_cold_modifier: float = 1.0
var _cached_damage_modifier: float = 1.0
var _cached_flees_combat: bool = false
var _cached_morale_aura: float = 0.0


func _ready() -> void:
	# Initialize stats if not set
	if stats == null:
		stats = SurvivorStats.new()

	# Cache trait modifiers
	_cache_trait_effects()

	# Apply trait modifiers to stats
	_apply_trait_modifiers()

	# Setup navigation
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_finished)

	# Connect health signals if component exists
	if health_component:
		if health_component.has_signal("died"):
			health_component.died.connect(_on_health_died)
		if health_component.has_signal("health_changed"):
			health_component.health_changed.connect(_on_health_changed)

	# Add to survivor group for easy querying
	add_to_group("survivors")


func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	match current_state:
		State.MOVING:
			_process_movement(delta)
		State.WORKING:
			_process_work(delta)
		State.RESTING:
			_process_rest(delta)
		State.FLEEING:
			_process_flee(delta)


func _cache_trait_effects() -> void:
	## Pre-calculate combined trait effects for performance.
	_cached_movement_modifier = 1.0
	_cached_hunger_modifier = 1.0
	_cached_cold_modifier = 1.0
	_cached_damage_modifier = 1.0
	_cached_flees_combat = false
	_cached_morale_aura = 0.0

	for survivor_trait in traits:
		_cached_movement_modifier *= survivor_trait.movement_speed_modifier
		_cached_hunger_modifier *= survivor_trait.hunger_decay_modifier
		_cached_cold_modifier *= survivor_trait.cold_resistance_modifier
		_cached_damage_modifier *= survivor_trait.damage_modifier
		if survivor_trait.flees_combat:
			_cached_flees_combat = true
		_cached_morale_aura += survivor_trait.morale_aura


func _apply_trait_modifiers() -> void:
	## Apply trait bonuses to stats.
	for survivor_trait in traits:
		stats.hunting_skill += survivor_trait.hunting_bonus
		stats.construction_skill += survivor_trait.construction_bonus
		stats.medicine_skill += survivor_trait.medicine_bonus
		stats.navigation_skill += survivor_trait.navigation_bonus
		stats.survival_skill += survivor_trait.survival_bonus
		stats.max_carry_weight *= survivor_trait.carry_capacity_modifier
		stats.cold_resistance *= survivor_trait.cold_resistance_modifier

	# Clamp skills to valid range
	stats.hunting_skill = clampf(stats.hunting_skill, 0.0, 100.0)
	stats.construction_skill = clampf(stats.construction_skill, 0.0, 100.0)
	stats.medicine_skill = clampf(stats.medicine_skill, 0.0, 100.0)
	stats.navigation_skill = clampf(stats.navigation_skill, 0.0, 100.0)
	stats.survival_skill = clampf(stats.survival_skill, 0.0, 100.0)


# --- Movement ---

func move_to(target_position: Vector3) -> void:
	## Navigate to target position.
	navigation_agent.target_position = target_position
	current_state = State.MOVING


func stop_movement() -> void:
	current_state = State.IDLE
	velocity = Vector3.ZERO


func _process_movement(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		current_state = State.IDLE
		reached_destination.emit()
		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := (next_position - global_position).normalized()

	# Calculate velocity
	var speed := base_movement_speed * _cached_movement_modifier * stats.get_work_efficiency()
	var desired_velocity := direction * speed

	# Smooth rotation towards movement direction
	if direction.length() > 0.1:
		var target_rotation := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)

	# Use avoidance if enabled
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = desired_velocity
	else:
		velocity = desired_velocity
		move_and_slide()


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_navigation_finished() -> void:
	if current_state == State.MOVING:
		current_state = State.IDLE
		reached_destination.emit()


# --- Tasks ---

func assign_task(task_type: String, target: Variant = null) -> void:
	## Assign a work task to this survivor.
	current_task = {
		"type": task_type,
		"target": target,
		"progress": 0.0
	}

	# Move to target if it has a position
	if target is Node3D:
		move_to(target.global_position)
	elif target is Vector3:
		move_to(target)
	else:
		current_state = State.WORKING


func _process_work(delta: float) -> void:
	if current_task.is_empty():
		current_state = State.IDLE
		return

	# Drain energy while working
	stats.energy -= stats.energy_decay_rate * delta * _cached_hunger_modifier

	# Progress the task based on efficiency
	var efficiency := stats.get_work_efficiency()
	current_task.progress += delta * efficiency

	# Check for exhaustion
	if stats.is_exhausted():
		current_state = State.RESTING
		return


func complete_current_task() -> void:
	## Called when a task is finished externally.
	var task_type: String = current_task.get("type", "unknown")
	current_task.clear()
	current_state = State.IDLE
	task_completed.emit(task_type)


# --- Rest ---

func start_resting() -> void:
	current_state = State.RESTING


func _process_rest(delta: float) -> void:
	stats.rest(delta * 0.1)  # Slow recovery while resting

	if stats.energy >= 80.0:
		current_state = State.IDLE


# --- Flee ---

func flee_from(threat_position: Vector3) -> void:
	## Run away from a threat.
	if not _cached_flees_combat:
		return  # Only cowards flee

	current_state = State.FLEEING
	var flee_direction := (global_position - threat_position).normalized()
	var flee_target := global_position + flee_direction * 20.0
	navigation_agent.target_position = flee_target


func _process_flee(delta: float) -> void:
	_process_movement(delta)

	# Stop fleeing when we reach safety (or get tired)
	if navigation_agent.is_navigation_finished() or stats.is_exhausted():
		current_state = State.IDLE


# --- Selection ---

func select() -> void:
	is_selected = true
	selected.emit()
	_show_selection_indicator(true)


func deselect() -> void:
	is_selected = false
	deselected.emit()
	_show_selection_indicator(false)


func _show_selection_indicator(show: bool) -> void:
	## Toggle selection indicator visibility.
	var indicator := get_node_or_null("SelectionIndicator")
	if indicator:
		indicator.visible = show


# --- Health / Death ---

func _on_health_died() -> void:
	current_state = State.DEAD
	died.emit(self)
	# Disable collision and other cleanup
	collision_shape.disabled = true
	set_physics_process(false)


func _on_health_changed(amount: int, _type: int) -> void:
	# Sync health component with stats
	if health_component:
		stats.health = health_component.current_health


func take_damage(amount: float) -> void:
	if health_component and health_component.has_method("damage"):
		health_component.damage(amount)
	else:
		stats.health -= amount
		if stats.is_dead():
			_on_health_died()


func heal(amount: float) -> void:
	if health_component and health_component.has_method("health"):
		health_component.health(amount)
	else:
		stats.heal(amount)


# --- Needs Update ---

func update_needs(delta_hours: float, is_in_shelter: bool, is_near_fire: bool, ambient_temp: float) -> void:
	## Called by TimeManager each in-game hour.
	var is_working := current_state == State.WORKING

	stats.apply_hourly_decay(is_working, is_in_shelter, is_near_fire, ambient_temp)

	# Emit critical need signals
	if stats.is_starving():
		need_critical.emit("hunger", stats.hunger)
	if stats.is_freezing():
		need_critical.emit("warmth", stats.warmth)
	if stats.is_exhausted():
		need_critical.emit("energy", stats.energy)

	# Check for death from needs
	if stats.is_dead():
		_on_health_died()


# --- Utility ---

func get_effective_skill(skill_name: String) -> float:
	## Returns skill value modified by current condition.
	var base_skill: float = 0.0
	match skill_name:
		"hunting":
			base_skill = stats.hunting_skill
		"construction":
			base_skill = stats.construction_skill
		"medicine":
			base_skill = stats.medicine_skill
		"navigation":
			base_skill = stats.navigation_skill
		"survival":
			base_skill = stats.survival_skill

	return base_skill * stats.get_work_efficiency()


func has_trait(trait_id: String) -> bool:
	for survivor_trait in traits:
		if survivor_trait.id == trait_id:
			return true
	return false


func get_morale_aura() -> float:
	return _cached_morale_aura


func should_flee_combat() -> bool:
	return _cached_flees_combat


func get_display_info() -> Dictionary:
	## Returns info for UI display.
	return {
		"name": survivor_name,
		"state": State.keys()[current_state],
		"hunger": stats.hunger,
		"warmth": stats.warmth,
		"health": stats.health,
		"morale": stats.morale,
		"energy": stats.energy,
		"traits": traits.map(func(t): return t.display_name)
	}
