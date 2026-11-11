
ForeverAurasSaved = {
["totemSpells"] = {
},
["editor_tab_spaces"] = 4,
["login_squelch_time"] = 10,
["minimap"] = {
["minimapPos"] = 11.70197318970864,
["hide"] = false,
},
["historyCutoff"] = 730,
["dbVersion"] = 91,
["editor_theme"] = "Monokai",
["dynamicIconCache"] = {
},
["editor_font_size"] = 12,
["lastArchiveClear"] = 1794062444,
["lastUpgrade"] = 1794062445,
["migrationCutoff"] = 730,
["features"] = {
},
["displays"] = {
["KwaKillCounter"] = {
["controlledChildren"] = {
"Display",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = 232.2937622070313,
["preferToUpdate"] = false,
["yOffset"] = 359.9508666992188,
["anchorPoint"] = "CENTER",
["borderColor"] = {
0,
0,
0,
1,
},
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["names"] = {
},
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
},
["internalVersion"] = 91,
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["load"] = {
["size"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["talent"] = {
["multi"] = {
},
},
},
["backdropColor"] = {
1,
1,
1,
0.5,
},
["scale"] = 1,
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 2,
["borderOffset"] = 4,
["groupIcon"] = 236489,
["tocversion"] = 11508,
["id"] = "KwaKillCounter",
["animation"] = {
["start"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["uid"] = "GHDyFhoYg(5",
["borderInset"] = 1,
["config"] = {
},
["authorOptions"] = {
},
["conditions"] = {
},
["information"] = {
},
["frameStrata"] = 1,
},
["Display"] = {
["outline"] = "None",
["authorOptions"] = {
},
["displayText"] = "%c",
["customText"] = "-- [[ CONSOLIDATED WEAKAURA FUNCTION ]]\n-- Copy the ENTIRE block below (from 'function()' to the last 'end') \n-- into the \"Custom Function\" text box in your WeakAura.\n\nfunction()\n    -- [[ CONFIGURATION ]]\n    -- Set these to true or false to show/hide specific lines in the WeakAura\n    local SHOW_KILLS = true\n    local SHOW_AVG_VENDOR = true\n    local SHOW_AVG_AH = true\n    local SHOW_KILLS_TO_LEVEL = true\n    \n    if WeakAuras.IsOptionsOpen() then \n        return \"Kills: 666\\nAvg Vendor: 1s 20c\\nAvg AH: 2s 50c\\nTo Level: 42\" \n    end\n    \n    local guid = UnitGUID(\"target\")\n    if not guid then return \"\" end\n    \n    local unitType, _, _, _, _, npcID = strsplit(\"-\", guid)\n    if not (unitType == \"Creature\" or unitType == \"Vehicle\") or not npcID then return \"\" end\n    \n    local data = MyKillCountTable and MyKillCountTable[npcID]\n    if not data then return \"\" end\n    \n    local lines = {}\n    \n    -- 1. Kills Count\n    if SHOW_KILLS then\n        local count = data.count or 0\n        table.insert(lines, string.format(\"Kills: %d\", count))\n    end\n    \n    -- 2. Average Vendor Value\n    if SHOW_AVG_VENDOR and data.avgLootValue and data.avgLootValue > 0 then\n        table.insert(lines, \"Avg Vendor: \" .. GetCoinTextureString(math.floor(data.avgLootValue)))\n    end\n    \n    -- 3. Average Auction Value\n    if SHOW_AVG_AH and GetDynamicAuctionValue then\n        local val = GetDynamicAuctionValue(npcID)\n        if val and val > 0 then\n            table.insert(lines, \"Avg AH: \" .. GetCoinTextureString(math.floor(val)))\n        end\n    end\n    \n    -- 4. Kills to Level\n    if SHOW_KILLS_TO_LEVEL and data.xp and data.xp > 0 then\n        local currentXP = UnitXP(\"player\")\n        local maxXP = UnitXPMax(\"player\")\n        local xpNeeded = maxXP - currentXP\n        if xpNeeded > 0 then\n            local killsToLevel = math.ceil(xpNeeded / data.xp)\n            table.insert(lines, \"To Level: \" .. killsToLevel)\n        end\n    end\n    \n    return table.concat(lines, \"\\n\")\nend",
["shadowYOffset"] = -1,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_hostility"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Unit Characteristics",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["unit"] = "target",
["use_unit"] = true,
["names"] = {
},
["use_attackable"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["displayText_format_p_time_legacy_floor"] = false,
["animation"] = {
["start"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["displayText_format_c2_format"] = "none",
["font"] = "Friz Quadrata TT",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["size"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["talent"] = {
["multi"] = {
},
},
},
["fontSize"] = 11,
["internalVersion"] = 91,
["shadowXOffset"] = 1,
["parent"] = "KwaKillCounter",
["selfPoint"] = "BOTTOM",
["fixedWidth"] = 200,
["regionType"] = "text",
["displayText_format_c1_format"] = "none",
["xOffset"] = 350.2227783203125,
["displayText_format_c_format"] = "none",
["uid"] = "0WKqWyl9JfD",
["displayText_format_p_time_precision"] = 1,
["displayText_format_c3_format"] = "none",
["alpha"] = 1,
["wordWrap"] = "WordWrap",
["justify"] = "LEFT",
["tocversion"] = 11508,
["id"] = "Display",
["displayText_format_p_time_mod_rate"] = true,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["color"] = {
1,
1,
1,
1,
},
["config"] = {
},
["displayText_format_p_time_dynamic_threshold"] = 60,
["yOffset"] = -559.11083984375,
["shadowColor"] = {
0,
0,
0,
1,
},
["conditions"] = {
},
["information"] = {
},
["preferToUpdate"] = false,
},
},
["totemNames"] = {
},
["registered"] = {
},
}
