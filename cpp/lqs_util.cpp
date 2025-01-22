/************************************************************************
* Loxley Quest System Utilities
*************************************************************************
* Copyright (c) 2025 LoxleyXI
*
* https://github.com/LoxleyXI/LQS
*************************************************************************
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see http://www.gnu.org/licenses/
************************************************************************/
#include "map/utils/moduleutils.h"

#include "common/sql.h"
#include "common/lua.h"
#include "map/utils/charutils.h"
#include "map/utils/itemutils.h"

#include "map/lua/lua_baseentity.h"
#include "map/packets/char_emotion.h"
#include "map/packets/independent_animation.h"
#include "map/packets/entity_animation.h"
#include "map/packets/chat_message.h"

class CNpcEmotionPacket : public CBasicPacket
{
public:
    CNpcEmotionPacket(CBaseEntity* PBaseEntity, uint32 TargetID, uint16 TargetIndex, Emote EmoteID, EmoteMode emoteMode, uint16 extra);
};

CNpcEmotionPacket::CNpcEmotionPacket(CBaseEntity* PBaseEntity, uint32 TargetID, uint16 TargetIndex, Emote EmoteID, EmoteMode emoteMode, uint16 extra)
{
    this->setType(0x5A);
    this->setSize(0x70);

    ref<uint32>(0x04) = PBaseEntity->id;
    ref<uint32>(0x08) = TargetID;
    ref<uint16>(0x0C) = PBaseEntity->targid;
    ref<uint16>(0x0E) = TargetIndex;
    ref<uint8>(0x10)  = static_cast<uint8>(EmoteID);
    ref<uint8>(0x16)  = static_cast<uint8>(emoteMode);
}

class LqsUtilModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        lua["CBaseEntity"]["fmt"] = [this](CLuaBaseEntity* PLuaBaseEntity, std::string const& message, sol::variadic_args va) -> void
        {
            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();

            if (PEntity->objtype != TYPE_PC)
            {
                return;
            }

            CCharEntity* PChar = (CCharEntity*)PEntity;
            PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_NS_SAY, lua_fmt(message, va).c_str(), ""));
        };

        lua["CBaseEntity"]["sys"] = [this](CLuaBaseEntity* PLuaBaseEntity, std::string const& message, sol::variadic_args va) -> void
        {
            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();

            if (PEntity->objtype != TYPE_PC)
            {
                return;
            }

            CCharEntity* PChar = (CCharEntity*)PEntity;
            PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, lua_fmt(message, va).c_str(), ""));
        };

        lua["CBaseEntity"]["canObtainItem"] = [this](CLuaBaseEntity* PLuaBaseEntity, uint16 itemID) -> bool
        {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();

            if (PEntity->objtype != TYPE_PC)
            {
                return false;
            }

            auto* const PChar = dynamic_cast<CCharEntity*>(PEntity);

            if (PChar->getStorage(LOC_INVENTORY)->GetFreeSlotsCount() == 0)
            {
                return false;
            }

            CItem* PItem = itemutils::GetItem(itemID);

            if (PItem == nullptr)
            {
                return false;
            }

            // Cannot obtain if item is RARE and player already has item
            return !((PItem->getFlag() & ITEM_FLAG_RARE) && charutils::HasItem(PChar, itemID));
        };

        /************************************************************************
        * Custom Events
        *************************************************************************/
        lua["CBaseEntity"]["ceFace"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* player) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PPlayer = player->GetBaseEntity();

            auto* const PChar       = dynamic_cast<CCharEntity*>(PPlayer);
            auto rot                = PEntity->loc.p.rotation;
            auto status             = PEntity->status;

            PEntity->loc.p.rotation = worldAngle(PEntity->loc.p, PChar->loc.p);
            PEntity->status = STATUS_TYPE::NORMAL;

            PChar->updateEntityPacket(PEntity, ENTITY_UPDATE, UPDATE_POS);

            PEntity->loc.p.rotation = rot;
            PEntity->status         = status;
        };

        lua["CBaseEntity"]["ceFaceNpc"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* player, CLuaBaseEntity* npc) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PPlayer = player->GetBaseEntity();
            CBaseEntity* PNpc    = npc->GetBaseEntity();

            auto* const PChar       = dynamic_cast<CCharEntity*>(PPlayer);
            auto        rot         = PEntity->loc.p.rotation;
            auto        status      = PEntity->status;

            PEntity->loc.p.rotation = worldAngle(PEntity->loc.p, PNpc->loc.p);
            PEntity->status         = STATUS_TYPE::NORMAL;

            PChar->updateEntityPacket(PEntity, ENTITY_UPDATE, UPDATE_POS);

            PEntity->loc.p.rotation = rot;
            PEntity->status         = status;
        };

        lua["CBaseEntity"]["ceTurn"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* player, uint8 rot) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PPlayer = player->GetBaseEntity();

            auto* const PChar   = dynamic_cast<CCharEntity*>(PPlayer);
            auto        current = PEntity->loc.p.rotation;
            auto        status  = PEntity->status;

            PEntity->loc.p.rotation = rot;
            PEntity->status         = STATUS_TYPE::NORMAL;

            PChar->updateEntityPacket(PEntity, ENTITY_UPDATE, UPDATE_POS);

            PEntity->loc.p.rotation = current;
            PEntity->status         = status;
        };

        lua["CBaseEntity"]["ceReset"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* target) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PTarget = target->GetBaseEntity();

            auto* const PChar = dynamic_cast<CCharEntity*>(PTarget);
            PChar->updateEntityPacket(PEntity, ENTITY_UPDATE, UPDATE_POS);
        };

        lua["CBaseEntity"]["ceEmote"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* player, uint8 emID, uint8 emMode) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PTarget = player->GetBaseEntity();

            auto* const PChar    = dynamic_cast<CCharEntity*>(PTarget);
            const auto emoteID   = static_cast<Emote>(emID);
            const auto emoteMode = static_cast<EmoteMode>(emMode);

            PChar->pushPacket(new CNpcEmotionPacket(PEntity, PTarget->id, PTarget->targid, emoteID, emoteMode, 0));
        };

        lua["CBaseEntity"]["ceAnimate"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* player, CLuaBaseEntity* target, uint16 animID, uint8 mode) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PPlayer = player->GetBaseEntity();
            CBaseEntity* PTarget = target->GetBaseEntity();

            auto* const PChar = dynamic_cast<CCharEntity*>(PPlayer);

            PChar->pushPacket(new CIndependentAnimationPacket(PEntity, PTarget, animID, mode));
        };

        lua["CBaseEntity"]["ceAnimationPacket"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* player, const char* command, CLuaBaseEntity* target) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PPlayer = player->GetBaseEntity();
            auto* const  PChar   = dynamic_cast<CCharEntity*>(PPlayer);

            // TODO: Passing without target doesn't work
            if (target == nullptr)
            {
                // If no target PEntity defaults to itself
                PChar->pushPacket(new CEntityAnimationPacket(PEntity, PEntity, command));
            }
            else
            {
                CBaseEntity* PTarget = target->GetBaseEntity();
                if (PTarget != nullptr)
                {
                    // If we have a target then set PTarget to that
                    PChar->pushPacket(new CEntityAnimationPacket(PEntity, PTarget, command));
                }
            }
        };

        lua["CBaseEntity"]["ceSpawn"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* target) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PTarget = target->GetBaseEntity();

            auto* const PChar = dynamic_cast<CCharEntity*>(PTarget);
            auto        status = PEntity->status;
            PEntity->status = STATUS_TYPE::NORMAL;
            PChar->updateEntityPacket(PEntity, ENTITY_SPAWN, UPDATE_ALL_MOB);
            PEntity->status = status;
        };

        lua["CBaseEntity"]["ceDespawn"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* target) -> void {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            CBaseEntity* PTarget = target->GetBaseEntity();

            auto* const PChar = dynamic_cast<CCharEntity*>(PTarget);
            auto        status = PEntity->status;
            PEntity->status    = STATUS_TYPE::DISAPPEAR;
            PChar->updateEntityPacket(PEntity, ENTITY_DESPAWN, UPDATE_DESPAWN);
            PEntity->status = status;
        };

        lua["CBaseEntity"]["setLookString"] = [](CLuaBaseEntity* PLuaBaseEntity, const std::string lookString) -> void {
            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();
            PEntity->look = stringToLook(lookString);

            // TODO: Add missing packet update
            // ------------------------------------------------
            // PEntity->updatemask |= UPDATE_LOOK;
            // PEntity->loc.zone->UpdateEntityPacket(PEntity, ENTITY_UPDATE, UPDATE_LOOK);
        };
    }
};

REGISTER_CPP_MODULE(LqsUtilModule);
