local addonName, KKK = ...

-- Panel version of the /kwakills, /kwaracekills, /kwatopvendor and
-- /kwatopauction commands. Registers as a separate KwaLite plugin.

local GetCoinTextureString = (C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString) or GetCoinTextureString
local GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo

local ROW_HEIGHT = 18
local MIN_KILLS = 10

local panel
local scroll
local content
local dropdown
local dropdownLabel
local subtitle
local emptyLabel
local menu
local overlay
local rows = {}
local rowCount = 0
local auctionCache = {}
local auctionLoadStarted
local requestedItems = {}

local currentView = "kills"

local VIEWS = {
    { id = "kills", label = "Top kills" },
    { id = "species", label = "Kills by species" },
    { id = "vendor", label = "Most profitable vendor" },
    { id = "auction", label = "Most profitable auction" },
}

local VIEW_LABEL = {}
for _, entry in ipairs(VIEWS) do
    VIEW_LABEL[entry.id] = entry.label
end

local function FormatMoney(copper)
    copper = math.floor(tonumber(copper) or 0)
    if GetCoinTextureString then
        local ok, text = pcall(GetCoinTextureString, copper)
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

local function AuctionFor(itemID)
    local key = tostring(itemID)
    local price = auctionCache[key]
    if price == nil then
        price = KKK.GetAuctionPrice and KKK.GetAuctionPrice(itemID) or 0
        auctionCache[key] = price
    end
    return price
end

local function MobAuctionValue(npcID)
    local data = MyKillCountTable and MyKillCountTable[npcID]
    if not data or not data.items or not data.looted or data.looted == 0 then return 0 end

    local total = 0
    for itemID, dropCount in pairs(data.items) do
        total = total + (AuctionFor(itemID) * dropCount)
    end
    return total / data.looted
end

local function ItemInfoReady(itemID)
    if not GetItemInfo then return true end
    if GetItemInfo(itemID) then return true end
    if not requestedItems[itemID] then
        requestedItems[itemID] = true
        if C_Item and C_Item.RequestLoadItemDataByID then
            pcall(C_Item.RequestLoadItemDataByID, itemID)
        end
    end
    return false
end

local function SortRows(list, compare)
    table.sort(list, function(a, b)
        if a.value ~= b.value then return compare(a, b) end
        return (a.name or "") < (b.name or "")
    end)
end

local function BuildRows()
    local list = {}
    local note
    local money = false
    local loading = false
    local table_ = MyKillCountTable or {}

    if currentView == "kills" then
        local totalKills = 0
        local mobs = 0
        for id, data in pairs(table_) do
            if type(data) == "table" then
                local count = data.count or 0
                totalKills = totalKills + count
                if count > 0 then
                    mobs = mobs + 1
                    list[#list + 1] = {
                        name = data.name or ("NPC " .. tostring(id)),
                        value = count,
                    }
                end
            end
        end
        note = "Total kills: " .. totalKills .. "  ·  " .. mobs .. " NPC"
            .. (mobs == 1 and "" or "s")
        SortRows(list, function(a, b) return a.value > b.value end)

    elseif currentView == "species" then
        local totals = {}
        for _, data in pairs(table_) do
            if type(data) == "table" then
                local species = data.race
                if type(species) == "string" and species ~= "" and species ~= "Unspecified" then
                    totals[species] = (totals[species] or 0) + (data.count or 0)
                end
            end
        end
        for species, count in pairs(totals) do
            if count > 0 then
                list[#list + 1] = { name = species, value = count, count = count }
            end
        end
        note = "Kills grouped by NPC species"
        SortRows(list, function(a, b) return a.value > b.value end)

    elseif currentView == "vendor" then
        money = true
        for id, data in pairs(table_) do
            if type(data) == "table" and (data.count or 0) >= MIN_KILLS
                and (data.avgLootValue or 0) > 0 then
                list[#list + 1] = {
                    name = data.name or ("NPC " .. tostring(id)),
                    value = data.avgLootValue,
                    count = data.count or 0,
                }
            end
        end
        note = "Average vendor value per kill  ·  min " .. MIN_KILLS .. " kills"
        SortRows(list, function(a, b) return a.value > b.value end)

    elseif currentView == "auction" then
        money = true
        local candidates = {}
        local missing = false
        for id, data in pairs(table_) do
            if type(data) == "table" and (data.count or 0) >= MIN_KILLS
                and (data.looted or 0) > 0 then
                candidates[#candidates + 1] = { id = id, data = data }
                for itemID in pairs(data.items or {}) do
                    local numericID = tonumber(itemID)
                    if numericID and not ItemInfoReady(numericID) then
                        missing = true
                    end
                end
            end
        end

        -- Auctionator needs the item's link for gear prices. If the client is
        -- still loading item info, wait instead of ranking a partial list that
        -- would change on the next refresh.
        if missing then
            auctionLoadStarted = auctionLoadStarted or GetTime()
            if GetTime() - auctionLoadStarted < 5 then
                return list, "Loading auction values...", money, true
            end
        else
            auctionLoadStarted = nil
        end

        for _, candidate in ipairs(candidates) do
            local value = MobAuctionValue(candidate.id)
            if value > 0 then
                list[#list + 1] = {
                    name = candidate.data.name or ("NPC " .. tostring(candidate.id)),
                    value = value,
                    count = candidate.data.count or 0,
                }
            end
        end
        note = "Average auction value per kill  ·  min " .. MIN_KILLS .. " kills"
        SortRows(list, function(a, b) return a.value > b.value end)
    end

    return list, note, money, loading
end

local function GetRow(index)
    local row = rows[index]
    if row then return row end

    row = CreateFrame("Frame", nil, content)
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.name:SetPoint("LEFT", row, "LEFT", 0, 0)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)
    row.value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.value:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.value:SetJustifyH("RIGHT")
    row.value:SetWordWrap(false)
    rows[index] = row
    return row
end

local function Refresh()
    if not panel then return end

    auctionCache = {}

    local list, note, money, loading = BuildRows()
    local width = (scroll and scroll:GetWidth()) or 0
    if width < 50 then width = 260 end
    width = width - 26
    if width < 100 then width = 100 end
    content:SetWidth(width)

    subtitle:SetText("|cff9d9d9d" .. (note or "") .. "|r")

    local y = 0
    for index = 1, #list do
        local data = list[index]
        local row = GetRow(index)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
        row:SetHeight(ROW_HEIGHT)

        row.name:SetText(index .. ".  " .. data.name)
        row.name:SetWidth(math.max(width - 80, 40))
        if money then
            row.value:SetText(FormatMoney(data.value))
        else
            row.value:SetText(tostring(math.floor(data.value + 0.5)))
        end
        row:Show()
        y = y + ROW_HEIGHT
    end

    for index = #list + 1, rowCount do
        rows[index]:Hide()
    end
    rowCount = #list

    if #list == 0 then
        emptyLabel:Show()
        local text
        if currentView == "auction" then
            if loading then
                text = "Loading auction values..."
            elseif not (KKK.HasAuctionator and KKK.HasAuctionator()) then
                text = "Auction values need Auctionator installed and scanned."
            else
                text = "No NPCs with at least " .. MIN_KILLS
                    .. " kills have auction value data yet."
            end
        elseif currentView == "vendor" then
            text = "No NPCs with at least " .. MIN_KILLS
                .. " kills have vendor loot data yet."
        elseif currentView == "species" then
            text = "No species data recorded yet."
        else
            text = "No kills recorded yet."
        end
        emptyLabel:SetText(text)
        content:SetHeight(40)
    else
        emptyLabel:Hide()
        content:SetHeight(math.max(y, 1))
    end
end

local function HideMenu()
    if menu then menu:Hide() end
    if overlay then overlay:Hide() end
end

local function SelectView(id)
    if not VIEW_LABEL[id] then return end
    currentView = id
    if id == "auction" then auctionLoadStarted = nil end
    dropdownLabel:SetText(VIEW_LABEL[id])
    Refresh()
    if scroll then scroll:SetVerticalScroll(0) end
end

local function CreateMenu()
    if menu then return menu end

    overlay = CreateFrame("Frame", nil, UIParent)
    overlay:SetAllPoints(UIParent)
    overlay:SetFrameStrata("DIALOG")
    overlay:EnableMouse(true)
    overlay:Hide()
    overlay:SetScript("OnMouseDown", HideMenu)

    menu = CreateFrame("Frame", "KwaKillStatsMenu", UIParent, "BackdropTemplate")
    menu:SetFrameStrata("TOOLTIP")
    menu:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    menu:SetBackdropColor(0.055, 0.055, 0.07, 0.98)
    menu:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)
    menu:EnableMouse(true)
    menu:Hide()
    menu:SetScript("OnHide", function()
        if overlay then overlay:Hide() end
    end)

    menu.buttons = {}
    for index, entry in ipairs(VIEWS) do
        local button = CreateFrame("Button", nil, menu)
        button:SetHeight(20)
        button:SetPoint("TOPLEFT", menu, "TOPLEFT", 1, -((index - 1) * 20 + 4))
        button:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -1, -((index - 1) * 20 + 4))

        local background = button:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints()
        background:SetColorTexture(1, 1, 1, 0.08)
        background:Hide()
        button.background = background

        local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("LEFT", button, "LEFT", 8, 0)
        text:SetJustifyH("LEFT")
        text:SetText(entry.label)
        button.text = text

        button:SetScript("OnEnter", function(self)
            self.background:Show()
        end)
        button:SetScript("OnLeave", function(self)
            self.background:Hide()
        end)
        button:SetScript("OnClick", function()
            SelectView(entry.id)
            HideMenu()
        end)

        menu.buttons[index] = button
    end

    menu:SetWidth(190)
    menu:SetHeight(8 + (#VIEWS * 20))
    return menu
end

local function ShowMenu()
    local frame = CreateMenu()

    for index, entry in ipairs(VIEWS) do
        local button = frame.buttons[index]
        local selected = entry.id == currentView
        button.text:SetTextColor(selected and 1 or 0.7, selected and 0.82 or 0.7, selected and 0 or 0.7)
        button.background:Hide()
    end

    local x, y = dropdown:GetLeft(), dropdown:GetBottom()
    if not x or not y then return end
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y - 2)
    overlay:Show()
    frame:Show()
end

local function CreatePanel(parent)
    if panel then return panel end

    panel = CreateFrame("Frame", nil, parent)

    dropdown = CreateFrame("Button", nil, panel, "BackdropTemplate")
    dropdown:SetSize(190, 22)
    dropdown:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    dropdown:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    dropdown:SetBackdropColor(0.08, 0.08, 0.1, 1)
    dropdown:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)

    dropdownLabel = dropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    dropdownLabel:SetPoint("LEFT", dropdown, "LEFT", 8, 0)
    dropdownLabel:SetPoint("RIGHT", dropdown, "RIGHT", -20, 0)
    dropdownLabel:SetJustifyH("LEFT")
    dropdownLabel:SetText(VIEW_LABEL[currentView])

    local arrow = dropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    arrow:SetPoint("RIGHT", dropdown, "RIGHT", -8, 0)
    arrow:SetText("v")

    dropdown:SetScript("OnClick", function()
        if menu and menu:IsShown() then
            HideMenu()
        else
            ShowMenu()
        end
    end)
    dropdown:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.5, 0.5, 0.58, 1)
    end)
    dropdown:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)
    end)

    subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    subtitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 2, -28)
    subtitle:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -2, -28)
    subtitle:SetJustifyH("LEFT")
    subtitle:SetWordWrap(false)

    scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -46)
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

    emptyLabel = content:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    emptyLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 2, -2)
    emptyLabel:SetWidth(240)
    emptyLabel:SetJustifyH("LEFT")

    panel:SetScript("OnShow", function()
        Refresh()
        if scroll then scroll:SetVerticalScroll(0) end
    end)
    panel:SetScript("OnHide", HideMenu)

    return panel
end

-- Item info arrives asynchronously. Rebuild the auction ranking once the
-- client has it, throttled so a big loot list doesn't refresh per item.
local itemEventFrame = CreateFrame("Frame")
itemEventFrame:Show()
for _, event in ipairs({ "GET_ITEM_INFO_RECEIVED", "ITEM_DATA_LOAD_RESULT" }) do
    pcall(itemEventFrame.RegisterEvent, itemEventFrame, event)
end

local refreshQueued = false

itemEventFrame:SetScript("OnEvent", function(_, _, itemID)
    if panel and panel:IsShown() and currentView == "auction" then
        auctionCache = {}
        refreshQueued = true
    end
end)

itemEventFrame:SetScript("OnUpdate", function(self, elapsed)
    if not refreshQueued then return end
    self.refreshElapsed = (self.refreshElapsed or 0) + elapsed
    if self.refreshElapsed < 0.15 then return end
    self.refreshElapsed = 0
    refreshQueued = false
    if panel and panel:IsShown() and currentView == "auction" then
        Refresh()
    end
end)

KKK.KillStats = {
    OnDataChanged = function()
        if panel and panel:IsShown() then
            Refresh()
        end
    end,
}

if KwaLite and KwaLite.RegisterAddon then
    KwaLite:RegisterAddon({
        id = "KwaKillStats",
        name = "Kill Counter",
        icon = "Interface\\Icons\\INV_Misc_Bone_01",
        priority = 4,
        createPanel = CreatePanel,
        refresh = function() Refresh() end,
        showMinimizedByDefault = false,
    })
end
