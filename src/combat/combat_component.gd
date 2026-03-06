class_name CombatComponent extends Node
## Standardized combat state component. Add as child to any combatant.
## Provides consistent signals for health bars, UI, and combat logic.
##
## Two modes:
## 1. Self-managed health: Set max_health, component tracks health internally
## 2. Delegated health: Set external_stats, component forwards from SurvivorStats

signal combat_started(target: Node3D)
signal combat_ended
signal took_damage(amount: float, attacker: Node3D)
signal died
signal health_changed(new_health: float, max_health: float)

## If > 0, component manages health internally (for Animal)
@export var max_health: float = 0.0

## If set, health is read from this SurvivorStats (for ClickableUnit)
var external_stats: Resource = null

var _health: float = 100.0
var combat_target: Node3D = null
var is_in_combat: bool = false
var _is_dead: bool = false

@onready var owner_node: Node3D = get_parent()


func _ready() -> void:
	if max_health > 0.0:
		_health = max_health
	# Try to find SurvivorStats on parent
	if external_stats == null and owner_node and "stats" in owner_node:
		external_stats = owner_node.stats


var health: float:
	get:
		if external_stats and "health" in external_stats:
			return external_stats.health
		return _health
	set(value):
		if external_stats and "health" in external_stats:
			external_stats.health = value
		else:
			_health = clampf(value, 0.0, get_max_health())
		health_changed.emit(health, get_max_health())
		if health <= 0.0 and not _is_dead:
			_on_death()


func get_max_health() -> float:
	if external_stats and "max_health" in external_stats:
		return external_stats.max_health
	return max_health if max_health > 0.0 else 100.0


func start_combat(target: Node3D) -> void:
	if _is_dead:
		return
	combat_target = target
	is_in_combat = true
	combat_started.emit(target)


func stop_combat() -> void:
	if not is_in_combat:
		return
	combat_target = null
	is_in_combat = false
	combat_ended.emit()


func take_damage(amount: float, attacker: Node3D = null) -> void:
	if _is_dead:
		return
	health -= amount
	took_damage.emit(amount, attacker)

	# Trigger ragdoll for heavy hits (bears do 35 damage)
	if attacker and is_instance_valid(attacker) and amount >= 20.0 and owner_node:
		var ragdoll := owner_node.get_node_or_null("RagdollComponent")
		if ragdoll and not ragdoll.is_ragdolling:
			var dir := (owner_node.global_position - attacker.global_position).normalized()
			dir.y = 0.3
			dir = dir.normalized()
			ragdoll.trigger_ragdoll(dir, ragdoll.impulse_strength)


func _on_death() -> void:
	_is_dead = true
	stop_combat()
	died.emit()


func is_dead() -> bool:
	if external_stats and external_stats.has_method("is_dead"):
		return external_stats.is_dead()
	return _is_dead or health <= 0.0


func get_health_percent() -> float:
	var max_hp := get_max_health()
	return health / max_hp if max_hp > 0.0 else 0.0
