-----------------------------------
-- Head First (Lv10)
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
-- !setvar [LQS]HEAD_FIRST 0
-- Hume Footprint !pos 639.090 24.000 120.994 108
-- !additem 538
-- Reward: Lizard Mantle
-----------------------------------
-- !setvar [LQS]HEAD_FIRST 3
-----------------------------------
local m = Module:new("lqs_head_first")

local info =
{
    name     = "Head First",
    author   = "Loxley",
    var      = "[LQS]HEAD_FIRST",
    required = xi.item.MAGICKED_SKULL,
    reward   =
    {
        item    = 13592,      -- Lizard Mantle
        augment = { 512, 0 }, -- STR +1
    },
}

local Leidl         = "Leidl"
local HumeFootprint = "Hume Footprint"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Konschtat_Highlands"] =
        {
            {
                name     = HumeFootprint,
                marker   = LQS.SIDE_QUEST,
                pos      = { 639.090, 24.000, 120.994, 24 },-- !pos 639.090 24.000 120.994 108
                default  = LQS.NOTHING,
            },
            {
                name   = Leidl,
                type   = xi.objType.NPC,
                hidden = true,
                look   = LQS.look({
                    race = xi.race.HUME_F,
                    face = LQS.face.B1,
                    head = 0,
                    body = 3,
                    hand = 3,
                    legs = 11,
                    feet = 3,
                }),
                pos    = { 639.090, 24.000, 120.994, 24 }, -- !pos 639.090 24.000 120.994 108
            },
        },
    },
    steps =
    {
        {
            check           = LQS.checks({ level = 10 }),
            [HumeFootprint] = LQS.dialog({
                quest = info.name,
                spawn = Leidl,
                event =
                {
                    { entity  = Leidl, emote = xi.emote.SHOCKED },
                    "Hey! Help!",
                    " I mean... everything is fine but...",
                    { delay   = 2000 },
                    { entity  = Leidl, emote = xi.emote.PANIC },

                    "Some old man asked me to fetch a magicked skull from these mines.",
                    " But... I can't! I just can't!",
                    { delay  = 1000 },
                    { entity = Leidl, emote = xi.emote.THINK },

                    "You look brave... You'll go in there for me, right?",
                    { delay = 1000 },
                    " Please bring back a magicked skull and I'll make it worth your time!",
                },
            }),
        },
        {
            [HumeFootprint] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    spawn = Leidl,
                    event =
                    {
                        "Please bring back a magicked skull and I'll make it worth your time!",
                    },
                }),
                onTrade   = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    spawn    = Leidl,
                    declined = { "Please bring back a magicked skull and I'll make it worth your time!" },
                    accepted =
                    {
                        { entity  = Leidl, emote = xi.emote.CHEER },
                        "You did it! You actually did it!",
                        { delay   = 2000 },

                        "Thank you. I can't wait to get out of here.",
                        { delay  = 1000 },
                        { entity = Leidl, emote = xi.emote.POINT },
                        " As promised, here's your reward. I hope you find it useful.",
                    },
                }),
            },
        },
        {
            [HumeFootprint] = LQS.dialog({
                step  = false,
                name  = "",
                event =
                {
                    "Whoever was here is long gone..."
                },
            }),
        },
    },
})

return m
