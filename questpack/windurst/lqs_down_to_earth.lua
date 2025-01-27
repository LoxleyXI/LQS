-----------------------------------
-- Down to Earth (Lv1)
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
-- !setvar [LQS]DOWN_TO_EARTH 0
-- Hermin-Harmon !pos -52.629 -10.750 123.497 238
-- !additem 582
-- Reward: Various ores
-----------------------------------
-- !setvar [LQS]DOWN_TO_EARTH 1
-----------------------------------
local m = Module:new("lqs_down_to_earth")

local info =
{
    name   = "Down to Earth",
    author = "Loxley",
    var    = "[LQS]DOWN_TO_EARTH",
    tally  = "[LQS]METEORITES",
    exchange =
    {
        [582] = -- Meteorite
        {
            { LQS.COMMON,    640, "a chunk of copper ore"   }, --  (15%)
            { LQS.COMMON,    642, "a chunk of zinc ore"     }, --  (15%)
            { LQS.UNCOMMON,  643, "a chunk of iron ore"     }, --  (10%)
            { LQS.UNCOMMON,  736, "a chunk of silver ore"   }, --  (10%)
            { LQS.RARE,      737, "a chunk of gold ore"     }, --  ( 5%)
            { LQS.VERY_RARE, 738, "a chunk of platinum ore" }, --  ( 1%)
        },
    },
}

local HerminHarmon = "Hermin-Harmon"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Windurst_Waters"] =
        {
            {
                name = HerminHarmon,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.TARU_M,
                    face = LQS.face.A4,
                    head = 3,
                    body = 3,
                    hand = 3,
                    legs = 3,
                    feet = 3,
                }),
                pos     = { -52.629, -10.750, 123.497, 101 }, -- !pos -52.629 -10.750 123.497 238
                default = { "Have you ever seen a falling star?" },
            },
        },
    },
    steps =
    {
        {
            [HerminHarmon] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "Have you ever seen a falling star?",
                    { emote = xi.emote.THINK },
                    { delay = 2000 },
                    " Legend has it that when they first fell on Starfall Hillock...",
                    " We used the metal to build weapons, and so began all the wars.",
                    { emote = xi.emote.SIGH },
                    { delay = 3000 },
                    "Maybe if you find one of those meteorites, I could salvage some material.",
                },
            })
        },
        {
            [HerminHarmon] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Bring me a meteorite and I'll try to salvage some material.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    tally    = info.tally,
                    step     = false,
                    exchange = info.exchange,
                    accepted =
                    {
                       "So it's true. These rocks do contain metal...",
                        " Let's see what secrets this one holds.",
                        { emote = xi.emote.THINK },
                        { delay = 3000 },
                    },
                    declined =
                    {
                        "Bring me a meteorite and I'll try to salvage some material.",
                    },
                }),
            },
        },
    },
})

return m
