class_name DemoShipDestructionScheduler
extends Node
## Automates progressive ship destruction over 7 game days.
## Connects to TimeManager signals and calls DemolitionTestController methods.
##
## Destruction phases progress realistically:
##   Days 1-2: Rigging snaps, shrouds fail
##   Days 2-4: Masts shake and collapse top-down
##   Days 3-5: Hull and deck pieces blown outward
##   Days 3-7: Incremental sinking events
##   Day 7:    Final destruction of remaining structure

signal destruction_event_occurred(event_type: String)
signal ship_fully_destroyed
signal ship_swap_requested

@export var total_destruction_days: int = 7
@export var explosive_events_per_day_min: int = 1
@export var explosive_events_per_day_max: int = 3
@export var rigging_events_per_day: int = 3
@export var sink_events_per_day_min: int = 1
@export var sink_events_per_day_max: int = 2

## Reference to the DemolitionTestController (set by demo_controller after spawning)
var demolition_controller: Node = null

## Internal state
var _current_day: int = 0
var _scheduled_events: Array[Dictionary] = []  # [{hour: int, type: String}]
var _destruction_complete: bool = false
var _ship_swapped: bool = false
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

## Destruction phases
enum Phase { RIGGING, SHROUDS, MASTS, HULL_DECK, SINKING, FINAL }


func _ready() -> void:
	_rng.randomize()
	var time_manager: Node = get_node_or_null("/root/TimeManager")
	if time_manager:
		time_manager.day_passed.connect(_on_day_passed)
		time_manager.hour_passed.connect(_on_hour_passed)
	else:
		push_warning("[DemoShipDestructionScheduler] TimeManager not found")


func _on_day_passed(_day: int) -> void:
	_current_day += 1
	if _destruction_complete:
		return

	if _current_day >= total_destruction_days:
		_finalize_destruction()
		return

	_schedule_today_events()


func _schedule_today_events() -> void:
	## Generate random event times for today based on current destruction phase.
	_scheduled_events.clear()

	# Determine which phases are active today
	var active_phases: Array[Phase] = _get_active_phases()

	# Schedule dedicated rigging events if in rigging phase, to ensure masts become vulnerable
	if active_phases.has(Phase.RIGGING):
		for i in range(rigging_events_per_day):
			var hour: int = _rng.randi_range(6, 22)
			_scheduled_events.append({"hour": hour, "phase": Phase.RIGGING})
		# Prevent explosive events from also being rigging
		active_phases.erase(Phase.RIGGING)

	# Schedule other explosive events from remaining active phases
	if not active_phases.is_empty():
		var explosive_count: int = _rng.randi_range(explosive_events_per_day_min, explosive_events_per_day_max)
		for i in range(explosive_count):
			var phase: Phase = active_phases[_rng.randi_range(0, active_phases.size() - 1)]
			var hour: int = _rng.randi_range(6, 22)  # Daytime events
			_scheduled_events.append({"hour": hour, "phase": phase})

	# Schedule sink events (start from day 1 alongside destruction)
	if _current_day >= 1:
		var sink_count: int = _rng.randi_range(sink_events_per_day_min, sink_events_per_day_max)
		for i in range(sink_count):
			var hour: int = _rng.randi_range(8, 20)
			_scheduled_events.append({"hour": hour, "phase": Phase.SINKING})

	# Sort by hour so they fire in order
	_scheduled_events.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.hour < b.hour
	)

	print("[DemoDestruction] Day %d: Scheduled %d events" % [_current_day, _scheduled_events.size()])


func _get_active_phases() -> Array[Phase]:
	## Determine which destruction phases are active based on current day.
	var phases: Array[Phase] = []

	if _current_day <= 2:
		phases.append(Phase.RIGGING)
	if _current_day >= 1 and _current_day <= 3:
		phases.append(Phase.SHROUDS)
	if _current_day >= 2 and _current_day <= 4:
		phases.append(Phase.MASTS)
	if _current_day >= 3:
		phases.append(Phase.HULL_DECK)

	if phases.is_empty():
		phases.append(Phase.HULL_DECK)

	return phases


func _on_hour_passed(hour: int, _day: int) -> void:
	if _destruction_complete or not demolition_controller:
		return

	# Check for events scheduled at this hour
	var events_this_hour: Array[Dictionary] = []
	for event in _scheduled_events:
		if event.hour == hour:
			events_this_hour.append(event)

	for event in events_this_hour:
		_execute_destruction_event(event.phase)
		_scheduled_events.erase(event)


func _execute_destruction_event(phase: Phase) -> void:
	## Execute the appropriate destruction based on phase.
	## On the first event, swap from simplified to fragmented ship model.
	if not demolition_controller:
		return

	if not _ship_swapped:
		ship_swap_requested.emit()
		_ship_swapped = true

	match phase:
		Phase.RIGGING:
			demolition_controller._destroy_rigging_single()
			destruction_event_occurred.emit("rigging")
		Phase.SHROUDS:
			demolition_controller._destroy_shroud_single()
			destruction_event_occurred.emit("shroud")
		Phase.MASTS:
			demolition_controller._destroy_mast_progressive()
			destruction_event_occurred.emit("mast")
		Phase.HULL_DECK:
			if _rng.randf() < 0.5:
				demolition_controller._destroy_hull_progressive()
				destruction_event_occurred.emit("hull")
			else:
				demolition_controller._destroy_deck_progressive()
				destruction_event_occurred.emit("deck")
		Phase.SINKING:
			demolition_controller._trigger_sink_event()
			destruction_event_occurred.emit("sink")

	print("[DemoDestruction] Event: %s (day %d)" % [Phase.keys()[phase], _current_day])


func _finalize_destruction() -> void:
	## Day 7+: Destroy everything remaining.
	if _destruction_complete:
		return

	_destruction_complete = true

	if demolition_controller and demolition_controller.has_method("destroy_all"):
		demolition_controller.destroy_all()

	ship_fully_destroyed.emit()
	print("[DemoDestruction] Ship fully destroyed on day %d" % _current_day)
