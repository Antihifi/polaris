# Known Issues / Bugs

Tracked bugs and issues to fix.


ship is instantiated in procedural mode with a pitch tilt rather than being relatively flat with a lateral tilt as in main.tscn
---

## AI Behavior

- [ ] Men sleep by fire rather than in beds
- [ ] Men clump in crescents at fire, not facing fire
- [ ] Men do not sit on crates while in wander behavior
- [ ] Need to adjust radius at which men will seek needs:
  - Beyond 100 meters, men cannot find needs without assistance (override to move)
  - Beyond 50m in bad weather
  - Beyond 10m in blizzard conditions
men are sitting at fire instead of crates

## UI

- [ ] Men roster UI not updating with current actual count on instantiation
