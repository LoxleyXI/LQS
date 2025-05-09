-----------------------------------
-- Slowing Down (Lv15)
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
-- !setvar [LQS]SLOWING_DOWN 0
-- Temimi !pos 25.682 -4.258 108.982 241
-- !additem 1981 4
-- Reward: Scroll of Slow
-----------------------------------
-- !setvar [LQS]SLOWING_DOWN 1
-----------------------------------
local m = Module:new("lqs_slowing_down")

local info =
{
    name     = "Slowing Down",
    author   = "Loxley",
    var      = "[LQS]SLOWING_DOWN",
    required = { { 1981, 4 } },
    reward   =
    {
        item = 4664, -- Scroll of Slow
    },
}

local Temimi = "Temimi"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Windurst_Woods"] =
        {
            {
                name   = Temimi,
                type   = xi.objType.NPC,
                look   = LQS.look({
                    race = xi.race.TARU_F,
                    face = LQS.face.B6,
                    head = 20, -- Circlet
                    body = 20, -- Robe
                    hand = 3,  -- Mitts
                    legs = 3,  -- Slacks
                    feet = 3,  -- Solea
                }),
                pos     = { 25.682, -4.258, 108.982, 134 }, -- !pos 25.682 -4.258 108.982 241
                default = { "How can I help you oh deary-weary?" },
            },
        },
    },
    steps =
    {
        {
            check    = LQS.checks({ level = 15 }),
            [Temimi] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "Oh deary-weary, each year passes faster than the last!",
                    " Before you know it, it's been twenty-wenty years!",
                    { emote = xi.emote.THINK },
                    "Back in my day, Sarutabaruta was quiet and peaceful.",
                    " That was until-wil... the locusts move in!",
                    { emote = xi.emote.FUME },
                    "Help get rid of these nasty pests by collecting 4 skull locusts!",
                    " Then maybe I'll have peace at last and things will settle down.",
                },
            })
        },
        {
            [Temimi] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Help get rid of these nasty pests by collecting 4 skull locusts!",
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    step     = true,
                    declined =
                    {
                        "Help get rid of these nasty pests by collecting 4 skull locusts!",
                    },
                    accepted =
                    {
                        "Oh that's so much better-wetter. It's beginning to feel just like I remember!",
                        " Take a moment every now and then-when to appreciate the silence.",
                        { emote = xi.emote.YES },
                        "That's how to make every day-way last!",
                    },
                })
            },
        },
        {
            [Temimi] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "Peace at last. Now I can take things nice and slow.",
                        { emote = xi.emote.SIGH },
                    },
                })
            },
        },
    },
})

return m
