local addonName, KU = ...

-- KwaProfitableCrafts: highlight profitable crafts (vendor or auction profit).
-- 3-way toggle: none / highlight vendor profit / highlight auction profit.
--
-- Builds on the same "vendor profit" idea as KwaVendorProfit, but applies it to
-- every recipe row in the recipe list instead of just the selected recipe:
--
--     profit = (output price * output quantity) - reagent cost
-- output price = vendor sell price (vendor mode) or auction value (auction
-- mode, Auctionator auction price of the crafted item)
--
-- A recipe counts as PROFITABLE when profit > 0 (PROFIT_THRESHOLD). A recipe
-- whose output has no vendor sell price (nothing to sell to a vendor, or item
-- data not loaded yet), or whose schematic can't be read, is UNKNOWN and is
-- NOT treated as profitable. Nothing is highlighted on a guess.
--
-- Reagent cost mirrors Auctionator.CraftingInfo.CalculateCraftCost for the
-- no-allocated-reagents case (installed Auctionator source): for each BASIC
-- reagent slot, take the cheapest reagent option; unit price = vendor buy
-- price, else auction price, or vendor price when it exceeds 5x auction price;
-- optional (non-basic) reagents are ignored; no reagents -> 0. Reagent prices
-- need Auctionator (Auctionator.API.v1.GetVendorPriceByItemID /
-- GetAuctionPriceByItemID); a reagent with no known price counts as free (0),
-- like KwaVendorProfit (cost or 0) and Auctionator, so profit uses partial
-- cost. Output vendor sell price comes from C_Item.GetItemInfo. We don't call
-- C_Item.RequestLoadItemDataByID (it can re-enter Blizzard's recipe loader);
-- item data is re-checked on GET_ITEM_INFO_RECEIVED; until it loads a recipe
-- is unknown, not profitable.
--
-- Enchanting has no item output in the schematic; known enchants map to an
-- output item via Auctionator.CraftingInfo.EnchantSpellsToItems (retail) or
-- .EnchantSpellsToItemData (this client) when available; otherwise enchanting
-- recipes are unknown.
--
-- Highlight: in "vendor" or "auction" mode, profitable recipes' names are
-- tinted gold in the recipe list. Blizzard colors recipe names itself (e.g. by
-- skill-up difficulty) in Init / OnLeave, then we run; we tint profitable rows
-- gold and restore Blizzard's original name color otherwise. Hooks
-- ProfessionsRecipeListRecipeMixin.Init / OnLeave (+ per-row fallback). We do
-- NOT touch the recipe list's data provider / scroll box at all.
--
-- UI: a "Kwa Profit" button on ProfessionsFrame.CraftingPage.RecipeList cycles
-- None -> Vendor profit -> Auction profit -> None. Session-local; not
-- persisted. /kwaprofit prints a profit breakdown for the selected recipe.
--
-- Event storms are coalesced into one deferred refresh per frame; in off mode
-- refresh is a cheap no-op; `Paint` never re-enters (hooksecurefunc, no
-- SetDataProvider, no item-load requests); `Paint` calls are pcall-safe reads.
--
-- Verified here: Lua syntax only (luac -p). NOT verified in-game on WoW
-- Forever. API names (C_TradeSkillUI.GetRecipeSchematic / GetRecipeInfo /
-- GetRecipeOutputItemData, schematic fields outputItemID / quantityMin /
-- reagentSlotSchematics / reagentType / quantityRequired / reagents[].itemID /
-- isEnchantingRecipe, Enum.CraftingReagentType.Basic, C_Item.GetItemInfo,
-- ProfessionsFrame.CraftingPage.RecipeList.ScrollBox,
-- ProfessionsRecipeListRecipeMixin, hooksecurefunc, UIPanelButtonTemplate,
-- Auctionator.API.v1, Auctionator.CraftingInfo) follow the installed WoW
-- Forever client + Auctionator sources and other addons on this client
-- (KwaVendorProfit, KwaItemLookup, ForeverPlusPlus); every probe is
-- feature-checked and wrapped in pcall so missing APIs degrade to "unknown".
-- Should be smoke-tested in game.

local C_TradeSkillUI = C_TradeSkillUI
local C_Item = C_Item
local pcall = pcall
local ipairs = ipairs
local pairs = pairs
local setmetatable = setmetatable

local PROFIT_THRESHOLD = 0 -- profit strictly greater than this counts as profitable
local PROFITABLE_COLOR = { r = 1, g = 0.82, b = 0 } -- gold

local MODES = { "none", "vendor", "auction" }
local MODE_LABEL = {
    none = "Kwa Profit: none",
    vendor = "Kwa Profit: vendor profit",
    auction = "Kwa Profit: auction profit",
}

local mode = "none" -- "none" | "vendor" | "auction"

local button

-- Item / recipe reading -------------------------------------------------------

-- C_Item.GetItemInfo (Forever) / GetItemInfo return either many values
-- (name, link, quality, ..., sellPrice as #11) or one table; normalize.
local function ItemInfo(item)
    local fn = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    if not fn or item == nil then
        return nil
    end
    local ok, a, b, c, d, e, f, g, h, i, j, k = pcall(fn, item)
    if not ok then
        return nil
    end
    if type(a) == "table" then
        return a
    end
    return {
        name = a, link = b, quality = c, itemLevel = d, requiredLevel = e,
        class = f, subclass = g, maxStack = h, equipLoc = i, texture = j,
        sellPrice = k,
    }
end

local function GetSellPrice(itemID)
    if not itemID or itemID == 0 then
        return nil
    end
    local info = ItemInfo(itemID)
    local price = info and info.sellPrice
    if type(price) == "number" and price >= 0 then
        return price
    end
    return nil
end

local function GetSchematic(recipeID)
    if not (C_TradeSkillUI and C_TradeSkillUI.GetRecipeSchematic) then
        return nil
    end
    local ok, schematic = pcall(C_TradeSkillUI.GetRecipeSchematic, recipeID, false)
    if ok and type(schematic) == "table" then
        return schematic
    end
    return nil
end

local function GetRecipeInfo(recipeID)
    if not (C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo) then
        return nil
    end
    local ok, info = pcall(C_TradeSkillUI.GetRecipeInfo, recipeID)
    if ok and type(info) == "table" then
        return info
    end
    return nil
end

local function EnchantOutputItemID(recipeID)
    local A = Auctionator and Auctionator.CraftingInfo
    if not A then
        return nil
    end
    local map = A.EnchantSpellsToItems or A.EnchantSpellsToItemData
    local entry = map and map[recipeID]
    if type(entry) == "number" then
        return entry
    end
    if type(entry) == "table" then
        return tonumber(entry.itemID or entry[1])
    end
    return nil
end

-- Output item ID for vendor sale, plus the schematic (for reagents / quantity).
local function GetOutputItemID(recipeID)
    local schematic = GetSchematic(recipeID)
    local output = schematic and tonumber(schematic.outputItemID)
    if output and output > 0 then
        return output, schematic
    end

    local info = GetRecipeInfo(recipeID)
    local isEnchant = (schematic and schematic.isEnchantingRecipe)
        or (info and info.isEnchantingRecipe)
    if isEnchant then
        local itemID = EnchantOutputItemID(recipeID)
        if itemID and itemID > 0 then
            return itemID, schematic
        end
    end

    if C_TradeSkillUI and C_TradeSkillUI.GetRecipeOutputItemData then
        local ok, data = pcall(C_TradeSkillUI.GetRecipeOutputItemData, recipeID)
        if ok and type(data) == "table" then
            local itemID = tonumber(data.itemID) or tonumber(data.itemID2)
            if itemID and itemID > 0 then
                return itemID, schematic
            end
            if type(data.hyperlink) == "string" then
                local id = tonumber(data.hyperlink:match("item:(%d+)"))
                if id and id > 0 then
                    return id, schematic
                end
            end
        end
    end

    return nil, schematic
end

-- Reagent cost ----------------------------------------------------------------

local function AuctionatorV1()
    return Auctionator and Auctionator.API and Auctionator.API.v1
end

local function UnitPrice(itemID)
    local A = AuctionatorV1()
    if not A or not itemID then
        return nil
    end
    local label = _G.AUCTIONATOR_L_REAGENT_SEARCH or "Auctionator"
    local vendor, auction
    if type(A.GetVendorPriceByItemID) == "function" then
        local ok, v = pcall(A.GetVendorPriceByItemID, label, itemID)
        if ok and type(v) == "number" then
            vendor = v
        end
    end
    if type(A.GetAuctionPriceByItemID) == "function" then
        local ok, a = pcall(A.GetAuctionPriceByItemID, label, itemID)
        if ok and type(a) == "number" then
            auction = a
        end
    end
    local unit = vendor or auction
    if vendor and auction and vendor > 5 * auction then
        unit = auction
    end
    if type(unit) == "number" then
        return unit
    end
    return nil
end

-- Total reagent cost per craft. Unknown (schematic missing) -> nil. No
-- reagents -> 0. A mandatory reagent with no known price contributes 0, exactly
-- like KwaVendorProfit (cost or 0) and Auctionator (GetByMinCostOption -> 0).
local function ReagentCost(schematic)
    if not schematic then
        return nil
    end
    local slots = schematic.reagentSlotSchematics
    if type(slots) ~= "table" then
        return 0
    end
    local basicType = Enum and Enum.CraftingReagentType and Enum.CraftingReagentType.Basic
    local total = 0
    for _, slot in ipairs(slots) do
        local reagents = slot.reagents
        if reagents and #reagents > 0 then
            local required = tonumber(slot.quantityRequired) or 0
            local isBasic
            if basicType ~= nil and slot.reagentType ~= nil then
                isBasic = slot.reagentType == basicType
            else
                isBasic = slot.required
            end
            if isBasic and required > 0 then
                local min = nil
                local priced = false
                for _, reagent in ipairs(reagents) do
                    local itemID = tonumber(reagent.itemID)
                    if itemID then
                        local price = UnitPrice(itemID)
                        if price then
                            priced = true
                            local value = price * required
                            if not min or value < min then
                                min = value
                            end
                        end
                    end
                end
                if priced then
                    total = total + (min or 0)
                end
            end
        end
    end
    return total
end

-- Output auction value from Auctionator (auction price of the crafted item).
local function AuctionOutputPrice(outputItemID)
    local A = AuctionatorV1()
    if not A or not outputItemID or type(A.GetAuctionPriceByItemID) ~= "function" then
        return nil
    end
    local label = _G.AUCTIONATOR_L_REAGENT_SEARCH or "Auctionator"
    local ok, price = pcall(A.GetAuctionPriceByItemID, label, outputItemID)
    if ok and type(price) == "number" and price > 0 then
        -- Apply the auction house cut like Auctionator's own profit does.
        local cut = Auctionator and Auctionator.Constants
            and Auctionator.Constants.AfterAHCut
        if type(cut) == "number" and cut > 0 then
            return price * cut
        end
        return price
    end
    return nil
end

-- Craft profit in copper for `kind` ("vendor" | "auction"), or nil when unknown.
--   vendor:  output vendor sell price * qty - reagent cost
--   auction: output auction value * Auctionator.Constants.AfterAHCut * qty - reagent cost
local function CraftProfit(recipeID, kind)
    if not recipeID then
        return nil
    end
    local outputItemID, schematic = GetOutputItemID(recipeID)
    if not outputItemID then
        return nil
    end
    local outputPrice
    if kind == "auction" then
        outputPrice = AuctionOutputPrice(outputItemID)
    else
        outputPrice = GetSellPrice(outputItemID)
        if outputPrice == 0 then
            outputPrice = nil -- nothing to sell to a vendor
        end
    end
    if not outputPrice or outputPrice <= 0 then
        return nil
    end
    local quantity = 1
    if schematic then
        quantity = tonumber(schematic.quantityMin) or tonumber(schematic.quantityMax) or 1
    end
    if quantity < 1 then
        quantity = 1
    end
    local cost = ReagentCost(schematic or GetSchematic(recipeID))
    if cost == nil then
        return nil
    end
    return outputPrice * quantity - cost
end

-- Vendor profit in copper, or nil when unknown (also used by /kwaprofit).
local function VendorProfit(recipeID)
    return CraftProfit(recipeID, "vendor")
end

-- Auction profit in copper, or nil when unknown.
local function AuctionProfit(recipeID)
    return CraftProfit(recipeID, "auction")
end

-- Profitability cache, invalidated on events ----------------------------------

local profitCache = {}

local function IsProfitable(recipeID, kind)
    if not recipeID or kind == "none" or not kind then
        return false
    end
    local key = tostring(recipeID) .. ":" .. kind
    local cached = profitCache[key]
    if cached ~= nil then
        return cached
    end
    local profit = CraftProfit(recipeID, kind)
    local profitable = profit ~= nil and profit > PROFIT_THRESHOLD
    profitCache[key] = profitable
    return profitable
end

local function Invalidate()
    profitCache = {}
end

-- Recipe list access ----------------------------------------------------------

local function RecipeList()
    local frame = _G.ProfessionsFrame
    local page = frame and frame.CraftingPage
    return page and page.RecipeList
end

local function ScrollBox()
    local list = RecipeList()
    return list and list.ScrollBox
end

local function NodeData(node)
    if not node then
        return nil
    end
    if node.GetData then
        return node:GetData()
    end
    return node.data
end

local function RowRecipeID(row)
    if not row then
        return nil
    end
    local node = row.GetElementData and row:GetElementData()
    local data = NodeData(node)
    local info = data and data.recipeInfo
    return info and info.recipeID
end

-- Highlight -------------------------------------------------------------------

local tinted = setmetatable({}, { __mode = "k" })
local originalColor = setmetatable({}, { __mode = "k" })

local function SetLabelColor(row, r, g, b)
    local label = row.Label
    if label and label.SetVertexColor then
        label:SetVertexColor(r, g, b)
    end
end

local function RestoreLabel(row)
    local orig = originalColor[row]
    originalColor[row] = nil
    if orig then
        SetLabelColor(row, orig[1], orig[2], orig[3])
    else
        SetLabelColor(row, 1, 1, 1)
    end
end

local function Paint(row)
    if not row or not row.Label then
        return
    end
    if mode ~= "none" and IsProfitable(RowRecipeID(row), mode) then
        if not tinted[row] then
            local label = row.Label
            if label.GetVertexColor then
                local r, g, b = label:GetVertexColor()
                originalColor[row] = { r, g, b }
            end
            tinted[row] = true
        end
        SetLabelColor(row, PROFITABLE_COLOR.r, PROFITABLE_COLOR.g, PROFITABLE_COLOR.b)
    elseif tinted[row] then
        tinted[row] = nil
        RestoreLabel(row)
    end
end

local function RepaintAll(box)
    box = box or ScrollBox()
    if box and box.ForEachFrame then
        box:ForEachFrame(function(row) Paint(row) end)
    end
end

local function ClearTint()
    for row in pairs(tinted) do
        tinted[row] = nil
        RestoreLabel(row)
    end
end

-- Hooking ---------------------------------------------------------------------

local rowHooked = setmetatable({}, { __mode = "k" })
local mixinHooked = false

local function HookRow(row, mixin)
    if not row or rowHooked[row] then
        return
    end
    rowHooked[row] = true
    if row.Init and (not mixin or row.Init ~= mixin.Init) then
        hooksecurefunc(row, "Init", function(self) Paint(self) end)
    end
    if row.OnLeave and (not mixin or row.OnLeave ~= mixin.OnLeave) then
        hooksecurefunc(row, "OnLeave", function(self) Paint(self) end)
    end
end

local function HookRows(box)
    local mixin = _G.ProfessionsRecipeListRecipeMixin
    if mixin and not mixinHooked then
        mixinHooked = true
        if mixin.Init then
            hooksecurefunc(mixin, "Init", function(self) Paint(self) end)
        end
        if mixin.OnLeave then
            hooksecurefunc(mixin, "OnLeave", function(self) Paint(self) end)
        end
    end
    if box and box.ForEachFrame then
        box:ForEachFrame(function(row) HookRow(row, mixin) end)
    end
end

local CreateButton

local function EnsureHooked()
    local box = ScrollBox()
    if not box then
        return
    end
    HookRows(box)
    CreateButton(RecipeList())
end

-- UI button -------------------------------------------------------------------

CreateButton = function(list)
    if button or not list then
        return
    end
    local ok, frame = pcall(
        CreateFrame, "Button", "KwaProfitableCraftsToggle", list, "UIPanelButtonTemplate"
    )
    if not ok or not frame then
        frame = CreateFrame("Button", "KwaProfitableCraftsToggle", list)
    end
    button = frame
    button:SetSize(140, 20)
    button:SetPoint("BOTTOMRIGHT", list, "BOTTOMRIGHT", -4, 4)
    button:SetText(MODE_LABEL[mode])
    if button.SetNormalFontObject then
        button:SetNormalFontObject("GameFontNormalSmall")
    end
    button:SetScript("OnClick", function() CycleMode() end)
end

local function UpdateButton()
    if button then
        button:SetText(MODE_LABEL[mode])
    end
end

-- Events ----------------------------------------------------------------------
-- Event storms are coalesced into one deferred refresh per frame; in off mode
-- refresh is a cheap no-op; nothing re-enters Blizzard (hooksecurefunc, no
-- SetDataProvider, no item-load requests).

local Refresh
local scheduled = false

local function runRefresh()
    scheduled = false
    pcall(function()
        EnsureHooked()
        if mode == "none" then
            return
        end
        Invalidate()
        RepaintAll()
    end)
end

Refresh = function()
    if scheduled then
        return
    end
    scheduled = true
    if C_Timer and C_Timer.After then
        C_Timer.After(0, runRefresh)
    else
        runRefresh()
    end
end

local function RepaintOnly()
    EnsureHooked()
    if mode ~= "none" then
        Invalidate()
        RepaintAll()
    end
end

-- Mode ------------------------------------------------------------------------

function CycleMode() -- global for the button; safe no-op if called early
    local index = 1
    for i, name in ipairs(MODES) do
        if name == mode then
            index = i
            break
        end
    end
    mode = MODES[(index % #MODES) + 1]
    if mode == "none" then
        ClearTint()
    end
    UpdateButton()
    Invalidate()
    EnsureHooked()
    Refresh()
end

-- Events ----------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("TRADE_SKILL_SHOW")
eventFrame:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
pcall(eventFrame.RegisterEvent, eventFrame, "GET_ITEM_INFO_RECEIVED")
pcall(eventFrame.RegisterEvent, eventFrame, "ITEM_DATA_LOAD_RESULT")
eventFrame:RegisterEvent("MERCHANT_SHOW")
eventFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")

eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "ADDON_LOADED" then
        if arg1 == "Blizzard_Professions" or arg1 == "Auctionator" then
            Refresh()
        end
        return
    end
    if event == "TRADE_SKILL_LIST_UPDATE" then
        RepaintOnly()
        return
    end
    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
        if not (Enum and Enum.PlayerInteractionType)
            or arg1 == Enum.PlayerInteractionType.Merchant then
            if C_Timer and C_Timer.After then
                C_Timer.After(1, Refresh)
            else
                Refresh()
            end
        end
        return
    end
    if event == "MERCHANT_SHOW" then
        -- Auctionator caches vendor buy prices asynchronously.
        if C_Timer and C_Timer.After then
            C_Timer.After(1, Refresh)
        else
            Refresh()
        end
        return
    end
    -- PLAYER_LOGIN, TRADE_SKILL_SHOW, GET_ITEM_INFO_RECEIVED, ITEM_DATA_LOAD_RESULT
    Refresh()
end)

-- /kwaprofit diagnostic: print the profit breakdown for the selected recipe.
local function SelectedRecipeID()
    local frame = _G.ProfessionsFrame
    local page = frame and frame.CraftingPage
    local form = page and page.SchematicForm
    local info = form and form.GetRecipeInfo and form:GetRecipeInfo()
    return info and info.recipeID
end

local function PrintBreakdown()
    local function out(msg)
        if _G.DEFAULT_CHAT_FRAME then
            _G.DEFAULT_CHAT_FRAME:AddMessage("|cff66ccffKwaProfit|r " .. tostring(msg))
        else
            print("KwaProfit " .. tostring(msg))
        end
    end
    local recipeID = SelectedRecipeID()
    out("mode=" .. mode .. " Auctionator=" .. tostring(Auctionator ~= nil)
        .. " APIv1=" .. tostring(AuctionatorV1() ~= nil))
    if not recipeID then
        out("no selected recipe")
        return
    end
    local outputItemID, schematic = GetOutputItemID(recipeID)
    local info = GetRecipeInfo(recipeID)
    local sellPrice = outputItemID and GetSellPrice(outputItemID) or nil
    local cost = ReagentCost(schematic or GetSchematic(recipeID))
    local profit = VendorProfit(recipeID)
    out(string.format(
        "recipeID=%s name=%s learned=%s",
        tostring(recipeID), tostring(info and info.name), tostring(info and info.learned)))
    out(string.format(
        "outputItemID=%s sellPrice=%s qtyMin=%s",
        tostring(outputItemID), tostring(sellPrice),
        tostring(schematic and schematic.quantityMin)))
    local auctionProfit = AuctionProfit(recipeID)
    out(string.format(
        "reagentSlots=%s reagentCost=%s vendorProfit=%s auctionProfit=%s",
        tostring(schematic and schematic.reagentSlotSchematics
            and #schematic.reagentSlotSchematics or 0),
        tostring(cost), tostring(profit), tostring(auctionProfit)))
    out(string.format("profitable(vendor)=%s profitable(auction)=%s",
        tostring(IsProfitable(recipeID, "vendor")),
        tostring(IsProfitable(recipeID, "auction"))))
end

_G.SLASH_KWAPROFIT1 = "/kwaprofit"
_G.SlashCmdList = _G.SlashCmdList or {}
_G.SlashCmdList["KWAPROFIT"] = function() pcall(PrintBreakdown) end

-- Public API (also handy for testing); KwaUtils namespace.
KU = KU or {}
KU.KwaProfitableCrafts = {
    VendorProfit = VendorProfit,
    AuctionProfit = AuctionProfit,
    CraftProfit = CraftProfit,
    IsProfitable = IsProfitable,
    ReagentCost = ReagentCost,
    GetOutputItemID = GetOutputItemID,
    GetSellPrice = GetSellPrice,
    CycleMode = function() CycleMode() end,
    GetMode = function() return mode end,
    RepaintAll = RepaintAll,
    PROFIT_THRESHOLD = PROFIT_THRESHOLD,
}

Refresh()
