# Polaris - Game Design Document

## Overview

**Title:** Polaris
**Genre:** Arctic Survival RTS / Colony Sim
**Engine:** Godot 4.5
**Inspirations:** The Terror (AMC), Franklin & Scott Expeditions, Rimworld, Kenshi, Project Zomboid

### Elevator Pitch
A brutal arctic survival RTS where 10-16 shipwreck survivors must endure a year of polar hell until rescue arrives. Manage dwindling resources, deteriorating mental states, and impossible choices. Death is all but certain.

### Core Pillars
1. **Desperate Survival** - Resources are scarce, weather is lethal, rescue is distant
2. **Human Drama** - Personalities clash, mental states break, cannibalism beckons
3. **Impossible Choices** - Leave the weak behind, trade with or exploit natives, sacrifice few to save many
4. **Historical Authenticity** - Period-accurate equipment, realistic polar conditions, exploration-era atmosphere

---

## Game Flow

### Start Condition (MVP)
Game begins with survivors already on shore with randomized salvage from their crushed/sunken ship. No interactive ship-sinking sequence for MVP.

### Win Condition
Survive until rescue ship arrives. At least one survivor must be alive.
- **Rescue Timer:** 365 days + random(30-180) days
- **Score Based On:** Survivors alive, resources stockpiled, average morale

### Lose Condition
All survivors dead.

### Core Gameplay Loop
1. **Survive** - Manage hunger, cold, health, morale for all survivors
2. **Build** - Construct shelters, fire pits, workshops to improve survival odds
3. **Gather** - Hunt seals/birds, scavenge, trade with natives
4. **Explore** - Send expeditions to find whaling bases, native camps, set rescue signals
5. **Endure** - Weather mental breaks, animal attacks, illness, interpersonal conflict

---

## Characters

### Survivor Count
10-16 survivors per game (randomized)

### Needs (0-100 scale, lower = worse)
| Need | Description | Consequences at Low |
|------|-------------|---------------------|
| Hunger | Decreases over time, restored by eating | Starvation death, reduced work speed |
| Cold | Affected by clothing, shelter, fire proximity | Frostbite damage, hypothermia death |
| Health | Damage from combat, cold, illness | Death at zero |
| Morale | Affected by events, comfort, companions | Reduced efficiency, mental breaks |
| Energy | Depleted by work, restored by rest | Collapse, forced rest |

### Skills (affect task efficiency)
- **Hunting** - Success rate for hunting, butchering yield
- **Construction** - Building speed
- **Medicine** - Healing effectiveness
- **Navigation** - Expedition success, pathfinding
- **Cold Resistance** - Slower cold buildup
- **Survival** - General efficiency bonus

### Traits (permanent modifiers)
| Trait | Effect |
|-------|--------|
| Drunkard | +50% ration consumption, +morale when drunk |
| Coward | Flees combat, -morale during danger |
| Combative | +damage, -morale to nearby survivors |
| Personable | +morale to nearby survivors |
| Affable | Faster trade with natives |
| Strong | +carry capacity, +construction speed |
| Weak | -carry capacity, -construction speed |
| Cold Blooded | Slower cold buildup |
| Leader | +morale aura, priority in conflicts |

### Behavior AI
**Priority Order:**
1. Player direct commands (move here, do this)
2. Critical needs (freezing → seek warmth, starving → seek food)
3. Assigned work tasks
4. Idle behavior

Characters autonomously:
- Seek food when hungry (from stockpile)
- Seek warmth when cold (fire, shelter)
- Rest when exhausted
- Flee danger if Coward trait

---

## Controls

### Camera
- **Movement:** WASD / Arrow keys / Edge scrolling
- **Zoom:** Mouse wheel
- **Rotation:** Middle mouse drag (yaw/pitch orbit)
- **Speed Boost:** Hold Shift

### Selection
- **Single Select:** Left click character
- **Multi-Select:** Ctrl+click or drag box
- **Control Groups:** Ctrl+1-9 to assign, 1-9 to recall
- **Portrait Bar:** Sidebar showing all survivors, click to select

### Commands
- **Move:** Right-click ground
- **Interact:** Right-click object (stockpile, building, resource)
- **Context Menu:** Right-click for action options

### Time Controls
- **Pause:** Space
- **Normal:** 1x speed
- **Fast:** 2x speed
- **Faster:** 4x speed

---

## World

### Map
Procedurally generated arctic terrain using Terrain3D. Features:
- Ice fields
- Rocky outcrops
- Frozen coastline
- Snow drifts

### Time & Seasons
| Season | Duration | Day Length | Temperature | Notes |
|--------|----------|------------|-------------|-------|
| Summer | 90 days | 20hr light | Mild cold | Best hunting, travel |
| Autumn | 90 days | 12hr light | Cold | Prepare for winter |
| Winter | 90 days | 4hr light | Severe cold | Survival mode, limited activity |
| Spring | 95+ days | 12hr light | Cold | Rescue approaches |

### Weather Events (Nice to Have)
- Blizzard (extreme cold, no visibility, no travel)
- Fog (reduced visibility)
- Clear skies (normal conditions)
- Aurora (morale boost)

---

## Items & Resources

### Categories

**Food:**
| Item | Nutrition | Notes |
|------|-----------|-------|
| Canned Goods | High | From ship salvage, finite |
| Pemmican | Medium | From ship salvage, finite |
| Seal Meat (raw) | Medium | Must cook, huntable |
| Seal Meat (cooked) | High | Safe to eat |
| Bird Meat | Low | Huntable (puffins, etc.) |
| Wolf Meat | Medium | Risky to eat raw |
| Polar Bear Meat | High | Risky to eat raw, dangerous to obtain |
| Whale Meat | Very High | Trade with natives or rare whale kill |
| Human Meat | High | Massive morale penalty, mental break risk |

**Fuel:**
| Item | Burn Time | Source |
|------|-----------|--------|
| Coal | Long | Ship salvage |
| Whale Oil | Long | Trade/whaling |
| Whale Blubber | Medium | Trade/whaling |
| Wood | Short | Ship salvage, scavenging |

**Materials:**
- Wood Planks
- Nails
- Scrap Metal
- Rope
- Canvas

**Clothing:**
| Item | Cold Protection | Source |
|------|-----------------|--------|
| Western Arctic Gear | Medium | Ship salvage |
| Native Cold Gear | High | Trade with natives |

**Tools:**
- Axe (construction, combat)
- Saw (construction)
- Hunting Rifle (hunting, combat)
- Harpoon (hunting)

**Weapons:**
- Rifle (ranged)
- Pistol (ranged, short)
- Knife (melee)

### Inventory System
- **Personal Inventory:** Each survivor carries items (weight limit based on Strength)
- **Stockpile:** Shared camp storage, survivors haul to/from

---

## Buildings

### Construction Flow
1. Player selects building from menu
2. Places blueprint (ghost showing placement)
3. Blueprint lists required materials
4. Survivors haul materials to site
5. Survivors construct over time
6. Building complete

### MVP Buildings
| Building | Materials | Function |
|----------|-----------|----------|
| Tent | Canvas, Rope, Wood | Basic shelter, reduces cold |
| Improved Shelter | Wood, Nails, Canvas | Better cold protection, upgrade from tent |
| Storage Pile | None | Stockpile designation |
| Fire Pit | Wood, Stones | Warmth, cooking |
| Workshop | Wood, Nails, Tools | Crafting station |

---

## Crafting

Uses existing IndieBlueprintRecipeManager system.

### Workshop Recipes
| Recipe | Materials | Result |
|--------|-----------|--------|
| Sled | Wood, Rope, Nails | Enables expeditions |
| Small Boat | Wood (lots), Canvas, Rope, Tools | Fishing, rare whaling |
| Cooked Food | Raw Meat + Fire | Safe food |
| Preserved Food | Meat + Salt | Long-lasting food |

### Special Projects

**Sled** - Enables sending expedition parties:
- Find native camps
- Locate whaling bases (instant rescue for expedition members)
- Set up rescue signals (reduces rescue timer)
- Scout terrain

**Small Boat** (need 2 for whaling):
- Increases fishing yield
- Extremely rare whale kill opportunity
- Whale kill = massive resources (oil, blubber, meat, bones)
- Near-guaranteed survival if successful
- Requires almost all tools and materials
- Very high risk of failure/death

---

## Combat

### Threats
| Enemy | Danger | Behavior | Drops |
|-------|--------|----------|-------|
| Wolf | Medium | Pack hunting, attacks weak/alone | Meat, Pelt |
| Polar Bear | High | Solitary, very dangerous | Lots of meat, Pelt |

### Combat System (Simple Rimworld-style)
- Enemies spawn at map edges, frequency increases in winter
- Survivors auto-attack if armed and enemy in range
- Coward trait causes flee behavior
- Health uses IndieBlueprintHealth component
- Death on health reaching zero

---

## Native Interaction

### Native Camp
- One discoverable camp on map (or found via expedition)
- Neutral disposition, can trade

### Trade
**You Give → You Get:**
- Western goods (tools, metal) → Native gear (superior cold protection)
- Western goods → Food (whale meat, seal meat)
- Western goods → Information

### Information Rewards
- Hunting spots (+hunting efficiency)
- Navigation knowledge (+expedition success)
- Whaling base location (expedition can find rescue)
- Survival tips (permanent skill buffs)

---

## Expeditions

Requires: Sled (crafted at Workshop)

### Setup
- Select 1-3 survivors
- Choose expedition type
- They leave for multi-day trip

### Expedition Types
| Type | Duration | Possible Outcomes |
|------|----------|-------------------|
| Scout | 3-5 days | Find nothing, find natives, find resources |
| Find Rescue | 7-14 days | Nothing, whaling base (instant rescue), death |
| Set Signals | 5-7 days | Reduces rescue timer by 30-60 days |

### Risks
- Character death from cold/wildlife
- Getting lost (longer return time)
- Finding nothing

---

## UI Layout

### HUD Elements
- **Top Left:** Date, Day count, Season indicator
- **Top Center:** Time controls (pause, 1x, 2x, 4x)
- **Top Right:** Resource summary (food, fuel, materials)
- **Left Side:** Survivor portrait bar (click to select)
- **Bottom:** Selected unit info panel, action buttons
- **Alerts:** Pop-up notifications for critical events

### Menus
- **Build Menu:** Building selection with costs
- **Crafting Menu:** Workshop recipes
- **Character Panel:** Stats, inventory, traits
- **Trade Menu:** Native camp trading interface

---

## Technical Requirements

### Godot Systems Used
- **Terrain3D:** Procedural arctic terrain
- **NavigationAgent3D:** Character pathfinding
- **IndieBlueprintHealth:** Health/damage system
- **IndieBlueprintRecipeManager:** Crafting system
- **IndieBlueprintLootManager:** Item generation

### Performance Targets
- 16 active characters with AI
- Day/night lighting
- Weather particles (snow)
- Smooth 60fps on mid-range hardware

---

## MVP vs Future Features

### MVP (2 Weeks)
- [x] Arctic terrain
- [x] RTS camera
- [ ] 10-16 survivors with needs
- [ ] Selection and commands
- [ ] Time/season system
- [ ] Basic needs AI
- [ ] Inventory and stockpiles
- [ ] 5 building types
- [ ] Workshop crafting
- [ ] Combat with wolves/bears
- [ ] One native camp with trade
- [ ] Expeditions with sled
- [ ] Win/lose conditions with scoring

### Future Features
- Interactive ship sinking intro
- Mental break system (psychotic breaks, binge eating, violence)
- Multiple native camps with different dispositions
- Weather variety (blizzards, fog, aurora)
- Snow blindness mechanic
- Whale hunting mini-game
- Multiple ending types
- Procedural survivor names and backstories
- Sound design and music
- Save/load system
