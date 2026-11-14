local addonName, KAT = ...

-- This plugin is optional: it only loads when both KwaLite and Auctionator are
-- available. OptionalDeps in the .toc makes Auctionator load first when present.
if not (KwaLite and KwaLite.RegisterAddon) then
    return
end
if not (Auctionator and Auctionator.API and Auctionator.API.v1) then
    return
end

local MAX_RESULTS = 50
local ROW_HEIGHT = 44
local SEARCH_DEBOUNCE = 0.15
local RESOLVE_CHUNK = 150
local RESOLVE_INTERVAL = 0.05

local panel
local searchFrame
local searchBox
local placeholder
local statusLabel
local scroll
local content
local rows = {}

local itemMeta = {}
local itemKey = {}
local itemKeyScore = {}
local indexIDs = {}
local indexSeen = {}
local resolveQueue = {}
local resolveHead = 1
local indexDirty = true
local currentQuery = ""
local resultCount = 0
local searchToken = 0
local needsResolveRefresh = false

local CreatePanel
local RunSearch
local BuildIndex

local function SafeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

local function GetItemInfoAPI()
    if C_Item and C_Item.GetItemInfo then return C_Item.GetItemInfo end
    return GetItemInfo
end

local function GetItemInfoInstantAPI()
    if C_Item and C_Item.GetItemInfoInstant then return C_Item.GetItemInfoInstant end
    return GetItemInfoInstant
end

local function RequestItemData(itemID)
    if type(itemID) ~= "number" then return end
    local request = C_Item and (C_Item.RequestLoadItemDataByID or C_Item.RequestLoadItemData)
    if type(request) == "function" then
        pcall(request, itemID)
        return
    end
    if type(_G.RequestLoadItemDataByID) == "function" then
        pcall(_G.RequestLoadItemDataByID, itemID)
    end
end

local function NormalizeIcon(icon)
    -- 0 is truthy in Lua, and some clients return 0 for "unknown icon".
    -- Treat it as missing so the next source (or the fallback icon) is used.
    if type(icon) == "number" then
        if icon > 0 then return icon end
        return nil
    end
    if type(icon) == "string" and icon ~= "" then
        local numeric = icon:match("^%d+$")
        if numeric then
            local id = tonumber(numeric)
            if id and id > 0 then return id end
            return nil
        end
        return icon
    end
    return nil
end

local function GetItemIcon(itemID)
    local getIconByID = C_Item and C_Item.GetItemIconByID
    if type(getIconByID) == "function" then
        local ok, icon = pcall(getIconByID, itemID)
        if ok and NormalizeIcon(icon) then return NormalizeIcon(icon) end
    end

    if type(_G.GetItemIcon) == "function" then
        local ok, icon = pcall(_G.GetItemIcon, itemID)
        if ok and NormalizeIcon(icon) then return NormalizeIcon(icon) end
    end

    local instant = GetItemInfoInstantAPI()
    if instant then
        -- GetItemInfoInstant returns: itemID, itemType, itemSubType,
        -- itemEquipLoc, icon, classID, subclassID.
        local ok, _, _, _, _, icon = pcall(instant, itemID)
        if ok and NormalizeIcon(icon) then return NormalizeIcon(icon) end
    end
end

local function FetchItemMeta(itemID)
    local getInfo = GetItemInfoAPI()
    if not getInfo then return nil end

    local ok, name, link, quality, _, _, _, _, _, _, texture = pcall(getInfo, itemID)
    if not ok or not name then return nil end

    local icon = NormalizeIcon(texture)
    if not icon then
        icon = GetItemIcon(itemID)
    end

    local meta = {
        name = name,
        nameLower = name:lower(),
        link = link,
        quality = quality,
        icon = icon,
    }
    return meta
end

local function KeyToItemID(key)
    if type(key) == "number" then
        if key > 0 then return math.floor(key) end
        return nil
    end
    if type(key) ~= "string" then return nil end

    local id = key:match("^(%d+)$")
    if id then return tonumber(id) end

    id = key:match("^g:(%d+):") or key:match("^gr:(%d+):")
    if id then return tonumber(id) end

    return nil
end

local function GetPriceDB()
    if Auctionator and Auctionator.Database then
        local db = Auctionator.Database.db
        if type(db) == "table" then return db end
    end

    if type(AUCTIONATOR_PRICE_DATABASE) == "table" then
        local realm = Auctionator and Auctionator.State and Auctionator.State.CurrentRealm
        if not realm and GetRealmName then
            realm = SafeCall(GetRealmName)
        end
        if realm and type(AUCTIONATOR_PRICE_DATABASE[realm]) == "table" then
            return AUCTIONATOR_PRICE_DATABASE[realm]
        end
    end

    return nil
end

local function GetMeanDays()
    if Auctionator and Auctionator.Config and Auctionator.Config.Get then
        local options = Auctionator.Config.Options
        local key = options and options.AUCTION_MEAN_DAYS_LIMIT
        if key then
            local days = SafeCall(Auctionator.Config.Get, key)
            if type(days) == "number" then return days end
        end
    end
    return 21
end

local function GetItemPriceInfo(dbKey)
    local db = GetPriceDB()
    local entry = db and dbKey and db[dbKey]
    if type(entry) ~= "table" then return nil end

    local lowest
    local highest

    if type(entry.l) == "table" then
        for _, price in pairs(entry.l) do
            if type(price) == "number" then
                if not lowest or price < lowest then lowest = price end
                if not highest or price > highest then highest = price end
            end
        end
    end
    if type(entry.h) == "table" then
        for _, price in pairs(entry.h) do
            if type(price) == "number" then
                if not highest or price > highest then highest = price end
                if not lowest or price < lowest then lowest = price end
            end
        end
    end

    local value = tonumber(entry.m)
    local average

    local database = Auctionator and Auctionator.Database
    if database and database.GetMeanPrice then
        average = SafeCall(database.GetMeanPrice, database, dbKey, GetMeanDays())
    end

    if not average and type(entry.h) == "table" then
        local total, count = 0, 0
        for day, price in pairs(entry.h) do
            if type(price) == "number" then
                local low = type(entry.l) == "table" and tonumber(entry.l[day]) or nil
                total = total + (low or price)
                count = count + 1
            end
        end
        if count > 0 then average = math.floor(total / count) end
    end

    return {
        value = value,
        lowest = lowest,
        highest = highest,
        average = average,
    }
end

local function FormatMoney(copper)
    copper = math.floor(tonumber(copper) or 0)

    local coinTextureString = (C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString)
        or GetCoinTextureString
    if coinTextureString then
        local ok, text = pcall(coinTextureString, copper)
        if ok and text then return text end
    end

    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100
    local parts = {}
    if gold > 0 then parts[#parts + 1] = gold .. "g" end
    if silver > 0 then parts[#parts + 1] = silver .. "s" end
    if cop > 0 or #parts == 0 then parts[#parts + 1] = cop .. "c" end
    return table.concat(parts, " ")
end

local function FormatPrice(price)
    if type(price) ~= "number" then return "|cff9d9d9d--|r" end
    return FormatMoney(price)
end

local function ColorName(name, quality)
    local qualityColor = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality or 1]
    local color = qualityColor and qualityColor.color
    if color and color.WrapTextInColorCode then
        local ok, text = pcall(color.WrapTextInColorCode, color, name)
        if ok and text then return text end
    end
    return name
end

local function SetLabel(fontString, label, value)
    fontString:SetText("|cff9d9d9d" .. label .. ":|r " .. FormatPrice(value))
end

local function UpdateContentWidth()
    if not scroll or not content then return end
    local width = scroll:GetWidth() or 0
    if width < 50 then
        width = (panel and panel:GetWidth()) or 220
    end
    width = width - 24
    if width < 100 then width = 100 end
    content:SetWidth(width)
end

local function CreateRow(parent, index)
    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(ROW_HEIGHT)

    local highlight = row:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetColorTexture(1, 1, 1, 0.06)

    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(30, 30)
    row.icon:SetPoint("TOPLEFT", row, "TOPLEFT", 2, -2)
    row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    row.icon:SetAlpha(1)
    row.icon:Show()

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.name:SetPoint("TOPLEFT", row, "TOPLEFT", 36, -2)
    row.name:SetPoint("TOPRIGHT", row, "TOPRIGHT", -4, -2)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)
    row.name:SetHeight(12)

    row.value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.value:SetPoint("TOPLEFT", row, "TOPLEFT", 36, -15)
    row.value:SetJustifyH("LEFT")
    row.value:SetWordWrap(false)

    row.average = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.average:SetPoint("TOPLEFT", row, "TOPLEFT", 36, -28)
    row.average:SetJustifyH("LEFT")
    row.average:SetWordWrap(false)

    row.low = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.low:SetPoint("TOPRIGHT", row, "TOPRIGHT", -4, -15)
    row.low:SetJustifyH("RIGHT")
    row.low:SetWordWrap(false)

    row.high = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.high:SetPoint("TOPRIGHT", row, "TOPRIGHT", -4, -28)
    row.high:SetJustifyH("RIGHT")
    row.high:SetWordWrap(false)

    row:SetScript("OnEnter", function(self)
        if not self.itemID then return end

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local meta = itemMeta[self.itemID]
        local shown = false

        if meta and meta.link then
            local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, meta.link)
            shown = ok
        end
        if not shown and GameTooltip.SetItemByID then
            local ok = pcall(GameTooltip.SetItemByID, GameTooltip, self.itemID)
            shown = ok
        end
        if not shown then
            pcall(GameTooltip.SetHyperlink, GameTooltip, "item:" .. self.itemID)
        end
        GameTooltip:Show()
    end)

    row:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    row:SetScript("OnClick", function(self)
        if not self.itemID then return end
        local meta = itemMeta[self.itemID]
        if IsShiftKeyDown and IsShiftKeyDown() and meta and meta.link
            and ChatEdit_InsertLink then
            pcall(ChatEdit_InsertLink, meta.link)
        end
    end)

    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -((index - 1) * ROW_HEIGHT))
    row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -((index - 1) * ROW_HEIGHT))

    return row
end

local function GetRow(index)
    local row = rows[index]
    if not row then
        row = CreateRow(content, index)
        rows[index] = row
    end
    return row
end

local function ShowResults(results)
    resultCount = #results

    for index = 1, MAX_RESULTS do
        local row = rows[index]
        if index <= resultCount then
            local itemID = results[index]
            local meta = itemMeta[itemID]
            local info = itemID and GetItemPriceInfo(itemKey[itemID])

            row = row or GetRow(index)
            row.itemID = itemID
            row.icon:SetTexture((meta and meta.icon) or "Interface\\Icons\\INV_Misc_QuestionMark")
            row.icon:SetAlpha(1)
            row.icon:Show()
            row.name:SetText(meta and ColorName(meta.name, meta.quality) or "Unknown item")

            if info then
                SetLabel(row.value, "Value", info.value)
                SetLabel(row.average, "Avg", info.average)
                SetLabel(row.low, "Low", info.lowest)
                SetLabel(row.high, "Max", info.highest)
            else
                row.value:SetText("|cff9d9d9dNo price data|r")
                row.average:SetText("")
                row.low:SetText("")
                row.high:SetText("")
            end

            row:Show()
        elseif row then
            row.itemID = nil
            row:Hide()
        end
    end

    UpdateContentWidth()
    content:SetHeight(math.max(1, resultCount * ROW_HEIGHT))

    if resultCount == 0 then
        statusLabel:SetText("|cff9d9d9dNo matching items with Auctionator prices|r")
    elseif resultCount >= MAX_RESULTS then
        statusLabel:SetText("|cff9d9d9dShowing first " .. MAX_RESULTS .. " results|r")
    else
        statusLabel:SetText("|cff9d9d9d" .. resultCount .. " result" .. (resultCount == 1 and "" or "s") .. "|r")
    end

    if scroll then scroll:SetVerticalScroll(0) end
end

local function ClearResults()
    for index = 1, #rows do
        rows[index].itemID = nil
        rows[index]:Hide()
    end
    resultCount = 0
    if content then content:SetHeight(1) end
end

RunSearch = function()
    if not panel or not searchBox or not content then return end

    local query = searchBox:GetText() or ""
    query = query:lower():match("^%s*(.-)%s*$")
    currentQuery = query

    if query == "" then
        ClearResults()
        statusLabel:SetText("|cff9d9d9dType to search Auctionator prices|r")
        if scroll then scroll:SetVerticalScroll(0) end
        return
    end

    if indexDirty then BuildIndex() end

    local results = {}
    local added = {}

    -- Prefix matches first so the most relevant items appear at the top.
    for pass = 1, 2 do
        for index = 1, #indexIDs do
            local itemID = indexIDs[index]
            local meta = itemMeta[itemID]
            if meta and meta.nameLower and not added[itemID] then
                local matched
                if pass == 1 then
                    matched = meta.nameLower:sub(1, #query) == query
                else
                    matched = meta.nameLower:find(query, 1, true) ~= nil
                end
                if matched then
                    added[itemID] = true
                    results[#results + 1] = itemID
                    if #results >= MAX_RESULTS then break end
                end
            end
        end
        if #results >= MAX_RESULTS then break end
    end

    ShowResults(results)
end

local function ScheduleSearch()
    searchToken = searchToken + 1
    local token = searchToken

    if C_Timer and C_Timer.After then
        C_Timer.After(SEARCH_DEBOUNCE, function()
            if token == searchToken then RunSearch() end
        end)
    else
        RunSearch()
    end
end

local function UpdatePlaceholder()
    if not placeholder or not searchBox then return end
    local text = searchBox:GetText() or ""
    if text == "" then
        placeholder:Show()
    else
        placeholder:Hide()
    end
end

CreatePanel = function(parent)
    if panel then return panel end

    panel = CreateFrame("Frame", nil, parent)

    searchFrame = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    searchFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    searchFrame:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    searchFrame:SetHeight(22)
    searchFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    searchFrame:SetBackdropColor(0.07, 0.07, 0.09, 0.95)
    searchFrame:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)

    searchBox = CreateFrame("EditBox", nil, searchFrame)
    searchBox:SetPoint("TOPLEFT", searchFrame, "TOPLEFT", 6, -1)
    searchBox:SetPoint("BOTTOMRIGHT", searchFrame, "BOTTOMRIGHT", -6, 1)
    searchBox:SetAutoFocus(false)
    searchBox:SetMaxLetters(60)
    local fontObject = _G.ChatFontNormal or _G.GameFontNormal
    if fontObject then
        searchBox:SetFontObject(fontObject)
    end
    searchBox:SetTextInsets(0, 0, 0, 0)
    searchBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    searchBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
        RunSearch()
    end)
    searchBox:SetScript("OnTextChanged", function()
        UpdatePlaceholder()
        ScheduleSearch()
    end)
    searchBox:SetScript("OnEditFocusGained", function()
        UpdatePlaceholder()
    end)
    searchBox:SetScript("OnEditFocusLost", function()
        UpdatePlaceholder()
    end)

    placeholder = searchFrame:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    placeholder:SetPoint("LEFT", searchFrame, "LEFT", 7, 0)
    placeholder:SetText("Search items...")

    statusLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    statusLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, -25)
    statusLabel:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -1, -25)
    statusLabel:SetJustifyH("LEFT")
    statusLabel:SetText("|cff9d9d9dType to search Auctionator prices|r")

    scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -41)
    scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -2, 0)
    if scroll.ScrollBar then
        scroll.ScrollBar:ClearAllPoints()
        scroll.ScrollBar:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", -2, -14)
        scroll.ScrollBar:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", -2, 14)
    end

    content = CreateFrame("Frame", nil, scroll)
    content:SetWidth(200)
    content:SetHeight(1)
    scroll:SetScrollChild(content)

    panel:SetScript("OnShow", function()
        -- Rebuild on each open so items that were not in the local item cache
        -- last time can be resolved and appear in search results.
        indexDirty = true
        BuildIndex()
        UpdateContentWidth()
        if searchBox and (searchBox:GetText() or "") ~= "" then
            RunSearch()
        else
            UpdatePlaceholder()
        end
    end)

    UpdatePlaceholder()
    return panel
end

BuildIndex = function()
    indexDirty = false

    indexIDs = {}
    indexSeen = {}
    itemKey = {}
    itemKeyScore = {}
    resolveQueue = {}
    resolveHead = 1
    needsResolveRefresh = false

    local db = GetPriceDB()
    if type(db) ~= "table" then return end

    for key, entry in pairs(db) do
        local itemID = KeyToItemID(key)
        if itemID then
            if not indexSeen[itemID] then
                indexSeen[itemID] = true
                indexIDs[#indexIDs + 1] = itemID
                if not itemMeta[itemID] then
                    resolveQueue[#resolveQueue + 1] = itemID
                end
            end

            local score = 0
            if type(entry) == "table" and type(entry.h) == "table" then
                for _ in pairs(entry.h) do score = score + 1 end
            end
            if key == tostring(itemID) then score = score + 100000 end

            if not itemKey[itemID] or score > (itemKeyScore[itemID] or -1) then
                itemKey[itemID] = key
                itemKeyScore[itemID] = score
            end
        end
    end
end

local resolver = CreateFrame("Frame")

resolver:SetScript("OnUpdate", function(_, elapsed)
    if resolveHead > #resolveQueue then return end

    resolver.elapsed = (resolver.elapsed or 0) + (elapsed or 0)
    if resolver.elapsed < RESOLVE_INTERVAL then return end
    resolver.elapsed = 0

    local processed = 0
    while resolveHead <= #resolveQueue and processed < RESOLVE_CHUNK do
        local itemID = resolveQueue[resolveHead]
        resolveHead = resolveHead + 1
        processed = processed + 1

        if not itemMeta[itemID] then
            local meta = FetchItemMeta(itemID)
            if meta then
                itemMeta[itemID] = meta
                needsResolveRefresh = true
            else
                -- The client does not always load item data just by calling
                -- GetItemInfo. Ask for it explicitly; GET_ITEM_INFO_RECEIVED
                -- will queue the item again once the data arrives.
                RequestItemData(itemID)
            end
        end
    end

    if resolveHead > #resolveQueue then
        resolveQueue = {}
        resolveHead = 1
        if needsResolveRefresh then
            needsResolveRefresh = false
            if panel and panel:IsShown() and currentQuery ~= "" then
                RunSearch()
            end
        end
    end
end)

local function QueueItemForResolve(itemID)
    if type(itemID) ~= "number" then return end
    if not indexSeen[itemID] or itemMeta[itemID] then return end
    resolveQueue[#resolveQueue + 1] = itemID
end

resolver:RegisterEvent("GET_ITEM_INFO_RECEIVED")
resolver:RegisterEvent("ITEM_DATA_LOAD_RESULT")
resolver:RegisterEvent("PLAYER_LOGIN")
resolver:SetScript("OnEvent", function(_, event, arg1)
    if event == "GET_ITEM_INFO_RECEIVED" or event == "ITEM_DATA_LOAD_RESULT" then
        QueueItemForResolve(arg1)
    elseif event == "PLAYER_LOGIN" then
        indexDirty = true
        if panel and panel:IsShown() then
            BuildIndex()
            if currentQuery ~= "" then RunSearch() end
        end
    end
end)

-- Auctionator fires this after a scan or after its price database changes.
pcall(Auctionator.API.v1.RegisterForDBUpdate, "KwaAuctionSearch", function()
    indexDirty = true
    if panel and panel:IsShown() then
        BuildIndex()
        if currentQuery ~= "" then RunSearch() end
    end
end)

KwaLite:RegisterAddon({
    id = "KwaAuctionSearch",
    name = "Auction Search",
    icon = "Interface\\Icons\\INV_Misc_Coin_01",
    priority = 2,
    createPanel = CreatePanel,
    refresh = function()
        if indexDirty then BuildIndex() end
        if panel and panel:IsShown() then
            UpdateContentWidth()
            if currentQuery ~= "" then RunSearch() end
        end
    end,
})
