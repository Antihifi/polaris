MEN AI

men.tscn

semi autonomous enlisted men of stricken icebound polar exploration vessel.  Important to the player because as officers die, men are promoted to officer.  Only officers can be directly controlled
by the player for building, defending, exploring, trading, etc. The win condition is also based on how many men are rescued

RESOURCE NODES (FOR MEN ONLY)

shelter
for now only the stricken ship which has an area3d aoe ship1.tscn

heat source
for now just camp fire aoe campfire1.tscn

food
self explanatory for survival.  spawned in barrels only. 

morale
men have a 10% chance to spawn as well liked.  The captain always has this perk and is more powerful.  Being in proximity of one of these AOEs gives a buff to Morale.


behavior tree / finite state machine

IDLE

can wander ~10M at a time
can SIT ON CRATE
can SOCIALIZE BY FIRE

SEEK SHELTER

when energy is below 25% (60% for testing until dialed in)
when inclement weather (blizzard condition)
when night time ~8 hours of sleep every night at a random 8 hours between sunrise and sunset OR between 10pm and 10am (polar nights can be very long)


SEEK WARMTH

when temperature below 60%


SEEK FOOD

HUNGER BELOW 30% (60% for testing)


IMPORTANT:  one of our biggest issues last time we tried to do this was agents NOT finding or moving to shelter, campfire or barrels

IMPORTANT:  if order of aninmations is tricky, outsource this to an animation tree??!


be careful of proximities.  Consider unit arrived if within 3 meters for testing so as not to overcrowd the node.

IMPORTANT: we have had a lot of issues with NavigationObstacle3d and nav mesh/nav agents.  They get stuck on barrels and crates constantly.  WRITE SIMPLE FALLBACK: 
	CHECK:
		If character has not made progress towards destination in 3 real world seconds, consider unit stuck
			move unit to side 1/2 meter and face 90 degrees and try again, should unstick there is VERY little geometry in this game...

crate seating procedure:
	move to crate
	face unit AWAY from crate positioned at one of the SeatPoints Marker3Ds
	play animation sitting_from_standing
	play animation sitting_depressed (looped)
	wait random amount of time between 30 minutes and 2 hours
	play animation stand up
	return to idle
	
sleeping procedure

	Sleep for:
		~approx 8 hours if "night"
		~until energy at +/- 80% if unit is resting during the day due to very low energy (under 25%)
		
	move to shelter
	align unit with foot_of_bed, head_of_bed Marker3D
	IMPORTANT play stand_up_from_laying_down animation BACKWARDS (I only have this anumation in one directon)
	play sleep animation:
		IF unit has a critically low major stat (hunger, energy, morale, health or temperature)
			play: sleeping_disturbed
		ELIF unit has all stats above critical
			play: sleeping_idle
		ELIF
			PLACEHOLDER: if unit has specific ailment
							play: example sleeping_cough, sleeping_vomit, etc.
	wakeup:
		play stand_up_from_laying_down animation
		
	return to idle
		
eating procedure
	move to barrel (if food available in barrel)
	play opening_a_lid animation
	remove food item from barrel (deplete inventory from that barrel)
	play take_item animation
	eat food
	play take_item animation
	play closing_a_lid animation
	return to idle
	

heating procedure / socializing by fire
	move to fire (3 in scene to start)
	CHECK for units at fire and find an EMPTY spot in a circle around fire
	FACE unit to fire, maintain about ~3 meters distance from fire
	CHOOSE ONE (50/50 for more dynamic feel)
		idle standing
			wait 1-2 hours OR until warmth is > 80%
			play standard idle animation on loop
		idle crouching 
			IMPORTANT play crouch_to_stand animation BACKWARDS (only one anumation here as well)
			wait 1-2 hours OR until warmth is > 80%
			play crouching_idle animation on looop 
			play crouch_to_stand
	return to idle
			
	
IMPORTANT: make sure to show current status (sleeping, eating, etc) or destination (seeking warmth) in 

make sure when under player control always play walking animation after issued an order (we've had issues with floating/sliding units due to not calling anumations correctly)
