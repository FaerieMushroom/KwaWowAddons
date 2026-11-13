local addonName, KwaLite = ...

_G.KwaLite = KwaLite

local FRAME_WIDTH = 292
local FRAME_HEIGHT = 458
local TITLE_HEIGHT = 24
local OPTION_HEIGHT = 20
local PLUGIN_BUTTON_SIZE = 20
local PLUGIN_ICON_SIZE = 16
local PLUGIN_BUTTON_GAP = 2
local CONTENT_LEFT = 18
local CONTENT_RIGHT = 28
local MINIMIZED_HEIGHT = 24
local MINIMIZED_ICON_SIZE = 16
local MINIMIZED_ICON_GAP = 3
local MINIMIZED_WIDGET_GAP = 6
local MINIMIZED_LEFT_PADDING = 4
local MINIMIZED_RIGHT_PADDING = 6
local MINIMIZED_MIN_WIDTH = 30

local frame
local titleBar
local titleText
local minimizeButton
local expandButton
local pluginBar
local optionRow
local minimizeCheckbox
local minimizeCheckLabel
local pageHost
local contextMenu
local contextOverlay

local addons = {}
local addonsByID = {}
local pluginButtons = {}
local activeID
local minimized = false
local initialized = false

local function EnsureDB()
    if type(KwaLiteDB) ~= "table" then
        KwaLiteDB = {}
    end
    if type(KwaLiteDB.addons) ~= "table" then
        KwaLiteDB.addons = {}
    end
    return KwaLiteDB
end

local function GetAddonDB(id)
    local db = EnsureDB()
    local entry = db.addons[id]
    if type(entry) ~= "table" then
        entry = {}
        db.addons[id] = entry
    end
    return entry
end

local function IsAddonChecked(addon)
    return GetAddonDB(addon.id).showMinimized and true or false
end

local function HideContextMenu()
    if contextMenu then contextMenu:Hide() end
    if contextOverlay then contextOverlay:Hide() end
end

local function CloseWindow()
    KwaLite:Hide()
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

    contextMenu = CreateFrame("Frame", "KwaLiteContextMenu", UIParent, "BackdropTemplate")
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
    contextMenu:SetSize(140, 28)
    contextMenu:EnableMouse(true)
    contextMenu:SetScript("OnHide", function()
        if contextOverlay then contextOverlay:Hide() end
    end)
    contextMenu:Hide()

    local button = CreateFrame("Button", nil, contextMenu)
    button:SetPoint("TOPLEFT", contextMenu, "TOPLEFT", 1, -4)
    button:SetPoint("TOPRIGHT", contextMenu, "TOPRIGHT", -1, -4)
    button:SetHeight(20)

    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(1, 1, 1, 0.08)
    background:Hide()
    button.background = background

    local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("LEFT", button, "LEFT", 8, 0)
    text:SetJustifyH("LEFT")
    text:SetText("Close Kwa")

    button:SetScript("OnEnter", function(self)
        self.background:Show()
    end)
    button:SetScript("OnLeave", function(self)
        self.background:Hide()
    end)
    button:SetScript("OnClick", function()
        HideContextMenu()
        CloseWindow()
    end)

    return contextMenu
end

local function ShowContextMenu()
    local menu = CreateContextMenu()

    local scale = UIParent:GetEffectiveScale() or 1
    local x, y = GetCursorPosition()
    x = (x or 0) / scale
    y = (y or 0) / scale

    local uiWidth = UIParent:GetWidth() or 1920
    if x + 145 > uiWidth then x = uiWidth - 145 end
    if x < 0 then x = 0 end
    if y < menu:GetHeight() + 4 then y = menu:GetHeight() + 4 end

    menu:ClearAllPoints()
    menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
    contextOverlay:Show()
    menu:Show()
end

local function RefreshMinimizedWidgets()
    for _, addon in ipairs(addons) do
        local widget = addon.minimizedWidget
        if widget and IsAddonChecked(addon) and addon.refreshMinimized then
            pcall(addon.refreshMinimized, widget, addon)
        end
    end
end

local function GetMinimizedIcon(addon)
    local icon = addon.minimizedIcon
    if not icon and titleBar then
        icon = titleBar:CreateTexture(nil, "ARTWORK")
        icon:SetSize(MINIMIZED_ICON_SIZE, MINIMIZED_ICON_SIZE)
        addon.minimizedIcon = icon
    end
    if icon then
        icon:SetTexture(addon.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
    end
    return icon
end

local function LayoutMinimized()
    if not frame then return end

    local x = MINIMIZED_LEFT_PADDING
    for _, addon in ipairs(addons) do
        local widget = addon.minimizedWidget
        local icon = addon.minimizedIcon
        if widget then
            if IsAddonChecked(addon) then
                icon = GetMinimizedIcon(addon)
                icon:ClearAllPoints()
                icon:SetPoint("LEFT", titleBar, "LEFT", x, 0)
                icon:Show()
                x = x + MINIMIZED_ICON_SIZE + MINIMIZED_ICON_GAP

                widget:ClearAllPoints()
                widget:SetPoint("LEFT", titleBar, "LEFT", x, 0)
                widget:SetHeight(MINIMIZED_HEIGHT - 4)
                widget:Show()
                local width = widget:GetWidth() or 0
                if width <= 0 then width = 72 end
                x = x + width + MINIMIZED_WIDGET_GAP
            else
                widget:Hide()
                if icon then icon:Hide() end
            end
        end
    end

    local width = math.ceil(x + 20 + MINIMIZED_RIGHT_PADDING)
    if width < MINIMIZED_MIN_WIDTH then width = MINIMIZED_MIN_WIDTH end
    local maxWidth = (UIParent and UIParent:GetWidth() or 1920) - 20
    if width > maxWidth then width = maxWidth end
    frame:SetSize(width, MINIMIZED_HEIGHT)
end

local function UpdateOptionRow()
    if not optionRow then return end

    local addon = addonsByID[activeID]
    if not addon then
        optionRow:Hide()
        if titleText then titleText:SetText("|cffffd100Kwa Lite|r") end
        return
    end

    if titleText then
        titleText:SetText("|cffffd100" .. addon.name .. "|r")
    end
    optionRow:Show()
    minimizeCheckbox:SetChecked(IsAddonChecked(addon))
    minimizeCheckLabel:SetText("Show " .. addon.name .. " when minimized")
end

local function UpdatePluginButtons()
    for index, addon in ipairs(addons) do
        local button = pluginButtons[index]
        if not button then
            button = CreateFrame("Button", nil, pluginBar)
            button:SetSize(PLUGIN_BUTTON_SIZE, PLUGIN_BUTTON_SIZE)

            local background = button:CreateTexture(nil, "BACKGROUND")
            background:SetAllPoints()
            background:SetColorTexture(1, 1, 1, 0.14)
            button.background = background

            local icon = button:CreateTexture(nil, "ARTWORK")
            icon:SetSize(PLUGIN_ICON_SIZE, PLUGIN_ICON_SIZE)
            icon:SetPoint("CENTER", button, "CENTER", 0, 0)
            button.icon = icon

            button:SetScript("OnClick", function(self)
                if self.addonID then
                    KwaLite:SelectAddon(self.addonID)
                end
            end)
            button:SetScript("OnEnter", function(self)
                self.background:Show()
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:AddLine(self.addonName or "Addon", 1, 0.82, 0)
                GameTooltip:Show()
            end)
            button:SetScript("OnLeave", function(self)
                if self.addonID == activeID then
                    self.background:Show()
                else
                    self.background:Hide()
                end
                GameTooltip:Hide()
            end)

            pluginButtons[index] = button
        end

        button.addonID = addon.id
        button.addonName = addon.name
        button.icon:SetTexture(addon.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        button:Show()
        button.background:SetShown(addon.id == activeID)
    end

    for index = #addons + 1, #pluginButtons do
        pluginButtons[index]:Hide()
    end

    for index = 1, #addons do
        local button = pluginButtons[index]
        button:ClearAllPoints()
        button:SetPoint("TOP", pluginBar, "TOP", 0, -((index - 1) * (PLUGIN_BUTTON_SIZE + PLUGIN_BUTTON_GAP)))
    end
end

local function LayoutExpanded()
    if not frame then return end

    local y = TITLE_HEIGHT
    if #addons > 0 then
        pluginBar:ClearAllPoints()
        pluginBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -(TITLE_HEIGHT + 4))
        pluginBar:SetWidth(PLUGIN_BUTTON_SIZE)
        pluginBar:SetHeight((#addons * (PLUGIN_BUTTON_SIZE + PLUGIN_BUTTON_GAP)) - PLUGIN_BUTTON_GAP)
        pluginBar:Show()
    else
        pluginBar:Hide()
    end

    optionRow:ClearAllPoints()
    optionRow:SetPoint("TOPLEFT", frame, "TOPLEFT", CONTENT_LEFT, -y)
    optionRow:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -CONTENT_RIGHT, -y)
    optionRow:SetHeight(OPTION_HEIGHT)
    optionRow:Show()
    y = y + OPTION_HEIGHT

    pageHost:ClearAllPoints()
    pageHost:SetPoint("TOPLEFT", frame, "TOPLEFT", CONTENT_LEFT, -y)
    pageHost:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -CONTENT_RIGHT, 4)
    pageHost:Show()
end

local function ApplyMinimizedState()
    if not frame then return end

    if minimized then
        frame:SetHeight(MINIMIZED_HEIGHT)
        if titleBar then titleBar:SetHeight(MINIMIZED_HEIGHT - 2) end
        if titleText then titleText:Hide() end
        if minimizeButton then minimizeButton:Hide() end
        if expandButton then expandButton:Show() end
        if pluginBar then pluginBar:Hide() end
        if optionRow then optionRow:Hide() end
        if pageHost then pageHost:Hide() end

        RefreshMinimizedWidgets()
        LayoutMinimized()
    else
        frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
        if titleBar then titleBar:SetHeight(TITLE_HEIGHT) end
        if titleText then titleText:Show() end
        if minimizeButton then minimizeButton:Show() end
        if expandButton then expandButton:Hide() end
        for _, addon in ipairs(addons) do
            if addon.minimizedWidget then
                addon.minimizedWidget:Hide()
            end
            if addon.minimizedIcon then
                addon.minimizedIcon:Hide()
            end
        end
        LayoutExpanded()
        UpdateOptionRow()
        UpdatePluginButtons()
        KwaLite:RefreshCurrent()
    end
end

local function SavePosition()
    if not frame then return end
    local point, _, relativePoint, x, y = frame:GetPoint(1)
    if point then
        local db = EnsureDB()
        db.position = {
            point = point,
            relativePoint = relativePoint,
            x = x,
            y = y,
        }
    end
end

local function CreateUI()
    if initialized and frame then return frame end
    initialized = true

    frame = CreateFrame("Frame", "KwaLiteFrame", UIParent, "BackdropTemplate")
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
    if (not position or not position.point) and type(KwaTrackerDB) == "table" then
        position = KwaTrackerDB.position
    end
    if position and position.point then
        frame:SetPoint(position.point, UIParent, position.relativePoint or position.point, position.x or 0, position.y or 0)
    else
        frame:SetPoint("RIGHT", UIParent, "RIGHT", -80, 40)
    end

    titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    titleBar:SetHeight(TITLE_HEIGHT)
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
    titleBar:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
        SavePosition()
    end)
    titleBar:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            ShowContextMenu()
        end
    end)

    local titleBackground = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBackground:SetAllPoints()
    titleBackground:SetColorTexture(0.10, 0.10, 0.13, 0.95)

    titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("LEFT", titleBar, "LEFT", CONTENT_LEFT, 0)
    titleText:SetText("|cffffd100Kwa Lite|r")

    minimizeButton = CreateFrame("Button", nil, titleBar, "UIPanelButtonTemplate")
    minimizeButton:SetSize(20, 20)
    minimizeButton:SetPoint("TOPRIGHT", titleBar, "TOPRIGHT", -4, -2)
    minimizeButton:SetFrameLevel(titleBar:GetFrameLevel() + 5)
    minimizeButton:SetText("-")
    minimizeButton:SetScript("OnClick", function()
        KwaLite:SetMinimized(true)
    end)

    expandButton = CreateFrame("Button", nil, titleBar, "UIPanelButtonTemplate")
    expandButton:SetSize(20, 20)
    expandButton:SetPoint("RIGHT", titleBar, "RIGHT", -4, 0)
    expandButton:SetFrameLevel(titleBar:GetFrameLevel() + 5)
    expandButton:SetText("+")
    expandButton:Hide()
    expandButton:SetScript("OnClick", function()
        KwaLite:SetMinimized(false)
    end)

    pluginBar = CreateFrame("Frame", nil, frame)
    pluginBar:Hide()

    optionRow = CreateFrame("Frame", nil, frame)
    optionRow:SetHeight(OPTION_HEIGHT)

    minimizeCheckbox = CreateFrame("CheckButton", nil, optionRow, "UICheckButtonTemplate")
    minimizeCheckbox:SetPoint("TOPLEFT", optionRow, "TOPLEFT", 0, 0)
    minimizeCheckbox:SetSize(20, 20)
    minimizeCheckbox:SetScript("OnClick", function(self)
        local addon = addonsByID[activeID]
        if not addon then return end
        GetAddonDB(addon.id).showMinimized = self:GetChecked() and true or false
        RefreshMinimizedWidgets()
        if minimized then LayoutMinimized() end
    end)
    minimizeCheckbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Minimized bar", 1, 0.82, 0)
        GameTooltip:AddLine("Checked: show this addon's compact info while Kwa Lite is minimized.", 1, 1, 1, true)
        GameTooltip:AddLine("Unchecked: hide it from the minimized bar.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    minimizeCheckbox:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    minimizeCheckLabel = optionRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    minimizeCheckLabel:SetPoint("LEFT", minimizeCheckbox, "RIGHT", 1, 0)
    minimizeCheckLabel:SetJustifyH("LEFT")

    pageHost = CreateFrame("Frame", nil, frame)
    pageHost:Hide()

    frame:SetScript("OnShow", function()
        if minimized then
            ApplyMinimizedState()
        else
            KwaLite:RefreshCurrent()
        end
    end)
    frame:SetScript("OnHide", function()
        HideContextMenu()
    end)
    frame:Hide()

    LayoutExpanded()
    return frame
end

local function CreateAddonWidgets(addon)
    if addon.page then return end

    local page = addon.createPanel(pageHost, addon)
    if page and page.SetAllPoints then
        page:SetAllPoints(pageHost)
    end
    addon.page = page

    local widget = addon.createMinimized(titleBar, addon)
    if widget then
        if widget.SetHeight then widget:SetHeight(MINIMIZED_HEIGHT - 8) end
        if widget.SetFrameLevel and titleBar then
            widget:SetFrameLevel(titleBar:GetFrameLevel() + 1)
        end
        widget:Hide()
    end
    addon.minimizedWidget = widget

    if page then
        page:SetShown(addon.id == activeID)
    end
end

function KwaLite:RegisterAddon(config)
    if type(config) ~= "table" then
        error("KwaLite:RegisterAddon expects a table")
    end
    if not config.id or config.id == "" then
        error("KwaLite:RegisterAddon requires an id")
    end
    if type(config.createPanel) ~= "function" then
        error("KwaLite:RegisterAddon requires createPanel(parent)")
    end
    if type(config.createMinimized) ~= "function" then
        error("KwaLite:RegisterAddon requires createMinimized(parent)")
    end
    if addonsByID[config.id] then
        return addonsByID[config.id]
    end

    local addon = {
        id = config.id,
        name = config.name or config.id,
        icon = config.icon,
        createPanel = config.createPanel,
        createMinimized = config.createMinimized,
        refresh = config.refresh,
        refreshMinimized = config.refreshMinimized,
    }
    addons[#addons + 1] = addon
    addonsByID[addon.id] = addon

    local db = GetAddonDB(addon.id)
    if type(db.showMinimized) ~= "boolean" then
        db.showMinimized = config.showMinimizedByDefault ~= false
    end

    if not activeID then activeID = addon.id end

    CreateUI()
    CreateAddonWidgets(addon)
    if not minimized then
        LayoutExpanded()
    end
    UpdatePluginButtons()
    UpdateOptionRow()

    if addon.id == activeID then
        if addon.page then addon.page:Show() end
        self:RefreshCurrent()
    end

    return addon
end

function KwaLite:SelectAddon(id)
    local addon = addonsByID[id]
    if not addon then return end

    activeID = id
    for _, entry in ipairs(addons) do
        if entry.page then
            entry.page:SetShown(entry.id == id)
        end
    end

    UpdatePluginButtons()
    UpdateOptionRow()
    self:RefreshCurrent()
end

function KwaLite:RefreshCurrent()
    local addon = addonsByID[activeID]
    if addon and addon.page and addon.page:IsShown() and addon.refresh then
        pcall(addon.refresh, addon.page, addon)
    end
end

function KwaLite:RefreshMinimized()
    RefreshMinimizedWidgets()
    if minimized then
        LayoutMinimized()
    end
end

function KwaLite:IsMinimized()
    return minimized
end

function KwaLite:SetMinimized(state)
    minimized = state and true or false
    ApplyMinimizedState()
end

function KwaLite:Show()
    local f = CreateUI()
    f:Show()
end

function KwaLite:Hide()
    if frame then frame:Hide() end
end

function KwaLite:Toggle()
    local f = CreateUI()
    if f:IsShown() then
        f:Hide()
    else
        f:Show()
    end
end

SLASH_KWA1 = "/kwa"
SLASH_KWA2 = "/kwalite"
SlashCmdList["KWA"] = function()
    KwaLite:Toggle()
end

-- Open the window automatically once per login/reload. PLAYER_ENTERING_WORLD
-- also fires when zoning, so guard it to avoid reopening a closed window.
local startupShown = false
local startupFrame = CreateFrame("Frame")
startupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
startupFrame:SetScript("OnEvent", function()
    if startupShown then return end
    startupShown = true
    KwaLite:Show()
    KwaLite:SetMinimized(true)
end)
