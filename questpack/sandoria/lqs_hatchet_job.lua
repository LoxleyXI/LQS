-----------------------------------
-- Hatchet Job (Lv5)
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
-- !setvar [LQS]HATCHET_JOB 0
-- Aesculian !pos 364.729 -49.955 173.272 101
-- !additem 4371
-- Reward: Hatchet x36
-----------------------------------
-- !setvar [LQS]HATCHET_JOB 2
-----------------------------------
local m = Module:new("lqs_hachet_job")

local info =
{
    name     = "Hatchet Job",
    author   = "Loxley",
    var      = "[LQS]HATCHET_JOB",
    required = 4371, -- Grilled Hared
    reward   =
    {
        item = { { xi.item.HATCHET, 36 } },
    },
}

local Aesculian = "Aesculian"

LQS.add(m, {
    info     = info,
    entities = 
    {
        ["East_Ronfaure"] =
        {
            {
                name = Aesculian,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.ELVAAN_M,
                    face = LQS.face.B4,
                    head = 1,
                    body = 105,
                    hand = 1,
                    legs = 105,
                    feet = 1,
                }),
                pos     = { 364.729, -49.955, 173.272, 90 }, -- !pos 364.729 -49.955 173.272 101
                default = { "Logging is hard work but so rewarding." },
            },
        },
    },
    steps =
    {
        {
            check       = LQS.checks({ level = 5 }),
            [Aesculian] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { noturn = true },
                    { entity = Aesculian, emote = xi.emote.LOGGING },
                    { delay  = 2000 },
                    { entity = Aesculian, face  = "player" },
                    "It's a fine day for logging.",
                    " I've plenty of hatchets but unfortunately nought to eat!",
                    { delay  = 2000 },
                    "Say, could you bring me a slice of grilled hare?",
                    { entity = Aesculian, emote = xi.emote.BOW},
                    " I'll gladly share some hatchets, so you can join in the fun!",
                },
            })
        },
        {
            [Aesculian] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Please bring me a slice of grilled hare and I'll share some hatchets.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    declined =
                    {
                        { entity = Aesculian, emote = xi.emote.NO },
                        "Hmmm... Thanks for the offer but this isn't a slice of grilled hare.",
                    },
                    accepted =
                    {
                        "Wonderful. This is just what I needed!",
                        { entity = Aesculian, emote = xi.emote.BOW},
                        "Here are your hatchets as promised.",
                        " Have fun, friend!",
                    },
                }),
            }
        },
        {
            [Aesculian] = LQS.dialog({
                step  = false,
                event =
                {
                    { noturn = true },
                    { entity = Aesculian, emote = xi.emote.LOGGING },
                    "A fine day for logging!",
                },
            }),
        },
    },
})

return m
