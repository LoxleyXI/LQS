-----------------------------------
-- func: !quest
-- desc: List custom quest info
-----------------------------------
local commandObj = {}

commandObj.cmdprops =
{
    permission = 0,
    parameters = 's'
}

-----------------------------------
-- Retrieve item names
-----------------------------------
local vowel = set{ "a","e","i","o","u" }

local function getItemName(itemID)
    local result  = "unknown"
    local itemObj = GetItemByID(itemID)

    if itemObj == nil then
        print(fmt("[LQS] Unknown item {}: {}", itemID, itemObj))
        return result
    end

    result = string.gsub(itemObj:getName(), "_", " ")

    if vowel[string.sub(result, 1, 1)] then
        return "An " .. result
    else
        return "A " .. result
    end
end

local function error(player, msg)
    player:printToPlayer(msg)
    player:printToPlayer('!quest <name>')
end

commandObj.onTrigger = function(player, str)
    if str ~= nil then
        local questInfo = LQS.registry[string.lower(str)]

        if questInfo == nil then
            player:fmt("Quest not found.")
            return
        end

        local status = player:getCharVar(questInfo.var) + 1

        player:fmt("=== Quest info ===")
        player:fmt("{} (Author: {})", questInfo.name, questInfo.author)

        if questInfo.reward ~= nil then
            player:fmt("Reward: {} ", getItemName(questInfo.reward))
        end

        local stepInfo = fmt("Current step: {}/{}", status, questInfo.finish)

        if status < questInfo.finish then
            stepInfo = fmt("{} ({})", stepInfo, questInfo.hint[status])
        else
            stepInfo = fmt("{} (Completed)", stepInfo)
        end

        player:fmt("{}", stepInfo)

        return
    end

    local accepted  = {}
    local completed = {}

    for questName, questInfo in pairs(LQS.registry) do
        local status = player:getCharVar(questInfo.var) + 1

        if status > 0 then
            if status >= questInfo.finish then
                table.insert(completed, fmt("\129\159 {} ({}/{})", questInfo.name, status, questInfo.finish))
            else
                table.insert(accepted,  fmt("\129\158 {} ({}/{})", questInfo.name, status, questInfo.finish))
            end
        end
    end

    if #accepted > 0 then
        player:fmt("=== Quests accepted ===")

        for _, row in pairs(accepted) do
            player:fmt(row)
        end
    end

    if #completed > 0 then
        player:fmt("=== Quests completed ===")

        for _, row in pairs(completed) do
            player:fmt(row)
        end
    end
end

return commandObj
