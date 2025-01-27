-----------------------------------
-- Here be dragons (Lv40)
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
-- !setvar [LQS]HERE_BE_DRAGONS 0
-- Khartes        !pos 53.340 -15.273 9.958 248
-- Miner's Helmet !pos -228.663 -21.546 -252.635 212
-----------------------------------
local m = Module:new("lqs_here_be_dragons")

local info =
{
    name   = "Here be dragons",
    author = "Loxley",
    var    = "[LQS]HERE_BE_DRAGONS",
    reward = xi.item.DRAGON_CHRONICLES,
}

local Khartes      = "Khartes"
local MinersHelmet = "Miner's Helmet"
local OreMelter    = "Ore Melter"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Selbina"] =
        {
            {
                name    = Khartes,
                type    = xi.objType.NPC,
                look    = LQS.look({
                    race = xi.race.HUME_M,
                    face = LQS.face.B1,
                    main = 266,
                    body = 21,
                    hand = 21,
                    legs = 21,
                    feet = 21,
                }),
                pos     = { 53.340, -15.273, 9.958, 157 }, -- !pos 53.340 -15.273 9.958 248
                default = { "This town may not look like much, but it's a great place to start a big adventure!" },
            },
        },
        ["Gustav_Tunnel"] =
        {
            {
                name    = MinersHelmet,
                marker  = LQS.SIDE_QUEST,
                pos     = { -228.663, -21.546, -252.635, 227 }, -- !pos -228.663 -21.546 -252.635 212
                default = LQS.NOTHING,
            },
            {
                name    = OreMelter,
                type    = xi.objType.MOB,
                pos     = { -228.663, -21.546, -252.635, 227 }, -- !pos -228.663 -21.546 -252.635
                base    = { 205, 21 },
                level   = 35,
            },
        },
    },
    steps =
    {
        {
            check     = LQS.checks({ level = 40 }),
            [Khartes] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { delay = 500 },
                    { emote = xi.emote.SHOCKED },
                    "Oh hey! You caught me by surprise.",
                    " Have you been down to Gustav Tunnel by any chance? ",
                    { emote = xi.emote.THINK },
                    { delay = 1000 },
                    " Supposedly it's filled with valuable rocks... but the locals said there are dragons guarding it!",
                    "Could you go check it out for me?",
                },
            }),
        },
        {
            [Khartes] = LQS.dialog({
                step  = false,
                event =
                {
                    "Hey, have you checked out Gustav Tunnel yet?",
                },
            }),
            [MinersHelmet] = LQS.menu({
                title   = "Pick up the helmet?",
                spawn   = { OreMelter },
                options =
                {
                    {
                        "No way!",
                    },
                    {
                        "Let's take a closer look...",
                        true,
                    },
                },
            }),
            [OreMelter] = LQS.defeat({
                mobs    = { OreMelter },
                spawner = MinersHelmet,
            }),
        },
        {
            [MinersHelmet] = LQS.nothingElse(),
            [Khartes]      = LQS.dialog({
                reward = info.reward,
                quest  = info.name,
                event  =
                {
                    "Woah! You really fought a dragon all by yourself!?",
                    { emote = xi.emote.HUH },
                    " I think I'll stay put and get a bit more experience before I wander in there!",
                },
            }),
        },
    },
})

return m
