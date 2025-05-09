-----------------------------------
-- Fleeing Daylight (Lv15)
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
-- !setvar [LQS]FLEEING_DAYLIGHT 0
-- Tenebraux !pos -138.888 -2.199 66.680 231
-- !additem 2014 6
-- Reward: Scroll of Diaga
-----------------------------------
-- !setvar [LQS]FLEEING_DAYLIGHT 1
-----------------------------------
local m = Module:new("lqs_earthen_echoes")

local info =
{
    name     = "Fleeing Daylight",
    author   = "Loxley",
    var      = "[LQS]FLEEING_DAYLIGHT",
    required = { { 2014, 6 } },
    reward   =
    {
        item = 4641, -- Scroll of Diaga
    },
}

local Tenebraux = "Tenebraux"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Northern_San_dOria"] =
        {
            {
                name   = Tenebraux,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.ELVAAN_M,
                    face = LQS.face.B2,
                    body = 11, -- White Cloak
                    hand = 3,  -- Mitts
                    legs = 3,  -- Slacks
                    feet = 3,  -- Solea
                }),
                pos     = { -138.888, -2.199, 66.680, 67 }, -- !pos -138.888 -2.199 66.680 231
                default = { "Who are you? Please don't disturb me." },
            },
        },
    },
    steps =
    {
        {
            check       = LQS.checks({ level = 15 }),
            [Tenebraux] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "Who disturbs my peace? Wait. Do not come closer.",
                    { emote = xi.emote.NO },
                    " Fetch six vials of bird blood and I'll share a secret.",
                },
            })
        },
        {
            [Tenebraux] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Fetch six vials of bird blood and I'll share a secret.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    step     = true,
                    declined =
                    {
                        "Fetch six vials of bird blood and I'll share a secret.",
                    },
                    accepted =
                    {
                        "Thank you adventurer, I can't gather these myself anymore.",
                        " I have a rare condition and can no longer bear the sun's light.",
                        "For your help, I offer this scroll that I no longer have need of.",
                    },
                })
            },
        },
        {
            [Tenebraux] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Thanks for helping but please don't disturb me.",
                    },
                })
            },
        },
    },
})

return m
