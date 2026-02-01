# Known Issues / Bugs

Tracked bugs and issues to fix.

## Spawning Issues

- [ ] ship is instantiated in procedural mode with a pitch tilt rather than being relatively flat with a lateral tilt as in main.tscn
- [ ] Unit and item spawner in procedural/demo mode should spawn on relatively flat ground; currently units sometimes spawn on cliffsides
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
- [ ] Terrain go-to click-handling for unit move orders is extremely unreliable at certain camera angles, especially oblique or head-on. Top-down tends to be accurate. Needs substantial investigation and documentation of root cause.

## Terrain / Nav Mesh

- [ ] Units still occasionally get stuck in valid game geometry - create UNSTUCK button that raises unit 2-3 meters from location and releases them
- [ ] Officers get stuck in procedural terrain on seemingly passable ground. Need a more robust automated "stuck" detection system: if a unit has not moved toward its destination in ~3 seconds, pick it up by ~1m and release in the same spot, allowing gravity to unstick it from terrain
- [ ] Officers frequently get trapped in small terrain divots (~3m diameter crater-like depressions), especially near the ship spawn area. Unit stands in the depression and cannot navigate out despite the terrain appearing passable visually
