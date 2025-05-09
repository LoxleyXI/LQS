-----------------------------------
-- Earthen Echoes (Lv15)
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
-- !setvar [LQS]EARTHEN_ECHOES 0
-- Rumbling Valley !pos 28.255 7.000 -13.689 234
-- !additem 768 12
-- Reward: Scroll of Stoneskin
-----------------------------------
-- !setvar [LQS]EARTHEN_ECHOES 1
-----------------------------------
local m = Module:new("lqs_earthen_echoes")

local info =
{
    name     = "Earthen Echoes",
    author   = "Loxley",
    var      = "[LQS]EARTHEN_ECHOES",
    required = { { 768, 12 } },
    reward   =
    {
        item = 4662, -- Scroll of Stoneskin
    },
}

local RumblingValley = "Rumbling Valley"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Bastok_Mines"] =
        {
            {
                name   = RumblingValley,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.GALKA,
                    face = LQS.face.B4,
                    head = 18, -- Traveler's Hat
                    body = 43, -- Earthen Doublet
                    hand = 3,  -- Mitts
                    legs = 3,  -- Slacks
                    feet = 3,  -- Solea
                }),
                pos     = { 28.255, 7.000, -13.689, 191 }, -- !pos 28.255 7.000 -13.689 234
                default = { "Can you hear the sound beneath us?" },
            },
        },
    },
    steps =
    {
        {
            check            = LQS.checks({ level = 15 }),
            [RumblingValley] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "Can you hear it? The call of the dust and the voice of the wind?",
                    " Bring me twelve flint stones and I'll tell you more.",
                },
            })
        },
        {
            [RumblingValley] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Bring me twelve flint stones and I'll tell you more.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    step     = true,
                    declined =
                    {
                        "Bring me twelve flint stones and I'll tell you more.",
                    },
                    accepted =
                    {
                        "Listen closely, all around you. Each aspect sings in perfect harmony.",
                        " There is a grand song in life, where everything plays a part.",
                        "Be the music, become one with the earth and nothing can break you.",
                    },
                })
            },
        },
        {
            [RumblingValley] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Can you hear it? Listen close.",
                    },
                })
            },
        },
    },
})

return m
