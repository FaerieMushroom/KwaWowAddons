local addonName, XPT = ...

local isSecret = function(v)
    return (issecretvalue and issecretvalue(v)) or false
end
local canAccess = function(v)
    return (canaccessvalue and canaccessvalue(v)) or true
end

local ROW_SPACING = 20
local BAR_HEIGHT = 24
local REFRESH_INTERVAL = 30

local panel
local miniFrame
local miniLabel
local bar
local barLevelLeft
local barPercent
local barLevelRight
local statGained
local statLeft
local statHour
local statTime
local statDrop
local statDrops
local statSession
local statLastGain
local statTotal
local statScope
local hintLabel
local contextMenu
local contextOverlay

local lastPlayerXP
local lastPlayerXPMax
local lastPlayerLevel
local sessionXp = 0
local gainCount = 0
local lastGain = 0
local sessionStart = GetTime()
local paused = false
local pausedAt = 0
local pausedTotal = 0

local RefreshPanel
local RefreshMinimized
local RefreshAll

local function SafeUnitXP()
    if not UnitXP then return nil end
    local ok, xp = pcall(UnitXP, "player")
    if not ok or isSecret(xp) or not canAccess(xp) or type(xp) ~= "number" then return nil end
    return xp
end

local function SafeUnitXPMax()
    if not UnitXPMax then return nil end
    local ok, xpMax = pcall(UnitXPMax, "player")
    if not ok or isSecret(xpMax) or not canAccess(xpMax) or type(xpMax) ~= "number" then return nil end
    return xpMax
end

local function SafeUnitLevel()
    if not UnitLevel then return nil end
    local ok, level = pcall(UnitLevel, "player")
    if not ok or isSecret(level) or not canAccess(level) or type(level) ~= "number" then return nil end
    return level
end

local function ReadPlayerXP()
    return SafeUnitXP(), SafeUnitXPMax(), SafeUnitLevel()
end

local function FormatNumber(value)
    local number = math.floor(tonumber(value) or 0)
    local text = tostring(number)
    local formatted
    repeat
        text, formatted = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
    until formatted == 0
    return text
end

local function FormatCompact(value)
    local number = tonumber(value) or 0
    if math.abs(number) >= 1000000 then
        return string.format("%.1fM", number / 1000000)
    end
    if math.abs(number) >= 10000 then
        return string.format("%.1fK", number / 1000)
    end
    return FormatNumber(number)
end

local function FormatDuration(seconds)
    seconds = tonumber(seconds)
    if not seconds or seconds <= 0 or seconds == math.huge then
        return "--"
    end
    seconds = math.floor(seconds + 0.5)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    if hours > 0 then
        return string.format("%dh %02dm", hours, minutes)
    end
    if minutes > 0 then
        return string.format("%dm %02ds", minutes, secs)
    end
    return string.format("%ds", secs)
end

local function HideContextMenu()
    if contextMenu then contextMenu:Hide() end
    if contextOverlay then contextOverlay:Hide() end
end

local function GetActiveElapsed(now)
    local elapsed = now - sessionStart - pausedTotal
    if paused then
        elapsed = elapsed - (now - pausedAt)
    end
    if elapsed < 1 then elapsed = 1 end
    return elapsed
end

local function ResetTotals()
    sessionXp = 0
    gainCount = 0
    lastGain = 0
    RefreshAll()
end

local function ResetTimer()
    sessionStart = GetTime()
    pausedTotal = 0
    if paused then
        pausedAt = sessionStart
    end
    RefreshAll()
end

local function ResetAll()
    ResetTotals()
    ResetTimer()
    lastPlayerXP, lastPlayerXPMax, lastPlayerLevel = ReadPlayerXP()
    RefreshAll()
end

local function TogglePause()
    local now = GetTime()
    if paused then
        paused = false
        pausedTotal = pausedTotal + (now - pausedAt)
        pausedAt = 0
        -- Ignore any XP gained while paused.
        lastPlayerXP, lastPlayerXPMax, lastPlayerLevel = ReadPlayerXP()
    else
        paused = true
        pausedAt = now
        lastPlayerXP, lastPlayerXPMax, lastPlayerLevel = ReadPlayerXP()
    end
    RefreshAll()
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

    contextMenu = CreateFrame("Frame", "KwaXpTrackerContextMenu", UIParent, "BackdropTemplate")
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
    for index = 1, 4 do
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

local function ShowResetMenu()
    local menu = CreateContextMenu()
    local options = {
        { label = paused and "Resume tracking" or "Pause tracking", action = TogglePause },
        { label = "Reset session XP", action = ResetTotals },
        { label = "Reset XP/hour timer", action = ResetTimer },
        { label = "Reset all", action = ResetAll },
    }

    for index, button in ipairs(menu.buttons) do
        local option = options[index]
        button.action = option and option.action or nil
        button.text:SetText(option and option.label or "")
        button.background:Hide()
        button:SetShown(option ~= nil)
    end

    menu:SetWidth(170)
    menu:SetHeight(8 + (#options * 20))
    menu:ClearAllPoints()

    local scale = UIParent:GetEffectiveScale() or 1
    local x, y = GetCursorPosition()
    x = (x or 0) / scale
    y = (y or 0) / scale

    local uiWidth = UIParent:GetWidth() or 1920
    if x + 175 > uiWidth then x = uiWidth - 175 end
    if x < 0 then x = 0 end
    if y < menu:GetHeight() + 4 then y = menu:GetHeight() + 4 end

    menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
    contextOverlay:Show()
    menu:Show()
end

local function CreateStatLine(parent, y, side)
    local value = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    if side == "RIGHT" then
        value:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -y)
        value:SetJustifyH("RIGHT")
    else
        value:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -y)
        value:SetJustifyH("LEFT")
    end
    return value
end

local function CreatePanel(parent)
    if panel then return panel end

    panel = CreateFrame("Frame", nil, parent)
    panel:EnableMouse(true)
    panel:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            ShowResetMenu()
        end
    end)

    local rowY = 2
    statGained = CreateStatLine(panel, rowY, "LEFT")
    statLeft = CreateStatLine(panel, rowY, "RIGHT")

    rowY = rowY + ROW_SPACING
    statHour = CreateStatLine(panel, rowY, "LEFT")
    statTime = CreateStatLine(panel, rowY, "RIGHT")

    rowY = rowY + ROW_SPACING
    statDrop = CreateStatLine(panel, rowY, "LEFT")
    statDrops = CreateStatLine(panel, rowY, "RIGHT")

    rowY = rowY + ROW_SPACING
    statSession = CreateStatLine(panel, rowY, "LEFT")
    statLastGain = CreateStatLine(panel, rowY, "RIGHT")

    rowY = rowY + ROW_SPACING + 6
    bar = CreateFrame("StatusBar", nil, panel)
    bar:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -rowY)
    bar:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -rowY)
    bar:SetHeight(BAR_HEIGHT)
    bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    bar:SetStatusBarColor(0.66, 0.26, 0.08, 1)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)

    local barBackground = bar:CreateTexture(nil, "BACKGROUND")
    barBackground:SetAllPoints()
    barBackground:SetColorTexture(0.08, 0.08, 0.08, 0.95)

    barLevelLeft = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    barLevelLeft:SetPoint("LEFT", bar, "LEFT", 6, 0)
    barLevelLeft:SetJustifyH("LEFT")

    barPercent = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    barPercent:SetPoint("CENTER", bar, "CENTER", 0, 0)
    barPercent:SetJustifyH("CENTER")

    barLevelRight = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    barLevelRight:SetPoint("RIGHT", bar, "RIGHT", -6, 0)
    barLevelRight:SetJustifyH("RIGHT")

    rowY = rowY + BAR_HEIGHT + 10
    statTotal = CreateStatLine(panel, rowY, "LEFT")
    statScope = CreateStatLine(panel, rowY, "RIGHT")

    rowY = rowY + ROW_SPACING + 4
    hintLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hintLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -rowY)
    hintLabel:SetText("Right-click for reset options")

    panel:SetScript("OnHide", function()
        HideContextMenu()
    end)

    return panel
end

local function CreateMinimized(parent)
    if miniFrame then return miniFrame end

    miniFrame = CreateFrame("Frame", nil, parent)
    miniFrame:SetHeight(20)
    miniFrame:SetWidth(80)
    miniFrame:EnableMouse(false)

    miniLabel = miniFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    miniLabel:SetPoint("LEFT", miniFrame, "LEFT", 0, 0)
    miniLabel:SetJustifyH("LEFT")
    miniLabel:SetJustifyV("MIDDLE")
    miniLabel:SetWordWrap(false)

    RefreshMinimized()
    return miniFrame
end

local function GetXpPerHour(now)
    if sessionXp <= 0 then return 0 end
    return sessionXp / GetActiveElapsed(now) * 3600
end

RefreshPanel = function()
    if not panel or not bar or not bar:IsShown() then return end

    local xp, xpMax, level = ReadPlayerXP()
    local remaining

    if xp and xpMax and xpMax > 0 then
        xpMax = math.floor(xpMax)
        xp = math.floor(xp)
        bar:SetMinMaxValues(0, xpMax)
        bar:SetValue(math.min(math.max(xp, 0), xpMax))
        remaining = math.max(0, xpMax - xp)
        local percent = (xp / xpMax) * 100
        barLevelLeft:SetText(level and ("Lvl. " .. tostring(level)) or "Lvl. --")
        barLevelRight:SetText(level and ("Lvl. " .. tostring(level + 1)) or "Lvl. --")
        barPercent:SetText(string.format("%.2f%%", percent))
    elseif xpMax and xpMax <= 0 then
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(1)
        remaining = 0
        barLevelLeft:SetText(level and ("Lvl. " .. tostring(level)) or "Lvl. --")
        barLevelRight:SetText("MAX")
        barPercent:SetText("100%")
    else
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(0)
        remaining = nil
        barLevelLeft:SetText(level and ("Lvl. " .. tostring(level)) or "Lvl. --")
        barLevelRight:SetText("Lvl. --")
        barPercent:SetText("XP unavailable")
    end

    local now = GetTime()
    local xpPerHour = GetXpPerHour(now)
    local timeToLevel = (remaining and xpPerHour > 0) and (remaining / (xpPerHour / 3600)) or nil
    local avgDrop = gainCount > 0 and (sessionXp / gainCount) or 0
    local dropsToLevel = (remaining and remaining > 0 and avgDrop > 0)
        and math.ceil(remaining / avgDrop) or nil
    local dropsText = (remaining == 0) and "MAX" or (dropsToLevel and tostring(dropsToLevel) or "--")

    statGained:SetText("|cff9d9d9dXP Gained:|r " .. FormatNumber(sessionXp))
    statLeft:SetText("|cff9d9d9dXP Left:|r " .. (remaining and FormatCompact(remaining) or "--"))
    statHour:SetText("|cff9d9d9dXP/Hour:|r " .. FormatNumber(xpPerHour))
    statTime:SetText("|cff9d9d9dTime to level:|r " .. FormatDuration(timeToLevel))
    statDrop:SetText("|cff9d9d9dXP/Drop:|r " .. FormatNumber(avgDrop))
    statDrops:SetText("|cff9d9d9dDrops to level:|r " .. dropsText)
    statSession:SetText("|cff9d9d9dSession time:|r " .. FormatDuration(GetActiveElapsed(now)))
    statLastGain:SetText("|cff9d9d9dLast gain:|r " .. (lastGain > 0 and FormatNumber(lastGain) or "--"))
    statTotal:SetText("|cff9d9d9dTotal XP Gained:|r " .. FormatNumber(sessionXp))
    statScope:SetText(paused and "|cff9d9d9dThis session (paused)|r" or "|cff9d9d9dThis session|r")
end

RefreshMinimized = function()
    if not miniFrame or not miniLabel then return end

    local xp, xpMax = ReadPlayerXP()
    local remaining
    if xp and xpMax and xpMax > 0 then
        remaining = math.max(0, xpMax - xp)
    elseif xpMax and xpMax <= 0 then
        remaining = 0
    end

    local xpPerHour = GetXpPerHour(GetTime())
    local timeToLevel = (remaining and remaining > 0 and xpPerHour > 0)
        and (remaining / (xpPerHour / 3600)) or nil
    local toLevelText = (remaining == 0) and "MAX" or FormatDuration(timeToLevel)

    local text = "|cff9d9d9dXP:|r " .. FormatNumber(sessionXp)
        .. "   |cff9d9d9dTo Level:|r " .. toLevelText
    miniLabel:SetText(text)

    local plain = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local textWidth = 0
    if miniLabel.GetStringWidth then
        -- Measure the plain text with plenty of room so the width is not
        -- clamped by a previous (possibly too small) label width.
        miniLabel:SetWidth(2000)
        miniLabel:SetText(plain)
        local ok, width = pcall(miniLabel.GetStringWidth, miniLabel)
        if ok and type(width) == "number" then
            textWidth = width
        end
        miniLabel:SetText(text)
    end
    if textWidth <= 0 then
        textWidth = #plain * 6
    end

    local width = math.ceil(math.max(textWidth + 12, 60))
    miniFrame:SetWidth(width)
    miniLabel:SetWidth(width - 2)
end

RefreshAll = function()
    RefreshPanel()
    if KwaLite and KwaLite.RefreshMinimized then
        KwaLite:RefreshMinimized()
    end
end

local function InitializePlayerXP()
    lastPlayerXP, lastPlayerXPMax, lastPlayerLevel = ReadPlayerXP()
end

InitializePlayerXP()

if KwaLite and KwaLite.RegisterAddon then
    KwaLite:RegisterAddon({
        id = "KwaXpTracker",
        name = "XP Tracker",
        icon = "Interface\\Icons\\misc_arrowlup",
        priority = 1,
        createPanel = CreatePanel,
        createMinimized = CreateMinimized,
        refresh = function() RefreshPanel() end,
        refreshMinimized = function() RefreshMinimized() end,
    })
else
    print("|cffff0000[KwaXpTracker] KwaLite is required. Install the KwaLite addon to use the XP tracker.|r")
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_XP_UPDATE")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        InitializePlayerXP()
        RefreshAll()
    elseif event == "PLAYER_LEVEL_UP" then
        RefreshAll()
    elseif event == "PLAYER_XP_UPDATE" then
        local xp, xpMax, level = ReadPlayerXP()
        if not xp or not xpMax then return end

        if paused then
            lastPlayerXP = xp
            lastPlayerXPMax = xpMax
            lastPlayerLevel = level
            RefreshAll()
            return
        end

        if lastPlayerXP == nil or lastPlayerLevel == nil then
            lastPlayerXP = xp
            lastPlayerXPMax = xpMax
            lastPlayerLevel = level
            RefreshAll()
            return
        end

        local delta
        if level and lastPlayerLevel and level > lastPlayerLevel then
            delta = math.max(0, (lastPlayerXPMax or xpMax) - lastPlayerXP) + xp
        else
            delta = xp - lastPlayerXP
        end

        lastPlayerXP = xp
        lastPlayerXPMax = xpMax
        lastPlayerLevel = level

        if delta > 0 then
            sessionXp = sessionXp + delta
            gainCount = gainCount + 1
            lastGain = delta
        end
        RefreshAll()
    end
end)

-- Keep XP/hour, session time, and time-to-level fresh even when no XP events fire.
local refreshElapsed = 0
eventFrame:SetScript("OnUpdate", function(_, elapsed)
    refreshElapsed = refreshElapsed + (elapsed or 0)
    if refreshElapsed >= REFRESH_INTERVAL then
        refreshElapsed = 0
        RefreshAll()
    end
end)
