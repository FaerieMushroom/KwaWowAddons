local addonName, KAT = ...

-- This plugin is optional: it only loads when both KwaLite and Auctionator are
-- available. OptionalDeps in the .toc makes Auctionator load first when present.
if not (KwaLite and KwaLite.RegisterAddon and KwaLite.Util) then
    return
end
if not (Auctionator and Auctionator.API and Auctionator.API.v1) then
    return
end

local Util = KwaLite.Util
local SafeCall = Util.SafeCall
local RequestItemData = Util.RequestItemData
local ColorName = Util.ColorName

local function FetchItemMeta(itemID)
    local meta = Util.UpdateItemMeta(itemID)
    if not meta.name then return nil end
    return meta
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

local detailFrame
local detailBack
local detailIcon
local detailName
local detailStats = {}
local graphFrame
local graphLines = {}
local graphLabels = {}
local graphLineCount = 0
local graphPoints = {}
local HideGraphHover
local selectedItemID
local detailMode = false

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
local ShowDetail
local RefreshDetail

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

local function GetPriceHistoryData(dbKey)
    local history = {}
    local db = GetPriceDB()
    local entry = db and dbKey and db[dbKey]

    local database = Auctionator and Auctionator.Database
    if database and type(database.GetPriceHistory) == "function" then
        local list = SafeCall(database.GetPriceHistory, database, dbKey)
        if type(list) == "table" then
            for _, point in ipairs(list) do
                local minSeen = tonumber(point.minSeen)
                local maxSeen = tonumber(point.maxSeen)
                if minSeen and maxSeen then
                    history[#history + 1] = {
                        date = point.date,
                        day = tonumber(point.rawDay),
                        minSeen = minSeen,
                        maxSeen = maxSeen,
                        available = point.available,
                    }
                end
            end
        end
    end

    -- Older Auctionator builds have the stored day tables but no
    -- GetPriceHistory helper, so reconstruct the same points from l/h.
    if #history == 0 and type(entry) == "table" and type(entry.h) == "table" then
        local days = {}
        for day in pairs(entry.h) do
            local numericDay = tonumber(day)
            if numericDay then days[#days + 1] = numericDay end
        end
        table.sort(days)
        for _, day in ipairs(days) do
            local high = tonumber(entry.h[day]) or tonumber(entry.h[tostring(day)])
            local low = type(entry.l) == "table"
                and (tonumber(entry.l[day]) or tonumber(entry.l[tostring(day)]))
                or high
            if high and low then
                local date
                local constants = Auctionator and Auctionator.Constants
                local utilities = Auctionator and Auctionator.Utilities
                if constants and constants.SCAN_DAY_0 and utilities and utilities.PrettyDate then
                    date = SafeCall(utilities.PrettyDate, day * 86400 + constants.SCAN_DAY_0)
                end
                history[#history + 1] = {
                    date = date or ("Day " .. tostring(day)),
                    day = day,
                    minSeen = low,
                    maxSeen = high,
                }
            end
        end
    end

    table.sort(history, function(a, b)
        if a.day and b.day and a.day ~= b.day then return a.day < b.day end
        return tostring(a.date or "") < tostring(b.date or "")
    end)

    return history, entry
end

local FormatMoney = Util.FormatMoney

local function FormatPrice(price)
    if type(price) ~= "number" then return "|cff9d9d9d--|r" end
    return FormatMoney(price)
end

local function NextGraphLine()
    if not graphFrame then return nil end
    graphLineCount = graphLineCount + 1
    local line = graphLines[graphLineCount]
    if not line then
        line = graphFrame:CreateLine(nil, "ARTWORK", nil, 1)
        graphLines[graphLineCount] = line
    end
    line:Show()
    return line
end

local function DrawGraphSegment(x1, y1, x2, y2, r, g, b, a, thickness)
    local line = NextGraphLine()
    if not line then return end
    line:SetColorTexture(r, g, b, a)
    line:SetThickness(thickness or 1)
    line:SetStartPoint("BOTTOMLEFT", graphFrame, x1, y1)
    line:SetEndPoint("BOTTOMLEFT", graphFrame, x2, y2)
end

local function SetGraphLabel(label, text)
    if not label then return end
    label:SetText(text or "")
    label:SetShown(text ~= nil and text ~= "")
end

local function DrawGraph(history)
    if not graphFrame then return end

    graphLineCount = 0
    graphPoints = {}
    if HideGraphHover then HideGraphHover() end
    if not history or #history == 0 then
        graphFrame.empty:Show()
        SetGraphLabel(graphLabels.maximum, nil)
        SetGraphLabel(graphLabels.minimum, nil)
        SetGraphLabel(graphLabels.firstDate, nil)
        SetGraphLabel(graphLabels.lastDate, nil)
        for index = graphLineCount + 1, #graphLines do
            graphLines[index]:Hide()
        end
        return
    end

    graphFrame.empty:Hide()

    local width = graphFrame:GetWidth() or 0
    local height = graphFrame:GetHeight() or 0
    if width < 60 then width = 250 end
    if height < 80 then height = 180 end

    local left, right = 8, width - 8
    local bottom, top = 18, height - 24
    if right <= left or top <= bottom then return end

    local minValue, maxValue = history[1].minSeen, history[1].maxSeen
    for _, point in ipairs(history) do
        if point.minSeen < minValue then minValue = point.minSeen end
        if point.maxSeen > maxValue then maxValue = point.maxSeen end
    end

    local span = maxValue - minValue
    if span <= 0 then span = math.max(1, maxValue * 0.1) end
    local axisMin = math.max(0, minValue - span * 0.08)
    local axisMax = maxValue + span * 0.08
    if axisMax <= axisMin then axisMax = axisMin + 1 end

    local function XFor(index)
        if #history == 1 then return (left + right) / 2 end
        return left + ((index - 1) / (#history - 1)) * (right - left)
    end

    local function YFor(value)
        return bottom + ((value - axisMin) / (axisMax - axisMin)) * (top - bottom)
    end

    graphFrame.plotLeft = left
    graphFrame.plotRight = right
    graphFrame.plotBottom = bottom
    graphFrame.plotTop = top

    for index, point in ipairs(history) do
        graphPoints[index] = {
            x = XFor(index),
            yMin = YFor(point.minSeen),
            yMax = YFor(point.maxSeen),
            minSeen = point.minSeen,
            maxSeen = point.maxSeen,
            date = point.date,
        }
    end

    -- Horizontal grid.
    for _, fraction in ipairs({ 0, 0.5, 1 }) do
        local y = bottom + fraction * (top - bottom)
        DrawGraphSegment(left, y, right, y, 1, 1, 1, 0.06, 1)
    end

    -- The daily min/max range, then the low and high trends over it.
    for index, point in ipairs(history) do
        local x = XFor(index)
        DrawGraphSegment(x, YFor(point.minSeen), x, YFor(point.maxSeen), 1, 1, 1, 0.16, 3)
    end

    if #history == 1 then
        local x = XFor(1)
        DrawGraphSegment(x - 3, YFor(history[1].minSeen), x + 3, YFor(history[1].minSeen),
            0.35, 0.85, 0.45, 1, 1.5)
        DrawGraphSegment(x - 3, YFor(history[1].maxSeen), x + 3, YFor(history[1].maxSeen),
            1, 0.8, 0.2, 1, 1.5)
    else
        for index = 1, #history - 1 do
            local current, nextPoint = history[index], history[index + 1]
            local x1, x2 = XFor(index), XFor(index + 1)
            DrawGraphSegment(x1, YFor(current.minSeen), x2, YFor(nextPoint.minSeen),
                0.35, 0.85, 0.45, 1, 1.5)
            DrawGraphSegment(x1, YFor(current.maxSeen), x2, YFor(nextPoint.maxSeen),
                1, 0.8, 0.2, 1, 1.5)
        end
    end

    for index = graphLineCount + 1, #graphLines do
        graphLines[index]:Hide()
    end

    SetGraphLabel(graphLabels.maximum, FormatPrice(math.floor(axisMax)))
    SetGraphLabel(graphLabels.minimum, FormatPrice(math.floor(axisMin)))
    SetGraphLabel(graphLabels.firstDate, tostring(history[1].date or ""))
    SetGraphLabel(graphLabels.lastDate, tostring(history[#history].date or ""))
end

local function SetLabel(fontString, label, value)
    fontString:SetText("|cff9d9d9d" .. label .. ":|r " .. FormatPrice(value))
end

local function UpdateContentWidth()
    Util.FitContentWidth(scroll, content, panel, 24, 220)
end

local function CreateDetailPage()
    if detailFrame then return end

    detailFrame = CreateFrame("Frame", nil, panel)
    detailFrame:SetAllPoints(panel)
    detailFrame:Hide()

    local header = CreateFrame("Frame", nil, detailFrame)
    header:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 0, 0)
    header:SetPoint("TOPRIGHT", detailFrame, "TOPRIGHT", 0, 0)
    header:SetHeight(34)

    detailBack = CreateFrame("Button", nil, header, "UIPanelButtonTemplate")
    detailBack:SetSize(22, 20)
    detailBack:SetPoint("TOPLEFT", header, "TOPLEFT", 0, -2)
    detailBack:SetText("<")
    detailBack:SetScript("OnClick", function()
        detailMode = false
        selectedItemID = nil
        detailFrame:Hide()
        searchFrame:Show()
        statusLabel:Show()
        scroll:Show()
        RunSearch()
    end)
    detailBack:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Back to results", 1, 0.82, 0)
        GameTooltip:Show()
    end)
    detailBack:SetScript("OnLeave", function() GameTooltip:Hide() end)

    detailIcon = header:CreateTexture(nil, "ARTWORK")
    detailIcon:SetSize(30, 30)
    detailIcon:SetPoint("TOPLEFT", header, "TOPLEFT", 28, -2)
    detailIcon:SetTexture(Util.DEFAULT_ICON)
    detailIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    detailName = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    detailName:SetPoint("LEFT", detailIcon, "RIGHT", 6, 0)
    detailName:SetPoint("RIGHT", header, "RIGHT", -4, 0)
    detailName:SetJustifyH("LEFT")
    detailName:SetWordWrap(false)

    local statsFrame = CreateFrame("Frame", nil, detailFrame)
    statsFrame:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 0, -38)
    statsFrame:SetPoint("TOPRIGHT", detailFrame, "TOPRIGHT", 0, -38)
    statsFrame:SetHeight(40)

    detailStats.recent = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    detailStats.recent:SetPoint("TOPLEFT", statsFrame, "TOPLEFT", 0, 0)
    detailStats.recent:SetJustifyH("LEFT")

    detailStats.average = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    detailStats.average:SetPoint("TOPRIGHT", statsFrame, "TOPRIGHT", -4, 0)
    detailStats.average:SetJustifyH("RIGHT")

    detailStats.low = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    detailStats.low:SetPoint("TOPLEFT", statsFrame, "TOPLEFT", 0, -20)
    detailStats.low:SetJustifyH("LEFT")

    detailStats.high = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    detailStats.high:SetPoint("TOPRIGHT", statsFrame, "TOPRIGHT", -4, -20)
    detailStats.high:SetJustifyH("RIGHT")

    graphFrame = CreateFrame("Frame", nil, detailFrame, "BackdropTemplate")
    graphFrame:SetPoint("TOPLEFT", detailFrame, "TOPLEFT", 0, -84)
    graphFrame:SetPoint("TOPRIGHT", detailFrame, "TOPRIGHT", -4, -84)
    graphFrame:SetHeight(190)
    graphFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    graphFrame:SetBackdropColor(0.05, 0.05, 0.07, 0.9)
    graphFrame:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)

    graphLabels.title = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    graphLabels.title:SetPoint("TOPLEFT", graphFrame, "TOPLEFT", 5, -3)
    graphLabels.title:SetText("Price history")

    graphLabels.lowLegend = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    graphLabels.lowLegend:SetPoint("TOPLEFT", graphFrame, "TOPLEFT", 82, -3)
    graphLabels.lowLegend:SetText("Low")
    graphLabels.lowLegend:SetTextColor(0.35, 0.85, 0.45)

    graphLabels.highLegend = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    graphLabels.highLegend:SetPoint("TOPLEFT", graphFrame, "TOPLEFT", 110, -3)
    graphLabels.highLegend:SetText("Max")
    graphLabels.highLegend:SetTextColor(1, 0.8, 0.2)

    graphLabels.maximum = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    graphLabels.maximum:SetPoint("TOPRIGHT", graphFrame, "TOPRIGHT", -5, -3)
    graphLabels.maximum:SetJustifyH("RIGHT")

    graphLabels.minimum = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    graphLabels.minimum:SetPoint("BOTTOMLEFT", graphFrame, "BOTTOMLEFT", 5, 14)

    graphLabels.firstDate = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    graphLabels.firstDate:SetPoint("BOTTOMLEFT", graphFrame, "BOTTOMLEFT", 5, 2)

    graphLabels.lastDate = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    graphLabels.lastDate:SetPoint("BOTTOMRIGHT", graphFrame, "BOTTOMRIGHT", -5, 2)
    graphLabels.lastDate:SetJustifyH("RIGHT")

    graphFrame.empty = graphFrame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    graphFrame.empty:SetPoint("CENTER", graphFrame, "CENTER", 0, 0)
    graphFrame.empty:SetText("No price history stored")
    graphFrame.empty:Hide()

    graphFrame.hoverLine = graphFrame:CreateLine(nil, "ARTWORK", nil, 3)
    graphFrame.hoverLine:SetColorTexture(1, 1, 1, 0.35)
    graphFrame.hoverLine:SetThickness(1)
    graphFrame.hoverLine:Hide()

    graphFrame.hoverLow = graphFrame:CreateTexture(nil, "ARTWORK", nil, 4)
    graphFrame.hoverLow:SetSize(6, 6)
    graphFrame.hoverLow:SetColorTexture(0.35, 0.85, 0.45, 1)
    graphFrame.hoverLow:Hide()

    graphFrame.hoverHigh = graphFrame:CreateTexture(nil, "ARTWORK", nil, 4)
    graphFrame.hoverHigh:SetSize(6, 6)
    graphFrame.hoverHigh:SetColorTexture(1, 0.8, 0.2, 1)
    graphFrame.hoverHigh:Hide()

    HideGraphHover = function()
        if not graphFrame then return end
        graphFrame.hoverIndex = nil
        if graphFrame.hoverLine then graphFrame.hoverLine:Hide() end
        if graphFrame.hoverLow then graphFrame.hoverLow:Hide() end
        if graphFrame.hoverHigh then graphFrame.hoverHigh:Hide() end
        GameTooltip:Hide()
    end

    graphFrame.hover = CreateFrame("Frame", nil, graphFrame)
    graphFrame.hover:SetAllPoints(graphFrame)
    graphFrame.hover:EnableMouse(true)
    graphFrame.hover:SetFrameLevel(graphFrame:GetFrameLevel() + 3)

    local function UpdateGraphHover()
        if not graphFrame.hovered then return end
        if #graphPoints == 0 then HideGraphHover() return end

        local scale = graphFrame.hover:GetEffectiveScale() or 1
        local cursorX, cursorY = GetCursorPosition()
        local left, bottom = graphFrame.hover:GetLeft(), graphFrame.hover:GetBottom()
        if not (cursorX and cursorY and left and bottom) then return end

        local x = cursorX / scale - left
        local y = cursorY / scale - bottom
        local plotLeft = graphFrame.plotLeft or 0
        local plotRight = graphFrame.plotRight or 0
        local plotBottom = graphFrame.plotBottom or 0
        local plotTop = graphFrame.plotTop or 0
        if x < plotLeft - 4 or x > plotRight + 4
            or y < plotBottom - 6 or y > plotTop + 6 then
            HideGraphHover()
            return
        end

        local index, best
        for pointIndex, point in ipairs(graphPoints) do
            local distance = math.abs(point.x - x)
            if not best or distance < best then
                best = distance
                index = pointIndex
            end
        end
        if not index then HideGraphHover() return end
        if graphFrame.hoverIndex == index then return end
        graphFrame.hoverIndex = index

        local point = graphPoints[index]
        graphFrame.hoverLine:SetStartPoint("BOTTOMLEFT", graphFrame, point.x, plotBottom)
        graphFrame.hoverLine:SetEndPoint("BOTTOMLEFT", graphFrame, point.x, plotTop)
        graphFrame.hoverLine:Show()

        graphFrame.hoverLow:ClearAllPoints()
        graphFrame.hoverLow:SetPoint("CENTER", graphFrame, "BOTTOMLEFT", point.x, point.yMin)
        graphFrame.hoverLow:Show()

        graphFrame.hoverHigh:ClearAllPoints()
        graphFrame.hoverHigh:SetPoint("CENTER", graphFrame, "BOTTOMLEFT", point.x, point.yMax)
        graphFrame.hoverHigh:Show()

        GameTooltip:SetOwner(graphFrame.hover, "ANCHOR_CURSOR")
        GameTooltip:ClearLines()
        GameTooltip:AddLine(tostring(point.date or "Price history"), 1, 0.82, 0)
        GameTooltip:AddDoubleLine("Low:", FormatPrice(point.minSeen),
            0.9, 0.9, 0.9, 0.35, 0.85, 0.45)
        GameTooltip:AddDoubleLine("Max:", FormatPrice(point.maxSeen),
            0.9, 0.9, 0.9, 1, 0.8, 0.2)
        GameTooltip:Show()
    end

    graphFrame.hover:SetScript("OnEnter", function()
        graphFrame.hovered = true
        graphFrame.hoverIndex = nil
        UpdateGraphHover()
    end)
    graphFrame.hover:SetScript("OnLeave", function()
        graphFrame.hovered = false
        HideGraphHover()
    end)
    graphFrame.hover:SetScript("OnUpdate", function()
        if graphFrame.hovered then UpdateGraphHover() end
    end)

    detailFrame:SetScript("OnHide", function()
        graphFrame.hovered = false
        if HideGraphHover then HideGraphHover() end
    end)
end

RefreshDetail = function()
    if not detailFrame or not selectedItemID then return end

    local meta = itemMeta[selectedItemID]
    detailIcon:SetTexture((meta and meta.icon) or Util.DEFAULT_ICON)
    detailName:SetText(meta and ColorName(meta.name, meta.quality) or ("Item " .. tostring(selectedItemID)))

    local dbKey = itemKey[selectedItemID]
    local info = dbKey and GetItemPriceInfo(dbKey)
    if info then
        detailStats.recent:SetText("|cff9d9d9dRecent:|r " .. FormatPrice(info.value))
        detailStats.average:SetText("|cff9d9d9dAvg:|r " .. FormatPrice(info.average))
        detailStats.low:SetText("|cff9d9d9dLow:|r " .. FormatPrice(info.lowest))
        detailStats.high:SetText("|cff9d9d9dHigh:|r " .. FormatPrice(info.highest))
    else
        detailStats.recent:SetText("|cff9d9d9dRecent:|r --")
        detailStats.average:SetText("|cff9d9d9dAvg:|r --")
        detailStats.low:SetText("|cff9d9d9dLow:|r --")
        detailStats.high:SetText("|cff9d9d9dHigh:|r --")
    end

    local history = dbKey and GetPriceHistoryData(dbKey) or nil
    DrawGraph(history)
end

ShowDetail = function(itemID)
    if not itemID or not detailFrame then return end

    selectedItemID = itemID
    detailMode = true
    searchFrame:Hide()
    statusLabel:Hide()
    scroll:Hide()
    GameTooltip:Hide()
    detailFrame:Show()
    RefreshDetail()
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
    row.icon:SetTexture(Util.DEFAULT_ICON)
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
        local meta = itemMeta[self.itemID]
        Util.ShowItemTooltip(self, self.itemID, meta and meta.link)
        GameTooltip:Show()
    end)

    row:SetScript("OnLeave", function()
        Util.HideTooltip()
    end)

    row:SetScript("OnClick", function(self)
        if not self.itemID then return end
        local meta = itemMeta[self.itemID]
        if IsShiftKeyDown and IsShiftKeyDown() and meta and meta.link
            and ChatEdit_InsertLink then
            pcall(ChatEdit_InsertLink, meta.link)
            return
        end
        ShowDetail(self.itemID)
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

local function ShowResults(results, totalMatches)
    resultCount = #results
    totalMatches = totalMatches or resultCount

    for index = 1, MAX_RESULTS do
        local row = rows[index]
        if index <= resultCount then
            local itemID = results[index]
            local meta = itemMeta[itemID]
            local info = itemID and GetItemPriceInfo(itemKey[itemID])

            row = row or GetRow(index)
            row.itemID = itemID
            row.icon:SetTexture((meta and meta.icon) or Util.DEFAULT_ICON)
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

    if resolveHead <= #resolveQueue then
        -- Item names are still loading. Say so instead of letting the list look
        -- complete (and possibly empty) while later items can still match.
        if resultCount >= MAX_RESULTS then
            statusLabel:SetText("|cff9d9d9dSearching... showing first " .. MAX_RESULTS .. " so far|r")
        else
            statusLabel:SetText("|cff9d9d9dSearching items... " .. resultCount .. " found so far|r")
        end
    elseif resultCount == 0 then
        statusLabel:SetText("|cff9d9d9dNo matching items with Auctionator prices|r")
    elseif totalMatches > resultCount then
        statusLabel:SetText("|cff9d9d9dShowing " .. resultCount .. " of " .. totalMatches .. " results|r")
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

    local matches = {}
    for index = 1, #indexIDs do
        local itemID = indexIDs[index]
        local meta = itemMeta[itemID]
        if meta and meta.nameLower then
            local name = meta.nameLower
            local rank
            if name == query then
                rank = 1
            elseif name:sub(1, #query) == query then
                rank = 2
            elseif name:find(query, 1, true) then
                rank = 3
            end
            if rank then
                matches[#matches + 1] = {
                    itemID = itemID,
                    rank = rank,
                    name = name,
                }
            end
        end
    end

    -- Database iteration order is not stable. Rank exact, then prefix, then
    -- substring matches, and break ties by name so the same query always shows
    -- the same top results.
    table.sort(matches, function(a, b)
        if a.rank ~= b.rank then return a.rank < b.rank end
        if a.name ~= b.name then return a.name < b.name end
        return a.itemID < b.itemID
    end)

    local results = {}
    for index = 1, math.min(#matches, MAX_RESULTS) do
        results[#results + 1] = matches[index].itemID
    end

    ShowResults(results, #matches)
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

    scroll, content = Util.CreateScrollPanel(panel, { top = 41 })

    CreateDetailPage()

    panel:SetScript("OnShow", function()
        -- Rebuild on each open so items that were not in the local item cache
        -- last time can be resolved and appear in search results.
        indexDirty = true
        BuildIndex()
        UpdateContentWidth()
        if detailMode and selectedItemID then
            RefreshDetail()
        elseif searchBox and (searchBox:GetText() or "") ~= "" then
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

    -- Refresh after every resolved chunk, not just when the whole queue is
    -- done, so newly resolvable items show up while the rest still load.
    if needsResolveRefresh then
        needsResolveRefresh = false
        if panel and panel:IsShown() then
            if detailMode and selectedItemID then
                RefreshDetail()
            elseif currentQuery ~= "" then
                RunSearch()
            end
        end
    end

    if resolveHead > #resolveQueue then
        resolveQueue = {}
        resolveHead = 1
    end
end)

local function QueueItemForResolve(itemID)
    if type(itemID) ~= "number" then return end
    -- Also requeue items that are in the price index but still unresolved;
    -- GET_ITEM_INFO_RECEIVED is how a failed first lookup gets retried.
    if itemMeta[itemID] or not indexSeen[itemID] then return end
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
            if detailMode and selectedItemID then
                RefreshDetail()
            elseif currentQuery ~= "" then
                RunSearch()
            end
        end
    end
end)

-- Auctionator fires this after a scan or after its price database changes.
pcall(Auctionator.API.v1.RegisterForDBUpdate, "KwaAuctionSearch", function()
    indexDirty = true
    if panel and panel:IsShown() then
        BuildIndex()
        if detailMode and selectedItemID then
            RefreshDetail()
        elseif currentQuery ~= "" then
            RunSearch()
        end
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
            if detailMode and selectedItemID then
                RefreshDetail()
            elseif currentQuery ~= "" then
                RunSearch()
            end
        end
    end,
})
