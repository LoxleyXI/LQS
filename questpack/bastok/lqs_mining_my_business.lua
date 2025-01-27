-----------------------------------
-- Mining My Business (Lv5)
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
-- !setvar [LQS]MINING_MY_BUSINESS 0
-- Iron Digger !pos 66.655 7.925 -149.454 172
-- !additem 5738
-- Reward: Pickaxe x36
-----------------------------------
-- !setvar [LQS]MINING_MY_BUSINESS 2
-----------------------------------
local m = Module:new("lqs_mining_my_business")

local info =
{
    name     = "Mining My Business",
    author   = "Loxley",
    var      = "[LQS]MINING_MY_BUSINESS",
    required = 5738, -- Sweet Lizard
    reward   =
    {
        item  = { { xi.item.PICKAXE, 36 } },
    },
}

local IronDigger = "Iron Digger"

LQS.add(m, {
    info   = info,
    entities =
    {
        ["Zeruhn_Mines"] =
        {
            {
                name   = IronDigger,
                type   = xi.objType.NPC,
                look   = cexi.util.look({
                    race = xi.race.GALKA,
                    face = cexi.face.B1,
                    head = 15,
                    body = 15,
                    hand = 8,
                    legs = 17,
                    feet = 8,
                }),
                pos     = { 66.655, 7.925, -149.454, 31 }, -- !pos 66.655 7.925 -149.454 172
                default = { "Sorry pal, I'm a little busy here right now." },
            },
        },
    },
    steps =
    {
        {
            check        = LQS.checks({ level = 5 }),
            [IronDigger] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { delay  = 500 },
                    { entity = IronDigger, emote = xi.emote.EXCAVATION },
                    "This is 'arder than it looks.",
                    "Even 'arder when you're hungry as I am!",
                    { delay  = 2000 },
                    { entity = IronDigger, emote = xi.emote.LAUGH },
                    "You want to try your hand? Hah!",
                    { delay  = 2000},
                    "Tell ya what, bring me a chunk of sweet lizard",
                    " and I'll share some picks to 'ave a go yerself.",
                },
            })
        },
        {
            [IronDigger] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Bring me a chunk of sweet lizard and you can 'ave those picks.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    declined =
                    {
                        { entity = IronDigger, emote = xi.emote.NO },
                        "I can't eat this... it's not even cooked properly!",
                    },
                    accepted =
                    {
                        { delay = 500 },
                        { entity = IronDigger, emote = xi.emote.CHEER },
                        "That's the stuff!",
                        { delay  = 2000 },
                        "It's a deal. Here's yer pickaxes.",
                        "Happy rock hittin' to the both o' us!",
                    },
                }),
            }
        },
        {
            [IronDigger] = LQS.dialog({
                step  = false,
                event =
                {
                    { entity = IronDigger, emote = xi.emote.CHEER },
                    "Rock smashers forever!",
                    { delay  = 1000 },
                },
            }),
        },
    },
})

return m
