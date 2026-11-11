local addonName, KKK = ...

-- WoW Forever (16001 / modern client) compatibility shims.
-- The old item/coin globals were removed in 12.1.5; use the namespaced APIs.
local GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
local GetCoinTextureString = (C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString) or GetCoinTextureString

-- The old global GetCoinTextureString was removed in Forever's client. Our own
-- code uses the local above, but WeakAura custom-text snippets (and other
-- addons) call the global, so restore it for compatibility.
if not _G.GetCoinTextureString then
    if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
        _G.GetCoinTextureString = function(copper)
            return C_CurrencyInfo.GetCoinTextureString(copper or 0)
        end
    else
        _G.GetCoinTextureString = function(copper)
            copper = math.floor(tonumber(copper) or 0)
            local gold = math.floor(copper / 10000)
            local silver = math.floor((copper % 10000) / 100)
            local cop = copper % 100
            return string.format("%dg %ds %dc", gold, silver, cop)
        end
    end
end

local isSecret = function(v)
    return (issecretvalue and issecretvalue(v)) or false
end
local canAccess = function(v)
    return (canaccessvalue and canaccessvalue(v)) or true
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UNIT_DIED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("LOOT_OPENED")
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local pendingKillQueue = {}
local processedGUIDs = {}
local processedItemGUIDs = {}
local lastTargetCache = nil -- { npcID, name, race, time }
local lastPlayerXP = nil

local function SafeUnitXP()
    if not UnitXP then return nil end
    local ok, xp = pcall(UnitXP, "player")
    if not ok or isSecret(xp) or not canAccess(xp) or type(xp) ~= "number" then return nil end
    return xp
end

local function MakeXPPattern()
    local tmpl = _G["COMBATLOG_XPGAIN_FIRSTPERSON"]
    if not tmpl or tmpl == "" then
        tmpl = "%s dies, you gain %d experience."
    end
    if type(tmpl) ~= "string" then return nil end
    local ok, pat = pcall(function()
        return tmpl:gsub("%%s", ".-"):gsub("%%d", "(%%d+)")
    end)
    if not ok or not pat or pat == "" then return nil end
    return pat
end
local xpKillPattern = MakeXPPattern()

-- Parse a GUID of the form "Creature-0-...-npcID-spawnID" (spawn/server fields
-- are obfuscated in Forever but the format is otherwise unchanged).
local function ParseGUID(guid)
    if not guid or isSecret(guid) or type(guid) ~= "string" then return nil end
    local unitType, _, _, _, _, npcID = strsplit("-", guid)
    if (unitType == "Creature" or unitType == "Vehicle") and npcID then
        return unitType, tostring(npcID)
    end
    return nil
end

local function UnitNpcId(unit)
    if not UnitExists or not UnitExists(unit) then return nil end
    local ok, guid = pcall(UnitGUID, unit)
    if not ok or not guid then return nil end
    if isSecret(guid) then return nil end
    local _, npcID = ParseGUID(guid)
    return npcID
end

local function SafeUnitName(unit)
    local ok, name = pcall(UnitName, unit)
    if not ok or not name then return nil end
    if isSecret(name) then return nil end
    if type(name) ~= "string" or name == "" then return nil end
    return name
end

local function SafeUnitCreatureType(unit)
    local ok, race = pcall(UnitCreatureType, unit)
    if not ok or not race then return nil end
    if isSecret(race) then return nil end
    if type(race) ~= "string" or race == "" then return nil end
    return race
end

local function TargetIsDead(unit)
    if not UnitIsDead then return false end
    local ok, dead = pcall(UnitIsDead, unit)
    if not ok or isSecret(dead) or not canAccess(dead) then return false end
    return dead and true or false
end

local function CacheTarget()
    if not UnitExists or not UnitExists("target") then return end
    local npcID = UnitNpcId("target")
    if not npcID then return end
    local guid
    local ok, g = pcall(UnitGUID, "target")
    if ok and g and not isSecret(g) then guid = g end
    lastTargetCache = {
        npcID = npcID,
        guid = guid,
        name = SafeUnitName("target") or "Unknown NPC",
        race = SafeUnitCreatureType("target") or "Unspecified",
        wasAlive = not TargetIsDead("target"),
        time = GetTime(),
    }
end

local function RecordKill(npcID, name, race)
    if not npcID or not MyKillCountTable then return end
    npcID = tostring(npcID)
    if not MyKillCountTable[npcID] then
        MyKillCountTable[npcID] = {count = 0, looted = 0, name = name or "Unknown NPC", race = race or "Unspecified", xp = 0, avgLootValue = 0, items = {}}
    end
    local entry = MyKillCountTable[npcID]
    entry.items = entry.items or {}
    entry.count = (entry.count or 0) + 1
    entry.looted = entry.looted or 0
    if name and name ~= "" then entry.name = name end
    if race and race ~= "Unspecified" then entry.race = race end
    if not entry.avgLootValue then entry.avgLootValue = 0 end
    table.insert(pendingKillQueue, { id = npcID, time = GetTime() })
    if #pendingKillQueue > 10 then table.remove(pendingKillQueue, 1) end
end

local function ResolveLootNpcID(guid)
    if guid and not isSecret(guid) and type(guid) == "string" then
        local _, npcID = ParseGUID(guid)
        if npcID then
            return npcID, guid
        end
    end
    if UnitIsDead and UnitIsDead("target") and lastTargetCache then
        if (GetTime() - (lastTargetCache.time or 0)) < 60 then
            return lastTargetCache.npcID, ("target:" .. lastTargetCache.npcID)
        end
    end
    local npcID = UnitNpcId("target")
    if npcID then
        return npcID, ("target:" .. npcID)
    end
    return nil
end

local function UpdateLootValue()
    local numItems = GetNumLootItems()
    local lootData = {} -- lootKey -> { npcID, totalMoney = 0, items = {}, complete = true }

    local function GetLootKey(i)
        local guid
        if GetLootSourceInfo then
            local ok, g = pcall(GetLootSourceInfo, i)
            if ok then guid = g end
        end
        local npcID, key = ResolveLootNpcID(guid)
        return npcID, key
    end

    if numItems == 0 then
        -- Even if empty, we want to count the loot event for the current target
        if UnitIsDead and UnitIsDead("target") then
            local npcID, key = ResolveLootNpcID(nil)
            if npcID and key then
                lootData[key] = { npcID = npcID, totalMoney = 0, items = {}, complete = true }
            end
        end
    else
        for i = 1, numItems do
            local npcID, key = GetLootKey(i)
            if npcID and key and (not processedGUIDs[key] or not processedItemGUIDs[key]) then
                if not lootData[key] then
                    lootData[key] = { npcID = npcID, totalMoney = 0, items = {}, complete = true }
                end

                local slotType = GetLootSlotType(i)
                if slotType == 1 then -- Item
                    local itemLink = GetLootSlotLink(i)
                    if itemLink then
                        local itemName, _, _, _, _, _, _, _, _, _, price = GetItemInfo(itemLink)

                        if itemName then
                            local _, _, quantity = GetLootSlotInfo(i)
                            quantity = quantity or 1

                            local itemID = itemLink:match("item:(%d+)")
                            table.insert(lootData[key].items, itemID or itemName)

                            if price then
                                lootData[key].totalMoney = lootData[key].totalMoney + (price * quantity)
                            else
                                lootData[key].complete = false
                            end
                        else
                            lootData[key].complete = false
                        end
                    else
                        lootData[key].complete = false
                    end
                elseif slotType == 2 then -- Money
                    local _, _, quantity = GetLootSlotInfo(i)
                    lootData[key].totalMoney = lootData[key].totalMoney + (quantity or 0)
                end
            end
        end
    end

    for key, data in pairs(lootData) do
        local npcID = data.npcID
        if npcID then
            local entry = MyKillCountTable[npcID]
            if not entry then
                -- Loot proves a kill even when the death event was secret / off-target.
                if lastTargetCache and lastTargetCache.npcID == npcID then
                    entry = {count = 0, looted = 0, name = lastTargetCache.name, race = lastTargetCache.race, xp = 0, avgLootValue = 0, items = {}}
                    MyKillCountTable[npcID] = entry
                end
            end
            if entry then
                entry.items = entry.items or {}

                if not processedItemGUIDs[key] then
                    processedItemGUIDs[key] = true
                    entry.looted = (entry.looted or 0) + 1

                    local uniqueItems = {}
                    for _, itemID in ipairs(data.items) do
                        uniqueItems[itemID] = true
                    end

                    for itemID, _ in pairs(uniqueItems) do
                        entry.items[itemID] = (entry.items[itemID] or 0) + 1
                    end
                end

                if data.complete and not processedGUIDs[key] then
                    processedGUIDs[key] = true
                    entry.totalVendorValue = (entry.totalVendorValue or 0) + data.totalMoney
                    if entry.looted and entry.looted > 0 then
                        entry.avgLootValue = entry.totalVendorValue / entry.looted
                    end
                end
            end
        end
    end
end

-- Dynamic Auction Value Calculation
function GetDynamicAuctionValue(npcID)
    local data = MyKillCountTable and MyKillCountTable[npcID]
    if not data or not data.items or not data.looted or data.looted == 0 then return 0 end

    local totalValue = 0
    for itemID, dropCount in pairs(data.items) do
        local _, _, itemQuality = GetItemInfo(itemID)
        if itemQuality and itemQuality > 0 then
            local ahPrice = 0
            if Auctionator and Auctionator.API and Auctionator.API.v1 then
                local numericID = tonumber(itemID)
                local ok, price
                if numericID then
                    ok, price = pcall(Auctionator.API.v1.GetAuctionPriceByItemID, "KwaKillCounter", numericID)
                end
                if (not ok or not price) and numericID then
                    local _, link = GetItemInfo(numericID)
                    if link then
                        ok, price = pcall(Auctionator.API.v1.GetAuctionPriceByItemLink, "KwaKillCounter", link)
                    end
                end
                if ok and price then ahPrice = price end
            end

            if itemQuality == 1 and ahPrice > 100000 then
                ahPrice = 0
            end

            totalValue = totalValue + (ahPrice * dropCount)
        end
    end

    return totalValue / data.looted
end

KKK.GetDynamicAuctionValue = GetDynamicAuctionValue

-- Full reset: wipes kills, loot, XP, values and all in-memory caches.
function KKK.FullReset()
    MyKillCountTable = {}
    pendingKillQueue = {}
    processedGUIDs = {}
    processedItemGUIDs = {}
    lastTargetCache = nil
    lastPlayerXP = SafeUnitXP()
end

local function MigrateData()
    if not MyKillCountTable then return end

    for id, data in pairs(MyKillCountTable) do
        if type(data) == "table" then
            if data.items and data.items[1] then
                local newItems = {}
                for _, item in ipairs(data.items) do
                    if item then newItems[tostring(item)] = (newItems[tostring(item)] or 0) + 1 end
                end
                if next(newItems) then data.items = newItems else data.items = {} end
            end

            data.items = data.items or {}
            data.avgLootValue = data.avgLootValue or 0
            data.totalVendorValue = data.totalVendorValue or ((data.avgLootValue or 0) * (data.looted or 0))
            data.xp = data.xp or 0
            data.looted = data.looted or 0
        end
    end
end

local function TryRecordSecretDeath(cache)
    -- Only the cache that was active when UNIT_DIED fired is eligible.
    if not cache or lastTargetCache ~= cache then return end
    if TargetIsDead("target") then
        RecordKill(cache.npcID, cache.name, cache.race)
        lastTargetCache = nil
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddonName = ...
        if loadedAddonName == addonName then
            MyKillCountTable = MyKillCountTable or {}
            MigrateData()
            lastPlayerXP = SafeUnitXP()
            CacheTarget()
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        processedGUIDs = {}
        processedItemGUIDs = {}
        lastPlayerXP = SafeUnitXP()
        CacheTarget()

    elseif event == "PLAYER_TARGET_CHANGED" then
        CacheTarget()

    elseif event == "UNIT_DIED" then
        local guid = ...
        if not lastTargetCache then return end
        local cache = lastTargetCache
        local unitType, npcID = ParseGUID(guid)
        if unitType and npcID then
            -- GUID visible: require it to be the cached target.
            if cache.npcID ~= npcID then return end
            if cache.guid and type(guid) == "string" and not isSecret(guid) then
                if guid ~= cache.guid then return end
            elseif not TargetIsDead("target") then
                return
            end
            RecordKill(cache.npcID, cache.name, cache.race)
            lastTargetCache = nil
        else
            -- GUID is secret (normal in Forever). Attribute the death only when
            -- our cached target is actually dead now and was alive when cached.
            -- Merely clicking/targeting an NPC can never trigger this, because
            -- no UNIT_DIED event happens. No timestamp window: long fights count.
            if not cache.wasAlive then return end
            TryRecordSecretDeath(cache)
            -- Death state can lag the event by a frame; retry once shortly after.
            if C_Timer and C_Timer.After then
                C_Timer.After(0.2, function() TryRecordSecretDeath(cache) end)
            end
        end

    elseif event == "CHAT_MSG_COMBAT_XP_GAIN" then
        local message = ...
        if message and canAccess(message) and xpKillPattern then
            local xpString = message:match(xpKillPattern)

            if xpString then
                local xp = tonumber(xpString)
                local now = GetTime()

                for i, data in ipairs(pendingKillQueue) do
                    if (now - data.time) < 2.0 then
                        local npcID = data.id
                        if MyKillCountTable[npcID] then
                            MyKillCountTable[npcID].xp = xp
                        end
                        table.remove(pendingKillQueue, i)
                        break
                    end
                end
            end
        end

    elseif event == "PLAYER_XP_UPDATE" then
        -- Fallback for clients where the XP chat message is secret/absent:
        -- credit a recent kill with the XP delta.
        local xp = SafeUnitXP()
        if xp and lastPlayerXP and xp > lastPlayerXP then
            local delta = xp - lastPlayerXP
            local now = GetTime()
            for i = #pendingKillQueue, 1, -1 do
                local kill = pendingKillQueue[i]
                if (now - kill.time) <= 2.0 then
                    local entry = MyKillCountTable and MyKillCountTable[kill.id]
                    if entry and (entry.xp or 0) == 0 then
                        entry.xp = delta
                    end
                    table.remove(pendingKillQueue, i)
                    break
                end
            end
        end
        if xp then lastPlayerXP = xp end

    elseif event == "LOOT_OPENED" or event == "LOOT_READY" then
        UpdateLootValue()
    end
end)

-- Tooltip Integration (shift-hover drop sources)
-- Forever (12.x) tooltips are built via TooltipDataProcessor; OnTooltipSetItem
-- lines get wiped. Auctionator hooks AddTooltipPostCall instead -- same here.
local function AddDropLines(tooltip, link)
    if not link or isSecret(link) or type(link) ~= "string" then return end
    local itemID = link:match("item:(%d+)")
    if not itemID then return end

    local sources = {}
    for id, data in pairs(MyKillCountTable) do
        if type(data) == "table" and data.items then
            for item, dropCount in pairs(data.items) do
                if tostring(item) == itemID then
                    local rate = 0
                    local totalSamples = data.looted or data.count or 0
                    if totalSamples > 0 then
                        rate = (dropCount / totalSamples) * 100
                    end
                    table.insert(sources, {name = data.name or ("NPC " .. id), rate = rate})
                    break
                end
            end
        end
    end

    if #sources > 0 then
        table.sort(sources, function(a, b) return a.rate > b.rate end)
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffffff00Dropped by:|r")
        for i = 1, math.min(3, #sources) do
            local source = sources[i]
            tooltip:AddLine(string.format("- %s [%.1f%%]", source.name, source.rate))
        end
        if #sources > 3 then
            tooltip:AddLine("...")
        end
    end
end

local function TooltipPostCall(tooltip, data)
    if not IsShiftKeyDown() then return end
    local okForbidden, forbidden = pcall(tooltip.IsForbidden, tooltip)
    if okForbidden and forbidden then return end

    local link = data and data.hyperlink
    if isSecret(link) or type(link) ~= "string" or link == "" then
        local ok, _, l = pcall(tooltip.GetItem, tooltip)
        if ok then link = l end
    end
    -- Never let our extra lines break the game's tooltip rendering.
    pcall(AddDropLines, tooltip, link)
end

if TooltipDataProcessor and Enum and Enum.TooltipDataType then
    local ok = pcall(TooltipDataProcessor.AddTooltipPostCall, Enum.TooltipDataType.Item, TooltipPostCall)
    if not ok then
        GameTooltip:HookScript("OnTooltipSetItem", function(self)
            TooltipPostCall(self, nil)
        end)
    end
else
    GameTooltip:HookScript("OnTooltipSetItem", function(self)
        TooltipPostCall(self, nil)
    end)
end
