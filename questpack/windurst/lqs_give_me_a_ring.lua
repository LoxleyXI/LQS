-----------------------------------
-- Give Me a Ring (Lv1)
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
-- !setvar [LQS]GIVE_ME_A_RING 0
-- Moyeyo       !pos 131.679 -5.000 -98.182 241
-- Dim Sparkle  !pos 34.598 0.000 245.517 239
-- Moyeyo       !pos 131.679 -5.000 -98.182 241
-- Abu Dabudabu !pos 10.471 -2.500 -15.412 241
-- Reward: Windurstian Ring
-----------------------------------
-- !setvar [LQS]GIVE_ME_A_RING 4
-----------------------------------
local m = Module:new("lqs_give_me_a_ring")

local info =
{
    name   = "Give Me a Ring",
    author = "Loxley",
    var    = "[LQS]GIVE_ME_A_RING",
    reward =
    {
        item = 13496, -- Windurstian Ring
    },
}

local Moyeyo     = "Moyeyo"
local Abu        = "Abu Dabudabu"
local DimSparkle = "Dim Sparkle"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Windurst_Woods"] =
        {
            {
                name = Moyeyo,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.TARU_F,
                    face = 7,
                    body = 103, -- Chocobo Jackcoat
                    hand = 8,   -- RSE
                    legs = 3,   -- Slacks
                    feet = 8,   -- RSE
                }),
                pos     = { 131.679, -5.000, -98.182, 90 }, -- !pos 131.679 -5.000 -98.182 241
                default =
                {
                    { emote = xi.emote.SIGH },
                    "Oh no, this just won't do!",
                },
            },
            {
                name = Abu,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.TARU_M,
                    face = 1,
                    body = 3,  -- Tunic
                    hand = 8,  -- RSE
                    legs = 11, -- White Slacks
                    feet = 8,  -- RSE
                }),
                pos     = { 10.471, -2.500, -15.412, 170 }, -- !pos 10.471 -2.500 -15.412 241
                default =
                {
                    "Excuse me. Sorry, I don't have anything for you.",
                },
            },
        },
        ["Windurst_Walls"] =
        {
            {
                name   = DimSparkle,
                marker = LQS.SIDE_QUEST,
                pos    = { 34.598, 0.000, 245.517, 0 }, --!pos 34.598 0.000 245.517 239
                dialog = LQS.NOTHING,
            },
        },
    },
    steps =
    {
        {
            [Moyeyo] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.FUME },
                    "Oh no, this just won't do! I've lost my ring!!~",
                    { delay = 2000 },
                    { emote = xi.emote.HUH },
                    "Are you by any chance heading to Windurst Walls?",
                    " I was travelling to meet someone and I was so distracted...",
                    { delay = 1000 },
                    { emote = xi.emote.BLUSH },
                    " The ring slipped from my hands and was swept away downstream!",
                    "Maybe it washed up somewhere. Please let me know if you find my ring!",
                },
            }),
        },
        {
            [Moyeyo] = LQS.dialog({
                step  = false,
                event =
                {
                    "Did you find my ring?",
                },
            }),
            [DimSparkle] = LQS.dialog({
                event =
                {
                    { animation = 48, target = "player", duration = 3000 }, -- Crouch down
                    { emotion = "digs in the dirt and finds Moyeyo's ring!" },
                },
            }),
        },
        {
            [DimSparkle] = LQS.nothingElse(),
            [Moyeyo]     = LQS.dialog({
                event =
                {
                    { emote = xi.emote.SURPRISED },
                    "This is the one... I can't believe you found it!",
                    { delay = 3000 },
                    "Well you see, actually this isn't for me.",
                    " It was a gift for my love to be.",
                    { emote = xi.emote.BLUSH },
                    " I couldn't possibly... but I...",
                    { delay = 2000 },
                    { emote = xi.emote.THINK },
                    "I would be ever so grateful if you delivered it on my behalf.",
                    " Please take the ring to Abu Dabudabu. He's usually around the Manustery.",
                }
            }),
        },
        {
            [Moyeyo] = LQS.dialog({
                step  = false,
                event =
                {
                    "Please take the ring to Abu Dabudabu. He's usually around the Manustery.",
                    { emote = xi.emote.BLUSH },
                },
            }),
            [Abu] = LQS.dialog({
                reward = info.reward,
                event  =
                {
                    { emote = xi.emote.HUH },
                    "For me? Surely you're mistaken.",
                    { delay = 2000 },
                    { emote = xi.emote.THINK },
                    " A gift? From Meyoyo? I see. Thank you for bringing this to me...",
                    { delay = 3000 },
                    "Hmm... I should wear Meyoyo's new gift.",
                    { emote = xi.emote.YES },
                    " And I guess I won't be needing this old trinket anymore.",
                    "Please take it for your trouble.",
                },
            }),
        },
        {
            [Moyeyo] = LQS.dialog({
                step  = false,
                event =
                {
                    "Thank you for helping me.",
                },
            }),
            [Abu] = LQS.dialog({
                step  = false,
                event =
                {
                    "Thank you. I can't wait to tell Meyoyo how I really feel!",
                },
            })
        },
    },
})

return m
