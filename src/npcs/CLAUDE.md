# NPC System

**Status:** Not Yet Implemented

Non-player characters including native Inuit camps and traders.

## Planned Purpose

Provide interaction opportunities beyond survival:
- **Inuit camps:** Trade, guidance, cultural exchange
- **Rescue parties:** Late-game encounters
- **Other survivors:** Found survivors, rival groups

**Historical context:** The Franklin expedition had some contact with Inuit peoples. Survivors who worked with Inuit guides had better chances of survival. This system should reflect that without being exploitative.

## Directory Structure

```
src/npcs/
├── CLAUDE.md           # This file
└── (planned files)
```

## Planned Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      NPC System                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ NPCDefinition   │     │ Character template:          │    │
│  │ (Resource)      │────►│ - name, dialogue             │    │
│  └─────────────────┘     │ - trade_inventory            │    │
│                          │ - disposition                │    │
│                          └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ Camp            │     │ Location node with:          │    │
│  │ (Node3D)        │────►│ - NPCs, inventory            │    │
│  └─────────────────┘     │ - reputation                 │    │
│                          └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ TradeSystem     │     │ Handles item exchange,       │    │
│  │ (Node)          │────►│ value calculation            │    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
│  ┌─────────────────┐     ┌─────────────────────────────┐    │
│  │ DialogueSystem  │     │ Conversation UI,             │    │
│  │ (Node)          │────►│ choices, outcomes            │    │
│  └─────────────────┘     └─────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Planned NPC Types

### Inuit Hunter
```gdscript
var inuit_hunter: NPCDefinition = {
    "name": "Inuit Hunter",
    "disposition": "neutral",  # neutral, friendly, wary
    "trade_items": ["seal_meat", "fur_clothing", "whale_oil"],
    "wants_items": ["metal_tools", "tobacco", "beads"],
    "dialogue_tree": "res://dialogue/inuit_hunter.json"
}
```

### Inuit Elder
```gdscript
var inuit_elder: NPCDefinition = {
    "name": "Inuit Elder",
    "disposition": "wise",
    "provides": ["survival_knowledge", "navigation_tips"],
    "dialogue_tree": "res://dialogue/inuit_elder.json"
}
```

### Lost Sailor
```gdscript
var lost_sailor: NPCDefinition = {
    "name": "Lost Sailor",
    "disposition": "desperate",
    "join_condition": "rescue",  # Joins party if helped
    "starting_stats": {...},
    "traits": ["weak", "navigator"]
}
```

## Planned Features

### Trading System

Barter-based economy (no currency):
```gdscript
class_name TradeSystem extends Node

## Item values for trade (relative, not absolute)
const TRADE_VALUES: Dictionary = {
    "hardtack": 1.0,
    "knife": 10.0,
    "seal_meat": 8.0,
    "fur_coat": 25.0,
    "tobacco": 15.0
}

func calculate_trade_value(items: Array[InventoryItem]) -> float:
    var total: float = 0.0
    for item in items:
        var id: String = item.prototype_id
        total += TRADE_VALUES.get(id, 1.0) * item.get_stack_size()
    return total

func can_trade(offer: Array, request: Array) -> bool:
    var offer_value := calculate_trade_value(offer)
    var request_value := calculate_trade_value(request)
    # Allow some unfavorable trades (desperation)
    return offer_value >= request_value * 0.8
```

### Reputation System

Actions affect standing with NPC groups:
```gdscript
class_name ReputationManager extends Node

var camp_reputation: Dictionary = {}  # camp_id -> float (-100 to 100)

func modify_reputation(camp_id: String, amount: float) -> void:
    var current: float = camp_reputation.get(camp_id, 0.0)
    camp_reputation[camp_id] = clampf(current + amount, -100.0, 100.0)

func get_disposition(camp_id: String) -> String:
    var rep: float = camp_reputation.get(camp_id, 0.0)
    if rep >= 50.0: return "friendly"
    if rep >= 0.0: return "neutral"
    if rep >= -50.0: return "wary"
    return "hostile"
```

### Reputation Effects

| Reputation | Trade Rates | Dialogue | Help |
|------------|-------------|----------|------|
| Friendly (50+) | Fair trades | Full access | Will assist |
| Neutral (0-50) | Standard | Basic | May assist |
| Wary (-50-0) | Unfavorable | Limited | Won't help |
| Hostile (-50-) | No trade | None | May attack |

### Actions That Affect Reputation

| Action | Reputation Change |
|--------|-------------------|
| Fair trade | +5 |
| Gift (no trade) | +10 |
| Help in danger | +20 |
| Theft | -30 |
| Violence | -50 |
| Trade Affable survivor | +5 bonus |

### Dialogue System

Simple branching dialogue:
```gdscript
# dialogue/inuit_hunter.json
{
    "start": {
        "text": "The hunter regards you cautiously.",
        "options": [
            {"text": "We come in peace.", "next": "peaceful"},
            {"text": "We need food.", "next": "request_food"},
            {"text": "[Leave]", "next": "exit"}
        ]
    },
    "peaceful": {
        "text": "He nods slowly. 'Your people... lost. Many die. Why you come here?'",
        "options": [...]
    }
}
```

### Survival Knowledge

Inuit NPCs can teach skills:
```gdscript
func learn_skill(survivor: Survivor, skill: String, amount: float) -> void:
    match skill:
        "hunting":
            survivor.stats.hunting_skill += amount
        "navigation":
            survivor.stats.navigation_skill += amount
        "survival":
            survivor.stats.survival_skill += amount
        "cold_resistance":
            survivor.stats.cold_resistance += amount
```

## Camp Locations

Camps are placed on the world map:
```gdscript
class_name Camp extends Node3D

@export var camp_name: String
@export var camp_type: String = "inuit"  # inuit, rescue, abandoned
@export var npcs: Array[NPCDefinition] = []

var reputation: float = 0.0
var trade_inventory: Inventory

signal entered(survivor: Survivor)
signal exited(survivor: Survivor)
```

## Integration Points

### With Inventory System
- Trade items between inventories
- NPCs have their own inventory/protoset

### With SurvivorStats
- Learning skills from NPCs
- Affable trait affects trade bonus

### With TimeManager
- Camp visits take time
- NPCs restock inventory over days

### With Weather System
- Camps provide shelter during visits
- NPCs won't trade during blizzards

### With Map/World
- Camps marked on world map
- Discovery through exploration

## Design Considerations

### Cultural Sensitivity

The Inuit peoples in the game should be:
- **Respectful** - Not stereotyped or exoticized
- **Capable** - They're the experts in arctic survival
- **Autonomous** - They have their own goals, not just serving players
- **Historically grounded** - Based on real Inuit practices

### Gameplay Purpose

NPCs should provide:
- **Alternative survival strategies** - Trade for what you can't make
- **Information** - Locations, weather predictions, dangers
- **Hope** - Contact with other humans in isolation
- **Moral choices** - Help others or focus on self

## Implementation Priority

1. **Basic Camp** - Location with shelter
2. **Simple Trade** - Item for item exchange
3. **Reputation** - Track relationship over time
4. **Dialogue** - Basic conversation trees
5. **Learning** - Skill improvement from NPCs

## Related Systems

- `src/items/` - Trade inventory
- `src/characters/survivor_stats.gd` - Skill learning
- `src/characters/trait.gd` - Affable trait bonus
- `ui/` - Trade and dialogue UI
