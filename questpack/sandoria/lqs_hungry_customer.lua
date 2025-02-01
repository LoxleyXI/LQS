-----------------------------------
-- Hungry Customer (Lv1)
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
-- !setvar [LQS]HUNGRY_CUSTOMER 0
-- !setvar [LQS]HARE_MEAT 0
-- Couquillard !pos 95.225 0.000, 118.159 230
-- !additem 4358 12
-- Rewards: 900g
-----------------------------------
local m = Module:new("lqs_hungry_customer")

local info =
{
    name     = "Hungry Customer",
    author   = "Loxley",
    var      = "[LQS]HUNGRY_CUSTOMER",
    tally    = "[LQS]HARE_MEAT",
    required = { { 4358, 12 } }, -- Hare Meat x12
    reward   =
    {
        gil = 900,
    },
}

local Couquillard   = "Couquillard"
local RumblingBelly = "Rumbling Belly"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Southern_San_dOria"] =
        {
            {
                name = RumblingBelly,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.GALKA,
                    face = LQS.face.B7,
                    head = 1,
                    body = 28,
                    hand = 1,
                    legs = 28,
                    feet = 28,
                }),
                pos     = { 93.210, 1.000, 120.840, 127 }, -- !pos 93.210 1.000 120.840 230
                default =
                {
                    { emote = xi.emote.SULK },
                    "So hungry...",
                },
            },
            {
                name = Couquillard,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.ELVAAN_M,
                    face = LQS.face.B7,
                    head = 0,
                    body = 20,
                    hand = 3,
                    legs = 61,
                    feet = 3,
                }),
                pos     = { 95.225, 0.000, 118.159, 225 }, -- !pos 95.225 0.000, 118.159 230
                default = { "He's back again..." },
            },
        },
    },
    steps =
    {
        {
            [Couquillard] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "One particular customer keeps eating all our hare meat!",
                    { entity = RumblingBelly, emote = xi.emote.LAUGH },
                    " Fetch twelve hare meat and I'll reward you.",
                },
            })
        },
        {
            [Couquillard] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Please fetch twelve hare meat and I'll reward you.",
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
                        "Please fetch twelve hare meat and I'll reward you.",
                    },
                    accepted =
                    {
                        "Phew, thank you. Now I can serve my customers again!",
                        { entity = RumblingBelly, emote = xi.emote.LAUGH },
                        { fmt = " So far, that makes {} hare dishes served, all thanks to you.", var = info.tally },
                    },
                }),
            },
        },
    },
})

return m
