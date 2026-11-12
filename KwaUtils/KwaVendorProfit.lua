local addonName, KU = ...

-- Adds a "Vendor Profit" line underneath Auctionator's crafting profit line on
-- the modern Professions crafting page.
--
-- Auctionator calculates: auction value of the crafted item - cost of reagents.
-- This does the same, but uses the item's vendor sell price for the output.
-- Reagent costs come from Auctionator's existing price calculation, which uses
-- vendor buy prices when known and falls back to auction prices.

local GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
local GetMoneyString = GetMoneyString
local GetCoinTextureString = GetCoinTextureString

local vendorFrame
local hooked = false
local hookedInitialize = false

local function GetAuctionatorFrame()
    return _G.AuctionatorCraftingInfoProfessionsFrame
end

local function HasAuctionatorAPI()
    return Auctionator
        and Auctionator.CraftingInfo
        and type(Auctionator.CraftingInfo.CalculateCraftCost) == "function"
end

local function FormatMoney(copper)
    copper = math.floor(tonumber(copper) or 0)
    if GetMoneyString then
        local ok, text = pcall(GetMoneyString, copper, true)
        if ok and text then
            return text
        end
    end
    if GetCoinTextureString then
        local ok, text = pcall(GetCoinTextureString, copper)
        if ok and text then
            return text
        end
    end
    return tostring(copper) .. "c"
end

local function ColorText(text, positive)
    local color = positive and WHITE_FONT_COLOR or RED_FONT_COLOR
    if color and color.WrapTextInColorCode then
        return color:WrapTextInColorCode(text)
    end
    return text
end

local function GetItemSellPrice(itemLinkOrID)
    local itemInfo = {GetItemInfo(itemLinkOrID)}
    return itemInfo[11]
end

local function GetEnchantOutputLink(recipeID)
    local enchantItems = Auctionator
        and Auctionator.CraftingInfo
        and Auctionator.CraftingInfo.EnchantSpellsToItems
    local itemIDs = enchantItems and enchantItems[recipeID]
    if not itemIDs or not itemIDs[1] then
        return nil
    end
    local _, link = GetItemInfo(itemIDs[1])
    return link
end

local function GetOutputLink(schematicForm, recipeInfo)
    if recipeInfo.isEnchantingRecipe then
        return GetEnchantOutputLink(recipeInfo.recipeID)
    end

    local transaction = schematicForm:GetTransaction()
    if not transaction then
        return nil
    end

    local ok, operationInfo = pcall(
        C_TradeSkillUI.GetCraftingOperationInfo,
        recipeInfo.recipeID,
        transaction:CreateCraftingReagentInfoTbl(),
        transaction:GetAllocationItemGUID(),
        transaction:IsApplyingConcentration()
    )
    if not ok then
        operationInfo = nil
    end

    local qualityOverride = operationInfo
        and recipeInfo.qualityIDs
        and recipeInfo.qualityIDs[operationInfo.craftingQuality]

    local qualityItemIDs = C_TradeSkillUI.GetRecipeQualityItemIDs(recipeInfo.recipeID)
    if not qualityItemIDs or #qualityItemIDs == 1 then
        local outputData = C_TradeSkillUI.GetRecipeOutputItemData(
            recipeInfo.recipeID,
            transaction:CreateOptionalCraftingReagentInfoTbl(),
            transaction:GetAllocationItemGUID(),
            qualityOverride
        )
        return outputData and outputData.hyperlink
    end

    local qualityIDs = C_TradeSkillUI.GetQualitiesForRecipe(recipeInfo.recipeID)
    local index = 1
    if qualityIDs and qualityOverride ~= nil then
        for i, qualityID in ipairs(qualityIDs) do
            if qualityID == qualityOverride then
                index = i
                break
            end
        end
    end

    local _, link = GetItemInfo(qualityItemIDs[index])
    return link
end

local function GetCraftCost(schematicForm, recipeInfo)
    if not HasAuctionatorAPI() then
        return nil
    end

    local ok, cost = pcall(function()
        local recipeLevel = schematicForm:GetCurrentRecipeLevel()
        local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(
            recipeInfo.recipeID,
            false,
            recipeLevel
        )
        local transaction = schematicForm:GetTransaction()
        if not recipeSchematic or not transaction then
            return nil
        end
        return Auctionator.CraftingInfo.CalculateCraftCost(recipeSchematic, transaction)
    end)

    if ok then
        return cost
    end
    return nil
end

local function Update(frame)
    if not frame or not vendorFrame or not vendorFrame.text then
        return
    end

    local ok, text = pcall(function()
        local schematicForm = frame:GetParent()
        if not schematicForm or not schematicForm.GetRecipeInfo then
            return nil
        end

        local recipeInfo = schematicForm:GetRecipeInfo()
        if not recipeInfo or not recipeInfo.recipeID then
            return nil
        end

        local recipeSchematic = schematicForm.recipeSchematic
        local outputLink = GetOutputLink(schematicForm, recipeInfo)
        if not outputLink then
            return nil
        end

        local sellPrice = GetItemSellPrice(outputLink)
        if not sellPrice or sellPrice <= 0 then
            return nil
        end

        local quantity = (recipeSchematic and recipeSchematic.quantityMin) or 1
        local cost = GetCraftCost(schematicForm, recipeInfo) or 0
        local profit = sellPrice * quantity - cost

        local price
        if profit >= 0 then
            price = ColorText(FormatMoney(profit), true)
        else
            price = ColorText("-" .. FormatMoney(-profit), false)
        end

        return "Vendor Profit: " .. price
    end)

    if ok and text then
        vendorFrame.text:SetText(text)
        vendorFrame:Show()
    else
        vendorFrame.text:SetText("")
        vendorFrame:Hide()
    end
end

local function CreateVendorFrame(auctionatorFrame)
    if vendorFrame then
        return vendorFrame
    end

    local frame = CreateFrame("Frame", "KwaVendorProfitFrame", auctionatorFrame)
    frame:SetSize(300, 16)
    frame:SetPoint("TOPLEFT", auctionatorFrame, "BOTTOMLEFT", 0, -2)
    frame:SetFrameLevel(auctionatorFrame:GetFrameLevel() + 1)

    local text = frame:CreateFontString("KwaVendorProfitText", "OVERLAY", "GameFontNormal")
    text:SetPoint("TOPLEFT")
    text:SetJustifyH("LEFT")
    text:SetText("")
    frame.text = text

    frame:Hide()
    vendorFrame = frame
    return frame
end

local function Attach(auctionatorFrame)
    if not auctionatorFrame then
        return
    end
    CreateVendorFrame(auctionatorFrame)
    Update(auctionatorFrame)
end

local function TryHookAuctionator()
    if hooked then
        return
    end

    local mixin = _G.AuctionatorCraftingInfoProfessionsFrameMixin
    if type(mixin) ~= "table" or type(mixin.UpdateTotal) ~= "function" then
        return
    end

    hooksecurefunc(mixin, "UpdateTotal", function(self)
        Attach(self)
    end)

    if type(mixin.ShowIfRelevant) == "function" then
        hooksecurefunc(mixin, "ShowIfRelevant", function(self)
            if self:IsVisible() then
                Attach(self)
            end
        end)
    end

    hooked = true
end

local function HookInitialize()
    if hookedInitialize then
        return
    end
    if Auctionator
        and Auctionator.CraftingInfo
        and type(Auctionator.CraftingInfo.InitializeProfessionsFrame) == "function"
    then
        hooksecurefunc(Auctionator.CraftingInfo, "InitializeProfessionsFrame", function()
            Attach(GetAuctionatorFrame())
        end)
        hookedInitialize = true
    end
end

local function Refresh()
    TryHookAuctionator()
    HookInitialize()
    Attach(GetAuctionatorFrame())
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("TRADE_SKILL_SHOW")
eventFrame:RegisterEvent("MERCHANT_SHOW")
eventFrame:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")

eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "ADDON_LOADED" then
        if arg1 == "Auctionator" then
            Refresh()
        end
    elseif event == "PLAYER_LOGIN" then
        Refresh()
    elseif event == "TRADE_SKILL_SHOW" then
        Refresh()
    elseif event == "MERCHANT_SHOW" then
        -- Auctionator caches vendor buy prices asynchronously.
        if C_Timer and C_Timer.After then
            C_Timer.After(1, Refresh)
        end
    elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
        if arg1 == Enum.PlayerInteractionType.Merchant then
            if C_Timer and C_Timer.After then
                C_Timer.After(1, Refresh)
            end
        end
    end
end)

Refresh()
