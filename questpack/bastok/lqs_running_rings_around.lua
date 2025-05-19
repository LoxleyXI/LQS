-----------------------------------
-- Running Rings Around (Lv1)
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
-- !setvar [LQS]RUNNING_RINGS_AROUND 0
-- Verona  !pos -78.994 -4.000 -88.088 235
-- Julberg !pos -151.168 -4.819 -79.144 235
-- Reward: Bastokan Ring
-----------------------------------
-- !setvar [LQS]RUNNING_RINGS_AROUND 9
-----------------------------------
local m = Module:new("lqs_running_rings_around")

local info =
{
    name   = "Running Rings Around",
    author = "Loxley",
    var    = "[LQS]RUNNING_RINGS_AROUND",
    reward =
    {
        item  = 13497, -- Bastokan Ring (Lv1)
    },
}

local Verona  = "Verona"
local Julberg = "Julberg"

local ringReminder = LQS.dialog({
    step  = false,
    event =
    {
        { emote = xi.emote.DOUBT },
        "Oh, please do hurry up and fetch that ring.",
    },
})

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Bastok_Markets"] =
        {
            {
                name = Verona,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.HUME_F,
                    face = 13,
                    head = 0,
                    body = 101, -- Errant Houppelande
                    hand = 8,   -- RSE
                    legs = 19,  -- Tactician Magician
                    feet = 8,   -- RSE
                }),
                pos     = { -78.994, -4.000, -88.088, 90 }, -- !pos -78.994 -4.000 -88.088 235
                default = { "Um excuse me, I am quite busy!" },
            },
            {
                name = Julberg,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.HUME_M,
                    face = 9,
                    head = 15, -- Bronze Cap
                    body = 23, -- Gambison
                    hand = 3,  -- Mitts
                    legs = 3,  -- Slacks
                    feet = 8,  -- RSE
                }),
                pos     = { -151.168, -4.819, -79.144, 180 }, --!pos -151.168 -4.819 -79.144 235
                default = { "Welcome, customer. Gaze upon the finest jewelry in all of Vana'diel!" },
            }
        },
    },
    steps =
    {
        {
            [Verona] = LQS.dialog({
                quest = info.name,
                event =
                {
                    { emote = xi.emote.THINK },
                    "Carmelide's right here in Bastok simply has the most wonderful jewelry!",
                    { delay = 2000 },
                    { emote = xi.emote.POINT },
                    " ...Why, You there, Errand boy... or.. uh girl!",
                    { entity = "player", emote = xi.emote.SHOCKED },
                    { delay = 1000 },
                    "You will be a dear and fetch that latest ring for me, won't you?",
                    " Go to Julberg at Carmelide's Jewelry and collect my order.",
                    { delay = 3000 },
                    "I can't wait to try it on!",
                },
            }),
        },
        {
            [Verona]  = ringReminder,
            [Julberg] = LQS.dialog({
                event =
                {
                    { entity = Julberg, animate = 243, mode = 4 }, -- Sweating
                    "An order? For Verona? Oh no...",
                    { delay = 3000 },
                    { emote = xi.emote.YES },
                    "I mean... yes, it's right here!",
                    { say = "You take Verona's new ring." },
                },
            }),
        },
        {
            [Verona] = LQS.dialog({
                event =
                {
                    { emotion = "hands over the new ring." },
                    { emote = xi.emote.DISGUSTED },
                    "Oh, no, no, no! This ring clashes too much with my shoes!",
                    " Please go back to Carmelide's and see what else they have.",
                },
            }),
        },
        {
            [Verona]  = ringReminder,
            [Julberg] = LQS.dialog({
                event =
                {
                    { emote = xi.emote.SULK },
                    "I was worried this would happen.... again.",
                    "Very well, take her this ring instead.",
                    { say = "You take Verona's new ring." },
                },
            }),
        },
        {
            [Verona] = LQS.dialog({
                event =
                {
                    { emotion = "hands over the new ring." },
                    { emote = xi.emote.DISGUSTED },
                    "Hmmm... this ring is too shiny.",
                    " Go get a different one for me to try on.",
                },
            }),
        },
        {
            [Verona]  = ringReminder,
            [Julberg] = LQS.dialog({
                event =
                {
                    { emote = xi.emote.STAGGER },
                    "Back again? Verona is impossible to please.",
                    " One last try then... how about this one?",
                    { say = "You take Verona's new ring." },
                },
            })
        },
        {
            [Verona] = LQS.dialog({
                event =
                {
                    { emotion = "hands over the new ring." },
                    { emote = xi.emote.FUME },
                    "This... monstrosity?! Absolutely not. This ring is hideous!",
                    " Go get a different one for me to try on.",
                },
            }),
        },
        {
            [Verona]  = ringReminder,
            [Julberg] = LQS.dialog({
                event =
                {
                    { emote = xi.emote.CRY },
                    "Enough! Enough! This is an insult to this very fine establishment!",
                    " Take this nasty clunker of a ring and see how she likes THAT one!",
                    { say = "You take Verona's new ring." },
                },
            })
        },
        {
            [Verona] = LQS.dialog({
                reward = info.reward,
                event  =
                {
                    { emotion = "hands over the new ring." },
                    { emote = xi.emote.PRAISE },
                    "PERFECT!~ WONDERFUL!~",
                    " This is it! This is the one!",
                    " Oh, I look absolutely fabulous!",
                    { emote = xi.emote.THINK },
                    " I'm going to be the talk of the town!",
                    { delay = 4000 },
                    { emote = xi.emote.ANGRY },
                    "Why you! What are you still doing here?",
                    " I need not that crude, brutish specimen you brought here earlier!",
                    " Get it out of my sight!",
                    "Take this ghastly trinket at once and leave me in peace!",
                },
            }),
        },
        {
            [Verona] = LQS.dialog({
                step  = false,
                event =
                {
                    { entity = Verona1, emote = xi.emote.NO },
                    "Excuse me, can't you see I'm very busy? I am quite important after all."
                },
            }),
        },
    },
})

return m
