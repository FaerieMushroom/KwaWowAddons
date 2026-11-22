local addonName, KwaLite = ...

-- Shared helpers for Kwa plugins.
--
-- Everything here is deliberately client-agnostic: optional APIs are probed at
-- call time and every potentially missing global is guarded. Keep the hot paths
-- allocation-light; these functions run inside list rendering loops.

local Util = KwaLite.Util or {}
KwaLite.Util = Util

Util.DEFAULT_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

-- Run fn(...) and swallow errors. Returns the first result, or nil.
function Util.SafeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if ok then return result end
    return nil
end

-- 0 is truthy in Lua and numeric-string icon IDs show up on some clients.
-- Normalize both to nil so callers can fall through to another source.
function Util.NormalizeIcon(icon)
    if type(icon) == "number" then
        if icon > 0 then return icon end
        return nil
    end
    if type(icon) == "string" and icon ~= "" then
        local numeric = icon:match("^%d+$")
        if numeric then
            local id = tonumber(numeric)
            if id and id > 0 then return id end
            return nil
        end
        return icon
    end
    return nil
end

function Util.GetItemInfoAPI()
    if C_Item and C_Item.GetItemInfo then return C_Item.GetItemInfo end
    return _G.GetItemInfo
end

function Util.GetItemInfoInstantAPI()
    if C_Item and C_Item.GetItemInfoInstant then return C_Item.GetItemInfoInstant end
    return _G.GetItemInfoInstant
end

function Util.RequestItemData(itemID)
    if type(itemID) ~= "number" then return end
    local request = C_Item and (C_Item.RequestLoadItemDataByID or C_Item.RequestLoadItemData)
    if type(request) == "function" then
        pcall(request, itemID)
        return
    end
    if type(_G.RequestLoadItemDataByID) == "function" then
        pcall(_G.RequestLoadItemDataByID, itemID)
    end
end

-- Resolve an item icon from whichever API this client exposes.
function Util.GetItemIcon(itemID)
    local normalize = Util.NormalizeIcon

    local getIconByID = C_Item and C_Item.GetItemIconByID
    if type(getIconByID) == "function" then
        local ok, icon = pcall(getIconByID, itemID)
        if ok and normalize(icon) then return normalize(icon) end
    end

    if type(_G.GetItemIcon) == "function" then
        local ok, icon = pcall(_G.GetItemIcon, itemID)
        if ok and normalize(icon) then return normalize(icon) end
    end

    local instant = Util.GetItemInfoInstantAPI()
    if instant then
        -- GetItemInfoInstant: itemID, itemType, itemSubType, itemEquipLoc,
        -- icon, classID, subclassID.
        local ok, _, _, _, _, icon = pcall(instant, itemID)
        if ok and normalize(icon) then return normalize(icon) end
    end
    return nil
end

-- Fill in (or refresh) item metadata in place. Cheap to call repeatedly: each
-- field is only queried while missing. Returns meta.
function Util.UpdateItemMeta(itemID, meta)
    meta = meta or {}

    if not meta.name then
        local getInfo = Util.GetItemInfoAPI()
        if type(getInfo) == "function" then
            local ok, name, link, quality, _, _, class, subclass, _,
                _, texture, _, classID, subclassID = pcall(getInfo, itemID)
            if ok and name then
                meta.name = name
                meta.nameLower = name:lower()
                meta.link = link or meta.link
                if quality ~= nil then meta.quality = quality end
                meta.icon = Util.NormalizeIcon(texture) or meta.icon
                if class then meta.class = class end
                if classID then meta.classID = classID end
                if subclass then meta.subclass = subclass end
                if subclassID then meta.subclassID = subclassID end
            end
        end
    end

    if not meta.classID then
        local instant = Util.GetItemInfoInstantAPI()
        if type(instant) == "function" then
            local ok, _, itemType, itemSubType, _, icon, classID, subclassID =
                pcall(instant, itemID)
            if ok then
                meta.class = meta.class or itemType
                meta.subclass = meta.subclass or itemSubType
                meta.classID = meta.classID or classID
                meta.subclassID = meta.subclassID or subclassID
                meta.icon = meta.icon or Util.NormalizeIcon(icon)
            end
        end
    end

    if not meta.icon then
        meta.icon = Util.GetItemIcon(itemID)
    end

    -- Last resort: the item link still contains the display name.
    if not meta.name and type(meta.link) == "string" then
        local name = meta.link:match("%[(.-)%]")
        if name and name ~= "" then
            meta.name = name
            meta.nameLower = name:lower()
        end
    end

    return meta
end

local function CoinTextureString(copper)
    local api = (C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString)
        or _G.GetCoinTextureString
    if type(api) == "function" then
        local ok, text = pcall(api, copper)
        if ok and text then return text end
    end
    return nil
end

-- Format copper as a coin string, preferring the client's texture markup.
function Util.FormatMoney(copper)
    copper = math.floor(tonumber(copper) or 0)

    local text = CoinTextureString(copper)
    if text then return text end

    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100
    local parts = {}
    if gold > 0 then parts[#parts + 1] = gold .. "g" end
    if silver > 0 then parts[#parts + 1] = silver .. "s" end
    if cop > 0 or #parts == 0 then parts[#parts + 1] = cop .. "c" end
    return table.concat(parts, " ")
end

-- Wrap an item name in its quality color when the client provides one.
function Util.ColorName(name, quality)
    local qualityColor = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality or 1]
    local color = qualityColor and qualityColor.color
    if color and color.WrapTextInColorCode then
        local ok, text = pcall(color.WrapTextInColorCode, color, name)
        if ok and text then return text end
    end
    return name
end

-- Create a standard plugin scroll frame plus its scroll child.
--
-- options:
--   top           pixels below the panel top (default 0)
--   bottom        pixels above the panel bottom (default 0)
--   barInset      vertical inset of the scrollbar (default 14)
--   contentWidth  initial scroll-child width (default 200; refreshed by callers)
function Util.CreateScrollPanel(panel, options)
    options = options or {}
    local top = options.top or 0
    local bottom = options.bottom or 0
    local barInset = options.barInset or 14
    local contentWidth = options.contentWidth or 200

    local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -top)
    scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -2, bottom)

    -- Move the scrollbar inward so it does not overlap content.
    if scroll.ScrollBar then
        scroll.ScrollBar:ClearAllPoints()
        scroll.ScrollBar:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", -2, -barInset)
        scroll.ScrollBar:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", -2, barInset)
    end

    local content = CreateFrame("Frame", nil, scroll)
    content:SetWidth(contentWidth)
    content:SetHeight(1)
    scroll:SetScrollChild(content)

    return scroll, content
end

-- Keep a scroll child as wide as its scroll frame minus scrollbar padding.
function Util.FitContentWidth(scroll, content, panel, padding, fallbackWidth)
    if not scroll or not content then return nil end
    local width = scroll:GetWidth() or 0
    if width < 50 then
        width = (panel and panel:GetWidth()) or fallbackWidth or 220
    end
    width = width - (padding or 24)
    if width < 100 then width = 100 end
    content:SetWidth(width)
    return width
end

-- Show the native item tooltip on owner. Returns true when the client rendered
-- a real item tooltip. Callers add their own extra lines afterwards.
function Util.ShowItemTooltip(owner, itemID, link)
    if not (GameTooltip and owner) then return false end

    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()

    local shown = false
    if type(link) == "string" and link ~= "" then
        shown = pcall(GameTooltip.SetHyperlink, GameTooltip, link)
    end
    if not shown and type(itemID) == "number"
        and type(GameTooltip.SetItemByID) == "function" then
        shown = pcall(GameTooltip.SetItemByID, GameTooltip, itemID)
    end
    if not shown and type(itemID) == "number" then
        shown = pcall(GameTooltip.SetHyperlink, GameTooltip, "item:" .. itemID)
    end
    return shown and true or false
end

function Util.HideTooltip()
    if GameTooltip then GameTooltip:Hide() end
end

-- A hover-highlight BACKGROUND texture attached to a row, hidden until
-- OnEnter. Returns the texture for extra tweaks.
function Util.AddRowHoverBackground(row, alpha, r, g, b)
    local background = row:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(r or 1, g or 1, b or 1, alpha or 0.06)
    background:Hide()
    row.background = background
    return background
end

-- Attach the standard OnEnter/OnLeave hover scripts to a frame that has a
-- background attached (usually via AddRowHoverBackground).
function Util.SetHoverScripts(frame)
    frame:SetScript("OnEnter", function(self)
        if self.background then self.background:Show() end
    end)
    frame:SetScript("OnLeave", function(self)
        if self.background then self.background:Hide() end
    end)
end

-- Create a hover-highlight BACKGROUND and scripts on one call.
function Util.SetHoverBackground(frame, alpha)
    Util.AddRowHoverBackground(frame, alpha)
    Util.SetHoverScripts(frame)
    return frame.background
end

-- A reusable list row: Button frame, highlight, icon and name label.
--
-- options:
--   height        default 28
--   iconSize      default 20
--   highlightAlpha default 0.06
--   nameRightOffset pixels from the row's right edge (default 0)
--   iconLeft      left inset of the icon (default 1)
--
-- Returns a Button with .highlight, .icon, .name. Callers add value
-- columns/scripts as needed.
function Util.CreateItemRow(parent, options)
    options = options or {}
    local height = options.height or 28
    local iconSize = options.iconSize or 20

    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(height)

    local highlight = row:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetColorTexture(1, 1, 1, options.highlightAlpha or 0.06)
    row.highlight = highlight
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(iconSize, iconSize)
    row.icon:SetPoint("LEFT", row, "LEFT", options.iconLeft or 1, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.icon:SetAlpha(1)

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
    row.name:SetPoint("RIGHT", row, "RIGHT", options.nameRightOffset or 0, 0)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)

    return row
end

-- A backdropped search field with placeholder text.
--
-- options:
--   maxLetters   default 60
--   placeholder  default "Search items..."
--   onChanged    called with (text, userInput) on every edit
--   onEnter      called when Enter is pressed (focus is cleared first)
--   height       default 22
--
-- Returns frame, editBox, placeholderFontString, updatePlaceholder.
function Util.CreateSearchBox(parent, options)
    options = options or {}

    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    frame:SetHeight(options.height or 22)
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(0.07, 0.07, 0.09, 0.95)
    frame:SetBackdropBorderColor(0.24, 0.24, 0.3, 1)

    local box = CreateFrame("EditBox", nil, frame)
    box:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -1)
    box:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 1)
    box:SetAutoFocus(false)
    box:SetMaxLetters(options.maxLetters or 60)
    local fontObject = _G.ChatFontNormal or _G.GameFontNormal
    if fontObject then
        box:SetFontObject(fontObject)
    end
    box:SetTextInsets(0, 0, 0, 0)

    local placeholder = frame:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    placeholder:SetPoint("LEFT", frame, "LEFT", 7, 0)
    placeholder:SetText(options.placeholder or "Search items...")

    local function updatePlaceholder()
        if (box:GetText() or "") == "" then
            placeholder:Show()
        else
            placeholder:Hide()
        end
    end

    box:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    box:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
        if options.onEnter then options.onEnter() end
    end)
    box:SetScript("OnTextChanged", function(self, userInput)
        updatePlaceholder()
        if options.onChanged then options.onChanged(self:GetText() or "", userInput) end
    end)
    box:SetScript("OnEditFocusGained", updatePlaceholder)
    box:SetScript("OnEditFocusLost", updatePlaceholder)

    updatePlaceholder()
    return frame, box, placeholder, updatePlaceholder
end

-- Parses a money string such as "1g 50s 25c" into copper. A plain number is
-- treated as copper. Returns nil when the text is not money.
function Util.ParseMoney(text)
    if type(text) == "number" then return text end
    if type(text) ~= "string" then return nil end

    text = text:lower():gsub("%s+", "")
    if text == "" then return nil end

    local copper = 0
    local matched = false
    for amount, unit in text:gmatch("(%d+%.?%d*)([gsc])") do
        local value = tonumber(amount)
        if value then
            if unit == "g" then
                value = value * 10000
            elseif unit == "s" then
                value = value * 100
            end
            copper = copper + value
            matched = true
        end
    end

    if matched then return math.floor(copper + 0.5) end

    local value = tonumber(text)
    if value then return math.floor(value + 0.5) end
    return nil
end

-- Parses a filter query into free-text terms plus min/max numeric bounds.
--
-- spec:
--   fields  array of field specs: {
--             token   token prefix, e.g. "kills" for "kills>5"
--             minKey  parsed key for the lower bound (default token .. "Min")
--             maxKey  parsed key for the upper bound (default token .. "Max")
--             value   key to read in Util.MatchesFilter values (default token)
--             parse   optional function(raw) -> number (default tonumber)
--             step    integer step for > and < (default 1)
--           }
--   aliases map of alias (without @) -> value, applied as an exact match
--   aliasField field spec used for aliases
--   flags   map of literal token -> parsed key set to true
--
-- The result stores `fields` (a reference to spec.fields) and `terms` so
-- Util.MatchesFilter can evaluate it without allocating.
function Util.ParseFilterQuery(text, spec)
    spec = spec or {}
    local parsed = { terms = {}, fields = spec.fields }
    text = (text or ""):lower()

    local function raiseMin(key, value)
        if not parsed[key] or value > parsed[key] then parsed[key] = value end
    end
    local function lowerMax(key, value)
        if not parsed[key] or value < parsed[key] then parsed[key] = value end
    end

    local function apply(field, op, raw)
        local value = field.parse and field.parse(raw) or tonumber(raw)
        if not value then return end

        local minKey = field.minKey or (field.token .. "Min")
        local maxKey = field.maxKey or (field.token .. "Max")
        if op == "=" then
            raiseMin(minKey, value)
            lowerMax(maxKey, value)
        elseif op == ">" then
            raiseMin(minKey, value + (field.step or 1))
        elseif op == ">=" then
            raiseMin(minKey, value)
        elseif op == "<" then
            lowerMax(maxKey, value - (field.step or 1))
        elseif op == "<=" then
            lowerMax(maxKey, value)
        end
    end

    for token in text:gmatch("%S+") do
        local flagKey = spec.flags and spec.flags[token]
        local alias = token:match("^@(%a+)$")
        local field, op, value

        if flagKey then
            parsed[flagKey] = true
        elseif alias and spec.aliases and spec.aliasField and spec.aliases[alias] ~= nil then
            apply(spec.aliasField, "=", spec.aliases[alias])
        else
            if spec.fields then
                for index = 1, #spec.fields do
                    local candidate = spec.fields[index]
                    local candidateOp, candidateValue = token:match("^" .. candidate.token .. "([<>=]+)(%S+)$")
                    if candidateOp then
                        field, op, value = candidate, candidateOp, candidateValue
                        break
                    end
                end
            end

            if field then
                apply(field, op, value)
            else
                parsed.terms[#parsed.terms + 1] = token
            end
        end
    end

    return parsed
end

-- Evaluates a parsed filter query against a values table. Keys come from each
-- field's `value` (or `token`). `values.nameLower` is matched against terms.
function Util.MatchesFilter(parsed, values)
    local fields = parsed.fields
    if fields then
        for index = 1, #fields do
            local field = fields[index]
            local value = values[field.value or field.token] or 0
            local min = parsed[field.minKey or (field.token .. "Min")]
            if min and value < min then return false end
            local max = parsed[field.maxKey or (field.token .. "Max")]
            if max and value > max then return false end
        end
    end

    local terms = parsed.terms
    if terms and #terms > 0 then
        local name = values.nameLower or ""
        for index = 1, #terms do
            if not name:find(terms[index], 1, true) then return false end
        end
    end

    return true
end

-- Pool of sequential list rows. Get(index) creates on demand; Trim(count)
-- hides everything above count. `pool.rows` remains available for direct
-- indexing and `pool.count` is the number of visible rows.
function Util.CreateRowPool(createRow)
    local pool = { rows = {}, count = 0 }

    function pool:Get(index)
        local row = self.rows[index]
        if not row then
            row = createRow(index)
            self.rows[index] = row
        end
        if index > self.count then self.count = index end
        return row
    end

    function pool:Trim(count, onHide)
        if count < 0 then count = 0 end
        for index = count + 1, self.count do
            local row = self.rows[index]
            if row then
                if onHide then onHide(row, index) end
                row:Hide()
            end
        end
        if count < self.count then self.count = count end
    end

    function pool:HideAll(onHide)
        self:Trim(0, onHide)
    end

    return pool
end

return Util
