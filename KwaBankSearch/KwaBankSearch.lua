local addonName, NS = ...

-- Bank Search: remembers what each character has in their bags and bank, and
-- lets you search across the whole account.
--
-- Only the logged-in character's containers can be read. Bags are copied live
-- on bag events, and the bank is copied whenever it is open. Other characters'
-- snapshots come from SavedVariables, so their data is as fresh as the last
-- time that character logged in / opened their bank.

if not (KwaLite and KwaLite.RegisterAddon) then
    return
end

local ADDON_ID = "KwaBankSearch"
local SEARCH_DEBOUNCE = 0.15
local ROW_HEIGHT = 28
local HEADER_HEIGHT = 20
local DEFAULT_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

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
local showInventoryCheck
local showInventoryLabel
local statusLabel
local scroll
local content

local itemRows = {}
local headerRows = {}
local itemRowCount = 0
local headerRowCount = 0

local searchToken = 0
local scanToken = 0
local bankOpen = false
local requestedItems = {}
local lastScrollQuery = nil

local function Now()
    if type(time) == "function" then return time() end
    return 0
end

local function SafeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
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

local function NormalizeIcon(icon)
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

local function GetItemInfoAPI()
    if C_Item and C_Item.GetItemInfo then return C_Item.GetItemInfo end
    return GetItemInfo
end

local function GetItemInfoInstantAPI()
    if C_Item and C_Item.GetItemInfoInstant then return C_Item.GetItemInfoInstant end
    return GetItemInfoInstant
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

    local request = C_Item and (C_Item.RequestLoadItemDataByID or C_Item.RequestLoadItemData)
    if type(request) == "function" then
        pcall(request, itemID)
        return
    end
    if type(_G.RequestLoadItemDataByID) == "function" then
        pcall(_G.RequestLoadItemDataByID, itemID)
    end
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

    if not meta.name then
        local getInfo = GetItemInfoAPI()
        if type(getInfo) == "function" then
            local ok, name, link, quality, _, _, class, subclass, _,
                _, texture, _, classID, subclassID = pcall(getInfo, itemID)
            if ok and name then
                meta.name = name
                meta.nameLower = name:lower()
                meta.link = link or meta.link
                if quality ~= nil then meta.quality = quality end
                meta.icon = NormalizeIcon(texture) or meta.icon
                if class then meta.class = class end
                if classID then meta.classID = classID end
                if subclass then meta.subclass = subclass end
                if subclassID then meta.subclassID = subclassID end
            end
        end
    end

    if not meta.classID then
        local instant = GetItemInfoInstantAPI()
        if type(instant) == "function" then
            local ok, _, itemType, itemSubType, _, icon, classID, subclassID = pcall(instant, itemID)
            if ok then
                meta.class = meta.class or itemType
                meta.subclass = meta.subclass or itemSubType
                meta.classID = meta.classID or classID
                meta.subclassID = meta.subclassID or subclassID
                meta.icon = meta.icon or NormalizeIcon(icon)
            end
        end
    end

    if not meta.icon then
        local getIcon = C_Item and C_Item.GetItemIconByID
        if type(getIcon) == "function" then
            meta.icon = NormalizeIcon(SafeCall(getIcon, itemID))
        end
    end

    if not meta.name and type(meta.link) == "string" then
        local name = meta.link:match("%[(.-)%]")
        if name and name ~= "" then
            meta.name = name
            meta.nameLower = name:lower()
        end
    end

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

local function ScheduleScan()
    scanToken = scanToken + 1
    local token = scanToken

    local function work()
        if token ~= scanToken then return end
        local char = EnsureCharacter()
        ScanInventory(char)
        if bankOpen then ScanBank(char) end
        if panel and panel:IsShown() then
            NS.Refresh()
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
            }
        end
    end

    return results
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

local function UpdateContentWidth()
    if not scroll or not content then return end
    local width = scroll:GetWidth() or 0
    if width < 50 then
        width = (panel and panel:GetWidth()) or 220
    end
    content:SetWidth(math.max(100, width - 26))
end

local function UpdatePlaceholder()
    if not searchPlaceholder or not searchBox then return end
    local text = searchBox:GetText() or ""
    if text == "" then
        searchPlaceholder:Show()
    else
        searchPlaceholder:Hide()
    end
end

local function CreateHeaderRow(index)
    local row = CreateFrame("Frame", nil, content)
    row:SetHeight(HEADER_HEIGHT)

    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    row.text:SetPoint("LEFT", row, "LEFT", 0, 0)
    row.text:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.text:SetJustifyH("LEFT")
    row.text:SetWordWrap(false)

    headerRows[index] = row
    return row
end

local function CreateItemRow(index)
    local row = CreateFrame("Button", nil, content)
    row:SetHeight(ROW_HEIGHT)

    local highlight = row:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetColorTexture(1, 1, 1, 0.06)

    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(20, 20)
    row.icon:SetPoint("LEFT", row, "LEFT", 1, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
    row.name:SetPoint("RIGHT", row, "RIGHT", -44, 0)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)

    row.countText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.countText:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.countText:SetJustifyH("RIGHT")
    row.countText:SetTextColor(0.85, 0.85, 0.85)

    row:SetScript("OnEnter", function(self)
        if not self.itemID then return end
        local db = EnsureDB()
        local meta = db.items[self.itemID] or EnsureMeta(self.itemID)

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:ClearLines()

        local shown = false
        if meta and type(meta.link) == "string" and meta.link ~= "" then
            shown = pcall(GameTooltip.SetHyperlink, GameTooltip, meta.link)
        end
        if not shown and type(GameTooltip.SetItemByID) == "function" then
            shown = pcall(GameTooltip.SetItemByID, GameTooltip, self.itemID)
        end
        if not shown then
            GameTooltip:AddLine(meta and meta.name or ("Item " .. tostring(self.itemID)), 1, 0.82, 0)
            GameTooltip:AddLine("Item ID: " .. tostring(self.itemID), 1, 1, 1)
        end
        GameTooltip:AddDoubleLine("Count:", tostring(self.stackCount or 0), 1, 1, 1, 1, 1, 1)
        GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function()
        GameTooltip:Hide()
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

    itemRows[index] = row
    return row
end

local function GetItemRow(index)
    return itemRows[index] or CreateItemRow(index)
end

local function GetHeaderRow(index)
    return headerRows[index] or CreateHeaderRow(index)
end

NS.Refresh = function()
    if not content or not searchBox or not statusLabel then return end

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

    for _, section in ipairs(sections) do
        shownHeaders = shownHeaders + 1
        local header = GetHeaderRow(shownHeaders)
        header:ClearAllPoints()
        header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        header:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
        header.text:SetText("|cff9d9d9d" .. section.label .. "|r")
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
    end

    for index = shownHeaders + 1, headerRowCount do
        headerRows[index]:Hide()
    end
    headerRowCount = shownHeaders

    for index = shownItems + 1, itemRowCount do
        itemRows[index].itemID = nil
        itemRows[index]:Hide()
    end
    itemRowCount = shownItems

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
    searchBox:SetMaxLetters(80)
    local fontObject = _G.ChatFontNormal or _G.GameFontNormal
    if fontObject then
        searchBox:SetFontObject(fontObject)
    end
    searchBox:SetTextInsets(0, 0, 0, 0)
    searchBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    searchBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
        NS.Refresh()
    end)
    searchBox:SetScript("OnTextChanged", function()
        UpdatePlaceholder()
        ScheduleSearch()
    end)
    searchBox:SetScript("OnEditFocusGained", UpdatePlaceholder)
    searchBox:SetScript("OnEditFocusLost", UpdatePlaceholder)

    searchPlaceholder = searchFrame:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    searchPlaceholder:SetPoint("LEFT", searchFrame, "LEFT", 7, 0)
    searchPlaceholder:SetText("Search items...")

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

    scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -64)
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
        if panel and panel:IsShown() then NS.Refresh() end
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        requestedItems[arg1] = nil
        local db = EnsureDB()
        if db.items[arg1] then EnsureMeta(arg1) end
        if panel and panel:IsShown() then NS.Refresh() end
    elseif event == "PLAYER_LOGOUT" then
        local char = EnsureCharacter()
        ScanInventory(char)
        if bankOpen then ScanBank(char) end
    end
end)

KwaLite:RegisterAddon({
    id = ADDON_ID,
    name = "Bank Search",
    icon = "Interface\\Icons\\INV_Misc_Bag_07",
    priority = 8,
    createPanel = CreatePanel,
})
