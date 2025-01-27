-----------------------------------
-- Bug Report (Lv1)
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
-- !setvar [LQS]BUG_REPORT 0
-- !setvar [LQS]INSECT_WINGS
-- Bardus !pos 104.494 8.500 6.774 236
-- !additem 4358 12
-- Rewards: 400g
-----------------------------------
-- !setvar [LQS]BUG_REPORT 1
-----------------------------------
local m = Module:new("lqs_bug_report")

local info =
{
    name     = "Bug Report",
    author   = "Loxley",
    var      = "[LQS]BUG_REPORT",
    tally    = "[LQS]INSECT_WINGS",
    required = { { 846, 12 } },
    reward   =
    {
        gil = 400,
    },
}

local Bardus = "Bardus"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Port_Bastok"] =
        {
            {
                name   = Bardus,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.HUME_M,
                    face = LQS.face.A7,
                    head = 0,
                    body = 21,
                    hand = 20,
                    legs = 20,
                    feet = 20,
                }),
                pos     = { 104.494, 8.500, 6.774, 48 }, -- !pos 104.494 8.500 6.774 236
                default =
                {
                    { emote = xi.emote.SIGH },
                    "These bugs are getting out of hand...",
                },
            },
        },
    },
    steps =
    {
        {
            check = LQS.checks({ toggle = true }),
            [Bardus] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.NO },
                    "Adventurer, these bugs are getting out of hand...",
                    " We must get this situation under control immediately.",
                    { delay = 1000 },
                    { emote = xi.emote.FUME },
                    "Go out there, squash as many bugs as you can find.",
                    " Come back with twelve insect wings as proof.",
                },
            })
        },
        {
            [Bardus] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        { emote = xi.emote.FUME },
                        "Go out there, squash as many bugs as you can find.",
                        " Come back with twelve insect wings as proof.",
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
                        "Adventurer, there is no time for these games.",
                        " Please get back to work.",
                    },
                    {
                        { emote = xi.emote.CLAP },
                        "Great work, adventurer. Keep it up.",
                        { fmt = " That makes a grand total of {} bugs eliminated.", var = info.tally },
                    },
                }),
            },
        },
    },
})

return m
