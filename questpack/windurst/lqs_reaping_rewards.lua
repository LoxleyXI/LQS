-----------------------------------
-- Reaping Rewards (Lv5)
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
-- !setvar [LQS]REAPING_REWARDS 0
-- Fha Mhakyaa !pos -162.120 -16.658 -93.217 115
-- !additem 5739
-- Reward: Sickle x36
-----------------------------------
-- !setvar [LQS]REAPING_REWARDS 2
-----------------------------------
local m = Module:new("lqs_reaping_rewards")

local info =
{
    name     = "Reaping Rewards",
    author   = "Loxley",
    var      = "[LQS]REAPING_REWARDS",
    required = 5739, -- Honeyed Egg
    reward   =
    {
        item  = { { xi.item.SICKLE, 36 } },
    },
}

local FhaMhakyaa = "Fha Mhakyaa"

LQS.add(m, {
    info   = info,
    entities =
    {
        ["West_Sarutabaruta"] =
        {
            {
                name = FhaMhakyaa,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.MITHRA,
                    face = LQS.face.A2,
                    head = 20,
                    body = 20,
                    hand = 8,
                    legs = 8,
                    feet = 8,
                }),
                pos     = { -162.120, -16.658, -93.217, 23 }, -- !pos -162.120 -16.658 -93.217 115
                default = { "G~rrreetings strrranger." },
            },
        },
    },
    steps =
    {
        {
            check        = LQS.checks({ level = 5 }),
            [FhaMhakyaa] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.HARVESTING },
                    { delay  = 2000 },
                    "G~rrreetings strrranger.",
                    " I'm out here harvesting ingrrredients for a poultice.",
                    "It's been a verrr~y long day and I would love a mug of honeyed egg.",
                    { emote = xi.emote.BLUSH },
                    " If you bring me one, I'll share some of my sickles.",
                    { delay  = 500 },
                },
            })
        },
        {
            [FhaMhakyaa] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Brrr~ing me a mug of honeyed egg and I'll sharrre some sickles.",
                        { entity = Fha, emote = xi.emote.HARVESTING },
                        { delay  = 2000 },
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    declined =
                    {
                        { entity = Fha, emote = xi.emote.NO },
                        "Sorry but my diet is verrr~y particular.",
                        { delay  = 500 },
                    },
                    accepted =
                    {
                        { entity = Fha, emote = xi.emote.PRAISE},
                        "Mmmm... grrreat! Here arrr~e your sickles.",
                        { delay  = 500 },
                    },
                }),
            },
        },
        {
            [FhaMhakyaa] = LQS.dialog({
                step  = false,
                event =
                {
                    "I'm harrr~d at work out here.",
                    { entity = Fha, emote = xi.emote.HARVESTING },
                    { delay  = 2000 },
                },
            }),
        },
    },
})

return m
