-----------------------------------
-- Mining My Business (Lv5)
-----------------------------------
-- !setvar [LQS]MINING_MY_BUSINESS 0
-- Iron Digger !pos 66.655 7.925 -149.454 172
-- !additem 5738
-- Reward: Pickaxe x12
-----------------------------------
-- !setvar [LQS]MINING_MY_BUSINESS 2
-----------------------------------
local m = Module:new("lqs_mining_my_business")

local info =
{
    name     = "Mining My Business",
    author   = "Loxley",
    var      = "[LQS]MINING_MY_BUSINESS",
    required =
    {
        item = 5738,
        name = "a chunk of sweet lizard",
    },
    reward   =
    {
        item  = { { xi.item.PICKAXE, 36 } },
        after = function(player)
            cq.rewardSlots(player, { xi.inv.WARDROBE4, 1 })
            cq.fieldTunica(player)

            return true
        end,
    },
}

local IronDigger = "Iron Digger"

cq.add(m, {
    info   = info,
    entities =
    {
        ["Zeruhn_Mines"] =
        {
            {
                id     = GALKA,
                name   = IronDigger,
                type   = xi.objType.NPC,
                look   = cexi.util.look({
                    race = xi.race.GALKA,
                    face = cexi.face.B1,
                    head = 15,
                    body = 15,
                    hand = 8,
                    legs = 17,
                    feet = 8,
                }),
                area    = "Zeruhn_Mines",
                pos     = { 66.655, 7.925, -149.454, 31 }, -- !pos 66.655 7.925 -149.454 172
                default = { "Sorry pal, I'm a little busy here right now." },
            },
        },
    },
    steps =
    {
        {
            check    = cq.checks({ CW = true, level = 5 }),
            [GALKA]  = cq.dialog({
                quest = info.name,
                event =
                {
                    { delay  = 500 },
                    { entity = IronDigger, emote = xi.emote.EXCAVATION },
                    "This is 'arder than it looks.",
                    "Even 'arder when you're hungry as I am!",
                    { delay  = 2000 },
                    { entity = IronDigger, emote = xi.emote.LAUGH },
                    "You want to try your hand? Hah!",
                    { delay  = 2000},
                    "Tell ya what, bring me a chunk of sweet lizard",
                    " and I'll share some picks to 'ave a go yerself.",
                },
            })
        },
        {
            [GALKA] =
            {
                onTrigger = cq.dialog({
                    step  = false,
                    event =
                    {
                        "Bring me a chunk of sweet lizard and you can 'ave those picks.",
                    },
                }),
                onTrade   = LQS.trade({
                    quest    = info.name,
                    required = info.required.item,
                    reward   = info.reward,
                    declined =
                    {
                        { entity = IronDigger, emote = xi.emote.NO },
                        "I can't eat this... it's not even cooked properly!",
                    },
                    accepted =
                    {
                        { delay = 500 },
                        { entity = IronDigger, emote = xi.emote.CHEER },
                        "That's the stuff!",
                        { delay  = 2000 },
                        "It's a deal. Here's yer pickaxes.",
                        "Happy rock hittin' to the both o' us!",
                    },
                }),

                cq.tradeStep("ACCEPTED", "DECLINED", info.required.item, info.reward, info.name, cexi.music.NONE),
            }
        },
        {
            [GALKA] = cq.dialog({
                step  = false,
                event =
                {
                    { entity = IronDigger, emote = xi.emote.CHEER },
                    "Rock smashers forever!",
                    { delay  = 1000 },
                },
            }),
        },
    },
})

return m
