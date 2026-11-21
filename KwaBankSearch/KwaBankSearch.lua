local addonName, NS = ...

-- Bank Search: remembers what each character has in their bags and bank, and
-- lets you search across the whole account.
--
-- Only the logged-in character's containers can be read. Bags are copied live
-- on bag events, and the bank is copied whenever it is open. Other characters'
-- snapshots come from SavedVariables, so their data is as fresh as the last
-- time that character logged in / opened their bank.

if not (KwaLite and KwaLite.RegisterAddon and KwaLite.Util) then
    return
end

local Util = KwaLite.Util

local ADDON_ID = "KwaBankSearch"
local SEARCH_DEBOUNCE = 0.15
local REFRESH_MIN_INTERVAL = 0.25
local ROW_HEIGHT = 28
local HEADER_HEIGHT = 20
local INVENTORY_PADDING = 15
local DEFAULT_ICON = Util.DEFAULT_ICON
local NormalizeIcon = Util.NormalizeIcon
local ColorName = Util.ColorName

-- Quality ids: 0 poor, 1 common, 2 uncommon, 3 rare, 4 epic, 5 legendary.
local RARITY_ALIASES = {
    poor = 0,
    gray = 0,
    grey = 0,
    common = 1,
    white = 1,
    uncommon = 2,
    green = 2,
    rare = 3,
    blue = 3,
    epic = 4,
    purple = 4,
    legendary = 5,
    orange = 5,
}

local RECIPE_PREFIXES = {
    "recipe:",
    "pattern:",
    "formula:",
    "schematic:",
    "plans:",
    "technique:",
}

local panel
local searchFrame
local searchBox
local searchPlaceholder
local UpdatePlaceholder
local showInventoryCheck
local showInventoryLabel
local statusLabel
local scroll
local content

local itemPool, headerPool

local searchToken = 0
local scanToken = 0
local bankOpen = false
local requestedItems = {}
local lastScrollQuery = nil
local lastRefresh = 0
local refreshScheduled = false

local function Now()
    if type(time) == "function" then return time() end
    return 0
end

local function EnsureDB()
    if type(KwaBankSearchDB) ~= "table" then
        KwaBankSearchDB = {}
    end

    local db = KwaBankSearchDB
    if type(db.items) ~= "table" then db.items = {} end
    if type(db.chars) ~= "table" then db.chars = {} end
    -- Existing installs from before the filter change default to showing the
    -- current character's inventory.
    if db.version ~= 3 then
        db.showInventory = true
        db.version = 3
    end
    if type(db.showInventory) ~= "boolean" then db.showInventory = true end
    return db
end

local function GetContainerNumSlots(bag)
    if C_Container and C_Container.GetContainerNumSlots then
        return C_Container.GetContainerNumSlots(bag) or 0
    end
    if type(GetContainerNumSlots) == "function" then
        return GetContainerNumSlots(bag) or 0
    end
    return 0
end

local function GetContainerItem(bag, slot)
    if C_Container and C_Container.GetContainerItemInfo then
        local info = C_Container.GetContainerItemInfo(bag, slot)
        if type(info) == "table" then
            return info.itemID, info.stackCount, info.quality,
                (info.iconFileID or info.icon), info.hyperlink
        end
        return nil
    end

    if type(GetContainerItemInfo) == "function" then
        local icon, count, _, quality, _, _, link, _, _, itemID = GetContainerItemInfo(bag, slot)
        if not itemID and type(link) == "string" then
            itemID = tonumber(link:match("item:(%d+)"))
        end
        return itemID, count, quality, icon, link
    end

    return nil
end

local function RequestItemData(itemID)
    if type(itemID) ~= "number" or requestedItems[itemID] then return end
    requestedItems[itemID] = true
    Util.RequestItemData(itemID)
end

local function EnsureMeta(itemID, fallbackQuality, fallbackIcon, fallbackLink)
    local db = EnsureDB()
    local meta = db.items[itemID]
    if type(meta) ~= "table" then
        meta = {}
        db.items[itemID] = meta
    end

    if meta.quality == nil and fallbackQuality ~= nil then meta.quality = fallbackQuality end
    if meta.icon == nil and fallbackIcon ~= nil then meta.icon = NormalizeIcon(fallbackIcon) end
    if (meta.link == nil or meta.link == "") and fallbackLink then meta.link = fallbackLink end

    Util.UpdateItemMeta(itemID, meta)

    if not meta.name then
        RequestItemData(itemID)
    end

    return meta
end

local function BagIDs()
    local list = {}
    local last = NUM_BAG_SLOTS or 4
    for bag = 0, last do
        list[#list + 1] = bag
    end
    return list
end

local function BankIDs()
    local list = { BANK_CONTAINER or -1 }
    local first = (NUM_BAG_SLOTS or 4) + 1
    local count = NUM_BANKBAGSLOTS or 6
    for index = 0, count - 1 do
        list[#list + 1] = first + index
    end
    return list
end

local function ScanContainers(ids)
    local items = {}
    local slots = 0

    for _, bag in ipairs(ids) do
        local count = GetContainerNumSlots(bag)
        slots = slots + count
        for slot = 1, count do
            local itemID, stackCount, quality, icon, link = GetContainerItem(bag, slot)
            if type(itemID) == "number" and itemID > 0 then
                local countNow = tonumber(stackCount) or 1
                if countNow > 0 then
                    items[itemID] = (items[itemID] or 0) + countNow
                    EnsureMeta(itemID, quality, icon, link)
                end
            end
        end
    end

    return items, slots
end

local function PlayerIdentity()
    local name, surname = UnitName("player")
    local realm = GetRealmName() or "Unknown"
    local display = name or "Unknown"
    if type(surname) == "string" and surname ~= "" then
        display = display .. " " .. surname
    end
    local _, class = UnitClass("player")
    return name, display, realm, class
end

local function CurrentKey()
    local name, _, realm = PlayerIdentity()
    if not name then return nil end
    return realm .. "-" .. name
end

local function EnsureCharacter()
    local name, display, realm, class = PlayerIdentity()
    if not name then return nil end

    local db = EnsureDB()
    local key = realm .. "-" .. name
    local char = db.chars[key]
    if type(char) ~= "table" then
        char = {}
        db.chars[key] = char
    end
    if type(char.bags) ~= "table" then char.bags = {} end
    if type(char.bank) ~= "table" then char.bank = {} end

    char.name = name
    char.display = display
    char.realm = realm
    char.class = class

    return char, key
end

local function ScanInventory(char)
    if not char then return end
    local items, slots = ScanContainers(BagIDs())
    if slots > 0 then
        char.bags = items
        char.bagsAt = Now()
    end
end

local function ScanBank(char)
    if not (char and bankOpen) then return end
    local items, slots = ScanContainers(BankIDs())
    -- If the bank is not really readable right now, do not wipe the snapshot.
    if slots > 0 then
        char.bank = items
        char.bankAt = Now()
    end
end

local function ScheduleInventoryScan()
    if not (C_Timer and C_Timer.After) then return end
    C_Timer.After(1.0, function()
        local char = EnsureCharacter()
        if char then ScanInventory(char) end
    end)
end

local function ThrottleRefresh()
    local now = Now()
    local delta = REFRESH_MIN_INTERVAL - (now - lastRefresh)
    if delta > 0 then
        if not refreshScheduled then
            refreshScheduled = true
            C_Timer.After(delta, function()
                refreshScheduled = false
                NS.Refresh()
            end)
        end
        return
    end
    NS.Refresh()
end

local function ScheduleScan()
    scanToken = scanToken + 1
    local token = scanToken

    local function work()
        if token ~= scanToken then return end
        local char = EnsureCharacter()
        ScanInventory(char)
        if bankOpen then ScanBank(char) end
        if panel and panel:IsShown() then
            ThrottleRefresh()
        end
    end

    if C_Timer and C_Timer.After then
        C_Timer.After(0.3, work)
    else
        work()
    end
end

local function ParseQuery(text)
    local parsed = { terms = {}, recipes = false }
    text = (text or ""):lower()

    local function raiseMin(field, value)
        if not parsed[field] or value > parsed[field] then parsed[field] = value end
    end
    local function lowerMax(field, value)
        if not parsed[field] or value < parsed[field] then parsed[field] = value end
    end
    local function applyComparison(kind, op, value)
        if kind == "rarity" then
            local q = tonumber(value) or RARITY_ALIASES[value]
            if not q then return end
            if op == "=" then
                raiseMin("rarityMin", q)
                lowerMax("rarityMax", q)
            elseif op == ">" then
                raiseMin("rarityMin", q + 1)
            elseif op == ">=" then
                raiseMin("rarityMin", q)
            elseif op == "<" then
                lowerMax("rarityMax", q - 1)
            elseif op == "<=" then
                lowerMax("rarityMax", q)
            end
        else
            local n = tonumber(value)
            if not n then return end
            if op == "=" then
                raiseMin("countMin", n)
                lowerMax("countMax", n)
            elseif op == ">" then
                raiseMin("countMin", n + 1)
            elseif op == ">=" then
                raiseMin("countMin", n)
            elseif op == "<" then
                lowerMax("countMax", n - 1)
            elseif op == "<=" then
                lowerMax("countMax", n)
            end
        end
    end

    for token in text:gmatch("%S+") do
        if token == "@recipe" or token == "@recipes" then
            parsed.recipes = true
        else
            local alias = token:match("^@(%a+)$")
            local op, value = token:match("^rarity([<>=]+)([%w_]+)$")
            local countOp, countValue = token:match("^count([<>=]+)(%d+)$")

            if alias and RARITY_ALIASES[alias] then
                local q = RARITY_ALIASES[alias]
                raiseMin("rarityMin", q)
                lowerMax("rarityMax", q)
            elseif op then
                applyComparison("rarity", op, value)
            elseif countOp then
                applyComparison("count", countOp, countValue)
            else
                parsed.terms[#parsed.terms + 1] = token
            end
        end
    end

    return parsed
end

local function IsRecipe(meta)
    if not meta then return false end
    if tonumber(meta.classID) == 9 then return true end
    if type(meta.class) == "string" and meta.class:lower() == "recipe" then return true end

    local name = meta.nameLower or ""
    for _, prefix in ipairs(RECIPE_PREFIXES) do
        if name:sub(1, #prefix) == prefix then return true end
    end
    return false
end

local function MatchesSearch(meta, count, parsed)
    if parsed.rarityMin or parsed.rarityMax then
        local quality = tonumber(meta.quality) or 0
        if parsed.rarityMin and quality < parsed.rarityMin then return false end
        if parsed.rarityMax and quality > parsed.rarityMax then return false end
    end

    if parsed.countMin and count < parsed.countMin then return false end
    if parsed.countMax and count > parsed.countMax then return false end
    if parsed.recipes and not IsRecipe(meta) then return false end

    if #parsed.terms > 0 then
        local name = meta.nameLower or ""
        for _, term in ipairs(parsed.terms) do
            if not name:find(term, 1, true) then return false end
        end
    end

    return true
end

local function CharacterLabel(char, key)
    local label = char.display or char.name or key
    local currentRealm = GetRealmName()
    if char.realm and currentRealm and char.realm ~= currentRealm then
        label = label .. " (" .. char.realm .. ")"
    end
    return label
end

local function HasItems(container)
    return type(container) == "table" and next(container) ~= nil
end

local function BuildSections(parsed)
    local db = EnsureDB()
    local _, currentKey = EnsureCharacter()
    local sections = {}

    local keys = {}
    for key, entry in pairs(db.chars) do
        if type(entry) == "table" and (HasItems(entry.bags) or HasItems(entry.bank)) then
            keys[#keys + 1] = key
        end
    end
    table.sort(keys, function(a, b)
        local left, right = db.chars[a], db.chars[b]
        local leftOwn = a == currentKey
        local rightOwn = b == currentKey
        if leftOwn ~= rightOwn then return leftOwn end
        return CharacterLabel(left, a):lower() < CharacterLabel(right, b):lower()
    end)

    for _, key in ipairs(keys) do
        local entry = db.chars[key]
        local own = key == currentKey

        -- The checkbox decides whether the current character's live bags are
        -- part of the list. Filters then apply to whatever is shown.
        if HasItems(entry.bags) and (db.showInventory or not own) then
            sections[#sections + 1] = {
                label = CharacterLabel(entry, key) .. " — Inventory",
                items = entry.bags,
                own = own,
                inventory = true,
            }
        end

        if HasItems(entry.bank) then
            sections[#sections + 1] = {
                label = CharacterLabel(entry, key) .. " — Bank",
                items = entry.bank,
                own = own,
            }
        end
    end

    local results = {}
    for _, section in ipairs(sections) do
        local entries = {}
        for itemID, count in pairs(section.items) do
            local meta = db.items[itemID]
            if type(meta) ~= "table" then meta = EnsureMeta(itemID) end
            if meta and MatchesSearch(meta, count, parsed) then
                entries[#entries + 1] = {
                    itemID = itemID,
                    count = count,
                    meta = meta,
                }
            end
        end

        table.sort(entries, function(a, b)
            local aName = (a.meta and a.meta.nameLower) or ""
            local bName = (b.meta and b.meta.nameLower) or ""
            if aName ~= bName then return aName < bName end
            return a.itemID < b.itemID
        end)

        if #entries > 0 then
            results[#results + 1] = {
                label = section.label,
                entries = entries,
                order = section.order,
                inventory = section.inventory,
                own = section.own,
            }
        end
    end

    return results
end

local function UpdateContentWidth()
    Util.FitContentWidth(scroll, content, panel, 26, 220)
end

local function CreateHeaderRow(index)
    local row = CreateFrame("Frame", nil, content)
    row:SetHeight(HEADER_HEIGHT)

    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    row.text:SetPoint("LEFT", row, "LEFT", 0, 0)
    row.text:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.text:SetJustifyH("LEFT")
    row.text:SetWordWrap(false)

    return row
end

local function CreateItemRow(index)
    local row = Util.CreateItemRow(content, {
        height = ROW_HEIGHT,
        nameRightOffset = -44,
    })

    row.countText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.countText:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.countText:SetJustifyH("RIGHT")
    row.countText:SetTextColor(0.85, 0.85, 0.85)

    row:SetScript("OnEnter", function(self)
        if not self.itemID then return end
        local db = EnsureDB()
        local meta = db.items[self.itemID] or EnsureMeta(self.itemID)

        local shown = Util.ShowItemTooltip(self, self.itemID, meta and meta.link)
        if not shown then
            GameTooltip:AddLine(meta and meta.name or ("Item " .. tostring(self.itemID)), 1, 0.82, 0)
            GameTooltip:AddLine("Item ID: " .. tostring(self.itemID), 1, 1, 1)
        end
        GameTooltip:AddDoubleLine("Count:", tostring(self.stackCount or 0), 1, 1, 1, 1, 1, 1)
        GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function()
        Util.HideTooltip()
    end)

    row:SetScript("OnClick", function(self)
        if not self.itemID then return end
        if IsShiftKeyDown and IsShiftKeyDown() then
            local meta = EnsureDB().items[self.itemID]
            local link = meta and meta.link
            if type(link) == "string" and type(ChatEdit_InsertLink) == "function" then
                pcall(ChatEdit_InsertLink, link)
            end
        end
    end)

    return row
end

itemPool = Util.CreateRowPool(CreateItemRow)
headerPool = Util.CreateRowPool(CreateHeaderRow)

local function GetItemRow(index)
    return itemPool:Get(index)
end

local function GetHeaderRow(index)
    return headerPool:Get(index)
end

NS.Refresh = function()
    if not content or not searchBox or not statusLabel then return end
    lastRefresh = Now()

    local query = searchBox:GetText() or ""
    local scrollY = 0
    if scroll and query == lastScrollQuery then
        scrollY = scroll:GetVerticalScroll()
    end

    local parsed = ParseQuery(query)
    local sections = BuildSections(parsed)
    local width = scroll:GetWidth() or 0
    if width < 50 then width = (panel and panel:GetWidth()) or 220 end
    content:SetWidth(math.max(100, width - 26))

    local y = 0
    local shownHeaders = 0
    local shownItems = 0

    for sectionIndex, section in ipairs(sections) do
        shownHeaders = shownHeaders + 1
        local header = GetHeaderRow(shownHeaders)
        header:ClearAllPoints()
        header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        header:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
        header.text:SetText(section.label)
        if section.inventory then
            header.text:SetTextColor(1, 0.75, 0.15, 1)
        else
            header.text:SetTextColor(1, 0.75, 0.15, 1)
        end
        header:Show()
        y = y + HEADER_HEIGHT

        for _, entry in ipairs(section.entries) do
            shownItems = shownItems + 1
            local row = GetItemRow(shownItems)
            row.itemID = entry.itemID
            row.stackCount = entry.count
            row.icon:SetTexture((entry.meta and entry.meta.icon) or DEFAULT_ICON)
            row.icon:Show()
            local itemName = entry.meta and entry.meta.name or ("Item " .. tostring(entry.itemID))
            row.name:SetText(ColorName(itemName, entry.meta and entry.meta.quality or 1))
            row.countText:SetText("x" .. tostring(entry.count))

            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
            row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
            row:Show()
            y = y + ROW_HEIGHT
        end

        if sectionIndex < #sections then
            y = y + INVENTORY_PADDING
        end
    end

    headerPool:Trim(shownHeaders)
    itemPool:Trim(shownItems, function(row)
        row.itemID = nil
    end)

    content:SetHeight(math.max(y, 1))

    if shownItems == 0 then
        statusLabel:SetText("|cff9d9d9dNo matching items|r")
    else
        statusLabel:SetFormattedText("|cff9d9d9d%d item%s in %d section%s|r",
            shownItems, shownItems == 1 and "" or "s",
            shownHeaders, shownHeaders == 1 and "" or "s")
    end

    if scroll then
        local range = scroll:GetVerticalScrollRange() or 0
        scrollY = math.min(math.max(scrollY, 0), range)
        scroll:SetVerticalScroll(scrollY)
        lastScrollQuery = query
    end
end

local function ScheduleSearch()
    searchToken = searchToken + 1
    local token = searchToken

    if C_Timer and C_Timer.After then
        C_Timer.After(SEARCH_DEBOUNCE, function()
            if token == searchToken then NS.Refresh() end
        end)
    else
        NS.Refresh()
    end
end

local function CreatePanel(parent)
    if panel then return panel end

    panel = CreateFrame("Frame", nil, parent)

    searchFrame, searchBox, searchPlaceholder, UpdatePlaceholder =
        Util.CreateSearchBox(panel, {
            maxLetters = 80,
            onEnter = function() NS.Refresh() end,
            onChanged = function() ScheduleSearch() end,
        })

    showInventoryCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    showInventoryCheck:SetSize(20, 20)
    showInventoryCheck:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -25)
    showInventoryCheck:SetScript("OnClick", function(self)
        EnsureDB().showInventory = self:GetChecked() and true or false
        local char = EnsureCharacter()
        ScanInventory(char)
        NS.Refresh()
    end)
    showInventoryCheck:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Show own inventory", 1, 0.82, 0)
        GameTooltip:AddLine("Show or hide your current character's bags. The search box filters whatever is currently listed.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    showInventoryCheck:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    showInventoryLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    showInventoryLabel:SetPoint("LEFT", showInventoryCheck, "RIGHT", 1, 0)
    showInventoryLabel:SetText("Show own inventory")

    statusLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    statusLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, -47)
    statusLabel:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -1, -47)
    statusLabel:SetJustifyH("LEFT")

    scroll, content = Util.CreateScrollPanel(panel, { top = 64 })

    showInventoryCheck:SetChecked(EnsureDB().showInventory)

    panel:SetScript("OnShow", function()
        local char = EnsureCharacter()
        ScanInventory(char)
        if bankOpen then ScanBank(char) end
        UpdateContentWidth()
        NS.Refresh()
    end)

    UpdateContentWidth()
    UpdatePlaceholder()
    return panel
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("BAG_UPDATE_DELAYED")
events:RegisterEvent("BANKFRAME_OPENED")
events:RegisterEvent("BANKFRAME_CLOSED")
events:RegisterEvent("GET_ITEM_INFO_RECEIVED")
events:RegisterEvent("PLAYER_LOGOUT")

events:SetScript("OnEvent", function(_, event, arg1)
    if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
        local char = EnsureCharacter()
        ScanInventory(char)
        ScheduleInventoryScan()
        if bankOpen then ScanBank(char) end
        if panel and panel:IsShown() then NS.Refresh() end
    elseif event == "BAG_UPDATE_DELAYED" then
        ScheduleScan()
    elseif event == "BANKFRAME_OPENED" then
        bankOpen = true
        local char = EnsureCharacter()
        ScanInventory(char)
        ScheduleScan()
    elseif event == "BANKFRAME_CLOSED" then
        if bankOpen then
            local char = EnsureCharacter()
            ScanBank(char)
        end
        bankOpen = false
        if panel and panel:IsShown() then ThrottleRefresh() end
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        requestedItems[arg1] = nil
        local db = EnsureDB()
        if db.items[arg1] then EnsureMeta(arg1) end
        if panel and panel:IsShown() then ThrottleRefresh() end
    elseif event == "PLAYER_LOGOUT" then
        local char = EnsureCharacter()
        ScanInventory(char)
        if bankOpen then ScanBank(char) end
    end
end)

KwaLite:RegisterAddon({
    id = ADDON_ID,
    name = "Bank Search",
    icon = "Interface\\Icons\\achievement_guildperk_mobilebanking",
    priority = 8,
    createPanel = CreatePanel,
    refresh = NS.Refresh,
})
