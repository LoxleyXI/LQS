# Loxley Quest System (LQS)

## Overview
The Loxley Quest System (LQS) is a module for the [LandSandBoat](https://github.com/LandSandBoat/server) FFXI server emulator. It allows server operators to easily create their own custom quests and script custom events using a simple template system. The system provides an authentic experience and is actively in use by multiple prominent FFXI server projects.

If you found this module helpful, please consider kindly supporting my other work and/or starring the repository. Thank you.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/loxleygames)

## Features
* Fully scriptable dialog events with NPC animations and simulated cutscenes
* Flexible item trading system offers endless possibilities
* Mob encounters featuring spawn requirements, level caps and other restrictions
* NPC look/model utility functions allow easy creation of any appearance
* Each step can be gated by any number of requirements
* Custom quest tracker and "quest accepted/complete" sound effects
* Quests are fully reloadable and will refresh simply by saving the file
(ie. You can update NPCs or implement new quest steps without any need for a server restart!)

## Setup
* `LQS.lua` must be located inside `modules/` but does not need to be loaded by `init.txt`
* Each new area must include a reference to `LQS.lua`, for example `local LQS = require('modules/lib/LQS')`
* Initialise your area using `LQS.add()` by following the examples provided in this repository
* Ensure `lqs_util.cpp` is included in your modules and [clear the CMake cache](https://github.com/LandSandBoat/server/wiki/Module-Guide#cpp-modules) before [rebuilding the C++](https://github.com/LandSandBoat/server/wiki/Quick-Start-Guide)

## Simple Example

## Steps Functions
### LQS.dialog
### LQS.trade
### LQS.menu
### LQS.shop
### LQS.defeat

## History
This system has been developed over a couple of years by myself and now supports over 130+ live custom quests and content systems.

* The [first version](https://www.bg-wiki.com/ffxi/CatsEyeXI_Systems/Quests) was initially developed by me for [Crystal Warrior](https://www.catseyexi.com/cw) on [CatsEyeXI](https://www.catseyexi.com/) in 2023
* This __definitive version__ was developed by me in 2025 to give the system a permanent home and make it more accessible to the community

## Final Note
If you found this module useful for your server, please provide a link back to it!

~ Loxley ~
