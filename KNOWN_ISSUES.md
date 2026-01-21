# Known Issues / Bugs

Tracked bugs and issues to fix.

## Spawning Issues

- [ ] ship is instantiated in procedural mode with a pitch tilt rather than being relatively flat with a lateral tilt as in main.tscn
---

## AI Behavior

- [ ] Men sleep by fire rather than in beds
- [x] Men clump in crescents at fire, not facing fire
- [x] Men do not sit on crates while in wander behavior
- [ ] Need to adjust radius at which men will seek needs:
  - Beyond 100 meters, men cannot find needs without assistance (override to move)
  - Beyond 50m in bad weather
  - Beyond 10m in blizzard conditions
- [x] men are sitting at fire instead of crates

## UI

- [ ] Men roster UI not updating with current actual count on instantiation
- [ ] Officer units displaying "idle" while walking to a point
- [ ] Terrain go-to click-handling unresponsive at oblique camera angles

## Terrain / Nav Mesh

- [ ] Units still occasioanally get stuck in valid game geometry - create UNSTUCK button that raises unit 2-3 meters from location and releases them
