local addonName, KKK = ...

local GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
local GetCoinTextureString = (C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString) or GetCoinTextureString

local Tracker = {}
KKK.Tracker = Tracker

local FRAME_WIDTH = 292
local FRAME_HEIGHT = 458
local HEADER_HEIGHT = 50
local ITEM_HEIGHT = 15
local EMPTY_HEIGHT = 18
local ROW_GAP = 4

local frame
local content
local scroll
local checkbox
local checkLabel
local totalsLabel
local emptyLabel
local contextMenu
local contextOverlay
local titleBar
local titleText
local closeButton
local minimizeButton
local expandButton
local minimizedLabel
local footer
local minimized = false

local MINIMIZED_WIDTH = FRAME_WIDTH
local MINIMIZED_HEIGHT = 28
local MINIMIZED_MIN_WIDTH = 140
local MINIMIZED_MAX_WIDTH = 340

local sessionView = true
local pendingMerge = nil
local merges = {}
local entryPool = {}
local auctionCache = {}

local HandleEntryClick
local Refresh

local function EnsureDB()
    if type(KwaTrackerDB) ~= "table" then
        KwaTrackerDB = {}
    end
    return KwaTrackerDB
end

local function SaveMerges()
    local db = EnsureDB()
    local saved = {}
    for _, group in ipairs(merges) do
        local members = {}
        for id in pairs(group.members or {}) do
            members[tostring(id)] = true
        end
        if next(members) then
            local rep = group.rep and tostring(group.rep)
            if not rep or not members[rep] then rep = next(members) end
            saved[#saved + 1] = { rep = rep, members = members }
        end
    end
    db.merges = saved
end

local function LoadMerges()
    merges = {}
    local db = EnsureDB()
    if type(db.merges) ~= "table" then return end

    for _, group in ipairs(db.merges) do
        if type(group) == "table" and type(group.members) == "table" then
            local members = {}
            for id in pairs(group.members) do
                members[tostring(id)] = true
            end
            if next(members) then
                local rep = group.rep and tostring(group.rep)
                if not rep or not members[rep] then rep = next(members) end
                merges[#merges + 1] = { rep = rep, members = members }
            end
        end
    end
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

local function ColorItemName(name, quality)
    local qualityColor = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality or 1]
    local color = qualityColor and qualityColor.color
    if color and color.WrapTextInColorCode then
        local ok, text = pcall(color.WrapTextInColorCode, color, name)
        if ok and text then return text end
    end
    return name
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

local function HasAuctionData()
    return KKK.HasAuctionator and KKK.HasAuctionator() or false
end

local function SumAuction(items)
    if not HasAuctionData() then return 0 end

    local total = 0
    for itemID, count in pairs(items or {}) do
        count = tonumber(count) or 0
        local price = AuctionFor(itemID)
        if price <= 0 then
            -- No auction data for this item: fall back to what the vendor pays
            -- so the auction side still reflects its value.
            local numericID = tonumber(itemID)
            if numericID then
                local _, _, _, _, _, _, _, _, _, _, sellPrice = GetItemInfo(numericID)
                price = sellPrice or 0
            end
        end
        total = total + (price * count)
    end
    return total
end

local function AddDoubleLine(tooltip, left, right)
    tooltip:AddDoubleLine(left, right, 0.9, 0.9, 0.9, 1, 1, 1)
end

local function ShowItemTooltip(row)
    local item = row.itemData
    if not item then return end

    local tooltip = GameTooltip
    tooltip:SetOwner(row, "ANCHOR_RIGHT")

    local link = item.link
    if not link and item.idNum then
        local _, itemLink = GetItemInfo(item.idNum)
        link = itemLink
    end

    if link then
        local ok = pcall(tooltip.SetHyperlink, tooltip, link)
        if not ok then
            tooltip:AddLine(item.name or ("Item " .. tostring(item.id)), 1, 1, 1)
        end
    else
        tooltip:AddLine(item.name or ("Item " .. tostring(item.id)), 1, 1, 1)
    end

    local sellPrice = item.sellPrice or 0
    local auctionPrice = item.auctionPrice or 0
    tooltip:AddLine(" ")
    if sellPrice > 0 then
        AddDoubleLine(tooltip, "Vendor each:", FormatMoney(sellPrice))
    end
    if auctionPrice > 0 then
        AddDoubleLine(tooltip, "Auction each:", FormatMoney(auctionPrice))
    end
    AddDoubleLine(tooltip, "Count:", "x" .. tostring(item.count))
    if sellPrice > 0 then
        AddDoubleLine(tooltip, "Vendor total:", FormatMoney(sellPrice * item.count))
    end
    if auctionPrice > 0 then
        AddDoubleLine(tooltip, "Auction total:", FormatMoney(auctionPrice * item.count))
    end
    tooltip:Show()
end

local function ShowMobTooltip(entryWidget)
    local row = entryWidget.rowData
    if not row then return end

    local tooltip = GameTooltip
    tooltip:SetOwner(entryWidget.header, "ANCHOR_RIGHT")
    tooltip:AddLine(row.name or "Unknown mob", 1, 0.82, 0)
    if (row.groupSize or 0) > 1 and row.memberNames then
        tooltip:AddLine("Merged: " .. table.concat(row.memberNames, ", "), 0.6, 0.8, 1, true)
    end
    tooltip:AddLine(" ")
    AddDoubleLine(tooltip, "Kills (session):", tostring(row.sessionKills or 0))
    AddDoubleLine(tooltip, "Kills (total):", tostring(row.totalKills or 0))
    AddDoubleLine(tooltip, "Coin dropped:", FormatMoney(row.coin or 0))
    AddDoubleLine(tooltip, "Vendor total:", FormatMoney(row.vendor or 0))
    if HasAuctionData() then
        AddDoubleLine(tooltip, "Auction total:", FormatMoney(SumAuction(row.items) + (row.coin or 0)))
    end
    tooltip:AddLine(" ")
    tooltip:AddLine("Ctrl+Click to merge", 0.65, 0.65, 0.65)
    tooltip:AddLine("Right-click for menu", 0.65, 0.65, 0.65)
    tooltip:Show()
end

local function FindMergeGroup(id)
    for i = 1, #merges do
        local group = merges[i]
        if group.members[id] then
            return group
        end
    end
end

local function RemoveMergeGroup(group)
    local removed = false
    for i = #merges, 1, -1 do
        if merges[i] == group then
            table.remove(merges, i)
            removed = true
        end
    end
    if removed then SaveMerges() end
end

local function MergeSelection(firstID, secondID)
    local firstGroup = FindMergeGroup(firstID)
    local secondGroup = FindMergeGroup(secondID)
    if firstGroup and firstGroup == secondGroup then return end

    local target
    if firstGroup then
        target = firstGroup
    else
        target = { rep = firstID, members = {} }
        table.insert(merges, target)
    end

    target.members[firstID] = true
    if secondGroup then
        for id in pairs(secondGroup.members) do
            target.members[id] = true
        end
        RemoveMergeGroup(secondGroup)
    else
        target.members[secondID] = true
    end

    SaveMerges()
end

local function BuildItemList(items)
    local list = {}
    for itemID, count in pairs(items or {}) do
        count = tonumber(count) or 0
        if count > 0 then
            local numericID = tonumber(itemID)
            local name, link, quality, _, _, _, _, _, _, texture, sellPrice = GetItemInfo(numericID or itemID)
            list[#list + 1] = {
                id = itemID,
                idNum = numericID,
                name = name,
                link = link,
                quality = quality,
                texture = texture,
                sellPrice = sellPrice or 0,
                auctionPrice = AuctionFor(itemID),
                count = count,
            }
        end
    end

    table.sort(list, function(a, b)
        local aValue = math.max(a.sellPrice or 0, a.auctionPrice or 0) * a.count
        local bValue = math.max(b.sellPrice or 0, b.auctionPrice or 0) * b.count
        if aValue ~= bValue then return aValue > bValue end
        local aName = a.name or tostring(a.id)
        local bName = b.name or tostring(b.id)
        if aName ~= bName then return aName < bName end
        return tostring(a.id) < tostring(b.id)
    end)

    return list
end

local function CreateItemRow(parent, index)
    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(ITEM_HEIGHT)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 6, -HEADER_HEIGHT - ((index - 1) * ITEM_HEIGHT))
    row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -6, -HEADER_HEIGHT - ((index - 1) * ITEM_HEIGHT))

    local background = row:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(1, 1, 1, 0.07)
    background:Hide()
    row.background = background

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(13, 13)
    icon:SetPoint("LEFT", row, "LEFT", 1, 0)
    row.icon = icon

    local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    name:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    name:SetPoint("RIGHT", row, "RIGHT", -38, 0)
    name:SetJustifyH("LEFT")
    row.name = name

    local count = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    count:SetPoint("RIGHT", row, "RIGHT", -2, 0)
    count:SetJustifyH("RIGHT")
    row.count = count

    row:SetScript("OnEnter", function(self)
        self.background:Show()
        ShowItemTooltip(self)
    end)
    row:SetScript("OnLeave", function(self)
        self.background:Hide()
        GameTooltip:Hide()
    end)

    return row
end

local function CreateEntryWidget()
    local entry = CreateFrame("Button", nil, content, "BackdropTemplate")
    entry:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    entry:SetBackdropColor(0, 0, 0, 0.35)
    entry:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)
    entry:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    entry:SetScript("OnClick", function(self, button)
        HandleEntryClick(self, button)
    end)

    local header = CreateFrame("Button", nil, entry)
    header:SetPoint("TOPLEFT", entry, "TOPLEFT", 0, 0)
    header:SetPoint("TOPRIGHT", entry, "TOPRIGHT", 0, 0)
    header:SetHeight(HEADER_HEIGHT)
    header:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    header:SetScript("OnClick", function(_, button)
        HandleEntryClick(entry, button)
    end)
    header:SetScript("OnEnter", function()
        ShowMobTooltip(entry)
    end)
    header:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    entry.header = header

    local name = entry:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    name:SetPoint("TOPLEFT", entry, "TOPLEFT", 7, -5)
    name:SetPoint("TOPRIGHT", entry, "TOPRIGHT", -80, -5)
    name:SetJustifyH("LEFT")
    name:SetWordWrap(false)
    entry.name = name

    local kills = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    kills:SetPoint("TOPRIGHT", entry, "TOPRIGHT", -7, -5)
    kills:SetJustifyH("RIGHT")
    entry.kills = kills

    local vendor = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    vendor:SetPoint("TOPLEFT", entry, "TOPLEFT", 7, -20)
    vendor:SetJustifyH("LEFT")
    entry.vendor = vendor

    local auction = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    auction:SetPoint("TOPRIGHT", entry, "TOPRIGHT", -7, -20)
    auction:SetJustifyH("RIGHT")
    entry.auction = auction

    local coin = entry:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    coin:SetPoint("TOPLEFT", entry, "TOPLEFT", 7, -34)
    coin:SetJustifyH("LEFT")
    entry.coin = coin

    local empty = entry:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    empty:SetPoint("TOPLEFT", entry, "TOPLEFT", 8, -HEADER_HEIGHT - 2)
    empty:SetText("No loot recorded yet")
    entry.emptyLabel = empty

    local outline = CreateFrame("Frame", nil, entry, "BackdropTemplate")
    outline:SetPoint("TOPLEFT", entry, "TOPLEFT", -1, 1)
    outline:SetPoint("BOTTOMRIGHT", entry, "BOTTOMRIGHT", 1, -1)
    outline:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2 })
    outline:SetBackdropBorderColor(0.1, 1, 0.1, 1)
    outline:Hide()
    entry.outline = outline

    entry.itemRows = {}

    return entry
end

local function GetEntry(index)
    local entry = entryPool[index]
    if not entry then
        entry = CreateEntryWidget()
        entryPool[index] = entry
    end
    entry:Show()
    return entry
end

local function BuildSessionSource()
    local list = {}
    local allData = MyKillCountTable or {}

    for id, sessionEntry in pairs(KKK.Session.mobs) do
        local backend = allData[id]
        list[#list + 1] = {
            id = id,
            name = sessionEntry.name or (backend and backend.name) or ("NPC " .. id),
            seq = sessionEntry.seq or 0,
            sessionKills = sessionEntry.kills or 0,
            totalKills = (backend and backend.count) or (sessionEntry.kills or 0),
            items = sessionEntry.items or {},
            vendor = sessionEntry.vendor or 0,
            coin = sessionEntry.coin or 0,
        }
    end

    return list
end

local function BuildOverallSource()
    local list = {}
    local allData = MyKillCountTable or {}

    for id, data in pairs(allData) do
        if type(data) == "table" then
            local sessionEntry = KKK.Session.mobs[id]
            list[#list + 1] = {
                id = id,
                name = data.name or ("NPC " .. id),
                seq = sessionEntry and sessionEntry.seq or 0,
                sessionKills = sessionEntry and sessionEntry.kills or 0,
                totalKills = data.count or 0,
                items = data.itemCounts or data.items or {},
                vendor = data.totalVendorValue or 0,
                coin = data.coin or 0,
            }
        end
    end

    return list
end

local function BuildRows(source)
    local byID = {}
    for _, item in ipairs(source) do
        byID[item.id] = item
    end

    local rows = {}
    local renderedGroups = {}

    for _, item in ipairs(source) do
        local group = FindMergeGroup(item.id)
        if not group then
            rows[#rows + 1] = {
                id = item.id,
                name = item.name,
                seq = item.seq or 0,
                sessionKills = item.sessionKills or 0,
                totalKills = item.totalKills or 0,
                items = item.items or {},
                vendor = item.vendor or 0,
                coin = item.coin or 0,
                groupSize = 0,
                memberIDs = { item.id },
                memberNames = { item.name },
            }
        elseif not renderedGroups[group] then
            renderedGroups[group] = true

            local repItem = byID[group.rep] or item
            local mergedItems = {}
            local memberIDs = {}
            local memberNames = {}
            local vendor = 0
            local coin = 0
            local seq = 0
            local sessionKills = 0
            local totalKills = 0

            for memberID in pairs(group.members) do
                local member = byID[memberID]
                if member then
                    memberIDs[#memberIDs + 1] = memberID
                    memberNames[#memberNames + 1] = member.name
                    if (member.seq or 0) > seq then seq = member.seq end
                    vendor = vendor + (member.vendor or 0)
                    coin = coin + (member.coin or 0)
                    sessionKills = sessionKills + (member.sessionKills or 0)
                    totalKills = totalKills + (member.totalKills or 0)
                    for itemID, count in pairs(member.items or {}) do
                        mergedItems[itemID] = (mergedItems[itemID] or 0) + count
                    end
                end
            end

            if #memberIDs > 0 then
                table.sort(memberNames)
                rows[#rows + 1] = {
                    id = repItem.id,
                    name = repItem.name,
                    seq = seq,
                    sessionKills = sessionKills,
                    totalKills = totalKills,
                    items = mergedItems,
                    vendor = vendor,
                    coin = coin,
                    groupSize = #memberIDs,
                    memberIDs = memberIDs,
                    memberNames = memberNames,
                    group = group,
                }
            end
        end
    end

    table.sort(rows, function(a, b)
        if a.seq ~= b.seq then return a.seq > b.seq end
        if (a.totalKills or 0) ~= (b.totalKills or 0) then
            return (a.totalKills or 0) > (b.totalKills or 0)
        end
        return a.name < b.name
    end)

    return rows
end

local function RenderEntry(entry, row, y)
    entry:ClearAllPoints()
    entry:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
    entry:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
    entry.rowData = row

    local items = BuildItemList(row.items)
    local height = HEADER_HEIGHT + 4
    if #items > 0 then
        height = height + (#items * ITEM_HEIGHT)
        entry.emptyLabel:Hide()
    else
        height = height + EMPTY_HEIGHT
        entry.emptyLabel:Show()
    end
    entry:SetHeight(height)

    local displayName = row.name or "Unknown mob"
    if (row.groupSize or 0) > 1 then
        displayName = displayName .. " |cff66ccff+" .. (row.groupSize - 1) .. "|r"
    end
    entry.name:SetText(displayName)

    local killCount = sessionView and (row.sessionKills or 0) or (row.totalKills or 0)
    entry.kills:SetText("|cff9d9d9dKills:|r " .. tostring(killCount))

    entry.vendor:SetText("|cff9d9d9dVendor:|r " .. FormatMoney(row.vendor or 0))
    if HasAuctionData() then
        entry.auction:SetText("|cff9d9d9dAuction:|r " .. FormatMoney(SumAuction(row.items) + (row.coin or 0)))
        entry.auction:Show()
    else
        entry.auction:Hide()
    end
    entry.coin:SetText("|cff9d9d9dCoin:|r " .. FormatMoney(row.coin or 0))

    for index = 1, #items do
        local itemRow = entry.itemRows[index]
        if not itemRow then
            itemRow = CreateItemRow(entry, index)
            entry.itemRows[index] = itemRow
        end
        itemRow:ClearAllPoints()
        itemRow:SetPoint("TOPLEFT", entry, "TOPLEFT", 6, -HEADER_HEIGHT - ((index - 1) * ITEM_HEIGHT))
        itemRow:SetPoint("TOPRIGHT", entry, "TOPRIGHT", -6, -HEADER_HEIGHT - ((index - 1) * ITEM_HEIGHT))
        itemRow:Show()

        local item = items[index]
        itemRow.itemData = item
        itemRow.icon:SetTexture(item.texture or "Interface\\Icons\\INV_Misc_QuestionMark")
        itemRow.name:SetText(ColorItemName(item.name or ("Item " .. tostring(item.id)), item.quality))
        itemRow.count:SetText("|cff9d9d9dx|r" .. tostring(item.count))
        itemRow.background:Hide()
    end

    for index = #items + 1, #entry.itemRows do
        entry.itemRows[index]:Hide()
    end

    local highlighted = pendingMerge and (row.id == pendingMerge or (row.group and row.group.members[pendingMerge]))
    entry.outline:SetShown(highlighted and true or false)

    return height
end

local function GetRowIDs(row)
    if row.group then
        local ids = {}
        for id in pairs(row.group.members) do
            ids[#ids + 1] = id
        end
        return ids
    end
    return row.memberIDs or { row.id }
end

local function ClearPendingForIDs(ids)
    if not pendingMerge then return end
    for _, id in ipairs(ids) do
        if pendingMerge == id then
            pendingMerge = nil
            return
        end
    end
end

local function ResetSessionRow(row)
    local ids = GetRowIDs(row)
    for _, id in ipairs(ids) do
        KKK.ResetSessionMob(id, true)
    end
    ClearPendingForIDs(ids)
    KKK.NotifyTracker("session-reset")
end

local function ResetKillRow(row)
    local ids = GetRowIDs(row)
    if row.group then
        RemoveMergeGroup(row.group)
    end

    for _, id in ipairs(ids) do
        MyKillCountTable[id] = nil
        KKK.ResetSessionMob(id, true)
    end
    ClearPendingForIDs(ids)
    KKK.NotifyTracker("data-reset")
end

local function UnmergeRow(row)
    if not row.group then return end
    if pendingMerge and row.group.members[pendingMerge] then
        pendingMerge = nil
    end
    RemoveMergeGroup(row.group)
    Refresh()
end

local function HideContextMenu()
    if contextMenu then contextMenu:Hide() end
    if contextOverlay then contextOverlay:Hide() end
end

local function CreateContextMenu()
    if contextMenu then return contextMenu end

    contextOverlay = CreateFrame("Frame", nil, UIParent)
    contextOverlay:SetAllPoints(UIParent)
    contextOverlay:SetFrameStrata("DIALOG")
    contextOverlay:EnableMouse(true)
    contextOverlay:Hide()
    contextOverlay:SetScript("OnMouseDown", function()
        HideContextMenu()
    end)

    contextMenu = CreateFrame("Frame", "KwaLootTrackerContextMenu", UIParent, "BackdropTemplate")
    contextMenu:SetFrameStrata("TOOLTIP")
    contextMenu:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    contextMenu:SetBackdropColor(0.055, 0.055, 0.07, 0.98)
    contextMenu:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)
    contextMenu:EnableMouse(true)
    contextMenu:SetScript("OnHide", function()
        if contextOverlay then contextOverlay:Hide() end
    end)
    contextMenu:Hide()

    contextMenu.buttons = {}
    for index = 1, 3 do
        local button = CreateFrame("Button", nil, contextMenu)
        button:SetHeight(20)
        button:SetPoint("TOPLEFT", contextMenu, "TOPLEFT", 1, -((index - 1) * 20 + 4))
        button:SetPoint("TOPRIGHT", contextMenu, "TOPRIGHT", -1, -((index - 1) * 20 + 4))

        local background = button:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints()
        background:SetColorTexture(1, 1, 1, 0.08)
        background:Hide()
        button.background = background

        local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("LEFT", button, "LEFT", 8, 0)
        text:SetJustifyH("LEFT")
        button.text = text

        button:SetScript("OnEnter", function(self)
            self.background:Show()
        end)
        button:SetScript("OnLeave", function(self)
            self.background:Hide()
        end)
        button:SetScript("OnClick", function(self)
            local action = self.action
            HideContextMenu()
            if action then action() end
        end)

        contextMenu.buttons[index] = button
    end

    return contextMenu
end

local function ShowContextMenu(row)
    local menu = CreateContextMenu()

    local options = {
        { label = "Reset group/kill", action = function() ResetKillRow(row) end },
        { label = "Reset session", action = function() ResetSessionRow(row) end },
    }
    if row.group then
        options[#options + 1] = { label = "Unmerge", action = function() UnmergeRow(row) end }
    end

    for index, button in ipairs(menu.buttons) do
        local option = options[index]
        if option then
            button.action = option.action
            button.text:SetText(option.label)
            button.background:Hide()
            button:Show()
        else
            button.action = nil
            button:Hide()
        end
    end

    menu:SetWidth(150)
    menu:SetHeight(8 + (#options * 20))
    menu:ClearAllPoints()

    local scale = UIParent:GetEffectiveScale() or 1
    local x, y = GetCursorPosition()
    x = (x or 0) / scale
    y = (y or 0) / scale

    local uiWidth = UIParent:GetWidth() or 1920
    if x + 155 > uiWidth then x = uiWidth - 155 end
    if x < 0 then x = 0 end
    if y < menu:GetHeight() + 4 then y = menu:GetHeight() + 4 end

    menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
    contextOverlay:Show()
    menu:Show()
end

HandleEntryClick = function(entryWidget, button)
    local row = entryWidget.rowData
    if not row then return end

    if button == "RightButton" then
        ShowContextMenu(row)
        return
    end

    if not IsControlKeyDown() then
        return
    end

    local clickedID = row.id
    if pendingMerge then
        local sameGroup = (pendingMerge == clickedID) or (row.group and row.group.members[pendingMerge])
        if sameGroup then
            pendingMerge = nil
            Refresh()
            return
        end

        MergeSelection(pendingMerge, clickedID)
        pendingMerge = nil
        Refresh()
    else
        pendingMerge = clickedID
        Refresh()
    end
end

local function SessionTotals()
    local vendor, auction, coin = 0, 0, 0
    local mobs = KKK.Session and KKK.Session.mobs or {}
    for _, entry in pairs(mobs) do
        -- entry.vendor already includes coin drop value, so only add coin to
        -- the auction side here to avoid counting it twice.
        vendor = vendor + (entry.vendor or 0)
        coin = coin + (entry.coin or 0)
        auction = auction + SumAuction(entry.items)
    end
    return vendor, auction + coin
end

local function SourceTotals(source)
    local vendor, auction, coin = 0, 0, 0
    for _, item in ipairs(source or {}) do
        -- As above: vendor totals already contain coin, auction totals do not.
        vendor = vendor + (item.vendor or 0)
        coin = coin + (item.coin or 0)
        auction = auction + SumAuction(item.items)
    end
    return vendor, auction + coin
end

local function UpdateMinimizedSize()
    if not frame or not minimized or not minimizedLabel then return end

    local textWidth = 0
    if minimizedLabel.GetStringWidth then
        local ok, width = pcall(minimizedLabel.GetStringWidth, minimizedLabel)
        if ok and type(width) == "number" then
            textWidth = width
        end
    end
    if textWidth <= 0 then
        local text = minimizedLabel:GetText() or ""
        text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        for line in (text .. "\n"):gmatch("(.-)\n") do
            if #line * 6 > textWidth then textWidth = #line * 6 end
        end
    end

    local width = math.ceil(textWidth + 8 + 4 + 20 + 6)
    if width < MINIMIZED_MIN_WIDTH then width = MINIMIZED_MIN_WIDTH end
    if width > MINIMIZED_MAX_WIDTH then width = MINIMIZED_MAX_WIDTH end
    frame:SetSize(width, MINIMIZED_HEIGHT)
end

local function UpdateMinimizedLabel()
    if minimizedLabel then
        local vendor, auction = SessionTotals()
        local text = "|cff9d9d9dVendor:|r " .. FormatMoney(vendor)
        if HasAuctionData() then
            text = text .. "  |cff9d9d9dAuction:|r " .. FormatMoney(auction)
        end
        minimizedLabel:SetText(text)
        UpdateMinimizedSize()
    end
end

Refresh = function()
    if not frame or not frame:IsShown() then return end
    if minimized then
        UpdateMinimizedLabel()
        return
    end

    auctionCache = {}

    local scrollWidth = scroll:GetWidth()
    if not scrollWidth or scrollWidth < 50 then scrollWidth = FRAME_WIDTH - 16 end
    local rowWidth = scrollWidth - 22
    content:SetWidth(rowWidth)

    local source = sessionView and BuildSessionSource() or BuildOverallSource()
    local totalVendor, totalAuction = SourceTotals(source)
    if totalsLabel then
        local text = "|cff9d9d9dVendor:|r " .. FormatMoney(totalVendor)
        if HasAuctionData() then
            text = text .. "   |cff9d9d9dAuction:|r " .. FormatMoney(totalAuction)
        end
        totalsLabel:SetText(text)
    end

    local rows = BuildRows(source)

    local y = 0
    for index = 1, #rows do
        local entry = GetEntry(index)
        local height = RenderEntry(entry, rows[index], y)
        y = y + height + ROW_GAP
    end

    for index = #rows + 1, #entryPool do
        entryPool[index]:Hide()
    end

    if #rows == 0 then
        emptyLabel:SetWidth(math.max(rowWidth - 12, 50))
        emptyLabel:SetText(sessionView
            and "No mobs killed this session yet.\nKill something to start tracking."
            or "No kills recorded yet.")
        emptyLabel:Show()
        content:SetHeight(50)
    else
        emptyLabel:Hide()
        content:SetHeight(math.max(y, 1))
    end
end

local function SavePosition()
    if not frame then return end
    local point, _, relativePoint, x, y = frame:GetPoint(1)
    if point then
        EnsureDB()
        KwaTrackerDB.position = {
            point = point,
            relativePoint = relativePoint,
            x = x,
            y = y,
        }
    end
end

local function SetMinimized(state)
    if not frame then return end
    minimized = state and true or false

    if minimized then
        frame:SetSize(MINIMIZED_WIDTH, MINIMIZED_HEIGHT)
        if titleText then titleText:Hide() end
        if checkbox then checkbox:Hide() end
        if checkLabel then checkLabel:Hide() end
        if totalsLabel then totalsLabel:Hide() end
        if scroll then scroll:Hide() end
        if footer then footer:Hide() end
        if closeButton then closeButton:Hide() end
        if minimizeButton then minimizeButton:Hide() end
        if expandButton then expandButton:Show() end
        if minimizedLabel then minimizedLabel:Show() end
        UpdateMinimizedLabel()
    else
        frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
        if titleText then titleText:Show() end
        if checkbox then checkbox:Show() end
        if checkLabel then checkLabel:Show() end
        if totalsLabel then totalsLabel:Show() end
        if scroll then scroll:Show() end
        if footer then footer:Show() end
        if closeButton then closeButton:Show() end
        if minimizeButton then minimizeButton:Show() end
        if expandButton then expandButton:Hide() end
        if minimizedLabel then minimizedLabel:Hide() end
        Refresh()
    end
end

local function CreateUI()
    if frame then return frame end

    LoadMerges()

    frame = CreateFrame("Frame", "KwaLootTrackerFrame", UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetFrameStrata("MEDIUM")
    frame:SetToplevel(true)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(0.055, 0.055, 0.07, 0.95)
    frame:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)

    local db = EnsureDB()
    local position = db.position
    if position and position.point then
        frame:SetPoint(position.point, UIParent, position.relativePoint or position.point, position.x or 0, position.y or 0)
    else
        frame:SetPoint("RIGHT", UIParent, "RIGHT", -80, 40)
    end

    titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    titleBar:SetHeight(24)
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
    titleBar:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
        SavePosition()
    end)

    local titleBackground = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBackground:SetAllPoints()
    titleBackground:SetColorTexture(0.10, 0.10, 0.13, 0.95)

    titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("LEFT", titleBar, "LEFT", 8, 0)
    titleText:SetText("|cffffd100Kwa Loot Tracker|r")

    minimizedLabel = titleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    minimizedLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -3)
    minimizedLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, -3)
    minimizedLabel:SetHeight(MINIMIZED_HEIGHT - 6)
    minimizedLabel:SetJustifyH("LEFT")
    minimizedLabel:SetWordWrap(false)
    minimizedLabel:Hide()

    closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    closeButton:SetFrameLevel(frame:GetFrameLevel() + 5)
    closeButton:SetScript("OnClick", function()
        frame:Hide()
    end)

    minimizeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    minimizeButton:SetSize(20, 20)
    minimizeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -34, -3)
    minimizeButton:SetFrameLevel(frame:GetFrameLevel() + 5)
    minimizeButton:SetText("-")
    minimizeButton:SetScript("OnClick", function()
        SetMinimized(true)
    end)

    expandButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    expandButton:SetSize(20, 20)
    expandButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
    expandButton:SetFrameLevel(frame:GetFrameLevel() + 5)
    expandButton:SetText("+")
    expandButton:Hide()
    expandButton:SetScript("OnClick", function()
        SetMinimized(false)
    end)

    checkbox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -28)
    checkbox:SetSize(20, 20)
    checkbox:SetChecked(true)
    checkbox:SetScript("OnClick", function(self)
        sessionView = self:GetChecked() and true or false
        pendingMerge = nil
        checkLabel:SetText(sessionView and "Session loot" or "Overall loot")
        Refresh()
    end)
    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Loot filter", 1, 0.82, 0)
        GameTooltip:AddLine("Checked: loot gained this session only.", 1, 1, 1, true)
        GameTooltip:AddLine("Unchecked: all recorded loot.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    checkbox:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    checkLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    checkLabel:SetPoint("LEFT", checkbox, "RIGHT", 1, 0)
    checkLabel:SetText("Session loot")

    totalsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    totalsLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -52)
    totalsLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -52)
    totalsLabel:SetJustifyH("LEFT")
    totalsLabel:SetWordWrap(false)

    scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -68)
    scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 28)
    if scroll.ScrollBar then
        scroll.ScrollBar:ClearAllPoints()
        scroll.ScrollBar:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", -2, -16)
        scroll.ScrollBar:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", -2, 16)
    end

    content = CreateFrame("Frame", nil, scroll)
    content:SetSize(FRAME_WIDTH - 38, 1)
    scroll:SetScrollChild(content)

    emptyLabel = content:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    emptyLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 6, -6)
    emptyLabel:SetJustifyH("LEFT")
    emptyLabel:SetTextColor(0.6, 0.6, 0.6)

    footer = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    footer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 7)
    footer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 7)
    footer:SetJustifyH("CENTER")
    footer:SetText("Ctrl+Click: merge  |  Right-click: menu")

    frame:SetScript("OnShow", function()
        Refresh()
        if scroll then scroll:SetVerticalScroll(0) end
    end)
    frame:SetScript("OnHide", function()
        HideContextMenu()
    end)
    frame:Hide()

    return frame
end

function Tracker.Refresh()
    if frame and frame:IsShown() then
        Refresh()
    end
end

function Tracker.OnDataChanged(reason)
    if reason == "reset" then
        merges = {}
        pendingMerge = nil
        SaveMerges()
    end
    if frame and frame:IsShown() then
        Refresh()
    end
end

function Tracker.Toggle()
    local f = CreateUI()
    if f:IsShown() then
        f:Hide()
    else
        f:Show()
    end
end

function Tracker.Show()
    local f = CreateUI()
    f:Show()
end

function Tracker.Hide()
    if frame then frame:Hide() end
end

SLASH_KWATRACKER1 = "/kwatracker"
SlashCmdList["KWATRACKER"] = function()
    Tracker.Toggle()
end
