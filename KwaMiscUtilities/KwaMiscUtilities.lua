local addonName, MU = ...

local Util = KwaLite and KwaLite.Util
if not (KwaLite and KwaLite.RegisterAddon and Util) then
    print("|cffff0000[KwaMiscUtilities] KwaLite is required. Install the KwaLite addon to use Misc Utilities.|r")
    return
end

local ADDON_ID = "KwaMiscUtilities"
local TIME_TO_LEVEL_VIEW = "timeToLevel"
local PLUGIN_ICON = "Interface\\Icons\\inv_misc_dice_01"
local MINIMIZED_ICON = "Interface\\Icons\\misc_arrowlup"
local REFRESH_INTERVAL = 5

local panel
local timeToLevelCheckbox
local autoShareCheckbox
local miniFrame
local miniLabel
local questFrame
local trackerFrame

local tracking = false
local sessionStart = 0
local sessionXp = 0
local lastPlayerXP
local lastPlayerXPMax
local lastPlayerLevel
local refreshElapsed = 0
local pendingShareQuestID

local isSecret = function(v)
    return (issecretvalue and issecretvalue(v)) or false
end

local canAccess = function(v)
    return (canaccessvalue and canaccessvalue(v)) or true
end

local function SafeUnitNumber(api, unit)
    if type(api) ~= "function" then return nil end
    local ok, value = pcall(api, unit)
    if not ok or isSecret(value) or not canAccess(value) or type(value) ~= "number" then
        return nil
    end
    return value
end

local function ReadPlayerXP()
    return SafeUnitNumber(UnitXP, "player"),
        SafeUnitNumber(UnitXPMax, "player"),
        SafeUnitNumber(UnitLevel, "player")
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

local function EnsureDB()
    if type(KwaMiscUtilitiesDB) ~= "table" then
        KwaMiscUtilitiesDB = {}
    end
    if type(KwaMiscUtilitiesDB.autoShareQuests) ~= "boolean" then
        KwaMiscUtilitiesDB.autoShareQuests = false
    end
    return KwaMiscUtilitiesDB
end

-- Time to Level minimized view ------------------------------------------------

local function ActiveElapsed(now)
    local elapsed = (now or GetTime()) - sessionStart
    if elapsed < 1 then elapsed = 1 end
    return elapsed
end

local function GetXpPerHour(now)
    if sessionXp <= 0 then return 0 end
    return sessionXp / ActiveElapsed(now) * 3600
end

local function TimeToLevelText()
    local xp, xpMax = ReadPlayerXP()
    local remaining
    if xp and xpMax and xpMax > 0 then
        remaining = math.max(0, math.floor(xpMax) - math.floor(xp))
    elseif xpMax and xpMax <= 0 then
        remaining = 0
    end

    if remaining == 0 then return "MAX" end
    if not remaining then return "--" end

    local xpPerHour = GetXpPerHour(GetTime())
    if xpPerHour <= 0 then return "--" end
    return FormatDuration(remaining / (xpPerHour / 3600))
end

local function UpdateMinimizedText()
    if not miniFrame or not miniLabel then return end

    local text = "|cff9d9d9dTime to Level:|r " .. TimeToLevelText()
    miniLabel:SetText(text)

    local plain = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local textWidth = 0
    if miniLabel.GetStringWidth then
        -- Measure without color codes and with plenty of room so the width is
        -- not clamped by the previous label width.
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

local function RefreshTrackingDisplay()
    if KwaLite and KwaLite.RefreshMinimized then
        KwaLite:RefreshMinimized()
    else
        UpdateMinimizedText()
    end
end

local function ResetTrackingBaseline()
    lastPlayerXP, lastPlayerXPMax, lastPlayerLevel = ReadPlayerXP()
end

local function TrackerOnUpdate(_, elapsed)
    refreshElapsed = refreshElapsed + (elapsed or 0)
    if refreshElapsed >= REFRESH_INTERVAL then
        refreshElapsed = 0
        RefreshTrackingDisplay()
    end
end

local function StartTracking()
    if tracking then return end
    tracking = true
    sessionStart = GetTime()
    sessionXp = 0
    refreshElapsed = 0
    ResetTrackingBaseline()

    if trackerFrame then
        trackerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        trackerFrame:RegisterEvent("PLAYER_LEVEL_UP")
        trackerFrame:RegisterEvent("PLAYER_XP_UPDATE")
        trackerFrame:SetScript("OnUpdate", TrackerOnUpdate)
    end

    RefreshTrackingDisplay()
end

local function StopTracking()
    if not tracking then return end
    tracking = false
    if trackerFrame then
        trackerFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
        trackerFrame:UnregisterEvent("PLAYER_LEVEL_UP")
        trackerFrame:UnregisterEvent("PLAYER_XP_UPDATE")
        trackerFrame:SetScript("OnUpdate", nil)
    end
end

local function OnTimeToLevelToggle(checked)
    if checked then
        StartTracking()
    else
        StopTracking()
    end
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

    UpdateMinimizedText()
    return miniFrame
end

-- Auto share newly accepted quests -------------------------------------------

local function CountGroupMembers()
    if GetNumGroupMembers then
        local ok, count = pcall(GetNumGroupMembers)
        if ok and type(count) == "number" then return count end
    end
    if GetNumSubgroupMembers then
        local ok, count = pcall(GetNumSubgroupMembers)
        if ok and type(count) == "number" then return count + 1 end
    end
    return 0
end

local function FindQuestLogIndex(questID)
    if type(questID) ~= "number" and type(questID) ~= "string" then return nil end
    questID = tonumber(questID)
    if not questID then return nil end

    if C_QuestLog then
        if C_QuestLog.GetLogIndexForQuestID then
            local ok, index = pcall(C_QuestLog.GetLogIndexForQuestID, questID)
            if ok and type(index) == "number" and index > 0 then return index end
        end

        if C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
            local ok, count = pcall(C_QuestLog.GetNumQuestLogEntries)
            if ok and type(count) == "number" then
                for index = 1, count do
                    local infoOk, info = pcall(C_QuestLog.GetInfo, index)
                    if infoOk and type(info) == "table" and info.questID == questID then
                        return index
                    end
                end
            end
        end
    end

    if GetNumQuestLogEntries and GetQuestLogTitle then
        local ok, count = pcall(GetNumQuestLogEntries)
        if ok and type(count) == "number" then
            for index = 1, count do
                local titleOk, _, _, _, _, _, _, _, id = pcall(GetQuestLogTitle, index)
                if titleOk and tonumber(id) == questID then return index end
            end
        end
    end

    return nil
end

local function IsQuestPushable(questID, index)
    if C_QuestLog and C_QuestLog.IsPushableQuest then
        local ok, pushable = pcall(C_QuestLog.IsPushableQuest, questID)
        if ok and pushable ~= nil then return pushable and true or false end
    end

    if GetQuestLogPushable and SelectQuestLogEntry then
        pcall(SelectQuestLogEntry, index)
        local ok, pushable = pcall(GetQuestLogPushable)
        if ok then return pushable and true or false end
    end

    return false
end

local function ShareQuest(questID)
    if not questID or CountGroupMembers() <= 1 then return end
    if UnitInBattleground and UnitInBattleground("player") then return end
    if type(QuestLogPushQuest) ~= "function" then return end
    if InCombatLockdown and InCombatLockdown() then
        pendingShareQuestID = questID
        return
    end

    local index = FindQuestLogIndex(questID)
    if not index then return end
    if not IsQuestPushable(questID, index) then return end

    pcall(function()
        if C_QuestLog and C_QuestLog.SetSelectedQuest then
            C_QuestLog.SetSelectedQuest(questID)
        elseif SelectQuestLogEntry then
            SelectQuestLogEntry(index)
        end
        QuestLogPushQuest()
    end)
end

local function TryPendingShare()
    if not pendingShareQuestID then return end
    if InCombatLockdown and InCombatLockdown() then return end
    local questID = pendingShareQuestID
    pendingShareQuestID = nil
    ShareQuest(questID)
end

local function QueueShare(questID)
    if not questID then return end
    if C_Timer and C_Timer.After then
        C_Timer.After(0.2, function()
            ShareQuest(questID)
        end)
    else
        ShareQuest(questID)
    end
end

local function UpdateQuestSharing()
    if not questFrame then return end
    if EnsureDB().autoShareQuests then
        questFrame:RegisterEvent("QUEST_ACCEPTED")
        questFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        questFrame:UnregisterEvent("QUEST_ACCEPTED")
        questFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        pendingShareQuestID = nil
    end
end

local function SyncPanelState()
    if timeToLevelCheckbox then
        timeToLevelCheckbox:SetChecked(KwaLite:IsMinimizedViewShown(ADDON_ID, TIME_TO_LEVEL_VIEW))
    end
    if autoShareCheckbox then
        autoShareCheckbox:SetChecked(EnsureDB().autoShareQuests)
    end
end

local function CreatePanel(parent)
    if panel then return panel end

    panel = CreateFrame("Frame", nil, parent)

    -- Minimized Displays
    local minimizedHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    minimizedHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    minimizedHeader:SetText("|cffffd100Minimized Displays|r")

    timeToLevelCheckbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    timeToLevelCheckbox:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -28)
    timeToLevelCheckbox:SetSize(20, 20)
    timeToLevelCheckbox:SetChecked(KwaLite:IsMinimizedViewShown(ADDON_ID, TIME_TO_LEVEL_VIEW))
    timeToLevelCheckbox:SetScript("OnClick", function(self)
        KwaLite:SetMinimizedViewShown(ADDON_ID, TIME_TO_LEVEL_VIEW, self:GetChecked() and true or false)
    end)
    timeToLevelCheckbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Time to Level", 1, 0.82, 0)
        GameTooltip:AddLine("Checked: show time to level in the minimized bar.", 1, 1, 1, true)
        GameTooltip:AddLine("Unchecked: hide it and stop the tracker.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    timeToLevelCheckbox:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local timeToLevelLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    timeToLevelLabel:SetPoint("LEFT", timeToLevelCheckbox, "RIGHT", 1, 0)
    timeToLevelLabel:SetJustifyH("LEFT")
    timeToLevelLabel:SetText("Time to Level")

    -- Functionality
    local functionalityHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    functionalityHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -56)
    functionalityHeader:SetText("|cffffd100Functionality|r")

    autoShareCheckbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    autoShareCheckbox:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -84)
    autoShareCheckbox:SetSize(20, 20)
    autoShareCheckbox:SetChecked(EnsureDB().autoShareQuests)
    autoShareCheckbox:SetScript("OnClick", function(self)
        EnsureDB().autoShareQuests = self:GetChecked() and true or false
        UpdateQuestSharing()
    end)
    autoShareCheckbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Auto share quests", 1, 0.82, 0)
        GameTooltip:AddLine("Checked: share newly accepted quests with your party or raid.", 1, 1, 1, true)
        GameTooltip:AddLine("Unchecked: never share quests automatically.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    autoShareCheckbox:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    local checkboxLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    checkboxLabel:SetPoint("LEFT", autoShareCheckbox, "RIGHT", 1, 0)
    checkboxLabel:SetJustifyH("LEFT")
    checkboxLabel:SetText("Auto share newly accepted quests")

    local description = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    description:SetPoint("TOPLEFT", autoShareCheckbox, "BOTTOMLEFT", 0, -6)
    description:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -8, -110)
    description:SetJustifyH("LEFT")
    description:SetWordWrap(true)
    description:SetText("When enabled, quests you accept are pushed to your group. Only works while grouped and only for shareable quests. Disabled by default.")

    return panel
end

-- Registration ---------------------------------------------------------------

if KwaLite and KwaLite.RegisterAddon and KwaLite.Util then
    KwaLite:RegisterAddon({
        id = ADDON_ID,
        name = "Misc Utilities",
        icon = PLUGIN_ICON,
        priority = 999,
        createPanel = CreatePanel,
        renderMinimizedOptions = false,
        minimizedViews = {
            {
                id = TIME_TO_LEVEL_VIEW,
                label = "Time to Level",
                icon = MINIMIZED_ICON,
                showByDefault = false,
                create = CreateMinimized,
                refresh = function() UpdateMinimizedText() end,
                onToggle = OnTimeToLevelToggle,
            },
        },
        refresh = function() SyncPanelState() end,
    })
end

trackerFrame = CreateFrame("Frame")
trackerFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_ENTERING_WORLD" then
        ResetTrackingBaseline()
        RefreshTrackingDisplay()
    elseif event == "PLAYER_LEVEL_UP" then
        RefreshTrackingDisplay()
    elseif event == "PLAYER_XP_UPDATE" then
        local xp, xpMax, level = ReadPlayerXP()
        if not xp or not xpMax then return end

        if lastPlayerXP == nil or lastPlayerLevel == nil then
            lastPlayerXP, lastPlayerXPMax, lastPlayerLevel = xp, xpMax, level
            RefreshTrackingDisplay()
            return
        end

        local delta
        if level and lastPlayerLevel and level > lastPlayerLevel then
            delta = math.max(0, (lastPlayerXPMax or xpMax) - lastPlayerXP) + xp
        else
            delta = xp - lastPlayerXP
        end

        lastPlayerXP, lastPlayerXPMax, lastPlayerLevel = xp, xpMax, level

        if delta > 0 then
            sessionXp = sessionXp + delta
        end
        RefreshTrackingDisplay()
    end
end)

questFrame = CreateFrame("Frame")
questFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "PLAYER_REGEN_ENABLED" then
        TryPendingShare()
    elseif event == "QUEST_ACCEPTED" then
        if not EnsureDB().autoShareQuests then return end
        -- Forever sends only the quest ID; Classic sends log index then ID.
        local questID = arg2 or arg1
        QueueShare(questID)
    end
end)

UpdateQuestSharing()

if KwaLite:IsMinimizedViewShown(ADDON_ID, TIME_TO_LEVEL_VIEW) then
    StartTracking()
end
