-----------------------------------
-- Rambling Around (Lv10)
-- Still Rambling  (Lv12)
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
-- !setvar [LQS]RAMBLING_AROUND 0
-- !setvar [LQS]LANOLIN 0
-- Glenda   !pos 81.170 3.000 33.216 230
-- Ram Wool !pos -267.380 -0.166 -569.411 100
-- Reward: 1500 gil
-----------------------------------
-- Glenda    !pos 81.170 3.000 33.216 230
-- !additem 531 2
-- Reward: 1800 gil
-----------------------------------
-- !setvar [LQS]RAMBLING_AROUND 5
-----------------------------------
local m = Module:new("lqs_rambling_around")

local info =
{
    name     = "Rambling Around",
    name2    = "Still Rambling",
    author   = "Loxley",
    var      = "[LQS]RAMBLING_AROUND",
    tally    = "[LQS]LANOLIN",
    required = { { 531, 2 } }, -- Lanolin Cube x2
    reward   =
    {
        {
            gil = 1500,
        },
        {
            gil = 1800,
        },
    },
}

local Glenda  = "Glenda"
local RamWool = "Ram Wool"
local WildRam = "Wild Ram"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Southern_San_dOria"] =
        {
            {
                name = Glenda,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.HUME_F,
                    face = LQS.face.B2,
                    head = 0,
                    body = 1,
                    hand = 1,
                    legs = 1,
                    feet = 1,
                }),
                pos     = { 81.170, 3.000, 33.216, 224 }, -- !pos 81.170 3.000 33.216 230
                default = { "Have you ever seen a ram?" },
            },
        },
        ["West_Ronfaure"] =
        {
            {
                name   = RamWool,
                marker = LQS.SIDE_QUEST,
                pos    = { -267.380, -0.166, -569.411, 170 }, --!pos -267.380 -0.166 -569.411 100
                dialog = LQS.NOTHING,
            },
            {
                name  = WildRam,
                type  = xi.objType.MOB,
                look  = 344,
                base  = { 102, 30 },
                pos   = { -267.380, -0.166, -569.411, 170 }, --!pos -267.380 -0.166 -569.411 100
                level = 4,
            },
        },
    },
    steps =
    {
        {
            check    = LQS.checks({ level = 10 }),
            [Glenda] = LQS.dialog({
                event =
                {
                    { emote = xi.emote.WAVE },
                    "Hello, I'm new here. Have you ever seen a ram?",
                    " Rosel told me they even used to roam into Ronfaure!",
                    { delay = 2000 },
                    { emote = xi.emote.THINK },
                    "I'd love to know if it's true. Would you be willing to help me find out?",
                },
            }),
        },
        {
            [Glenda] = LQS.menu({
                quest   = info.name,
                title   = "Rams in Ronfaure?",
                options =
                {
                    {
                        "Quit your rambling.",
                    },
                    {
                        "Let's find out.",
                        {
                            "I've been told that rams used to be seen in southern Ronfaure.",
                            " I hope you're able to find something.",
                        },
                    },
                },
            }),
        },
        {
            [Glenda] = LQS.dialog({
                step  = false,
                event =
                {
                    "I hope you're able to find something.",
                },
            }),
            [RamWool] = LQS.menu({
                spawn   = { WildRam },
                title   = "Examine the clump of wool?",
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
            [WildRam] = LQS.defeat({
                mobs    = { WildRam },
                spawner = RamWool,
            }),
        },
        {
            [RamWool] = LQS.nothingElse(),
            [Glenda]  = LQS.dialog({
                quest  = info.name,
                reward = info.reward[1],
                event  =
                {
                    { emote = xi.emote.AMAZED },
                    "Incredible. So there really were rams in Ronfaure!",
                },
            })
        },
        {
            check    = LQS.checks({ level = 12 }),
            [Glenda] = LQS.dialog({
                quest  = info.name2,
                event  =
                {
                    "Thanks for helping me out by investigating those rams.",
                    { emote = xi.emote.BOW },
                    { delay = 1000 },
                    "Here are at Rosel's we use lanolin to finish some of the pieces.",
                    " If you brought two lanolin cubes, I could make it worth your time.",
                },
            })
        },
        {
            [Glenda] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Here are at Rosel's we use lanolin to finish some of the pieces.",
                        " If you brought two lanolin cubes, I could make it worth your time.",
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
                        "If you brought two lanolin cubes, I could make it worth your time.",
                    },
                    accepted =
                    {
                        { emote = xi.emote.BOW },
                        { fmt = "Thanks for these lanolin cubes. That makes {}.", var = info.tally },
                        " We can always use more, please keep bringing them.",
                    },
                }),
            },
        },
    },
})

return m
