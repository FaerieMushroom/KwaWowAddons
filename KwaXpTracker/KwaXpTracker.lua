local addonName, XPT = ...

local isSecret = function(v)
    return (issecretvalue and issecretvalue(v)) or false
end
local canAccess = function(v)
    return (canaccessvalue and canaccessvalue(v)) or true
end

local XP_MATCH_WINDOW = 3
local XP_FLUSH_DELAY = 0.3
local XP_EVENT_RETENTION = 10
local ROW_SPACING = 18

local panel
local miniFrame
local miniLabel
local bar
local barText
local statTime
local statXpKill
local statKills
local statXpHour
local statKillTotal
local statQuestTotal
local statLastKill
local hintLabel
local contextMenu
local contextOverlay

local lastPlayerXP
local lastPlayerXPMax
local lastPlayerLevel
local sessionXp = 0
local sessionKillXp = 0
local sessionQuestXp = 0
local sessionStart = GetTime()

local pendingXp = {}
local recentChatXp = {}
local flushScheduled = false

local RefreshPanel
local RefreshMinimized
local RefreshAll

local function EnsureDB()
    if type(KwaXpTrackerDB) ~= "table" then
        KwaXpTrackerDB = {}
    end
    local db = KwaXpTrackerDB
    db.totalKillXp = db.totalKillXp or 0
    db.totalQuestXp = db.totalQuestXp or 0
    db.killCount = db.killCount or 0
    db.lastKillXp = db.lastKillXp or 0
    return db
end

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

local function MakeXpPattern(template)
    if not template or template == "" then return nil end
    local ok, pattern = pcall(function()
        return template:gsub("%%s", "(.-)"):gsub("%%d", "(%%d+)")
    end)
    if not ok or not pattern or pattern == "" then return nil end
    return pattern
end

local killPattern = MakeXpPattern(_G.COMBATLOG_XPGAIN_FIRSTPERSON or "%s dies, you gain %d experience.")
local killUnnamedPattern = MakeXpPattern(_G.COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED or "You gain %d experience.")
local questPattern = MakeXpPattern(_G.COMBATLOG_XPGAIN_QUEST or "You gain %d experience from quest: %s.")

local function ParseXpMessage(message)
    if type(message) ~= "string" or message == "" then return nil end
    if isSecret(message) or not canAccess(message) then return nil end

    if questPattern then
        local xp, questName = message:match(questPattern)
        if xp then
            return tonumber(xp), "quest", questName
        end
    end

    if killPattern then
        local mobName, xp = message:match(killPattern)
        if xp then
            return tonumber(xp), "kill", mobName
        end
    end

    if killUnnamedPattern then
        local xp = message:match(killUnnamedPattern)
        if xp then
            return tonumber(xp), "kill", nil
        end
    end

    return nil
end

local function PruneXpEvents(now)
    for index = #pendingXp, 1, -1 do
        if (now - pendingXp[index].time) > XP_EVENT_RETENTION then
            table.remove(pendingXp, index)
        end
    end
    for index = #recentChatXp, 1, -1 do
        if (now - recentChatXp[index].time) > XP_EVENT_RETENTION then
            table.remove(recentChatXp, index)
        end
    end
end

local function ApplyXpGain(amount, kind, name, gainTime)
    amount = tonumber(amount) or 0
    if amount <= 0 then return end

    local db = EnsureDB()
    if sessionXp <= 0 then
        sessionStart = gainTime or GetTime()
    end

    sessionXp = sessionXp + amount
    if kind == "quest" then
        db.totalQuestXp = db.totalQuestXp + amount
        sessionQuestXp = sessionQuestXp + amount
    else
        db.totalKillXp = db.totalKillXp + amount
        sessionKillXp = sessionKillXp + amount
        db.killCount = db.killCount + 1
        db.lastKillXp = amount
        if name and name ~= "" then
            db.lastKillName = name
        end
    end
end

local function ReclassifyXp(amount, fromKind, toKind, name)
    amount = tonumber(amount) or 0
    if amount <= 0 or fromKind == toKind then return false end

    local db = EnsureDB()
    if fromKind == "quest" then
        db.totalQuestXp = math.max(0, db.totalQuestXp - amount)
        sessionQuestXp = math.max(0, sessionQuestXp - amount)
    else
        db.totalKillXp = math.max(0, db.totalKillXp - amount)
        sessionKillXp = math.max(0, sessionKillXp - amount)
        db.killCount = math.max(0, db.killCount - 1)
    end

    if toKind == "quest" then
        db.totalQuestXp = db.totalQuestXp + amount
        sessionQuestXp = sessionQuestXp + amount
    else
        db.totalKillXp = db.totalKillXp + amount
        sessionKillXp = sessionKillXp + amount
        db.killCount = db.killCount + 1
        db.lastKillXp = amount
        if name and name ~= "" then
            db.lastKillName = name
        end
    end
    return true
end

local function ScheduleXpFlush()
    if flushScheduled then return end
    flushScheduled = true

    if C_Timer and C_Timer.After then
        C_Timer.After(XP_FLUSH_DELAY, function()
            flushScheduled = false
            local now = GetTime()
            local changed = false

            for _, pending in ipairs(pendingXp) do
                if not pending.finalized and not pending.kind then
                    for index = #recentChatXp, 1, -1 do
                        local chat = recentChatXp[index]
                        if not chat.used and chat.amount == pending.amount
                            and (now - chat.time) <= XP_MATCH_WINDOW then
                            pending.kind = chat.kind
                            pending.name = chat.name
                            chat.used = true
                            break
                        end
                    end
                end
            end

            for _, pending in ipairs(pendingXp) do
                if not pending.finalized then
                    pending.finalized = true
                    ApplyXpGain(pending.amount, pending.kind or "kill", pending.name, pending.time)
                    changed = true
                end
            end

            for _, chat in ipairs(recentChatXp) do
                if not chat.used and not chat.counted then
                    chat.used = true
                    chat.counted = true
                    ApplyXpGain(chat.amount, chat.kind, chat.name, chat.time)
                    changed = true
                end
            end

            PruneXpEvents(now)
            if changed then
                RefreshAll()
            end
        end)
    else
        flushScheduled = false
    end
end

local function EnqueueXpDelta(delta, now)
    delta = tonumber(delta) or 0
    if delta <= 0 then return end

    PruneXpEvents(now)
    for index = #recentChatXp, 1, -1 do
        local chat = recentChatXp[index]
        if chat.amount == delta and (now - chat.time) <= XP_MATCH_WINDOW then
            if chat.counted then
                return
            end
            if not chat.used then
                chat.used = true
                pendingXp[#pendingXp + 1] = {
                    amount = delta,
                    time = now,
                    kind = chat.kind,
                    name = chat.name,
                }
                ScheduleXpFlush()
                return
            end
        end
    end

    pendingXp[#pendingXp + 1] = {
        amount = delta,
        time = now,
    }
    ScheduleXpFlush()
end

local function OnChatXp(amount, kind, name)
    amount = tonumber(amount) or 0
    if amount <= 0 then return end

    local now = GetTime()
    PruneXpEvents(now)

    local matched = false
    local matchedFinalized = false
    local finalizedKind
    for index = #pendingXp, 1, -1 do
        local pending = pendingXp[index]
        if pending.amount == amount and (now - pending.time) <= XP_MATCH_WINDOW then
            if pending.finalized then
                matchedFinalized = true
                finalizedKind = pending.kind
            elseif not pending.kind then
                pending.kind = kind
                pending.name = name
            end
            matched = true
            break
        end
    end

    if matchedFinalized and finalizedKind and finalizedKind ~= kind then
        if ReclassifyXp(amount, finalizedKind, kind, name) then
            RefreshAll()
        end
    end

    recentChatXp[#recentChatXp + 1] = {
        amount = amount,
        kind = kind,
        name = name,
        time = now,
        used = matched,
        counted = matchedFinalized,
    }

    if not matched then
        ScheduleXpFlush()
    end
end

local function HideContextMenu()
    if contextMenu then contextMenu:Hide() end
    if contextOverlay then contextOverlay:Hide() end
end

local function ResetTotals()
    local db = EnsureDB()
    db.totalKillXp = 0
    db.totalQuestXp = 0
    db.killCount = 0
    db.lastKillXp = 0
    db.lastKillName = nil
    pendingXp = {}
    recentChatXp = {}
    RefreshAll()
end

local function ResetTimer()
    sessionXp = 0
    sessionKillXp = 0
    sessionQuestXp = 0
    sessionStart = GetTime()
    RefreshAll()
end

local function ResetAll()
    ResetTotals()
    ResetTimer()
    lastPlayerXP = SafeUnitXP()
    lastPlayerXPMax = SafeUnitXPMax()
    lastPlayerLevel = SafeUnitLevel()
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

local function ShowResetMenu()
    local menu = CreateContextMenu()
    local options = {
        { label = "Reset XP totals", action = ResetTotals },
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

local function CreateStatRow(parent, y, labelText)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -y)
    label:SetText(labelText)

    local value = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    value:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -y)
    value:SetJustifyH("RIGHT")
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

    bar = CreateFrame("StatusBar", nil, panel)
    bar:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    bar:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    bar:SetHeight(20)
    bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    bar:SetStatusBarColor(0.25, 0.55, 0.95)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(0)

    local barBackground = bar:CreateTexture(nil, "BACKGROUND")
    barBackground:SetAllPoints()
    barBackground:SetColorTexture(0, 0, 0, 0.6)

    barText = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    barText:SetPoint("CENTER", bar, "CENTER", 0, 0)

    local rowY = 30
    statTime = CreateStatRow(panel, rowY, "Time to level:")
    rowY = rowY + ROW_SPACING
    statXpKill = CreateStatRow(panel, rowY, "XP per kill:")
    rowY = rowY + ROW_SPACING
    statKills = CreateStatRow(panel, rowY, "Kills to level:")
    rowY = rowY + ROW_SPACING
    statXpHour = CreateStatRow(panel, rowY, "XP per hour:")

    rowY = rowY + ROW_SPACING + 8
    statKillTotal = CreateStatRow(panel, rowY, "Kill XP total:")
    rowY = rowY + ROW_SPACING
    statQuestTotal = CreateStatRow(panel, rowY, "Quest XP total:")

    rowY = rowY + ROW_SPACING + 6
    statLastKill = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    statLastKill:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -rowY)
    statLastKill:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -rowY)
    statLastKill:SetJustifyH("LEFT")

    rowY = rowY + ROW_SPACING + 2
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
    miniLabel:SetWordWrap(false)

    RefreshMinimized()
    return miniFrame
end

local function GetXpPerHour(now)
    if sessionXp <= 0 then return 0 end
    local elapsed = math.max(1, now - sessionStart)
    return sessionXp / elapsed * 3600
end

RefreshPanel = function()
    if not panel or not bar or not bar:IsShown() then return end

    local db = EnsureDB()
    local xp, xpMax, level = ReadPlayerXP()
    local remaining
    local percent

    if xp and xpMax and xpMax > 0 then
        xpMax = math.floor(xpMax)
        xp = math.floor(xp)
        bar:SetMinMaxValues(0, xpMax)
        bar:SetValue(math.min(math.max(xp, 0), xpMax))
        percent = (xp / xpMax) * 100
        remaining = math.max(0, xpMax - xp)
        local levelText = level and ("Lvl " .. tostring(level) .. "  |  ") or ""
        barText:SetText(levelText .. string.format("%.1f%%", percent) .. "  |  "
            .. FormatNumber(xp) .. " / " .. FormatNumber(xpMax) .. " XP")
    elseif xpMax and xpMax <= 0 then
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(1)
        percent = 100
        remaining = 0
        barText:SetText("MAX LEVEL")
    else
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(0)
        percent = 0
        remaining = nil
        barText:SetText("XP unavailable")
    end

    local now = GetTime()
    local xpPerHour = GetXpPerHour(now)
    local timeToLevel = (remaining and xpPerHour > 0) and (remaining / (xpPerHour / 3600)) or nil
    local xpPerKill = db.killCount > 0 and (db.totalKillXp / db.killCount) or 0
    local killsToLevel = (remaining and db.lastKillXp > 0) and math.ceil(remaining / db.lastKillXp) or nil

    statTime:SetText(FormatDuration(timeToLevel))
    statXpKill:SetText(FormatNumber(xpPerKill))
    statKills:SetText(killsToLevel and tostring(killsToLevel) or "--")
    statXpHour:SetText(FormatNumber(xpPerHour))

    statKillTotal:SetText(FormatNumber(db.totalKillXp) .. "  (" .. FormatNumber(db.killCount) .. " kills)")
    statQuestTotal:SetText(FormatNumber(db.totalQuestXp))

    if db.lastKillXp > 0 then
        local name = db.lastKillName or "last mob"
        statLastKill:SetText("Last kill: " .. name .. " (" .. FormatNumber(db.lastKillXp) .. " XP)")
    else
        statLastKill:SetText("Last kill: none recorded")
    end
end

RefreshMinimized = function()
    if not miniFrame or not miniLabel then return end

    local xp, xpMax = ReadPlayerXP()
    local text
    if xp and xpMax and xpMax > 0 then
        local percent = (xp / xpMax) * 100
        local remaining = math.max(0, xpMax - xp)
        local xpPerHour = GetXpPerHour(GetTime())
        local timeToLevel = xpPerHour > 0 and (remaining / (xpPerHour / 3600)) or nil
        text = string.format("XP %.0f%%", percent)
        if timeToLevel then
            text = text .. "  |  " .. FormatDuration(timeToLevel) .. " to level"
        end
    elseif xpMax and xpMax <= 0 then
        text = "XP MAX"
    else
        text = "XP --"
    end

    miniLabel:SetText(text)

    local textWidth = 0
    if miniLabel.GetStringWidth then
        local ok, width = pcall(miniLabel.GetStringWidth, miniLabel)
        if ok and type(width) == "number" then
            textWidth = width
        end
    end
    if textWidth <= 0 then
        local plain = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        textWidth = #plain * 6
    end
    miniFrame:SetWidth(math.ceil(math.max(textWidth + 2, 60)))
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
eventFrame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        InitializePlayerXP()
        RefreshAll()
    elseif event == "PLAYER_LEVEL_UP" then
        RefreshAll()
    elseif event == "PLAYER_XP_UPDATE" then
        local xp, xpMax, level = ReadPlayerXP()
        if not xp or not xpMax then return end

        local now = GetTime()
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
            EnqueueXpDelta(delta, now)
        end
        RefreshAll()
    elseif event == "CHAT_MSG_COMBAT_XP_GAIN" then
        local message = ...
        local amount, kind, name = ParseXpMessage(message)
        if amount then
            OnChatXp(amount, kind, name)
        end
    end
end)
