-----------------------------------
-- Ring Around the Roses (Lv1)
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
-- !setvar [LQS]RING_AROUND_THE_ROSES 0
-- Aeolia      !pos 159.217 -0.950 17.122 230
-- Flower Bed  !pos -13.677 0.000 43.668 231
-- Aeolia      !pos 159.217 -0.950 17.122 230
-- Reward: San d'Orian Ring
-----------------------------------
-- !setvar [LQS]RING_AROUND_THE_ROSES 3
-----------------------------------
local m = Module:new("lqs_ring_around_the_roses")

local info =
{
    name   = "Ring Around the Roses",
    author = "Loxley",
    var    = "[LQS]RING_AROUND_THE_ROSES",
    reward =
    {
        item = 13495, -- San d'Orian Ring (Lv1)
    },
}

local Aeolia    = "Aeolia"
local FlowerBed = "Flower Bed"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Southern_San_dOria"] =
        {
            {
                name = Aeolia,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.ELVAAN_F,
                    face = 6,
                    head = 0,
                    body = 18, -- Velvet Robe
                    hand = 3,  -- Mitts
                    legs = 24, -- Battle Hose
                    feet = 18, -- Ebony Sabots
                }),
                pos     = { 159.217, -0.950, 17.122, 214 }, -- !pos 159.217 -0.950 17.122 230
                default =
                {
                    { emote = xi.emote.SHOCKED },
                    "Achoo!!",
                },
            },
        },
        ["Northern_San_dOria"] =
        {
            {
                name    = FlowerBed,
                marker  = LQS.SIDE_QUEST,
                pos     = { -10.962, 0.000, 44.073, 0 }, --!pos -13.677, 0.000, 43.668 231
                default = LQS.NOTHING,
            },
        },
    },
    steps =
    {
        {
            [Aeolia] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.SHOCKED },
                    "Achoo!!! I mean, you! I mean sorry.",
                    " Can you help me? I...",
                    { delay = 1000 },

                    { emote = xi.emote.SHOCKED },
                    " Achoo!!",
                    { delay = 1000 },

                    "Dropped my ring in the flower beds... *sniff*",
                    " At the fountain in Northern San d'Oria but the flowers they-",
                    { delay = 1000 },

                    { emote = xi.emote.SHOCKED },
                    " Achoo!!",
                    { delay = 1000 },

                    "Thank you. I would be in your debt.",
                },
            }),
        },
        {
            [Aeolia] = LQS.dialog({
                step  = false,
                event =
                {
                    { delay = 1000 },
                    { emote = xi.emote.SHOCKED },
                    "Achoo!!",
                },
            }),
            [FlowerBed] = LQS.dialog({
                event =
                {
                    { animation = 48, target = "player", duration = 3000 }, -- Crouch down
                    { emotion   = "rummages through the Flower Bed and finds Aeolia's ring." },
                },
            }),
        },
        {
            [FlowerBed] = LQS.nothingElse(),
            [Aeolia]    = LQS.dialog({
                reward = info.reward,
                event  =
                {
                    "Thank you for bringing this to me but...",
                    { delay = 1000 },

                    { emote = xi.emote.SHOCKED },
                    " Achoo!!",

                    { delay = 1000 },
                    "Maybe you better keep this... *sniff* instead of me.",
                },
            }),
        },
        {
            [Aeolia] = LQS.dialog({
                step  = false,
                event =
                {
                    "Thanks anyway. *sniff*",
                },
            }),
        },
    },
})

return m
