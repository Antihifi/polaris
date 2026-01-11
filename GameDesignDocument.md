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

### Character Types

| Type | Count | Control | Behavior |
|------|-------|---------|----------|
| **Officers** | Up to 12 | Player-controlled | Active tasks: hunting, exploring, building, cooking |
| **The Men** | Remaining | AI-controlled | Survival tasks: eat, sleep, warm, fuel fires |
| **Captain** | 1 | Player-controlled | Provides morale aura, can promote Men to Officers |

When an Officer dies, Captain promotes a random Man to Officer status.

### Stat Interactions & Cascading Effects

**Energy → Hunger Cascade:**
| Energy Level | Hunger Drain Multiplier |
|--------------|------------------------|
| ≥50% | 1.0x (normal) |
| 25-49% | 1.5x (increased appetite) |
| <25% | 2.5x (body burning reserves) |

**Body Temperature → Energy & Hunger:**
| Warmth Level | Energy Drain | Hunger Drain |
|--------------|--------------|--------------|
| ≥50% | 1.0x | 1.0x |
| 25-49% | 1.5x | 1.25x |
| <25% | 2.5x | 2.0x |

**Combined Critical State:**
When multiple stats are critically low (<25%), health and morale decline rapidly:
- 2+ critical stats: 2x health/morale drain
- 3+ critical stats: 4x health/morale drain

### Dying Condition

When hunger, energy, OR warmth reaches 0:
- Unit enters "Dying" state
- Health drains at 5.0/hour
- Cause of death: Starvation, Exhaustion, or Hypothermia
- Only medical intervention or immediate need fulfillment can save them
- Dead characters become lootable corpses containing 2-6 human meat (1x1 each)

### Mental Breaks (Morale = 0)

When morale reaches 0, character "snaps" and exhibits dangerous behavior:

| Condition | Break Type | Behavior |
|-----------|------------|----------|
| Morale = 0, Hunger > 25 | Berserk | Attacks other survivors |
| Morale = 0, Hunger ≤ 25 | Food Binge | Consumes all available food recklessly |
| Morale = 0, Hunger = 0 | Wendigo | Kills and consumes other survivors |

**Note:** High morale characters will NOT break regardless of physical condition. They will simply die of starvation/exposure/exhaustion with dignity.

### Morale Modifiers

**Boosters:**
| Source | Boost | Frequency |
|--------|-------|-----------|
| Direct sunlight (daytime outdoors) | +0.5/hr | Continuous |
| Proximity to Captain (<20m) | +1.0/hr | Continuous |
| Proximity to "Personable" survivor | +0.5/hr | Continuous |
| Rum consumption | +15 | One-time |
| Quality food (canned meat, salt pork, fresh seal) | +5 | Per meal |
| Near fire with 1+ others | +0.25/hr | Continuous |
| Near fire with friend | +1.0/hr | Continuous |
| End of storm/blizzard | +10 | One-time |
| Hunting kill | +20 | One-time |
| Witness hunting kill (<150m) | +5 | One-time |

**Drains:**
| Source | Drain | Frequency |
|--------|-------|-----------|
| Prolonged low light (winter darkness) | -0.5/hr | Continuous |
| Death of friend | -30 | One-time |
| Death of other survivor | -15 | One-time |
| Witness cannibalism (<150m) | -20 | One-time |
| Consuming human meat | -40 | Per meal |
| Snowstorm | -0.25/hr | Continuous |
| Blizzard | -1.0/hr | Continuous |
| Forced march in blizzard | -2.0/hr | Continuous |
| Multiple days of low-quality food | -5/day | After 2+ days |
| Man-hauling sleds | -0.25/hr | Continuous |

### Temperature Modifiers

**Warmers:**
| Source | Effect |
|--------|--------|
| Rum | +10 warmth (one-time) |
| Fire proximity (<5m) | +5.0/hr |
| Basic shelter (tent) | +2.0/hr, halves cold damage |
| Improved shelter | +3.0/hr, 75% cold reduction |
| Direct sunlight | +1.0/hr |
| Inuit cold gear | 80% cold reduction |
| Western cold gear | 40% cold reduction |

**Cold Exposure (without appropriate gear):**
| Ambient Temp | Effect | Mitigation |
|--------------|--------|------------|
| 0°C to -19°C | -2.0 warmth/hr | Western or Inuit CWG negates |
| -20°C to -39°C | -4.0 warmth/hr | Inuit CWG negates |
| ≤-40°C | -8.0 warmth/hr (extreme) | -2.0 with Western CWG, -0.5 with Inuit CWG |

**Night Multiplier:**
Being in darkness (nighttime) DOUBLES cold effects when combined with sub-zero temperatures.

### Health Modifiers

**Recovery (requires all base stats ≥75%):**
- Base: +1.0 health/hr
- With western medicine: +2.0 health/hr
- With Inuit medicine: +2.0 health/hr

**Damage Sources:**
| Source | Damage |
|--------|--------|
| Any base stat (temp/energy/hunger) at 0 | -5.0 health/hr |
| Lead poisoning (bad canned food) | -2.0 health/hr until treated |
| Scurvy (no vitamin C for 14+ days) | -1.0 health/hr, -50% work efficiency |

**Scurvy Prevention:**
- Pemmican: Small vitamin C (resets timer by 3 days)
- Seal liver: Large vitamin C (resets timer fully)

### Energy Modifiers

**Recovery:**
| Source | Effect |
|--------|--------|
| Resting (idle, not working) | +3.0 energy/hr |
| Sleeping in tent | +6.0 energy/hr |
| Sleeping in improved shelter | +8.0 energy/hr |
| Rum | +5 energy (one-time) |
| Any food consumption | +2 energy (one-time) |
| Direct sunlight | +0.5 energy/hr |
| Warm day (>0°C) | +1.0 energy/hr |

**Drains:**
| Activity | Drain |
|----------|-------|
| Walking | -0.5 energy/hr |
| Running | -2.0 energy/hr |
| Man-hauling | -3.0 energy/hr |
| Building/construction | -1.5 energy/hr |
| Hunting | -1.0 energy/hr |
| Fishing | -0.5 energy/hr |
| Fighting | -4.0 energy/hr |
| Carrying heavy load | +50% to activity drain |

**Cascading Drains:**
- Hungry (<50%): +25% energy drain
- Very hungry (<25%): +75% energy drain
- Cold (<50%): +25% energy drain
- Freezing (<25%): +75% energy drain

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

### Procedural Island Generation

#### Historical Context
The game is set on a fictionalized King William Island, September 1846. The ship became trapped in an inlet on the northern part of the island near Victory Point. The crew mistakenly sailed in thinking it led to open water. A subsequent quick deep freeze caught them off guard, freezing the ship in place. There is no hope of cutting their way out. They settle in for winter, but ice shifts and crushes the boat irreparably. The ship remains usable as makeshift shelter (not enough for the whole crew), and half their supplies are lost.

#### Island Shape & Dimensions
- **Shape**: Teardrop, narrow end north, wide end south
- **Size**: ~12km (N-S) × ~9km (E-W), approximately 100 km²
- **Starting Position**: Ship trapped in procedurally generated inlet on north coast (random east or west side)

#### Boundaries (No Artificial Walls)

| Direction | Boundary Type | Conditions |
|-----------|---------------|------------|
| North | Endless arctic ice | -60°C, permanent blizzard, total darkness, zero resources, no Inuit, certain death |
| East | Endless arctic ice | Same as North |
| West | Endless arctic ice | Same as North |
| South | Ocean water | Impassable (visual only) |

The ice zones are fully traversable - no invisible walls or force fields. Players can walk north to their doom if they choose. This maintains realism while naturally constraining gameplay.

#### Terrain Features
- **Cliffs & Ice Cliffs**: Rocky and ice faces, creates natural barriers and chokepoints
- **Beaches**: Low elevation coastal areas, primarily on south shore
- **Inlets & Minor Fjords**: Water intrusions into coastline, sheltered areas
- **Hills & Slopes**: Rolling terrain throughout the island
- **Flat Plains**: Common, especially in central and southern regions - best for travel
- **Mountains**: Lower peaks under 400m, concentrated in central areas

#### Regional Characteristics

| Region | Characteristics | Travel Difficulty |
|--------|-----------------|-------------------|
| Northern (ship start) | Narrow, rugged, inlet features, higher elevation | Difficult |
| Central | Mixed terrain, mountains, hills, some flat areas | Moderate |
| Southern | Wide, gentle downhill slope, beaches | Easy (favorable for sled travel) |

#### Points of Interest

| POI | Count | Placement | Purpose |
|-----|-------|-----------|---------|
| Ship Wreck | 1 | Generated inlet, north coast | Starting location, partial shelter, salvage |
| HBC Whaling Station | 1 | South coast, ~8-10km from ship | Rescue destination, guaranteed salvation |
| Inuit Village | 1-2 | 2-4km from ship, accessible terrain | Trading, information, survival aid |

**Travel Distances**: At ~1km per week (accounting for blizzards, animal attacks, hunting stops, medical care, etc.), reaching the HBC station takes approximately 8 weeks of dedicated travel. This journey is the core challenge of the game.

#### Terrain Textures

| Texture | Location | Notes |
|---------|----------|-------|
| Snow | Default, high elevation | Primary surface covering most of island |
| Rock | Steep slopes (>35°), cliff faces | Exposed rock, difficult terrain |
| Ice | Sea level edges, frozen water | Slippery, cold, transition to ice zones |
| Gravel | Low elevation, transitions | Beaches, paths, easier travel |
| Beach Sand | Southern beaches | Limited areas near water |

#### Seed System
- Each island is generated from a numeric seed
- Seed is visible on new game screen and in pause menu
- Players can enter specific seeds to replay islands
- Seeds can be shared between players (e.g., "Try seed A3F7BC12!")
- Same seed always generates identical terrain, POI positions, and features

#### Procedural Elements
- Island coastline shape (within teardrop constraints)
- Mountain and hill placement
- Inlet location and shape (east or west of north coast)
- POI exact positions (within distance rules)
- Texture variation patterns
- Fjord and cliff locations

#### Generation Process
At new game start:
1. Generate island shape mask (teardrop)
2. Create heightmap with multi-octave noise
3. Carve inlet for ship spawn
4. Paint textures based on height/slope
5. Bake navigation mesh (30-60 seconds)
6. Place POIs with distance validation
7. Verify all POIs reachable via pathfinding

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
