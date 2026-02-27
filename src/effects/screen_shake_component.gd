class_name ScreenShakeComponent extends Node
## Triggers distance-scaled camera shake in response to signals.
## Add as child to any node that should cause screen shake.
##
## Auto-discovers CombatComponent on parent and connects to took_damage.
## Also connects to parent's impact_occurred signal for generic events
## (ship destruction, ice shifting, explosions, etc.).

@export_category("Intensity")
## Base shake intensity for a full-damage combat hit.
@export var base_intensity: float = 0.15
## Base shake duration in seconds.
@export var base_duration: float = 0.3
## Damage amount that produces full base_intensity (e.g. bear hit = 35).
@export var damage_scale_reference: float = 35.0
## Hard cap on shake intensity sent to camera.
@export var max_intensity: float = 0.35

@export_category("Distance Falloff")
## Full shake intensity within this distance (meters).
@export var full_intensity_range: float = 8.0
## No shake beyond this distance (meters).
@export var max_range: float = 30.0


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	var parent := get_parent()
	if not parent:
		return

	# Combat: auto-discover CombatComponent
	var combat_comp: Node = null
	if parent.has_node("CombatComponent"):
		combat_comp = parent.get_node("CombatComponent")
	elif "combat" in parent and parent.combat:
		combat_comp = parent.combat

	if combat_comp and combat_comp.has_signal("took_damage"):
		combat_comp.took_damage.connect(_on_took_damage)

	# Generic impact signal (ship destruction, ice, explosions, etc.)
	if parent.has_signal("impact_occurred"):
		parent.impact_occurred.connect(_on_impact_occurred)


func _on_took_damage(amount: float, _attacker: Node3D) -> void:
	var damage_factor := clampf(amount / damage_scale_reference, 0.2, 1.0)
	var intensity := base_intensity * damage_factor
	var duration := base_duration * clampf(damage_factor, 0.5, 1.0)
	_apply_shake(intensity, duration)


func _on_impact_occurred(intensity: float, duration: float) -> void:
	_apply_shake(intensity, duration)


func _apply_shake(intensity: float, duration: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if not camera or not camera.has_method("shake"):
		return

	var parent := get_parent()
	if not parent or not parent is Node3D:
		return

	var dist := (parent as Node3D).global_position.distance_to(camera.global_position)
	var range_span := max_range - full_intensity_range
	var factor := clampf(1.0 - (dist - full_intensity_range) / range_span, 0.0, 1.0) if range_span > 0.0 else 1.0
	if factor <= 0.0:
		return

	var final_intensity := minf(intensity * factor, max_intensity)
	var final_duration := duration * maxf(factor, 0.5)
	camera.shake(final_intensity, final_duration)
