-----------------------------------
-- Insult to Gingery (Lv40)
-----------------------------------
-- !setvar [LQS]INSULT_GINGERY 0
-- Gordo-Bordo !pos 16.855 -6.000 -51.214 50
-- !additem 2645 4
-- Reward: Sipahi Turban, 600 gil
-----------------------------------
-- !setvar [LQS]INSULT_GINGERY 1
-----------------------------------
local m = Module:new("lqs_insult_to_gingery")

local info =
{
    name     = "Insult to Gingery",
    author   = "Loxley",
    var      = "[LQS]INSULT_GINGERY",
    tally    = "[LQS]GINGER",
    required =
    {
        item = { { 2645, 4 } },
    },
    reward =
    {
        {
            item    = 16061,              -- Sipahi Turban (Lv59)
            augment = { 513, 1, 516, 1 }, -- DEX +2, INT +2
        },
        {
            gil = 600,
        },
    },
}

local Gordo = "Gordo-Bordo"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Aht_Urhgan_Whitegate"] =
        {
            {
                name   = Gordo,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.TARU_M,
                    face = LQS.face.A1,
                    head = 124, -- Chef's Hat
                    body = 124,
                    hand = 11,
                    legs = 11,
                    feet = 11,
                }),
                area    = "Aht_Urhgan_Whitegate",
                pos     = { 16.855, -6.000, -51.214, 95 }, -- !pos 16.855 -6.000 -51.214 50
                default = { "I don't have anything for you." },
            },
        },
    },
    steps =
    {
        {
            check   = LQS.checks({ level = 40, toggle = true }),
            [Gordo] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.THINK },
                    "President Naja has me cooking up dinners but lately she's been unimpressed.",
                    " My hurt pride is one thing... but that thing she swings around is scary...",
                    {delay = 1000 },
                    { emote = xi.emote.PANIC },
                    "I don't think she'll tolerate another miss!",
                    { delay = 1000 },
                    "Say, could you fetch me some eastern ginger roots to help spice things up?",
                    " Bring four at a time. That should do it!",
                },
            })
        },
        {
            [Gordo] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        { emote = xi.emote.PANIC },
                        "Please bring four eastern ginger roots as soon as possible!",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    music    = 178, -- Whitegate
                    required = info.required.item,
                    reward   = info.reward[1],
                    tally    = info.tally,
                    declined =
                    {
                        { emote = xi.emote.NO },
                        "Remember, I need four eastern ginger roots.",
                    },
                    accepted =
                    {
                        { emote = xi.emote.YES },
                        "Thanks. This ought to really give my next dish some extra kick!",
                        { fmt = " So far, you've brought me {} ginger roots!", var = info.tally },
                        "Here's a little something for your time.",
                    },
                }),
            },
        },
        {
            [Gordo] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Phew! That dish was a real hit... I'm saved.",
                        { emote = xi.emote.BOW },
                        "Please bring any more eastern ginger roots that you find!",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    step     = false,
                    required = info.required.item,
                    reward   = info.reward[2],
                    tally    = info.tally,
                    declined =
                    {
                        { emote = xi.emote.NO },
                        "Remember, I need four eastern ginger roots.",
                    },
                    accepted =
                    {
                        { emote = xi.emote.YES },
                        "Thanks. This ought to really give my next dish some extra kick!",
                        { fmt = " So far, you've brought me {} ginger roots!", var = info.tally },
                        "Here's a little something for your time.",
                    },
                }),
            },
        },
    },
})

return m
