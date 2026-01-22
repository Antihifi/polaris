@tool
extends BTCondition
class_name BTCheckCanWork
## Returns SUCCESS if unit can work (all core stats > 50%), FAILURE otherwise.
## Used to gate autonomous work behaviors for Men.

## Minimum stat threshold for working (0-100).
@export var stat_threshold: float = 50.0


func _generate_name() -> String:
	return "CanWork? [stats > %.0f%%]" % stat_threshold


func _tick(_delta: float) -> Status:
	var agent: Node3D = get_agent()
	if not agent:
		return FAILURE

	# Only Men work autonomously (not Officers or Captain)
	if "rank" in agent:
		var rank: int = agent.rank
		# UnitRank.MAN = 0, OFFICER = 1, CAPTAIN = 2
		if rank != 0:
			return FAILURE

	# Check if unit has stats component
	if not "stats" in agent or not agent.stats:
		return FAILURE

	var stats := agent.stats as SurvivorStats

	# Check all core stats are above threshold
	if stats.hunger <= stat_threshold:
		return FAILURE
	if stats.warmth <= stat_threshold:
		return FAILURE
	if stats.energy <= stat_threshold:
		return FAILURE
	if stats.morale <= stat_threshold:
		return FAILURE

	return SUCCESS
