local addonName, KP = ...

-- Profiler: reports Lua CPU time per KwaLite plugin and for the main KwaLite
-- window. WoW has no per-addon CPU counter, so this instruments the callbacks
-- and frame scripts that belong to Kwa addons. Numbers are Lua milliseconds,
-- not total frame time (engine/render work is not included).
--
-- The plugin is disabled by default. Once enabled it collects while the
-- KwaLite window is shown and not minimized, and the page refreshes every
-- 5 seconds. Instrumentation only adds a few debugprofilestop calls per
-- callback while active.

if not (KwaLite and KwaLite.RegisterAddon and KwaLite.GetAddons) then
    return
end

local ADDON_ID = "KwaProfiler"
local KWALITE_OWNER = "KwaLite"

local SAMPLE_SECONDS = 5
local WINDOW_SECONDS = 30
local BUCKET_SECONDS = 1
local ACTIVATION_CHECK = 0.5
local RESCAN_SECONDS = 30
local ROW_HEIGHT = 34

local panel
local scroll
local content
local headerLabel
local statusLabel
local resetButton
local rows = {}
local rowCount = 0

local active = false
local ownerMapBuilt = false
local nextActivationCheck = 0
local nextRender = 0
local nextRescan = 0
local sessionFrames = 0
local session = {}
local buckets = {}
local currentBucket
local stack = {}
local stackDepth = 0
local wrapState = setmetatable({}, { __mode = "k" })
local fileOwners = {}
local folderOwners = {}

local function Now()
    if type(GetTime) == "function" then return GetTime() end
    return 0
end

-- debugprofilestop is millisecond-resolution wall time. Fall back to GetTime
-- on clients where the profiler API is unavailable.
local function ProfileNow()
    if type(debugprofilestop) == "function" then
        return debugprofilestop()
    end
    return Now() * 1000
end

local function EnsureBucket()
    local now = Now()
    if not currentBucket then
        currentBucket = { start = now, frames = 0, owners = {} }
        buckets[#buckets + 1] = currentBucket
    elseif now - currentBucket.start >= BUCKET_SECONDS then
        currentBucket = { start = now, frames = 0, owners = {} }
        buckets[#buckets + 1] = currentBucket
    end
    return currentBucket
end

local function AddTime(owner, elapsed)
    local bucket = currentBucket
    if bucket then
        local data = bucket.owners[owner]
        if not data then
            data = { ms = 0, calls = 0, max = 0 }
            bucket.owners[owner] = data
        end
        data.ms = data.ms + elapsed
        data.calls = data.calls + 1
        if elapsed > data.max then data.max = elapsed end
    end

    local total = session[owner]
    if not total then
        total = { ms = 0, calls = 0, max = 0 }
        session[owner] = total
    end
    total.ms = total.ms + elapsed
    total.calls = total.calls + 1
    if elapsed > total.max then total.max = elapsed end
end

local function MakeWrapper(fn, owner)
    return function(...)
        if not active then return fn(...) end

        local depth = stackDepth + 1
        stackDepth = depth
        local entry = stack[depth]
        if not entry then
            entry = {}
            stack[depth] = entry
        end
        entry.owner = owner
        entry.start = ProfileNow()
        entry.child = 0

        -- pcall keeps the timing stack balanced if a plugin callback errors.
        local ok, a, b, c = pcall(fn, ...)

        local elapsed = ProfileNow() - entry.start
        stackDepth = depth - 1

        local own = elapsed - entry.child
        if own < 0 then own = 0 end
        AddTime(entry.owner, own)

        if depth > 1 then
            local parent = stack[depth - 1]
            parent.child = parent.child + elapsed
        end

        if not ok then error(a, 0) end
        return a, b, c
    end
end

local function NormalizeSource(fn)
    if type(debug) ~= "table" or type(debug.getinfo) ~= "function" then return nil end
    local ok, info = pcall(debug.getinfo, fn, "S")
    if not ok or type(info) ~= "table" then return nil end

    local source = info.short_src or info.source or ""
    source = source:gsub("\\", "/"):gsub("^@", ""):lower()
    local folder, file = source:match("interface/addons/([^/]+)/(.+)$")
    return folder, file
end

local function RegisterOwnerFunction(fn, owner)
    local folder, file = NormalizeSource(fn)
    if not folder then return end

    fileOwners[folder .. "/" .. file] = owner
    local existing = folderOwners[folder]
    if existing == nil then
        folderOwners[folder] = owner
    elseif existing ~= owner then
        folderOwners[folder] = false
    end
end

local function OwnerForFunction(fn)
    local folder, file = NormalizeSource(fn)
    if not folder then return nil end

    local owner = fileOwners[folder .. "/" .. file]
    if owner then return owner end
    owner = folderOwners[folder]
    if owner then return owner end
    return nil
end

local function BuildOwnerMap()
    if ownerMapBuilt then return end
    ownerMapBuilt = true

    folderOwners = {
        kwalite = KWALITE_OWNER,
        kwaprofiler = ADDON_ID,
    }

    local callbackKeys = { "createPanel", "createMinimized", "refresh", "refreshMinimized", "createSettings" }
    for _, addon in ipairs(KwaLite:GetAddons()) do
        if addon.id ~= ADDON_ID then
            for _, key in ipairs(callbackKeys) do
                local fn = addon[key]
                if type(fn) == "function" then
                    RegisterOwnerFunction(fn, addon.id)
                end
            end
        end
    end
end

local function WrapAddonCallbacks()
    for _, addon in ipairs(KwaLite:GetAddons()) do
        if addon.id ~= ADDON_ID and not addon.__kwaProfilerWrapped then
            for _, key in ipairs({ "refresh", "refreshMinimized" }) do
                local fn = addon[key]
                if type(fn) == "function" then
                    addon[key] = MakeWrapper(fn, addon.id)
                end
            end
            addon.__kwaProfilerWrapped = true
        end
    end
end

local KWALITE_METHODS = {
    "RefreshCurrent",
    "RefreshMinimized",
    "SelectAddon",
    "SetMinimized",
    "Show",
    "Hide",
    "Toggle",
}

local function InstallKwaLiteHooks()
    for _, name in ipairs(KWALITE_METHODS) do
        local flag = "__kwaProfiler_" .. name
        local fn = KwaLite[name]
        if type(fn) == "function" and not KwaLite[flag] then
            KwaLite[name] = MakeWrapper(fn, KWALITE_OWNER)
            KwaLite[flag] = true
        end
    end
end

local SCRIPT_TYPES = { "OnUpdate", "OnEvent", "OnShow", "OnHide" }

local function WrapFrame(frame)
    local okForbidden, forbidden = pcall(frame.IsForbidden, frame)
    if okForbidden and forbidden then return end

    local state = wrapState[frame]
    if not state then
        state = {}
        wrapState[frame] = state
    end

    for _, scriptType in ipairs(SCRIPT_TYPES) do
        local ok, current = pcall(frame.GetScript, frame, scriptType)
        if ok and type(current) == "function" then
            local tracked = state[scriptType]
            if not (tracked and tracked.wrapper == current) then
                local owner = OwnerForFunction(current)
                if owner and owner ~= ADDON_ID then
                    local wrapper = MakeWrapper(current, owner)
                    if pcall(frame.SetScript, frame, scriptType, wrapper) then
                        state[scriptType] = { wrapper = wrapper, original = current }
                    end
                end
            end
        end
    end
end

local ScanFrames

local function StartProfiling()
    if active then return end

    BuildOwnerMap()
    InstallKwaLiteHooks()
    WrapAddonCallbacks()

    active = true
    stackDepth = 0
    buckets = {}
    currentBucket = { start = Now(), frames = 0, owners = {} }
    buckets[1] = currentBucket
    nextRender = Now() + SAMPLE_SECONDS
    nextRescan = Now() + RESCAN_SECONDS

    ScanFrames()
end

local function StopProfiling()
    active = false
    stackDepth = 0
end

local function ShouldProfile()
    if not (KwaLite.IsAddonEnabled and KwaLite:IsAddonEnabled(ADDON_ID)) then
        return false
    end
    if KwaLite.IsMinimized and KwaLite:IsMinimized() then
        return false
    end

    local frame = _G.KwaLiteFrame
    return frame ~= nil and frame:IsShown() and true or false
end

local function GetOwnerLabel(owner)
    if owner == KWALITE_OWNER then return "KwaLite window" end
    local addon = KwaLite.GetAddon and KwaLite:GetAddon(owner)
    return addon and addon.name or owner
end

local function BuildSnapshot()
    local now = Now()
    while buckets[1] and now - buckets[1].start >= WINDOW_SECONDS do
        table.remove(buckets, 1)
    end

    local aggregate = {}
    local frames = 0
    for _, bucket in ipairs(buckets) do
        frames = frames + bucket.frames
        for owner, data in pairs(bucket.owners) do
            local total = aggregate[owner]
            if not total then
                total = { ms = 0, calls = 0, max = 0 }
                aggregate[owner] = total
            end
            total.ms = total.ms + data.ms
            total.calls = total.calls + data.calls
            if data.max > total.max then total.max = data.max end
        end
    end
    if frames < 1 then frames = 1 end

    local list = {}
    local seen = {}
    local function AddOwner(owner)
        if seen[owner] then return end
        seen[owner] = true

        local data = aggregate[owner]
        local total = session[owner]
        list[#list + 1] = {
            owner = owner,
            label = GetOwnerLabel(owner),
            msPerFrame = (data and data.ms or 0) / frames,
            ms = data and data.ms or 0,
            calls = data and data.calls or 0,
            max = data and data.max or 0,
            sessionMs = total and total.ms or 0,
            sessionCalls = total and total.calls or 0,
            sessionMsPerFrame = total and (total.ms / math.max(sessionFrames, 1)) or 0,
        }
    end

    for owner in pairs(aggregate) do
        AddOwner(owner)
    end
    AddOwner(KWALITE_OWNER)
    for _, addon in ipairs(KwaLite:GetAddons()) do
        if addon.id ~= ADDON_ID then
            AddOwner(addon.id)
        end
    end

    table.sort(list, function(a, b)
        if a.msPerFrame ~= b.msPerFrame then
            return a.msPerFrame > b.msPerFrame
        end
        return a.label < b.label
    end)

    return list, frames
end

local function ValueColor(msPerFrame)
    if msPerFrame >= 1 then
        return 1, 0.35, 0.35
    elseif msPerFrame >= 0.25 then
        return 1, 0.82, 0.2
    elseif msPerFrame > 0 then
        return 0.55, 0.9, 0.55
    end
    return 0.55, 0.55, 0.55
end

local function CreateRow(index)
    local row = CreateFrame("Frame", nil, content)
    row:SetHeight(ROW_HEIGHT)

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.name:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -1)
    row.name:SetPoint("RIGHT", row, "RIGHT", -92, -1)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)

    row.value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.value:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, -1)
    row.value:SetWidth(92)
    row.value:SetJustifyH("RIGHT")

    row.detail = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.detail:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -17)
    row.detail:SetPoint("RIGHT", row, "RIGHT", 0, -17)
    row.detail:SetJustifyH("LEFT")
    row.detail:SetWordWrap(false)

    rows[index] = row
    return row
end

local function GetRow(index)
    return rows[index] or CreateRow(index)
end

local function Render()
    if not content or not scroll then return end

    local list, frames = BuildSnapshot()
    local width = scroll:GetWidth() or 0
    if width < 50 then width = (panel and panel:GetWidth()) or 220 end
    content:SetWidth(math.max(100, width - 26))

    local y = 0
    for index = 1, #list do
        local entry = list[index]
        local row = GetRow(index)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -y)

        row.name:SetText(entry.label)
        if KwaLite.IsAddonEnabled and entry.owner ~= KWALITE_OWNER
            and not KwaLite:IsAddonEnabled(entry.owner) then
            row.name:SetTextColor(0.5, 0.5, 0.5)
        else
            row.name:SetTextColor(1, 1, 1)
        end

        if entry.calls > 0 then
            row.value:SetFormattedText("%.3f ms/f", entry.msPerFrame)
        else
            row.value:SetText("0.000 ms/f")
        end
        row.value:SetTextColor(ValueColor(entry.msPerFrame))

        if entry.calls > 0 then
            row.detail:SetFormattedText(
                "%.2f ms total  ·  %d calls  ·  max %.2f ms  ·  session %.2f ms",
                entry.ms, entry.calls, entry.max, entry.sessionMs)
        else
            row.detail:SetText("no activity in the last " .. WINDOW_SECONDS .. "s")
        end
        row:Show()
        y = y + ROW_HEIGHT
    end

    for index = #list + 1, rowCount do
        rows[index]:Hide()
    end
    rowCount = #list

    content:SetHeight(math.max(y, 1))

    if active then
        statusLabel:SetFormattedText(
            "|cff9d9d9d%.1fs window  ·  %d frames  ·  refreshes every %ds|r",
            WINDOW_SECONDS, frames, SAMPLE_SECONDS)
    else
        statusLabel:SetText("|cff9d9d9dPaused (window minimized, hidden, or plugin disabled)|r")
    end
end

ScanFrames = function()
    if type(EnumerateFrames) ~= "function" then return end
    local ok, frame = pcall(EnumerateFrames)
    if not ok then return end

    while frame do
        WrapFrame(frame)
        local okNext, nextFrame = pcall(EnumerateFrames, frame)
        if not okNext then break end
        frame = nextFrame
    end
end

local function CreatePanel(parent)
    if panel then return panel end

    panel = CreateFrame("Frame", nil, parent)

    headerLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    headerLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, -1)
    headerLabel:SetPoint("RIGHT", panel, "RIGHT", -60, -1)
    headerLabel:SetJustifyH("LEFT")
    headerLabel:SetText("Lua CPU time per frame")

    resetButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    resetButton:SetSize(52, 18)
    resetButton:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -4, 0)
    resetButton:SetText("Reset")
    resetButton:SetScript("OnClick", function()
        session = {}
        sessionFrames = 0
        buckets = {}
        currentBucket = { start = Now(), frames = 0, owners = {} }
        buckets[1] = currentBucket
        nextRender = Now() + SAMPLE_SECONDS
        Render()
    end)
    resetButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Reset profiler data", 1, 0.82, 0)
        GameTooltip:AddLine("Clears the rolling window and session totals.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    resetButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    statusLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    statusLabel:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, -19)
    statusLabel:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -1, -19)
    statusLabel:SetJustifyH("LEFT")

    scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -37)
    scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -2, 0)
    if scroll.ScrollBar then
        scroll.ScrollBar:ClearAllPoints()
        scroll.ScrollBar:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", -2, -14)
        scroll.ScrollBar:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", -2, 14)
    end

    content = CreateFrame("Frame", nil, scroll)
    content:SetWidth(200)
    content:SetHeight(1)
    scroll:SetScrollChild(content)

    panel:SetScript("OnShow", function()
        Render()
        nextRender = Now() + SAMPLE_SECONDS
    end)
    panel:SetScript("OnHide", function()
        GameTooltip:Hide()
    end)

    return panel
end

local driver = CreateFrame("Frame")
driver:SetScript("OnUpdate", function()
    local now = Now()

    if active then
        local bucket = EnsureBucket()
        bucket.frames = bucket.frames + 1
        sessionFrames = sessionFrames + 1

        while buckets[1] and now - buckets[1].start >= WINDOW_SECONDS do
            table.remove(buckets, 1)
        end

        if now >= nextRescan then
            nextRescan = now + RESCAN_SECONDS
            ScanFrames()
        end

        if panel and panel:IsShown() and now >= nextRender then
            Render()
            nextRender = now + SAMPLE_SECONDS
        end
    end

    if now >= nextActivationCheck then
        nextActivationCheck = now + ACTIVATION_CHECK
        local shouldProfile = ShouldProfile()
        if shouldProfile and not active then
            StartProfiling()
        elseif not shouldProfile and active then
            StopProfiling()
        end
    end
end)

KwaLite:RegisterAddon({
    id = ADDON_ID,
    name = "Profiler",
    icon = "Interface\\Icons\\inv_professions_inscription_scribesmagnifyingglass_gold",
    priority = 7,
    enabledByDefault = false,
    createPanel = CreatePanel,
    refresh = function()
        Render()
        nextRender = Now() + SAMPLE_SECONDS
    end,
})
