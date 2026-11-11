-- Convert Bartender4 classic saved variables into the Forever layout used by
-- Bartender4Forever.lua. Best-effort: positions/settings are preserved, the
-- active classic profile is remapped onto the Forever character profile, and
-- the new Forever namespaces (StatusTrackingBar, QueueStatus, ExtraActionBar)
-- are synthesised.
--
-- Usage: lua5.1 convert_bartender.lua [input] [output]

local input = arg and arg[1] or "Bartender4Classic.lua"
local output = arg and arg[2] or "Bartender4Converted.lua"

local FOREVER_PROFILE = "Fae Moidbane"
local ACTIVE_CLASSIC_PROFILE = "Faeprincess - Doomhowl"
local SECONDARY_CLASSIC_PROFILE = "Faeriemushie - Doomhowl"

local env = {}
local chunk, err = loadfile(input)
if not chunk then
    io.stderr:write("Could not load " .. input .. ": " .. tostring(err) .. "\n")
    os.exit(1)
end
setfenv(chunk, env)
local ok, runErr = pcall(chunk)
if not ok then
    io.stderr:write("Could not execute " .. input .. ": " .. tostring(runErr) .. "\n")
    os.exit(1)
end

local src = env.Bartender4DB
if type(src) ~= "table" then
    io.stderr:write("No Bartender4DB table found in " .. input .. "\n")
    os.exit(1)
end

local function deepcopy(v)
    if type(v) ~= "table" then return v end
    local out = {}
    for k, val in pairs(v) do out[k] = deepcopy(val) end
    return out
end

local function copy(t) return deepcopy(t or {}) end

local function nsProfile(ns, profile)
    local n = src.namespaces and src.namespaces[ns]
    return n and n.profiles and n.profiles[profile]
end

local out = {
    namespaces = {},
    profileKeys = {},
    profiles = {},
}

-- Old-name -> new-name mapping. The active classic profile becomes the
-- Forever character's profile; the other one is preserved for reference.
local profilesToConvert = {
    { old = ACTIVE_CLASSIC_PROFILE, new = FOREVER_PROFILE },
    { old = SECONDARY_CLASSIC_PROFILE, new = SECONDARY_CLASSIC_PROFILE },
}

for _, pair in ipairs(profilesToConvert) do
    local oldName, newName = pair.old, pair.new

    -- ActionBars: forever data carries WoW10Layout on every bar.
    local ab = copy(nsProfile("ActionBars", oldName))
    ab.actionbars = ab.actionbars or {}
    for i = 1, 15 do
        ab.actionbars[i] = ab.actionbars[i] or {}
        ab.actionbars[i].version = ab.actionbars[i].version or 3
        ab.actionbars[i].WoW10Layout = true
    end
    -- The Forever example uses left-flyout bars for the two vertical bars.
    ab.actionbars[3].flyoutDirection = ab.actionbars[3].flyoutDirection or "LEFT"
    ab.actionbars[4].flyoutDirection = ab.actionbars[4].flyoutDirection or "LEFT"
    out.namespaces.ActionBars = out.namespaces.ActionBars or { profiles = {} }
    out.namespaces.ActionBars.profiles[newName] = ab

    for _, ns in ipairs({ "MicroMenu", "BagBar", "Vehicle", "StanceBar", "PetBar" }) do
        out.namespaces[ns] = out.namespaces[ns] or { profiles = {} }
        out.namespaces[ns].profiles[newName] = copy(nsProfile(ns, oldName)) or {}
    end

    -- BlizzardArt in the Forever profile uses the modern artwork layout.
    local art = copy(nsProfile("BlizzardArt", oldName)) or {}
    art.artLayout = art.artLayout or "MODERNARTCLASSIC"
    out.namespaces.BlizzardArt = out.namespaces.BlizzardArt or { profiles = {} }
    out.namespaces.BlizzardArt.profiles[newName] = art

    -- XPBar + RepBar were merged into StatusTrackingBar in Forever.
    local xp = nsProfile("XPBar", oldName)
    local rep = nsProfile("RepBar", oldName)
    local status = {
        enabled = true,
        version = 3,
        position = copy((xp and xp.position) or (rep and rep.position)) or {
            y = 82, x = -601, point = "BOTTOM",
        },
    }
    out.namespaces.StatusTrackingBar = out.namespaces.StatusTrackingBar or { profiles = {} }
    out.namespaces.StatusTrackingBar.profiles[newName] = status

    -- New Forever-only namespaces with the example's defaults.
    out.namespaces.QueueStatus = out.namespaces.QueueStatus or { profiles = {} }
    out.namespaces.QueueStatus.profiles[newName] = {
        version = 3,
        position = { y = 100, x = 640, point = "BOTTOM" },
    }

    out.namespaces.ExtraActionBar = out.namespaces.ExtraActionBar or { profiles = {} }
    out.namespaces.ExtraActionBar.profiles[newName] = {
        version = 3,
        position = { y = -192.5000305175781, x = -63.49981689453125, point = "CENTER" },
    }

    -- Profile-level settings are global to the profile.
    local settings = copy(src.profiles and src.profiles[oldName]) or {}
    settings.minimapIcon = settings.minimapIcon or {}
    if settings.minimapIcon.minimapPos == nil then
        settings.minimapIcon.minimapPos = 26.10028205169727
    end
    out.profiles[newName] = settings
end

-- Character -> profile routing: live Forever character uses the converted
-- active layout; the secondary classic character keeps its old name.
out.profileKeys[FOREVER_PROFILE] = FOREVER_PROFILE
out.profileKeys[SECONDARY_CLASSIC_PROFILE] = FOREVER_PROFILE

-- Serializer, matching the saved-variables style of Bartender4Forever.lua.
local function escapeString(s)
    s = s:gsub("\\", "\\\\")
    s = s:gsub("\"", "\\\"")
    s = s:gsub("\r", "\\r")
    s = s:gsub("\n", "\\n")
    s = s:gsub("\t", "\\t")
    s = s:gsub("([%z\1-\31])", function(c)
        return string.format("\\%03d", string.byte(c))
    end)
    return '"' .. s .. '"'
end

local function isArray(t)
    local n = #t
    local count = 0
    for k in pairs(t) do
        count = count + 1
        if type(k) ~= "number" or k < 1 or k > n or k ~= math.floor(k) then
            return false, 0
        end
    end
    return count == n, n
end

local function sortedKeys(t)
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b)
        local ta, tb = type(a), type(b)
        if ta ~= tb then return ta < tb end
        if ta == "number" then return a < b end
        return tostring(a) < tostring(b)
    end)
    return keys
end

local serialize
serialize = function(v)
    local t = type(v)
    if t == "nil" then
        return "nil"
    elseif t == "boolean" then
        return v and "true" or "false"
    elseif t == "number" then
        if v ~= v then return "(0/0)" end
        if v == math.huge then return "(1/0)" end
        if v == -math.huge then return "(-1/0)" end
        if v == math.floor(v) and math.abs(v) < 2 ^ 53 then
            return string.format("%d", v)
        end
        return string.format("%.17g", v)
    elseif t == "string" then
        return escapeString(v)
    elseif t == "table" then
        local array, n = isArray(v)
        local lines = { "{" }
        if array and n > 0 then
            for i = 1, n do
                lines[#lines + 1] = serialize(v[i]) .. ","
            end
        elseif not array then
            for _, k in ipairs(sortedKeys(v)) do
                local key
                if type(k) == "number" then
                    key = "[" .. string.format("%d", k) .. "]"
                else
                    key = "[" .. escapeString(tostring(k)) .. "]"
                end
                lines[#lines + 1] = key .. " = " .. serialize(v[k]) .. ","
            end
        end
        lines[#lines + 1] = "}"
        return table.concat(lines, "\n")
    end
    return "nil"
end

local text = "\nBartender4DB = " .. serialize(out) .. "\n"
text = text:gsub("\r\n", "\n"):gsub("\n", "\r\n")

local f, openErr = io.open(output, "wb")
if not f then
    io.stderr:write("Could not write " .. output .. ": " .. tostring(openErr) .. "\n")
    os.exit(1)
end
f:write(text)
f:close()

print(string.format("Wrote %s (%d profiles, %.1f KB)", output, #profilesToConvert, #text / 1024))
