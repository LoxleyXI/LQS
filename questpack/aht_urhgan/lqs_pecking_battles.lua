-----------------------------------
-- Pecking Battles (Lv50)
-----------------------------------
-- !setvar [LQS]PECKING_BATTLES 0
-- !setvar [LQS]BEAKS 0
-- Vermali !pos 369.949 -12.550 -52.531 52
-- !additem 2171 6
-- Rewards: Wivre Mask, 1800 gil
-----------------------------------
-- !setvar [LQS]PECKING_BATTLES 1
-----------------------------------
local m = Module:new("lqs_quest-pecking_battles")

local info =
{
    name     = "Pecking Battles",
    author   = "Loxley",
    var      = "[LQS]PECKING_BATTLES",
    tally    = "[LQS]BEAKS",
    required =
    {
       { { 2171, 60 } },
       { { 2171,  6 } },
    },
    reward  =
    {
        {
            item    = 16130,             -- Wivre Mask (Lv65)
            augment = { 513, 2, 23, 4 }, -- DEX +3, Accuracy +5
        },
        {
            gil = 1800,
        },
    },
}

local Vermali = "Vermali"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Bhaflau_Thickets"] =
        {
            {
                name   = Vermali,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.HUME_M,
                    face = LQS.face.A5,
                    head = 171,
                    body = 172,
                    hand = 174,
                    legs = 172,
                    feet = 174,
                }),
                pos     = { 369.949, -12.550, -52.531, 225 }, -- !pos 369.949 -12.550 -52.531 52
                default = { "What a racket!" },
            },
        },
    },
    steps =
    {
        {
            check = LQS.checks({ level = 50 }),
            [Vermali] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.FUME },
                    "Birds!! I 'ate these the stupid birds!",
                    " Flap, flap, flap, screech, screech. I hate it!",
                    { delay = 2000 },

                    "Put down as many of these pests as you can.",
                    { emote = xi.emote.LAUGH },
                    " Bring me sixty beaks and I'll make it worth your while!",
                },
            })
        },
        {
            [Vermali] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        { emote = xi.emote.THINK },
                        "Bring me sixty beaks and I'll make it worth your while!",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required[1],
                    reward   = info.reward[1],
                    tally    = info.tally,
                    declined =
                    {
                        { emote = xi.emote.NO },
                        "Remember, it's sixty beaks or no deal!",
                    },
                    accepted =
                    {
                        { emote = xi.emote.YES },
                        "This is a great start. But our work has only just begun!",
                        " Bring me another six at a time and I'll pay.",
                    },
                }),
            },
        },
        {
            [Vermali] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        { emote = xi.emote.PANIC },
                        "Please get rid of these birds! Hand over six colibri beaks and I'll pay.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required[2],
                    reward   = info.reward[2],
                    tally    = info.tally,
                    declined =
                    {
                        { emote = xi.emote.NO },
                        "That isn't the proof I asked for. Remember, it's six beaks!",
                    },
                    accepted =
                    {
                        { emote = xi.emote.CLAP },
                        "That's the stuff. Get those birds!!",
                        { fmt = " You've handed me a total of {} beaks.", var = info.tally },
                        "Bring me more, soldier.",
                    },
                }),
            },
        },
    },
})

return m
