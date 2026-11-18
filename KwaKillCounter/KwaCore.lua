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
frame:RegisterEvent("CHAT_MSG_MONEY")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local pendingKillQueue = {}
local processedGUIDs = {}
local processedItemGUIDs = {}
local lastTargetCache = nil -- { npcID, name, race, time }
local lastPlayerXP = nil

-- Session-only loot state. This is intentionally *not* persisted: every addon
-- load starts with an empty list, and only mobs killed/looted since then appear
-- in the tracker's Session view.
local session = { mobs = {}, nextSeq = 0 }
KKK.Session = session

local lootSnapshots = {} -- [stable loot key] = { money, coin, items }
local lootGenerations = {} -- [npcID] = kill generation, used when source GUID is secret
local lastLootNpcID = nil
local lastLootTime = 0

-- Coin can be reported twice: once from the loot slot and once from the
-- "You loot ..." chat message. These records let us keep whichever arrives
-- first and ignore the duplicate, regardless of event order.
local COIN_DEDUPE_WINDOW = 6
local recentCoinEvents = {} -- { npcID, amount, time, source }

function KKK.NotifyTracker(reason, npcID)
    if KKK.Tracker and KKK.Tracker.OnDataChanged then
        KKK.Tracker.OnDataChanged(reason, npcID)
    end
    if KKK.KillStats and KKK.KillStats.OnDataChanged then
        KKK.KillStats.OnDataChanged(reason, npcID)
    end
    if KKK.ItemLookup and KKK.ItemLookup.OnDataChanged then
        KKK.ItemLookup.OnDataChanged(reason, npcID)
    end
end

function KKK.GetSessionMob(npcID, name, race)
    if not npcID then return nil end
    npcID = tostring(npcID)
    local entry = session.mobs[npcID]
    if not entry then
        entry = {
            id = npcID,
            name = name or ("NPC " .. npcID),
            race = race,
            items = {},
            vendor = 0,
            looted = 0,
            kills = 0,
            seq = 0,
        }
        session.mobs[npcID] = entry
    end
    if name and name ~= "" then entry.name = name end
    if race and race ~= "Unspecified" then entry.race = race end
    return entry
end

function KKK.TouchSessionMob(npcID, name, race)
    local entry = KKK.GetSessionMob(npcID, name, race)
    session.nextSeq = session.nextSeq + 1
    entry.seq = session.nextSeq
    entry.kills = (entry.kills or 0) + 1
    return entry
end

function KKK.ResetSessionMob(npcID, silent)
    if not npcID then return end
    session.mobs[tostring(npcID)] = nil
    if not silent then
        KKK.NotifyTracker("session-reset", npcID)
    end
end

function KKK.ResetSession()
    session.mobs = {}
    session.nextSeq = 0
end

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
        MyKillCountTable[npcID] = {count = 0, looted = 0, name = name or "Unknown NPC", race = race or "Unspecified", xp = 0, avgLootValue = 0, items = {}, itemCounts = {}, coin = 0}
    end
    local entry = MyKillCountTable[npcID]
    entry.items = entry.items or {}
    entry.count = (entry.count or 0) + 1
    entry.looted = entry.looted or 0
    -- Each new kill gets a new loot generation. This keeps repeated loot
    -- windows for the *same* corpse from being counted more than once, while
    -- still allowing the next kill of the same NPC to count again.
    lootGenerations[npcID] = (lootGenerations[npcID] or 0) + 1
    if name and name ~= "" then entry.name = name end
    if race and race ~= "Unspecified" then entry.race = race end
    if not entry.avgLootValue then entry.avgLootValue = 0 end
    table.insert(pendingKillQueue, { id = npcID, time = GetTime() })
    if #pendingKillQueue > 10 then table.remove(pendingKillQueue, 1) end

    -- Tracker session: every kill moves this mob's section to the top.
    KKK.TouchSessionMob(npcID, entry.name, entry.race)
    -- The corpse we are about to loot is this mob; this lets coin chat
    -- messages that arrive before LOOT_READY still be attributed correctly.
    lastLootNpcID = npcID
    lastLootTime = GetTime()
    KKK.NotifyTracker("kill", npcID)
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

local function StripMoneyEscapes(text)
    if type(text) ~= "string" then return "" end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", "")
    text = text:gsub("|r", "")
    text = text:gsub("|T.-|t", "")
    text = text:gsub("|A.-|a", "")
    text = text:gsub("|H.-|h", "")
    return text
end

local function EscapePattern(text)
    return (text:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1"))
end

local coinWordMap
local function EnsureCoinWordMap()
    if coinWordMap then return end
    coinWordMap = {
        gold = 10000, g = 10000,
        silver = 100, s = 100,
        copper = 1, c = 1,
    }

    if GetMoneyString then
        local denominations = { {10000, "gold"}, {100, "silver"}, {1, "copper"} }
        for _, info in ipairs(denominations) do
            local ok, text = pcall(GetMoneyString, info[1], true)
            if ok and type(text) == "string" then
                local word = StripMoneyEscapes(text):gsub("%d", ""):gsub("[%s,%.]+", "")
                word = word:lower()
                if word ~= "" then
                    coinWordMap[word] = info[1]
                end
            end
        end
    end
end

-- Turn a "You loot ..." chat line into a copper amount.
local function ParseMoneyMessage(message)
    if type(message) ~= "string" or message == "" then return nil end
    if isSecret(message) or not canAccess(message) then return nil end
    EnsureCoinWordMap()

    local text = StripMoneyEscapes(message):lower()
    local total, found = 0, false
    for value, token in text:gmatch("(%d+)%s*([^%d%s%p]+)") do
        local multiplier = coinWordMap[token]
        if multiplier then
            total = total + (tonumber(value) or 0) * multiplier
            found = true
        end
    end
    if found then return total end

    -- Unknown coin wording: the message normally contains a single amount.
    local fallback = text:match("(%d+)")
    return fallback and tonumber(fallback) or nil
end

local function PruneCoinEvents(now)
    for index = #recentCoinEvents, 1, -1 do
        if (now - recentCoinEvents[index].time) > COIN_DEDUPE_WINDOW then
            table.remove(recentCoinEvents, index)
        end
    end
end

local function HasCoinEvent(npcID, amount, source, now)
    PruneCoinEvents(now)
    for index = #recentCoinEvents, 1, -1 do
        local record = recentCoinEvents[index]
        if record.source ~= source
            and record.amount == amount
            and (not npcID or not record.npcID or record.npcID == npcID)
            and (now - record.time) <= COIN_DEDUPE_WINDOW then
            table.remove(recentCoinEvents, index)
            return true
        end
    end
    return false
end

local function RecordCoinEvent(npcID, amount, source, now)
    recentCoinEvents[#recentCoinEvents + 1] = {
        npcID = npcID,
        amount = amount,
        source = source,
        time = now,
    }
    PruneCoinEvents(now)
end

local function AddCoinDrop(npcID, amount)
    amount = tonumber(amount)
    if not npcID or not amount or amount <= 0 or not MyKillCountTable then return end
    npcID = tostring(npcID)

    local entry = MyKillCountTable[npcID]
    if not entry and lastTargetCache and lastTargetCache.npcID == npcID then
        entry = {
            count = 0, looted = 0,
            name = lastTargetCache.name,
            race = lastTargetCache.race,
            xp = 0, avgLootValue = 0,
            items = {}, itemCounts = {}, coin = 0,
        }
        MyKillCountTable[npcID] = entry
    end

    if entry then
        entry.coin = (entry.coin or 0) + amount
        entry.totalVendorValue = (entry.totalVendorValue or 0) + amount
        if (entry.looted or 0) > 0 then
            entry.avgLootValue = entry.totalVendorValue / entry.looted
        end
    end

    local sessionEntry = KKK.GetSessionMob(npcID, entry and entry.name, entry and entry.race)
    sessionEntry.vendor = (sessionEntry.vendor or 0) + amount
    sessionEntry.coin = (sessionEntry.coin or 0) + amount

    KKK.NotifyTracker("loot", npcID)
end

local function UpdateLootValue(isLootOpened)
    local numItems = GetNumLootItems()
    local lootData = {} -- lootKey -> { npcID, totalMoney = 0, items = {}, itemQtys = {}, complete = true }

    local function AddLoot(key, npcID)
        local data = lootData[key]
        if not data then
            data = { npcID = npcID, totalMoney = 0, coin = 0, items = {}, itemQtys = {}, complete = true }
            lootData[key] = data
        end
        return data
    end

    local function QualifyLootKey(npcID, key)
        if npcID and key and key:sub(1, 7) == "target:" then
            -- The fallback key is identical for every kill of the same NPC.
            -- Qualify it by kill generation instead of per-window token, so
            -- re-opening the same corpse is deduplicated reliably.
            key = key .. ":gen:" .. tostring(lootGenerations[npcID] or 0)
        end
        return npcID, key
    end

    local function GetLootKey(i)
        local guid
        if GetLootSourceInfo then
            local ok, g = pcall(GetLootSourceInfo, i)
            if ok then guid = g end
        end
        local npcID, key = ResolveLootNpcID(guid)
        return QualifyLootKey(npcID, key)
    end

    if numItems == 0 then
        -- Even if empty, we want to count the loot event for the current target
        if UnitIsDead and UnitIsDead("target") then
            local npcID, key = QualifyLootKey(ResolveLootNpcID(nil))
            if npcID and key then
                AddLoot(key, npcID)
                lastLootNpcID = npcID
                lastLootTime = GetTime()
            end
        end
    else
        for i = 1, numItems do
            local npcID, key = GetLootKey(i)
            if npcID and key then
                local data = AddLoot(key, npcID)
                lastLootNpcID = npcID
                lastLootTime = GetTime()

                local lootIcon, lootName, lootQuantity = GetLootSlotInfo(i)
                local itemLink = GetLootSlotLink and GetLootSlotLink(i) or nil
                local slotType = GetLootSlotType and GetLootSlotType(i) or nil
                local isMoney = slotType == 2 or (slotType ~= 3 and not itemLink and (lootQuantity or 0) > 0)

                if isMoney then
                    local quantity = tonumber(lootQuantity) or 0
                    local now = GetTime()
                    if quantity > 0 then
                        if HasCoinEvent(npcID, quantity, "slot", now) then
                            -- Already credited from the chat message.
                        else
                            RecordCoinEvent(npcID, quantity, "slot", now)
                            data.coin = (data.coin or 0) + quantity
                            data.totalMoney = data.totalMoney + quantity
                        end
                    end
                elseif itemLink then -- Item
                    local itemName, _, _, _, _, _, _, _, _, _, price = GetItemInfo(itemLink)
                    if itemName then
                        local quantity = lootQuantity or 1

                        local itemID = itemLink:match("item:(%d+)")
                        local itemKey = itemID or itemName
                        table.insert(data.items, itemKey)
                        data.itemQtys[itemKey] = (data.itemQtys[itemKey] or 0) + quantity

                        if price then
                            data.totalMoney = data.totalMoney + (price * quantity)
                        else
                            data.complete = false
                        end
                    else
                        data.complete = false
                    end
                else
                    data.complete = false
                end
            end
        end
    end

    local sessionChanged = false

    for key, data in pairs(lootData) do
        local npcID = data.npcID
        if npcID then
            local entry = MyKillCountTable[npcID]
            if not entry then
                -- Loot proves a kill even when the death event was secret / off-target.
                if lastTargetCache and lastTargetCache.npcID == npcID then
                    entry = {count = 0, looted = 0, name = lastTargetCache.name, race = lastTargetCache.race, xp = 0, avgLootValue = 0, items = {}, itemCounts = {}, coin = 0}
                    MyKillCountTable[npcID] = entry
                end
            end
            if entry then
                entry.items = entry.items or {}

                if not processedItemGUIDs[key] then
                    processedItemGUIDs[key] = true
                    entry.looted = (entry.looted or 0) + 1
                    entry.itemCounts = entry.itemCounts or {}

                    local uniqueItems = {}
                    for _, itemID in ipairs(data.items) do
                        uniqueItems[itemID] = true
                    end

                    for itemID, _ in pairs(uniqueItems) do
                        entry.items[itemID] = (entry.items[itemID] or 0) + 1
                    end

                    for itemID, quantity in pairs(data.itemQtys) do
                        entry.itemCounts[itemID] = (entry.itemCounts[itemID] or 0) + quantity
                    end

                    if (data.coin or 0) > 0 then
                        entry.coin = (entry.coin or 0) + data.coin
                        entry.totalVendorValue = (entry.totalVendorValue or 0) + data.coin
                    end
                end

                if data.complete and not processedGUIDs[key] then
                    processedGUIDs[key] = true
                    local itemValue = data.totalMoney - (data.coin or 0)
                    entry.totalVendorValue = (entry.totalVendorValue or 0) + itemValue
                    if entry.looted and entry.looted > 0 then
                        entry.avgLootValue = entry.totalVendorValue / entry.looted
                    end
                end
            end

            -- Session view is updated from a per-corpse snapshot keyed by the
            -- stable loot key. Re-opening the same corpse therefore produces
            -- zero deltas, while a new kill gets a new key and counts again.
            local hasLoot = next(data.itemQtys) ~= nil or data.totalMoney > 0
            if hasLoot then
                local previous = lootSnapshots[key]
                local previousItems = previous and previous.items or {}
                local previousMoney = previous and previous.money or 0
                local previousCoin = previous and previous.coin or 0
                local deltaMoney = data.totalMoney - previousMoney
                local deltaCoin = (data.coin or 0) - previousCoin

                local name = entry and entry.name
                local race = entry and entry.race
                if not name and lastTargetCache and lastTargetCache.npcID == npcID then
                    name = lastTargetCache.name
                    race = lastTargetCache.race
                end

                local sessionEntry = KKK.GetSessionMob(npcID, name, race)
                if not previous then
                    sessionEntry.looted = (sessionEntry.looted or 0) + 1
                end

                if deltaMoney > 0 then
                    sessionEntry.vendor = (sessionEntry.vendor or 0) + deltaMoney
                    sessionChanged = true
                end

                if deltaCoin > 0 then
                    sessionEntry.coin = (sessionEntry.coin or 0) + deltaCoin
                    sessionChanged = true
                end

                for itemID, quantity in pairs(data.itemQtys) do
                    local delta = quantity - (previousItems[itemID] or 0)
                    if delta > 0 then
                        sessionEntry.items[itemID] = (sessionEntry.items[itemID] or 0) + delta
                        sessionChanged = true
                    end
                end

                local snapshotItems = {}
                for itemID, quantity in pairs(data.itemQtys) do
                    snapshotItems[itemID] = quantity
                end
                lootSnapshots[key] = { money = data.totalMoney, coin = data.coin or 0, items = snapshotItems }
            end
        end
    end

    if sessionChanged then
        KKK.NotifyTracker("loot")
    end
end

-- True when Auctionator's price API is available. The tracker hides auction
-- values entirely when it isn't, rather than showing a misleading zero.
function KKK.HasAuctionator()
    return type(Auctionator) == "table"
        and type(Auctionator.API) == "table"
        and type(Auctionator.API.v1) == "table"
end

-- A single item's auction price, with the same quality sanity filter used by
-- the original average-value calculation.
function KKK.GetAuctionPrice(itemID)
    local numericID = tonumber(itemID)
    if not numericID then return 0 end

    local _, link, itemQuality = GetItemInfo(numericID)

    local ahPrice = 0
    if KKK.HasAuctionator() then
        local ok, price
        ok, price = pcall(Auctionator.API.v1.GetAuctionPriceByItemID, "KwaKillCounter", numericID)
        if (not ok or not price) and link then
            ok, price = pcall(Auctionator.API.v1.GetAuctionPriceByItemLink, "KwaKillCounter", link)
        end
        if ok and price then ahPrice = price end
    end

    -- Quality is only a sanity check, so don't throw away a real Auctionator
    -- price just because the client hasn't cached the item's info yet.
    if itemQuality == 1 and ahPrice > 100000 then
        ahPrice = 0
    end

    return ahPrice
end

-- Total auction value for an id -> count item table.
function KKK.GetItemsAuctionValue(items)
    local totalValue = 0
    if not items then return totalValue end
    for itemID, count in pairs(items) do
        local price = KKK.GetAuctionPrice(itemID)
        if price > 0 then
            totalValue = totalValue + (price * count)
        end
    end
    return totalValue
end

-- Dynamic Auction Value Calculation (average per loot event, kept for the
-- existing /kwatopauction command).
function GetDynamicAuctionValue(npcID)
    local data = MyKillCountTable and MyKillCountTable[npcID]
    if not data or not data.items or not data.looted or data.looted == 0 then return 0 end

    local totalValue = 0
    for itemID, dropCount in pairs(data.items) do
        totalValue = totalValue + (KKK.GetAuctionPrice(itemID) * dropCount)
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
    lootSnapshots = {}
    lootGenerations = {}
    KKK.ResetSession()
    KKK.NotifyTracker("reset")
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
            if not data.itemCounts then
                data.itemCounts = {}
                for itemID, count in pairs(data.items) do
                    data.itemCounts[itemID] = count
                end
            end
            data.avgLootValue = data.avgLootValue or 0
            data.totalVendorValue = data.totalVendorValue or ((data.avgLootValue or 0) * (data.looted or 0))
            data.coin = data.coin or 0
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
        lootSnapshots = {}
        lastLootNpcID = nil
        lastLootTime = 0
        recentCoinEvents = {}
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

    elseif event == "CHAT_MSG_MONEY" then
        local message = ...
        local amount = ParseMoneyMessage(message)
        if amount and amount > 0 then
            local now = GetTime()
            local npcID = lastLootNpcID
            if not npcID and lastTargetCache and (now - (lastTargetCache.time or 0)) < 60 then
                npcID = lastTargetCache.npcID
            end
            if not npcID then
                npcID = UnitNpcId("target")
            end

            if npcID and (now - (lastLootTime or 0)) <= 60 then
                if not HasCoinEvent(npcID, amount, "chat", now) then
                    RecordCoinEvent(npcID, amount, "chat", now)
                    AddCoinDrop(npcID, amount)
                end
            end
        end

    elseif event == "LOOT_OPENED" then
        UpdateLootValue(true)
    elseif event == "LOOT_READY" then
        UpdateLootValue(false)
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
