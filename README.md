# Loxley Quest System (LQS)
[![LQS](https://github.com/LoxleyXI/LQS/blob/main/lqs.png)](https://github.com/LoxleyXI/LQS)

## Overview
The Loxley Quest System (LQS) is a module for the [LandSandBoat](https://github.com/LandSandBoat/server) FFXI server emulator. It allows server operators to easily create their own custom quests and script custom events using a simple template system. The system provides an authentic experience and is actively in use by multiple prominent FFXI server projects.

If you found this module helpful, please consider kindly supporting my other work and/or starring the repository. Thank you.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/loxleygames)

## Features
* **LQS now comes bundled with Questpack, providing 20+ new quests to kick start your experience.**
* Fully scriptable dialog events with NPC animations and simulated cutscenes
* Flexible item trading system offers endless possibilities
* Mob encounters featuring spawn requirements, level caps and other restrictions
* NPC look/model utility functions allow easy creation of any appearance
* Each step can be gated by any number of requirements
* Custom quest tracker and "quest accepted/complete" sound effects
* Quests are fully reloadable and will refresh simply by saving the file
(ie. You can update NPCs or implement new quest steps without any need for a server restart!)

## Setup
* `LQS.lua` must be located inside `modules/` but does not need to be loaded by `init.txt`
* Each new area must include a reference to `LQS.lua`, for example `local LQS = require('modules/lib/LQS')`
* Initialise your area using `LQS.add()` by following the examples provided in this repository
* Ensure `lqs_util.cpp` is included in your modules and [clear the CMake cache](https://github.com/LandSandBoat/server/wiki/Module-Guide#cpp-modules) before [rebuilding the C++](https://github.com/LandSandBoat/server/wiki/Quick-Start-Guide)

## Questpack
**LQS now comes bundled with Questpack, providing 20+ new quests to kick start your experience.** Each quest features tastefully written dialog, appropriate to the game's setting and a variety of new rewards, including augmented items and repeatable gil rewards.

* San d'Oria **(5)**: Hatchet Job, Hungry Customer, In Sheep's Clothing, Rambling Around, Staying Afloat
* Bastok **(5)**: Bird Search, Bug Report, Chasing Tails, Mining My Business, That's All Folks
* Windurst **(5)**: Down to Earth, Neck and Neck, Only the Dose, Reaping Rewards, Rustling Feathers
* Other Areas **(3)**: Head First, Here Be Dragons, Likely Tails
* Aht Urhgan **(2)**: Insult to Gingery, Pecking Battles

## Step Functions
### LQS.dialog
Dialog steps are the foundation of any quest, each dialog includes an event table and optional parameters, such as quest name to trigger the "Quest Accepted" message or reward to trigger the "Quest Completed" message and distribute rewards.
* Event tables consist of strings and tables containing many different functions
* Dialog is automatically assigned to the current NPC unless a spawn is specified
* The assigned NPC will turn to the player during dialog and reset position following
* Spawners will disappear during dialog and respawn after
* Events are sent directly to the target player, the only one who sees NPCs move, emote or spawners altering state
```lua
["Entity Name"] = LQS.dialog({
    -- (Optional)
    check  = { level = 5 },

    -- (Optional) Setting this will give players the "Quest Accepted" message after the dialog completes
    quest  = "Quest Name",

     -- (Optional) Setting this will complete the quest after the dialog completes
    reward = { item = xi.item.CHUNK_OF_ROCK_SALT, gil = 100 },

    -- (Optional) Set the NPC's name here if the entity is a spawner
    spawn  = "NPC Name",

    -- (Optional) Include if this should not increment the quest step, ie. reminder dialog
    step   = false,

    -- (Required)
    event  =
    {
        "Test message",
        { emote = xi.emote.THINK },
    },
}),
```

### LQS.trade
Trade steps advance the quest or provide rewards in exchange for requested items. By setting `step = false`, repeatable quests can be created and the `tally` parameter can be used to keep track of the total trades, eg. for dialog.
```lua
["Entity Name"] = LQS.trade({
    -- (Optional) Gate this step with optional requirements
    check = { level = 5 },

    -- (Optional) The required items
    required = { { xi.item.CHUNK_OF_ROCK_SALT, 12 } },

    -- (Optional) A table of rarity sorted results can be used instead of the `required` parameter, allowing multiple different types of items to be exchanged
    exchange =
    {
        [xi.item.CHUNK_OF_ROCK_SALT] =
        {
            { LQS.COMMON,   CHUNK_OF_COPPER_ORE, "a chunk of copper ore" }, --  (15%)
            { LQS.UNCOMMON, CHUNK_OF_ZINC_ORE,   "a chunk of zinc ore"   }, --  (10%)
            { LQS.RARE,     CHUNK_OF_GOLD_ORE,   "a chunk of gold ore"   }, --  ( 5%)
        },
    },

    -- (Optional) Setting this will give players the "Quest Accepted" message after the dialog completes
    quest = "Quest Name",

     -- (Optional) Setting this will complete the quest after the dialog completes
    reward = { gil = 250 },

    -- (Optional) Include if this should not increment the quest step, ie. reminder dialog
    step = false,

    -- (Optional) Character variable to store a tally for the total number of items accepted
    tally = "[LQS]VAR_NAME",

    -- (Required) This event table will be played if the player brings incorrect items
    declined  =
    {
        "This isn't what I wanted.",
    },

    -- (Required) This event table will be played if the player brings the correct items
    accepted  =
    {
        "Thanks for bringing me this item, here's your reward",
    },
}),
```

### LQS.menu
The menu function must be assigned to an NPC.
```lua
["Entity Name"] = LQS.menu({
    -- (Optional) Setting this will give players the "Quest Accepted" message after the dialog completes
    quest = "Quest Name",

    -- (Optional) If specified, the affirmative menu option will spawn the provided mob list
    spawn = { "Mob Name" },

    -- (Optional) If mob spawns, the spawner can be moved along to another position
    nextPos = { 1, 1, 1, 0 },

    -- (Optional) If mob spawns, level cap the player for the encounter
    levelCap = 10,

    -- (Optional) If mob spawns, allow players with this level cap status to receive raise
    raiseAllowed = true,

    -- (Optional) Require a max party size before allowing the mob to spawn
    partySize = 6,

    -- (Optional) If mob spawns, set the player's variable, eg. to reset quest state and consume a pop
    setVar = "[LQS]VAR_NAME",

    -- (Optional) If mob spawns, set a variable for all players in the alliance
    setVarAll = "[LQS]VAR_NAME",

    -- (Required) Title displayed on the custom menu
    title = "Here's a question",

    -- (Required) Options displayed on the custom menu
    options =
    {
        {
            "Here's an answer",
        },
        {
            "Different answer",
            {
                "This event table plays if this answer is chosen"
                { emote = xi.emote.THINK },
            },
        },
    },
}),
```

### LQS.defeat
The defeat function must be assigned to a mob.
```lua
["Entity Name"] = LQS.defeat({
    -- (Required) A table containing all mobs required to trigger the win condition
    mobs = { "Mob Name" },

    -- (Required) The name of the spawner to reappear after all mobs are defeated
    spawner = "Spawner Name",

    -- (Optional) Players who aren't on the current quest step can receive an item for helping, once per JST midnight
    helper = { { xi.item.CHUNK_OF_ROCK_SALT, 3 } },

    -- (Optional) Applies a JST midnight cooldown to all players by setting the supplied variable to 1 with an expiry
    cooldown = "[LQS]VAR_NAME",

    -- (Optional) Roll a random amount of points within the specified range for all participants
    pointsVar = "[LQS]POINTS_NAME",
    points    = { 15, 20 },
    message   = "{} gains {} special points.",

    -- (Optional) Award all participants with an amount of EXP
    exp = 1000,

    -- (Optional) Send all defeated players a Raise of the specified value after combat ends
    raise = 3,

    -- (Optional) Execute an arbitrary function for all participants
    func = function(player, step)
    end,
}),
```

### LQS.shop
The shop utility presents players with an automatically paginated list and provides a confirmation dialog before purchasing each item. The amount of points is checked before each item is allowed to be purchased. The quest step will not advance and this function should be assigned to a secondary NPC or at the end of a quest.
```lua
["Entity Name"] = LQS.shop({
    var    = "[LQS]POINTS_NAME",
    title  = "Puchase an item ({} points)",
    dialog = { "Optional dialog here" },
    list   =
    {

        { "Copper Ore", CHUNK_OF_COPPER_ORE,  5 },
        { "Zinc Ore",   CHUNK_OF_ZINC_ORE,   10 },
        { "Gold Ore",   CHUNK_OF_GOLD_ORE,   25 },
    },
}),
```

## History
This system has been developed over a couple of years by myself and now supports over 130+ live custom quests and content systems.

* The [first version](https://www.bg-wiki.com/ffxi/CatsEyeXI_Systems/Quests) was initially developed by me for [Crystal Warrior](https://www.catseyexi.com/cw) on [CatsEyeXI](https://www.catseyexi.com/) in 2023
* This __definitive version__ was developed by me in 2025 to give the system a permanent home and make it more accessible to the community

## Final Note
If you found this module useful for your server, please provide a link back to it!

~ Loxley ~
