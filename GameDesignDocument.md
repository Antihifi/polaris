# Polaris - Game Design Document

## Overview

**Title:** Polaris
**Genre:** Arctic Survival RTS / Colony Sim
**Engine:** Godot 4.5
**Inspirations:** The Terror, Franklin & Scott Expeditions, Rimworld, Kenshi, Project Zomboid

### Elevator Pitch
A brutal arctic survival RTS where 30-45 icebound survivors must endure a year of polar hell until rescue arrives. Manage dwindling resources, deteriorating mental states, and impossible choices. Death is all but certain.

### Core Pillars
1. **Desperate Survival** - Resources are scarce, weather is lethal, rescue is distant
2. **Human Drama** - Personalities clash, mental states break, cannibalism beckons
3. **Impossible Choices** - Leave the weak behind, trade with -- or exploit natives -- sacrifice few to save many
4. **Historical Authenticity** - Period-accurate equipment, realistic polar conditions, exploration-era atmosphere

---

## Game Flow

### Start Condition (MVP)
Game begins with survivors already on shore with randomized salvage from their crushed/partially sunken ship. No interactive ship-sinking sequence for MVP.

### Initial Spawn & Early Game Progression

**Base Camp Spawn:**
- **Captain:** 1 (always)
- **Officers:** 2-4 (randomized)
- **Men:** 15-20 (randomized)
- **Location:** Near the trapped ship on the north coast

**Phase 1: Find the Missing Men**

During the chaos of escaping the ship being crushed (and the ensuing snowstorm), several groups of men became separated and are now scattered along the north coast. These "errant groups" represent a critical early-game objective.

| Group Count | Men Per Group | Officers Per Group | Supplies |
|-------------|---------------|-------------------|----------|
| 2-3 groups | 3-5 men each | 0-1 (often none) | Small cache of supplies |

**Errant Group Placement:**
- Spawned via POI spawner along the north coast biome
- Each group includes:
  - 3-5 men
  - 0-1 officer (can be none)
  - 1-3 barrels of food (partially filled, same rules as ship salvage)
  - 1-3 crates of supplies
- Groups are stationary, waiting to be found

**Live Simulation (Full BT):**

Errant groups run full behavior trees from game start. The existing BT handles needs naturally - they will deplete resources, weaken, potentially cannibalize, and die organically without special simulation code.

*Rationale: Adding 6-15 units to the existing 18-25 is negligible overhead. LimboAI is efficient, and idle units doing basic need-checking are cheap. This approach is simpler, creates emergent drama, and requires no special-case code.*

**Camp Setup:**
- **Camp Fire:** Each camp has a small, dim fire (smaller/dimmer than normal campfire). Provides minimal warmth but makes camps hard to spot from distance - player must actively scout.
- **Wandering Limit:** Units are restricted to a small radius around their camp (leash system or BT constraint). Prevents excessive pathfinding and keeps groups cohesive.
- **Path Validation:** POI spawner must verify at least one navigable path exists from ship spawn to each errant camp location.

**Discovery & Recruitment:**

Errant men are NOT immediately selectable. They must be "recruited" to join the colony:

| Requirement | Details |
|-------------|---------|
| Proximity | A Captain or Officer must come within recruitment range (~10-15m) |
| Action | Automatic recruitment on proximity (no manual action needed) |
| Result | Units added to `selectable_units` group, now player-controllable |

*Before recruitment:* Units visible but not selectable, not shown in portrait bar, run autonomous survival BT.
*After recruitment:* Full player control, added to roster, shown in UI.

**Animation LOD (Future - Not MVP):**
- Start/stop animations based on distance from nearest controllable unit
- Reduces overhead for distant errant groups
- Units beyond visible range use simplified or no animation updates

**Time Pressure - Attrition:**
If the player does not find these groups quickly enough:
- Men will begin dying from exposure and starvation
- Survivors may resort to cannibalism, killing and eating each other
- The player may arrive to find only corpses and the grim aftermath
- **Remaining bodies can be used as food/resources** (with standard negative morale penalties for cannibalism)

**Strategic Implications:**

This design intentionally prevents a "speed run" south strategy:
1. **Insufficient Officers:** Starting with only 2-4 officers means the player cannot directly control enough units to execute a long march
2. **Insufficient Men:** 15-20 men cannot establish the necessary supply chain (leap-frogging caches) while pulling sleds
3. **No Full Complement:** The player must build up their force before attempting the southern journey

**Incentivized Behavior:**
- Stay near the north coast initially
- Prioritize scouting for errant groups
- Build up base camp infrastructure
- Accumulate supplies and grow the roster
- **Promote enough officers (goal: 11)** before attempting the dash south to the HBC whaling station

### Win Condition
Survive until rescue ship arrives. At least one survivor must be alive.
- **Rescue Timer:** 365 days + random(30-180) days
- **Score Based On:** Survivors alive, resources stockpiled, average of morale

### Lose Condition
All survivors dead.

### Core Gameplay Loop
1. **Survive** - Manage hunger, cold, health, morale for all survivors
2. **Build** - Construct rudimentary shelters, fire pits, workshops to improve survival odds
3. **Gather** - Hunt seals/birds, scavenge, trade with natives, find cairns of previous expeditions, salvage other previously icebound ships
4. **Explore** - Send expeditions to find Hudson's Bay Company whaling bases, native camps, set rescue signals
5. **Endure** - Weather mental breaks, animal attacks, illness, interpersonal conflict

---

## Characters

### Survivor Count
30-45 survivors per game (randomized)

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
| **Officers** | Up to 11 | Player-controlled | Active tasks: hunting, exploring, building, cooking |
| **The Men** | Remaining | AI-controlled | Survival tasks: eat, sleep, warm, fuel fires |
| **Captain** | 1 | Player-controlled | Provides morale aura, can promote Men to Officers |

When an Officer dies, Captain promotes a random Man to Officer status.

### Promotion System

**Hierarchy Limits:**
- Maximum 1 Captain
- Maximum 11 Officers (plus Captain)
- Unlimited Enlisted Men (usually 30-35 to start)

**Officer Promotion:**
When an officer dies, the player can select a new officer from the pool of enlisted men. Promotion considerations:
- Direct stats of enlisted men are **obscured** - player cannot see exact numbers
- Each man displays earned **Skill Icons** (see Skills section below)
- Longer-surviving men have more skills, making them more valuable
- This creates incentive to keep enlisted men alive as a "bench" of future officers

**Captain Succession:**
If the captain dies:
- Player may promote any officer to captain
- **Cost:** [TO BE DETERMINED]
- **Penalty for no captain:** Large morale debuff to ALL units (regardless of proximity)
- Captain vacancy is a serious strategic problem

**Demotion:**
Units cannot currently be demoted. This prevents exploits such as:
- Trading down officers for more skilled enlisted men
- Intentionally killing weak officers to access the enlisted pool

### Skills (Earned Over Time)

Skills are displayed as icons and are earned by surviving in the arctic. These are distinct from permanent Traits - skills represent learned abilities.

| Skill | Effect | Levels |
|-------|--------|--------|
| **Captain's Presence** | LARGE morale buff to units in LARGE proximity | N/A (Captain only) |
| **Well Liked** | Morale buff to units in proximity | Single level |
| **Polar Navigation** | +0.05m camera view height per skill point (max +5m); compensates for unreliable compass; at higher levels provides pathfinding hints for routes through ice fields/mountains | 3 levels |

**Skill Acquisition:**
- Skills are unlocked based on time survived
- More experienced survivors have more skill icons displayed
- Skills are visible on enlisted men, helping inform promotion decisions

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

### Mental Breaks (Morale < 25%)

When morale drops below 25%, character may "snap" and exhibit dangerous behavior:

| Condition | Break Type | Behavior |
|-----------|------------|----------|
| Morale < 25%, Hunger > 25 | Berserk | Attacks other survivors |
| Morale < 25%, Hunger ≤ 25 | Food Binge | Consumes all available food recklessly |
| Morale < 25%, Hunger = 0 | Wendigo | Kills and consumes other survivors |

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

**Group Size Morale Scaling (TO BE IMPLEMENTED):**

Morale scales in proportion to the number of nearby units. This mechanic:
- **Favors keeping the main group together** - larger groups maintain morale more easily
- **Penalizes small expeditions** - hunting parties, trading missions, and exploration groups suffer morale drain
- **Prevents solo "hail mary" attempts** - even the Captain with his generous morale aura cannot sustain a solo march to the HBC whaling outpost

| Nearby Units | Morale Effect |
|--------------|---------------|
| 6+ units | Normal morale (no penalty) |
| 4-5 units | Mild isolation penalty |
| 2-3 units | Moderate isolation penalty |
| 1 unit (solo) | Severe isolation penalty - rapid morale drain |

**Ship Morale Floor:**
The ship provides a tiny morale floor-cap that prevents reaching absolute zero morale. This enables a "last survivor" win condition:
- A lone survivor at the ship can wait out rescue (barely)
- A lone survivor away from the ship will succumb to isolation

**Death by Despair:**
When morale reaches 0% due to isolation (rather than mental break triggers), the unit dies with cause of death: **"Lost the will to live."**

This is distinct from Mental Breaks (Berserk, Food Binge, Wendigo) which require specific hunger conditions. Isolation-induced zero morale is a quiet surrender.

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
- **Strength** - Sled hauling capacity, carry weight (60-100, skewed distribution)

### Strength Mechanic

Strength determines hauling and carrying capacity. Unlike other skills, strength is primarily a physical attribute that degrades under poor conditions.

**Generation:**
- Range: 60-100
- Distribution: Skewed toward lower values (scores above 70 increasingly rare)
- Approximately 50% spawn with 60-70, 35% with 70-85, 15% with 85-100

**Degradation (Stacking):**
When core stats fall low, strength is sapped. Multiple low stats stack:
| Condition | Strength Loss (per stat) |
|-----------|--------------------------|
| Stat critical (<15%) | -1.0/hr each |
| Stat low (<35%) | -0.5/hr each |

Example: Critical hunger (-1.0) + low warmth (-0.5) + low energy (-0.5) = -2.0/hr total

**Recovery:**
- All 5 core stats must be above 75% simultaneously
- Recovery rate: +0.5/hr
- Cannot exceed base (spawn) value

**Usage:**
- Sled man-hauling efficiency
- Carry weight capacity
- Modified by "Strong" (+50%) and "Weak" (-40%) traits

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
| Greedy | Hoards 2+ food and rum in personal inventory at all times |

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

### Autonomous Work Behavior

Men contribute to construction tasks autonomously when their condition allows:

**Task Types (max 2 workers each):**
| Task | Description |
|------|-------------|
| Gathering | Collect raw materials from stricken ship |
| Preparing | Process materials at workbench |
| Hauling | Transport materials between locations |
| Constructing | Work at construction sites |

**Work Conditions:**
- All core stats (hunger, warmth, energy, morale) must be above 50%
- If any stat falls below 50%, men prioritize recovery
- If no recovery resource available, men are incapacitated (starving, hypothermic, exhausted, desperate)
- Work discovered via proximity (within 30m of workbench or construction site)

**Efficiency Bonuses:**
- Each additional worker: +25% speed
- Carpenter trait: +25% construction speed
- Builder trait: +15% construction speed
- Beast of Burden trait: +50% carry capacity
- Resourceful trait: +25% gathering yield

**Officers:**
- Can be directly assigned to any task via right-click
- Have same skill buff potential as men (randomly assigned)
- Not subject to autonomous work behavior (player controlled)

**Construction Timeline:**
| Item | Days |
|------|------|
| Crate | 2 |
| Barrel | 3 |
| Tent Frame | 4 |
| Firewood Bundle | 1 |
| Sled | 10 |

**Build Placement:**
- Must be within 75m of workbench
- Must be on relatively flat ground (slope < 10%)
- Ghost preview shows pale olive green when valid, red when invalid
- Invalid reasons: collision, slope too steep, out of bounds, insufficient materials

---

## Controls

### Camera
- **Movement:** WASD / Arrow keys / Edge scrolling
- **Zoom:** Mouse wheel
- **Rotation:** Middle mouse drag (yaw/pitch orbit)
- **Speed Boost:** Hold Shift
- **Focus:** Only Officers and Captain can be camera-focused. Selecting Men does not move the camera.
- **View Distance:** Camera max height is restricted based on the focused officer's navigation equipment:
  - Base: 25m | Spyglass: +10m | Sextant: +10m | Navigation skill: up to +5m
  - Maximum possible: 50m (both items + max skill). Creates exploration progression.

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
- Aurora borealis (see below)

### Aurora Borealis
- **Visual:** Raymarched volumetric green/teal glow in the night sky using a BoxMesh with a spatial shader
- **Conditions:** Clear night sky only — cannot occur during snow/blizzard (would be hidden anyway)
- **Probability:** ~15% base chance per eligible hour, modified by season and temperature:
  - Winter: 2x multiplier
  - Autumn/Spring: 1.3x multiplier
  - Summer: 0.3x multiplier (rare but possible in arctic)
  - Temperature below -25°C: 1.5x boost
  - Temperature below -35°C: 2x boost
- **Duration:** 2-6 game hours per occurrence
- **Effect:** Morale boost to all survivors while visible (+2 morale/hour)
- **Implementation:** `AuroraController` in `src/effects/`, integrates with `TimeManager` and `DynamicWeatherController`

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
| Tripe de Roche | Very Low | Rock lichen, foraged in flatlands near HBC, last-resort sustenance |

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
- Spyglass (navigation — +10m camera view height when held by focused officer)
- Sextant (navigation — +10m camera view height when held by focused officer)

**Weapons:**
| Weapon | Type | Damage | Range | Attack Speed | Notes |
|--------|------|--------|-------|--------------|-------|
| Unarmed | Melee | 3-5 | 1.5m | 1.0s | Always available |
| Knife | Melee | 6-10 | 1.5m | 0.8s | Fast, low damage |
| Hatchet | Melee | 10-15 | 2m | 1.2s | Also a tool |
| Pistol | Ranged | 25-35 | 15m | 18s reload | Officers only |
| Shotgun | Ranged | 40-60 | 20m | 20s reload | Wide spread, close range bonus |
| Musket | Ranged | 35-50 | 40m | 22s reload | Best range, hunting primary |

*Historical Note: All firearms are percussion cap/black powder (1845 era). The 15-25 second reload makes them useful for hunting or opening combat, then switching to melee.*

### Inventory System
- **Personal Inventory:** Each survivor carries items (weight limit based on Strength)
- **Stockpile:** Shared camp storage, survivors haul to/from

### Gradual Ship Destruction

**Purpose:** Both cinematic/historical authenticity and a gameplay timer that encourages players to maximize resource extraction early.

**Overview:** The Erebus will be gradually crushed by ice and claimed by the sea over the course of the game. This creates urgency around salvage operations and provides dramatic set-piece moments as the ship breaks apart.

#### Ship Object Groups

The Erebus is divided into approximately 20 major object groups representing ship systems:

| Object Group | Destruction Order | Resources |
|--------------|-------------------|-----------|
| Fore Rigging | Early | Rope, Canvas |
| Aft Rigging | Early | Rope, Canvas |
| Bowsprit | Early-Mid | Wood |
| Foremast | Mid | Wood, Rope |
| Mainmast | Mid | Wood, Rope |
| Aftmast | Mid | Wood, Rope |
| Upper Deck | Mid-Late | Wood Planks, Nails |
| Lower Deck | Late | Wood Planks, Nails |
| Left Hull | Late | Wood, Nails, Scrap Metal |
| Right Hull | Late | Wood, Nails, Scrap Metal |
| Stern | Late | Wood, Nails |
| Bow | Late | Wood, Scrap Metal |
| Captain's Quarters | Late | Wood, Canvas, Furniture |
| Cargo Hold | Final | Remaining supplies |

#### Destruction Sequence

The ship breaks apart in a realistic sequence:

1. **Rigging Failure** - Ice pressure snaps ropes and tears canvas; masts become unstable
2. **Mast Collapse** - Weakened masts break and fall, damaging deck sections
3. **Hull Breach** - Ice pierces the hull; wood splinters and fractures
4. **Deck Collapse** - Structural integrity fails; decks cave in
5. **Final Sinking** - Remaining hull sections succumb; ship is claimed by the sea

#### Physics & Performance

Each object group is fractured into 30-100 individual physics objects using cell fracture techniques. Performance optimization strategies:

| Technique | Description |
|-----------|-------------|
| **LOD Swapping** | Erebus initially renders as a single low-poly model. As each group begins destruction, it swaps to the fractured version minus already-destroyed sections |
| **Pre-baked Physics** | Fracture simulations computed in background during gameplay. When destruction triggers, physics playback is cheap |
| **Async Computation** | Fracture calculations happen during normal gameplay, queued for when needed |
| **Object Pooling** | Debris objects are pooled and recycled to minimize instantiation costs |

**Fracture Tools (Implementation Options):**
- **Cell Fracture (Blender)** - Pre-computed fractures baked into assets
- **[godot-smashthemesh](https://github.com/cloudofoz/godot-smashthemesh/)** - Runtime fracturing if visually appealing and performant

#### Gameplay Implications

**Temporary Resource Boon:**
- Ship fragments that fall become harvestable debris
- Rich in wood, nails, sailcloth, food, and other salvage
- Fragments are scattered unpredictably - creates scramble to collect before weather/wildlife claims them

**Non-Renewable Resource:**
- The ship cannot be repaired or restored
- Once gone, its resources are gone forever
- Unlike traditional survival games, there are **no trees** on the island, **little to hunt**
- Forces careful long-term resource management from day one

**Strategic Pressure:**
- Early game: Race to salvage before destruction events
- Mid game: Ship provides diminishing returns as sections are lost
- Late game: Ship is gone; players must survive on what they've stockpiled and scavenged

**Cinematic Value:**
- Each destruction event is a visual spectacle
- Provides narrative beats matching historical accounts of ships crushed by ice
- Reinforces the hopelessness and urgency of the survivors' situation

**Implementation Details:**
See [tools/CLAUDE.md](tools/CLAUDE.md) for detailed technical documentation including:
- DemolitionTestController (staged destruction with key controls)
- ShipSinkController (sinking animation with rumble sounds)
- Sound integration (wood crashing, ground impacts, continuous creaking)
- Test scene: `objects/erebus4/erebus_physics_test.tscn`

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

### Tent Upgrades

Tents can be upgraded with animal pelts to dramatically improve their effectiveness:

**Seal Pelt Insulated Tent:**
- **Materials:** Existing Tent + 3-4 Seal Pelts
- **Effect:** Functions as a combined fire + tent — provides warmth equivalent to fire proximity but contained within the tent's interior
- **Capacity:** Max 3 occupants
- **Warmth radius:** Interior only (no external warmth like a fire pit)
- **Buffs:**
  - Large temperature regeneration (comparable to fire proximity + basic shelter combined)
  - Morale boost to occupants (+1.0/hr while inside)
  - Greatly increased energy regeneration (+7.0 energy/hr, between tent and improved shelter)

**Bearskin Floor:**
- **Materials:** Existing Tent + 1 Large Pelt (polar bear)
- **Effect:** Similar buffs to seal pelt insulation but less pronounced
- **Buffs:**
  - Moderate temperature regeneration bonus (+2.0 warmth/hr on top of base tent)
  - Small morale boost to occupants (+0.5/hr while inside)
  - Increased energy regeneration (+5.0 energy/hr)

**Stacking:** Seal pelt insulation and bearskin floor can be combined on the same tent for maximum comfort. A fully upgraded tent is one of the most valuable shelters in the game and creates strong incentive to hunt dangerous wildlife.

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

## Sleds & Transport

### Sled Construction
Building a sled requires:
1. Designate an officer as **Carpenter**
2. Construct a **Carpentry Station** (requires wood, nails, tools)
3. Salvage sufficient **wood** from small boats or the ship itself
4. Craft the sled at the carpentry station

### Sled Composition
Each sled must contain at least one small boat. Additional cargo loads via physics-based stacking:

| Component | Required | Quantity | Weight (kg) |
|-----------|----------|----------|-------------|
| Small Boat | Yes | 1 | ~50 (base) |
| Crates | Optional | As fits in boat | +20-40 each |
| Barrels | Optional | As fits in boat | +30-60 each |
| Sick/Recovering Men | Optional | As fits | +70-90 each |

Items physically rest in the boat via collision. Total weight affects pull difficulty.

### Terrain Friction
Different terrain surfaces affect sled movement:

| Surface | Friction | Pull Difficulty | Notes |
|---------|----------|-----------------|-------|
| Ice | 0.3-0.4 | Easy | Frozen sea, inlet |
| Snow | 0.6-0.7 | Moderate | Primary island surface |
| Gravel | 0.8-0.9 | Hard | Low elevation, beaches |
| Rock | 0.95+ | Very Hard | Steep slopes, cliffs |

Slope also affects difficulty: uphill requires more force, downhill provides momentum assistance.

### Man-Hauling Mechanics
Men (or dogs when available) pull sleds using rope harnesses:

**Physics:**
- Sleds respond realistically to physics (gravity, momentum, friction)
- PinJoint3D simulates rope attachment between pullers and sled
- Multiple pullers share the load, reducing individual strain

**Puller Coordination:**
- One designated **lead puller** navigates the path
- Additional pullers follow in formation behind the leader
- All pullers must be attached before movement begins

**Costs:**
- Energy drain: -3.0/hr per puller
- Morale drain: -0.25/hr per puller ("Man-hauling sleds" penalty)
- Heavier loads = slower movement speed

**Dogs (Future):**
- More efficient pulling (less energy per unit of force)
- No morale penalty
- Must be acquired through trade with natives

---

## Combat

### Design Philosophy
Combat is **simple and deterministic** (inspired by Kenshi/Rimworld). No complex dice rolls or ability cooldowns. Weapons have fixed damage and attack speeds. The drama comes from *who* is fighting *whom* and *why*, not from combat mechanics themselves.

### Combat Initiation

| Initiator | Target | Trigger |
|-----------|--------|---------|
| Player (Officer/Captain) | Any hostile | Right-click to attack |
| Men | Hostile attacking them | Auto-defend when attacked |
| Broken Man (violent break) | Nearby survivors | Automatic (see Mental Breaks) |
| Animals | Survivors in territory | Proximity aggro |

**Key Rules:**
- Officers/Captain require explicit player commands to attack
- Men auto-defend ONLY when directly attacked (not when allies are attacked)
- Only Officers can intervene against broken men (Men will not auto-attack other men)
- Right-click on hostile = attack command

### Damage Calculation

**Formula:** `Damage = WeaponBaseDamage × (0.8 + Strength/250)`

- Deterministic: no random hit/miss rolls
- Attack speed determines DPS (attacks hit on timer)
- Strength modifies damage output (60-100 range means 1.04x to 1.2x multiplier)

**Firearms Accuracy:**
- Base accuracy from weapon type (pistol < shotgun < musket at range)
- Modified by Shooting skill (+2% per skill level)
- Marksman trait: +15% accuracy
- Miss = no damage (simple binary)

### Weapons

See Items & Resources section for weapon stats table.

**Implementation Priority:**
1. Unarmed + Hatchet (MVP)
2. Knife
3. Firearms (shotgun, musket, pistol)

### Flee Behavior

| Trait | Flee Threshold | Notes |
|-------|----------------|-------|
| Coward | 50% HP | Flees early, runs far |
| Normal | 15% HP | Attempts to disengage |
| Combative | Never | Fights to death |
| Animals | 25% HP | Always attempt to flee |

Fleeing units can be chased and killed. Flee direction is away from attacker toward nearest safe location (camp, fire, shelter).

### Wildlife

**Spawning:** Animals are persistent world entities that roam the map. Not event-based spawns.

| Animal | HP | Damage | Speed | Behavior | Drops |
|--------|-----|--------|-------|----------|-------|
| Seal | 40 | 5 | Slow | Passive, flees immediately | 2-4 seal meat, 1 blubber |
| Caribou | 60 | 8 | Fast | Passive, flees when approached | 3-6 caribou meat, 1 pelt |
| Arctic Fox | 25 | 4 | Fast | Passive, scavenges corpses | 1 meat, 1 pelt |
| Wolf | 80 | 15 | Fast | Pack hunter, attacks weak/isolated | 2-3 meat, 1 pelt |
| Polar Bear | 200 | 35 | Medium | Solitary, territorial, very dangerous | 6-10 meat, 1 large pelt, 1 fat |

**Animal AI:**
- Seals/Caribou: Graze, flee on player proximity
- Wolves: Hunt in packs (2-4), target isolated or low-HP units
- Polar Bears: Roam territory, attack anything that enters ~30m radius

**Trichinosis Risk:** Eating raw polar bear or seal meat has chance of parasitic infection (health drain over time). Cooking eliminates risk.

### Man-on-Man Combat

Combat between survivors occurs due to:

| Cause | Aggressor Behavior | Resolution |
|-------|-------------------|------------|
| Berserk (morale <25%, hunger >25%) | Attacks nearest survivor | Officer subdues or kills |
| Wendigo (morale <25%, hunger =0) | Kills and eats survivors | Officer subdues or kills |
| Deliberate attack (player command) | Officer attacks target man | Target defends |
| Subduing broken man | Officer attacks to incapacitate | Broken man resists |

**Key Rules:**
- Men do NOT auto-defend against other men (even broken ones)
- Only Officers/Captain can intervene against broken men
- Broken men attack continuously until subdued, killed, or morale recovers
- Subduing = reducing to <10% HP without killing (requires player to stop attack)

### Combat Death

Combat deaths follow the same rules as any death:
- Body becomes lootable corpse
- Corpse contains: equipment carried + 2-6 human meat
- Standard cannibalism morale penalties apply if meat is consumed
- Bodies can be butchered for additional yield (existing butcher task)

### Mental Breaks (Violent)

*Non-violent breaks (hysterical laughter, wandering, catatonia) are planned for later.*

| Break | Trigger | Behavior | Duration |
|-------|---------|----------|----------|
| Berserk | Morale <25%, Hunger >25% | Attacks nearest survivor with equipped weapon | Until subdued or morale >35% |
| Wendigo | Morale <25%, Hunger =0 | Kills survivor, attempts to eat corpse | Until subdued or fed |

**Break Chance:** When morale drops below 25%, roll chance each hour:
- Base: 10% per hour while under threshold
- +5% per additional critical stat (<25%)
- Combative trait: +10% for Berserk specifically
- Leader trait: -5% (more composed)

### Skills Affecting Combat

| Skill | Effect |
|-------|--------|
| Shooting | +2% firearm accuracy per level |
| Strength | Damage multiplier (see formula) |
| Combat (new) | +5% attack speed per level |

### Traits Affecting Combat

| Trait | Effect |
|-------|--------|
| Combative | +15% damage, never flees, +10% Berserk chance |
| Coward | -25% damage, flees at 50% HP, will not attack first |
| Marksman | +15% firearm accuracy |
| Strong | +50% to strength for damage calc |
| Weak | -40% to strength for damage calc |

---

## Factions

### Overview
Units can split off into hostile factions during the game, creating internal conflict that threatens survival. This mechanic is inspired by *The Terror* and *Kenshi*, representing the breakdown of social order under extreme conditions.

### MVP Implementation

**Trigger:** Scripted event when morale conditions deteriorate sufficiently across the crew.

**Sequence:**
1. Small cutscene and dialog plays
2. Units split into two camps
3. Crozier commands one camp (player-controlled)
4. Other camp becomes hostile (AI-controlled)

**Gameplay:** Player must manage their remaining loyal forces while dealing with a hostile faction on the same island.

### Desired Implementation (Post-MVP)

**The Mutiny:**
One set of units overpowers and imprisons another set in a mutiny scenario.

| Phase | Description |
|-------|-------------|
| **Imprisonment** | Mutineers lock loyal units in a makeshift "brig" (similar to Kenshi's cage/enslavement system) |
| **Escape** | Captain must free himself and gather loyal forces |
| **Resolution** | Player chooses: retake control by force, ignore mutineers and continue southward march, or negotiate |

**Brig Mechanics:**
- Units in brig cannot act (similar to incapacitated state)
- Brig is a physical location that can be guarded
- Escape requires: picking locks, overpowering guards, or outside rescue
- Imprisoned units suffer morale/health drain over time

### Faction Triggers

**Primary Condition:** Low morale across a significant portion of the crew.

**Required Elements:**
| Requirement | Details |
|-------------|---------|
| Low morale threshold | X% of units below 25% morale (TBD) |
| Faction leader | At least one "Well Liked" individual OR an Officer willing to defect |
| Critical mass | Minimum number of potential defectors (3-5 units) |

**Contributing Factors:**
- Prolonged food scarcity
- Multiple recent deaths
- Cannibalism discovered/witnessed
- Failed expeditions
- Captain's poor decisions (player choices)
- Proximity to "Combative" or "Coward" traits (amplifies tension)

### Faction Leader Requirements

Not all units can lead a mutiny. Valid faction leaders must have:

| Trait/Role | Why |
|------------|-----|
| "Well Liked" | Has social influence, others will follow |
| Officer | Has authority and command experience |
| High morale (relative) | Still has will to act rather than despair |

**Irony:** The very traits that make someone a good leader also make them a potential rival.

### Faction Behavior

**Hostile Faction AI:**
- Defends their camp territory
- Competes for resources (may raid player stockpiles)
- Will attack player units that enter their territory
- Maintains basic survival behavior (eat, sleep, warm)

**Potential Outcomes:**
| Outcome | Description |
|---------|-------------|
| Player victory | Defeat/capture hostile faction, reclaim full control |
| Coexistence | Both factions survive separately, competing for resources |
| Player defeat | Player faction wiped out (game over) |
| Reconciliation | Negotiate reunion (requires specific conditions) |

### Historical Authenticity
This mechanic mirrors historical accounts of polar expeditions:
- Franklin expedition crews reportedly split into factions
- Some groups attempted escape while others remained with ships
- Leadership disputes and mental deterioration led to violent conflict
- "The Terror" novel/series depicts exactly this scenario

---

## Native Interaction

### Native Camp
- One discoverable camp on map (or found via expedition)
- Neutral disposition, can trade

### Trade

**Trade Goods (What Inuit Want):**

| Category | Items | Trade Value |
|----------|-------|-------------|
| **Iron/Metal** | Knives, stoves, nails, scrap metal, tools | High — most practical value to Inuit |
| **Firearms** | Rifles, shotguns | Very High — 1 rifle = 4 seals (*North Water* tribute). Limited supply: 4-5 rifles/shotguns per game, so trading one is a major strategic decision |
| **Valuables** | Silverware, gold jewelry, pocket watches, medals | Moderate — Inuit know these hold value to *other* white men (whalers, traders). No survival value but recognized as currency |
| **Curiosities** | Books, maps, compasses | Low — minor novelty value |

**What You Get:**

| You Give | You Get |
|----------|---------|
| Iron/Metal goods | Native cold gear (superior protection), pelts |
| Firearms | Large food supply (seals, whale meat), dogs |
| Valuables | Food (moderate), information, minor gear |
| Mixed goods | Navigation knowledge, hunting spots, survival tips |

**Trade Notes:**
- Valuables are otherwise useless dead weight — trading them is always worth it
- Rifles are scarce enough that trading even one meaningfully impacts combat/hunting capability
- Inuit may refuse trades if disposition drops (e.g., hostile encounters, theft)

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

## Demo / Quickplay Mode

A condensed, showable version of the full game designed for indie dev nights and demos.

### Demo Overview
- **Map Size:** 2x2km procedurally-generated island (random seed each play)
- **Crew:** 8-12 men + 1-2 officers at base camp, plus 1-2 errant groups scattered 500-900m from ship
- **Duration:** ~7 in-game days before the ship is fully destroyed
- **Objective:** Build a sled and reach open water at the south coast before the ship sinks and resources run out

### Ship Destruction Timeline
The trapped ship is actively being crushed by ice and sinking. Destruction is automated and progressive:

| Days | Phase | Events Per Day |
|------|-------|----------------|
| 1-2 | Rigging & Shrouds | 1-3 explosive events, rigging snaps and falls |
| 2-4 | Shrouds & Masts | 1-3 explosive events, masts shake and collapse top-down |
| 3-5 | Hull & Deck | 1-3 explosive events, hull pieces blown outward |
| 3-7 | Sinking | 0-1 sink events, ship descends incrementally with roll/pitch |
| 7 | Final | Ship fully degraded, remaining structure collapses |

Ship resources (wood, nails, sailcloth) remain gatherable at ground level as the ship sinks, allowing continued salvage operations until destruction is complete.

### Win Condition
Get a built sled from the starting area to the open water Area3D at the south coast. The sled must be constructed by the player (not pre-spawned).

**Sled Recipe (Demo):** 10 scrap_wood + 5 nails, 3-day build time (reduced from full game's 10 days)

### Scoring
Additional points awarded based on camp management:

| Metric | Points | Description |
|--------|--------|-------------|
| Survivors alive | 500 each | Total living crew at win |
| Men in good condition | 200 each | All 5 core stats above 50% |
| Errant men found | 300 each | Discovered and recruited scattered groups |
| Tents built | 150 each | Completed tent constructions |
| Food stockpiled | 50 each | Individual food items in containers |

### Lose Condition
All survivors dead.

### Key Differences from Full Game
- 2km island vs 10km (faster terrain generation, tighter gameplay)
- Ship actively sinking (creates urgent resource extraction pressure)
- No pre-built sled (forces engagement with crafting/construction system)
- Shorter build times (3-day sled vs 10-day)
- Smaller crew (more manageable for new players/spectators)
- Clear win objective (reach open water) vs full game's long-term survival

---

## MVP vs Future Features

### MVP (2 Weeks)
- [x] Arctic terrain
- [x] RTS camera
- [x] 30-35 survivors with needs
- [x] Selection and commands
- [x] Time/season system
- [ ] Basic needs AI (I'm close)
- [x] Inventory and stockpiles
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
- Weather variety (blizzards, fog, aurora) (this is already partially implemented)
- Snow blindness mechanic
- Whale hunting mini-game
- Multiple ending types
- Procedural survivor names and backstories
- Sound design and music
- Save/load system
