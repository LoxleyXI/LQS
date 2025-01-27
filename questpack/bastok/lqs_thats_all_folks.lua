-----------------------------------
-- That's All Folks (Lv10)
-- In a Bucket      (Lv12)
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
-- !setvar [LQS]THATS_ALL_FOLKS 0
-- !setvar [LQS]CRAB_SHELL 0
-- Conchata-Potata !pos -145.155 -7.480 7.991 236
-- Hare Tracks     !pos -550.685 40.000 -379.522 107
-- Reward: 1500 gil
-----------------------------------
-- Conchata-Potata !pos -145.155 -7.480 7.991 236
-- !additem 881 3
-- Reward: 1800 gil
-----------------------------------
-- !setvar [LQS]THATS_ALL_FOLKS 4
-----------------------------------
local m = Module:new("lqs_thats_all_folks")

local info =
{
    name     = "That's All Folks",
    name2    = "In a Bucket",
    author   = "Loxley",
    var      = "[LQS]THATS_ALL_FOLKS",
    tally    = "[LQS]CRAB_SHELL",
    required = { { 881, 3 } }, -- Crab Shell x3
    reward   =
    {
        {
            gil = 1500,
        },
        {
            gil = 1800,
        },
    },
}

local ConchataPotata = "Conchata-Potata"
local HareTracks     = "Hare Tracks"
local GustabergHare  = "Gustaberg Hare"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Port_Bastok"] =
        {
            {
                name   = ConchataPotata,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.TARU_M,
                    face = LQS.face.B4,
                    head = 119, -- Magnifying Spectacles
                    body = 18,  -- Velvet Robe
                    hand = 20,
                    legs = 20,
                    feet = 20,
                }),
                pos     = { -145.155, -7.480, 7.991, 177 }, -- !pos -145.155 -7.480 7.991 236
                default = { "Many years ago, wild hare inhibated the land around Bastok." },
            },
        },
        ["South_Gustaberg"] =
        {
            {
                name    = HareTracks,
                marker  = LQS.SIDE_QUEST,
                pos     = { -550.685, 40.000, -379.522, 153 }, --!pos -550.685 40.000 -379.522 107
                default = LQS.NOTHING,
            },
            {
                name  = GustabergHare,
                type  = xi.objType.MOB,
                base  = { 191, 9 },
                look  = 268,
                pos   = { -550.685, 40.000, -379.522, 153 }, --!pos -550.685 40.000 -379.522 107
                level = 7,
            },
        },
    },
    steps =
    {
        {
            check            = LQS.checks({ level = 10 }),
            [ConchataPotata] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.THINK },
                    "Many years ago, wild hare inhibated the land around Bastok.",
                    " They're a rare sight today, having mostly migrated to Dangruf.",
                    { delay = 2000 },
                    "If you find any traces of the the Gustaberg Hare, let me know.",
                    " I've heard a rumor that one was sighted around the Fumaroles.",
                },
            }),
        },
        {
            [ConchataPotata] = LQS.dialog({
                step  = false,
                event =
                {
                    { emote = xi.emote.THINK },
                    "If you find any traces of the the Gustaberg Hare, let me know.",
                    " I've heard a rumor that one was sighted around the Fumaroles.",
                },
            }),
            [HareTracks] = LQS.menu({
                spawn   = { GustabergHare },
                title   = "Inspect the tracks?",
                options =
                {
                    {
                        "No.",
                    },
                    {
                        "Yes",
                        true,
                    },
                },
            }),
            [GustabergHare] = LQS.defeat({
                mobs    = { GustabergHare },
                spawner = HareTracks,
            }),
        },
        {
            [HareTracks]     = LQS.nothingElse(),
            [ConchataPotata] = LQS.dialog({
                quest  = info.name,
                reward = info.reward[1],
                event  =
                {
                    { emote = xi.emote.AMAZED },
                    "You were able to track one down? Yes, they can be quite aggressive.",
                    { delay = 1000 },
                    { entity = "player", emote = xi.emote.SIGH },
                    { emote = xi.emote.YES },
                    "I see. Not to worry. It's probably for the best.",
                    " Here's a little something for your time.",
                },
            })
        },
        {
            check            = LQS.checks({ level = 12 }),
            [ConchataPotata] = LQS.dialog({
                quest = info.name2,
                event =
                {
                    "Do you have any plans to visit the Fumaroles again soon?",
                    " I'm in need of some crab shells for my research.",
                    { emote = xi.emote.THINK },
                    { delay = 2000 },
                    "I'll pay you for every three crab shells you bring me.",
                },
            })
        },
        {
            [ConchataPotata] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "I'll pay you for every three crab shells you bring me.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name2,
                    required = info.required,
                    reward   = info.reward[2],
                    step     = false,
                    tally    = info.tally,
                    declined =
                    {
                        "I'll pay you for every three crab shells you bring me.",
                    },
                    accepted =
                    {
                        { emote = xi.emote.BOW },
                        { fmt = "This will do nicely for my research. That makes {}.", var = info.tally },
                        " I'll take another three whenever you have them.",
                    },
                }),
            },
        },
    },
})

return m
