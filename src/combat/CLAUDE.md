# Combat System

**Status:** Not Yet Implemented

See [docs/DESIGN.md](../../docs/DESIGN.md#combat-system) for full design specification.

## Quick Summary

- Rare, dangerous, avoidable combat encounters
- Wildlife (polar bears, wolves), environmental damage, hostile humans
- Uses existing `IndieBlueprintHealth` addon and `SurvivorStats` health

## Existing Code (already working)

- Environmental damage in `survivor_stats.gd` (starvation, frostbite)
- Flee behavior in `clickable_unit.gd`
- Combat traits (Coward, Combative) in `trait.gd`
