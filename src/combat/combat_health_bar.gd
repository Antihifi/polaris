class_name CombatHealthBar extends Node3D
## Health bar that displays above combatants during combat.
## Connects to CombatComponent signals for efficient updates.

@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
@onready var sprite: Sprite3D = $Sprite3D

var combat_component: CombatComponent
var _flash_tween: Tween
var _is_flashing: bool = false


func _ready() -> void:
	visible = false
	# Defer connection to ensure siblings are ready
	call_deferred("_deferred_init")


func _deferred_init() -> void:
	# Auto-find CombatComponent in parent (sibling node)
	var parent := get_parent()
	if parent:
		combat_component = parent.get_node_or_null("CombatComponent")
		if combat_component:
			_connect_signals()
		else:
			push_warning("[CombatHealthBar] No CombatComponent found in parent: %s" % parent.name)


func initialize(component: CombatComponent) -> void:
	## Manual initialization if not auto-detected.
	combat_component = component
	_connect_signals()


func _connect_signals() -> void:
	if not combat_component:
		return
	# Avoid duplicate connections
	if not combat_component.combat_started.is_connected(_on_combat_started):
		combat_component.combat_started.connect(_on_combat_started)
	if not combat_component.combat_ended.is_connected(_on_combat_ended):
		combat_component.combat_ended.connect(_on_combat_ended)
	if not combat_component.health_changed.is_connected(_on_health_changed):
		combat_component.health_changed.connect(_on_health_changed)
	if not combat_component.died.is_connected(_on_died):
		combat_component.died.connect(_on_died)


func _on_combat_started(_target: Node3D) -> void:
	visible = true
	_update_bar()


func _on_combat_ended() -> void:
	visible = false


func _on_health_changed(new_health: float, max_health: float) -> void:
	# Don't show/update if entity is dead
	if combat_component and combat_component.is_dead():
		_stop_flash()
		visible = false
		return
	if not visible and new_health < max_health:
		visible = true  # Show when taking damage
	progress_bar.value = (new_health / max_health) * 100.0 if max_health > 0 else 0.0

	# Flash when bleeding from dismemberment
	var dc := get_parent().get_node_or_null("DismembermentComponent")
	if dc and dc.is_bleeding:
		visible = true
		_start_flash()
	elif _is_flashing:
		_stop_flash()


func _on_died() -> void:
	_stop_flash()
	visible = false


func _update_bar() -> void:
	if combat_component:
		progress_bar.value = combat_component.get_health_percent() * 100.0


func _start_flash() -> void:
	if _is_flashing:
		return
	_is_flashing = true
	_flash_tween = create_tween().set_loops()
	_flash_tween.tween_property(progress_bar, "modulate", Color(1, 0.2, 0.2, 1.0), 0.4)
	_flash_tween.tween_property(progress_bar, "modulate", Color(1, 1, 1, 1.0), 0.4)


func _stop_flash() -> void:
	if not _is_flashing:
		return
	_is_flashing = false
	if _flash_tween:
		_flash_tween.kill()
		_flash_tween = null
	progress_bar.modulate = Color.WHITE
