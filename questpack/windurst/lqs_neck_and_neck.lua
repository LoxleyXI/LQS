-----------------------------------
-- Neck and Neck    (Lv10)
-- Neck and Neck II (Lv12)
-----------------------------------
-- Copyright (c) 2025 LoxleyXI
--
-- https://github.com/LoxleyXI/LQS
-----------------------------------
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see http://www.gnu.org/licenses/
-----------------------------------
-- !setvar [LQS]NECK_AND_NECK 0
-- !setvar [LQS]PAPAKA 0
-- Erbelie       !pos -28.726 -4.152 59.257 241
-- Dhalmel Bones !pos 222.800 -21.077 597.115 115
-- Reward: 1500 gil
-----------------------------------
-- Erbelie       !pos -28.726 -4.152 59.257 241
-- !additem 938 2
-- Reward: 800 gil
-----------------------------------
-- !setvar [LQS]NECK_AND_NECK 5
-----------------------------------
local m = Module:new("lqs_neck_and_neck")

local info =
{
    name     = "Neck and Neck",
    name2    = "Neck and Neck II",
    author   = "Loxley",
    var      = "[LQS]NECK_AND_NECK",
    tally    = "[LQS]PAPAKA",
    required = { { 938, 2 } }, -- Papaka Grass x2
    reward   =
    {
        {
            gil = 1500,
        },
        {
            gil = 800,
        },
    },
}

local Erbelie      = "Erbelie"
local DhalmelBones = "Dhalmel Bones"
local GhostDhalmel = "Ghost Dhalmel"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Windurst_Woods"] =
        {
            {
                name = Erbelie,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.ELVAAN_F,
                    face = LQS.face.B2,
                    head = 0,
                    body = 6,
                    hand = 6,
                    legs = 6,
                    feet = 6,
                }),
                pos     = { -28.726, -4.152, 59.257, 228}, -- !pos -28.726 -4.152 59.257 241
                default = { "Fascinating, aren't they?" },
            },
        },
        ["West_Sarutabaruta"] =
        {
            {
                id      = BONES,
                name    = DhalmelBones,
                marker  = LQS.SIDE_QUEST,
                pos     = { 222.800, -21.077, 597.115, 153 }, --!pos 222.800 -21.077 597.115 115
                default = LQS.NOTHING,
            },
            {
                id    = GHOST,
                name  = "Ghost Dhalmel",
                type  = xi.objType.MOB,
                base  = { 118, 16 },
                look  = 332,
                pos   = { 222.800, -21.077, 597.115, 153 }, --!pos 222.800 -21.077 597.115 115
                level = 7,
            },
        },
    },
    steps =
    {
        {
            check     = LQS.checks({ level = 10 }),
            [Erbelie] = LQS.dialog({
                event =
                {
                    { emote = xi.emote.THINK },
                    "Fascinating, aren't they?",
                    " It's said Dhalmels roamed northern Sarutabaruta before the great war",
                    { delay = 2000 },
                    "I'd sure like to see some evidence though. Could you help me?",
                },
            }),
        },
        {
            [Erbelie] = LQS.menu({
                quest   = info.name,
                title   = "Dhalmels in Sarutabaruta?",
                options =
                {
                    {
                        "I don't believe in nonsense.",
                    },
                    {
                        "Let's neck it out.",
                        { "Thank you. Let me know what you find." },
                    },
                },
            }),
        },
        {
            [Erbelie] = LQS.dialog({
                step  = false,
                event =
                {
                    "Let me know what you find.",
                },
            }),
            [DhalmelBones] = LQS.menu({
                spawn   = { GhostDhalmel },
                title   = "Look closer?",
                options =
                {
                    {
                        "No.",
                    },
                    {
                        "Yes",
                        true,
                    },
                },
            }),
            [GhostDhalmel] = LQS.defeat({
                mobs    = { GhostDhalmel },
                spawner = DhalmelBones,
            }),
        },
        {
            [DhalmelBones] = LQS.nothingElse(),
            [Erbelie]  = LQS.dialog({
                quest  = info.name,
                reward = info.reward[1],
                event  =
                {
                    { emote = xi.emote.SHOCKED },
                    "You found what!? Oh my... Thanks for looking into this.",
                    " From now on, I think I'll stick to admiring the ones we have here!",
                    { delay = 2000 },
                    "Hmmm... Their favorite treat is papaka grass. Maybe you could find some.",
                },
            })
        },
        {
            check     = LQS.checks({ level = 12 }),
            [Erbelie] = LQS.dialog({
                quest  = info.name2,
                event  =
                {
                    "A dhalmel's favorite treat is papaka grass.",
                    " Collect two sprigs and I'll pay.",
                },
            })
        },
        {
            [Erbelie] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "A dhalmel's favorite treat is papaka grass.",
                        " Collect two sprigs and I'll pay.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name2,
                    required = info.required,
                    reward   = info.reward[2],
                    step     = false,
                    tally    = info.tally,
                    declined =
                    {
                        "A dhalmel's favorite treat is papaka grass.",
                        " Collect two sprigs and I'll pay.",
                    },
                    accepted =
                    {
                        { emote = xi.emote.BOW },
                        "Thanks for bringing these. That makes {} sprigs.",
                        " If you find any more, I'll gladly pay for them.",
                    },
                }),
            },
        },
    },
})

return m
