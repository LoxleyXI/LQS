-----------------------------------
-- Staying Afloat (Lv1)
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
-- !setvar [LQS]STAYING_AFLOAT 0
-- Archimedes !pos -154.714 12.000 142.442 231
-- !additem 4504 12
-- Reward: 800 gil
-----------------------------------
-- !setvar [LQS]STAYING_AFLOAT 1
-----------------------------------
local m = Module:new("lqs_staying_afloat")

local info =
{
    name     = "Staying Afloat",
    author   = "Loxley",
    var      = "[LQS]STAYING_AFLOAT",
    tally    = "[LQS]ACORNS",
    required = { { 4504, 12 } },
    reward   =
    {
        gil = 800,
    },
}

local Archimedes = "Archimedes"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Northern_San_dOria"] =
        {
            {
                name   = Archimedes,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.ELVAAN_M,
                    face = LQS.face.B8,
                    head = 115,
                    body = 149,
                    hand = 3,
                    legs = 3,
                    feet = 149,
                }),
                pos     = { -154.714, 12.000, 142.442, 128 }, -- !pos -154.714 12.000 142.442 231
                default = { "Excuse me... I'm dealing with very important matters right now. Do not bother me." },
            },
        },
    },
    steps =
    {
        {
            [Archimedes] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "Greetings. I'm in need of acorns for a... a very important experiment.",
                    { emote = xi.emote.THINK },
                    " Gather twelve acorns and I'll make it worth your while.",
                },
            })
        },
        {
            [Archimedes] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Gather twelve acorns and I'll make it worth your while.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    step     = false,
                    tally    = info.tally,
                    declined =
                    {
                        "Gather twelve acorns and I'll make it worth your while.",
                    },
                    accepted =
                    {
                        { fmt = "Thank you. So far you've brought me {} acorns.", var = info.tally },
                        " Excuse me, one moment.",
                        { entity = Archimedes, face = 128 },
                        { delay = 2000 },
                        { emote = xi.emote.TOSS },
                        { delay = 3000 },
                        "Fascinating...",
                        { entity = Archimedes, face = "player" },
                        "Here's your reward.",
                    },
                }),
            },
        },
    },
})

return m
