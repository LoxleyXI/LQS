-----------------------------------
-- Rustling Feathers (Lv5)
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
-- !setvar [LQS]DARKSTEEL_ORE 0
-- !setvar [LQS]LODE_OF_GIL 0
-- Mighty Hammer !pos -45.663 2.000 -22.873 237
-----------------------------------
-- !setvar [LQS]LODE_OF_GIL 1
-----------------------------------
local m = Module:new("lqs_lode_of_gil")

local info =
{
    name     = "Lode of Gil",
    author   = "Loxley",
    var      = "[LQS]LODE_OF_GIL",
    tally    = "[LQS]DARKSTEEL_ORE",
}

local exchange =
{
    [645] =
    {
        { cexi.rate.GUARANTEED, { gil = 4000 } }, -- 100%
    },
}

local MightyHammer = "Mighty Hammer"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Metalworks"] =
        {
            {
                name    = MightyHammer,
                type    = xi.objType.NPC,
                look    = 174,
                pos     = { -45.663, 2.000, -22.873, 97 }, -- !pos -45.663 2.000 -22.873 237
                default = { "Made darksteel all my life." },
            },
        },
    },
    steps =
    {
        {
            check          = LQS.checks({ level = 5 }),
            [MightyHammer] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "Forging darksteel is busy work, don't have time to source the materials.",
                    " I'll pay for every darksteel ore you bring me.",
                },
            })
        },
        {
            [MightyHammer] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Forging darksteel is busy work, don't have time to source the materials.",
                        " I'll pay for every darksteel ore you bring me.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    step     = false,
                    tally    = info.tally,
                    exchange = exchange,
                    declined =
                    {
                        "What's this!? I'll pay for every darksteel ore you bring me."
                    },
                    accepted =
                    {
                        "All right!",
                        { fmt = "I'll add this to the {} you've already brought me. Here's your payment.", var = info.tally },
                    },
                }),
            },
        },
    },
})

return m
