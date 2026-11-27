local addonName, NS = ...

-- Bookmarker: keeps two character macros in sync.
--   KwaMarker  runs KwaBookmarker:AddTarget(), which adds the current target
--              mob to the tracked list.
--   KwaTarget  tries the tracked mob names highest-priority last, then marks
--              the result with the X raid marker and falls back when the match
--              is dead.
--
-- The list is maintained like Unit Labeler: a scroll panel with a Top button
-- and an x button per row. Index 1 is the highest priority.

if not (KwaLite and KwaLite.RegisterAddon and KwaLite.Util) then
    return
end

local Util = KwaLite.Util

_G.KwaBookmarker = NS

local PLUGIN_ICON = "Interface\\Icons\\Ability_Hunter_Pet_Wolf"
local MACRO_ICON = "Ability_Hunter_Pet_Wolf"

local MARKER_MACRO = "KwaMarker"
local TARGET_MACRO = "KwaTarget"
local MARKER_BODY = "/run KwaBookmarker:AddTarget()"

-- /tm !7 sets the cross/X raid marker on the current target. The dead fallback
-- returns to the previous target when /targetexact matched a corpse.
local TARGET_SUFFIX = "\n/tm !7\n/targetlasttarget [dead]"
local MAX_MACRO_LENGTH = 255
local TARGET_BUDGET = MAX_MACRO_LENGTH - #TARGET_SUFFIX

local ROW_HEIGHT = 24

local panel
local scroll
local content
local emptyLabel
local headerLabel
local nameBox
local rowPool
local miniFrame
local miniLabel

-- Build state: which entries currently fit in the macro.
local activeMap = {}
local activeCount = 0
local macroBody = ""
local pendingUpdate = false
local macrosReady = false
local createWarned = {}

local Refresh
local RefreshMinimized
local PromoteEntry
local RemoveEntry

local function Print(message)
    print("|cffffd100KwaBookmarker:|r " .. tostring(message))
end

local function Trim(text)
    if type(text) ~= "string" then return "" end
    return (text:match("^%s*(.-)%s*$") or "")
end

local function NameKey(name)
    local text = Trim(name):lower()
    text = text:gsub("%s+", " ")
    return text
end

local function EnsureDB()
    if type(KwaBookmarkerDB) ~= "table" then KwaBookmarkerDB = {} end
    local db = KwaBookmarkerDB
    if type(db.entries) ~= "table" then db.entries = {} end

    for index = #db.entries, 1, -1 do
        local entry = db.entries[index]
        if type(entry) ~= "table" then
            table.remove(db.entries, index)
        else
            entry.name = Trim(entry.name)
            if entry.name == "" then
                table.remove(db.entries, index)
            else
                if type(entry.npcID) ~= "number" then
                    entry.npcID = tonumber(entry.npcID)
                end
                if type(entry.added) ~= "number" then entry.added = nil end
            end
        end
    end

    -- Keep the first (highest-priority) occurrence of each name.
    local seen = {}
    local index = 1
    while index <= #db.entries do
        local entry = db.entries[index]
        local key = NameKey(entry.name)
        if seen[key] then
            table.remove(db.entries, index)
        else
            seen[key] = true
            index = index + 1
        end
    end

    return db
end

local function GetNpcID(unit)
    local ok, guid = pcall(UnitGUID, unit)
    if not ok or type(guid) ~= "string" then return nil end
    if issecretvalue and issecretvalue(guid) then return nil end
    local id = guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)")
    return tonumber(id)
end

-- Macro construction -----------------------------------------------------------

-- Returns body, activeMap, activeCount.
-- Lines are assembled lowest-priority first so the highest-priority match is
-- the last /targetexact line (matching RestedXP's targeting macro). When the
-- text is too long, lines are dropped from the front, so low-priority names
-- are the ones that do not fit.
local function BuildTargetMacro(entries)
    local lines = {}
    for index = #entries, 1, -1 do
        lines[#lines + 1] = {
            index = index,
            text = "/targetexact " .. entries[index].name,
        }
    end

    local function assemble()
        local parts = {}
        for i = 1, #lines do parts[i] = lines[i].text end
        return table.concat(parts, "\n")
    end

    local text = assemble()
    while #lines > 0 and #text > TARGET_BUDGET do
        table.remove(lines, 1)
        text = assemble()
    end

    local active = {}
    for i = 1, #lines do active[lines[i].index] = true end

    local body = ""
    if text ~= "" then
        body = text .. TARGET_SUFFIX
    end
    return body, active, #lines
end

local function FindMacroIndex(name)
    if GetMacroIndexByName then
        local ok, index = pcall(GetMacroIndexByName, name)
        if ok and type(index) == "number" and index > 0 then
            return index
        end
    end

    if GetMacroInfo and GetNumMacros then
        local ok, general, character = pcall(GetNumMacros)
        if ok then
            local total = (tonumber(general) or 0) + (tonumber(character) or 0)
            for index = 1, total do
                local found, macroName = pcall(GetMacroInfo, index)
                if found and macroName == name then
                    return index
                end
            end
        end
    end

    return nil
end

local function CreateMacroSafe(name, body)
    if not CreateMacro then return nil end
    local ok, index = pcall(CreateMacro, name, MACRO_ICON, body)
    if ok and type(index) == "number" and index > 0 then
        createWarned[name] = nil
        return index
    end
    if not createWarned[name] then
        createWarned[name] = true
        Print("could not create the " .. name .. " macro (no free macro slots?)")
    end
    return nil
end

-- Apply the current list to the macros. Deferred during combat, then flushed
-- on PLAYER_REGEN_ENABLED.
local function SyncMacros()
    if not macrosReady then
        pendingUpdate = true
        return
    end
    if InCombatLockdown and InCombatLockdown() then
        pendingUpdate = true
        return
    end
    pendingUpdate = false

    local markerIndex = FindMacroIndex(MARKER_MACRO)
    if not markerIndex then
        markerIndex = CreateMacroSafe(MARKER_MACRO, MARKER_BODY)
    end
    if markerIndex and EditMacro then
        local _, _, current = GetMacroInfo(markerIndex)
        if current ~= MARKER_BODY then
            pcall(EditMacro, markerIndex, MARKER_MACRO, nil, MARKER_BODY)
        end
    end

    local targetIndex = FindMacroIndex(TARGET_MACRO)
    if not targetIndex then
        targetIndex = CreateMacroSafe(TARGET_MACRO, macroBody)
    end
    if targetIndex and EditMacro then
        local _, _, current = GetMacroInfo(targetIndex)
        if current ~= macroBody then
            pcall(EditMacro, targetIndex, TARGET_MACRO, nil, macroBody)
        end
    end
end

local function RebuildMacroState()
    macroBody, activeMap, activeCount = BuildTargetMacro(EnsureDB().entries)
end

local function RefreshMacroState()
    RebuildMacroState()
    SyncMacros()
end

-- Add target -------------------------------------------------------------------

local function AddName(name, npcID)
    local db = EnsureDB()
    name = Trim(name)
    name = name:gsub("%s+", " ")
    if name == "" then
        Print("type a name to add.")
        return nil
    end

    local key = NameKey(name)
    for index, entry in ipairs(db.entries) do
        if NameKey(entry.name) == key then
            table.remove(db.entries, index)
            RefreshMacroState()
            if Refresh then Refresh() end
            if KwaLite.RefreshMinimized then KwaLite:RefreshMinimized() end
            Print('removed "' .. entry.name .. '".')
            return true
        end
    end

    db.entries[#db.entries + 1] = {
        name = name,
        npcID = npcID,
        added = time and time() or nil,
    }

    RefreshMacroState()
    if Refresh then Refresh() end
    if KwaLite.RefreshMinimized then KwaLite:RefreshMinimized() end

    local index = #db.entries
    if activeMap[index] then
        Print('bookmarked "' .. name .. '" (in the macro).')
    else
        Print('bookmarked "' .. name .. '" (queued; Top moves it into the macro).')
    end

    return true
end

function NS:AddTarget()
    if not UnitExists or not UnitExists("target") then
        Print("no target to bookmark.")
        return
    end

    local ok, isPlayer = pcall(UnitIsPlayer, "target")
    if ok and not (issecretvalue and issecretvalue(isPlayer)) and isPlayer then
        Print("players cannot be bookmarked.")
        return
    end

    local raw = UnitName("target")
    if type(raw) ~= "string" then raw = nil end
    if raw and issecretvalue and issecretvalue(raw) then raw = nil end
    local name = Trim(raw or "")
    if name == "" then
        Print("that target has no usable name.")
        return
    end

    AddName(name, GetNpcID("target"))
end

-- Rows -------------------------------------------------------------------------

local function CreateSmallButton(parent, text, width)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(width or 30, 16)
    button:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    button:SetBackdropColor(0.08, 0.08, 0.1, 1)
    button:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)

    local label = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetAllPoints()
    label:SetJustifyH("CENTER")
    label:SetJustifyV("MIDDLE")
    label:SetText(text)
    button.label = label

    button:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(0.5, 0.5, 0.58, 1)
    end)
    button:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.3, 0.3, 0.36, 1)
    end)

    return button
end

local function CreateRow()
    local row = CreateFrame("Frame", nil, content)
    row:SetHeight(ROW_HEIGHT)
    row:EnableMouse(true)

    row.background = Util.AddRowHoverBackground(row, 0.04)
    Util.SetHoverScripts(row)

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.name:SetPoint("LEFT", row, "LEFT", 4, 0)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)

    row.delete = CreateFrame("Button", nil, row)
    row.delete:SetSize(16, 16)
    row.delete:SetPoint("RIGHT", row, "RIGHT", -2, 0)
    local deleteText = row.delete:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    deleteText:SetAllPoints()
    deleteText:SetText("x")
    row.delete:SetScript("OnClick", function(self)
        if self.entry then RemoveEntry(self.entry) end
    end)
    row.delete:SetScript("OnEnter", function()
        deleteText:SetTextColor(1, 0.3, 0.3)
    end)
    row.delete:SetScript("OnLeave", function()
        deleteText:SetTextColor(1, 1, 1)
    end)

    row.top = CreateSmallButton(row, "Top", 30)
    row.top:SetPoint("RIGHT", row.delete, "LEFT", -4, 0)
    row.top:SetScript("OnClick", function(self)
        if self.entry then PromoteEntry(self.entry) end
    end)

    row.status = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.status:SetPoint("RIGHT", row.top, "LEFT", -6, 0)
    row.status:SetWidth(52)
    row.status:SetJustifyH("RIGHT")

    -- Keep the name clear of the status text.
    row.name:SetPoint("RIGHT", row.status, "LEFT", -6, 0)

    return row
end

rowPool = Util.CreateRowPool(CreateRow)

-- List changes -----------------------------------------------------------------

local function AfterListChange()
    RefreshMacroState()
    if Refresh then Refresh() end
    if KwaLite.RefreshMinimized then KwaLite:RefreshMinimized() end
end

PromoteEntry = function(entry)
    local db = EnsureDB()
    for index, candidate in ipairs(db.entries) do
        if candidate == entry then
            if index > 1 then
                table.remove(db.entries, index)
                table.insert(db.entries, 1, entry)
            end
            break
        end
    end
    AfterListChange()
end

RemoveEntry = function(entry)
    local db = EnsureDB()
    for index, candidate in ipairs(db.entries) do
        if candidate == entry then
            table.remove(db.entries, index)
            break
        end
    end
    AfterListChange()
end

-- Panel ------------------------------------------------------------------------

Refresh = function()
    if not content then return end

    local db = EnsureDB()
    Util.FitContentWidth(scroll, content, panel, 26, 240)

    local y = 0
    for index, entry in ipairs(db.entries) do
        local row = rowPool:Get(index)

        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)
        row:SetHeight(ROW_HEIGHT)

        row.entry = entry
        row.top.entry = entry
        row.delete.entry = entry

        row.name:SetText(entry.name)
        row.top:SetShown(index > 1)
        if activeMap[index] then
            row.status:SetText("|cff40c040in macro|r")
        else
            row.status:SetText("|cff9d9d9dqueued|r")
        end
        row.background:Hide()
        row:Show()
        y = y + ROW_HEIGHT
    end

    rowPool:Trim(#db.entries)

    content:SetHeight(math.max(y, 1))
    emptyLabel:SetShown(#db.entries == 0)

    if headerLabel then
        if #db.entries == 0 then
            headerLabel:SetText("No mobs tracked")
        else
            headerLabel:SetText(string.format(
                "%d tracked (%d in macro, %d queued)",
                #db.entries, activeCount, #db.entries - activeCount))
        end
    end
end

RefreshMinimized = function()
    if not miniLabel then return end
    local total = #EnsureDB().entries
    if total == 0 then
        miniLabel:SetText("No mobs")
    else
        miniLabel:SetText(string.format("%d/%d active", activeCount, total))
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

    RefreshMinimized()
    return miniFrame
end

local function CreatePanel(parent)
    if panel then return panel end

    EnsureDB()
    panel = CreateFrame("Frame", nil, parent)

    headerLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    headerLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    headerLabel:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -8, 0)
    headerLabel:SetJustifyH("LEFT")

    local inputRow = CreateFrame("Frame", nil, panel)
    inputRow:SetPoint("TOPLEFT", headerLabel, "BOTTOMLEFT", 0, -6)
    inputRow:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -42, -18)
    inputRow:SetHeight(22)

    local inputFrame, box = Util.CreateSearchBox(inputRow, {
        placeholder = "Add a mob name...",
        maxLetters = 80,
        onEnter = function()
            if AddName(nameBox:GetText()) then
                nameBox:SetText("")
                nameBox:ClearFocus()
            end
        end,
    })
    nameBox = box

    local addButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    addButton:SetSize(34, 20)
    addButton:SetPoint("LEFT", inputFrame, "RIGHT", 6, 0)
    addButton:SetText("+")
    addButton:SetScript("OnClick", function()
        if AddName(nameBox:GetText()) then
            nameBox:SetText("")
            nameBox:ClearFocus()
        end
    end)
    addButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Add name", 1, 0.82, 0)
        GameTooltip:AddLine("Adds the typed mob name to the list.", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    addButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("TOPLEFT", inputRow, "BOTTOMLEFT", 0, -4)
    hint:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -8, -44)
    hint:SetJustifyH("LEFT")
    hint:SetWordWrap(false)
    hint:SetText("Use KwaMarker, or type a name above. Top promotes it into KwaTarget.")

    scroll, content = Util.CreateScrollPanel(panel, { top = 60 })

    emptyLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    emptyLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 2, -68)
    emptyLabel:SetWidth(240)
    emptyLabel:SetJustifyH("LEFT")
    emptyLabel:SetText("No mobs tracked yet. Use the KwaMarker macro while targeting a mob.")
    emptyLabel:Hide()

    panel:SetScript("OnShow", function()
        RefreshMacroState()
        Refresh()
        RefreshMinimized()
    end)

    RebuildMacroState()
    Refresh()
    return panel
end

-- Events -----------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED" }) do
    pcall(eventFrame.RegisterEvent, eventFrame, event)
end

eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_ENABLED" then
        if pendingUpdate then RefreshMacroState() end
        if Refresh then Refresh() end
        if RefreshMinimized then RefreshMinimized() end
        return
    end

    EnsureDB()
    macrosReady = true
    RefreshMacroState()
    if Refresh then Refresh() end
    if RefreshMinimized then RefreshMinimized() end
end)

KwaLite:RegisterAddon({
    id = "KwaBookmarker",
    name = "Bookmarker",
    icon = PLUGIN_ICON,
    priority = 9,
    createPanel = CreatePanel,
    createMinimized = CreateMinimized,
    refresh = function()
        RefreshMacroState()
        Refresh()
        RefreshMinimized()
    end,
    refreshMinimized = function() RefreshMinimized() end,
    showMinimizedByDefault = false,
})
