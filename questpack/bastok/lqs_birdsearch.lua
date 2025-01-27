-----------------------------------
-- Birdsearch (Lv5)
-----------------------------------
-- !setvar [LQS]BIRDSEARCH 0
-- !setvar [LQS]BIRD_FEATHERS
-- Neavias !pos -215.700 -6.000 -91.677 235
-- !additem 847 4
-- Rewards: 400g
-----------------------------------
-- !setvar [LQS]BIRDSEARCH 1
-----------------------------------
local m = Module:new("lqs_birdsearch")

local info =
{
    name     = "Birdsearch",
    author   = "Loxley",
    var      = "[LQS]BIRDSEARCH",
    tally    = "[LQS]BIRD_FEATHERS",
    required = { { 847, 4 } }, -- Bird Feather x4
    reward   =
    {
        gil = 400,
    },
}

local Neavias = "Neavias"

LQS.add(m, {
    info   = info,
    entities =
    {
        ["Bastok_Markets"] =
        {
            {
                name   = Neavias,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.ELVAAN_M,
                    face = LQS.face.A6,
                    head = 115,
                    body = 102,
                    hand = 102,
                    legs = 3,
                    feet = 102,
                }),
                pos     = { -215.700, -6.000, -91.677, 40 }, -- !pos -215.700 -6.000 -91.677 235
                default = { "Greetings. I'm bird collector of sorts..." },
            },
        },
    },
    steps =
    {
        {
            check     = LQS.checks({ toggle = true, level = 5 }),
            [Neavias] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.WAVE },
                    "Greetings. I'm bird collector of sorts...",
                    " I gather different feathers for my collection.",
                    { delay = 1000 },
                    "If you have any bird feathers to sell, I'll take them, four at a time",
                },
            })
        },
        {
            [Neavias] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "If you have any bird feathers to sell, I'll take them, four at a time",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    step     = false,
                    required = info.required,
                    reward   = info.reward,
                    declined =
                    {
                        "Remember, it's four bird feathers at a time.",
                    },
                    accepted =
                    {
                        { emote = xi.emote.THINK },
                        { fmt = "Hmmm... These are good samples. That makes {} feathers.", var = info.tally },
                        " Here's your reward.",
                    },
                }),
            }
        },
    },
})

return m
