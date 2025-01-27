-----------------------------------
-- Only the Dose (Lv1)
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
-- !setvar [LQS]ONLY_THE_DOSE 0
-- !setvar [LQS]GIANT_STINGERS 0
-- Perah Celehsi !pos 66.709 -4.250 38.347 241
-- !additem 925
-- Rewards: 300g
-----------------------------------
-- !setvar [LQS]ONLY_THE_DOSE 1
-----------------------------------
local m = Module:new("lqs_only_the_dose")

local info =
{
    name     = "Only the Dose",
    author   = "Loxley",
    var      = "[LQS]ONLY_THE_DOSE",
    tally    = "[LQS]GIANT_STINGERS",
    required = 925, -- Giant Stinger
    reward   =
    {
        gil = 300,
    },
}

local PerahCelehsi = "Perah Celehsi"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Windurst_Woods"] =
        {
            {
                name = PerahCelehsi,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.MITHRA,
                    face = LQS.face.B2,
                    head = 1,
                    body = 17,
                    hand = 15,
                    legs = 1,
                    feet = 15,
                    main = 120,
                    offh = 120,
                }),
                pos     = { 69.424, -4.250, 35.333, 170 }, -- !pos 69.424 -4.250 35.333 241
                default = { "I'm sho~rrrt on supplies..." },
            },
        },
    },
    steps =
    {
        {
            [PerahCelehsi] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.THINK },
                    "I make verrr~y special medicine but... I'm sho~rrrt on supplies.",
                    " Collect giant stingerrrs and I'll pay 300 gil a piece."
                },
            })
        },
        {
            [PerahCelehsi] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Collect giant stingerrrs and I'll pay 300 gil a piece."
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
                        { emote = xi.emote.PANIC },
                        "What's this? I need very pa~rrrticular materials for my worrrrk."
                    },
                    accepted =
                    {
                        { emote = xi.emote.YES },
                        { fmt = "Yes, this is what I need. That makes %u giant stingerrrs.", var = info.tally },
                        " Brrrring more and I'll pay.",
                    },
                }),
            },
        },
    },
})

return m
