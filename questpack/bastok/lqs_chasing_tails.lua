-----------------------------------
-- Chasing Tails (Lv1)
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
-- !setvar [LQS]CHASING_TALES 0
-- Shining Stone !pos 98.661 6.017 -17.552 234
-- !additem 926 12
-- Reward: 600 gil
-----------------------------------
-- !setvar [LQS]CHASING_TALES 1
-----------------------------------
local m = Module:new("lqs_chasing_tails")

local info =
{
    name     = "Chasing Tales",
    author   = "Loxley",
    var      = "[LQS]CHASING_TALES",
    tally    = "[LQS]TAILS",
    required =
    {
        item = { { 926, 12 } },
        name = "a lizard tail",
    },
    reward   =
    {
        gil = 600,
    },
}

local ShiningStone = "Shining Stone"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Bastok_Mines"] =
        {
            {
                name   = ShiningStone,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.GALKA,
                    face = LQS.face.B8,
                    head = 119, -- Magnifying Spectacles
                    body = 20,
                    hand = 20,
                    legs = 20,
                    feet = 20,
                }),
                pos    = { 98.661, 6.017, -17.552, 224 }, -- !pos 98.661 6.017 -17.552 234
                dialog = { "Brewing potions is harder than it looks!" },
            },
        },
    },
    steps =
    {
        {
            [ShiningStone] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "What? Never seen a Galkachemist before?",
                    { emote = xi.emote.LAUGH },
                    { delay = 2000 },
                    "The truth is, I'm new here... and I keep forgetting my ingredients!",
                    " It would really help me out if you brought twelve lizard tails.",
                },
            })
        },
        {
            [ShiningStone] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "It would really help me out if you brought twelve lizard tails.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required.item,
                    reward   = info.reward,
                    step     = false,
                    tally    = info.tally,
                    declined =
                    {
                        "It would really help me out if you brought twelve lizard tails.",
                    },
                    accepted =
                    {
                        "Thanks! Now I can get back to work.",
                        { emote = xi.emote.CHEER },
                        { fmt = " So far, you've helped me brew {} potions.", var = info.tally },
                        "Bring more lizard tails and I'll gladly do business again!",
                    },
                }),
            },
        },
    },
})

return m
