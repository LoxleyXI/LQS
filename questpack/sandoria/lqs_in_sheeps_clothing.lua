-----------------------------------
-- In Sheep's Clothing (Lv5)
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
-- !setvar [LQS]SHEEPS_CLOTHING 0
-- !setvar [LQS]SHEEPSKIN 0
-- Chilly Wolf !pos -247.432 8.000 7.263 231
-- !additem 505 3
-- Rewards: 250g
-----------------------------------
-- !setvar [LQS]SHEEPS_CLOTHING 1
-----------------------------------
local m = Module:new("lqs_in_sheeps_clothing")

local info =
{
    name     = "In Sheep's Clothing",
    author   = "Loxley",
    var      = "[LQS]SHEEPS_CLOTHING",
    tally    = "[LQS]SHEEPSKIN",
    required = { { 505, 3 } }, -- Sheepskin x3
    reward   =
    {
        gil = 250,
    },
}

local ChillyWolf = "Chilly Wolf"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Northern_San_dOria"] =
        {
            {
                name = ChillyWolf,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.GALKA,
                    face = LQS.face.B2,
                    head = 0,
                    body = 20,
                    hand = 20,
                    legs = 20,
                    feet = 20,
                    main = 2,
                }),
                pos     = { -247.432, 8.000, 7.263, 222 }, -- !pos -247.432 8.000 7.263 231
                default = { "So brrr~ cold..." },
            },
        },
    },
    steps  =
    {
        {
            check        = LQS.checks({ level = 5 }),
            [ChillyWolf] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.STAGGER },
                    "Ronfaure is so cold. I miss the blistering heat of Gustaberg.",
                    " Get three sheepskin to warm me up and I'll pay for it.",
                },
            })
        },
        {
            [ChillyWolf] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Get three sheepskin to warm me up and I'll pay for it.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    step     = false,
                    required = info.required,
                    reward   = info.reward,
                    tally    = info.tally,
                    declined =
                    {
                        "Get three sheepskin to warm me up and I'll pay for it.",
                    },
                    accepted =
                    {
                        { emote = xi.emote.YES },
                        { fmt = "That's better, but not enough. So far, I have {} sheepskins.", var = info.tally },
                        " Get more sheepskins and I'll keep paying.",
                    },
                }),
            }
        },
    },
})

return m
