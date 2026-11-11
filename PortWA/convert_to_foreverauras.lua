-- Convert a WeakAuras saved-variables file into ForeverAuras saved-variables
-- format. Best-effort: data is preserved, version fields are retargeted, and
-- ForeverAuras' own Modernize pass handles the 89 -> 91 display migrations.
--
-- Usage: lua5.1 convert_to_foreverauras.lua [input] [output]

local input = arg and arg[1] or "WeakAuras.lua"
local output = arg and arg[2] or "ForeverAurasConverted.lua"

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

local root = env.WeakAurasSaved
if type(root) ~= "table" then
    io.stderr:write("No WeakAurasSaved table found in " .. input .. "\n")
    os.exit(1)
end

-- ForeverAuras database version. Displays deliberately keep their old
-- internalVersion so ForeverAuras runs the 89 -> 90 -> 91 migrations.
root.dbVersion = 91
root.totemSpells = root.totemSpells or {}
root.totemNames = root.totemNames or {}
root.displays = root.displays or {}

local displayCount = 0
for _, data in pairs(root.displays) do
    if type(data) == "table" then
        data.tocversion = data.tocversion or 11508
        data.internalVersion = data.internalVersion or 89
        displayCount = displayCount + 1
    end
end

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

local serialize

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
        local out = { "{" }
        if array and n > 0 then
            for i = 1, n do
                out[#out + 1] = serialize(v[i]) .. ","
            end
        elseif not array then
            for _, k in ipairs(sortedKeys(v)) do
                local key
                if type(k) == "number" then
                    key = "[" .. string.format("%d", k) .. "]"
                else
                    key = "[" .. escapeString(tostring(k)) .. "]"
                end
                out[#out + 1] = key .. " = " .. serialize(v[k]) .. ","
            end
        end
        out[#out + 1] = "}"
        return table.concat(out, "\n")
    end
    return "nil"
end

local text = "\nForeverAurasSaved = " .. serialize(root) .. "\n"
text = text:gsub("\r\n", "\n"):gsub("\n", "\r\n")

local f, openErr = io.open(output, "wb")
if not f then
    io.stderr:write("Could not write " .. output .. ": " .. tostring(openErr) .. "\n")
    os.exit(1)
end
f:write(text)
f:close()

print(string.format("Wrote %s (%d displays, %.1f KB)", output, displayCount, #text / 1024))
