local addonName, NS = ...

-- Unit Labeler: puts a chosen icon on friendly/enemy nameplates whose unit name
-- matches an entry. Icons are ordinary textures on the nameplate's unit frame,
-- so they scale and move with the plate.
--
-- Friendly NPC nameplates only appear when the client is configured to show
-- them, and friendly plates inside instances are protected from addons.

if not (KwaLite and KwaLite.RegisterAddon and KwaLite.Util) then
    return
end

local Util = KwaLite.Util

local DEFAULT_ICON = Util.DEFAULT_ICON
local ROW_HEIGHT = 26
local DEFAULT_ICON_SIZE = 18
local ICON_SIZE_MIN = 10
local ICON_SIZE_MAX = 48

local ANCHORS = {
    { id = "top", label = "On top" },
    { id = "left", label = "Left" },
    { id = "right", label = "Right" },
}

local ICONS = {
    -- Raid markers
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2",
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5",
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
    "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
    -- Class icons
    "Interface\\Icons\\ClassIcon_Warrior",
    "Interface\\Icons\\ClassIcon_Mage",
    "Interface\\Icons\\ClassIcon_Rogue",
    "Interface\\Icons\\ClassIcon_Priest",
    "Interface\\Icons\\ClassIcon_Hunter",
    "Interface\\Icons\\ClassIcon_Warlock",
    "Interface\\Icons\\ClassIcon_Paladin",
    "Interface\\Icons\\ClassIcon_Druid",
    "Interface\\Icons\\ClassIcon_Shaman",
    -- Generic markers and useful symbols
    "Interface\\Icons\\INV_Misc_QuestionMark",
    "Interface\\Icons\\INV_Misc_Bone_01",
    "Interface\\Icons\\INV_Misc_Bone_02",
    "Interface\\Icons\\INV_Misc_Coin_01",
    "Interface\\Icons\\INV_Misc_Gear_01",
    "Interface\\Icons\\INV_Misc_Spyglass_02",
    "Interface\\Icons\\INV_Misc_Note_01",
    "Interface\\Icons\\INV_Misc_Map_01",
    "Interface\\Icons\\INV_Misc_Book_09",
    "Interface\\Icons\\INV_Misc_Bag_07",
    "Interface\\Icons\\INV_Misc_Key_01",
    "Interface\\Icons\\INV_Misc_Rune_01",
    "Interface\\Icons\\INV_Misc_Gem_01",
    "Interface\\Icons\\INV_Misc_Herb_03",
    "Interface\\Icons\\INV_Misc_Food_15",
    "Interface\\Icons\\INV_Misc_Fish_02",
    "Interface\\Icons\\INV_Misc_ArmorKit_01",
    "Interface\\Icons\\INV_Misc_Shell_02",
    "Interface\\Icons\\INV_Misc_Head_Dragon_01",
    "Interface\\Icons\\INV_Misc_Head_Human_01",
    "Interface\\Icons\\Ability_Hunter_MarkedForDeath",
    "Interface\\Icons\\Ability_Warrior_Charge",
    "Interface\\Icons\\Ability_Rogue_SinisterStrike",
    "Interface\\Icons\\Spell_Holy_HolyBolt",
    "Interface\\Icons\\Spell_Holy_PowerWordShield",
    "Interface\\Icons\\Spell_Fire_Fireball02",
    "Interface\\Icons\\Spell_Frost_FrostBolt02",
    "Interface\\Icons\\Spell_Nature_Lightning",
    "Interface\\Icons\\Spell_Shadow_ShadowBolt",
    "Interface\\Icons\\Trade_Alchemy",
    "Interface\\Icons\\Trade_BlackSmithing",
    -- Hearthstone and Delves icons
    "Interface\\Icons\\inv_mousehearthstone",
    "Interface\\Icons\\inv_ratmounthearthstone",
    "Interface\\Icons\\delves-scenario-heart-icon-2x",
    "Interface\\Icons\\delves-scenario-heart-icon",
}

local panel
local addButton
local scroll
local content
local emptyLabel
local rowPool
local focusRow

local settingsPanel
local anchorDropdown
local anchorDropdownLabel
local anchorMenu
local anchorOverlay
local iconSizeSlider
local iconSizeValue

local iconPicker
local iconOverlay
local iconButtons
local pickerEntry
local ShowIconPicker

local labelFrames = setmetatable({}, { __mode = "k" })
local activeIcons = {}

local function EnsureDB()
    if type(KwaUnitLabelerDB) ~= "table" then KwaUnitLabelerDB = {} end
    local db = KwaUnitLabelerDB
    if type(db.entries) ~= "table" then db.entries = {} end
    if db.anchor ~= "left" and db.anchor ~= "right" then db.anchor = "top" end
    if type(db.iconSize) ~= "number" then
        db.iconSize = DEFAULT_ICON_SIZE
    end
    db.iconSize = math.max(ICON_SIZE_MIN, math.min(ICON_SIZE_MAX, math.floor(db.iconSize + 0.5)))

    for index = #db.entries, 1, -1 do
        local entry = db.entries[index]
        if type(entry) ~= "table" then
            table.remove(db.entries, index)
        else
            if type(entry.name) ~= "string" then entry.name = "" end
            if type(entry.icon) ~= "string" or entry.icon == "" then
                entry.icon = DEFAULT_ICON
            end
        end
    end

    return db
end

local function NormalizeName(name)
    if type(name) ~= "string" then return "" end
    return (name:match("^%s*(.-)%s*$") or ""):lower()
end

local function FindEntry(keys)
    if type(keys) ~= "table" then return nil end
    for _, entry in ipairs(EnsureDB().entries) do
        local key = NormalizeName(entry.name)
        if key ~= "" and keys[key] then
            return entry
        end
    end
end

local function AnchorLabel(id)
    for _, option in ipairs(ANCHORS) do
        if option.id == id then return option.label end
    end
    return ANCHORS[1].label
end

local function PositionLabel(display)
    local frame = display.plateFrame
    if not frame then return end
    display:ClearAllPoints()
    local anchor = EnsureDB().anchor
    if anchor == "left" then
        display:SetPoint("RIGHT", frame, "LEFT", -2, 0)
    elseif anchor == "right" then
        display:SetPoint("LEFT", frame, "RIGHT", 2, 0)
    else
        local topFrame = frame:GetParent() or frame
        display:SetPoint("BOTTOM", topFrame, "TOP", 0, 2)
    end
end

local function CreateLabelDisplay(frame)
    local display = CreateFrame("Frame", nil, frame)
    local size = EnsureDB().iconSize
    display:SetSize(size, size)
    if display.SetFrameLevel and frame.GetFrameLevel then
        display:SetFrameLevel(frame:GetFrameLevel() + 5)
    end
    display.plateFrame = frame
    display.texture = display:CreateTexture(nil, "OVERLAY")
    display.texture:SetAllPoints()
    display.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    display:Hide()
    return display
end

local function UnitNameKeys(unit)
    local keys = {}
    if not UnitName then return keys end

    local ok, name, surname = pcall(UnitName, unit)
    if not ok then return keys end
    if issecretvalue and issecretvalue(name) then name = nil end
    if issecretvalue and issecretvalue(surname) then surname = nil end
    if type(name) ~= "string" or name == "" then return keys end

    local first = NormalizeName(name)
    if first ~= "" then keys[first] = true end

    -- On Forever the second return value is the player's surname, not a realm.
    if type(surname) == "string" then
        local last = NormalizeName(surname)
        if last ~= "" and not first:find(" " .. last, 1, true) then
            keys[first .. " " .. last] = true
        end
    end

    return keys
end

local function ApplyPlate(unit, frame)
    if not unit or not frame then return end

    local entry = FindEntry(UnitNameKeys(unit))
    local display = labelFrames[frame]

    if not entry then
        if display then display:Hide() end
        activeIcons[unit] = nil
        return
    end

    if not display then
        display = CreateLabelDisplay(frame)
        labelFrames[frame] = display
    end

    display.texture:SetTexture(entry.icon or DEFAULT_ICON)
    local size = EnsureDB().iconSize
    display:SetSize(size, size)
    display.unit = unit
    PositionLabel(display)
    display:Show()
    activeIcons[unit] = display
end

local function GetPlateFrame(unit)
    if not (C_NamePlate and C_NamePlate.GetNamePlateForUnit) then return nil end
    local ok, plate = pcall(C_NamePlate.GetNamePlateForUnit, unit)
    if ok and plate then
        return plate.UnitFrame or plate
    end
end

local function RefreshPlates()
    if not (C_NamePlate and C_NamePlate.GetNamePlates) then return end

    local ok, plates = pcall(C_NamePlate.GetNamePlates)
    if not ok or type(plates) ~= "table" then return end

    local seen = {}
    for _, plate in pairs(plates) do
        local frame = plate.UnitFrame or plate
        local unit = plate.namePlateUnitToken or (plate.UnitFrame and plate.UnitFrame.unit)
        if unit and frame then
            seen[unit] = true
            ApplyPlate(unit, frame)
        end
    end

    for unit, display in pairs(activeIcons) do
        if not seen[unit] then
            display:Hide()
            activeIcons[unit] = nil
        end
    end
end

-- Rows -------------------------------------------------------------------------

local function CreateRow(index)
    local row = CreateFrame("Frame", nil, content)
    row:SetHeight(ROW_HEIGHT)
    row:EnableMouse(true)

    row.background = row:CreateTexture(nil, "BACKGROUND")
    row.background:SetAllPoints()
    row.background:SetColorTexture(1, 1, 1, 0.04)
    row.background:Hide()

    row.edit = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
    row.edit:SetHeight(20)
    row.edit:SetPoint("TOPLEFT", row, "TOPLEFT", 4, -3)
    row.edit:SetPoint("TOPRIGHT", row, "TOPRIGHT", -50, -3)
    row.edit:SetAutoFocus(false)
    row.edit:SetMaxLetters(80)
    row.edit:SetFontObject("GameFontHighlightSmall")
    row.edit:SetScript("OnTextChanged", function(self)
        if self.entry then
            self.entry.name = self:GetText() or ""
            if not self.updating then RefreshPlates() end
        end
    end)
    row.edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    row.edit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    row.iconButton = CreateFrame("Button", nil, row, "BackdropTemplate")
    row.iconButton:SetSize(22, 22)
    row.iconButton:SetPoint("RIGHT", row, "RIGHT", -24, 0)
    row.iconButton:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    row.iconButton:SetBackdropColor(0.08, 0.08, 0.1, 1)
    row.iconButton:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)

    row.icon = row.iconButton:CreateTexture(nil, "ARTWORK")
    row.icon:SetAllPoints()
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    row.iconButton:SetScript("OnClick", function(self)
        if self.entry then ShowIconPicker(self) end
    end)
    row.iconButton:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.5, 0.5, 0.58, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Choose icon", 1, 0.82, 0)
        GameTooltip:Show()
    end)
    row.iconButton:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)
        GameTooltip:Hide()
    end)

    row.delete = CreateFrame("Button", nil, row)
    row.delete:SetSize(16, 16)
    row.delete:SetPoint("RIGHT", row, "RIGHT", -2, 0)
    local deleteText = row.delete:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    deleteText:SetAllPoints()
    deleteText:SetText("x")
    row.delete:SetScript("OnClick", function(self)
        local entry = self.entry
        if not entry then return end
        for i, candidate in ipairs(EnsureDB().entries) do
            if candidate == entry then
                table.remove(EnsureDB().entries, i)
                break
            end
        end
        Refresh()
        RefreshPlates()
    end)
    row.delete:SetScript("OnEnter", function()
        deleteText:SetTextColor(1, 0.3, 0.3)
    end)
    row.delete:SetScript("OnLeave", function()
        deleteText:SetTextColor(1, 1, 1)
    end)

    row:SetScript("OnEnter", function(self) self.background:Show() end)
    row:SetScript("OnLeave", function(self) self.background:Hide() end)

    return row
end

rowPool = Util.CreateRowPool(CreateRow)

local function Refresh()
    if not content then return end

    local db = EnsureDB()
    local width = (scroll and scroll:GetWidth()) or 0
    if width < 50 then width = 240 end
    content:SetWidth(math.max(100, width - 26))

    local y = 0
    for index, entry in ipairs(db.entries) do
        local row = rowPool:Get(index)

        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
        row:SetHeight(ROW_HEIGHT)

        row.entry = entry
        row.edit.entry = entry
        row.iconButton.entry = entry
        row.delete.entry = entry

        row.edit.updating = true
        row.edit:SetText(entry.name or "")
        row.edit.updating = false

        row.icon:SetTexture(entry.icon or DEFAULT_ICON)
        row.background:Hide()
        row:Show()
        y = y + ROW_HEIGHT
    end

    rowPool:Trim(#db.entries)

    content:SetHeight(math.max(y, 1))
    emptyLabel:SetShown(#db.entries == 0)

    if focusRow and rowPool.rows[focusRow] then
        rowPool.rows[focusRow].edit:SetFocus()
        focusRow = nil
    end
end

local function AddEntry()
    local db = EnsureDB()
    db.entries[#db.entries + 1] = { name = "", icon = DEFAULT_ICON }
    focusRow = #db.entries
    Refresh()
end

-- Icon picker ------------------------------------------------------------------

local function HideIconPicker()
    if iconPicker then iconPicker:Hide() end
    if iconOverlay then iconOverlay:Hide() end
    pickerEntry = nil
end

local function ChooseIcon(icon)
    if pickerEntry then
        pickerEntry.icon = icon
    end
    HideIconPicker()
    Refresh()
    RefreshPlates()
end

local function CreateIconPicker()
    if iconPicker then return iconPicker end

    iconOverlay = CreateFrame("Frame", nil, UIParent)
    iconOverlay:SetAllPoints(UIParent)
    iconOverlay:SetFrameStrata("DIALOG")
    iconOverlay:EnableMouse(true)
    iconOverlay:Hide()
    iconOverlay:SetScript("OnMouseDown", HideIconPicker)

    iconPicker = CreateFrame("Frame", "KwaUnitLabelerIconPicker", UIParent, "BackdropTemplate")
    iconPicker:SetFrameStrata("TOOLTIP")
    iconPicker:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    iconPicker:SetBackdropColor(0.055, 0.055, 0.07, 0.98)
    iconPicker:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)
    iconPicker:SetClampedToScreen(true)
    iconPicker:EnableMouse(true)
    iconPicker:Hide()
    iconPicker:SetScript("OnHide", function()
        if iconOverlay then iconOverlay:Hide() end
    end)

    local title = iconPicker:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", iconPicker, "TOPLEFT", 8, -6)
    title:SetText("Choose icon")

    local columns = 8
    local cell = 24
    local padding = 6
    local titleHeight = 24

    iconButtons = {}
    for index, icon in ipairs(ICONS) do
        local button = CreateFrame("Button", nil, iconPicker)
        local column = (index - 1) % columns
        local row = math.floor((index - 1) / columns)
        button:SetSize(22, 22)
        button:SetPoint("TOPLEFT", iconPicker, "TOPLEFT",
            padding + column * cell, -(titleHeight + row * cell))

        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetAllPoints()
        button.icon:SetTexture(icon)
        button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
        button.highlight:SetAllPoints()
        button.highlight:SetColorTexture(1, 1, 1, 0.18)

        button:SetScript("OnClick", function(self) ChooseIcon(self.iconPath) end)
        button.iconPath = icon
        iconButtons[#iconButtons + 1] = button
    end

    local totalRows = math.ceil(#ICONS / columns)
    iconPicker:SetSize(padding * 2 + columns * cell, titleHeight + totalRows * cell + padding)
    return iconPicker
end

ShowIconPicker = function(button)
    local picker = CreateIconPicker()
    pickerEntry = button.entry
    picker:ClearAllPoints()
    picker:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, -2)
    iconOverlay:Show()
    picker:Show()
end

-- Settings ---------------------------------------------------------------------

local function HideAnchorMenu()
    if anchorMenu then anchorMenu:Hide() end
    if anchorOverlay then anchorOverlay:Hide() end
end

local function SetAnchor(id)
    if id ~= "left" and id ~= "right" then id = "top" end
    EnsureDB().anchor = id
    if anchorDropdownLabel then
        anchorDropdownLabel:SetText(AnchorLabel(id))
    end
    RefreshPlates()
end

local function CreateAnchorMenu()
    if anchorMenu then return anchorMenu end

    anchorOverlay = CreateFrame("Frame", nil, UIParent)
    anchorOverlay:SetAllPoints(UIParent)
    anchorOverlay:SetFrameStrata("DIALOG")
    anchorOverlay:EnableMouse(true)
    anchorOverlay:Hide()
    anchorOverlay:SetScript("OnMouseDown", HideAnchorMenu)

    anchorMenu = CreateFrame("Frame", "KwaUnitLabelerAnchorMenu", UIParent, "BackdropTemplate")
    anchorMenu:SetFrameStrata("TOOLTIP")
    anchorMenu:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    anchorMenu:SetBackdropColor(0.055, 0.055, 0.07, 0.98)
    anchorMenu:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)
    anchorMenu:EnableMouse(true)
    anchorMenu:Hide()
    anchorMenu:SetScript("OnHide", function()
        if anchorOverlay then anchorOverlay:Hide() end
    end)

    anchorMenu.buttons = {}
    for index, option in ipairs(ANCHORS) do
        local button = CreateFrame("Button", nil, anchorMenu)
        button:SetHeight(20)
        button:SetPoint("TOPLEFT", anchorMenu, "TOPLEFT", 1, -((index - 1) * 20 + 4))
        button:SetPoint("TOPRIGHT", anchorMenu, "TOPRIGHT", -1, -((index - 1) * 20 + 4))

        local background = button:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints()
        background:SetColorTexture(1, 1, 1, 0.08)
        background:Hide()
        button.background = background

        local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("LEFT", button, "LEFT", 8, 0)
        text:SetJustifyH("LEFT")
        text:SetText(option.label)
        button.text = text
        button.optionID = option.id

        button:SetScript("OnEnter", function(self) self.background:Show() end)
        button:SetScript("OnLeave", function(self) self.background:Hide() end)
        button:SetScript("OnClick", function(self)
            SetAnchor(self.optionID)
            HideAnchorMenu()
        end)

        anchorMenu.buttons[index] = button
    end

    anchorMenu:SetWidth(150)
    anchorMenu:SetHeight(8 + (#ANCHORS * 20))
    return anchorMenu
end

local function ShowAnchorMenu()
    local menu = CreateAnchorMenu()
    local current = EnsureDB().anchor
    for _, button in ipairs(menu.buttons) do
        local selected = button.optionID == current
        button.text:SetTextColor(selected and 1 or 0.7, selected and 0.82 or 0.7, selected and 0 or 0.7)
        button.background:Hide()
    end

    local x, y = anchorDropdown:GetLeft(), anchorDropdown:GetBottom()
    if not x or not y then return end
    menu:ClearAllPoints()
    menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y - 2)
    anchorOverlay:Show()
    menu:Show()
end

local function CreateSettings(parent)
    if settingsPanel then return settingsPanel end

    settingsPanel = CreateFrame("Frame", nil, parent)

    local heading = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heading:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 0, 0)
    heading:SetText("|cffffd100Nameplate icons|r")

    local description = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    description:SetPoint("TOPLEFT", heading, "BOTTOMLEFT", 0, -6)
    description:SetPoint("TOPRIGHT", settingsPanel, "TOPRIGHT", -8, -22)
    description:SetJustifyH("LEFT")
    description:SetWordWrap(true)
    description:SetText("Where to place the icon relative to the nameplate, and how large it is. Icons appear on friendly and enemy nameplates that match an entry.")

    local label = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 0, -74)
    label:SetText("Anchor:")

    anchorDropdown = CreateFrame("Button", nil, settingsPanel, "BackdropTemplate")
    anchorDropdown:SetSize(150, 20)
    anchorDropdown:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -6)
    anchorDropdown:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    anchorDropdown:SetBackdropColor(0.08, 0.08, 0.1, 1)
    anchorDropdown:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)

    anchorDropdownLabel = anchorDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    anchorDropdownLabel:SetPoint("LEFT", anchorDropdown, "LEFT", 8, 0)
    anchorDropdownLabel:SetPoint("RIGHT", anchorDropdown, "RIGHT", -20, 0)
    anchorDropdownLabel:SetJustifyH("LEFT")
    anchorDropdownLabel:SetText(AnchorLabel(EnsureDB().anchor))

    local arrow = anchorDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    arrow:SetPoint("RIGHT", anchorDropdown, "RIGHT", -8, 0)
    arrow:SetText("v")

    anchorDropdown:SetScript("OnClick", function()
        if anchorMenu and anchorMenu:IsShown() then
            HideAnchorMenu()
        else
            ShowAnchorMenu()
        end
    end)
    anchorDropdown:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.5, 0.5, 0.58, 1)
    end)
    anchorDropdown:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)
    end)

    iconSizeSlider = CreateFrame("Slider", nil, settingsPanel, "OptionsSliderTemplate")
    iconSizeSlider:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 0, -146)
    iconSizeSlider:SetWidth(150)
    iconSizeSlider:SetMinMaxValues(ICON_SIZE_MIN, ICON_SIZE_MAX)
    iconSizeSlider:SetValueStep(1)
    iconSizeSlider:SetObeyStepOnDrag(true)
    iconSizeSlider:SetValue(EnsureDB().iconSize)

    if iconSizeSlider.Text then
        iconSizeSlider.Text:SetText("Icon size")
        iconSizeSlider.Text:SetFontObject("GameFontNormalSmall")
    end
    if iconSizeSlider.Low then
        iconSizeSlider.Low:SetText(tostring(ICON_SIZE_MIN))
        iconSizeSlider.Low:SetFontObject("GameFontDisableTiny")
    end
    if iconSizeSlider.High then
        iconSizeSlider.High:SetText(tostring(ICON_SIZE_MAX))
        iconSizeSlider.High:SetFontObject("GameFontDisableTiny")
    end

    iconSizeValue = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    iconSizeValue:SetPoint("LEFT", iconSizeSlider, "RIGHT", 12, 0)
    iconSizeValue:SetText(tostring(EnsureDB().iconSize))

    iconSizeSlider:SetScript("OnValueChanged", function(self, value)
        local size = math.floor((tonumber(value) or DEFAULT_ICON_SIZE) + 0.5)
        size = math.max(ICON_SIZE_MIN, math.min(ICON_SIZE_MAX, size))
        local db = EnsureDB()
        if iconSizeValue then iconSizeValue:SetText(tostring(size)) end
        if db.iconSize ~= size then
            db.iconSize = size
            RefreshPlates()
        end
    end)

    settingsPanel:SetScript("OnShow", function()
        anchorDropdownLabel:SetText(AnchorLabel(EnsureDB().anchor))
        iconSizeSlider:SetValue(EnsureDB().iconSize)
    end)
    settingsPanel:SetScript("OnHide", HideAnchorMenu)

    return settingsPanel
end

-- Panel ------------------------------------------------------------------------

local function CreatePanel(parent)
    if panel then return panel end

    EnsureDB()
    panel = CreateFrame("Frame", nil, parent)

    addButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    addButton:SetSize(34, 20)
    addButton:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    addButton:SetText("+")
    addButton:SetScript("OnClick", AddEntry)

    local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("LEFT", addButton, "RIGHT", 6, 0)
    hint:SetText("Type a first or full name, then pick an icon")

    scroll, content = Util.CreateScrollPanel(panel, { top = 26 })

    emptyLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    emptyLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 2, -34)
    emptyLabel:SetWidth(240)
    emptyLabel:SetJustifyH("LEFT")
    emptyLabel:SetText("No entries yet. Click + to label a player or mob nameplate.")
    emptyLabel:Hide()

    panel:SetScript("OnShow", function()
        Refresh()
        RefreshPlates()
    end)

    panel:SetScript("OnHide", HideIconPicker)

    Refresh()
    return panel
end

-- Events -----------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
for _, event in ipairs({ "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "PLAYER_ENTERING_WORLD" }) do
    pcall(eventFrame.RegisterEvent, eventFrame, event)
end

eventFrame:SetScript("OnEvent", function(_, event, unit)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local frame = GetPlateFrame(unit)
        if frame then ApplyPlate(unit, frame) end
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local display = activeIcons[unit]
        if display then
            if display.unit == unit then display:Hide() end
            activeIcons[unit] = nil
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        EnsureDB()
        RefreshPlates()
    end
end)

if KwaLite and KwaLite.RegisterAddon then
    KwaLite:RegisterAddon({
        id = "KwaUnitLabeler",
        name = "Unit Labeler",
        icon = "Interface\\Icons\\INV_Misc_Head_Human_01",
        priority = 6,
        createPanel = CreatePanel,
        createSettings = CreateSettings,
        refresh = function()
            Refresh()
            RefreshPlates()
        end,
        showMinimizedByDefault = false,
    })
end
