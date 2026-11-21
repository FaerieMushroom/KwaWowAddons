local addonName, KKK = ...

-- Settings plugin for the Kwa Lite plugin bar. Lists every registered plugin
-- so it can be enabled/disabled and, when a plugin provides one, opens that
-- plugin's settings panel.

if not (KwaLite and KwaLite.RegisterAddon and KwaLite.GetAddons and KwaLite.Util) then
    return
end

local Util = KwaLite.Util

local ADDON_ID = "KwaSettings"
local ROW_HEIGHT = 24
local ICON_SIZE = 16

local panel
local searchBox
local searchPlaceholder
local clearButton
local countLabel
local scroll
local content
local emptyLabel
local settingsHeader
local settingsTitle
local settingsBack
local settingsHost

local rows = {}
local rowCount = 0
local searchText = ""
local mode = "list"
local settingsAddonID

local Refresh

local function UpdateMode()
    local listMode = mode == "list"
    searchBox:SetShown(listMode)
    searchPlaceholder:SetShown(listMode and searchText == "")
    clearButton:SetShown(listMode and searchText ~= "")
    countLabel:SetShown(listMode)
    scroll:SetShown(listMode)
    if not listMode then
        emptyLabel:Hide()
    end
    settingsHeader:SetShown(not listMode)
    settingsHost:SetShown(not listMode)
end

local function CloseSettings()
    mode = "list"
    settingsAddonID = nil
    settingsHost:Hide()
    UpdateMode()
    Refresh()
end

local function OpenSettings(id)
    local addon = KwaLite:GetAddon(id)
    if not addon or not KwaLite:HasAddonSettings(id) then return end

    local page = KwaLite:CreateAddonSettings(id, settingsHost)
    if not page then return end

    for _, entry in ipairs(KwaLite:GetAddons()) do
        if entry.id ~= id and entry.settingsPage then
            entry.settingsPage:Hide()
        end
    end

    settingsAddonID = id
    settingsTitle:SetText(addon.name or addon.id)
    if page.SetAllPoints then page:SetAllPoints(settingsHost) end
    page:Show()

    mode = "settings"
    UpdateMode()
end

local function AcquireRow(index)
    local row = rows[index]
    if row then return row end

    row = CreateFrame("Button", nil, content)
    row:SetHeight(ROW_HEIGHT)

    Util.AddRowHoverBackground(row, 0.04)
    Util.SetHoverScripts(row)

    row.check = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
    row.check:SetSize(20, 20)
    row.check:SetPoint("LEFT", row, "LEFT", 0, 0)

    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(ICON_SIZE, ICON_SIZE)
    row.icon:SetPoint("LEFT", row.check, "RIGHT", 2, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("LEFT", row.icon, "RIGHT", 5, 0)
    row.text:SetPoint("RIGHT", row, "RIGHT", -70, 0)
    row.text:SetJustifyH("LEFT")
    row.text:SetWordWrap(false)

    row.settings = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    row.settings:SetSize(62, 18)
    row.settings:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.settings:SetText("Settings")
    row.settings:Hide()

    row.check:SetScript("OnClick", function(self)
        local id = self.pluginID
        if not id then return end
        KwaLite:SetAddonEnabled(id, self:GetChecked())
        Refresh()
    end)

    row.settings:SetScript("OnClick", function(self)
        if self.pluginID then
            OpenSettings(self.pluginID)
        end
    end)

    row:SetScript("OnEnter", function(self) self.background:Show() end)
    row:SetScript("OnLeave", function(self) self.background:Hide() end)

    rows[index] = row
    return row
end

Refresh = function()
    if not content or mode ~= "list" then return end

    local width = (scroll and scroll:GetWidth()) or 0
    if width < 50 then width = 260 end
    content:SetWidth(math.max(100, width - 26))

    local query = (searchText or ""):lower()
    local list = {}

    for _, addon in ipairs(KwaLite:GetAddons()) do
        if addon.id ~= ADDON_ID then
            local name = addon.name or addon.id
            if query == ""
                or name:lower():find(query, 1, true)
                or addon.id:lower():find(query, 1, true) then
                list[#list + 1] = addon
            end
        end
    end

    local total = #list
    local y = 0
    for index = 1, total do
        local addon = list[index]
        local row = AcquireRow(index)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
        row:SetHeight(ROW_HEIGHT)

        local enabled = KwaLite:IsAddonEnabled(addon.id)
        row.check.pluginID = addon.id
        row.check:SetChecked(enabled)

        row.icon:SetTexture(addon.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        row.text:SetText(addon.name or addon.id)
        if enabled then
            row.text:SetTextColor(1, 1, 1)
        else
            row.text:SetTextColor(0.5, 0.5, 0.5)
        end

        row.settings.pluginID = addon.id
        row.settings:SetShown(KwaLite:HasAddonSettings(addon.id))

        row.background:Hide()
        row:Show()
        y = y + ROW_HEIGHT
    end

    for index = total + 1, rowCount do
        rows[index]:Hide()
    end
    rowCount = total

    content:SetHeight(math.max(y, 1))
    countLabel:SetText("|cff9d9d9d" .. total .. " plugin" .. (total == 1 and "" or "s") .. "|r")

    if total == 0 then
        emptyLabel:SetText(query ~= "" and "No plugins match your search."
            or "No plugins available.")
        emptyLabel:Show()
    else
        emptyLabel:Hide()
    end
end

local function CreatePanel(parent)
    if panel then return panel end
    panel = CreateFrame("Frame", nil, parent)

    searchBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    searchBox:SetSize(206, 20)
    searchBox:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -2)
    searchBox:SetAutoFocus(false)
    searchBox:SetMaxLetters(60)
    searchBox:SetFontObject("GameFontHighlightSmall")

    searchPlaceholder = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    searchPlaceholder:SetPoint("LEFT", searchBox, "LEFT", 6, 0)
    searchPlaceholder:SetText("Search plugins...")

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

    countLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    countLabel:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, -5)
    countLabel:SetJustifyH("RIGHT")

    searchBox:SetScript("OnTextChanged", function(self)
        searchText = self:GetText() or ""
        searchPlaceholder:SetShown(searchText == "")
        clearButton:SetShown(searchText ~= "")
        Refresh()
        if scroll then scroll:SetVerticalScroll(0) end
    end)
    searchBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)

    scroll, content = Util.CreateScrollPanel(panel, { top = 26 })

    emptyLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    emptyLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 2, -30)
    emptyLabel:SetWidth(230)
    emptyLabel:SetJustifyH("LEFT")
    emptyLabel:Hide()

    settingsHeader = CreateFrame("Frame", nil, panel)
    settingsHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    settingsHeader:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    settingsHeader:SetHeight(22)
    settingsHeader:Hide()

    settingsBack = CreateFrame("Button", nil, settingsHeader, "UIPanelButtonTemplate")
    settingsBack:SetSize(22, 20)
    settingsBack:SetPoint("LEFT", settingsHeader, "LEFT", 0, 0)
    settingsBack:SetText("<")
    settingsBack:SetScript("OnClick", CloseSettings)

    settingsTitle = settingsHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    settingsTitle:SetPoint("LEFT", settingsBack, "RIGHT", 6, 0)
    settingsTitle:SetJustifyH("LEFT")

    settingsHost = CreateFrame("Frame", nil, panel)
    settingsHost:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -26)
    settingsHost:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -2, 0)
    settingsHost:Hide()

    panel:SetScript("OnShow", function()
        UpdateMode()
        Refresh()
    end)

    return panel
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function()
    if panel and panel:IsShown() then
        Refresh()
    end
end)

KwaLite:RegisterAddon({
    id = ADDON_ID,
    name = "Settings",
    icon = "Interface\\Icons\\INV_Misc_Gear_01",
    priority = 0,
    createPanel = CreatePanel,
    refresh = function()
        if mode == "settings" and settingsAddonID and KwaLite:HasAddonSettings(settingsAddonID) then
            return
        end
        UpdateMode()
        Refresh()
    end,
    showMinimizedByDefault = false,
})
