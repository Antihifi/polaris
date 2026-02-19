class_name SkillIndicatorComponent extends Node3D
## Toggles visibility of editor-placed skill icons above a unit's head.
## Attach as child of ClickableUnit with Sprite3D children placed in the editor.
## The script only shows/hides — all visuals are configured in the .tscn scene.

## Maps a child Sprite3D node name to an inventory check condition.
## "node" - name of the Sprite3D child, "check" - detection method, "value" - match target.
const SKILL_ICON_CONFIG: Array[Dictionary] = [
	{
		"node": "SkillIconNavigator",
		"check": "subcategory",
		"value": "navigation",
	},
]

var _unit: ClickableUnit = null


func _ready() -> void:
	_unit = get_parent() as ClickableUnit
	if not _unit:
		push_warning("[SkillIndicator] Parent is not a ClickableUnit, disabling.")
		return

	_unit.inventory_changed.connect(_refresh)
	_unit.stats_changed.connect(_refresh)
	call_deferred("_refresh")


func _refresh() -> void:
	if not _unit or not _unit.inventory:
		return

	var alive: bool = not _unit.is_dead
	for config: Dictionary in SKILL_ICON_CONFIG:
		var icon: Sprite3D = get_node_or_null(config["node"]) as Sprite3D
		if not icon:
			continue
		icon.visible = alive and _check_condition(config)


func _check_condition(config: Dictionary) -> bool:
	var check_type: String = config["check"]
	var check_value: String = config["value"]

	match check_type:
		"subcategory":
			return _has_item_with_subcategory(check_value)
		"item_id":
			return _unit.has_item_by_id(check_value)
		_:
			return false


func _has_item_with_subcategory(subcategory: String) -> bool:
	for item: InventoryItem in _unit.inventory.get_items():
		if item.get_property("subcategory", "") == subcategory:
			return true
	return false
