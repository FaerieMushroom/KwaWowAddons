local addonName, KKK = ...

local Util = KwaLite and KwaLite.Util
if not Util then return end

-- Item Lookup plugin: browses every item seen in loot, its drop sources and
-- drop rates, its vendor/auction value, and any known crafting recipes that
-- make or use it.

local GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo

local RECIPE_VERSION = 1
local ROW_HEIGHT = 20
local ICON_SIZE = 16
local DETAIL_VALUE_WIDTH = 105
local MIN_SOURCE_SAMPLES = 5

local SORT_OPTIONS = {
    { id = "drops", label = "Drop count" },
    { id = "alpha", label = "Alphabetical" },
}

local panel
local searchBox
local searchPlaceholder
local clearButton
local browseCount
local sortDropdown
local sortDropdownLabel
local sortMenu
local sortOverlay
local browseScroll
local browseContent
local browseEmpty
local detailHeader
local backButton
local detailIcon
local detailName
local detailValue
local tabButtons
local detailScroll
local detailContent
local detailEmpty

local browseRows = {}
local browseRowCount = 0
local browseResults = {}
local detailRows = {}
local detailRowCount = 0

local mode = "browse"
local detailTab = "sources"
local selectedID
local searchText = ""
local sortMode = "drops"
local auctionCache = {}
local itemInfoCache = {}
local itemIDList
local itemIDDirty = true
local recipeIndex
local recipeScanAt

local UpdateMode
local RefreshBrowse
local RefreshDetail
local StartSearch

local itemLoader

-- Created after IsItemCached is available so it can use it as the cached
-- check when deciding whether an item needs loading.

local function EnsureDB()
    if type(KwaTrackerDB) ~= "table" then KwaTrackerDB = {} end
    if KwaTrackerDB.recipeVersion ~= RECIPE_VERSION
        or type(KwaTrackerDB.recipes) ~= "table" then
        KwaTrackerDB.recipes = {}
        KwaTrackerDB.recipeVersion = RECIPE_VERSION
    end
    return KwaTrackerDB
end

local function FormatMoney(copper)
    copper = math.floor(tonumber(copper) or 0)
    if copper <= 0 then return "0c" end
    return Util.FormatMoney(copper)
end

local function ItemData(itemID)
    itemID = tonumber(itemID)
    if not itemID or not GetItemInfo then return nil end

    local cached = itemInfoCache[itemID]
    if cached then return cached end

    local name, link, quality, _, _, _, _, _, _, texture, sellPrice = GetItemInfo(itemID)
    if not name then return nil end

    local data = {
        name = name,
        link = link,
        quality = quality,
        texture = texture,
        sellPrice = sellPrice,
    }
    itemInfoCache[itemID] = data
    return data
end

local function IsItemCached(itemID)
    if C_Item and C_Item.IsItemDataCachedByID then
        local ok, cached = pcall(C_Item.IsItemDataCachedByID, itemID)
        if ok and cached then return true end
    end
    -- IsItemDataCachedByID is Mainline-only on some clients; fall back to the
    -- plain item lookup so the loader still requests missing items.
    return GetItemInfo and GetItemInfo(itemID) ~= nil or false
end

itemLoader = Util.CreateItemLoader({
    budget = 20,
    interval = 0.25,
    isReady = IsItemCached,
    isActive = function()
        return panel and panel:IsShown() and mode == "browse"
    end,
    onRefresh = function()
        RefreshBrowse(true)
    end,
})

-- Only resolves names for items the client already has, so searching never
-- floods the item cache. Missing items are loaded a few at a time elsewhere.
local function CachedItemData(itemID)
    local cached = itemInfoCache[itemID]
    if cached then return cached end
    if not IsItemCached(itemID) then return nil end
    return ItemData(itemID)
end

local function IconFor(data)
    if data and data.texture and data.texture ~= "" and data.texture ~= 0 then
        return data.texture
    end
    return Util.DEFAULT_ICON
end

local ColoredName = Util.ColorName

-- Item index from the recorded loot table -------------------------------------

local itemIndexCache
local itemIndexDirty = true

local function BuildItemIndex()
    if itemIndexCache and not itemIndexDirty then
        return itemIndexCache
    end

    local index = {}
    local table_ = MyKillCountTable or {}

    for id, data in pairs(table_) do
        if type(data) == "table" and type(data.items) == "table" then
            local samples = data.looted or data.count or 0
            for rawID, drops in pairs(data.items) do
                local itemID = tonumber(rawID) or rawID
                local entry = index[itemID]
                if not entry then
                    entry = { id = itemID, drops = 0, sources = {} }
                    index[itemID] = entry
                end
                local count = tonumber(drops) or 0
                entry.drops = entry.drops + count
                if samples > 0 and count > 0 then
                    entry.sources[#entry.sources + 1] = {
                        name = data.name or ("NPC " .. tostring(id)),
                        drops = count,
                        samples = samples,
                        rate = (count / samples) * 100,
                    }
                end
            end
        end
    end

    for _, entry in pairs(index) do
        table.sort(entry.sources, function(a, b)
            local aKnown = (a.samples or 0) >= MIN_SOURCE_SAMPLES
            local bKnown = (b.samples or 0) >= MIN_SOURCE_SAMPLES
            if aKnown ~= bKnown then return aKnown end
            if a.rate ~= b.rate then return a.rate > b.rate end
            return (a.name or "") < (b.name or "")
        end)
    end

    itemIndexCache = index
    itemIndexDirty = false
    itemIDDirty = true
    return index
end

-- A stable list for the search and the staggered loader. Sorting by drop count
-- here means the incremental search has a predictable order.
local function GetItemIDList()
    if itemIDList and not itemIDDirty then
        return itemIDList
    end

    local index = BuildItemIndex()
    local list = {}
    for itemID, entry in pairs(index) do
        list[#list + 1] = { id = itemID, drops = entry.drops }
    end
    table.sort(list, function(a, b)
        if a.drops ~= b.drops then return a.drops > b.drops end
        return tostring(a.id) < tostring(b.id)
    end)

    itemIDList = list
    itemIDDirty = false
    return list
end

local function CollectItemIDs()
    local list = GetItemIDList()
    local ids = {}
    for index = 1, #list do
        local itemID = list[index].id
        if type(itemID) == "number" then
            ids[#ids + 1] = itemID
        end
    end
    return ids
end

local function ItemName(itemID, info)
    info = info or ItemData(itemID)
    return (info and info.name) or ("Item #" .. tostring(itemID))
end

-- Recipe cache ----------------------------------------------------------------

local function RecipeDB()
    local db = EnsureDB()
    return db.recipes
end

local professionNames = {}

local function ProfessionName(line)
    if not line then return nil end
    if professionNames[line] ~= nil then return professionNames[line] or nil end
    local T = C_TradeSkillUI
    if not T then return nil end
    local name
    if T.GetProfessionInfoBySkillLineID then
        local ok, info = pcall(T.GetProfessionInfoBySkillLineID, line)
        if ok and type(info) == "table" and info.professionName then
            name = info.professionName
        end
    end
    if not name and T.GetTradeSkillDisplayName then
        local ok, value = pcall(T.GetTradeSkillDisplayName, line)
        if ok and type(value) == "string" and value ~= "" then name = value end
    end
    professionNames[line] = name or false
    return name
end

local function RecipeLine(recipeID)
    local T = C_TradeSkillUI
    if not (T and T.GetTradeSkillLineForRecipe) then return nil end
    local ok, line, _, parent = pcall(T.GetTradeSkillLineForRecipe, recipeID)
    if not ok then return nil end
    return (parent and ProfessionName(parent)) or ProfessionName(line)
end

local function ScanRecipes(force)
    local T = C_TradeSkillUI
    if not (T and T.GetAllRecipeIDs and T.GetRecipeInfo) then return end

    local now = GetTime()
    if not force and recipeScanAt and (now - recipeScanAt) < 30 then return end

    local ids = T.GetAllRecipeIDs()
    if type(ids) ~= "table" or #ids == 0 then return end
    recipeScanAt = now

    local recipes = RecipeDB()
    local found = false
    for _, recipeID in ipairs(ids) do
        local ok, info = pcall(T.GetRecipeInfo, recipeID)
        if ok and type(info) == "table" and info.learned then
            local schematic
            if T.GetRecipeSchematic then
                local okS, value = pcall(T.GetRecipeSchematic, recipeID, false)
                if okS and type(value) == "table" then schematic = value end
            end

            local output = schematic and tonumber(schematic.outputItemID) or nil
            local reagents = {}
            if schematic then
                for _, slot in ipairs(schematic.reagentSlotSchematics or {}) do
                    local isBasic
                    local basic = Enum and Enum.CraftingReagentType
                        and Enum.CraftingReagentType.Basic
                    if basic and slot.reagentType ~= nil then
                        isBasic = slot.reagentType == basic
                    else
                        isBasic = slot.required
                    end
                    local reagent = slot.reagents and slot.reagents[1]
                    local required = tonumber(slot.quantityRequired) or 0
                    if isBasic and reagent and reagent.itemID and required > 0 then
                        reagents[#reagents + 1] = { tonumber(reagent.itemID), required }
                    end
                end
            end

            if output or #reagents > 0 then
                found = true
                recipes[tostring(recipeID)] = {
                    name = info.name or ("Recipe " .. tostring(recipeID)),
                    profession = RecipeLine(recipeID),
                    icon = info.icon,
                    output = output,
                    reagents = reagents,
                }
            end
        end
    end

    if found then
        recipeIndex = nil
    end
end

local function GetRecipeIndex()
    if recipeIndex then return recipeIndex end

    local byOutput, byReagent = {}, {}
    for id, recipe in pairs(RecipeDB()) do
        if type(recipe) == "table" then
            local output = tonumber(recipe.output)
            if output then
                local list = byOutput[output]
                if not list then list = {}; byOutput[output] = list end
                list[#list + 1] = { id = id, recipe = recipe }
            end
            for _, reagent in ipairs(recipe.reagents or {}) do
                local itemID = tonumber(reagent[1])
                local count = tonumber(reagent[2]) or 1
                if itemID then
                    local list = byReagent[itemID]
                    if not list then list = {}; byReagent[itemID] = list end
                    list[#list + 1] = { id = id, recipe = recipe, count = count }
                end
            end
        end
    end

    recipeIndex = { byOutput = byOutput, byReagent = byReagent }
    return recipeIndex
end

local function SortRecipeList(list)
    table.sort(list, function(a, b)
        local an = (a.recipe and a.recipe.name) or ""
        local bn = (b.recipe and b.recipe.name) or ""
        if an == bn then return tostring(a.id) < tostring(b.id) end
        return an < bn
    end)
end

-- Row helpers -----------------------------------------------------------------

local function AcquireBrowseRow(index)
    local row = browseRows[index]
    if row then return row end

    row = CreateFrame("Button", nil, browseContent)
    row:SetHeight(ROW_HEIGHT)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(ICON_SIZE, ICON_SIZE)
    row.icon:SetPoint("LEFT", row, "LEFT", 0, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("LEFT", row, "LEFT", ICON_SIZE + 5, 0)
    row.text:SetPoint("RIGHT", row, "RIGHT", -50, 0)
    row.text:SetJustifyH("LEFT")
    row.text:SetWordWrap(false)
    row.value = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.value:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.value:SetJustifyH("RIGHT")

    row.background = Util.AddRowHoverBackground(row)
    row.background:Hide()

    row:SetScript("OnEnter", function(self)
        self.background:Show()
        if self.itemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            local data = ItemData(self.itemID)
            if data and data.link then
                GameTooltip:SetHyperlink(data.link)
            elseif GameTooltip.SetItemByID then
                pcall(GameTooltip.SetItemByID, GameTooltip, self.itemID)
            end
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function(self)
        self.background:Hide()
        GameTooltip:Hide()
    end)
    row:SetScript("OnClick", function(self)
        if self.itemID then
            mode = "detail"
            detailTab = "sources"
            selectedID = self.itemID
            UpdateMode()
            RefreshDetail()
            if detailScroll then detailScroll:SetVerticalScroll(0) end
        end
    end)

    browseRows[index] = row
    return row
end

local function AcquireDetailRow(index)
    local row = detailRows[index]
    if row then return row end

    row = CreateFrame("Frame", nil, detailContent)
    row:EnableMouse(true)
    row:SetHeight(ROW_HEIGHT)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(ICON_SIZE, ICON_SIZE)
    row.icon:SetPoint("LEFT", row, "LEFT", 0, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.icon:Hide()
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
    row.text:SetPoint("TOPRIGHT", row, "TOPRIGHT", -DETAIL_VALUE_WIDTH - 4, 0)
    row.text:SetJustifyH("LEFT")
    row.text:SetJustifyV("TOP")
    row.text:SetWordWrap(true)
    row.value = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.value:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
    row.value:SetWidth(DETAIL_VALUE_WIDTH)
    row.value:SetJustifyH("RIGHT")
    row.value:SetJustifyV("TOP")
    row.value:SetWordWrap(false)

    row:SetScript("OnEnter", function(self)
        if self.tooltipItemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            local data = ItemData(self.tooltipItemID)
            if data and data.link then
                GameTooltip:SetHyperlink(data.link)
            elseif GameTooltip.SetItemByID then
                pcall(GameTooltip.SetItemByID, GameTooltip, self.tooltipItemID)
            end
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    detailRows[index] = row
    return row
end

local function DetailWidth()
    local width = (detailScroll and detailScroll:GetWidth()) or 0
    if width < 50 then width = 260 end
    return math.max(100, width - 26)
end

local function AddDetailRow(y, icon, text, value, tooltipItemID)
    detailRowCount = detailRowCount + 1
    local row = AcquireDetailRow(detailRowCount)
    row:ClearAllPoints()
    row:SetPoint("TOPLEFT", detailContent, "TOPLEFT", 0, -y)
    row:SetPoint("TOPRIGHT", detailContent, "TOPRIGHT", 0, -y)
    row:SetHeight(ROW_HEIGHT)

    if icon then
        row.icon:SetTexture(icon)
        row.icon:Show()
        row.text:ClearAllPoints()
        row.text:SetPoint("TOPLEFT", row, "TOPLEFT", ICON_SIZE + 5, 0)
        row.text:SetPoint("TOPRIGHT", row, "TOPRIGHT", -DETAIL_VALUE_WIDTH - 4, 0)
    else
        row.icon:Hide()
        row.text:ClearAllPoints()
        row.text:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
        row.text:SetPoint("TOPRIGHT", row, "TOPRIGHT", -DETAIL_VALUE_WIDTH - 4, 0)
    end

    row.text:SetWordWrap(true)
    row.text:SetText(text or "")
    row.value:SetText(value or "")

    local textHeight = (row.text.GetStringHeight and row.text:GetStringHeight()) or 0
    local height = math.max(ROW_HEIGHT, math.ceil(textHeight) + 4)
    row:SetHeight(height)

    row.tooltipItemID = tooltipItemID
    row:Show()
    return y + height
end

local function AddDetailHeader(y, text)
    detailRowCount = detailRowCount + 1
    local row = AcquireDetailRow(detailRowCount)
    row:ClearAllPoints()
    row:SetPoint("TOPLEFT", detailContent, "TOPLEFT", 0, -y)
    row:SetPoint("TOPRIGHT", detailContent, "TOPRIGHT", 0, -y)
    row:SetHeight(18)
    row.icon:Hide()
    row.text:ClearAllPoints()
    row.text:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
    row.text:SetJustifyV("TOP")
    row.text:SetWordWrap(false)
    row.text:SetText("|cffffd100" .. text .. "|r")
    row.value:SetText("")
    row.tooltipItemID = nil
    row:Show()
    return y + 20
end

-- Refreshing ------------------------------------------------------------------

local function RenderBrowseWindow()
    local total = #browseResults
    if total == 0 then
        for i = 1, browseRowCount do browseRows[i]:Hide() end
        browseRowCount = 0
        return
    end

    local viewHeight = (browseScroll and browseScroll:GetHeight()) or 300
    local offset = (browseScroll and browseScroll:GetVerticalScroll()) or 0
    if offset < 0 then offset = 0 end

    local first = math.floor(offset / ROW_HEIGHT) + 1
    if first < 1 then first = 1 end
    local visible = math.ceil(viewHeight / ROW_HEIGHT) + 2
    local last = math.min(total, first + visible - 1)

    local rowIndex = 0
    for index = first, last do
        local item = browseResults[index]
        rowIndex = rowIndex + 1
        local row = AcquireBrowseRow(rowIndex)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", browseContent, "TOPLEFT", 0, -((index - 1) * ROW_HEIGHT))
        row:SetPoint("TOPRIGHT", browseContent, "TOPRIGHT", 0, -((index - 1) * ROW_HEIGHT))
        row:SetHeight(ROW_HEIGHT)

        row.itemID = item.id
        row.icon:SetTexture(IconFor(item.info))
        row.text:SetText(ColoredName(item.name, item.info and item.info.quality))
        row.value:SetText((item.drops or 0) .. "x")
        row.background:Hide()
        row:Show()
    end

    for i = rowIndex + 1, browseRowCount do
        browseRows[i]:Hide()
    end
    browseRowCount = rowIndex
end

-- Full search over cached names only. It is cheap enough to run on every
-- keystroke; uncached items are loaded in the background and appear once
-- their names arrive.
RefreshBrowse = function(keepScroll)
    if not browseContent then return end

    local query = (searchText or ""):lower()
    local width = (browseScroll and browseScroll:GetWidth()) or 0
    if width < 50 then width = 260 end
    width = math.max(100, width - 26)
    browseContent:SetWidth(width)

    local list = GetItemIDList()
    local results = {}

    for _, entry in ipairs(list) do
        local data = CachedItemData(entry.id)
        local name = (data and data.name) or ("Item #" .. tostring(entry.id))
        if query == ""
            or name:lower():find(query, 1, true)
            or tostring(entry.id):find(query, 1, true) then
            results[#results + 1] = {
                id = entry.id,
                name = name,
                info = data,
                drops = entry.drops,
            }
        end
    end

    if sortMode == "alpha" then
        table.sort(results, function(a, b)
            if a.name ~= b.name then return a.name < b.name end
            return a.drops > b.drops
        end)
    else
        table.sort(results, function(a, b)
            if a.drops ~= b.drops then return a.drops > b.drops end
            return a.name < b.name
        end)
    end

    browseResults = results
    local total = #results

    if total > 0 then
        browseCount:SetText("|cff9d9d9d" .. total .. " item" .. (total == 1 and "" or "s") .. "|r")
        browseEmpty:Hide()
        browseContent:SetHeight(math.max(total * ROW_HEIGHT, 1))
        if browseScroll and not keepScroll then browseScroll:SetVerticalScroll(0) end
        RenderBrowseWindow()
    else
        browseRowCount = 0
        for i = 1, #browseRows do browseRows[i]:Hide() end
        browseCount:SetText("|cff9d9d9d0 items|r")
        browseEmpty:SetText(query ~= "" and "No items match your search."
            or "No items recorded yet. Loot something to start tracking.")
        browseEmpty:Show()
        browseContent:SetHeight(30)
    end
end

RefreshDetail = function()
    if not detailContent then return end
    for _, row in ipairs(detailRows) do row:Hide() end
    detailRowCount = 0
    detailEmpty:Hide()
    auctionCache = {}

    local itemID = selectedID
    local data = itemID and ItemData(itemID)
    local name = itemID and ItemName(itemID, data) or "Item"
    detailIcon:SetTexture(IconFor(data))
    detailName:SetText(ColoredName(name, data and data.quality))
    detailName:SetTextColor(1, 1, 1)

    local values = {}
    if data and data.sellPrice and data.sellPrice > 0 then
        values[#values + 1] = "|cff9d9d9dVendor:|r " .. FormatMoney(data.sellPrice)
    end
    if KKK.HasAuctionator and KKK.HasAuctionator() and KKK.GetAuctionPrice then
        local ok, price = pcall(KKK.GetAuctionPrice, itemID)
        if ok and price and price > 0 then
            values[#values + 1] = "|cff9d9d9dAuction:|r " .. FormatMoney(price)
        end
    end
    detailValue:SetText(table.concat(values, "   "))

    for _, button in ipairs(tabButtons) do
        local active = button.tab == detailTab
        button.text:SetTextColor(active and 1 or 0.6, active and 0.82 or 0.6, active and 0 or 0.6)
        button.underline:SetShown(active)
    end

    local y = 0
    local width = DetailWidth()
    detailContent:SetWidth(width)

    if detailTab == "uses" then
        local index = GetRecipeIndex()
        local uses = {}
        for _, entry in ipairs(index.byReagent[itemID] or {}) do
            uses[#uses + 1] = entry
        end
        SortRecipeList(uses)

        if #uses > 0 then
            y = AddDetailHeader(y, "Used by recipes (" .. #uses .. ")")
            for _, entry in ipairs(uses) do
                local recipe = entry.recipe
                local profession = recipe.profession and ("|cff9d9d9d" .. recipe.profession .. "|r") or ""
                y = AddDetailRow(y, recipe.icon, recipe.name, "x" .. entry.count .. "  " .. profession)
            end
        else
            detailEmpty:Show()
            detailEmpty:SetText(next(RecipeDB()) == nil
                and "No recipe data yet.\nOpen your profession window once to record recipes."
                or "No known recipes use this item.")
            detailContent:SetHeight(40)
            detailEmpty:SetWidth(math.max(width - 12, 60))
            return
        end
    else
        local itemIndex = BuildItemIndex()
        local entry = itemIndex[itemID]
        local sources = entry and entry.sources or {}

        if #sources > 0 then
            y = AddDetailHeader(y, "Dropped by (" .. #sources .. ")")
            for _, source in ipairs(sources) do
                local rateText = ((source.samples or 0) < MIN_SOURCE_SAMPLES)
                    and "??%" or string.format("%.1f%%", source.rate)
                y = AddDetailRow(y, nil, source.name,
                    string.format("%dx · %s", source.drops, rateText))
            end
        end

        local index = GetRecipeIndex()
        local crafted = index.byOutput[itemID] or {}
        local sorted = {}
        for _, entryByOutput in ipairs(crafted) do
            sorted[#sorted + 1] = entryByOutput
        end
        SortRecipeList(sorted)

        if #sorted > 0 then
            y = y + 4
            y = AddDetailHeader(y, "Crafted by (" .. #sorted .. ")")
            for _, entryByOutput in ipairs(sorted) do
                local recipe = entryByOutput.recipe
                local profession = recipe.profession and ("|cff9d9d9d" .. recipe.profession .. "|r") or ""
                y = AddDetailRow(y, recipe.icon, recipe.name, profession)
            end
        end

        if #sources == 0 and #sorted == 0 then
            detailEmpty:Show()
            detailEmpty:SetText("No drop sources or known recipes for this item.")
            detailContent:SetHeight(40)
            detailEmpty:SetWidth(math.max(width - 12, 60))
            return
        end
    end

    detailEmpty:Hide()
    detailContent:SetHeight(math.max(y, 1))
end

local function Refresh()
    if not panel then return end
    if mode == "detail" then
        RefreshDetail()
    else
        StartSearch()
    end
end

StartSearch = function()
    itemLoader:SetItems(CollectItemIDs())
    itemLoader:Start()
    RefreshBrowse()
end


local function SortLabel(id)
    for _, option in ipairs(SORT_OPTIONS) do
        if option.id == id then return option.label end
    end
    return SORT_OPTIONS[1].label
end

local function HideSortMenu()
    if sortMenu then sortMenu:Hide() end
    if sortOverlay then sortOverlay:Hide() end
end

local function SetSortMode(id)
    sortMode = (id == "alpha") and "alpha" or "drops"
    if type(KwaTrackerDB) == "table" then
        KwaTrackerDB.itemSortMode = sortMode
    end
    if sortDropdownLabel then
        sortDropdownLabel:SetText(SortLabel(sortMode))
    end
    if panel and panel:IsShown() then
        RefreshBrowse()
    end
end

local function CreateSortMenu()
    if sortMenu then return sortMenu end

    sortOverlay = CreateFrame("Frame", nil, UIParent)
    sortOverlay:SetAllPoints(UIParent)
    sortOverlay:SetFrameStrata("DIALOG")
    sortOverlay:EnableMouse(true)
    sortOverlay:Hide()
    sortOverlay:SetScript("OnMouseDown", HideSortMenu)

    sortMenu = CreateFrame("Frame", "KwaItemLookupSortMenu", UIParent, "BackdropTemplate")
    sortMenu:SetFrameStrata("TOOLTIP")
    sortMenu:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    sortMenu:SetBackdropColor(0.055, 0.055, 0.07, 0.98)
    sortMenu:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)
    sortMenu:EnableMouse(true)
    sortMenu:Hide()
    sortMenu:SetScript("OnHide", function()
        if sortOverlay then sortOverlay:Hide() end
    end)

    sortMenu.buttons = {}
    for index, option in ipairs(SORT_OPTIONS) do
        local button = CreateFrame("Button", nil, sortMenu)
        button:SetHeight(20)
        button:SetPoint("TOPLEFT", sortMenu, "TOPLEFT", 1, -((index - 1) * 20 + 4))
        button:SetPoint("TOPRIGHT", sortMenu, "TOPRIGHT", -1, -((index - 1) * 20 + 4))

        local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("LEFT", button, "LEFT", 8, 0)
        text:SetJustifyH("LEFT")
        text:SetText(option.label)
        button.text = text
        button.optionID = option.id

        Util.SetHoverBackground(button, 0.08)
        button:SetScript("OnClick", function(self)
            SetSortMode(self.optionID)
            HideSortMenu()
        end)

        sortMenu.buttons[index] = button
    end

    sortMenu:SetWidth(150)
    sortMenu:SetHeight(8 + (#SORT_OPTIONS * 20))
    return sortMenu
end

local function ShowSortMenu()
    local frame = CreateSortMenu()
    for _, button in ipairs(frame.buttons) do
        local selected = button.optionID == sortMode
        button.text:SetTextColor(selected and 1 or 0.7, selected and 0.82 or 0.7, selected and 0 or 0.7)
        button.background:Hide()
    end

    local x, y = sortDropdown:GetLeft(), sortDropdown:GetBottom()
    if not x or not y then return end
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y - 2)
    sortOverlay:Show()
    frame:Show()
end

UpdateMode = function()
    local detail = mode == "detail"
    searchBox:SetShown(not detail)
    searchPlaceholder:SetShown(not detail and searchText == "")
    clearButton:SetShown(not detail and searchText ~= "")
    sortDropdown:SetShown(not detail)
    if detail then HideSortMenu() end
    browseCount:SetShown(not detail)
    browseScroll:SetShown(not detail)
    detailHeader:SetShown(detail)
    for _, button in ipairs(tabButtons) do button:SetShown(detail) end
    detailScroll:SetShown(detail)
    if not detail then
        detailEmpty:Hide()
    end
end

local function CreatePanel(parent)
    if panel then return panel end

    EnsureDB()
    sortMode = (KwaTrackerDB.itemSortMode == "alpha") and "alpha" or "drops"
    panel = CreateFrame("Frame", nil, parent)

    searchBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    searchBox:SetSize(206, 20)
    searchBox:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -2)
    searchBox:SetAutoFocus(false)
    searchBox:SetMaxLetters(60)
    searchBox:SetFontObject("GameFontHighlightSmall")

    searchPlaceholder = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    searchPlaceholder:SetPoint("LEFT", searchBox, "LEFT", 6, 0)
    searchPlaceholder:SetText("Search items...")

    clearButton = CreateFrame("Button", nil, panel)
    clearButton:SetSize(16, 16)
    clearButton:SetPoint("LEFT", searchBox, "RIGHT", 2, 0)
    local clearText = clearButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    clearText:SetAllPoints()
    clearText:SetText("x")
    clearText:SetTextColor(0.7, 0.7, 0.7)
    clearButton:SetScript("OnClick", function()
        searchBox:SetText("")
        searchBox:ClearFocus()
    end)
    clearButton:SetScript("OnEnter", function() clearText:SetTextColor(1, 1, 1) end)
    clearButton:SetScript("OnLeave", function() clearText:SetTextColor(0.7, 0.7, 0.7) end)
    clearButton:Hide()

    sortDropdown = CreateFrame("Button", nil, panel, "BackdropTemplate")
    sortDropdown:SetSize(128, 20)
    sortDropdown:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -26)
    sortDropdown:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    sortDropdown:SetBackdropColor(0.08, 0.08, 0.1, 1)
    sortDropdown:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)

    sortDropdownLabel = sortDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sortDropdownLabel:SetPoint("LEFT", sortDropdown, "LEFT", 8, 0)
    sortDropdownLabel:SetPoint("RIGHT", sortDropdown, "RIGHT", -20, 0)
    sortDropdownLabel:SetJustifyH("LEFT")
    sortDropdownLabel:SetText(SortLabel(sortMode))

    local sortArrow = sortDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sortArrow:SetPoint("RIGHT", sortDropdown, "RIGHT", -8, 0)
    sortArrow:SetText("v")

    sortDropdown:SetScript("OnClick", function()
        if sortMenu and sortMenu:IsShown() then
            HideSortMenu()
        else
            ShowSortMenu()
        end
    end)
    sortDropdown:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.5, 0.5, 0.58, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Sort items", 1, 0.82, 0)
        GameTooltip:Show()
    end)
    sortDropdown:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)
        GameTooltip:Hide()
    end)

    browseCount = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    browseCount:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -30)
    browseCount:SetJustifyH("RIGHT")

    searchBox:SetScript("OnTextChanged", function(self)
        searchText = self:GetText() or ""
        searchPlaceholder:SetShown(searchText == "")
        clearButton:SetShown(searchText ~= "")
        StartSearch()
    end)
    searchBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)

    browseScroll, browseContent = Util.CreateScrollPanel(panel, { top = 52 })
    browseScroll:SetScript("OnVerticalScroll", function()
        RenderBrowseWindow()
    end)

    browseEmpty = browseContent:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    browseEmpty:SetPoint("TOPLEFT", browseContent, "TOPLEFT", 2, -2)
    browseEmpty:SetWidth(230)
    browseEmpty:SetJustifyH("LEFT")

    detailHeader = CreateFrame("Frame", nil, panel)
    detailHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    detailHeader:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    detailHeader:SetHeight(44)
    detailHeader:Hide()

    backButton = CreateFrame("Button", nil, detailHeader, "UIPanelButtonTemplate")
    backButton:SetSize(22, 20)
    backButton:SetPoint("TOPLEFT", detailHeader, "TOPLEFT", 0, -2)
    backButton:SetText("<")
    backButton:SetScript("OnClick", function()
        mode = "browse"
        selectedID = nil
        UpdateMode()
        RefreshBrowse()
        itemLoader:Start()
        if browseScroll then browseScroll:SetVerticalScroll(0) end
    end)
    backButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(backButton, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Back to items", 1, 0.82, 0)
        GameTooltip:Show()
    end)
    backButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local iconFrame = CreateFrame("Frame", nil, detailHeader)
    iconFrame:SetSize(30, 30)
    iconFrame:SetPoint("TOPLEFT", detailHeader, "TOPLEFT", 22, -2)
    iconFrame:EnableMouse(true)
    detailIcon = iconFrame:CreateTexture(nil, "ARTWORK")
    detailIcon:SetAllPoints()
    detailIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    iconFrame:SetScript("OnEnter", function()
        if not selectedID then return end
        GameTooltip:SetOwner(iconFrame, "ANCHOR_RIGHT")
        local data = ItemData(selectedID)
        if data and data.link then
            GameTooltip:SetHyperlink(data.link)
        elseif GameTooltip.SetItemByID then
            pcall(GameTooltip.SetItemByID, GameTooltip, selectedID)
        end
        GameTooltip:Show()
    end)
    iconFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)

    detailName = detailHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    detailName:SetPoint("TOPLEFT", detailHeader, "TOPLEFT", 58, -3)
    detailName:SetPoint("TOPRIGHT", detailHeader, "TOPRIGHT", -2, -3)
    detailName:SetJustifyH("LEFT")
    detailName:SetWordWrap(false)

    detailValue = detailHeader:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    detailValue:SetPoint("TOPLEFT", detailName, "BOTTOMLEFT", 0, -3)
    detailValue:SetPoint("TOPRIGHT", detailHeader, "TOPRIGHT", -2, -20)
    detailValue:SetJustifyH("LEFT")
    detailValue:SetWordWrap(false)

    tabButtons = {}
    local tabSpecs = {
        { tab = "sources", label = "Sources" },
        { tab = "uses", label = "Uses" },
    }
    for index, spec in ipairs(tabSpecs) do
        local button = CreateFrame("Button", nil, panel)
        button:SetSize(70, 18)
        button:SetPoint("TOPLEFT", panel, "TOPLEFT", (index - 1) * 76, -50)
        button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        button.text:SetAllPoints()
        button.text:SetText(spec.label)
        button.text:SetJustifyH("LEFT")
        button.underline = button:CreateTexture(nil, "ARTWORK")
        button.underline:SetColorTexture(1, 0.82, 0, 0.8)
        button.underline:SetHeight(1)
        button.underline:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
        button.underline:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -30, 0)
        button.tab = spec.tab
        button:SetScript("OnClick", function(self)
            detailTab = self.tab
            RefreshDetail()
            if detailScroll then detailScroll:SetVerticalScroll(0) end
        end)
        tabButtons[index] = button
    end

    detailScroll, detailContent = Util.CreateScrollPanel(panel, { top = 72 })

    detailEmpty = detailContent:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    detailEmpty:SetPoint("TOPLEFT", detailContent, "TOPLEFT", 2, -2)
    detailEmpty:SetWidth(230)
    detailEmpty:SetJustifyH("LEFT")

    panel:SetScript("OnShow", function()
        EnsureDB()
        UpdateMode()
        if mode == "detail" and selectedID then
            RefreshDetail()
        else
            StartSearch()
        end
    end)
    panel:SetScript("OnHide", HideSortMenu)

    return panel
end

-- Events ----------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
for _, event in ipairs({
    "PLAYER_ENTERING_WORLD",
    "TRADE_SKILL_SHOW",
    "TRADE_SKILL_UPDATE",
    "GET_ITEM_INFO_RECEIVED",
    "ITEM_DATA_LOAD_RESULT",
}) do
    pcall(eventFrame.RegisterEvent, eventFrame, event)
end
eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "TRADE_SKILL_SHOW" then
        ScanRecipes(true)
    elseif event == "TRADE_SKILL_UPDATE" then
        ScanRecipes(false)
    elseif event == "GET_ITEM_INFO_RECEIVED" or event == "ITEM_DATA_LOAD_RESULT" then
        local itemID = tonumber(arg1)
        local tracked = itemID and itemIndexCache and itemIndexCache[itemID]
        if tracked then
            itemInfoCache[itemID] = nil
        end
        if tracked and panel and panel:IsShown() then
            if mode == "detail" then
                RefreshDetail()
            else
                itemLoader:Requeue()
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        EnsureDB()
    end
end)

KKK.ItemLookup = {
    OnDataChanged = function()
        itemIndexDirty = true
        itemIDDirty = true
        if not (panel and panel:IsShown()) then return end
        if mode == "detail" then
            RefreshDetail()
        else
            itemLoader:SetItems(CollectItemIDs())
            itemLoader:MarkDirty()
        end
    end,
}

if KwaLite and KwaLite.RegisterAddon then
    KwaLite:RegisterAddon({
        id = "KwaItemLookup",
        name = "Item Lookup",
        icon = "Interface\\Icons\\INV_Misc_Spyglass_02",
        priority = 6,
        createPanel = CreatePanel,
        refresh = function() Refresh() end,
        showMinimizedByDefault = false,
    })
end
