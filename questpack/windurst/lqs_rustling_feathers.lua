-----------------------------------
-- Rustling Feathers (Lv5)
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
-- !setvar [LQS]RUSTLING_FEATHERS 0
-- !setvar [LQS]YAGUDO_FEATHERS 0
-- Puluki-Culuki !pos -226.082 -8.198 222.513 65
-- !additem 841 4
-- Rewards: 150g
-----------------------------------
-- !setvar [LQS]RUSTLING_FEATHERS 1
-----------------------------------
local m = Module:new("lqs_rustling_feathers")

local info =
{
    name     = "Rustling Feathers",
    author   = "Loxley",
    var      = "[LQS]RUSTLING_FEATHERS",
    tally    = "[LQS]YAGUDO_FEATHERS",
    required = { { 841, 4 } }, -- Yagudo Feather x4
    reward  =
    {
        gil = 150,
    },
}

local PulukiCuluki = "Puluki-Culuki"

LQS.add(m, {
    info     = info,
    entities =
    {
        ["Port_Windurst"] =
        {
            {
                name = PulukiCuluki,
                type = xi.objType.NPC,
                look = LQS.look({
                    race = xi.race.TARU_M,
                    face = LQS.face.A5,
                    head = 19,
                    body = 19,
                    hand = 19,
                    legs = 19,
                    feet = 19,
                    main = 120,
                }),
                pos     = { -226.082, -8.198, 222.513, 36 }, -- !pos -226.082 -8.198 222.513 65
                default = { "We must push back the Yagudo for the safety of all Windurstians!" },
            },
        },
    },
    steps =
    {
        {
            check          = LQS.checks({ level = 5 }),
            [PulukiCuluki] = LQS.dialog({
                quest = info.name,
                event =
                {
                    "Our feathered foes are overstepping their bounds.",
                    " They've been coming closer and closer to our borders.",
                    { emote = xi.emote.THINK },
                    { delay = 2000 },
                    "We must push back the Yagudo for the safety of all Windurstians.",
                    " Disruptaru them and present four yagudo feathers as proof.",
                },
            })
        },
        {
            [PulukiCuluki] =
            {
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        "We must push back the Yagudo for the safety of all Windurstians.",
                        { emote = xi.emote.THINK },
                        " Disruptaru them and present four yagudo feathers as proof.",
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
                        "Now is notaru the time for foolish pranks!"
                    },
                    accepted =
                    {
                        { emote = xi.emote.SALUTE },
                        "This is progress but many more Yagudo lie at our border.",
                        { delay = 1000 },
                        { fmt = "So far you've brought me {} feathers.", var = info.tally },
                        " Keep up the excellentaru work!",
                    },
                }),
            },
        },
    },
})

return m
