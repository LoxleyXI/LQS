-----------------------------------
-- Likely Tails (Lv10)
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
-- !setvar [LQS]LIKELY_TAILS 0
-- Mithra Tracks !pos 366.220 -9.068 -85.519 117
-- !additem 542
-- Reward: Cotton Cape
-----------------------------------
-- !setvar [LQS]LIKELY_TAILS 2
-----------------------------------
local m = Module:new("lqs_likely_tails")

local info =
{
    name   = "Likely Tails",
    author = "Loxley",
    var    = "[LQS]LIKELY_TAILS",
    reward =
    {
        item    = 13584,            -- Cotton Cape
        augment = { 9, 4, 516, 0 }, -- MP +5, INT +1
    },
}

local Shu    = "Shu Rhuli"
local Tracks = "Mithra Tracks"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Tahrongi_Canyon"] =
        {
            {
                name     = Tracks,
                marker   = LQS.SIDE_QUEST,
                pos      = { 366.220, -9.068, -85.519, 150 },-- !pos 366.220 -9.068 -85.519 117
                default  = LQS.NOTHING,
            },
            {
                name   = Shu,
                type   = xi.objType.NPC,
                hidden = true,
                pos    = { 366.220, -9.068, -85.519, 150 },-- !pos 366.220 -9.068 -85.519 117
                look   = LQS.look({
                    race = xi.race.MITHRA,
                    face = LQS.face.A4,
                    head = 20,
                    body = 21,
                    hand = 3,
                    legs = 21,
                    feet = 21,
                }),
            },
        },
    },
    steps =
    {
        {
            [Tracks] = LQS.dialog({
                quest = info.name,
                check = { level = 10 },
                spawn = Shu,
                event =
                {
                    "Hearrrd about wild rabbit tails? I've been told they brrrring good luck.",
                    { entity = Shu, emote = xi.emote.THINK },
                    { delay  = 2000 },
                    "I came here in searrr~ch but Buburimu Peninsula seems much too dangerous.",
                    " Brrr~ing me a wild rabbit tail and I'll rewarrr~d you.",
                },
            }),
        },
        {
            [Tracks] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    spawn = Shu,
                    event =
                    {
                        "Brrr~ing me a wild rabbit tail and I'll rewarrr~d you.",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = 542, -- Wild Rabbit Tail
                    reward   = info.reward,
                    spawn    = Shu,
                    declined = { "Brrr~ing me a wild rabbit tail and I'll rewarrr~d you." },
                    accepted =
                    {
                        { entity  =  Shu, emote = xi.emote.THINK },
                        "This is the one. Verrry well, he~rrre's your reward.",
                    },
                }),
            },
        },
        {
            [Tracks] = LQS.dialog({
                name  = "",
                step  = false,
                event =
                {
                    "Whoever was here is long gone..."
                },
            }),
        },
    },
})

return m
