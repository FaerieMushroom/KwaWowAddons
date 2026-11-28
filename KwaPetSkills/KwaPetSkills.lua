local addonName, KPS = ...

-- Optional plugin: it only registers for hunters, and only when KwaLite is
-- installed. The hardcoded ability data lives in KwaPetSkillsData.lua.
if not (KwaLite and KwaLite.RegisterAddon and KwaLite.Util) then
    return
end

local Util = KwaLite.Util

local SECTION_ROW = 20
local ABILITY_ROW = 34

local panel
local scroll
local content
local statusLabel
local showUnlearnableCheck
local checkLabel
local rows = {}
local rowCount = 0
local hoveredRow
local tooltipZone
local tooltipPetLevel
local tooltipElapsed = 0

local registered = false
local state = {
    petName = nil,
    petLevel = nil,
    playerLevel = nil,
    family = nil,
    known = {},
    petRanks = {},
    onPet = {},
}

local SafeCall = function(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

local function ReadPet()
    state.petName = SafeCall(UnitName, "pet")
    state.petLevel = SafeCall(UnitLevel, "pet")
    if state.petLevel and state.petLevel <= 0 then state.petLevel = nil end
    state.playerLevel = SafeCall(UnitLevel, "player")
    if state.playerLevel and state.playerLevel <= 0 then state.playerLevel = nil end
    state.family = SafeCall(UnitCreatureFamily, "pet")
    if state.family == "" then state.family = nil end
end

local function SpellName(spellID)
    if C_Spell and C_Spell.GetSpellName then
        return SafeCall(C_Spell.GetSpellName, spellID)
    end
    return SafeCall(GetSpellInfo, spellID)
end

local function SpellSubtext(spellID)
    if C_Spell and C_Spell.GetSpellSubtext then
        local value = SafeCall(C_Spell.GetSpellSubtext, spellID)
        if value ~= nil then return value end
    end
    if GetSpellInfo then
        local ok, _, subtext = pcall(GetSpellInfo, spellID)
        if ok then return subtext end
    end
end

local function RankFromText(text)
    if type(text) ~= "string" then return nil end
    return tonumber(text:match("(%d+)%s*$"))
end

local function RankNumber(rank)
    return RankFromText(rank and rank.name) or 0
end

local function SpellBookBanks()
    local banks = {}
    local enum = Enum and Enum.SpellBookSpellBank
    banks[1] = (enum and enum.Player) or 0
    banks[2] = (enum and enum.Pet) or 1
    return banks
end

local function StoreRank(map, key, entry)
    local existing = map[key]
    if not existing or (entry.rank or 0) >= (existing.rank or 0) then
        map[key] = entry
    end
end

local function ScanSpellbook()
    state.known = {}
    state.petRanks = {}
    if not (C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines
        and C_SpellBook.GetSpellBookItemInfo) then
        return
    end

    local numLines = SafeCall(C_SpellBook.GetNumSpellBookSkillLines) or 0
    for line = 1, numLines do
        local info = SafeCall(C_SpellBook.GetSpellBookSkillLineInfo, line)
        local offset, count
        if type(info) == "table" then
            offset = info.itemIndexOffset
            count = info.numSpellBookItems
        end
        if type(offset) == "number" and type(count) == "number" then
            for bankIndex, bank in ipairs(SpellBookBanks()) do
                for index = offset + 1, offset + count do
                    local item = SafeCall(C_SpellBook.GetSpellBookItemInfo, index, bank)
                    local spellID
                    if type(item) == "table" then
                        spellID = item.spellID
                    elseif type(item) == "number" then
                        spellID = item
                    end
                    if spellID then
                        local name = SpellName(spellID)
                        if name then
                            local rank = RankFromText(SpellSubtext(spellID)) or 0
                            local key = name:lower()
                            local entry = {
                                id = spellID,
                                name = name,
                                rank = rank,
                                bank = bankIndex,
                            }
                            StoreRank(state.known, key, entry)
                            if bankIndex == 2 then
                                StoreRank(state.petRanks, key, entry)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function ScanPetActions()
    state.onPet = {}
    if not GetPetActionInfo then return end
    for index = 1, 10 do
        local ok, name, _, _, _, _, _, spellID = pcall(GetPetActionInfo, index)
        if ok and type(name) == "string" and name ~= "" then
            local key = name:lower()
            state.onPet[key] = true
            if spellID then
                local spellName = SpellName(spellID) or name
                -- The action bar is authoritative for the pet's current rank,
                -- so overwrite whatever the pet spellbook bank reported.
                state.petRanks[spellName:lower()] = {
                    id = spellID,
                    name = spellName,
                    rank = RankFromText(SpellSubtext(spellID)) or 0,
                }
            end
        end
    end
end

local function RankByNumber(ability, number)
    if not number or number <= 0 then return nil end
    for _, rank in ipairs(ability.ranks or {}) do
        if RankNumber(rank) == number then return rank end
    end
end

local function BestRank(ability, petLevel)
    local best
    for _, rank in ipairs(ability.ranks or {}) do
        if rank.level and petLevel and petLevel >= rank.level then
            if not best or RankNumber(rank) > RankNumber(best) then
                best = rank
            end
        end
    end
    return best or (ability.ranks and ability.ranks[1])
end

-- The rank the pet actually has, which can be lower than the best rank the
-- hunter knows or the best rank the pet's level would allow.
local function PetRank(ability)
    local petKnown = state.petRanks[ability.name:lower()]
    if petKnown and petKnown.rank and petKnown.rank > 0 then
        return RankByNumber(ability, petKnown.rank) or BestRank(ability, state.petLevel)
    end
    return BestRank(ability, state.petLevel)
end

local function RankLabel(ability, rank)
    if not rank then return "No rank data" end
    local number = RankNumber(rank)
    if number > 0 then
        return "Rank " .. number
    end
    return rank.name or "Rank"
end

-- UnitCreatureFamily returns a singular family name ("Turtle"), while the
-- Petopia data uses plurals ("Turtles"). Normalize both to compare them.
local function NormalizeFamily(name)
    if type(name) ~= "string" then return nil end
    name = name:lower():gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if name:sub(-3) == "ies" then
        return name:sub(1, -4) .. "y"
    end
    if name:sub(-3) == "ves" then
        return name:sub(1, -4) .. "f"
    end
    if name:sub(-2) == "es" then
        local before = name:sub(-3, -3)
        local stem = name:sub(-4, -3)
        if stem == "sh" or stem == "ch" or stem == "ss" or before == "x"
            or before == "s" or before == "z" then
            return name:sub(1, -3)
        end
    end
    if name:sub(-1) == "s" then
        return name:sub(1, -2)
    end
    return name
end

local function AbilityFitsFamily(ability, family)
    if not family then return true end
    local families = ability.families or ""
    if families == "All Families" then return true end

    local target = NormalizeFamily(family)
    for entry in families:gmatch("[^,]+") do
        if NormalizeFamily(entry) == target then return true end
    end
    return false
end

local function ClassifyAbilities()
    local compatible, incompatible = {}, {}
    for _, ability in ipairs(KPS.Abilities or {}) do
        if AbilityFitsFamily(ability, state.family) then
            compatible[#compatible + 1] = ability
        else
            incompatible[#incompatible + 1] = ability
        end
    end

    local unlearned, known = {}, {}
    local trainer, tame = {}, {}
    for _, ability in ipairs(compatible) do
        local key = ability.name:lower()
        local petKnown = state.petRanks[key]
        local isKnown = petKnown or state.onPet[key]
        if isKnown then
            known[#known + 1] = ability
        end

        local petNumber = petKnown and petKnown.rank or 0
        local best = BestRank(ability, state.petLevel)

        if best and best.trainer then
            -- Trainer skills are bought one rank at a time, so keep a single
            -- row for the best rank the pet qualifies for.
            if RankNumber(best) > petNumber then
                unlearned[#unlearned + 1] = ability
                trainer[#trainer + 1] = ability
            end
        else
            -- Tameable skills are learned by taming pets of the right level,
            -- so list every unlearned rank as its own row. The rank the pet
            -- already has stays in the known section only. You can only tame a
            -- pet up to your own level, so filter by player level, not pet level.
            local playerLevel = state.playerLevel
            local ranksAdded = false
            for _, rank in ipairs(ability.ranks or {}) do
                if RankNumber(rank) > petNumber
                    and (not playerLevel or not rank.level or rank.level <= playerLevel) then
                    tame[#tame + 1] = { ability = ability, rank = rank }
                    ranksAdded = true
                end
            end
            if ranksAdded then
                unlearned[#unlearned + 1] = ability
            end
        end
    end

    return compatible, incompatible, unlearned, known, trainer, tame
end

local function GetSettings()
    if type(KwaLiteDB) ~= "table" then KwaLiteDB = {} end
    if type(KwaLiteDB.addons) ~= "table" then KwaLiteDB.addons = {} end
    local db = KwaLiteDB.addons.KwaPetSkills
    if type(db) ~= "table" then
        db = {}
        KwaLiteDB.addons.KwaPetSkills = db
    end
    return db
end

local function CurrentZone()
    local zone = SafeCall(GetRealZoneText)
    if not zone or zone == "" then
        zone = SafeCall(GetZoneText)
    end
    return zone
end

local function ZoneMatches(a, b)
    if not a or not b or a == "" or b == "" then return false end
    a, b = a:lower(), b:lower()
    return a == b or a:find(b, 1, true) ~= nil or b:find(a, 1, true) ~= nil
end

local function SourceMaxLevel(source)
    local level = source[4]
    if type(level) ~= "string" then return nil end
    local low, high = level:match("(%d+)%s*%-%s*(%d+)")
    if low then return tonumber(high) end
    return tonumber(level:match("(%d+)"))
end

local function SortedSources(rank)
    local preferred, rest = {}, {}
    local zone = CurrentZone()
    local petLevel = state.petLevel

    for _, source in ipairs(rank.sources or {}) do
        local currentZone = zone and ZoneMatches(source[5], zone)
        local maxLevel = SourceMaxLevel(source)
        local levelOk = petLevel and maxLevel and maxLevel <= petLevel
        if currentZone and levelOk then
            preferred[#preferred + 1] = source
        else
            rest[#rest + 1] = source
        end
    end

    local sorted = {}
    for _, source in ipairs(preferred) do sorted[#sorted + 1] = source end
    for _, source in ipairs(rest) do sorted[#sorted + 1] = source end
    return sorted
end

local function ShowAbilityTooltip(frame, ability, rank, refresh)
    if not GameTooltip or not ability then return end

    if not (refresh and GameTooltip.GetOwner and GameTooltip:GetOwner() == frame) then
        GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
    elseif refresh then
        GameTooltip:ClearLines()
    end

    -- Prefer the real spell tooltip for the rank the pet actually has, then
    -- for a rank the hunter knows. Otherwise fall back to the Petopia data.
    local key = ability.name:lower()
    local petKnown = state.petRanks[key]
    local hunterKnown = state.known[key]
    local known = petKnown or hunterKnown
    local shown = false
    if known and known.id and GameTooltip.SetSpellByID then
        local ok = pcall(GameTooltip.SetSpellByID, GameTooltip, known.id)
        if ok then shown = true end
    end

    if not shown then
        GameTooltip:AddLine(ability.name, 1, 0.82, 0)
        if ability.desc and ability.desc ~= "" then
            GameTooltip:AddLine(ability.desc, 1, 1, 1, true)
        end
        GameTooltip:AddLine(" ")
        if rank then
            GameTooltip:AddDoubleLine("Rank:", RankLabel(ability, rank), 1, 1, 1, 0.82, 0.82, 0.82)
            if rank.level then
                GameTooltip:AddDoubleLine("Pet level:", tostring(rank.level), 1, 1, 1, 0.82, 0.82, 0.82)
            end
            if rank.cost then
                GameTooltip:AddDoubleLine("Training cost:", tostring(rank.cost) .. " TP", 1, 1, 1, 0.82, 0.82, 0.82)
            end
            if rank.desc and rank.desc ~= "" then
                GameTooltip:AddLine(rank.desc, 0.9, 0.9, 0.9, true)
            end
        end
    else
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Best rank for pet level: " .. ((rank and rank.name) or "--"), 0.9, 0.9, 0.9)
        if rank and rank.level then
            GameTooltip:AddLine("Requires pet level " .. tostring(rank.level), 0.9, 0.9, 0.9)
        end
    end

    if petKnown then
        GameTooltip:AddLine("On your pet: "
            .. (petKnown.rank and petKnown.rank > 0 and ("Rank " .. petKnown.rank) or "Yes"),
            0.4, 0.8, 1)
    elseif state.onPet[key] then
        GameTooltip:AddLine("On your pet", 0.4, 0.8, 1)
    end
    if hunterKnown then
        GameTooltip:AddLine("Known by hunter: "
            .. (hunterKnown.rank and hunterKnown.rank > 0 and ("Rank " .. hunterKnown.rank) or "Yes"),
            0.4, 1, 0.4)
    end
    if not known and not state.onPet[key] then
        GameTooltip:AddLine("Not learned yet", 1, 0.4, 0.4)
    end

    if rank and rank.sources and #rank.sources > 0 then
        local sources = SortedSources(rank)
        local shownCount = math.min(#sources, 15)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Sources (" .. #sources .. "):", 1, 0.82, 0)

        for index = 1, shownCount do
            local source = sources[index]
            local mob = source[1] or "Unknown"
            local level = source[4]
            local zone = source[5]

            GameTooltip:AddLine("  " .. mob, 1, 1, 1)

            local detail = ""
            if level and level ~= "" then detail = "Lvl " .. level end
            if zone and zone ~= "" then
                detail = detail ~= "" and (detail .. " · " .. zone) or zone
            end
            if detail ~= "" then
                GameTooltip:AddLine("     " .. detail, 0.65, 0.65, 0.65)
            end
        end

        if #rank.sources > shownCount then
            GameTooltip:AddLine("  +" .. (#rank.sources - shownCount) .. " more source"
                .. (#rank.sources - shownCount == 1 and "" or "s"), 0.65, 0.65, 0.65)
        end
    elseif rank and rank.trainer then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Learned from a pet trainer.", 0.4, 1, 0.4)
    end

    GameTooltip:Show()
end

local function UpdateContentWidth()
    Util.FitContentWidth(scroll, content, panel, 24, 240)
end

local function ResetRows()
    rowCount = 0
    for index = 1, #rows do
        rows[index]:Hide()
    end
end

local function AcquireRow(y, height, icon, ability, rank)
    rowCount = rowCount + 1
    local row = rows[rowCount]
    if not row then
        row = CreateFrame("Frame", nil, content)
        row:EnableMouse(true)
        row.icon = row:CreateTexture(nil, "ARTWORK")
        row.icon:SetSize(18, 18)
        row.icon:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -1)
        row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.text:SetJustifyH("LEFT")
        row.text:SetWordWrap(false)
        row.detail = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        row.detail:SetJustifyH("LEFT")
        row.detail:SetWordWrap(false)
        row:SetScript("OnEnter", function(self)
            hoveredRow = self
            tooltipZone = CurrentZone()
            tooltipPetLevel = state.petLevel
            tooltipElapsed = 0
            ShowAbilityTooltip(self, self.ability, self.rank)
        end)
        row:SetScript("OnLeave", function(self)
            if hoveredRow == self then
                hoveredRow = nil
                tooltipZone = nil
                tooltipPetLevel = nil
            end
            if GameTooltip then GameTooltip:Hide() end
        end)
        rows[rowCount] = row
    end

    row:ClearAllPoints()
    row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
    row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
    row:SetHeight(height)
    row.ability, row.rank = ability, rank
    row.icon:Hide()
    row.detail:Hide()

    local left = 0
    if icon then
        row.icon:SetTexture(icon)
        row.icon:Show()
        left = 24
    end
    row.text:ClearAllPoints()
    row.text:SetPoint("TOPLEFT", row, "TOPLEFT", left, 0)
    row.text:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 0)
    row.detail:ClearAllPoints()
    row.detail:SetPoint("TOPLEFT", row, "TOPLEFT", left, -17)
    row.detail:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, -17)

    row:Show()
    return row
end

local function SectionHeader(y, title)
    local row = AcquireRow(y, SECTION_ROW, nil, nil, nil)
    row.text:SetText("|cffffd100" .. title .. "|r")
    return y + SECTION_ROW + 2
end

local function AddSkillRow(y, ability, rank, mode)
    local row = AcquireRow(y, ABILITY_ROW, ability.icon, ability, rank)

    row.text:SetText("|cffffffff" .. ability.name .. "|r")

    local meta = { RankLabel(ability, rank) }
    if rank and rank.level then meta[#meta + 1] = "pet lvl " .. rank.level end
    if rank and rank.cost then meta[#meta + 1] = rank.cost .. " TP" end
    if mode == "known" then
        meta[#meta + 1] = state.onPet[ability.name:lower()] and "On your pet" or "Known"
    elseif rank and rank.trainer then
        meta[#meta + 1] = "Pet trainer"
    else
        meta[#meta + 1] = "Tame"
    end
    row.detail:SetText("|cff9d9d9d" .. table.concat(meta, "  ·  ") .. "|r")
    row.detail:Show()

    return y + ABILITY_ROW + 2
end

local AddonPanel

local function BuildContent()
    if not content then return end
    ResetRows()

    -- Without a pet there is no family or level to filter by, and no tame
    -- sources are usable yet, so only show the general trainer skills.
    if not state.petName then
        local trainer = {}
        for _, ability in ipairs(KPS.Abilities or {}) do
            local rank = BestRank(ability, nil)
            if rank and rank.trainer then
                trainer[#trainer + 1] = ability
            end
        end

        local y = SectionHeader(0, "Unlearned trainer skills (" .. #trainer .. ")")
        for _, ability in ipairs(trainer) do
            y = AddSkillRow(y, ability, BestRank(ability, nil), "unlearned")
        end

        UpdateContentWidth()
        content:SetHeight(math.max(1, y))
        return
    end

    local compatible, incompatible, unlearned, known, trainer, tame = ClassifyAbilities()
    local y = 0

    if showUnlearnableCheck and showUnlearnableCheck:GetChecked() and #incompatible > 0 then
        local label = "Not available to " .. (state.family or "this pet")
        y = SectionHeader(y, label .. " (" .. #incompatible .. ")")
        for _, ability in ipairs(incompatible) do
            y = AddSkillRow(y, ability, BestRank(ability, state.petLevel), "unlearned")
        end
        y = y + 4
    end

    if #compatible == 0 then
        local row = AcquireRow(y, 26, nil, nil, nil)
        row.text:SetText("|cff9d9d9dNo abilities match this pet family.|r")
        y = y + 26
    else
        if #unlearned == 0 then
            y = SectionHeader(y, "Unlearned skills (0)")
            local row = AcquireRow(y, 18, nil, nil, nil)
            row.text:SetText("|cff40ff40All available abilities are learned.|r")
            y = y + 24
        else
            if #trainer > 0 then
                y = SectionHeader(y, "Unlearned trainer skills (" .. #trainer .. ")")
                for _, ability in ipairs(trainer) do
                    y = AddSkillRow(y, ability, BestRank(ability, state.petLevel), "unlearned")
                end
                y = y + 4
            end

            if #tame > 0 then
                y = SectionHeader(y, "Unlearned tame skills (" .. #tame .. ")")
                for _, entry in ipairs(tame) do
                    y = AddSkillRow(y, entry.ability, entry.rank, "unlearned")
                end
                y = y + 4
            end
        end

        y = SectionHeader(y, "Known skills (" .. #known .. ")")
        if #known == 0 then
            local row = AcquireRow(y, 18, nil, nil, nil)
            row.text:SetText("|cff9d9d9dNo matching abilities learned yet.|r")
            y = y + 20
        else
            for _, ability in ipairs(known) do
                y = AddSkillRow(y, ability, PetRank(ability), "known")
            end
        end
    end

    UpdateContentWidth()
    content:SetHeight(math.max(1, y))
end

local RefreshPanel

AddonPanel = function(parent)
    if panel then return panel end

    panel = CreateFrame("Frame", nil, parent)

    statusLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    statusLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -2)
    statusLabel:SetPoint("RIGHT", panel, "RIGHT", -130, -2)
    statusLabel:SetJustifyH("LEFT")
    statusLabel:SetWordWrap(false)
    statusLabel:SetText("|cff9d9d9dNo pet summoned|r")

    showUnlearnableCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    showUnlearnableCheck:SetSize(20, 20)
    showUnlearnableCheck:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    showUnlearnableCheck:SetChecked(GetSettings().showUnlearnable and true or false)
    showUnlearnableCheck:SetScript("OnClick", function(self)
        GetSettings().showUnlearnable = self:GetChecked() and true or false
        BuildContent()
    end)
    showUnlearnableCheck:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Show unlearnable skills", 1, 0.82, 0)
        GameTooltip:AddLine("Includes abilities that are not available to your current pet family.",
            1, 1, 1, true)
        GameTooltip:Show()
    end)
    showUnlearnableCheck:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    checkLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    checkLabel:SetPoint("RIGHT", showUnlearnableCheck, "LEFT", -2, 0)
    checkLabel:SetText("Show unlearnable")

    scroll, content = Util.CreateScrollPanel(panel, { top = 24 })

    panel:SetScript("OnShow", function()
        RefreshPanel()
    end)

    return panel
end

RefreshPanel = function()
    if not panel then return end

    ReadPet()
    ScanSpellbook()
    ScanPetActions()

    local status
    if state.petName then
        status = (state.family or "Unknown") .. " - Lvl " .. (state.petLevel or "?")
    else
        status = "No pet summoned"
    end
    statusLabel:SetText("|cff9d9d9d" .. status .. "|r")

    if showUnlearnableCheck then
        showUnlearnableCheck:SetShown(state.petName ~= nil)
    end
    if checkLabel then
        checkLabel:SetShown(state.petName ~= nil)
    end

    if panel:IsShown() then
        BuildContent()
        if scroll then scroll:SetVerticalScroll(0) end
    end
end

local function IsHunter()
    local _, class = UnitClass("player")
    return class == "HUNTER"
end

local function TryRegister()
    if registered or not IsHunter() then return end

    registered = true
    KwaLite:RegisterAddon({
        id = "KwaPetSkills",
        name = "Pet Skills",
        icon = "Interface\\Icons\\ability_hunter_beasttaming",
        priority = 4,
        createPanel = AddonPanel,
        refresh = function() RefreshPanel() end,
    })
    RefreshPanel()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("UNIT_PET")
eventFrame:RegisterEvent("PET_BAR_UPDATE")
eventFrame:RegisterEvent("PET_UI_UPDATE")
eventFrame:RegisterEvent("PET_STABLE_UPDATE")
eventFrame:RegisterEvent("SPELLS_CHANGED")
eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        TryRegister()
    end
    if not registered then return end

    if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
        RefreshPanel()
    elseif event == "UNIT_PET" or event == "PET_BAR_UPDATE" or event == "PET_UI_UPDATE"
        or event == "PET_STABLE_UPDATE" or event == "SPELLS_CHANGED"
        or event == "PLAYER_LEVEL_UP" then
        RefreshPanel()
    end
end)

TryRegister()

-- Keep a hovered tooltip current when the player changes zone or the pet's
-- level changes, so the current-zone source sorting stays accurate.
local tooltipUpdater = CreateFrame("Frame")
tooltipUpdater:SetScript("OnUpdate", function(_, elapsed)
    if not hoveredRow or not GameTooltip or not GameTooltip:IsShown() then
        tooltipElapsed = 0
        return
    end

    tooltipElapsed = tooltipElapsed + elapsed
    if tooltipElapsed < 1 then return end
    tooltipElapsed = 0

    local zone = CurrentZone()
    local petLevel = state.petLevel
    if zone == tooltipZone and petLevel == tooltipPetLevel then return end

    tooltipZone = zone
    tooltipPetLevel = petLevel
    ShowAbilityTooltip(hoveredRow, hoveredRow.ability, hoveredRow.rank, true)
end)
