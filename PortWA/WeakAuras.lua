
WeakAurasSaved = {
["editor_tab_spaces"] = 4,
["login_squelch_time"] = 10,
["minimap"] = {
["minimapPos"] = 37.3546437082487,
["hide"] = false,
},
["historyCutoff"] = 730,
["dbVersion"] = 89,
["editor_theme"] = "Monokai",
["dynamicIconCache"] = {
},
["editor_font_size"] = 12,
["lastArchiveClear"] = 1777789797,
["lastUpgrade"] = 1777789797,
["personalRessourceDisplayFrame"] = {
["xOffset"] = -362.6470234555645,
["yOffset"] = -290.5100084192656,
},
["migrationCutoff"] = 730,
["registered"] = {
},
["displays"] = {
["Call Pet"] = {
["texXOffset"] = 0,
["xOffset"] = 0,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["do_custom"] = false,
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound_path"] = "567461",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Call Pet\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(883) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["custom"] = "function(event, show)\n    return show\nend",
["spellIds"] = {
},
["events"] = "TOGGLE_PET_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_class"] = true,
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["parent"] = "PetGroup",
["iconSource"] = -1,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["preset"] = "spiral",
["duration_type"] = "seconds",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["translateType"] = "straightTranslate",
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["duration"] = ".1",
},
},
["authorOptions"] = {
},
["cooldown"] = false,
["displayIcon"] = 132161,
["config"] = {
},
["icon"] = true,
["cooldownTextDisabled"] = false,
["width"] = 30,
["useCooldownModRate"] = true,
["id"] = "Call Pet",
["zoom"] = 0,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["uid"] = "elPRSunFvRh",
["inverse"] = false,
["color"] = {
1,
1,
1,
1,
},
["conditions"] = {
},
["information"] = {
},
["keepAspectRatio"] = false,
},
["BoglingAlert"] = {
["authorOptions"] = {
},
["yOffset"] = 80.59283447265625,
["regionType"] = "empty",
["information"] = {
},
["xOffset"] = -228.3450927734375,
["actions"] = {
["start"] = {
["do_message"] = false,
},
["init"] = {
},
["finish"] = {
["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.ogg",
["do_sound"] = true,
},
},
["triggers"] = {
{
["trigger"] = {
["subeventPrefix"] = "SPELL",
["type"] = "event",
["genericShowOn"] = "showOnCooldown",
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["use_genericShowOn"] = true,
["message_operator"] = "find('%s')",
["names"] = {
},
["message"] = "removes the seeds",
["use_itemName"] = true,
["spellIds"] = {
},
["use_unit"] = true,
["use_message"] = true,
["unit"] = "",
["event"] = "Chat Message",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["alpha"] = 1,
["internalVersion"] = 89,
["anchorFrameType"] = "SCREEN",
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
["id"] = "BoglingAlert",
["thumbnailIcon"] = 133749,
["frameStrata"] = 1,
["width"] = 200,
["config"] = {
},
["uid"] = "8Mb2ioHU)tn",
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
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
["anchorPoint"] = "CENTER",
},
["HunterGroup"] = {
["grow"] = "GRID",
["controlledChildren"] = {
"Track Beasts",
"Track Hidden",
"Eagle Eye",
"Track Demons",
"Track Undead",
"Track Humanoids",
"Track Elementals",
"Track Giants",
"AudioAndFX",
},
["borderBackdrop"] = "Blizzard Collections Background",
["parent"] = "HunterUtilFolder",
["yOffset"] = 16.83938598632813,
["gridType"] = "UL",
["borderColor"] = {
0,
0,
0,
1,
},
["space"] = 2,
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
["subeventPrefix"] = "SPELL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["names"] = {
},
["event"] = "Health",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
},
["columnSpace"] = 0,
["internalVersion"] = 89,
["useLimit"] = false,
["align"] = "CENTER",
["stagger"] = 0,
["xOffset"] = 14.7764892578125,
["subRegions"] = {
},
["borderInset"] = 3,
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
["fullCircle"] = true,
["backdropColor"] = {
0,
0,
0,
1,
},
["rotation"] = 0,
["animate"] = false,
["config"] = {
},
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Blizzard Chat Bubble",
["stepAngle"] = 15,
["borderSize"] = 5,
["limit"] = 5,
["authorOptions"] = {
},
["sort"] = "none",
["constantFactor"] = "RADIUS",
["arcLength"] = 360,
["borderOffset"] = 1,
["gridWidth"] = 4,
["rowSpace"] = 1,
["id"] = "HunterGroup",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["radius"] = 200,
["uid"] = "4eVlQS3idWx",
["anchorPoint"] = "CENTER",
["regionType"] = "dynamicgroup",
["conditions"] = {
},
["information"] = {
},
["selfPoint"] = "BOTTOMRIGHT",
},
["Raptor Strike"] = {
["iconSource"] = 1,
["xOffset"] = 0,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["debuffType"] = "HELPFUL",
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["names"] = {
},
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["genericShowOn"] = "showOnCooldown",
["use_exact_spellName"] = false,
["use_track"] = true,
["spellName"] = 2973,
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["authorOptions"] = {
},
["parent"] = "CooldownGroup",
["useAdjustededMin"] = false,
["regionType"] = "icon",
["url"] = "Meow",
["useTooltip"] = true,
["information"] = {
},
["progressSource"] = {
-1,
"",
},
["uid"] = "2OXS70sADA8",
["zoom"] = 0,
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["useCooldownModRate"] = true,
["id"] = "Raptor Strike",
["frameStrata"] = 1,
["alpha"] = 1,
["width"] = 26,
["color"] = {
1,
1,
1,
1,
},
["config"] = {
},
["inverse"] = false,
["actions"] = {
["start"] = {
},
["finish"] = {
["do_sound"] = true,
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound_channel"] = "SFX",
},
["init"] = {
},
},
["conditions"] = {
},
["cooldown"] = true,
["selfPoint"] = "CENTER",
},
["BG2"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["xOffset"] = -20,
["desaturate"] = false,
["color"] = {
0,
0,
0,
1,
},
["authorOptions"] = {
},
["mirror"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["parent"] = "Party2",
["rotate"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
["finish"] = {
},
},
["texture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_AlphaGradient.tga",
["triggers"] = {
{
["trigger"] = {
["use_factionID"] = true,
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["type"] = "unit",
["spellIds"] = {
},
["names"] = {
},
["unit"] = "party2",
["use_unit"] = true,
["use_specific_unit"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["config"] = {
},
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
["id"] = "BG2",
["selfPoint"] = "CENTER",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["uid"] = "xW8eFJOclzr",
["alpha"] = 0.6,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 40,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "percenthealth",
["value"] = "50",
["op"] = "<=",
},
["changes"] = {
{
["value"] = {
1,
0,
0.01568627543747425,
1,
},
["property"] = "color",
},
},
},
},
["information"] = {
},
["width"] = 310,
},
["PetGroup"] = {
["grow"] = "GRID",
["controlledChildren"] = {
"Feed Pet",
"Revive Pet",
"Pet Training",
"Call Pet",
"Tame Beast",
"Dismiss Pet",
"AudioAndFX 2",
},
["borderBackdrop"] = "Blizzard Collections Background",
["xOffset"] = 14.7764892578125,
["yOffset"] = 16.83938598632813,
["anchorPoint"] = "CENTER",
["borderColor"] = {
0,
0,
0,
1,
},
["space"] = 2,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
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
["columnSpace"] = 0,
["radius"] = 200,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["align"] = "CENTER",
["stagger"] = 0,
["stepAngle"] = 15,
["subRegions"] = {
},
["uid"] = "0f2PeXZGZty",
["selfPoint"] = "BOTTOMRIGHT",
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["rotation"] = 0,
["backdropColor"] = {
0,
0,
0,
1,
},
["gridType"] = "UL",
["animate"] = false,
["useLimit"] = false,
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Blizzard Chat Bubble",
["regionType"] = "dynamicgroup",
["borderSize"] = 5,
["limit"] = 5,
["internalVersion"] = 89,
["parent"] = "PetFolder",
["constantFactor"] = "RADIUS",
["arcLength"] = 360,
["borderOffset"] = 1,
["alpha"] = 1,
["frameStrata"] = 1,
["id"] = "PetGroup",
["rowSpace"] = 1,
["gridWidth"] = 3,
["anchorFrameType"] = "SCREEN",
["config"] = {
},
["borderInset"] = 3,
["sort"] = "none",
["authorOptions"] = {
},
["conditions"] = {
},
["information"] = {
},
["fullCircle"] = true,
},
["ClickBox3"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["alpha"] = 0,
["width"] = 262,
["parent"] = "Party3",
["color"] = {
1,
1,
1,
1,
},
["mirror"] = false,
["yOffset"] = 0,
["regionType"] = "texture",
["information"] = {
},
["blendMode"] = "BLEND",
["anchorPoint"] = "CENTER",
["authorOptions"] = {
},
["xOffset"] = 0,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- 1. Create a unique name to avoid global conflicts\nlocal btnName = \"WA_PartyTargetBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\")\n\n-- 2. Cleanup old button if it exists (prevents button stacking on reloads)\nif aura_env.btn then\n    aura_env.btn:Hide()\nend\n\n-- 3. Create the Secure Button\n-- We parent it to aura_env.region so it moves/scales with the WeakAura\nlocal btn = CreateFrame(\"Button\", btnName, aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 4. Set the Attributes\n-- Note: These cannot be changed while in combat\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/target party3\")\n\n-- 5. Store in aura_env for persistence and cleanup\naura_env.btn = btn\n\n",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_alwaystrue"] = true,
["subeventSuffix"] = "_CAST_START",
["event"] = "Conditions",
["use_genericShowOn"] = true,
["use_itemName"] = true,
["unit"] = "target",
["subeventPrefix"] = "SPELL",
["use_spellName"] = true,
["spellIds"] = {
},
["names"] = {
},
["use_unit"] = true,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["conditions"] = {
},
["internalVersion"] = 89,
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "ClickBox3",
["selfPoint"] = "CENTER",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["uid"] = "8h7GCtf0xeu",
["config"] = {
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 44,
["rotate"] = false,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"4",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["desaturate"] = false,
},
["Track Humanoids"] = {
["iconSource"] = -1,
["parent"] = "HunterGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["sound"] = " custom",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["do_custom"] = false,
["sound_path"] = "567461",
["sound_channel"] = "Master",
},
["finish"] = {
["sound_channel"] = "Master",
["sound_path"] = "567482",
["sound"] = " custom",
["do_sound"] = false,
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Track Humanoids\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(19883) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["spellIds"] = {
},
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_HUNTER_MENU",
["custom"] = "function(event, show)\n    return show\nend",
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["debuffType"] = "HELPFUL",
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["spellName"] = 19883,
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["preset"] = "spiral",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["scaley"] = 1,
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["selfPoint"] = "CENTER",
["authorOptions"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["color"] = {
1,
1,
1,
1,
},
["keepAspectRatio"] = false,
["information"] = {
},
["conditions"] = {
},
["uid"] = "ocziEJPV1Qs",
["xOffset"] = 0,
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["id"] = "Track Humanoids",
["frameStrata"] = 1,
["useCooldownModRate"] = true,
["width"] = 30,
["cooldownTextDisabled"] = false,
["config"] = {
},
["inverse"] = false,
["icon"] = true,
["displayIcon"] = 135942,
["cooldown"] = false,
["texXOffset"] = 0,
},
["CheetahWarning"] = {
["iconSource"] = -1,
["color"] = {
1,
0.05490196496248245,
0,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -135.1116638183594,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_incombat"] = true,
["subeventSuffix"] = "_CAST_START",
["event"] = "Conditions",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "aura2",
["auranames"] = {
5118,
"5131",
},
["use_genericShowOn"] = true,
["event"] = "Unit Characteristics",
["unit"] = "player",
["useName"] = true,
["use_spellName"] = true,
["form"] = {
["single"] = 0,
},
["use_form"] = true,
["use_unit"] = true,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 45,
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
["useAdjustededMax"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["displayIcon"] = 132242,
["cooldown"] = false,
["xOffset"] = 1.57940673828125,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["keepAspectRatio"] = false,
["cooldownTextDisabled"] = false,
["zoom"] = 0,
["config"] = {
},
["frameStrata"] = 1,
["id"] = "CheetahWarning",
["width"] = 45,
["useCooldownModRate"] = true,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["uid"] = "F)sLUNGeqQt",
["inverse"] = false,
["authorOptions"] = {
},
["conditions"] = {
},
["information"] = {
},
["animation"] = {
["start"] = {
["type"] = "preset",
["easeType"] = "none",
["duration_type"] = "seconds",
["preset"] = "fade",
["easeStrength"] = 3,
},
["main"] = {
["type"] = "preset",
["easeType"] = "none",
["duration_type"] = "seconds",
["preset"] = "pulse",
["easeStrength"] = 3,
},
["finish"] = {
["type"] = "preset",
["easeType"] = "none",
["duration_type"] = "seconds",
["preset"] = "fade",
["easeStrength"] = 3,
},
},
},
["PetFolder"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"PetButton",
"PetGroup",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["borderEdge"] = "Square Full White",
["border"] = false,
["yOffset"] = -289.9760131835938,
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
["authorOptions"] = {
},
["borderColor"] = {
0,
0,
0,
1,
},
["uid"] = "uie7QH(y9DF",
["regionType"] = "group",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
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
["parent"] = "ActionBarFolders",
["borderOffset"] = 4,
["xOffset"] = 708.7410888671875,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "PetFolder",
["internalVersion"] = 89,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["config"] = {
},
["alpha"] = 1,
["subRegions"] = {
},
["borderInset"] = 1,
["conditions"] = {
},
["information"] = {
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
},
["InCombatSFX"] = {
["parent"] = "CombatFX",
["yOffset"] = 0,
["regionType"] = "empty",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = true,
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["xOffset"] = 0,
["actions"] = {
["start"] = {
["custom"] = "local sounds = {\n    \"Interface/AddOns/WACustomAssets/Clarity_of_Thought.ogg\"\n}\n\nlocal randomIndex = math.random(1, #sounds)\nPlaySoundFile(sounds[randomIndex], \"Master\")",
["do_sound"] = true,
["do_custom"] = false,
["sound"] = " custom",
["sound_path"] = "Interface\\AddOns\\WACustomAssets\\BreathFade3.ogg",
},
["finish"] = {
["do_sound_fade"] = true,
["do_sound"] = false,
["stop_sound_fade"] = 1,
["do_message"] = false,
["stop_sound"] = true,
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_incombat"] = true,
["subeventSuffix"] = "_CAST_START",
["event"] = "Conditions",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "player",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["authorOptions"] = {
},
["internalVersion"] = 89,
["frameStrata"] = 1,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "InCombatSFX",
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["width"] = 200,
["config"] = {
},
["uid"] = "XMzhvcxHFWW",
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["information"] = {
},
["anchorPoint"] = "CENTER",
},
["Debuffs"] = {
["arcLength"] = 360,
["controlledChildren"] = {
"Icons 3",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = 561.71,
["preferToUpdate"] = true,
["yOffset"] = 50.28,
["anchorPoint"] = "CENTER",
["fullCircle"] = true,
["space"] = 2,
["url"] = "Meow",
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
["subeventPrefix"] = "SPELL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["names"] = {
},
["event"] = "Health",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
},
["columnSpace"] = 1,
["internalVersion"] = 89,
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
["align"] = "CENTER",
["gridWidth"] = 7,
["rotation"] = 0,
["sort"] = "none",
["sortHybridTable"] = {
["Icons 3"] = false,
},
["subRegions"] = {
},
["parent"] = "BDO Player Bars",
["radius"] = 200,
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
["borderColor"] = {
0,
0,
0,
1,
},
["backdropColor"] = {
1,
1,
1,
0.5,
},
["authorOptions"] = {
},
["animate"] = false,
["grow"] = "GRID",
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Square Full White",
["stepAngle"] = 15,
["borderSize"] = 2,
["limit"] = 5,
["borderInset"] = 1,
["config"] = {
},
["constantFactor"] = "RADIUS",
["rowSpace"] = 1,
["borderOffset"] = 4,
["frameStrata"] = 1,
["tocversion"] = 11508,
["id"] = "Debuffs",
["useLimit"] = false,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["regionType"] = "dynamicgroup",
["uid"] = "Yhj(jOZlFmy",
["gridType"] = "LU",
["selfPoint"] = "BOTTOMRIGHT",
["conditions"] = {
},
["information"] = {
},
["stagger"] = 0,
},
["EnemyHPInstant"] = {
["sparkWidth"] = 15,
["iconSource"] = -1,
["xOffset"] = 0,
["adjustedMax"] = "",
["yOffset"] = -15.09155218920735,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["url"] = "Meow",
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWATargetProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"target\")\n\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nRegisterUnitWatch(btn) \n\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nlocal bg = btn:CreateTexture(nil, \"BACKGROUND\")\nbg:SetAllPoints(btn)\nbg:SetColorTexture(0, 0, 0, 0)\n\nif TargetFrame then\n    TargetFrame:Hide()\nend",
},
["finish"] = {
},
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["selfPoint"] = "CENTER",
["barColor"] = {
0.8588235974311829,
0.1568627506494522,
0.01568627543747425,
1,
},
["desaturate"] = false,
["ignoreWagoUpdate"] = true,
["sparkOffsetY"] = 0.1,
["gradientOrientation"] = "HORIZONTAL",
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_alive"] = true,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
["HUNTER"] = true,
},
},
["size"] = {
["multi"] = {
},
},
},
["smoothProgress"] = false,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["overlayclip"] = true,
["texture"] = "Solid",
["zoom"] = 0,
["spark"] = false,
["tocversion"] = 11502,
["alpha"] = 1,
["sparkColor"] = {
1,
1,
1,
0.6447645425796509,
},
["sparkOffsetX"] = 0.1,
["wagoID"] = "zuOgFOlAp",
["parent"] = "BDO Target Bar",
["adjustedMin"] = "",
["sparkRotationMode"] = "MANUAL",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_maxhealth"] = false,
["names"] = {
},
["event"] = "Health",
["unit"] = "target",
["subeventPrefix"] = "SPELL",
["powertype"] = 0,
["spellIds"] = {
},
["use_unit"] = true,
["use_showCost"] = true,
["use_percenthealth"] = false,
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "unit",
["use_unit"] = true,
["classification"] = {
["multi"] = {
["elite"] = true,
["worldboss"] = true,
["rareelite"] = true,
["rare"] = true,
},
},
["use_role"] = false,
["debuffType"] = "HELPFUL",
["event"] = "Unit Characteristics",
["unit"] = "target",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["version"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["border_offset"] = 1,
["type"] = "subborder",
["border_visible"] = true,
["border_color"] = {
0,
0,
0,
1,
},
["anchor_area"] = "bar",
["border_edge"] = "1 Pixel",
["border_size"] = 1,
},
{
["text_shadowXOffset"] = 1,
["text_text_format_p_time_dynamic_threshold"] = 60,
["text_text_format_t_time_legacy_floor"] = false,
["anchorXOffset"] = 0,
["text_text_format_p_time_mod_rate"] = true,
["text_text_format_p_format"] = "timed",
["text_text_format_p_time_legacy_floor"] = false,
["text_selfPoint"] = "CENTER",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["text_text_format_t_time_format"] = 0,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_t_format"] = "timed",
["text_text_format_p_time_format"] = 0,
["text_visible"] = true,
["type"] = "subtext",
["text_fontType"] = "None",
["text_color"] = {
0.9764706492424,
1,
0.98039221763611,
1,
},
["text_font"] = "2002",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_anchorYOffset"] = 0,
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_text_format_t_time_mod_rate"] = true,
["text_text_format_p_time_precision"] = 1,
["text_text_format_t_time_precision"] = 1,
["anchor_point"] = "INNER_CENTER",
["text_fontSize"] = 14,
["text_text_format_t_time_dynamic_threshold"] = 3,
["text_text"] = "%p/%t",
},
{
["glowFrequency"] = 0.2,
["type"] = "subglow",
["useGlowColor"] = true,
["glowType"] = "ACShine",
["glowLength"] = 11.5,
["glow"] = true,
["glowYOffset"] = 0,
["glowColor"] = {
1,
0.847058892250061,
0,
0.1832259893417358,
},
["glowThickness"] = 8.250000000000002,
["glowXOffset"] = 0,
["glowDuration"] = 1,
["glowScale"] = 1.8,
["anchor_area"] = "bg",
["glowLines"] = 6,
["glowBorder"] = true,
},
},
["height"] = 18.56317138671875,
["textureSource"] = "LSM",
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["config"] = {
},
["icon_side"] = "RIGHT",
["barColor2"] = {
0.5254902243614197,
0.5254902243614197,
0.5254902243614197,
1,
},
["authorOptions"] = {
},
["sparkHeight"] = 33,
["preferToUpdate"] = false,
["overlaysTexture"] = {
"Details Flat",
},
["backgroundColor"] = {
0,
0,
0,
0,
},
["semver"] = "1.0.0",
["id"] = "EnemyHPInstant",
["sparkHidden"] = "NEVER",
["width"] = 584.0000610351562,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["uid"] = "sPnFVBEE5D0",
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["inverse"] = false,
["icon"] = false,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "nameplateType",
["op"] = "==",
["value"] = "friendly",
},
["changes"] = {
{
["value"] = {
0.207843154668808,
0.7960785031318665,
0.2235294282436371,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 2,
["variable"] = "classification",
["op"] = "==",
["value"] = "normal",
},
["linked"] = false,
["changes"] = {
{
["property"] = "sub.5.glow",
},
},
},
{
["check"] = {
["trigger"] = 2,
["variable"] = "classification",
["op"] = "~=",
["value"] = "normal",
},
["linked"] = true,
["changes"] = {
{
["value"] = true,
["property"] = "sub.5.glow",
},
{
["value"] = "PlaterHealth",
["property"] = "texture",
},
},
},
},
["information"] = {
["showNilIsFalse"] = true,
},
["overlays"] = {
{
0.95294123888016,
1,
0.99215692281723,
1,
},
},
},
["Party3"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"BG3",
"SoundAlert3",
"ClickBox3",
"Power3",
"Health3",
"ClassIcon3",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["yOffset"] = -135,
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 2,
["xOffset"] = 0,
["borderColor"] = {
0,
0,
0,
1,
},
["uid"] = "fjBnI35lPuE",
["anchorPoint"] = "CENTER",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["authorOptions"] = {
},
["borderOffset"] = 4,
["parent"] = "BDOPartyFrame",
["selfPoint"] = "CENTER",
["id"] = "Party3",
["internalVersion"] = 89,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["borderInset"] = 1,
["frameStrata"] = 1,
["subRegions"] = {
},
["config"] = {
},
["conditions"] = {
},
["information"] = {
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
},
["Pet Health"] = {
["controlledChildren"] = {
"PetHealth",
"PetPower",
},
["borderBackdrop"] = "Blizzard Dialog Background",
["wagoID"] = "zuOgFOlAp",
["xOffset"] = -4.899569247723732,
["preferToUpdate"] = false,
["yOffset"] = -593.1487691348689,
["anchorPoint"] = "CENTER",
["sharedFrameLevel"] = false,
["borderColor"] = {
0,
0,
0,
1,
},
["url"] = "https://wago.io/zuOgFOlAp/1",
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["subeventPrefix"] = "SPELL",
["unit"] = "player",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["internalVersion"] = 89,
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
["version"] = 1,
["subRegions"] = {
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["backdropColor"] = {
0.4823529720306397,
0.4823529720306397,
0.4823529720306397,
0.5,
},
["scale"] = 0.55,
["border"] = true,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 1,
["groupIcon"] = 132311,
["parent"] = "BDO UI Overhaul",
["borderOffset"] = 0,
["semver"] = "1.0.0",
["tocversion"] = 11502,
["id"] = "Pet Health",
["authorOptions"] = {
},
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["borderInset"] = 1,
["uid"] = "yx65ODGRUki",
["config"] = {
},
["conditions"] = {
},
["information"] = {
["showNilIsFalse"] = true,
},
["selfPoint"] = "CENTER",
},
["Feed Pet"] = {
["iconSource"] = -1,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_YOffset"] = -1,
["glow_action"] = "show",
["glow_XOffset"] = -1,
["sound"] = " custom",
["do_glow"] = false,
["do_custom"] = false,
["glow_frame"] = "WeakAuras:PetButton",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["glow_type"] = "ACShine",
["sound_path"] = "Sound\\Creature\\Cat\\CatDeath.ogg",
["sound_channel"] = "Master",
},
["finish"] = {
["hide_all_glows"] = false,
["do_sound"] = false,
["sound_path"] = "6006536",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Feed Pet\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(6991) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)\n\n\nbtn:SetScript(\"PostClick\", function()\n        -- This closes the tooltip (your previous request)\n        GameTooltip:Hide()\n        \n        -- This opens the bags if they are closed\n        if not IsBagOpen(0) then \n            OpenAllBags() \n        end\nend)",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["custom"] = "function(event, show)\n    return show\nend",
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_PET_MENU",
["spellIds"] = {
},
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["scaley"] = 1,
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["translateType"] = "straightTranslate",
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["rotate"] = 0,
["scaley"] = 1,
["easeStrength"] = 3,
["scalex"] = 1,
["duration_type"] = "seconds",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_class"] = true,
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["parent"] = "PetGroup",
["texXOffset"] = 0,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["xOffset"] = 0,
["icon"] = true,
["information"] = {
},
["conditions"] = {
},
["uid"] = "bx5O)IaIAJ4",
["selfPoint"] = "CENTER",
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["id"] = "Feed Pet",
["frameStrata"] = 1,
["useCooldownModRate"] = true,
["width"] = 30,
["cooldownTextDisabled"] = false,
["config"] = {
},
["inverse"] = false,
["progressSource"] = {
-1,
"",
},
["displayIcon"] = 132165,
["cooldown"] = false,
["color"] = {
1,
1,
1,
1,
},
},
["ClickBox1"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["alpha"] = 0,
["width"] = 262,
["xOffset"] = 0,
["parent"] = "Party1",
["mirror"] = false,
["yOffset"] = 0,
["regionType"] = "texture",
["information"] = {
},
["blendMode"] = "BLEND",
["anchorPoint"] = "CENTER",
["color"] = {
1,
1,
1,
1,
},
["authorOptions"] = {
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- 1. Create a unique name to avoid global conflicts\nlocal btnName = \"WA_PartyTargetBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\")\n\n-- 2. Cleanup old button if it exists (prevents button stacking on reloads)\nif aura_env.btn then\n    aura_env.btn:Hide()\nend\n\n-- 3. Create the Secure Button\n-- We parent it to aura_env.region so it moves/scales with the WeakAura\nlocal btn = CreateFrame(\"Button\", btnName, aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 4. Set the Attributes\n-- Note: These cannot be changed while in combat\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/target party1\")\n\n-- 5. Store in aura_env for persistence and cleanup\naura_env.btn = btn\n\n",
},
},
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
["conditions"] = {
},
["internalVersion"] = 89,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_alwaystrue"] = true,
["subeventSuffix"] = "_CAST_START",
["event"] = "Conditions",
["use_genericShowOn"] = true,
["use_itemName"] = true,
["unit"] = "target",
["subeventPrefix"] = "SPELL",
["use_spellName"] = true,
["spellIds"] = {
},
["names"] = {
},
["use_unit"] = true,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["selfPoint"] = "CENTER",
["id"] = "ClickBox1",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["uid"] = "9xc(MQuPYiX",
["config"] = {
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 44,
["rotate"] = false,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["desaturate"] = false,
},
["Icons 3"] = {
["iconSource"] = -1,
["parent"] = "Debuffs",
["preferToUpdate"] = true,
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["url"] = "Meow",
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["showClones"] = true,
["type"] = "aura2",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HARMFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 45,
["load"] = {
["use_never"] = false,
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["authorOptions"] = {
},
["config"] = {
},
["cooldownEdge"] = false,
["keepAspectRatio"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["cooldown"] = true,
["adjustedMax"] = "",
["xOffset"] = 0,
["color"] = {
1,
1,
1,
1,
},
["width"] = 45,
["frameStrata"] = 1,
["cooldownTextDisabled"] = false,
["zoom"] = 0,
["tocversion"] = 11508,
["id"] = "Icons 3",
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWAPlayerProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"player\")\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nif PlayerFrame then\n    PlayerFrame:Hide()\nend",
},
["finish"] = {
},
},
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["useCooldownModRate"] = true,
["uid"] = "G7RcXOw8h5g",
["inverse"] = false,
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
["conditions"] = {
},
["information"] = {
},
["useTooltip"] = true,
},
["Icons 2"] = {
["iconSource"] = -1,
["parent"] = "Buffs",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["url"] = "Meow",
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["showClones"] = true,
["type"] = "aura2",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 45,
["load"] = {
["use_never"] = false,
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["xOffset"] = 0,
["uid"] = "hYxWv2M5pJx",
["cooldownEdge"] = false,
["authorOptions"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["information"] = {
},
["color"] = {
1,
1,
1,
1,
},
["keepAspectRatio"] = false,
["preferToUpdate"] = true,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["zoom"] = 0,
["cooldownTextDisabled"] = false,
["tocversion"] = 11508,
["id"] = "Icons 2",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["useCooldownModRate"] = true,
["width"] = 45,
["frameStrata"] = 1,
["config"] = {
},
["inverse"] = false,
["actions"] = {
["start"] = {
["custom"] = "local region = aura_env.region\nif InCombatLockdown() then return end\n\n-- 1. Get the buff name and a unique ID for this specific clone\nlocal state = aura_env.state\nif not state or not state.name then return end\n\nlocal buffName = state.name\n-- Use cloneId so every icon gets its own unique button\nlocal uniqueID = state.cloneId or aura_env.id\nlocal btnName = \"WA_Cancel_\" .. uniqueID:gsub(\"[^%w]\", \"_\")\n\n-- 2. Create or retrieve the unique button\nlocal btn = _G[btnName] or CreateFrame(\"Button\", btnName, region, \"SecureActionButtonTemplate\")\n\n-- 3. Anchor and Parent\nbtn:SetParent(region)\nbtn:ClearAllPoints()\nbtn:SetAllPoints(region)\n\n-- 4. Set the attributes\nbtn:RegisterForClicks(\"RightButtonUp\")\nbtn:SetAttribute(\"type2\", \"macro\")\nbtn:SetAttribute(\"macrotext2\", \"/cancelaura \" .. buffName)\n\n-- 5. Ensure it's clickable and layered correctly\nbtn:SetFrameStrata(region:GetFrameStrata())\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\n\n-- 6. Background (Invisible)\nif not btn.bg then\n    btn.bg = btn:CreateTexture(nil, \"BACKGROUND\")\n    btn.bg:SetAllPoints(btn)\n    btn.bg:SetColorTexture(0, 0, 0, 0)\nend\n\n",
["do_message"] = false,
["do_custom"] = false,
},
["finish"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "",
},
},
["conditions"] = {
},
["cooldown"] = true,
["useTooltip"] = true,
},
["Track Giants"] = {
["texXOffset"] = 0,
["parent"] = "HunterGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["spellIds"] = {
},
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_HUNTER_MENU",
["custom"] = "function(event, show)\n    return show\nend",
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 19882,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_combat"] = false,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["use_alive"] = true,
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["actions"] = {
["start"] = {
["do_custom"] = false,
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound_path"] = "567461",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["finish"] = {
["sound_channel"] = "Master",
["sound_path"] = "567482",
["sound"] = " custom",
["do_sound"] = false,
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Track Giants\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(19882) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
},
["xOffset"] = 0,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["authorOptions"] = {
},
["iconSource"] = -1,
["information"] = {
},
["conditions"] = {
},
["uid"] = "AhqkkHntJCf",
["color"] = {
1,
1,
1,
1,
},
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["id"] = "Track Giants",
["zoom"] = 0,
["useCooldownModRate"] = true,
["width"] = 30,
["alpha"] = 1,
["config"] = {
},
["inverse"] = false,
["keepAspectRatio"] = false,
["displayIcon"] = 132275,
["cooldown"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["preset"] = "spiral",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["scaley"] = 1,
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
},
["Threat"] = {
["outline"] = "None",
["xOffset"] = 0,
["displayText_format_p_time_dynamic_threshold"] = 60,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["displayText_format_1.threatpct_pad"] = false,
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_threatvalue"] = false,
["event"] = "Threat Situation",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "target",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_time_mod_rate"] = true,
["displayText_format_p_time_legacy_floor"] = false,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["displayText_format_1.threatpct_pad_mode"] = "left",
["font"] = "Friz Quadrata TT",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["fontSize"] = 19,
["displayText_format_1.threatpct_round_type"] = "floor",
["shadowXOffset"] = 1,
["authorOptions"] = {
},
["shadowYOffset"] = -1,
["regionType"] = "text",
["displayText_format_p_format"] = "timed",
["fixedWidth"] = 200,
["displayText_format_1.threatpct_pad_max"] = 8,
["displayText_format_1.threatpct_format"] = "Number",
["displayText_format_p_time_precision"] = 1,
["wordWrap"] = "WordWrap",
["displayText_format_1.threatpct_decimal_precision"] = 0,
["displayText_format_1.threatvalue_format"] = "none",
["justify"] = "LEFT",
["uid"] = "XNEFF4Jb(f(",
["id"] = "Threat",
["parent"] = "RaceAndThreat",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["color"] = {
0.6235294342041016,
0.6235294342041016,
0.6235294342041016,
1,
},
["config"] = {
},
["selfPoint"] = "BOTTOM",
["internalVersion"] = 89,
["shadowColor"] = {
0,
0,
0,
1,
},
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "threatpct",
["value"] = "85",
["op"] = ">",
},
["changes"] = {
{
["value"] = {
1,
0.1137254983186722,
0,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "threatpct",
["value"] = "40",
["op"] = ">",
},
["linked"] = true,
["changes"] = {
{
["property"] = "color",
},
},
},
},
["information"] = {
},
["displayText"] = " - %1.threatpct",
},
["BDO UI Overhaul"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"BDOPartyFrame",
"BDO Cooldowns",
"BDO Player Bars",
"BDO Target Bar",
"BDO XP",
"Pet Health",
},
["borderBackdrop"] = "Blizzard Tooltip",
["authorOptions"] = {
},
["borderEdge"] = "Square Full White",
["border"] = false,
["groupIcon"] = "132311",
["regionType"] = "group",
["borderSize"] = 2,
["scale"] = 1,
["borderColor"] = {
0,
0,
0,
1,
},
["config"] = {
},
["yOffset"] = 0,
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["anchorPoint"] = "CENTER",
["internalVersion"] = 89,
["xOffset"] = 0,
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
["id"] = "BDO UI Overhaul",
["borderOffset"] = 4,
["frameStrata"] = 3,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["borderInset"] = 1,
["alpha"] = 1,
["subRegions"] = {
},
["uid"] = "w0GvngYr3BQ",
["conditions"] = {
},
["information"] = {
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
},
["Icons"] = {
["iconSource"] = -1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -2.154996871948242,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["showClones"] = true,
["type"] = "aura2",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["names"] = {
},
["unit"] = "target",
["debuffType"] = "HARMFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["ignoreWagoUpdate"] = true,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "None",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
{
["border_offset"] = 0,
["type"] = "subborder",
["border_color"] = {
1,
0,
0,
0.371259868144989,
},
["border_visible"] = true,
["border_edge"] = "Square Full White",
["border_size"] = 2,
},
},
["height"] = 39,
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_alive"] = true,
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["url"] = "Meow",
["xOffset"] = 12.92924499511719,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "aura_env.region:EnableMouse(true)\naura_env.region:SetScript(\"OnMouseDown\", function(self, button)\n   if button == \"RightButton\" then\n      CancelUnitBuff(\"player\", aura_env.id)\n   end\nend)",
},
},
["parent"] = "TargetDebuffs",
["information"] = {
},
["useTooltip"] = true,
["uid"] = "Iflo3rE7HcG",
["authorOptions"] = {
},
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["id"] = "Icons",
["cooldownTextDisabled"] = false,
["alpha"] = 1,
["width"] = 39,
["useCooldownModRate"] = true,
["config"] = {
},
["inverse"] = false,
["keepAspectRatio"] = false,
["conditions"] = {
},
["cooldown"] = true,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
},
["HunterButton"] = {
["iconSource"] = -1,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_frame"] = "WeakAuras:PetButton",
["do_sound"] = false,
["do_glow"] = false,
["glow_type"] = "buttonOverlay",
["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AcousticGuitar.ogg",
["glow_action"] = "show",
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- 1. Create the Secure Button\nlocal btn = CreateFrame(\"Button\", \"HunterAnchorBtn\", aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Create the INVISIBLE \"Dummy\" window brain\nif not _G.MyWAHunterMenuEscapeFrame then\n    local escFrame = CreateFrame(\"Frame\", \"MyWAHunterMenuEscapeFrame\", UIParent)\n    escFrame:Hide()\n    tinsert(_G.UISpecialFrames, \"MyWAHunterMenuEscapeFrame\")\n    \n    -- When this frame is SHOWN (via macro), tell icons to show\n    escFrame:SetScript(\"OnShow\", function()\n            -- CLOSE OTHER MENUS HERE\n            if MyWAPetMenuEscapeFrame then MyWAPetMenuEscapeFrame:Hide() end\n            if MyWAProfMenuEscapeFrame then MyWAProfMenuEscapeFrame:Hide() end\n            \n            _G.WA_HUNTER_OPEN = true\n            _G.WeakAuras.ScanEvents(\"TOGGLE_HUNTER_MENU\", true)\n    end)\n    \n    -- When this frame is HIDDEN (via Escape or macro), tell icons to hide\n    escFrame:SetScript(\"OnHide\", function()\n            _G.WA_HUNTER_OPEN = false\n            _G.WeakAuras.ScanEvents(\"TOGGLE_HUNTER_MENU\", false)\n    end)\n    \n    -- Close on combat\n    escFrame:RegisterEvent(\"PLAYER_REGEN_DISABLED\")\n    escFrame:SetScript(\"OnEvent\", function(self) self:Hide() end)\nend\n\n-- 3. The Toggle Macro (Now super simple)\n-- It just flips the dummy frame. The frame's own scripts handle the rest.\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", [[\n/run if MyWAHunterMenuEscapeFrame:IsShown() then MyWAHunterMenuEscapeFrame:Hide() else MyWAHunterMenuEscapeFrame:Show() end\n]])\n\n-- 4. Sync initial state\n_G.WA_HUNTER_OPEN = false",
},
["finish"] = {
["do_glow"] = false,
["hide_all_glows"] = false,
["glow_action"] = "hide",
["glow_frame_type"] = "FRAMESELECTOR",
["glow_frame"] = "WeakAuras:PetButton",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Unit Characteristics",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "any",
["customTriggerLogic"] = "function()\n    return true\nend",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
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
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["selfPoint"] = "CENTER",
["useAdjustededMin"] = false,
["regionType"] = "icon",
["displayIcon"] = 132382,
["progressSource"] = {
-1,
"",
},
["parent"] = "HunterUtilFolder",
["cooldown"] = true,
["xOffset"] = 0,
["config"] = {
},
["cooldownTextDisabled"] = false,
["useCooldownModRate"] = true,
["width"] = 30,
["id"] = "HunterButton",
["alpha"] = 1,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["zoom"] = 0,
["uid"] = "ieaAOvcIIXM",
["inverse"] = false,
["icon"] = true,
["conditions"] = {
},
["information"] = {
},
["color"] = {
1,
1,
1,
1,
},
},
["ClickBox0"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["authorOptions"] = {
},
["desaturate"] = false,
["parent"] = "Party0",
["xOffset"] = 0,
["mirror"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["color"] = {
1,
1,
1,
1,
},
["rotate"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- 1. Create a unique name to avoid global conflicts\nlocal btnName = \"WA_PartyTargetBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\")\n\n-- 2. Cleanup old button if it exists (prevents button stacking on reloads)\nif aura_env.btn then\n    aura_env.btn:Hide()\nend\n\n-- 3. Create the Secure Button\n-- We parent it to aura_env.region so it moves/scales with the WeakAura\nlocal btn = CreateFrame(\"Button\", btnName, aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 4. Set the Attributes\n-- Note: These cannot be changed while in combat\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/target Player\")\n\n-- 5. Store in aura_env for persistence and cleanup\naura_env.btn = btn\n\n",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_alwaystrue"] = true,
["subeventSuffix"] = "_CAST_START",
["use_itemName"] = true,
["use_genericShowOn"] = true,
["event"] = "Conditions",
["unit"] = "target",
["subeventPrefix"] = "SPELL",
["use_spellName"] = true,
["spellIds"] = {
},
["genericShowOn"] = "showOnCooldown",
["use_unit"] = true,
["names"] = {
},
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
["internalVersion"] = 89,
["config"] = {
},
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
["id"] = "ClickBox0",
["selfPoint"] = "CENTER",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["uid"] = "sM5M4v6ItAk",
["alpha"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 44,
["conditions"] = {
},
["information"] = {
},
["width"] = 262,
},
["WithinRangeSound"] = {
["xOffset"] = -289.9749450683594,
["yOffset"] = 49.777587890625,
["anchorPoint"] = "CENTER",
["load"] = {
["use_never"] = true,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["regionType"] = "empty",
["actions"] = {
["start"] = {
["sound_path"] = "567506",
["sound"] = " custom",
["do_sound"] = true,
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Range Check",
["subeventPrefix"] = "SPELL",
["unit"] = "target",
["range"] = "7",
["spellIds"] = {
},
["use_range"] = true,
["names"] = {
},
["use_unit"] = true,
["range_operator"] = "<=",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "unit",
["range_operator"] = ">=",
["use_range"] = true,
["range"] = "8",
["use_unit"] = true,
["event"] = "Range Check",
["unit"] = "target",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "unit",
["unit"] = "target",
["event"] = "Unit Characteristics",
["debuffType"] = "HELPFUL",
["use_dead"] = false,
["use_attackable"] = true,
["use_unit"] = true,
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["authorOptions"] = {
},
["internalVersion"] = 89,
["frameStrata"] = 1,
["selfPoint"] = "CENTER",
["id"] = "WithinRangeSound",
["width"] = 200,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["config"] = {
},
["uid"] = "ZSRgZ4PVVSD",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["information"] = {
},
["parent"] = "RangeCheck",
},
["TabTargetTooltip"] = {
["authorOptions"] = {
},
["yOffset"] = 0,
["regionType"] = "empty",
["xOffset"] = 0,
["actions"] = {
["start"] = {
["do_custom"] = false,
},
["init"] = {
},
["finish"] = {
["do_message"] = false,
["custom"] = "function()\n    GameTooltip:Hide()\nend",
["do_custom"] = false,
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["custom_hide"] = "timed",
["duration"] = "3",
["event"] = "Health",
["dynamicDuration"] = false,
["custom_type"] = "event",
["spellIds"] = {
},
["events"] = "PLAYER_TARGET_CHANGED, PLAYER_SOFT_TARGET_CHANGED",
["subeventPrefix"] = "SPELL",
["unit"] = "player",
["custom"] = "function(event)\n    -- Determine which unit triggered the event\n    local unit = \"target\"\n    if event == \"PLAYER_SOFT_TARGET_CHANGED\" then\n        unit = \"softtarget\"\n    end\n\n    if UnitExists(unit) then\n        -- 1. Show the tooltip\n        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)\n        GameTooltip:SetUnit(unit)\n        GameTooltip:Show()\n\n        -- 2. Clean up any existing timer\n        if WA_TooltipTimer then WA_TooltipTimer:Cancel() end\n\n        -- 3. Just hide it after 2 seconds (no fading, just clean exit)\n        WA_TooltipTimer = C_Timer.NewTimer(2, function()\n            GameTooltip:Hide()\n        end)\n    end\n    \n    return false\nend",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function()\n    GameTooltip:Hide()\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["internalVersion"] = 89,
["animation"] = {
["start"] = {
["type"] = "custom",
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
["selfPoint"] = "CENTER",
["id"] = "TabTargetTooltip",
["alpha"] = 1,
["frameStrata"] = 1,
["width"] = 200,
["config"] = {
},
["uid"] = "FWg6)SNG6(2",
["anchorFrameType"] = "SCREEN",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["information"] = {
},
["anchorPoint"] = "CENTER",
},
["WithinRange"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["config"] = {
},
["frameStrata"] = 1,
["xOffset"] = 0.00018310546875,
["authorOptions"] = {
},
["mirror"] = false,
["yOffset"] = -174.8888244628906,
["regionType"] = "texture",
["information"] = {
},
["blendMode"] = "BLEND",
["anchorPoint"] = "CENTER",
["color"] = {
0.3490196168422699,
0.6117647290229797,
1,
1,
},
["parent"] = "RangeCheck",
["actions"] = {
["start"] = {
["sound_kit_id"] = "567506",
["sound_path"] = "567506",
["sound"] = " custom",
["do_sound"] = false,
},
["finish"] = {
["do_message"] = false,
["sound_path"] = "567473",
["sound"] = " custom",
["do_sound"] = false,
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["use_dead"] = false,
["use_hostility"] = false,
["use_genericShowOn"] = true,
["genericShowOn"] = "showOnCooldown",
["use_unit"] = true,
["use_attackable"] = true,
["debuffType"] = "HELPFUL",
["type"] = "spell",
["subeventSuffix"] = "_CAST_START",
["event"] = "Action Usable",
["use_targetRequired"] = true,
["spellName"] = 75,
["use_spellName"] = true,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["names"] = {
},
["unit"] = "target",
["use_track"] = true,
["hostility"] = "hostile",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["use_unit"] = true,
["type"] = "unit",
["range_operator"] = "<=",
["use_range"] = true,
["range"] = "35",
["debuffType"] = "HELPFUL",
["event"] = "Range Check",
["unit"] = "target",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["use_unit"] = true,
["type"] = "unit",
["range_operator"] = ">=",
["use_range"] = true,
["range"] = "8",
["debuffType"] = "HELPFUL",
["event"] = "Range Check",
["unit"] = "target",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["conditions"] = {
{
["check"] = {
["trigger"] = -1,
["variable"] = "incombat",
["value"] = 1,
},
["changes"] = {
{
["value"] = {
1,
0.02745098248124123,
0,
1,
},
["property"] = "color",
},
},
},
},
["internalVersion"] = 89,
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura7",
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["scalex"] = 1.8,
["easeType"] = "none",
["preset"] = "starShakeDecay",
["scaley"] = 1.8,
["alpha"] = 0,
["easeStrength"] = 3,
["y"] = 0,
["x"] = 0,
["use_scale"] = true,
["colorA"] = 1,
["duration"] = ".1",
["rotate"] = 0,
["scaleType"] = "straightScale",
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["use_rotate"] = false,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["scalex"] = 1.3,
["type"] = "custom",
["duration"] = ".1",
["easeType"] = "none",
["easeStrength"] = 3,
["scaley"] = 1.3,
["alpha"] = 0,
["rotate"] = 3,
["y"] = 0,
["x"] = 0,
["colorA"] = 1,
["rotateType"] = "wobble",
["use_scale"] = true,
["rotateFunc"] = "function(progress, start, delta)\n    local angle = progress * 2 * math.pi\n    return start + math.sin(angle) * delta\nend\n",
["scaleType"] = "straightScale",
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
},
},
["id"] = "WithinRange",
["selfPoint"] = "CENTER",
["alpha"] = 1,
["width"] = 50,
["rotation"] = 180,
["uid"] = "7V(EaheYcTZ",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 50,
["rotate"] = false,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["anchorFrameType"] = "SCREEN",
},
["Buffs"] = {
["grow"] = "GRID",
["controlledChildren"] = {
"Icons 2",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = -561.7087421377948,
["preferToUpdate"] = true,
["yOffset"] = 50.28195286223548,
["sortHybridTable"] = {
["Icons 2"] = false,
},
["borderColor"] = {
0,
0,
0,
1,
},
["space"] = 2,
["url"] = "Meow",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
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
["columnSpace"] = 1,
["internalVersion"] = 89,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["align"] = "CENTER",
["alpha"] = 1,
["stagger"] = 0,
["stepAngle"] = 15,
["fullCircle"] = true,
["subRegions"] = {
},
["parent"] = "BDO Player Bars",
["rotation"] = 0,
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["radius"] = 200,
["backdropColor"] = {
1,
1,
1,
0.5,
},
["gridType"] = "RU",
["animate"] = false,
["authorOptions"] = {
},
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "dynamicgroup",
["borderSize"] = 2,
["limit"] = 5,
["uid"] = "RoDsZ8iOLcR",
["sort"] = "none",
["constantFactor"] = "RADIUS",
["useLimit"] = false,
["borderOffset"] = 4,
["frameStrata"] = 1,
["tocversion"] = 11508,
["id"] = "Buffs",
["rowSpace"] = 1,
["gridWidth"] = 7,
["anchorFrameType"] = "SCREEN",
["config"] = {
},
["borderInset"] = 1,
["anchorPoint"] = "CENTER",
["arcLength"] = 360,
["conditions"] = {
},
["information"] = {
},
["selfPoint"] = "BOTTOMLEFT",
},
["EliteTex"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["xOffset"] = 1.436656553215815,
["anchorFrameType"] = "SCREEN",
["parent"] = "BDO Target Bar",
["color"] = {
0.9803922176361084,
0.9686275124549866,
0.9450981020927429,
1,
},
["mirror"] = false,
["yOffset"] = -1.43654558020846,
["anchorPoint"] = "CENTER",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["authorOptions"] = {
},
["rotate"] = false,
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
["subeventSuffix"] = "_CAST_START",
["event"] = "Unit Characteristics",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "target",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["texture"] = "Artifacts-Hunter-Header",
["internalVersion"] = 89,
["uid"] = "seOxbiOH)jB",
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
["id"] = "EliteTex",
["selfPoint"] = "CENTER",
["frameStrata"] = 1,
["desaturate"] = false,
["rotation"] = 0,
["config"] = {
},
["alpha"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 48,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "classification",
["op"] = "==",
["value"] = "normal",
},
["changes"] = {
{
["property"] = "alpha",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "classification",
["op"] = "~=",
["value"] = "elite",
},
["linked"] = true,
["changes"] = {
{
["value"] = true,
["property"] = "desaturate",
},
{
["value"] = 1,
["property"] = "alpha",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "classification",
["op"] = "==",
["value"] = "elite",
},
["linked"] = true,
["changes"] = {
{
["value"] = false,
["property"] = "desaturate",
},
{
["value"] = 1,
["property"] = "alpha",
},
},
},
},
["information"] = {
},
["width"] = 726,
},
["BDO XP"] = {
["controlledChildren"] = {
"XP Bar",
"LVL Group",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = -3.16082763671875,
["groupIcon"] = 132311,
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["internalVersion"] = 89,
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
["borderInset"] = 1,
["frameStrata"] = 1,
["id"] = "BDO XP",
["authorOptions"] = {
},
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["parent"] = "BDO UI Overhaul",
["config"] = {
},
["yOffset"] = 3.16070556640625,
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
["conditions"] = {
},
["information"] = {
},
["uid"] = "c1f4wYnx4r8",
},
["BG4"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["config"] = {
},
["anchorFrameType"] = "SCREEN",
["authorOptions"] = {
},
["parent"] = "Party4",
["mirror"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["color"] = {
0,
0,
0,
1,
},
["xOffset"] = -20,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
["finish"] = {
},
},
["texture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_AlphaGradient.tga",
["rotate"] = false,
["internalVersion"] = 89,
["triggers"] = {
{
["trigger"] = {
["use_factionID"] = true,
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["type"] = "unit",
["spellIds"] = {
},
["names"] = {
},
["unit"] = "party4",
["use_unit"] = true,
["use_specific_unit"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["selfPoint"] = "CENTER",
["id"] = "BG4",
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
["frameStrata"] = 1,
["desaturate"] = false,
["rotation"] = 0,
["uid"] = "eINvF1Y7DG)",
["alpha"] = 0.6,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 40,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "percenthealth",
["value"] = "50",
["op"] = "<=",
},
["changes"] = {
{
["value"] = {
1,
0,
0.01568627543747425,
1,
},
["property"] = "color",
},
},
},
},
["information"] = {
},
["width"] = 310,
},
["Track Demons"] = {
["texXOffset"] = 0,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["spellIds"] = {
},
["custom"] = "function(event, show)\n    return show\nend",
["events"] = "TOGGLE_HUNTER_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 19878,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["preset"] = "spiral",
["duration_type"] = "seconds",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["translateType"] = "straightTranslate",
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["duration"] = ".1",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_combat"] = false,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["use_alive"] = true,
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["progressSource"] = {
-1,
"",
},
["authorOptions"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["actions"] = {
["start"] = {
["sound"] = " custom",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["do_custom"] = false,
["sound_path"] = "567461",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Track Demons\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(19878) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["iconSource"] = -1,
["cooldown"] = false,
["displayIcon"] = 136217,
["config"] = {
},
["useCooldownModRate"] = true,
["cooldownTextDisabled"] = false,
["width"] = 30,
["alpha"] = 1,
["id"] = "Track Demons",
["zoom"] = 0,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = 0,
["uid"] = "sP2s3sje4mO",
["inverse"] = false,
["parent"] = "HunterGroup",
["conditions"] = {
},
["information"] = {
},
["selfPoint"] = "CENTER",
},
["ProfessionFolder"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"ProfessionButton",
"ProfessionsGroup",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["yOffset"] = -289.9758605957031,
["border"] = false,
["borderEdge"] = "Square Full White",
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
["xOffset"] = 738.7646484375,
["borderColor"] = {
0,
0,
0,
1,
},
["uid"] = "fNghXW4IVtT",
["regionType"] = "group",
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
["subeventPrefix"] = "SPELL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["names"] = {
},
["event"] = "Health",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
},
["authorOptions"] = {
},
["internalVersion"] = 89,
["parent"] = "ActionBarFolders",
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
["id"] = "ProfessionFolder",
["borderOffset"] = 4,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["borderInset"] = 1,
["alpha"] = 1,
["subRegions"] = {
},
["config"] = {
},
["conditions"] = {
},
["information"] = {
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
},
["HunterUtilFolder"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"HunterButton",
"HunterGroup",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["borderEdge"] = "Square Full White",
["border"] = false,
["yOffset"] = -289.9760131835938,
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
["authorOptions"] = {
},
["borderColor"] = {
0,
0,
0,
1,
},
["config"] = {
},
["regionType"] = "group",
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
["subeventPrefix"] = "SPELL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["names"] = {
},
["event"] = "Health",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
},
["parent"] = "ActionBarFolders",
["internalVersion"] = 89,
["xOffset"] = 679.50732421875,
["selfPoint"] = "CENTER",
["id"] = "HunterUtilFolder",
["borderOffset"] = 4,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
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
["uid"] = ")dYmr0w9uyl",
["alpha"] = 1,
["subRegions"] = {
},
["borderInset"] = 1,
["conditions"] = {
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
["information"] = {
},
},
["Health3"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["xOffset"] = 20,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -4,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
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
["use_health"] = false,
["use_raid_role"] = false,
["subeventSuffix"] = "_CAST_START",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["use_specific_unit"] = true,
["use_unit"] = true,
["spellIds"] = {
},
["use_ignoreDisconnected"] = false,
["names"] = {
},
["unit"] = "party3",
["use_percenthealth"] = false,
["use_maxhealth"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = 1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
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
["barColor"] = {
1,
0.207843154668808,
0,
1,
},
["desaturate"] = false,
["alpha"] = 1,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%1.health",
["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_n_format"] = "none",
["type"] = "subtext",
["text_shadowYOffset"] = -1,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.health_pad_mode"] = "left",
["text_anchorYOffset"] = 10,
["text_visible"] = true,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_text_format_1.health_format"] = "BigNumber",
["text_text_format_1.health_pad"] = false,
["anchor_point"] = "SPARK",
["text_fontSize"] = 10,
["anchorXOffset"] = 0,
["text_text_format_1.health_pad_max"] = 8,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%n %1.raidMark",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["text_text_format_1.raidMark_format"] = "none",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_anchorYOffset"] = 14,
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_fontType"] = "None",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_LEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["rotateText"] = "NONE",
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%2.level",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_2.level_format"] = "none",
["type"] = "subtext",
["text_anchorXOffset"] = -21,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_anchorYOffset"] = -13,
["text_visible"] = true,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_text_format_1.level_format"] = "none",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_BOTTOMLEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_shadowYOffset"] = -1,
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"4",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["sparkRotationMode"] = "MANUAL",
["barColor2"] = {
1,
1,
0,
1,
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["parent"] = "Party3",
["sparkColor"] = {
1,
1,
1,
1,
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["uid"] = "SI8xf9d2lns",
["height"] = 4,
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 10,
["texture"] = "Clean",
["zoom"] = 0,
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["spark"] = true,
["sparkHidden"] = "NEVER",
["id"] = "Health3",
["authorOptions"] = {
},
["frameStrata"] = 3,
["width"] = 180,
["iconSource"] = -1,
["config"] = {
},
["inverse"] = false,
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["value"] = "function()\n    return not UnitIsConnected(\"party3\")\nend",
["variable"] = "customcheck",
["trigger"] = -1,
},
["changes"] = {
{
["value"] = {
0.4549019932746887,
0.4549019932746887,
0.4549019932746887,
1,
},
["property"] = "barColor",
},
},
},
},
["information"] = {
},
["icon"] = false,
},
["xp"] = {
["displayText_format_1.percentXP_pad"] = false,
["displayText_format_1.percentXP_pad_max"] = 8,
["displayText_format_1.percentXP_format"] = "Number",
["authorOptions"] = {
},
["displayText"] = "%1.percentXP%%\n",
["yOffset"] = 350.8149719238281,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Experience",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "player",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["internalVersion"] = 89,
["wordWrap"] = "WordWrap",
["font"] = "Fira Sans Condensed Medium",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["fontSize"] = 13,
["shadowXOffset"] = 0,
["shadowYOffset"] = 0,
["displayText_format_p_time_mod_rate"] = true,
["regionType"] = "text",
["outline"] = "None",
["displayText_format_1.level_format"] = "none",
["conditions"] = {
},
["displayText_format_p_time_dynamic_threshold"] = 60,
["displayText_format_p_time_precision"] = 1,
["displayText_format_p_time_legacy_floor"] = false,
["uid"] = "O9jZ1QPpMyg",
["displayText_format_1.percentXP_pad_mode"] = "left",
["justify"] = "CENTER",
["displayText_format_1.percentXP_decimal_precision"] = 3,
["id"] = "xp",
["parent"] = "LVL Group",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["config"] = {
},
["selfPoint"] = "BOTTOM",
["color"] = {
1,
0.9294118285179138,
0.7882353663444519,
1,
},
["shadowColor"] = {
0.9803922176361084,
1,
0.1411764770746231,
0,
},
["fixedWidth"] = 200,
["information"] = {
},
["xOffset"] = -713,
},
["Mana Bar"] = {
["sparkWidth"] = 20,
["iconSource"] = -1,
["authorOptions"] = {
},
["preferToUpdate"] = true,
["yOffset"] = -26,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["textureInput"] = "Interface\\AddOns\\WACustomAssets\\StatBar2.tga",
["url"] = "Meow",
["backgroundColor"] = {
0,
0,
0,
1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["selfPoint"] = "CENTER",
["barColor"] = {
0.294117659330368,
0.5843137502670288,
1,
1,
},
["desaturate"] = false,
["sparkOffsetY"] = 0,
["gradientOrientation"] = "HORIZONTAL",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
["HUNTER"] = true,
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["smoothProgress"] = true,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["overlayclip"] = true,
["texture"] = "Solid",
["zoom"] = 0,
["spark"] = true,
["tocversion"] = 11502,
["alpha"] = 1,
["sparkColor"] = {
1,
1,
1,
0.636217474937439,
},
["sparkOffsetX"] = 0,
["wagoID"] = "zuOgFOlAp",
["parent"] = "BDO Player Bars",
["adjustedMin"] = "",
["sparkRotationMode"] = "AUTO",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_showCost"] = true,
["unit"] = "player",
["event"] = "Power",
["powertype"] = 0,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["use_unit"] = true,
["names"] = {
},
["use_powertype"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["version"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["border_offset"] = 1,
["type"] = "subborder",
["border_visible"] = true,
["border_color"] = {
0,
0,
0,
1,
},
["anchor_area"] = "bar",
["border_edge"] = "1 Pixel",
["border_size"] = 1,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%1.power/%1.maxpower",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_fixedWidth"] = 64,
["rotateText"] = "NONE",
["text_color"] = {
1,
1,
1,
1,
},
["text_text_format_1.power_pad_max"] = 8,
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_fontSize"] = 14,
["anchorXOffset"] = 0,
["text_text_format_1.maxpower_pad_mode"] = "left",
["text_text_format_1.percentpower_decimal_precision"] = 0,
["text_text_format_1.power_round_type"] = "floor",
["text_text_format_n_pad"] = false,
["text_text_format_1.power_decimal_precision"] = 0,
["text_text_format_1.power_pad_mode"] = "left",
["text_text_format_1.percentpower_pad"] = false,
["text_text_format_1.maxpower_round_type"] = "floor",
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_text_format_1.maxpower_pad"] = false,
["text_text_format_1.percentpower_pad_max"] = 8,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["text_visible"] = true,
["text_text_format_1.maxpower_format"] = "Number",
["text_text_format_1.maxpower_pad_max"] = 8,
["type"] = "subtext",
["text_text_format_1.power_pad"] = false,
["text_anchorXOffset"] = -2,
["text_text_format_1.percentpower_pad_mode"] = "left",
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.percentpower_round_type"] = "floor",
["text_anchorYOffset"] = -17,
["text_text_format_1.percentpower_format"] = "Number",
["text_text_format_1.power_format"] = "Number",
["text_text_format_n_decimal_precision"] = 0,
["text_text_format_n_format"] = "Number",
["text_text_format_n_round_type"] = "floor",
["anchor_point"] = "SPARK",
["text_text_format_n_pad_max"] = 8,
["text_text_format_n_pad_mode"] = "left",
["text_text_format_1.maxpower_decimal_precision"] = 0,
},
},
["height"] = 12,
["textureSource"] = "Picker",
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["config"] = {
},
["icon_side"] = "RIGHT",
["barColor2"] = {
0.5254902243614197,
0.5254902243614197,
0.5254902243614197,
1,
},
["adjustedMax"] = "",
["sparkHeight"] = 28,
["xOffset"] = 0,
["overlaysTexture"] = {
"Details Flat",
},
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWAPlayerProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"player\")\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nif PlayerFrame then\n    PlayerFrame:Hide()\nend",
},
["finish"] = {
},
},
["semver"] = "1.0.0",
["sparkHidden"] = "NEVER",
["id"] = "Mana Bar",
["uid"] = "eluUobPPtrZ",
["frameStrata"] = 1,
["width"] = 700,
["anchorFrameType"] = "SCREEN",
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["inverse"] = false,
["icon"] = false,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["value"] = 3,
["op"] = "==",
},
["changes"] = {
{
["value"] = {
1,
0.7411764860153198,
0,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["op"] = "==",
["value"] = 1,
},
["changes"] = {
{
["value"] = {
0.5882353186607361,
0.03921568766236305,
0,
1,
},
["property"] = "barColor",
},
},
},
},
["information"] = {
["showNilIsFalse"] = true,
},
["overlays"] = {
{
0.95294123888016,
1,
0.99215692281723,
1,
},
},
},
["Party0"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"BG0",
"SoundAlert0",
"ClickBox0",
"Power0",
"Health0",
"ClassIcon0",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["borderEdge"] = "Square Full White",
["border"] = false,
["yOffset"] = 0,
["regionType"] = "group",
["borderSize"] = 2,
["xOffset"] = 0,
["borderColor"] = {
0,
0,
0,
1,
},
["uid"] = "qv02cI2eW7B",
["anchorPoint"] = "CENTER",
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
["authorOptions"] = {
},
["internalVersion"] = 89,
["parent"] = "BDOPartyFrame",
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
["id"] = "Party0",
["borderOffset"] = 4,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["config"] = {
},
["alpha"] = 1,
["subRegions"] = {
},
["borderInset"] = 1,
["conditions"] = {
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
["information"] = {
},
},
["BDO Cooldowns"] = {
["controlledChildren"] = {
"CooldownGroup",
},
["borderBackdrop"] = "Blizzard Tooltip",
["authorOptions"] = {
},
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["borderColor"] = {
0,
0,
0,
1,
},
["url"] = "Meow",
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["internalVersion"] = 89,
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
["config"] = {
},
["parent"] = "BDO UI Overhaul",
["id"] = "BDO Cooldowns",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = 0,
["uid"] = "4tCjhV4L3sF",
["borderInset"] = 1,
["groupIcon"] = 132311,
["conditions"] = {
},
["information"] = {
},
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
},
["Point 5"] = {
["user_y"] = 0,
["user_x"] = 0,
["xOffset"] = 80,
["adjustedMax"] = "5",
["adjustedMin"] = "4",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["desaturateBackground"] = false,
["sameTexture"] = false,
["desaturateForeground"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_unit"] = true,
["class"] = "ROGUE",
["use_requirePowerType"] = false,
["unit"] = "player",
["use_class"] = true,
["powertype"] = 4,
["spellIds"] = {
},
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["endAngle"] = 360,
["internalVersion"] = 89,
["progressSource"] = {
1,
"power",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["uid"] = "M1M(kv9k)uO",
["parent"] = "Combo Points",
["rotation"] = 0,
["font"] = "Friz Quadrata TT",
["foregroundColor"] = {
1,
1,
1,
1,
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 20,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["preferToUpdate"] = true,
["useAdjustededMax"] = true,
["fontSize"] = 12,
["authorOptions"] = {
},
["startAngle"] = 0,
["crop_y"] = 0.41,
["config"] = {
},
["mirror"] = false,
["useAdjustededMin"] = true,
["regionType"] = "progresstexture",
["backgroundColor"] = {
0.501960813999176,
0.501960813999176,
0.501960813999176,
1,
},
["blendMode"] = "BLEND",
["width"] = 20,
["frameStrata"] = 1,
["slantMode"] = "INSIDE",
["backgroundTexture"] = "ClassOverlay-ComboPoint-Off",
["compress"] = false,
["smoothProgress"] = true,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom_load"] = true,
["custom"] = "if ComboFrame then\n    ComboFrame:Hide()\n    ComboFrame:UnregisterAllEvents()\nend",
["do_custom"] = true,
},
},
["tocversion"] = 11508,
["id"] = "Point 5",
["foregroundTexture"] = "ComboPoints-ComboPoint",
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["auraRotation"] = 0,
["inverse"] = false,
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["orientation"] = "VERTICAL",
["crop_x"] = 0.41,
["information"] = {
},
["backgroundOffset"] = 2,
},
["SoundAlert4"] = {
["parent"] = "Party4",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["information"] = {
},
["authorOptions"] = {
},
["actions"] = {
["start"] = {
["sound_kit_id"] = "727",
["sound_path"] = "727",
["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\wilhelm.ogg",
["do_sound"] = true,
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
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"30",
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["unit"] = "party4",
["names"] = {
},
["spellIds"] = {
},
["use_specific_unit"] = true,
["use_unit"] = true,
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["xOffset"] = 0,
["internalVersion"] = 89,
["alpha"] = 1,
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
["id"] = "SoundAlert4",
["width"] = 200,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["uid"] = "U90a7zjLQtm",
["config"] = {
},
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["regionType"] = "empty",
},
["SoundAlert0"] = {
["authorOptions"] = {
},
["yOffset"] = 0,
["regionType"] = "empty",
["information"] = {
},
["xOffset"] = 0,
["actions"] = {
["start"] = {
["sound_kit_id"] = "727",
["sound_path"] = "727",
["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\wilhelm.ogg",
["do_sound"] = false,
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
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"30",
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["unit"] = "Player",
["names"] = {
},
["spellIds"] = {
},
["use_specific_unit"] = true,
["use_unit"] = true,
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["anchorPoint"] = "CENTER",
["internalVersion"] = 89,
["alpha"] = 1,
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
["id"] = "SoundAlert0",
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["width"] = 200,
["uid"] = "BWviQmON(y)",
["config"] = {
},
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["parent"] = "Party0",
},
["CooldownGroup"] = {
["grow"] = "GRID",
["controlledChildren"] = {
"GCD Only Spells",
"Arcane Shot",
"Raptor Strike",
"Multishot",
"ConcussiveShot",
"Disengage",
"Rapid Fire",
"Feign Death",
"Intimidation",
"Bestial Wrath",
"Scare Beast",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = -219.6551513671875,
["yOffset"] = 10.27130126953125,
["anchorPoint"] = "CENTER",
["borderColor"] = {
0,
0,
0,
1,
},
["space"] = 2,
["url"] = "Meow",
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["columnSpace"] = 1,
["radius"] = 200,
["selfPoint"] = "TOPLEFT",
["align"] = "CENTER",
["stagger"] = 0,
["authorOptions"] = {
},
["subRegions"] = {
},
["borderInset"] = 1,
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
["parent"] = "BDO Cooldowns",
["backdropColor"] = {
1,
1,
1,
0.5,
},
["rotation"] = 0,
["animate"] = false,
["gridType"] = "DR",
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "dynamicgroup",
["borderSize"] = 2,
["limit"] = 6,
["sort"] = "none",
["useLimit"] = false,
["constantFactor"] = "RADIUS",
["arcLength"] = 360,
["borderOffset"] = 4,
["gridWidth"] = 4,
["rowSpace"] = 1,
["id"] = "CooldownGroup",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["stepAngle"] = 15,
["uid"] = "lteC65AoS2)",
["fullCircle"] = true,
["internalVersion"] = 89,
["conditions"] = {
},
["information"] = {
},
["config"] = {
},
},
["Health1"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["parent"] = "Party1",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -4,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_raid_role"] = false,
["use_maxhealth"] = false,
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["use_unit"] = true,
["use_ignoreDisconnected"] = false,
["spellIds"] = {
},
["names"] = {
},
["unit"] = "party1",
["use_percenthealth"] = false,
["use_specific_unit"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = 1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
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
["barColor"] = {
1,
0.207843154668808,
0,
1,
},
["desaturate"] = false,
["alpha"] = 1,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%1.health",
["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_n_format"] = "none",
["type"] = "subtext",
["text_shadowYOffset"] = -1,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.health_pad_mode"] = "left",
["text_anchorYOffset"] = 10,
["text_visible"] = true,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_text_format_1.health_format"] = "BigNumber",
["text_text_format_1.health_pad"] = false,
["anchor_point"] = "SPARK",
["text_fontSize"] = 10,
["anchorXOffset"] = 0,
["text_text_format_1.health_pad_max"] = 8,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%n %1.raidMark",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = -1,
["text_anchorYOffset"] = 14,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_fontType"] = "None",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_LEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_text_format_1.raidMark_format"] = "none",
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%2.level",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_2.level_format"] = "none",
["type"] = "subtext",
["text_anchorXOffset"] = -21,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = -1,
["text_fontType"] = "None",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_text_format_1.level_format"] = "none",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_BOTTOMLEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_anchorYOffset"] = -13,
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["xOffset"] = 20,
["barColor2"] = {
1,
1,
0,
1,
},
["sparkRotationMode"] = "MANUAL",
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["uid"] = "7X6vyAzKyGQ",
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["config"] = {
},
["height"] = 4,
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 10,
["texture"] = "Clean",
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["zoom"] = 0,
["spark"] = true,
["sparkHidden"] = "NEVER",
["id"] = "Health1",
["authorOptions"] = {
},
["frameStrata"] = 3,
["width"] = 180,
["iconSource"] = -1,
["sparkColor"] = {
1,
1,
1,
1,
},
["inverse"] = false,
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["value"] = "function()\n    return not UnitIsConnected(\"party1\")\nend",
["variable"] = "customcheck",
["trigger"] = -1,
},
["changes"] = {
{
["value"] = {
0.4549019932746887,
0.4549019932746887,
0.4549019932746887,
1,
},
["property"] = "barColor",
},
},
},
},
["information"] = {
},
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
},
["Arcane Shot"] = {
["iconSource"] = 1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["use_genericShowOn"] = true,
["genericShowOn"] = "showOnCooldown",
["names"] = {
},
["use_showgcd"] = true,
["debuffType"] = "HELPFUL",
["type"] = "spell",
["subeventSuffix"] = "_CAST_START",
["event"] = "Cooldown Progress (Spell)",
["use_exact_spellName"] = false,
["use_spellName"] = true,
["spellIds"] = {
},
["use_remaining"] = false,
["spellName"] = 14282,
["subeventPrefix"] = "SPELL",
["use_track"] = true,
["unit"] = "player",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["xOffset"] = 0,
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
["useAdjustededMin"] = false,
["regionType"] = "icon",
["url"] = "Meow",
["useTooltip"] = true,
["cooldown"] = true,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
["do_sound"] = true,
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound_channel"] = "SFX",
},
},
["config"] = {
},
["cooldownTextDisabled"] = false,
["zoom"] = 0,
["width"] = 26,
["useCooldownModRate"] = true,
["id"] = "Arcane Shot",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["keepAspectRatio"] = false,
["uid"] = "ZN1M4iAv4sN",
["inverse"] = false,
["parent"] = "CooldownGroup",
["conditions"] = {
},
["information"] = {
},
["authorOptions"] = {
},
},
["Track Beasts"] = {
["texXOffset"] = 0,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["custom"] = "function(event, show)\n    return show\nend",
["spellIds"] = {
},
["events"] = "TOGGLE_HUNTER_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["debuffType"] = "HELPFUL",
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["spellName"] = 1494,
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["color"] = {
1,
1,
1,
1,
},
["actions"] = {
["start"] = {
["sound"] = " custom",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["do_custom"] = false,
["sound_path"] = "567461",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Track Beasts\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(1494) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["xOffset"] = 0,
["progressSource"] = {
-1,
"",
},
["cooldown"] = false,
["displayIcon"] = 132328,
["config"] = {
},
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration_type"] = "seconds",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["preset"] = "spiral",
["scalex"] = 1,
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["translateType"] = "straightTranslate",
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["colorR"] = 1,
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["scalex"] = 1,
},
},
["cooldownTextDisabled"] = false,
["width"] = 30,
["useCooldownModRate"] = true,
["id"] = "Track Beasts",
["zoom"] = 0,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["uid"] = "vaa)(rfYYkm",
["inverse"] = false,
["iconSource"] = -1,
["conditions"] = {
},
["information"] = {
},
["parent"] = "HunterGroup",
},
["EnemyHPSlow"] = {
["sparkWidth"] = 15,
["iconSource"] = -1,
["authorOptions"] = {
},
["preferToUpdate"] = false,
["yOffset"] = -15.09155218920735,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["url"] = "Meow",
["backgroundColor"] = {
0,
0,
0,
1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["selfPoint"] = "CENTER",
["barColor"] = {
1,
0.9568628072738647,
0.9686275124549866,
1,
},
["desaturate"] = false,
["ignoreWagoUpdate"] = true,
["sparkOffsetY"] = 0.1,
["gradientOrientation"] = "HORIZONTAL",
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["use_alive"] = true,
["class"] = {
["single"] = "HUNTER",
["multi"] = {
["HUNTER"] = true,
},
},
["size"] = {
["multi"] = {
},
},
},
["smoothProgress"] = true,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["overlayclip"] = true,
["texture"] = "Solid",
["zoom"] = 0,
["spark"] = false,
["tocversion"] = 11502,
["alpha"] = 1,
["sparkColor"] = {
1,
1,
1,
0.6447645425796509,
},
["sparkOffsetX"] = 0.1,
["wagoID"] = "zuOgFOlAp",
["parent"] = "BDO Target Bar",
["adjustedMin"] = "",
["sparkRotationMode"] = "MANUAL",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_maxhealth"] = false,
["subeventPrefix"] = "SPELL",
["use_showCost"] = true,
["use_unit"] = true,
["names"] = {
},
["powertype"] = 0,
["spellIds"] = {
},
["unit"] = "target",
["event"] = "Health",
["use_percenthealth"] = false,
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["version"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
},
["height"] = 18.56317138671875,
["textureSource"] = "LSM",
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["overlays"] = {
{
0.95294123888016,
1,
0.99215692281723,
1,
},
},
["icon_side"] = "RIGHT",
["information"] = {
["showNilIsFalse"] = true,
},
["adjustedMax"] = "",
["sparkHeight"] = 33,
["xOffset"] = 0,
["overlaysTexture"] = {
"Details Flat",
},
["icon"] = false,
["semver"] = "1.0.0",
["id"] = "EnemyHPSlow",
["sparkHidden"] = "NEVER",
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["uid"] = "CRL3HyXwawi",
["width"] = 584.0000610351562,
["inverse"] = false,
["config"] = {
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
},
["barColor2"] = {
0.5254902243614197,
0.5254902243614197,
0.5254902243614197,
1,
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWATargetProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"target\")\n\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nRegisterUnitWatch(btn) \n\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nlocal bg = btn:CreateTexture(nil, \"BACKGROUND\")\nbg:SetAllPoints(btn)\nbg:SetColorTexture(0, 0, 0, 0)\n\nif TargetFrame then\n    TargetFrame:Hide()\nend",
},
},
},
["LVL Group"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"LVL",
"LvlTxt",
"xp",
"BG",
},
["borderBackdrop"] = "Blizzard Tooltip",
["parent"] = "BDO XP",
["yOffset"] = 7.11102294921875,
["border"] = false,
["borderEdge"] = "Square Full White",
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
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
["borderColor"] = {
0,
0,
0,
1,
},
["scale"] = 1,
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["regionType"] = "group",
["internalVersion"] = 89,
["authorOptions"] = {
},
["selfPoint"] = "CENTER",
["id"] = "LVL Group",
["xOffset"] = -9.48114013671875,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["borderOffset"] = 4,
["borderInset"] = 1,
["uid"] = "arlDb8cUrd5",
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
["alpha"] = 1,
["conditions"] = {
},
["information"] = {
},
["config"] = {
},
},
["PlayerBarClickbox"] = {
["authorOptions"] = {
},
["preferToUpdate"] = true,
["yOffset"] = -0.718284970202312,
["anchorPoint"] = "CENTER",
["url"] = "Meow",
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "if _G[\"MyWAPlayerProxy\"] then return end\n\nif InCombatLockdown() then\n    local f = CreateFrame(\"Frame\")\n    f:RegisterEvent(\"PLAYER_REGEN_ENABLED\")\n    f:SetScript(\"OnEvent\", function(self)\n            if aura_env.region.OnInitialize then\n                aura_env.region:OnInitialize()\n            end\n            self:UnregisterAllEvents()\n    end)\n    return \nend\n\nlocal region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWAPlayerProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"player\")\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nbtn:SetFrameStrata(\"LOW\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nif PlayerFrame then\n    PlayerFrame:UnregisterAllEvents()\n    --PlayerFrame:Hide()\nend",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["names"] = {
},
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["rotation"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 79.54887390136719,
["rotate"] = false,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["mirror"] = false,
["regionType"] = "texture",
["blendMode"] = "BLEND",
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
["config"] = {
},
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
["id"] = "PlayerBarClickbox",
["alpha"] = 0,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["width"] = 1023,
["uid"] = "eRqNbf2q(BS",
["color"] = {
1,
1,
1,
1,
},
["parent"] = "BDO Player Bars",
["conditions"] = {
},
["information"] = {
},
["xOffset"] = -0.000332919022064533,
},
["Dismiss Pet"] = {
["texXOffset"] = 0,
["xOffset"] = 0,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["do_custom"] = false,
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound_path"] = "567461",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Dismiss Pet\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(2641) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["spellIds"] = {
},
["custom"] = "function(event, show)\n    return show\nend",
["events"] = "TOGGLE_PET_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_class"] = true,
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["icon"] = true,
["authorOptions"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration_type"] = "seconds",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["preset"] = "spiral",
["scalex"] = 1,
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["translateType"] = "straightTranslate",
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["colorR"] = 1,
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["scalex"] = 1,
},
},
["cooldown"] = false,
["displayIcon"] = 136095,
["config"] = {
},
["iconSource"] = -1,
["cooldownTextDisabled"] = false,
["width"] = 30,
["useCooldownModRate"] = true,
["id"] = "Dismiss Pet",
["zoom"] = 0,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["uid"] = "pi4TMJ0(bwS",
["inverse"] = false,
["color"] = {
1,
1,
1,
1,
},
["conditions"] = {
},
["information"] = {
},
["parent"] = "PetGroup",
},
["SoundAlert2"] = {
["authorOptions"] = {
},
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["information"] = {
},
["parent"] = "Party2",
["actions"] = {
["start"] = {
["sound_kit_id"] = "727",
["sound_path"] = "727",
["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\wilhelm.ogg",
["do_sound"] = true,
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
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"30",
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["unit"] = "party2",
["names"] = {
},
["spellIds"] = {
},
["use_specific_unit"] = true,
["use_unit"] = true,
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["xOffset"] = 0,
["internalVersion"] = 89,
["alpha"] = 1,
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
["id"] = "SoundAlert2",
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["width"] = 200,
["config"] = {
},
["uid"] = "YDlMHtCA4wi",
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["regionType"] = "empty",
},
["LVL"] = {
["outline"] = "None",
["authorOptions"] = {
},
["displayText"] = "%1.level",
["shadowYOffset"] = 0,
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
["subeventSuffix"] = "_CAST_START",
["event"] = "Experience",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["internalVersion"] = 89,
["selfPoint"] = "BOTTOM",
["font"] = "Fira Sans Condensed Medium",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["fontSize"] = 42,
["shadowXOffset"] = 0,
["regionType"] = "text",
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
["displayText_format_1.level_format"] = "none",
["displayText_format_p_time_legacy_floor"] = false,
["displayText_format_p_time_precision"] = 1,
["fixedWidth"] = 200,
["parent"] = "LVL Group",
["color"] = {
1,
0.9098039865493774,
0.8078432083129883,
1,
},
["justify"] = "CENTER",
["xOffset"] = -714.2715034484863,
["id"] = "LVL",
["uid"] = "N7vvOIq49mA",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["yOffset"] = 359.5064392089844,
["config"] = {
},
["wordWrap"] = "WordWrap",
["displayText_format_p_time_dynamic_threshold"] = 60,
["shadowColor"] = {
0.9803922176361084,
1,
0.1411764770746231,
0,
},
["conditions"] = {
},
["information"] = {
},
["displayText_format_p_time_mod_rate"] = true,
},
["TargetPVP"] = {
["outline"] = "OUTLINE",
["authorOptions"] = {
},
["displayText"] = "%c",
["customText"] = "function()\n    if UnitExists(\"target\") then\n        local reaction = UnitReaction(\"target\", \"player\")\n        local isPlayer = UnitIsPlayer(\"target\")\n        local isPVP = UnitIsPVP(\"target\")\n        \n        -- Check if it's an enemy or neutral (Reaction 1-4)\n        if reaction and reaction <= 4 then\n            if isPVP then\n                return \"PVP NPC\"\n            else\n                return \"\"\n            end\n        end\n        return \"\" -- Returns nothing if no target exists\n    end\nend",
["shadowYOffset"] = -1,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["use_unitisunit"] = false,
["use_hostility"] = false,
["use_character"] = false,
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["type"] = "unit",
["unit"] = "target",
["custom_type"] = "status",
["use_role"] = false,
["use_unit"] = true,
["event"] = "Unit Characteristics",
["factionID"] = 469,
["names"] = {
},
["spellIds"] = {
},
["events"] = "PLAYER_TARGET_CHANGED, UNIT_FACTION",
["unitisunit"] = "target",
["check"] = "event",
["use_factionID"] = true,
["subeventSuffix"] = "_CAST_START",
["classification"] = {
},
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["internalVersion"] = 89,
["selfPoint"] = "BOTTOM",
["font"] = "Friz Quadrata TT",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["fontSize"] = 20,
["shadowXOffset"] = 1,
["regionType"] = "text",
["conditions"] = {
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["displayText_format_c_format"] = "none",
["displayText_format_p_time_precision"] = 1,
["displayText_format_p_time_legacy_floor"] = false,
["displayText_format_p_time_mod_rate"] = true,
["wordWrap"] = "WordWrap",
["justify"] = "LEFT",
["config"] = {
},
["id"] = "TargetPVP",
["yOffset"] = 58,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = 0,
["uid"] = ")fc)qG6kEo2",
["color"] = {
1,
0.01568627543747425,
0,
1,
},
["displayText_format_p_time_dynamic_threshold"] = 60,
["shadowColor"] = {
0,
0,
0,
1,
},
["fixedWidth"] = 200,
["information"] = {
},
["parent"] = "BDO Target Bar",
},
["TargetBuffs"] = {
["grow"] = "LEFT",
["controlledChildren"] = {
"Icons 4",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = 278.6983874820076,
["yOffset"] = -58.84,
["gridType"] = "RD",
["borderColor"] = {
0,
0,
0,
1,
},
["space"] = 2,
["url"] = "Meow",
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["columnSpace"] = 1,
["internalVersion"] = 89,
["selfPoint"] = "RIGHT",
["align"] = "CENTER",
["rotation"] = 0,
["ignoreWagoUpdate"] = true,
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
["subRegions"] = {
},
["borderInset"] = 1,
["anchorPoint"] = "CENTER",
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
["authorOptions"] = {
},
["backdropColor"] = {
1,
1,
1,
0.5,
},
["parent"] = "BDO Target Bar",
["animate"] = false,
["useLimit"] = false,
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "dynamicgroup",
["borderSize"] = 2,
["sort"] = "none",
["fullCircle"] = true,
["limit"] = 5,
["constantFactor"] = "RADIUS",
["arcLength"] = 360,
["borderOffset"] = 4,
["gridWidth"] = 5,
["rowSpace"] = 1,
["id"] = "TargetBuffs",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["stagger"] = 0,
["uid"] = "3MyDmAxysxa",
["config"] = {
},
["stepAngle"] = 15,
["conditions"] = {
},
["information"] = {
},
["radius"] = 200,
},
["AudioAndFX 3"] = {
["xOffset"] = -0.7901234944661458,
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["information"] = {
},
["authorOptions"] = {
},
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_YOffset"] = -1,
["glow_XOffset"] = -1,
["do_glow"] = true,
["do_sound"] = true,
["glow_frame"] = "WeakAuras:ProfessionButton",
["sound_path"] = "567461",
["glow_type"] = "ACShine",
["sound"] = " custom",
["glow_action"] = "show",
},
["init"] = {
},
["finish"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["hide_all_glows"] = true,
["glow_action"] = "show",
["glow_type"] = "ACShine",
["glow_frame"] = "HunterAnchorBtn",
["do_glow"] = false,
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["custom"] = "function(event, show)\n    return show\nend",
["spellIds"] = {
},
["events"] = "TOGGLE_PROF_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["regionType"] = "empty",
["internalVersion"] = 89,
["alpha"] = 1,
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
["id"] = "AudioAndFX 3",
["width"] = 200,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["uid"] = "lRsQpegHSmS",
["config"] = {
},
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["parent"] = "ProfessionsGroup",
},
["Point 3"] = {
["user_y"] = 0,
["user_x"] = 0,
["xOffset"] = 0,
["adjustedMax"] = "3",
["adjustedMin"] = "2",
["yOffset"] = 0,
["foregroundColor"] = {
1,
1,
1,
1,
},
["desaturateBackground"] = false,
["sameTexture"] = false,
["desaturateForeground"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_unit"] = true,
["class"] = "ROGUE",
["use_requirePowerType"] = false,
["unit"] = "player",
["use_class"] = true,
["powertype"] = 4,
["spellIds"] = {
},
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["endAngle"] = 360,
["internalVersion"] = 89,
["progressSource"] = {
1,
"power",
},
["selfPoint"] = "CENTER",
["uid"] = "c0Ya4hC793t",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom_load"] = true,
["custom"] = "if ComboFrame then\n    ComboFrame:Hide()\n    ComboFrame:UnregisterAllEvents()\nend",
["do_custom"] = true,
},
},
["rotation"] = 0,
["font"] = "Friz Quadrata TT",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 20,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["preferToUpdate"] = true,
["useAdjustededMax"] = true,
["backgroundTexture"] = "ClassOverlay-ComboPoint-Off",
["parent"] = "Combo Points",
["startAngle"] = 0,
["foregroundTexture"] = "ComboPoints-ComboPoint",
["config"] = {
},
["mirror"] = false,
["useAdjustededMin"] = true,
["regionType"] = "progresstexture",
["crop_y"] = 0.41,
["blendMode"] = "BLEND",
["width"] = 20,
["frameStrata"] = 1,
["slantMode"] = "INSIDE",
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["compress"] = false,
["smoothProgress"] = true,
["backgroundColor"] = {
0.501960813999176,
0.501960813999176,
0.501960813999176,
1,
},
["tocversion"] = 11508,
["id"] = "Point 3",
["fontSize"] = 12,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["anchorPoint"] = "CENTER",
["auraRotation"] = 0,
["inverse"] = false,
["authorOptions"] = {
},
["orientation"] = "VERTICAL",
["crop_x"] = 0.41,
["information"] = {
},
["backgroundOffset"] = 2,
},
["Combo Points"] = {
["controlledChildren"] = {
"Point 1",
"Point 2",
"Point 3",
"Point 4",
"Point 5",
},
["borderBackdrop"] = "Blizzard Tooltip",
["parent"] = "BDO Player Bars",
["preferToUpdate"] = true,
["yOffset"] = -50,
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
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["internalVersion"] = 89,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["subRegions"] = {
},
["load"] = {
["talent"] = {
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
["size"] = {
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
["selfPoint"] = "CENTER",
["tocversion"] = 11508,
["id"] = "Combo Points",
["xOffset"] = 0,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["uid"] = "YO5kcwvT4Ln",
["config"] = {
},
["borderInset"] = 1,
["conditions"] = {
},
["information"] = {
},
["authorOptions"] = {
},
},
["BG0"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["xOffset"] = -20,
["desaturate"] = false,
["color"] = {
0,
0,
0,
1,
},
["authorOptions"] = {
},
["mirror"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["parent"] = "Party0",
["rotate"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
["finish"] = {
},
},
["texture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_AlphaGradient.tga",
["triggers"] = {
{
["trigger"] = {
["use_factionID"] = true,
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["type"] = "unit",
["spellIds"] = {
},
["names"] = {
},
["unit"] = "player",
["use_unit"] = true,
["use_specific_unit"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["config"] = {
},
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
["id"] = "BG0",
["selfPoint"] = "CENTER",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["uid"] = "(Fht4x7JFaC",
["alpha"] = 0.6,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 40,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "percenthealth",
["value"] = "50",
["op"] = "<=",
},
["changes"] = {
{
["value"] = {
1,
0,
0.01568627543747425,
1,
},
["property"] = "color",
},
},
},
},
["information"] = {
},
["width"] = 310,
},
["AudioAndFX 2"] = {
["xOffset"] = 0,
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["regionType"] = "empty",
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_YOffset"] = -1,
["glow_XOffset"] = -1,
["do_glow"] = true,
["glow_action"] = "show",
["do_sound"] = true,
["sound"] = " custom",
["glow_type"] = "ACShine",
["sound_path"] = "Sound\\Creature\\Cat\\CatDeath.ogg",
["glow_frame"] = "PetAnchorBtn",
},
["finish"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["hide_all_glows"] = true,
["glow_action"] = "show",
["glow_type"] = "ACShine",
["do_glow"] = false,
["glow_frame"] = "HunterAnchorBtn",
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["custom"] = "function(event, show)\n    return show\nend",
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_PET_MENU",
["spellIds"] = {
},
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["authorOptions"] = {
},
["internalVersion"] = 89,
["frameStrata"] = 1,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "AudioAndFX 2",
["width"] = 200,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["config"] = {
},
["uid"] = "hhTbkJaLPy)",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["information"] = {
},
["parent"] = "PetGroup",
},
["BG"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["color"] = {
1,
1,
1,
0.1319443583488464,
},
["anchorFrameType"] = "SCREEN",
["parent"] = "LVL Group",
["authorOptions"] = {
},
["mirror"] = false,
["yOffset"] = 377.6792697906494,
["regionType"] = "texture",
["information"] = {
},
["blendMode"] = "BLEND",
["anchorPoint"] = "CENTER",
["xOffset"] = -710.7160758972168,
["rotate"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["texture"] = "SquareMask",
["internalVersion"] = 89,
["config"] = {
},
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
["id"] = "BG",
["selfPoint"] = "CENTER",
["frameStrata"] = 1,
["width"] = 66.37039947509766,
["rotation"] = 0,
["uid"] = "EFChkcZy1GP",
["alpha"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["border_offset"] = 4,
["type"] = "subborder",
["border_color"] = {
1,
1,
1,
0.1319443583488464,
},
["border_visible"] = false,
["border_edge"] = "Blizzard Chat Bubble",
["border_size"] = 25,
},
},
["height"] = 62.4199104309082,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["desaturate"] = false,
},
["New 3"] = {
["parent"] = "LowHPVignette",
["preferToUpdate"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["actions"] = {
["start"] = {
["do_loop"] = true,
["message"] = "",
["do_message"] = false,
["do_sound"] = false,
["sound_path"] = "Interface\\AddOns\\LowHPVignette\\Sounds\\LowHPVignette\\LowHP.mp3",
["do_custom"] = false,
["sound"] = " custom",
["sound_channel"] = "SFX",
},
["init"] = {
},
["finish"] = {
["stop_sound"] = true,
["do_sound"] = false,
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"50",
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["unit"] = "player",
["spellIds"] = {
},
["names"] = {
},
["use_unit"] = true,
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Action Usable",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 5384,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["rotation"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 1200,
["rotate"] = false,
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
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["mirror"] = false,
["regionType"] = "texture",
["blendMode"] = "ADD",
["texture"] = "PhotosensitivityWarning-vignette",
["uid"] = "Z5R3Gryoqrs",
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeIn",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["duration"] = ".25",
["colorA"] = 1,
["rotate"] = 0,
["easeStrength"] = 3,
["preset"] = "fade",
["scalex"] = 1,
},
["main"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "alphaPulse",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    local angle = (progress * 2 * math.pi) - (math.pi / 2)\n    return start + (((math.sin(angle) + 1)/2) * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["scaley"] = 1,
["alpha"] = 0.7000000000000001,
["y"] = 0,
["x"] = 0,
["duration"] = ".75",
["scalex"] = 1,
["easeStrength"] = 3,
["rotate"] = 0,
["preset"] = "pulse",
["colorA"] = 1,
},
["finish"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOut",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["rotate"] = 0,
["duration"] = "1",
["scalex"] = 1,
},
},
["tocversion"] = 11508,
["id"] = "New 3",
["width"] = 2000,
["alpha"] = 1,
["anchorFrameType"] = "UIPARENT",
["frameStrata"] = 2,
["config"] = {
},
["authorOptions"] = {
},
["color"] = {
1,
0,
0.007843137718737125,
1,
},
["conditions"] = {
},
["information"] = {
},
["xOffset"] = 0,
},
["Multishot"] = {
["iconSource"] = 1,
["parent"] = "CooldownGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["spellName"] = 2643,
["subeventSuffix"] = "_CAST_START",
["names"] = {
},
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["unit"] = "player",
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["genericShowOn"] = "showOnCooldown",
["use_exact_spellName"] = false,
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
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
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["selfPoint"] = "CENTER",
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
["do_sound"] = true,
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound_channel"] = "SFX",
},
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["url"] = "Meow",
["useTooltip"] = true,
["cooldown"] = true,
["authorOptions"] = {
},
["config"] = {
},
["zoom"] = 0,
["cooldownTextDisabled"] = false,
["width"] = 26,
["frameStrata"] = 1,
["id"] = "Multishot",
["alpha"] = 1,
["useCooldownModRate"] = true,
["anchorFrameType"] = "SCREEN",
["xOffset"] = 0,
["uid"] = "jlR0KqrUbe0",
["inverse"] = false,
["progressSource"] = {
-1,
"",
},
["conditions"] = {
},
["information"] = {
},
["color"] = {
1,
1,
1,
1,
},
},
["Multi-Shot"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -155,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["sparkRotationMode"] = "AUTO",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "combatlog",
["spellId"] = {
14288,
},
["subeventSuffix"] = "_CAST_START",
["duration"] = "0.5",
["event"] = "Combat Log",
["subeventPrefix"] = "SPELL",
["use_spellId"] = true,
["spellIds"] = {
},
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["barColor"] = {
0.2745098173618317,
0.529411792755127,
1,
1,
},
["desaturate"] = false,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
},
["height"] = 4,
["textureSource"] = "LSM",
["load"] = {
["size"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["talent"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["sparkHidden"] = "NEVER",
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["barColor2"] = {
1,
1,
0,
1,
},
["enableGradient"] = false,
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["gradientOrientation"] = "HORIZONTAL",
["uid"] = "AzCCCVOb3Cs",
["icon_side"] = "RIGHT",
["sparkColor"] = {
1,
1,
1,
1,
},
["sparkHeight"] = 18,
["texture"] = "Solid",
["anchorFrameType"] = "SCREEN",
["zoom"] = 0,
["spark"] = false,
["alpha"] = 1,
["id"] = "Multi-Shot",
["xOffset"] = 6.103515625e-05,
["frameStrata"] = 1,
["width"] = 250,
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["config"] = {
},
["inverse"] = true,
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
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
},
["changes"] = {
{
},
},
},
},
["information"] = {
},
["iconSource"] = -1,
},
["ClickBox2"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["uid"] = "fMRE9NyP4X5",
["desaturate"] = false,
["parent"] = "Party2",
["color"] = {
1,
1,
1,
1,
},
["mirror"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"3",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["authorOptions"] = {
},
["xOffset"] = 0,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- 1. Create a unique name to avoid global conflicts\nlocal btnName = \"WA_PartyTargetBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\")\n\n-- 2. Cleanup old button if it exists (prevents button stacking on reloads)\nif aura_env.btn then\n    aura_env.btn:Hide()\nend\n\n-- 3. Create the Secure Button\n-- We parent it to aura_env.region so it moves/scales with the WeakAura\nlocal btn = CreateFrame(\"Button\", btnName, aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 4. Set the Attributes\n-- Note: These cannot be changed while in combat\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/target party2\")\n\n-- 5. Store in aura_env for persistence and cleanup\naura_env.btn = btn\n\n",
},
["finish"] = {
},
},
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
["rotate"] = false,
["internalVersion"] = 89,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_alwaystrue"] = true,
["subeventSuffix"] = "_CAST_START",
["use_itemName"] = true,
["use_genericShowOn"] = true,
["event"] = "Conditions",
["unit"] = "target",
["subeventPrefix"] = "SPELL",
["use_spellName"] = true,
["spellIds"] = {
},
["genericShowOn"] = "showOnCooldown",
["use_unit"] = true,
["names"] = {
},
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["selfPoint"] = "CENTER",
["id"] = "ClickBox2",
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
["alpha"] = 0,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["config"] = {
},
["frameStrata"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 44,
["conditions"] = {
},
["information"] = {
},
["width"] = 262,
},
["ClickBox4"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["uid"] = "F4MdEO4uRcq",
["desaturate"] = false,
["parent"] = "Party4",
["color"] = {
1,
1,
1,
1,
},
["mirror"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"5",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["xOffset"] = 0,
["authorOptions"] = {
},
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- 1. Create a unique name to avoid global conflicts\nlocal btnName = \"WA_PartyTargetBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\")\n\n-- 2. Cleanup old button if it exists (prevents button stacking on reloads)\nif aura_env.btn then\n    aura_env.btn:Hide()\nend\n\n-- 3. Create the Secure Button\n-- We parent it to aura_env.region so it moves/scales with the WeakAura\nlocal btn = CreateFrame(\"Button\", btnName, aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 4. Set the Attributes\n-- Note: These cannot be changed while in combat\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/target party4\")\n\n-- 5. Store in aura_env for persistence and cleanup\naura_env.btn = btn\n\n",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_alwaystrue"] = true,
["subeventSuffix"] = "_CAST_START",
["use_itemName"] = true,
["use_genericShowOn"] = true,
["event"] = "Conditions",
["unit"] = "target",
["subeventPrefix"] = "SPELL",
["use_spellName"] = true,
["spellIds"] = {
},
["genericShowOn"] = "showOnCooldown",
["use_unit"] = true,
["names"] = {
},
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["rotate"] = false,
["internalVersion"] = 89,
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
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
["id"] = "ClickBox4",
["selfPoint"] = "CENTER",
["alpha"] = 0,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["config"] = {
},
["frameStrata"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 44,
["conditions"] = {
},
["information"] = {
},
["width"] = 262,
},
["Fishing"] = {
["iconSource"] = -1,
["xOffset"] = 0,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["do_custom"] = false,
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound_path"] = "567461",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["finish"] = {
["sound_channel"] = "Master",
["sound_path"] = "567482",
["sound"] = " custom",
["do_sound"] = false,
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/equip Strong Fishing Pole\\n/cast Fishing\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(18248) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["custom"] = "function(event, show)\n    return show\nend",
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_PROF_MENU",
["spellIds"] = {
},
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 7620,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["preset"] = "spiral",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["scaley"] = 1,
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["useAdjustededMin"] = false,
["regionType"] = "icon",
["parent"] = "ProfessionsGroup",
["texXOffset"] = 0,
["information"] = {
},
["conditions"] = {
},
["uid"] = "Rl5ItP6BPZs",
["authorOptions"] = {
},
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["id"] = "Fishing",
["frameStrata"] = 1,
["useCooldownModRate"] = true,
["width"] = 30,
["zoom"] = 0,
["config"] = {
},
["inverse"] = false,
["icon"] = true,
["displayIcon"] = 136245,
["cooldown"] = false,
["color"] = {
1,
1,
1,
1,
},
},
["ProfessionsGroup"] = {
["grow"] = "UP",
["controlledChildren"] = {
"Leatherworking",
"Cooking",
"First Aid",
"Fishing",
"AudioAndFX 3",
},
["borderBackdrop"] = "Blizzard Collections Background",
["xOffset"] = -0.2352294921875,
["yOffset"] = 18.419921875,
["anchorPoint"] = "CENTER",
["borderColor"] = {
0,
0,
0,
1,
},
["space"] = 0,
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
["subeventPrefix"] = "SPELL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["names"] = {
},
["event"] = "Health",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
},
["columnSpace"] = 1,
["radius"] = 200,
["selfPoint"] = "BOTTOM",
["align"] = "CENTER",
["stagger"] = 0,
["fullCircle"] = true,
["subRegions"] = {
},
["borderInset"] = 3,
["gridType"] = "RD",
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
["backdropColor"] = {
0,
0,
0,
1,
},
["rotation"] = 0,
["animate"] = false,
["authorOptions"] = {
},
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Blizzard Chat Bubble",
["regionType"] = "dynamicgroup",
["borderSize"] = 5,
["limit"] = 5,
["sort"] = "none",
["useLimit"] = false,
["constantFactor"] = "RADIUS",
["arcLength"] = 360,
["borderOffset"] = 1,
["gridWidth"] = 5,
["rowSpace"] = 1,
["id"] = "ProfessionsGroup",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["stepAngle"] = 15,
["uid"] = "Rg)8s1ntWQT",
["parent"] = "ProfessionFolder",
["internalVersion"] = 89,
["conditions"] = {
},
["information"] = {
},
["config"] = {
},
},
["Eagle Eye"] = {
["iconSource"] = -1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_YOffset"] = -1,
["glow_XOffset"] = -1,
["sound_path"] = "Sound\\Item\\Weapons\\Bow\\BowRelease.ogg",
["do_custom"] = false,
["do_glow"] = false,
["glow_action"] = "show",
["do_sound"] = false,
["glow_frame"] = "WeakAuras:HunterButton",
["sound_kit_id"] = "567482",
["glow_type"] = "ACShine",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast !Eagle Eye\") -- Change this for the other icon\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(6197) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["hide_all_glows"] = false,
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "6006536",
["sound_channel"] = "Master",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["custom"] = "function(event, show)\n    return show\nend",
["spellIds"] = {
},
["events"] = "TOGGLE_HUNTER_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["debuffType"] = "HELPFUL",
["use_exact_spellName"] = false,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["spellName"] = 6197,
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scaley"] = 1,
["y"] = -10,
["x"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["scalex"] = 1,
["easeStrength"] = 3,
["scaley"] = 1,
["rotate"] = 0,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["texXOffset"] = 0,
["authorOptions"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["progressSource"] = {
-1,
"",
},
["icon"] = true,
["cooldown"] = false,
["displayIcon"] = 132172,
["config"] = {
},
["useCooldownModRate"] = true,
["cooldownTextDisabled"] = false,
["width"] = 30,
["frameStrata"] = 1,
["id"] = "Eagle Eye",
["zoom"] = 0,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["uid"] = "Hnq8HUg9wif",
["inverse"] = false,
["xOffset"] = -0.7901234944661458,
["conditions"] = {
},
["information"] = {
},
["parent"] = "HunterGroup",
},
["BG3"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["color"] = {
0,
0,
0,
1,
},
["anchorFrameType"] = "SCREEN",
["xOffset"] = -20,
["authorOptions"] = {
},
["mirror"] = false,
["yOffset"] = 0,
["regionType"] = "texture",
["information"] = {
},
["blendMode"] = "BLEND",
["anchorPoint"] = "CENTER",
["parent"] = "Party3",
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "percenthealth",
["op"] = "<=",
["value"] = "50",
},
["changes"] = {
{
["value"] = {
1,
0,
0.01568627543747425,
1,
},
["property"] = "color",
},
},
},
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["use_factionID"] = true,
["spellIds"] = {
},
["use_specific_unit"] = true,
["use_unit"] = true,
["unit"] = "party3",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["texture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_AlphaGradient.tga",
["internalVersion"] = 89,
["alpha"] = 0.6,
["selfPoint"] = "CENTER",
["id"] = "BG3",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["frameStrata"] = 1,
["desaturate"] = false,
["rotation"] = 0,
["uid"] = "F0xm4MOPIf9",
["config"] = {
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 40,
["rotate"] = false,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["width"] = 310,
},
["test"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["frameStrata"] = 1,
["color"] = {
1,
1,
1,
1,
},
["width"] = 200,
["mirror"] = false,
["yOffset"] = 0,
["regionType"] = "texture",
["xOffset"] = 0,
["blendMode"] = "BLEND",
["information"] = {
},
["anchorPoint"] = "CENTER",
["conditions"] = {
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "aura_env.hardLocked = false",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["debuffType"] = "HELPFUL",
["unit"] = "softenemy",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["spellIds"] = {
},
["events"] = "PLAYER_TARGET_CHANGED\nUPDATE_SOFT_ENEMY\nUNIT_TARGET",
["custom_type"] = "status",
["check"] = "update",
["custom"] = "function(event, ...)\n    if event == \"PLAYER_TARGET_CHANGED\" then\n        aura_env.hardLocked = UnitExists(\"target\") \n            and UnitCanAttack(\"player\", \"target\") \n            or false\n    end\n    return aura_env.hardLocked\nend",
["use_unit"] = true,
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, ...)\n    return not aura_env.hardLocked\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["authorOptions"] = {
},
["internalVersion"] = 89,
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
["selfPoint"] = "CENTER",
["id"] = "test",
["uid"] = "C)y0YqsSA99",
["alpha"] = 0.46,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["config"] = {
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 200,
["rotate"] = false,
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["desaturate"] = false,
},
["ActionBarFolders"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"PetFolder",
"ProfessionFolder",
"HunterUtilFolder",
},
["borderBackdrop"] = "Blizzard Tooltip",
["authorOptions"] = {
},
["groupIcon"] = 136011,
["border"] = false,
["borderEdge"] = "Square Full White",
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
["scale"] = 1,
["borderColor"] = {
0,
0,
0,
1,
},
["uid"] = "B66zLql5mGG",
["yOffset"] = -60,
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
["regionType"] = "group",
["borderOffset"] = 4,
["xOffset"] = 0,
["selfPoint"] = "CENTER",
["id"] = "ActionBarFolders",
["internalVersion"] = 89,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
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
["borderInset"] = 1,
["frameStrata"] = 1,
["subRegions"] = {
},
["config"] = {
},
["conditions"] = {
},
["information"] = {
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
},
["Power2"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -12,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["use_power"] = false,
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_maxhealth"] = false,
["spellIds"] = {
},
["unit"] = "party2",
["use_unit"] = true,
["use_percenthealth"] = false,
["use_powertype"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
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
["barColor"] = {
0.207843154668808,
0.658823549747467,
1,
1,
},
["desaturate"] = false,
["frameStrata"] = 3,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["border_size"] = 2,
["border_offset"] = 0,
["border_visible"] = false,
["border_color"] = {
1,
1,
1,
1,
},
["anchor_area"] = "bar",
["border_edge"] = "Square Full White",
["type"] = "subborder",
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"3",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["iconSource"] = -1,
["barColor2"] = {
1,
1,
0,
1,
},
["parent"] = "Party2",
["sparkRotationMode"] = "AUTO",
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["config"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["sparkColor"] = {
1,
1,
1,
1,
},
["height"] = 4,
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 30,
["texture"] = "Clean",
["xOffset"] = 20,
["zoom"] = 0,
["spark"] = false,
["id"] = "Power2",
["sparkHidden"] = "NEVER",
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["alpha"] = 1,
["width"] = 180,
["selfPoint"] = "CENTER",
["uid"] = "K)269Z8(TBX",
["inverse"] = false,
["internalVersion"] = 89,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = -1,
["op"] = "",
["value"] = "function()\n    return not UnitIsConnected(\"party2\")\nend",
["variable"] = "customcheck",
},
["changes"] = {
{
["value"] = {
0.4117647409439087,
0.4117647409439087,
0.4117647409439087,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["value"] = 1,
["op"] = "==",
},
["changes"] = {
{
["value"] = {
1,
0.5058823823928833,
0.07450980693101883,
1,
},
["property"] = "barColor",
},
},
},
},
["information"] = {
},
["backgroundColor"] = {
0,
0,
0,
0.5,
},
},
["ClassIcon1"] = {
["iconSource"] = -1,
["parent"] = "Party1",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
},
["triggers"] = {
{
["trigger"] = {
["use_namerealm"] = false,
["classification"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "party1",
["class"] = "HUNTER",
["event"] = "Unit Characteristics",
["use_specific_unit"] = true,
["use_class"] = false,
["type"] = "unit",
["spellIds"] = {
},
["names"] = {
},
["subeventPrefix"] = "SPELL",
["use_unit"] = true,
["use_unitisunit"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["desaturate"] = true,
["subRegions"] = {
{
["type"] = "subborder",
["border_offset"] = 2,
["border_color"] = {
0.6549019813537598,
0.6274510025978088,
0,
0.5849355757236481,
},
["border_visible"] = true,
["border_edge"] = "Blizzard Tooltip",
["border_size"] = 11,
},
{
["type"] = "subbackground",
},
},
["height"] = 37,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["useTooltip"] = false,
["icon"] = true,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["selfPoint"] = "CENTER",
["color"] = {
0.803921639919281,
0.803921639919281,
0.803921639919281,
0.7300000190734863,
},
["information"] = {
},
["displayIcon"] = 136095,
["uid"] = "achdh42Jxyb",
["frameStrata"] = 1,
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["alpha"] = 0.9,
["id"] = "ClassIcon1",
["cooldownTextDisabled"] = false,
["useCooldownModRate"] = true,
["width"] = 37,
["keepAspectRatio"] = false,
["config"] = {
},
["inverse"] = false,
["authorOptions"] = {
},
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "HUNTER",
},
["changes"] = {
{
["value"] = "626000",
["property"] = "displayIcon",
},
{
["value"] = {
0.3725490272045136,
0.6666666865348816,
0.388235330581665,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["op"] = "==",
["value"] = "DRUID",
["variable"] = "class",
},
["linked"] = true,
["changes"] = {
{
["value"] = "625999",
["property"] = "displayIcon",
},
{
["value"] = {
0.615686297416687,
0.2862745225429535,
0.1098039299249649,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "PRIEST",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626004",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.5843137502670288,
0.5843137502670288,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "ROGUE",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626005",
["property"] = "displayIcon",
},
{
["value"] = {
0.6705882549285889,
0.5529412031173706,
0.294117659330368,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "WARLOCK",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626007",
["property"] = "displayIcon",
},
{
["value"] = {
0.4000000357627869,
0.3764706254005432,
0.6549019813537598,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "WARRIOR",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626008",
["property"] = "displayIcon",
},
{
["value"] = {
0.5607843399047852,
0.2784313857555389,
0.2549019753932953,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "MAGE",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626001",
["property"] = "displayIcon",
},
{
["value"] = {
0.3254902064800263,
0.7215686440467834,
1,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "PALADIN",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626003",
["property"] = "displayIcon",
},
{
["value"] = {
0.572549045085907,
0.3333333432674408,
0.501960813999176,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "SHAMAN",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626006",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.501960813999176,
0.5372549295425415,
1,
},
["property"] = "color",
},
},
},
},
["cooldown"] = false,
["xOffset"] = -92,
},
["Bestial Wrath"] = {
["iconSource"] = 1,
["xOffset"] = 0,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
["do_sound"] = true,
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound_channel"] = "SFX",
},
},
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["spellName"] = 19574,
["subeventSuffix"] = "_CAST_START",
["names"] = {
},
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["unit"] = "player",
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["genericShowOn"] = "showOnCooldown",
["use_exact_spellName"] = false,
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["config"] = {
},
["authorOptions"] = {
},
["progressSource"] = {
-1,
"",
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["useTooltip"] = true,
["cooldown"] = true,
["conditions"] = {
},
["icon"] = true,
["useCooldownModRate"] = true,
["width"] = 26,
["zoom"] = 0,
["alpha"] = 1,
["color"] = {
1,
1,
1,
1,
},
["id"] = "Bestial Wrath",
["cooldownTextDisabled"] = false,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["parent"] = "CooldownGroup",
["uid"] = "c6W1D16nTVZ",
["inverse"] = false,
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
["displayIcon"] = 132127,
["information"] = {
},
["url"] = "Meow",
},
["SoundAlert3"] = {
["xOffset"] = 0,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["regionType"] = "empty",
["actions"] = {
["start"] = {
["sound_kit_id"] = "727",
["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\wilhelm.ogg",
["sound_path"] = "727",
["do_sound"] = true,
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"30",
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["unit"] = "party3",
["names"] = {
},
["spellIds"] = {
},
["use_specific_unit"] = true,
["use_unit"] = true,
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["parent"] = "Party3",
["internalVersion"] = 89,
["frameStrata"] = 1,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "SoundAlert3",
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["width"] = 200,
["selfPoint"] = "CENTER",
["config"] = {
},
["uid"] = "BiftYkPcIeL",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["information"] = {
},
["authorOptions"] = {
},
},
["RaceAndThreat"] = {
["grow"] = "HORIZONTAL",
["controlledChildren"] = {
"TargetRace",
"Threat",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = 0,
["yOffset"] = 8,
["anchorPoint"] = "CENTER",
["borderColor"] = {
0,
0,
0,
1,
},
["space"] = 2,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["names"] = {
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
},
["untrigger"] = {
},
},
},
["columnSpace"] = 1,
["radius"] = 200,
["selfPoint"] = "CENTER",
["align"] = "CENTER",
["stagger"] = 0,
["uid"] = ")Kyjy5GWD69",
["subRegions"] = {
},
["config"] = {
},
["rotation"] = 0,
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["authorOptions"] = {
},
["backdropColor"] = {
1,
1,
1,
0.5,
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["animate"] = false,
["internalVersion"] = 89,
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "dynamicgroup",
["borderSize"] = 2,
["limit"] = 5,
["gridType"] = "RD",
["stepAngle"] = 15,
["constantFactor"] = "RADIUS",
["arcLength"] = 360,
["borderOffset"] = 4,
["alpha"] = 1,
["frameStrata"] = 1,
["id"] = "RaceAndThreat",
["rowSpace"] = 1,
["gridWidth"] = 5,
["anchorFrameType"] = "SCREEN",
["fullCircle"] = true,
["borderInset"] = 1,
["useLimit"] = false,
["sort"] = "none",
["conditions"] = {
},
["information"] = {
},
["parent"] = "BDO Target Bar",
},
["WithinMelee"] = {
["xOffset"] = -289.9749450683594,
["yOffset"] = 49.777587890625,
["anchorPoint"] = "CENTER",
["information"] = {
},
["regionType"] = "empty",
["actions"] = {
["start"] = {
["sound_path"] = "567473",
["sound"] = " custom",
["do_sound"] = true,
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
["subeventSuffix"] = "_CAST_START",
["event"] = "Range Check",
["subeventPrefix"] = "SPELL",
["unit"] = "target",
["range"] = "8",
["spellIds"] = {
},
["use_range"] = true,
["use_unit"] = true,
["names"] = {
},
["range_operator"] = "<=",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "unit",
["use_unit"] = true,
["use_attackable"] = true,
["debuffType"] = "HELPFUL",
["use_dead"] = false,
["event"] = "Unit Characteristics",
["unit"] = "target",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["parent"] = "RangeCheck",
["internalVersion"] = 89,
["alpha"] = 1,
["selfPoint"] = "CENTER",
["id"] = "WithinMelee",
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["width"] = 200,
["uid"] = "xftpDt9)1Tx",
["config"] = {
},
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
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
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
["authorOptions"] = {
},
},
["PetPower"] = {
["overlays"] = {
{
0.95294123888016,
1,
0.99215692281723,
1,
},
},
["iconSource"] = -1,
["xOffset"] = 0,
["adjustedMax"] = "",
["yOffset"] = -6,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["url"] = "https://wago.io/zuOgFOlAp/1",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["selfPoint"] = "CENTER",
["barColor"] = {
0.321568638086319,
0.6392157077789307,
1,
1,
},
["desaturate"] = false,
["sparkOffsetY"] = 0,
["gradientOrientation"] = "HORIZONTAL",
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["use_alive"] = true,
["class"] = {
["single"] = "HUNTER",
["multi"] = {
["HUNTER"] = true,
},
},
["size"] = {
["multi"] = {
},
},
},
["smoothProgress"] = true,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["overlayclip"] = true,
["texture"] = "Clean",
["zoom"] = 0,
["spark"] = false,
["tocversion"] = 11502,
["alpha"] = 1,
["sparkColor"] = {
1,
1,
1,
1,
},
["sparkOffsetX"] = 0,
["wagoID"] = "zuOgFOlAp",
["parent"] = "Pet Health",
["adjustedMin"] = "",
["sparkRotationMode"] = "AUTO",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_maxhealth"] = false,
["use_showCost"] = true,
["event"] = "Power",
["unit"] = "pet",
["use_unit"] = true,
["powertype"] = 2,
["spellIds"] = {
},
["names"] = {
},
["subeventPrefix"] = "SPELL",
["use_percenthealth"] = false,
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["version"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
},
["height"] = 2,
["textureSource"] = "Picker",
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["authorOptions"] = {
},
["icon_side"] = "RIGHT",
["information"] = {
["showNilIsFalse"] = true,
},
["sparkWidth"] = 10,
["sparkHeight"] = 27,
["preferToUpdate"] = false,
["overlaysTexture"] = {
"Details Flat",
},
["config"] = {
},
["semver"] = "1.0.0",
["sparkHidden"] = "NEVER",
["id"] = "PetPower",
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["uid"] = "olrx7MhZ2cs",
["width"] = 468,
["inverse"] = false,
["icon"] = false,
["orientation"] = "HORIZONTAL",
["conditions"] = {
},
["barColor2"] = {
0.5254902243614197,
0.5254902243614197,
0.5254902243614197,
1,
},
["backgroundColor"] = {
0,
0,
0,
0.2259613275527954,
},
},
["CastBar"] = {
["sparkWidth"] = 13,
["sparkOffsetX"] = 0,
["xOffset"] = -0.002108487139742042,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -96.25121722614332,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["sparkRotationMode"] = "AUTO",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Cast",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "target",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
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
["barColor"] = {
0.2352941334247589,
0.6980392336845398,
0.9019608497619629,
1,
},
["desaturate"] = false,
["alpha"] = 1,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%n",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_anchorYOffset"] = 0,
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_CENTER",
["text_fontSize"] = 20,
["anchorXOffset"] = 0,
["text_fontType"] = "None",
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "LSM",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["parent"] = "BDO Target Bar",
["barColor2"] = {
1,
1,
0,
1,
},
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["internalVersion"] = 89,
["height"] = 11,
["sparkColor"] = {
1,
1,
1,
1,
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["uid"] = "PBKMkS3vV2O",
["selfPoint"] = "CENTER",
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 28,
["texture"] = "Solid",
["zoom"] = 0,
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["spark"] = true,
["sparkHidden"] = "NEVER",
["id"] = "CastBar",
["authorOptions"] = {
},
["frameStrata"] = 1,
["width"] = 584,
["iconSource"] = -1,
["config"] = {
},
["inverse"] = false,
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
},
["information"] = {
},
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
},
["Revive Pet"] = {
["iconSource"] = -1,
["xOffset"] = 0,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["custom"] = "function(event, show)\n    return show\nend",
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_PET_MENU",
["spellIds"] = {
},
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_class"] = true,
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["texXOffset"] = 0,
["color"] = {
1,
1,
1,
1,
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["actions"] = {
["start"] = {
["sound_path"] = "567461",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound"] = " custom",
["do_custom"] = false,
["sound_channel"] = "Master",
},
["finish"] = {
["sound_channel"] = "Master",
["sound_path"] = "567482",
["sound"] = " custom",
["do_sound"] = false,
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Revive Pet\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(982) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
},
["parent"] = "PetGroup",
["information"] = {
},
["conditions"] = {
},
["uid"] = "5IEzxl7(FEw",
["alpha"] = 1,
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["id"] = "Revive Pet",
["zoom"] = 0,
["useCooldownModRate"] = true,
["width"] = 30,
["authorOptions"] = {
},
["config"] = {
},
["inverse"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["preset"] = "spiral",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["scaley"] = 1,
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["displayIcon"] = 132163,
["cooldown"] = false,
["keepAspectRatio"] = false,
},
["LvlTxt"] = {
["outline"] = "None",
["color"] = {
1,
0.9294118285179138,
0.8274510502815247,
1,
},
["displayText_format_p_time_dynamic_threshold"] = 60,
["shadowYOffset"] = 0,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Experience",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "player",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_time_mod_rate"] = true,
["displayText_format_p_time_legacy_floor"] = false,
["selfPoint"] = "BOTTOM",
["font"] = "Fira Sans Condensed Medium",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["fontSize"] = 12,
["shadowXOffset"] = 0,
["regionType"] = "text",
["internalVersion"] = 89,
["displayText_format_1.level_format"] = "none",
["displayText_format_p_format"] = "timed",
["displayText_format_p_time_precision"] = 1,
["conditions"] = {
},
["wordWrap"] = "WordWrap",
["xOffset"] = -713,
["justify"] = "CENTER",
["parent"] = "LVL Group",
["id"] = "LvlTxt",
["config"] = {
},
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["yOffset"] = 397.4324035644531,
["uid"] = "lhhcE94S7Pk",
["authorOptions"] = {
},
["displayText"] = "Lv",
["shadowColor"] = {
0.9803922176361084,
1,
0.1411764770746231,
0,
},
["fixedWidth"] = 200,
["information"] = {
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
},
["PVP Flag"] = {
["outline"] = "OUTLINE",
["authorOptions"] = {
},
["displayText"] = "PVP FLAGGED",
["shadowYOffset"] = -1,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_pvpflagged"] = true,
["event"] = "Conditions",
["unit"] = "player",
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_unit"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["internalVersion"] = 89,
["selfPoint"] = "BOTTOM",
["font"] = "Friz Quadrata TT",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["fontSize"] = 23,
["shadowXOffset"] = 1,
["regionType"] = "text",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["displayText_format_p_time_precision"] = 1,
["displayText_format_p_time_mod_rate"] = true,
["conditions"] = {
},
["color"] = {
1,
0.08627451211214066,
0,
1,
},
["justify"] = "LEFT",
["displayText_format_p_time_dynamic_threshold"] = 60,
["id"] = "PVP Flag",
["yOffset"] = -252.0497589111328,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["config"] = {
},
["uid"] = "KBSLnttRGbe",
["wordWrap"] = "WordWrap",
["xOffset"] = -0.00030517578125,
["shadowColor"] = {
0,
0,
0,
1,
},
["fixedWidth"] = 200,
["information"] = {
},
["displayText_format_p_time_legacy_floor"] = false,
},
["ClassIcon3"] = {
["iconSource"] = -1,
["parent"] = "Party3",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
},
["triggers"] = {
{
["trigger"] = {
["use_namerealm"] = false,
["classification"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "party3",
["class"] = "HUNTER",
["event"] = "Unit Characteristics",
["use_specific_unit"] = true,
["use_class"] = false,
["type"] = "unit",
["spellIds"] = {
},
["names"] = {
},
["subeventPrefix"] = "SPELL",
["use_unit"] = true,
["use_unitisunit"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["desaturate"] = true,
["subRegions"] = {
{
["border_size"] = 11,
["type"] = "subborder",
["border_color"] = {
0.6549019813537598,
0.6274510025978088,
0,
0.5849355757236481,
},
["border_visible"] = true,
["border_edge"] = "Blizzard Tooltip",
["border_offset"] = 2,
},
{
["type"] = "subbackground",
},
},
["height"] = 37,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["useTooltip"] = false,
["xOffset"] = -92,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["icon"] = true,
["selfPoint"] = "CENTER",
["information"] = {
},
["displayIcon"] = 136095,
["uid"] = "KEUs3cVwpHf",
["alpha"] = 0.9,
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["id"] = "ClassIcon3",
["cooldownTextDisabled"] = false,
["useCooldownModRate"] = true,
["width"] = 37,
["authorOptions"] = {
},
["config"] = {
},
["inverse"] = false,
["color"] = {
0.803921639919281,
0.803921639919281,
0.803921639919281,
0.7300000190734863,
},
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "HUNTER",
},
["changes"] = {
{
["value"] = "626000",
["property"] = "displayIcon",
},
{
["value"] = {
0.3725490272045136,
0.6666666865348816,
0.388235330581665,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["op"] = "==",
["value"] = "DRUID",
["variable"] = "class",
},
["linked"] = true,
["changes"] = {
{
["value"] = "625999",
["property"] = "displayIcon",
},
{
["value"] = {
0.615686297416687,
0.2862745225429535,
0.1098039299249649,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "PRIEST",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626004",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.5843137502670288,
0.5843137502670288,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "ROGUE",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626005",
["property"] = "displayIcon",
},
{
["value"] = {
0.6705882549285889,
0.5529412031173706,
0.294117659330368,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "WARLOCK",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626007",
["property"] = "displayIcon",
},
{
["value"] = {
0.4000000357627869,
0.3764706254005432,
0.6549019813537598,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "WARRIOR",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626008",
["property"] = "displayIcon",
},
{
["value"] = {
0.5607843399047852,
0.2784313857555389,
0.2549019753932953,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "MAGE",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626001",
["property"] = "displayIcon",
},
{
["value"] = {
0.3254902064800263,
0.7215686440467834,
1,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "PALADIN",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626003",
["property"] = "displayIcon",
},
{
["value"] = {
0.572549045085907,
0.3333333432674408,
0.501960813999176,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["op"] = "==",
["value"] = "SHAMAN",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626006",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.501960813999176,
0.5372549295425415,
1,
},
["property"] = "color",
},
},
},
},
["cooldown"] = false,
["keepAspectRatio"] = false,
},
["Health2"] = {
["sparkWidth"] = 10,
["iconSource"] = -1,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -4,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["use_raid_role"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["use_maxhealth"] = false,
["use_specific_unit"] = true,
["use_unit"] = true,
["unit"] = "party2",
["use_ignoreDisconnected"] = false,
["names"] = {
},
["spellIds"] = {
},
["use_percenthealth"] = false,
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = 1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["barColor"] = {
1,
0.207843154668808,
0,
1,
},
["desaturate"] = false,
["frameStrata"] = 3,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["text_text_format_n_format"] = "none",
["text_text"] = "%1.health",
["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_shadowXOffset"] = 1,
["type"] = "subtext",
["text_anchorYOffset"] = 10,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.health_pad_mode"] = "left",
["text_shadowYOffset"] = -1,
["text_fontType"] = "None",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_text_format_1.health_format"] = "BigNumber",
["text_text_format_1.health_pad"] = false,
["anchor_point"] = "SPARK",
["text_fontSize"] = 10,
["anchorXOffset"] = 0,
["text_text_format_1.health_pad_max"] = 8,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%n %1.raidMark",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["text_text_format_1.raidMark_format"] = "none",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = -1,
["rotateText"] = "NONE",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_fontType"] = "None",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_LEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_anchorYOffset"] = 14,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%2.level",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_2.level_format"] = "none",
["type"] = "subtext",
["text_anchorXOffset"] = -21,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_anchorYOffset"] = -13,
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_text_format_1.level_format"] = "none",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_BOTTOMLEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_visible"] = true,
},
},
["height"] = 4,
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"3",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["information"] = {
},
["parent"] = "Party2",
["sparkRotationMode"] = "MANUAL",
["enableGradient"] = false,
["xOffset"] = 20,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["config"] = {
},
["uid"] = "W5L6j8STOTN",
["icon_side"] = "RIGHT",
["width"] = 180,
["sparkHeight"] = 10,
["texture"] = "Clean",
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["zoom"] = 0,
["spark"] = true,
["sparkHidden"] = "NEVER",
["id"] = "Health2",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["gradientOrientation"] = "HORIZONTAL",
["sparkColor"] = {
1,
1,
1,
1,
},
["inverse"] = false,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["value"] = "function()\n    return not UnitIsConnected(\"party2\")\nend",
["variable"] = "customcheck",
["trigger"] = -1,
},
["changes"] = {
{
["value"] = {
0.4549019932746887,
0.4549019932746887,
0.4549019932746887,
1,
},
["property"] = "barColor",
},
},
},
},
["barColor2"] = {
1,
1,
0,
1,
},
["sparkOffsetX"] = 0,
},
["MongooseAvailable"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["frameStrata"] = 1,
["xOffset"] = -138.2716064453125,
["width"] = 46,
["mirror"] = false,
["yOffset"] = -399.1851558685303,
["anchorPoint"] = "CENTER",
["color"] = {
1,
0.0470588281750679,
0,
0.9695510528981686,
},
["blendMode"] = "BLEND",
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
["regionType"] = "texture",
["rotate"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["texture"] = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-70",
["authorOptions"] = {
},
["internalVersion"] = 89,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["spellName"] = 14269,
["subeventSuffix"] = "_CAST_START",
["use_exact_spellName"] = false,
["use_genericShowOn"] = true,
["event"] = "Action Usable",
["subeventPrefix"] = "SPELL",
["use_targetRequired"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["genericShowOn"] = "showOnCooldown",
["unit"] = "player",
["names"] = {
},
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "unit",
["use_unit"] = true,
["debuffType"] = "HELPFUL",
["event"] = "Health",
["unit"] = "nameplate",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["selfPoint"] = "CENTER",
["id"] = "MongooseAvailable",
["config"] = {
},
["alpha"] = 1,
["desaturate"] = false,
["rotation"] = 0,
["uid"] = "jnsX(avTsL2",
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
["translateType"] = "straightTranslate",
["alphaType"] = "alphaPulse",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    local angle = (progress * 2 * math.pi) - (math.pi / 2)\n    return start + (((math.sin(angle) + 1)/2) * delta)\nend\n",
["rotate"] = 0,
["duration"] = ".2",
["use_translate"] = false,
["use_alpha"] = false,
["scaleType"] = "straightScale",
["type"] = "custom",
["scaley"] = 2.200000000000001,
["easeType"] = "easeIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["use_color"] = true,
["alpha"] = 0.42,
["colorType"] = "straightHSV",
["y"] = -35,
["x"] = 0,
["preset"] = "bounceDecay",
["colorA"] = 1,
["colorFunc"] = "function(progress, r1, g1, b1, a1, r2, g2, b2, a2)\n    return WeakAuras.GetHSVTransition(progress, r1, g1, b1, a1, r2, g2, b2, a2)\nend\n",
["easeStrength"] = 3,
["scalex"] = 2.200000000000001,
["use_scale"] = true,
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["scalex"] = 1.3,
["colorA"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["duration"] = ".05",
["easeStrength"] = 3,
["use_translate"] = false,
["use_alpha"] = false,
["translateType"] = "straightTranslate",
["type"] = "none",
["scaleType"] = "straightScale",
["easeType"] = "none",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["use_color"] = false,
["alpha"] = 0,
["colorType"] = "straightColor",
["y"] = 0,
["x"] = 0,
["use_scale"] = true,
["scaley"] = 1.3,
["colorFunc"] = "function(progress, r1, g1, b1, a1, r2, g2, b2, a2)\n    return r1 + (progress * (r2 - r1)), g1 + (progress * (g2 - g1)), b1 + (progress * (b2 - b1)), a1 + (progress * (a2 - a1))\nend\n",
["rotate"] = 0,
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
["duration_type"] = "seconds",
},
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 40,
["conditions"] = {
},
["information"] = {
},
["anchorFrameType"] = "SCREEN",
},
["Rapid Fire"] = {
["iconSource"] = 1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["debuffType"] = "HELPFUL",
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["names"] = {
},
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["use_exact_spellName"] = false,
["genericShowOn"] = "showOnCooldown",
["subeventPrefix"] = "SPELL",
["use_track"] = true,
["spellName"] = 3045,
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["authorOptions"] = {
},
["keepAspectRatio"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["parent"] = "CooldownGroup",
["useTooltip"] = true,
["information"] = {
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["uid"] = "mToAHtlZEu5",
["frameStrata"] = 1,
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["useCooldownModRate"] = true,
["id"] = "Rapid Fire",
["zoom"] = 0,
["alpha"] = 1,
["width"] = 26,
["xOffset"] = 0,
["config"] = {
},
["inverse"] = false,
["url"] = "Meow",
["conditions"] = {
},
["cooldown"] = true,
["actions"] = {
["start"] = {
},
["finish"] = {
["sound_channel"] = "SFX",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound"] = " custom",
["do_sound"] = true,
},
["init"] = {
},
},
},
["Multi-Shot 2"] = {
["sparkWidth"] = 10,
["iconSource"] = -1,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -155,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["sparkRotationMode"] = "AUTO",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "combatlog",
["spellId"] = {
2643,
},
["subeventSuffix"] = "_CAST_START",
["duration"] = "0.5",
["event"] = "Combat Log",
["subeventPrefix"] = "SPELL",
["use_spellId"] = true,
["spellIds"] = {
},
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["barColor"] = {
0.2745098173618317,
0.529411792755127,
1,
1,
},
["desaturate"] = false,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
},
["height"] = 4,
["textureSource"] = "LSM",
["load"] = {
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["enableGradient"] = false,
["information"] = {
},
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["sparkOffsetX"] = 0,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["sparkColor"] = {
1,
1,
1,
1,
},
["icon_side"] = "RIGHT",
["config"] = {
},
["sparkHeight"] = 18,
["texture"] = "Solid",
["width"] = 250,
["zoom"] = 0,
["spark"] = false,
["frameStrata"] = 1,
["sparkHidden"] = "NEVER",
["xOffset"] = 6.103515625e-05,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["id"] = "Multi-Shot 2",
["uid"] = "hGrrCqIdcMB",
["inverse"] = true,
["gradientOrientation"] = "HORIZONTAL",
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
},
["changes"] = {
{
},
},
},
},
["barColor2"] = {
1,
1,
0,
1,
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
},
["Point 1"] = {
["user_y"] = 0,
["user_x"] = 0,
["parent"] = "Combo Points",
["adjustedMax"] = "1",
["adjustedMin"] = "0",
["yOffset"] = 0,
["foregroundColor"] = {
1,
1,
1,
1,
},
["desaturateBackground"] = false,
["sameTexture"] = false,
["backgroundColor"] = {
0.501960813999176,
0.501960813999176,
0.501960813999176,
1,
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_unit"] = true,
["class"] = "ROGUE",
["use_requirePowerType"] = false,
["unit"] = "player",
["use_class"] = true,
["powertype"] = 4,
["spellIds"] = {
},
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["endAngle"] = 360,
["internalVersion"] = 89,
["progressSource"] = {
1,
"power",
},
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["colorB"] = 1,
["colorG"] = 1,
["scalex"] = 1.25,
["use_scale"] = true,
["type"] = "none",
["easeStrength"] = 3,
["easeType"] = "easeOutIn",
["scaley"] = 1.25,
["use_color"] = true,
["alpha"] = 0,
["x"] = 0,
["y"] = 0,
["colorType"] = "pulseHSV",
["colorA"] = 1,
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    local angle = (progress * 2 * math.pi) - (math.pi / 2)\n    return startX + (((math.sin(angle) + 1)/2) * (scaleX - 1)), startY + (((math.sin(angle) + 1)/2) * (scaleY - 1))\nend\n",
["colorFunc"] = "function(progress, r1, g1, b1, a1, r2, g2, b2, a2)\n    local angle = (progress * 2 * math.pi) - (math.pi / 2)\n    local newProgress = ((math.sin(angle) + 1)/2);\n    return WeakAuras.GetHSVTransition(newProgress, r1, g1, b1, a1, r2, g2, b2, a2)\nend\n",
["rotate"] = 0,
["scaleType"] = "pulse",
["duration"] = ".25",
},
["main"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["colorB"] = 1,
["colorG"] = 1,
["type"] = "none",
["easeType"] = "easeOutIn",
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    if aura_env.combopoint1 then\n        local angle = (progress * 2 * math.pi) - (math.pi / 2)\n        return startX + (((math.sin(angle) + 1)/2) * (scaleX - 1)), startY + (((math.sin(angle) + 1)/2) * (scaleY - 1))\n    end\n    return startX, startY\n    end\n    \n    ",
["scaley"] = 1,
["alpha"] = 0,
["scalex"] = 1,
["y"] = 0,
["x"] = 0,
["easeStrength"] = 3,
["scaleType"] = "custom",
["colorA"] = 1,
["rotate"] = 0,
["use_scale"] = true,
["duration"] = ".25",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["preferToUpdate"] = true,
["authorOptions"] = {
},
["rotation"] = 0,
["font"] = "Friz Quadrata TT",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom_load"] = true,
["custom"] = "if ComboFrame then\n    ComboFrame:Hide()\n    ComboFrame:UnregisterAllEvents()\nend",
["do_custom"] = true,
},
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 20,
["conditions"] = {
},
["crop_y"] = 0.41,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = true,
["fontSize"] = 12,
["xOffset"] = -80,
["foregroundTexture"] = "ComboPoints-ComboPoint",
["backgroundTexture"] = "ClassOverlay-ComboPoint-Off",
["config"] = {
},
["mirror"] = false,
["useAdjustededMin"] = true,
["regionType"] = "progresstexture",
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["blendMode"] = "BLEND",
["width"] = 20,
["alpha"] = 1,
["slantMode"] = "INSIDE",
["desaturateForeground"] = false,
["compress"] = false,
["uid"] = "(Q8SobdaziL",
["anchorPoint"] = "CENTER",
["tocversion"] = 11508,
["id"] = "Point 1",
["smoothProgress"] = true,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["startAngle"] = 0,
["auraRotation"] = 0,
["inverse"] = false,
["selfPoint"] = "CENTER",
["orientation"] = "VERTICAL",
["crop_x"] = 0.41,
["information"] = {
},
["backgroundOffset"] = 2,
},
["Target Name"] = {
["outline"] = "None",
["displayText_format_1.raidMark_format"] = "none",
["authorOptions"] = {
},
["displayText"] = "%1.unit %c %1.raidMark",
["customText"] = "function()\n    local level = UnitLevel(\"target\")\n    local levelText = level\n    if level == -1 then levelText = \"??\" end\n\n    local r, g, b\n\n    -- Check if the target is friendly\n    if UnitIsFriend(\"player\", \"target\") then\n        -- Vanilla Gold Color (RGB: 255, 210, 0)\n        r, g, b = 255, 210, 0\n    else\n        -- Use standard difficulty coloring for enemies\n        local color = GetQuestDifficultyColor(level)\n        r, g, b = color.r * 255, color.g * 255, color.b * 255\n    end\n    \n    return string.format(\"|cff%02x%02x%02x(Lvl %s)|r\", r, g, b, levelText)\nend",
["shadowYOffset"] = -1,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWATargetProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"target\")\n\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nRegisterUnitWatch(btn) \n\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nlocal bg = btn:CreateTexture(nil, \"BACKGROUND\")\nbg:SetAllPoints(btn)\nbg:SetColorTexture(0, 0, 0, 0)\n\nif TargetFrame then\n    TargetFrame:Hide()\nend",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "target",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["internalVersion"] = 89,
["selfPoint"] = "BOTTOM",
["font"] = "Friz Quadrata TT",
["displayText_format_1.unit_realm_name"] = "never",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
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
["displayText_format_1.unit_pad"] = false,
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_alive"] = true,
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["displayText_format_1.unit_color"] = "class",
["fontSize"] = 25,
["displayText_format_1.unit_pad_max"] = 8,
["fixedWidth"] = 200,
["shadowXOffset"] = 1,
["displayText_format_1.unit_pad_mode"] = "left",
["color"] = {
1,
1,
1,
1,
},
["url"] = "Meow",
["regionType"] = "text",
["config"] = {
},
["displayText_format_p_time_mod_rate"] = true,
["ignoreWagoUpdate"] = true,
["displayText_format_p_time_legacy_floor"] = false,
["displayText_format_p_time_precision"] = 1,
["displayText_format_p_time_dynamic_threshold"] = 60,
["parent"] = "BDO Target Bar",
["displayText_format_1.unit_abbreviate"] = false,
["justify"] = "CENTER",
["displayText_format_1.unit_format"] = "Unit",
["id"] = "Target Name",
["displayText_format_c_format"] = "none",
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["yOffset"] = 27.29536478102693,
["uid"] = "zh5(LrmD3Ft",
["wordWrap"] = "WordWrap",
["displayText_format_1.unit_abbreviate_max"] = 8,
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
["xOffset"] = 0,
},
["DarkenVignette"] = {
["authorOptions"] = {
},
["preferToUpdate"] = false,
["yOffset"] = -8.691375732421875,
["anchorPoint"] = "CENTER",
["actions"] = {
["start"] = {
["do_loop"] = true,
["do_message"] = false,
["message"] = "",
["custom"] = "-- CONFIGURATION\nlocal fadeInDuration = 30\nlocal fadeOutDuration = 2\n\nlocal now = GetTime()\nlocal targetAlpha = 0\n\n-- 1. Calculate the intended Alpha\nif UnitAffectingCombat(\"player\") and aura_env.combatStartTime then\n    local elapsed = now - aura_env.combatStartTime\n    targetAlpha = math.min(elapsed / fadeInDuration, 1)\n    aura_env.lastAlpha = targetAlpha \nelseif aura_env.exitCombatTime then\n    local elapsedExit = now - aura_env.exitCombatTime\n    local startingAlpha = aura_env.lastAlpha or 0\n    targetAlpha = math.max(startingAlpha - (elapsedExit / fadeOutDuration), 0)\nend\n\n-- 2. Manually force the Alpha onto the frame\naura_env.currentAlpha = targetAlpha\naura_env.region:SetAlpha(targetAlpha)",
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "Interface\\AddOns\\LowHPVignette\\Sounds\\LowHPVignette\\LowHP.mp3",
["do_custom"] = false,
["sound_channel"] = "SFX",
},
["finish"] = {
["do_sound"] = false,
["stop_sound"] = false,
},
["init"] = {
["do_custom"] = true,
["custom"] = "aura_env.region = aura_env.region or aura_env.cloneId and WeakAuras.GetRegion(aura_env.id, aura_env.cloneId) or WeakAuras.GetRegion(aura_env.id)",
},
},
["triggers"] = {
{
["trigger"] = {
["subeventSuffix"] = "_CAST_START",
["type"] = "custom",
["use_incombat"] = true,
["custom_type"] = "status",
["subeventPrefix"] = "SPELL",
["percenthealth"] = {
"50",
},
["event"] = "Conditions",
["use_unit"] = true,
["unit"] = "player",
["spellIds"] = {
},
["custom"] = "function()\n    local fadeInDuration = 160\n    local fadeOutDuration = 3\n    local now = GetTime()\n    local inCombat = UnitAffectingCombat(\"player\")\n    \n    -- 1. Manage Timers\n    if inCombat then\n        if not aura_env.combatStart then\n            aura_env.combatStart = now\n            aura_env.exitTime = nil\n        end\n    else\n        if aura_env.combatStart then\n            aura_env.exitTime = now\n            aura_env.combatStart = nil\n        end\n    end\n    \n    -- 2. Calculate Alpha\n    local targetAlpha = 0\n    if inCombat and aura_env.combatStart then\n        targetAlpha = math.min((now - aura_env.combatStart) / fadeInDuration, 1)\n        aura_env.lastAlpha = targetAlpha\n    elseif aura_env.exitTime then\n        local elapsedExit = now - aura_env.exitTime\n        local startAlpha = aura_env.lastAlpha or 0\n        targetAlpha = math.max(startAlpha - (elapsedExit / fadeOutDuration), 0)\n    end\n    \n    -- 3. Apply Alpha & Global Tracking\n    aura_env.currentAlpha = targetAlpha\n    if aura_env.region then\n        aura_env.region:SetAlpha(targetAlpha)\n    end\n    \n    -- 4. Stay active as long as alpha > 0\n    return targetAlpha > 0\nend",
["names"] = {
},
["check"] = "update",
["use_percenthealth"] = false,
["percenthealth_operator"] = {
"==",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function()\n    return (aura_env.currentAlpha or 0) <= 0 and not UnitAffectingCombat(\"player\")\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["rotation"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["textureMirror"] = false,
["scale"] = 1,
["mirror"] = false,
["self_point"] = "CENTER",
["textureRotation"] = 0,
["textureVisible"] = true,
["anchor_mode"] = "area",
["anchor_area"] = "ALL",
["type"] = "subtexture",
["textureDesaturate"] = false,
["textureTexture"] = "PhotosensitivityWarning-vignette",
["width"] = 32,
["textureBlendMode"] = "BLEND",
["textureColor"] = {
1,
1,
1,
1,
},
["anchor_point"] = "CENTER",
["rotate"] = false,
["textureRotate"] = false,
["height"] = 32,
},
},
["height"] = 1200,
["rotate"] = false,
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["mirror"] = false,
["regionType"] = "texture",
["blendMode"] = "BLEND",
["texture"] = "PhotosensitivityWarning-vignette",
["config"] = {
},
["xOffset"] = -19.753173828125,
["tocversion"] = 11508,
["id"] = "DarkenVignette",
["anchorFrameType"] = "UIPARENT",
["alpha"] = 1,
["width"] = 2000,
["frameStrata"] = 2,
["uid"] = "cDOb2kPwDEb",
["color"] = {
0,
0,
0,
1,
},
["parent"] = "CombatFX",
["conditions"] = {
},
["information"] = {
},
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "none",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["scalex"] = 1,
["preset"] = "fade",
["easeStrength"] = 3,
["rotate"] = 0,
["colorA"] = 1,
["duration"] = "60",
},
["main"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "alphaPulse",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    local angle = (progress * 2 * math.pi) - (math.pi / 2)\n    return start + (((math.sin(angle) + 1)/2) * delta)\nend\n",
["use_alpha"] = false,
["type"] = "none",
["easeType"] = "easeOutIn",
["scaley"] = 1,
["alpha"] = 0.7000000000000001,
["y"] = 0,
["x"] = 0,
["colorA"] = 1,
["preset"] = "pulse",
["rotate"] = 0,
["easeStrength"] = 3,
["scalex"] = 1,
["duration"] = ".75",
},
["finish"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "none",
["easeType"] = "none",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["scalex"] = 1,
["duration"] = "3",
["rotate"] = 0,
["easeStrength"] = 3,
["colorA"] = 1,
["preset"] = "fade",
},
},
},
["Pet Training"] = {
["texXOffset"] = 0,
["parent"] = "PetGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["sound_path"] = "567461",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound"] = " custom",
["do_custom"] = false,
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Beast Training\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(5149) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["spellIds"] = {
},
["custom"] = "function(event, show)\n    return show\nend",
["events"] = "TOGGLE_PET_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["preset"] = "spiral",
["duration_type"] = "seconds",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["translateType"] = "straightTranslate",
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["duration"] = ".1",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_class"] = true,
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["iconSource"] = -1,
["icon"] = true,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["authorOptions"] = {
},
["color"] = {
1,
1,
1,
1,
},
["cooldown"] = false,
["displayIcon"] = 132162,
["config"] = {
},
["zoom"] = 0,
["cooldownTextDisabled"] = false,
["width"] = 30,
["useCooldownModRate"] = true,
["id"] = "Pet Training",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["uid"] = "A4TuGGVOMc8",
["inverse"] = false,
["xOffset"] = 0,
["conditions"] = {
},
["information"] = {
},
["progressSource"] = {
-1,
"",
},
},
["BG1"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["alpha"] = 0.6,
["width"] = 310,
["color"] = {
0,
0,
0,
1,
},
["parent"] = "Party1",
["mirror"] = false,
["yOffset"] = 0,
["regionType"] = "texture",
["information"] = {
},
["blendMode"] = "BLEND",
["anchorPoint"] = "CENTER",
["authorOptions"] = {
},
["xOffset"] = -20,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
},
["texture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_AlphaGradient.tga",
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "percenthealth",
["op"] = "<=",
["value"] = "50",
},
["changes"] = {
{
["value"] = {
1,
0,
0.01568627543747425,
1,
},
["property"] = "color",
},
},
},
},
["internalVersion"] = 89,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["use_factionID"] = true,
["spellIds"] = {
},
["use_specific_unit"] = true,
["use_unit"] = true,
["unit"] = "party1",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["selfPoint"] = "CENTER",
["id"] = "BG1",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["rotation"] = 0,
["uid"] = "ccIg)xrMET3",
["config"] = {
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 40,
["rotate"] = false,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["desaturate"] = false,
},
["Scare Beast"] = {
["iconSource"] = 1,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["url"] = "Meow",
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["spellName"] = 14326,
["subeventSuffix"] = "_CAST_START",
["names"] = {
},
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["unit"] = "player",
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["genericShowOn"] = "showOnCooldown",
["use_exact_spellName"] = false,
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
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
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
["do_sound"] = true,
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound_channel"] = "SFX",
},
},
["cooldownEdge"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["xOffset"] = 0,
["useTooltip"] = true,
["cooldown"] = true,
["selfPoint"] = "CENTER",
["config"] = {
},
["alpha"] = 1,
["cooldownTextDisabled"] = false,
["width"] = 26,
["frameStrata"] = 1,
["id"] = "Scare Beast",
["zoom"] = 0,
["useCooldownModRate"] = true,
["anchorFrameType"] = "SCREEN",
["progressSource"] = {
-1,
"",
},
["uid"] = "CsGe9tTLmZl",
["inverse"] = false,
["parent"] = "CooldownGroup",
["conditions"] = {
},
["information"] = {
},
["color"] = {
1,
1,
1,
1,
},
},
["BDOPartyFrame"] = {
["controlledChildren"] = {
"Party0",
"Party1",
"Party2",
"Party3",
"Party4",
},
["borderBackdrop"] = "Blizzard Tooltip",
["parent"] = "BDO UI Overhaul",
["groupIcon"] = "132311",
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
["internalVersion"] = 89,
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
["scale"] = 0.8999999999999999,
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 2,
["borderOffset"] = 4,
["uid"] = "oZcKmJc(fpe",
["config"] = {
},
["id"] = "BDOPartyFrame",
["authorOptions"] = {
},
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = -731.3038703823041,
["borderInset"] = 1,
["yOffset"] = 99.78163682891889,
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
["conditions"] = {
},
["information"] = {
},
["alpha"] = 1,
},
["PetHealth"] = {
["sparkWidth"] = 17,
["iconSource"] = -1,
["xOffset"] = 0,
["preferToUpdate"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["url"] = "https://wago.io/zuOgFOlAp/1",
["icon"] = false,
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["selfPoint"] = "CENTER",
["barColor"] = {
1,
0.1411764770746231,
0.1058823615312576,
1,
},
["desaturate"] = false,
["sparkOffsetY"] = 0,
["gradientOrientation"] = "HORIZONTAL",
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_alive"] = true,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
["HUNTER"] = true,
},
},
["size"] = {
["multi"] = {
},
},
},
["smoothProgress"] = true,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["overlayclip"] = true,
["texture"] = "Clean",
["zoom"] = 0,
["spark"] = true,
["tocversion"] = 11502,
["alpha"] = 1,
["sparkColor"] = {
1,
1,
1,
1,
},
["sparkOffsetX"] = 0,
["wagoID"] = "zuOgFOlAp",
["parent"] = "Pet Health",
["adjustedMin"] = "",
["sparkRotationMode"] = "AUTO",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["use_unit"] = true,
["use_showCost"] = true,
["unit"] = "pet",
["use_maxhealth"] = false,
["powertype"] = 0,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_percenthealth"] = false,
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["version"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["text_text_format_1.percenthealth_pad"] = false,
["text_text"] = "%1.health",
["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_text_format_1.health_decimal_precision"] = 0,
["text_fixedWidth"] = 64,
["rotateText"] = "NONE",
["text_text_format_1.percenthealth_format"] = "Number",
["text_color"] = {
1,
1,
1,
1,
},
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_text_format_1.health_round_type"] = "floor",
["text_text_format_1.health_pad"] = false,
["text_text_format_1.percenthealth_decimal_precision"] = 0,
["text_fontSize"] = 14,
["anchorXOffset"] = 0,
["text_text_format_1.health_pad_max"] = 8,
["text_text_format_n_format"] = "none",
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_text_format_1.percenthealth_round_type"] = "floor",
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["type"] = "subtext",
["text_anchorXOffset"] = 0,
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.health_pad_mode"] = "left",
["text_anchorYOffset"] = -15,
["text_shadowXOffset"] = 1,
["text_text_format_1.health_format"] = "Number",
["anchor_point"] = "SPARK",
["text_visible"] = true,
["text_text_format_1.percenthealth_pad_mode"] = "left",
["text_text_format_1.percenthealth_pad_max"] = 8,
},
{
["text_shadowXOffset"] = 1,
["text_text_format_1.unit_abbreviate"] = false,
["text_text"] = "%1.unit",
["text_text_format_1.unit_pad_max"] = 8,
["text_text_format_1.unit_abbreviate_max"] = 8,
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_1.unit_pad"] = false,
["text_text_format_1.unit_realm_name"] = "never",
["type"] = "subtext",
["text_text_format_1.unit_format"] = "Unit",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_text_format_n_format"] = "none",
["text_shadowYOffset"] = -1,
["text_visible"] = true,
["text_text_format_1.unit_color"] = "class",
["text_fontType"] = "None",
["text_anchorYOffset"] = 23,
["text_wordWrap"] = "WordWrap",
["anchor_point"] = "INNER_TOP",
["text_fontSize"] = 16,
["anchorXOffset"] = 0,
["text_text_format_1.unit_pad_mode"] = "left",
},
},
["height"] = 10,
["textureSource"] = "Picker",
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["backgroundColor"] = {
0,
0,
0,
1,
},
["icon_side"] = "RIGHT",
["barColor2"] = {
0.5254902243614197,
0.5254902243614197,
0.5254902243614197,
1,
},
["adjustedMax"] = "",
["sparkHeight"] = 30,
["authorOptions"] = {
},
["overlaysTexture"] = {
"Details Flat",
},
["config"] = {
},
["semver"] = "1.0.0",
["sparkHidden"] = "NEVER",
["id"] = "PetHealth",
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["width"] = 468,
["uid"] = "T7AP3sGAbuH",
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["inverse"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
},
["information"] = {
["showNilIsFalse"] = true,
},
["overlays"] = {
{
0.95294123888016,
1,
0.99215692281723,
1,
},
},
},
["EnemyMana"] = {
["overlays"] = {
{
0.95294123888016,
1,
0.99215692281723,
1,
},
},
["iconSource"] = -1,
["authorOptions"] = {
},
["adjustedMax"] = "",
["yOffset"] = -30,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["url"] = "Meow",
["backgroundColor"] = {
0,
0,
0,
1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["selfPoint"] = "CENTER",
["barColor"] = {
0,
0.5607843399047852,
1,
1,
},
["desaturate"] = false,
["ignoreWagoUpdate"] = true,
["sparkOffsetY"] = 0,
["gradientOrientation"] = "HORIZONTAL",
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_alive"] = true,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
["HUNTER"] = true,
},
},
["size"] = {
["multi"] = {
},
},
},
["smoothProgress"] = false,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["overlayclip"] = true,
["texture"] = "Clean",
["zoom"] = 0,
["spark"] = false,
["tocversion"] = 11502,
["alpha"] = 1,
["sparkColor"] = {
1,
1,
1,
1,
},
["sparkOffsetX"] = 0,
["wagoID"] = "zuOgFOlAp",
["parent"] = "BDO Target Bar",
["adjustedMin"] = "",
["sparkRotationMode"] = "AUTO",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Power",
["names"] = {
},
["use_showCost"] = true,
["unit"] = "target",
["subeventPrefix"] = "SPELL",
["powertype"] = 0,
["spellIds"] = {
},
["use_unit"] = true,
["use_maxhealth"] = false,
["use_percenthealth"] = false,
["use_powertype"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["version"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["border_size"] = 1,
["border_offset"] = 1,
["border_visible"] = true,
["border_color"] = {
0,
0,
0,
1,
},
["anchor_area"] = "bar",
["border_edge"] = "1 Pixel",
["type"] = "subborder",
},
{
["text_text_format_t_time_precision"] = 1,
["text_text_format_p_time_format"] = 0,
["text_text"] = "%p/%t",
["anchorXOffset"] = 0,
["text_text_format_p_time_mod_rate"] = true,
["text_text_format_p_format"] = "timed",
["text_text_format_t_time_legacy_floor"] = false,
["text_selfPoint"] = "CENTER",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["text_text_format_t_time_format"] = 0,
["text_text_format_p_time_legacy_floor"] = false,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_t_format"] = "timed",
["anchorYOffset"] = 0,
["text_visible"] = true,
["type"] = "subtext",
["text_fontType"] = "None",
["text_color"] = {
0.9764706492424,
1,
0.98039221763611,
1,
},
["text_font"] = "2002",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_anchorYOffset"] = -2,
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_text_format_t_time_mod_rate"] = true,
["text_text_format_p_time_precision"] = 1,
["text_shadowXOffset"] = 1,
["anchor_point"] = "INNER_CENTER",
["text_fontSize"] = 13,
["text_text_format_t_time_dynamic_threshold"] = 3,
["text_text_format_p_time_dynamic_threshold"] = 60,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%1.percenthealth",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_text_format_1.percenthealth_round_type"] = "floor",
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_1.percenthealth_format"] = "Number",
["text_fixedWidth"] = 64,
["anchorXOffset"] = 0,
["type"] = "subtext",
["text_anchorXOffset"] = -15,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.percenthealth_pad"] = false,
["text_shadowYOffset"] = -1,
["anchor_point"] = "SPARK",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_text_format_n_format"] = "none",
["text_fontType"] = "None",
["text_text_format_1.percenthealth_decimal_precision"] = 0,
["text_fontSize"] = 12,
["text_text_format_1.percenthealth_pad_mode"] = "left",
["text_text_format_1.percenthealth_pad_max"] = 8,
},
},
["height"] = 11.56317138671875,
["textureSource"] = "Picker",
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["authorMode"] = true,
["barColor2"] = {
0.5254902243614197,
0.5254902243614197,
0.5254902243614197,
1,
},
["icon_side"] = "RIGHT",
["xOffset"] = 0,
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["sparkHeight"] = 28,
["preferToUpdate"] = false,
["overlaysTexture"] = {
"Details Flat",
},
["uid"] = "wTpzw9WUoNQ",
["semver"] = "1.0.0",
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWATargetProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"target\")\n\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nRegisterUnitWatch(btn) \n\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nlocal bg = btn:CreateTexture(nil, \"BACKGROUND\")\nbg:SetAllPoints(btn)\nbg:SetColorTexture(0, 0, 0, 0)\n\nif TargetFrame then\n    TargetFrame:Hide()\nend",
},
["finish"] = {
},
},
["sparkHidden"] = "NEVER",
["config"] = {
},
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["width"] = 584.0000610351562,
["id"] = "EnemyMana",
["inverse"] = false,
["sparkWidth"] = 10,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["op"] = "==",
["value"] = 0,
},
["changes"] = {
{
["value"] = {
0,
0.4470588564872742,
1,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["op"] = "==",
["value"] = 1,
},
["changes"] = {
{
["value"] = {
1,
0.04313725605607033,
0,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["op"] = "==",
["value"] = 3,
},
["changes"] = {
{
["value"] = {
0.9372549653053284,
0.917647123336792,
0,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["op"] = "==",
["value"] = 2,
},
["changes"] = {
{
["value"] = {
1,
0.4392157196998596,
0,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "maxpower",
["op"] = "==",
["value"] = "1",
},
["changes"] = {
{
["property"] = "alpha",
},
},
},
},
["information"] = {
["showNilIsFalse"] = true,
},
["icon"] = false,
},
["XP Bar"] = {
["sparkWidth"] = 10,
["iconSource"] = -1,
["xOffset"] = 0.78997802734375,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 423.2653198242188,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["sparkRotationMode"] = "AUTO",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_level"] = false,
["subeventSuffix"] = "",
["names"] = {
},
["use_genericShowOn"] = true,
["use_itemName"] = true,
["use_unit"] = true,
["subeventPrefix"] = "UNIT_DIED",
["genericShowOn"] = "showOnCooldown",
["spellIds"] = {
},
["unit"] = "player",
["use_totalXP"] = false,
["event"] = "Experience",
["use_currentXP"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["barColor"] = {
1,
0.917647123336792,
0,
1,
},
["desaturate"] = false,
["anchorFrameType"] = "SCREEN",
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
},
["height"] = 3,
["textureSource"] = "LSM",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["parent"] = "BDO XP",
["barColor2"] = {
1,
1,
0,
1,
},
["gradientOrientation"] = "HORIZONTAL",
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom_load"] = false,
["do_custom"] = true,
["custom"] = "-- 1. Create a transparent frame to act as the \"sensor\"\n-- We give it a unique name based on the aura's name to avoid conflicts\nlocal frameName = \"WA_XP_Sensor_\" .. aura_env.id:gsub(\"%s+\", \"_\")\naura_env.sensor = CreateFrame(\"Frame\", frameName, aura_env.region)\naura_env.sensor:SetAllPoints(aura_env.region)\naura_env.sensor:EnableMouse(true)\n\n-- 2. Define the tooltip logic\naura_env.sensor:SetScript(\"OnEnter\", function(self)\n        local curr, max = UnitXP(\"player\"), UnitXPMax(\"player\")\n        local rest = GetXPExhaustion() or 0\n        local pct = math.max(0, math.floor((curr / (max > 0 and max or 1)) * 100))\n        \n        GameTooltip:SetOwner(self, \"ANCHOR_CURSOR\")\n        GameTooltip:ClearLines()\n        GameTooltip:AddLine(\"Experience Progress\", 0, 1, 0.5)\n        GameTooltip:AddDoubleLine(\"Current XP:\", string.format(\"%s / %s (%d%%)\", BreakUpLargeNumbers(curr), BreakUpLargeNumbers(max), pct), 1, 1, 1, 1, 1, 1)\n        \n        if rest > 0 then\n            GameTooltip:AddDoubleLine(\"Rested:\", \"+\" .. BreakUpLargeNumbers(rest), 0, 0.6, 1, 0, 0.6, 1)\n        end\n        \n        GameTooltip:Show()\nend)\n\naura_env.sensor:SetScript(\"OnLeave\", function() \n        GameTooltip:Hide() \nend)",
},
["finish"] = {
},
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["sparkOffsetX"] = 0,
["config"] = {
},
["icon_side"] = "RIGHT",
["sparkColor"] = {
1,
1,
1,
1,
},
["sparkHeight"] = 30,
["texture"] = "Solid",
["frameStrata"] = 1,
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["spark"] = false,
["sparkHidden"] = "NEVER",
["id"] = "XP Bar",
["zoom"] = 0,
["alpha"] = 1,
["width"] = 1516,
["authorOptions"] = {
},
["uid"] = "day55KhywR6",
["inverse"] = false,
["enableGradient"] = false,
["orientation"] = "HORIZONTAL",
["conditions"] = {
},
["information"] = {
},
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
},
["OutOfCombatSFXRandom"] = {
["xOffset"] = 0,
["yOffset"] = 0,
["regionType"] = "empty",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["anchorPoint"] = "CENTER",
["actions"] = {
["start"] = {
["custom"] = "local sounds = {\n    \"Interface/AddOns/WACustomAssets/Sigh1.ogg\",\n    \"Interface/AddOns/WACustomAssets/Sigh2.ogg\",\n    \"Interface/AddOns/WACustomAssets/Sigh3.ogg\",\n    \"Interface/AddOns/WACustomAssets/Sigh4.ogg\",\n}\n\nlocal randomIndex = math.random(1, #sounds)\nPlaySoundFile(sounds[randomIndex], \"Master\")",
["do_sound"] = false,
["do_custom"] = true,
["sound"] = " custom",
["sound_path"] = "Interface\\AddOns\\WACustomAssets\\Clarity_of_Thought.ogg",
},
["finish"] = {
["do_message"] = false,
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_incombat"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Conditions",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "player",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["authorOptions"] = {
},
["internalVersion"] = 89,
["frameStrata"] = 1,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "OutOfCombatSFXRandom",
["width"] = 200,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["uid"] = "6QYCkX2OOrY",
["config"] = {
},
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["information"] = {
},
["parent"] = "CombatFX",
},
["WithinRangeNameplate"] = {
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["color"] = {
1,
0,
0.05882353335618973,
1,
},
["anchorFrameType"] = "NAMEPLATE",
["parent"] = "RangeCheck",
["authorOptions"] = {
},
["mirror"] = false,
["yOffset"] = -15,
["anchorPoint"] = "CENTER",
["load"] = {
["use_never"] = true,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["blendMode"] = "BLEND",
["regionType"] = "texture",
["xOffset"] = 0.00018310546875,
["rotate"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura7",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["unit"] = "nameplate",
["spellIds"] = {
},
["names"] = {
},
["subeventPrefix"] = "SPELL",
["use_unit"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["unit"] = "target",
["type"] = "unit",
["event"] = "Range Check",
["use_range"] = true,
["use_unit"] = true,
["range"] = "8",
["range_operator"] = ">=",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["width"] = 34,
["selfPoint"] = "CENTER",
["id"] = "WithinRangeNameplate",
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
["easeType"] = "none",
["scaleType"] = "straightScale",
["preset"] = "starShakeDecay",
["alpha"] = 0,
["rotate"] = 0,
["y"] = 0,
["x"] = 0,
["duration"] = ".1",
["colorA"] = 1,
["use_scale"] = true,
["easeStrength"] = 3,
["scaley"] = 1.8,
["scalex"] = 1.8,
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["use_rotate"] = false,
["scalex"] = 1.3,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["scaleFunc"] = "function(progress, startX, startY, scaleX, scaleY)\n    return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
["type"] = "custom",
["scaleType"] = "straightScale",
["easeType"] = "none",
["rotateFunc"] = "function(progress, start, delta)\n    local angle = progress * 2 * math.pi\n    return start + math.sin(angle) * delta\nend\n",
["scaley"] = 1.3,
["alpha"] = 0,
["use_scale"] = true,
["y"] = 0,
["x"] = 0,
["rotateType"] = "wobble",
["colorA"] = 1,
["rotate"] = 3,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["duration"] = ".1",
},
},
["alpha"] = 1,
["desaturate"] = false,
["rotation"] = 180,
["config"] = {
},
["uid"] = "gfLEGlKOCgi",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 34,
["conditions"] = {
{
["check"] = {
},
["changes"] = {
{
},
},
},
},
["information"] = {
},
["frameStrata"] = 1,
},
["Power3"] = {
["sparkWidth"] = 10,
["iconSource"] = -1,
["xOffset"] = 20,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -12,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["sparkRotationMode"] = "AUTO",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["subeventPrefix"] = "SPELL",
["use_power"] = false,
["event"] = "Power",
["use_specific_unit"] = true,
["names"] = {
},
["use_maxhealth"] = false,
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "party3",
["use_percenthealth"] = false,
["use_powertype"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["barColor"] = {
0.207843154668808,
0.658823549747467,
1,
1,
},
["desaturate"] = false,
["alpha"] = 1,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["type"] = "subborder",
["border_size"] = 2,
["anchor_area"] = "bar",
["border_color"] = {
1,
1,
1,
1,
},
["border_visible"] = false,
["border_edge"] = "Square Full White",
["border_offset"] = 0,
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"4",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["sparkOffsetX"] = 0,
["information"] = {
},
["authorOptions"] = {
},
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["icon"] = false,
["sparkColor"] = {
1,
1,
1,
1,
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["uid"] = "8KABW1Bqzsn",
["height"] = 4,
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 30,
["texture"] = "Clean",
["parent"] = "Party3",
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["spark"] = false,
["sparkHidden"] = "NEVER",
["id"] = "Power3",
["zoom"] = 0,
["frameStrata"] = 3,
["width"] = 180,
["selfPoint"] = "CENTER",
["config"] = {
},
["inverse"] = false,
["internalVersion"] = 89,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = -1,
["variable"] = "customcheck",
["value"] = "function()\n    return not UnitIsConnected(\"party3\")\nend",
},
["changes"] = {
{
["value"] = {
0.4117647409439087,
0.4117647409439087,
0.4117647409439087,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["value"] = 1,
["op"] = "==",
},
["changes"] = {
{
["value"] = {
1,
0.5058823823928833,
0.07450980693101883,
1,
},
["property"] = "barColor",
},
},
},
},
["barColor2"] = {
1,
1,
0,
1,
},
["backgroundColor"] = {
0,
0,
0,
0.5,
},
},
["Intimidation"] = {
["iconSource"] = 1,
["parent"] = "CooldownGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["debuffType"] = "HELPFUL",
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["names"] = {
},
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["use_exact_spellName"] = false,
["genericShowOn"] = "showOnCooldown",
["subeventPrefix"] = "SPELL",
["use_track"] = true,
["spellName"] = 19577,
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["progressSource"] = {
-1,
"",
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["color"] = {
1,
1,
1,
1,
},
["useTooltip"] = true,
["information"] = {
},
["actions"] = {
["start"] = {
},
["finish"] = {
["sound_channel"] = "SFX",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound"] = " custom",
["do_sound"] = true,
},
["init"] = {
},
},
["uid"] = "AqzlQ2H1TsN",
["useCooldownModRate"] = true,
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["id"] = "Intimidation",
["authorOptions"] = {
},
["alpha"] = 1,
["width"] = 26,
["zoom"] = 0,
["config"] = {
},
["inverse"] = false,
["url"] = "Meow",
["conditions"] = {
},
["cooldown"] = true,
["xOffset"] = 0,
},
["First Aid"] = {
["texXOffset"] = 0,
["parent"] = "ProfessionsGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["sound_path"] = "567461",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound"] = " custom",
["do_custom"] = false,
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast First Aid\") -- Change this for the other icon\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(3273) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["spellIds"] = {
},
["custom"] = "function(event, show)\n    return show\nend",
["events"] = "TOGGLE_PROF_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 3273,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scaley"] = 1,
["y"] = -10,
["x"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["scalex"] = 1,
["easeStrength"] = 3,
["scaley"] = 1,
["rotate"] = 0,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["iconSource"] = -1,
["icon"] = true,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["authorOptions"] = {
},
["color"] = {
1,
1,
1,
1,
},
["cooldown"] = false,
["displayIcon"] = 135966,
["config"] = {
},
["zoom"] = 0,
["cooldownTextDisabled"] = false,
["width"] = 30,
["useCooldownModRate"] = true,
["id"] = "First Aid",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["uid"] = "8)Pg4b9B8QJ",
["inverse"] = false,
["xOffset"] = 0,
["conditions"] = {
},
["information"] = {
},
["progressSource"] = {
-1,
"",
},
},
["TargetedSomething"] = {
["authorOptions"] = {
},
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["regionType"] = "empty",
["actions"] = {
["start"] = {
["sound"] = " custom",
["sound_path"] = "567403",
["do_message"] = false,
["do_sound"] = true,
},
["finish"] = {
["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\bigkiss.ogg",
["do_sound"] = false,
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["custom_type"] = "event",
["debuffType"] = "HELPFUL",
["duration"] = ".1",
["event"] = "Health",
["unit"] = "player",
["events"] = "PLAYER_TARGET_CHANGED",
["custom"] = "function(event)\n    if UnitExists(\"target\") then\n        -- Return: Show, Duration Info\n        return true, GetTime(), 1\n    end\nend",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["check"] = "event",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["custom_hide"] = "timed",
},
["untrigger"] = {
["custom"] = "function()\n    return true\nend",
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["information"] = {
},
["internalVersion"] = 89,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["selfPoint"] = "CENTER",
["id"] = "TargetedSomething",
["frameStrata"] = 1,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["config"] = {
},
["uid"] = "q5ym4JZaZ9A",
["width"] = 200,
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["load"] = {
["use_zone"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["zone"] = "Teldrassil",
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["xOffset"] = 0,
},
["ClassIcon4"] = {
["iconSource"] = -1,
["parent"] = "Party4",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["use_namerealm"] = false,
["classification"] = {
},
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["class"] = "HUNTER",
["event"] = "Unit Characteristics",
["unit"] = "party4",
["use_class"] = false,
["use_unitisunit"] = false,
["spellIds"] = {
},
["use_unit"] = true,
["subeventPrefix"] = "SPELL",
["names"] = {
},
["type"] = "unit",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = true,
["subRegions"] = {
{
["type"] = "subborder",
["border_offset"] = 2,
["border_color"] = {
0.6549019813537598,
0.6274510025978088,
0,
0.5849355757236481,
},
["border_visible"] = true,
["border_edge"] = "Blizzard Tooltip",
["border_size"] = 11,
},
{
["type"] = "subbackground",
},
},
["height"] = 37,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["progressSource"] = {
-1,
"",
},
["icon"] = true,
["useAdjustededMin"] = false,
["regionType"] = "icon",
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
["color"] = {
0.803921639919281,
0.803921639919281,
0.803921639919281,
0.7300000190734863,
},
["cooldown"] = false,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "HUNTER",
["op"] = "==",
},
["changes"] = {
{
["value"] = "626000",
["property"] = "displayIcon",
},
{
["value"] = {
0.3725490272045136,
0.6666666865348816,
0.388235330581665,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["op"] = "==",
["variable"] = "class",
["value"] = "DRUID",
},
["linked"] = true,
["changes"] = {
{
["value"] = "625999",
["property"] = "displayIcon",
},
{
["value"] = {
0.615686297416687,
0.2862745225429535,
0.1098039299249649,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "PRIEST",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626004",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.5843137502670288,
0.5843137502670288,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "ROGUE",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626005",
["property"] = "displayIcon",
},
{
["value"] = {
0.6705882549285889,
0.5529412031173706,
0.294117659330368,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "WARLOCK",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626007",
["property"] = "displayIcon",
},
{
["value"] = {
0.4000000357627869,
0.3764706254005432,
0.6549019813537598,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "WARRIOR",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626008",
["property"] = "displayIcon",
},
{
["value"] = {
0.5607843399047852,
0.2784313857555389,
0.2549019753932953,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "MAGE",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626001",
["property"] = "displayIcon",
},
{
["value"] = {
0.3254902064800263,
0.7215686440467834,
1,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "PALADIN",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626003",
["property"] = "displayIcon",
},
{
["value"] = {
0.572549045085907,
0.3333333432674408,
0.501960813999176,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "SHAMAN",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626006",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.501960813999176,
0.5372549295425415,
1,
},
["property"] = "color",
},
},
},
},
["config"] = {
},
["useCooldownModRate"] = true,
["zoom"] = 0,
["width"] = 37,
["alpha"] = 0.9,
["id"] = "ClassIcon4",
["cooldownTextDisabled"] = false,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = -92,
["uid"] = "AZP9h4wvCOW",
["inverse"] = false,
["useTooltip"] = false,
["displayIcon"] = 136095,
["information"] = {
},
["authorOptions"] = {
},
},
["GCD Only Spells"] = {
["iconSource"] = 1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["use_showLatency"] = false,
["use_genericShowOn"] = true,
["genericShowOn"] = "showOnCooldown",
["subeventPrefix"] = "SPELL",
["use_showgcd"] = true,
["debuffType"] = "HELPFUL",
["type"] = "combatlog",
["subeventSuffix"] = "_CAST_SUCCESS",
["spellName"] = {
"Serpent Sting",
"Hunter's Mark",
},
["use_track"] = true,
["event"] = "Combat Log",
["use_exact_spellName"] = false,
["unit"] = "player",
["use_spellName"] = true,
["spellIds"] = {
},
["use_sourceUnit"] = true,
["names"] = {
},
["duration"] = "1",
["sourceUnit"] = "player",
["use_unit"] = true,
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["authorOptions"] = {
},
["url"] = "Meow",
["useAdjustededMin"] = false,
["regionType"] = "icon",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["progressSource"] = {
-1,
"",
},
["information"] = {
},
["conditions"] = {
},
["uid"] = "IyHjZ)3Kn53",
["cooldownTextDisabled"] = false,
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["useCooldownModRate"] = true,
["id"] = "GCD Only Spells",
["alpha"] = 1,
["frameStrata"] = 1,
["width"] = 26,
["xOffset"] = 0,
["config"] = {
},
["inverse"] = false,
["actions"] = {
["start"] = {
},
["finish"] = {
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["do_sound"] = false,
},
["init"] = {
},
},
["displayIcon"] = 135724,
["cooldown"] = true,
["parent"] = "CooldownGroup",
},
["Point 2"] = {
["user_y"] = 0,
["user_x"] = 0,
["parent"] = "Combo Points",
["adjustedMax"] = "2",
["adjustedMin"] = "1",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["desaturateBackground"] = false,
["sameTexture"] = false,
["backgroundColor"] = {
0.501960813999176,
0.501960813999176,
0.501960813999176,
1,
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_unit"] = true,
["class"] = "ROGUE",
["use_requirePowerType"] = false,
["unit"] = "player",
["use_class"] = true,
["powertype"] = 4,
["spellIds"] = {
},
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["endAngle"] = 360,
["internalVersion"] = 89,
["progressSource"] = {
1,
"power",
},
["selfPoint"] = "CENTER",
["config"] = {
},
["xOffset"] = -40,
["rotation"] = 0,
["font"] = "Friz Quadrata TT",
["foregroundColor"] = {
1,
1,
1,
1,
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 20,
["crop_x"] = 0.41,
["crop_y"] = 0.41,
["preferToUpdate"] = true,
["useAdjustededMax"] = true,
["backgroundTexture"] = "ClassOverlay-ComboPoint-Off",
["authorOptions"] = {
},
["startAngle"] = 0,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["auraRotation"] = 0,
["mirror"] = false,
["useAdjustededMin"] = true,
["regionType"] = "progresstexture",
["desaturateForeground"] = false,
["blendMode"] = "BLEND",
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["slantMode"] = "INSIDE",
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["compress"] = false,
["smoothProgress"] = true,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom_load"] = true,
["custom"] = "if ComboFrame then\n    ComboFrame:Hide()\n    ComboFrame:UnregisterAllEvents()\nend",
["do_custom"] = true,
},
["finish"] = {
},
},
["tocversion"] = 11508,
["id"] = "Point 2",
["foregroundTexture"] = "ComboPoints-ComboPoint",
["frameStrata"] = 1,
["width"] = 20,
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
["uid"] = "OzQ94RY)lFR",
["inverse"] = false,
["fontSize"] = 12,
["orientation"] = "VERTICAL",
["conditions"] = {
},
["information"] = {
},
["backgroundOffset"] = 2,
},
["Point 4"] = {
["user_y"] = 0,
["user_x"] = 0,
["xOffset"] = 40,
["adjustedMax"] = "4",
["adjustedMin"] = "3",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["desaturateBackground"] = false,
["sameTexture"] = false,
["backgroundColor"] = {
0.501960813999176,
0.501960813999176,
0.501960813999176,
1,
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["use_unit"] = true,
["class"] = "ROGUE",
["use_requirePowerType"] = false,
["unit"] = "player",
["use_class"] = true,
["powertype"] = 4,
["spellIds"] = {
},
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["endAngle"] = 360,
["internalVersion"] = 89,
["progressSource"] = {
1,
"power",
},
["selfPoint"] = "CENTER",
["config"] = {
},
["parent"] = "Combo Points",
["rotation"] = 0,
["font"] = "Friz Quadrata TT",
["preferToUpdate"] = true,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 20,
["crop_x"] = 0.41,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["crop_y"] = 0.41,
["useAdjustededMax"] = true,
["fontSize"] = 12,
["backgroundTexture"] = "ClassOverlay-ComboPoint-Off",
["startAngle"] = 0,
["desaturateForeground"] = false,
["uid"] = "EtmL7Q6oe5w",
["mirror"] = false,
["useAdjustededMin"] = true,
["regionType"] = "progresstexture",
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["blendMode"] = "BLEND",
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["slantMode"] = "INSIDE",
["authorOptions"] = {
},
["compress"] = false,
["smoothProgress"] = true,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom_load"] = true,
["custom"] = "if ComboFrame then\n    ComboFrame:Hide()\n    ComboFrame:UnregisterAllEvents()\nend",
["do_custom"] = true,
},
["finish"] = {
},
},
["tocversion"] = 11508,
["id"] = "Point 4",
["foregroundColor"] = {
1,
1,
1,
1,
},
["frameStrata"] = 1,
["width"] = 20,
["foregroundTexture"] = "ComboPoints-ComboPoint",
["auraRotation"] = 0,
["inverse"] = false,
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
["orientation"] = "VERTICAL",
["conditions"] = {
},
["information"] = {
},
["backgroundOffset"] = 2,
},
["ClassIcon0"] = {
["iconSource"] = -1,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["use_namerealm"] = false,
["classification"] = {
},
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["class"] = "HUNTER",
["event"] = "Unit Characteristics",
["unit"] = "player",
["use_class"] = false,
["use_unitisunit"] = false,
["spellIds"] = {
},
["use_unit"] = true,
["subeventPrefix"] = "SPELL",
["names"] = {
},
["type"] = "unit",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["useTooltip"] = false,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = true,
["subRegions"] = {
{
["border_size"] = 11,
["type"] = "subborder",
["border_color"] = {
0.6549019813537598,
0.6274510025978088,
0,
0.5849355757236481,
},
["border_visible"] = true,
["border_edge"] = "Blizzard Tooltip",
["border_offset"] = 2,
},
{
["type"] = "subbackground",
},
},
["height"] = 37,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["parent"] = "Party0",
["keepAspectRatio"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["icon"] = true,
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
["cooldown"] = false,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "HUNTER",
["op"] = "==",
},
["changes"] = {
{
["value"] = "626000",
["property"] = "displayIcon",
},
{
["value"] = {
0.3725490272045136,
0.6666666865348816,
0.388235330581665,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["op"] = "==",
["variable"] = "class",
["value"] = "DRUID",
},
["linked"] = true,
["changes"] = {
{
["value"] = "625999",
["property"] = "displayIcon",
},
{
["value"] = {
0.615686297416687,
0.2862745225429535,
0.1098039299249649,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "PRIEST",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626004",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.5843137502670288,
0.5843137502670288,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "ROGUE",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626005",
["property"] = "displayIcon",
},
{
["value"] = {
0.6705882549285889,
0.5529412031173706,
0.294117659330368,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "WARLOCK",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626007",
["property"] = "displayIcon",
},
{
["value"] = {
0.4000000357627869,
0.3764706254005432,
0.6549019813537598,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "WARRIOR",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626008",
["property"] = "displayIcon",
},
{
["value"] = {
0.5607843399047852,
0.2784313857555389,
0.2549019753932953,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "MAGE",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626001",
["property"] = "displayIcon",
},
{
["value"] = {
0.3254902064800263,
0.7215686440467834,
1,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "PALADIN",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626003",
["property"] = "displayIcon",
},
{
["value"] = {
0.572549045085907,
0.3333333432674408,
0.501960813999176,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "SHAMAN",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626006",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.501960813999176,
0.5372549295425415,
1,
},
["property"] = "color",
},
},
},
},
["config"] = {
},
["alpha"] = 0.9,
["zoom"] = 0,
["width"] = 37,
["useCooldownModRate"] = true,
["id"] = "ClassIcon0",
["cooldownTextDisabled"] = false,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = -92,
["uid"] = "65FEiQiViiB",
["inverse"] = false,
["color"] = {
0.803921639919281,
0.803921639919281,
0.803921639919281,
0.7300000190734863,
},
["displayIcon"] = 136095,
["information"] = {
},
["internalVersion"] = 89,
},
["Leatherworking"] = {
["iconSource"] = -1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["custom"] = "function(event, show)\n    return show\nend",
["spellIds"] = {
},
["events"] = "TOGGLE_PROF_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 2108,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
38,
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["xOffset"] = 0,
["keepAspectRatio"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["preset"] = "spiral",
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["scaley"] = 1,
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["texXOffset"] = 0,
["cooldown"] = false,
["displayIcon"] = 133611,
["config"] = {
},
["authorOptions"] = {
},
["zoom"] = 0,
["width"] = 30,
["useCooldownModRate"] = true,
["id"] = "Leatherworking",
["cooldownTextDisabled"] = false,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["uid"] = "SbPfQdUljCR",
["inverse"] = false,
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_YOffset"] = -1,
["glow_action"] = "show",
["glow_XOffset"] = -1,
["do_custom"] = false,
["do_glow"] = false,
["sound_path"] = "567461",
["do_sound"] = false,
["glow_frame"] = "WeakAuras:ProfessionButton",
["sound_kit_id"] = "567482",
["glow_type"] = "ACShine",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- 1. Create the Secure Button\nlocal btn = CreateFrame(\"Button\", \"MyProfButton1\", aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Leatherworking\")\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(2108) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["hide_all_glows"] = false,
["do_sound"] = false,
["sound_path"] = "567512",
["sound"] = " custom",
["sound_channel"] = "Master",
},
},
["conditions"] = {
},
["information"] = {
},
["parent"] = "ProfessionsGroup",
},
["SoundAlert1"] = {
["authorOptions"] = {
},
["yOffset"] = 0,
["regionType"] = "empty",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["parent"] = "Party1",
["actions"] = {
["start"] = {
["sound_kit_id"] = "727",
["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\wilhelm.ogg",
["sound_path"] = "727",
["do_sound"] = true,
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"30",
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["unit"] = "party1",
["names"] = {
},
["spellIds"] = {
},
["use_specific_unit"] = true,
["use_unit"] = true,
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["anchorPoint"] = "CENTER",
["internalVersion"] = 89,
["frameStrata"] = 1,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "SoundAlert1",
["width"] = 200,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["uid"] = "iVcH(JMehIJ",
["config"] = {
},
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["information"] = {
},
["xOffset"] = 0,
},
["Icons 4"] = {
["iconSource"] = -1,
["xOffset"] = 12.92924499511719,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -2.154996871948242,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "aura_env.region:EnableMouse(true)\naura_env.region:SetScript(\"OnMouseDown\", function(self, button)\n   if button == \"RightButton\" then\n      CancelUnitBuff(\"player\", aura_env.id)\n   end\nend)",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["showClones"] = true,
["type"] = "aura2",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["names"] = {
},
["unit"] = "target",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["desaturate"] = false,
["ignoreWagoUpdate"] = true,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "None",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 39,
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["use_alive"] = true,
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["url"] = "Meow",
["authorOptions"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["parent"] = "TargetBuffs",
["color"] = {
1,
1,
1,
1,
},
["cooldown"] = true,
["icon"] = true,
["config"] = {
},
["zoom"] = 0,
["cooldownTextDisabled"] = false,
["width"] = 39,
["alpha"] = 1,
["id"] = "Icons 4",
["useCooldownModRate"] = true,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["useTooltip"] = true,
["uid"] = "4ijxiP0bVFu",
["inverse"] = false,
["selfPoint"] = "CENTER",
["conditions"] = {
},
["information"] = {
},
["keepAspectRatio"] = false,
},
["Party1"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"BG1",
"SoundAlert1",
"ClickBox1",
"Power1",
"Health1",
"ClassIcon1",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["yOffset"] = -45,
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 2,
["xOffset"] = 0,
["borderColor"] = {
0,
0,
0,
1,
},
["borderInset"] = 1,
["anchorPoint"] = "CENTER",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["parent"] = "BDOPartyFrame",
["borderOffset"] = 4,
["authorOptions"] = {
},
["selfPoint"] = "CENTER",
["id"] = "Party1",
["internalVersion"] = 89,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["uid"] = "KNMivK5X64f",
["frameStrata"] = 1,
["subRegions"] = {
},
["config"] = {
},
["conditions"] = {
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["information"] = {
},
},
["HP Bar"] = {
["sparkWidth"] = 20,
["iconSource"] = -1,
["authorOptions"] = {
},
["preferToUpdate"] = true,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["textureInput"] = "Interface\\AddOns\\WACustomAssets\\StatBar2.tga",
["url"] = "Meow",
["backgroundColor"] = {
0,
0,
0,
1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["selfPoint"] = "CENTER",
["barColor"] = {
1,
0.1725490242242813,
0.062745101749897,
1,
},
["desaturate"] = false,
["sparkOffsetY"] = 0,
["gradientOrientation"] = "HORIZONTAL",
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
["HUNTER"] = true,
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["smoothProgress"] = false,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["overlayclip"] = true,
["texture"] = "Clean",
["zoom"] = 0,
["spark"] = true,
["tocversion"] = 11502,
["alpha"] = 1,
["sparkColor"] = {
1,
1,
1,
0.6789528131484985,
},
["sparkOffsetX"] = -2,
["wagoID"] = "zuOgFOlAp",
["parent"] = "BDO Player Bars",
["adjustedMin"] = "",
["sparkRotationMode"] = "MANUAL",
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["names"] = {
},
["use_showCost"] = true,
["use_unit"] = true,
["use_maxhealth"] = false,
["powertype"] = 0,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["unit"] = "player",
["use_percenthealth"] = false,
["use_powertype"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["version"] = 1,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["border_offset"] = 1,
["type"] = "subborder",
["border_visible"] = true,
["border_color"] = {
0,
0,
0,
1,
},
["anchor_area"] = "bar",
["border_edge"] = "1 Pixel",
["border_size"] = 1,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%1.health/%1.maxhealth",
["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_text_format_1.maxhealth_pad"] = false,
["text_fixedWidth"] = 64,
["rotateText"] = "NONE",
["text_text_format_1.percenthealth_format"] = "Number",
["text_color"] = {
1,
1,
1,
1,
},
["text_text_format_1.maxhealth_format"] = "Number",
["text_shadowYOffset"] = -1,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_text_format_1.health_round_type"] = "floor",
["text_text_format_1.health_pad"] = false,
["text_text_format_1.percenthealth_decimal_precision"] = 0,
["text_fontSize"] = 14,
["anchorXOffset"] = 0,
["text_text_format_1.health_pad_max"] = 8,
["text_text_format_n_format"] = "none",
["text_text_format_1.maxhealth_big_number_format"] = "AbbreviateNumbers",
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_text_format_1.percenthealth_round_type"] = "floor",
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["text_text_format_1.maxhealth_round_type"] = "floor",
["type"] = "subtext",
["text_anchorXOffset"] = 2,
["text_text_format_1.maxhealth_decimal_precision"] = 0,
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.health_pad_mode"] = "left",
["text_anchorYOffset"] = 18,
["text_text_format_1.health_decimal_precision"] = 0,
["text_text_format_1.maxhealth_pad_mode"] = "left",
["text_text_format_1.maxhealth_pad_max"] = 8,
["text_text_format_1.percenthealth_pad"] = false,
["text_visible"] = true,
["anchor_point"] = "SPARK",
["text_text_format_1.health_format"] = "Number",
["text_text_format_1.percenthealth_pad_mode"] = "left",
["text_text_format_1.percenthealth_pad_max"] = 8,
},
},
["height"] = 12,
["textureSource"] = "Picker",
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["config"] = {
},
["icon_side"] = "RIGHT",
["barColor2"] = {
0.5254902243614197,
0.5254902243614197,
0.5254902243614197,
1,
},
["adjustedMax"] = "",
["sparkHeight"] = 28,
["xOffset"] = 0,
["overlaysTexture"] = {
"Details Flat",
},
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWAPlayerProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"player\")\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nif PlayerFrame then\n    PlayerFrame:Hide()\nend",
},
["finish"] = {
},
},
["semver"] = "1.0.0",
["sparkHidden"] = "NEVER",
["id"] = "HP Bar",
["uid"] = "3vB1ZEVfF8(",
["frameStrata"] = 1,
["width"] = 700,
["anchorFrameType"] = "SCREEN",
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["inverse"] = false,
["icon"] = false,
["orientation"] = "HORIZONTAL",
["conditions"] = {
},
["information"] = {
["showNilIsFalse"] = true,
},
["overlays"] = {
{
0.95294123888016,
1,
0.99215692281723,
1,
},
},
},
["Health0"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["xOffset"] = 20,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -4,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["sparkRotationMode"] = "MANUAL",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["use_raid_role"] = false,
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["use_unit"] = true,
["unit"] = "player",
["use_ignoreDisconnected"] = false,
["names"] = {
},
["spellIds"] = {
},
["use_percenthealth"] = false,
["use_maxhealth"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = 1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["barColor"] = {
1,
0.207843154668808,
0,
1,
},
["desaturate"] = false,
["frameStrata"] = 3,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["text_text_format_n_format"] = "none",
["text_text"] = "%1.health",
["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_shadowXOffset"] = 1,
["type"] = "subtext",
["text_anchorYOffset"] = 10,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.health_pad_mode"] = "left",
["text_shadowYOffset"] = -1,
["text_fontType"] = "None",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_text_format_1.health_format"] = "BigNumber",
["text_text_format_1.health_pad"] = false,
["anchor_point"] = "SPARK",
["text_fontSize"] = 10,
["anchorXOffset"] = 0,
["text_text_format_1.health_pad_max"] = 8,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%n %1.raidMark",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_anchorYOffset"] = 14,
["text_text_format_1.raidMark_format"] = "none",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_fontType"] = "None",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_LEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_shadowYOffset"] = -1,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%2.level",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_2.level_format"] = "none",
["type"] = "subtext",
["text_anchorXOffset"] = -21,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = -1,
["text_anchorYOffset"] = -13,
["text_wordWrap"] = "WordWrap",
["text_fontType"] = "None",
["text_text_format_1.level_format"] = "none",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_BOTTOMLEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_visible"] = true,
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["parent"] = "Party0",
["information"] = {
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["height"] = 4,
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["uid"] = "kQJ12DdhaS4",
["config"] = {
},
["icon_side"] = "RIGHT",
["width"] = 180,
["sparkHeight"] = 10,
["texture"] = "Clean",
["iconSource"] = -1,
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["spark"] = true,
["id"] = "Health0",
["sparkHidden"] = "NEVER",
["zoom"] = 0,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["authorOptions"] = {
},
["sparkColor"] = {
1,
1,
1,
1,
},
["inverse"] = false,
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["value"] = "function()\n    return not UnitIsConnected(\"player\")\nend",
["variable"] = "customcheck",
["trigger"] = -1,
},
["changes"] = {
{
["value"] = {
0.4549019932746887,
0.4549019932746887,
0.4549019932746887,
1,
},
["property"] = "barColor",
},
},
},
},
["barColor2"] = {
1,
1,
0,
1,
},
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
},
["BDO Target Bar"] = {
["controlledChildren"] = {
"TargetPVP",
"CastBar",
"EliteClassification",
"TargetBarClickbox",
"Target Name",
"RaceAndThreat",
"EnemyHPSlow",
"EnemyHPInstant",
"EliteTex",
"EnemyMana",
"TargetDebuffs",
"TargetBuffs",
},
["borderBackdrop"] = "Blizzard Dialog Background",
["wagoID"] = "zuOgFOlAp",
["authorOptions"] = {
},
["preferToUpdate"] = false,
["yOffset"] = 679.5543078381247,
["anchorPoint"] = "CENTER",
["sharedFrameLevel"] = false,
["borderColor"] = {
0,
0,
0,
1,
},
["url"] = "Meow",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["event"] = "Health",
["unit"] = "player",
},
["untrigger"] = {
},
},
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["ignoreWagoUpdate"] = true,
["version"] = 1,
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
0.4823529720306397,
0.4823529720306397,
0.4823529720306397,
0.5,
},
["scale"] = 0.55,
["border"] = true,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 13,
["uid"] = "t94MHatU(rj",
["parent"] = "BDO UI Overhaul",
["borderOffset"] = 1,
["semver"] = "1.0.0",
["tocversion"] = 11502,
["id"] = "BDO Target Bar",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["groupIcon"] = 132311,
["borderInset"] = 1,
["alpha"] = 1,
["config"] = {
},
["conditions"] = {
},
["information"] = {
["showNilIsFalse"] = true,
},
["xOffset"] = 0,
},
["Party2"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"BG2",
"SoundAlert2",
"ClickBox2",
"Power2",
"Health2",
"ClassIcon2",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["yOffset"] = -90,
["border"] = false,
["borderEdge"] = "Square Full White",
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
["authorOptions"] = {
},
["borderColor"] = {
0,
0,
0,
1,
},
["config"] = {
},
["regionType"] = "group",
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
["parent"] = "BDOPartyFrame",
["borderOffset"] = 4,
["xOffset"] = 0,
["selfPoint"] = "CENTER",
["id"] = "Party2",
["internalVersion"] = 89,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
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
["uid"] = "LJfeN0I(HVU",
["frameStrata"] = 1,
["subRegions"] = {
},
["borderInset"] = 1,
["conditions"] = {
},
["information"] = {
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
},
["LowHPVignette"] = {
["controlledChildren"] = {
"New 2",
"New 4",
"New 3",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = 109.2354125976563,
["preferToUpdate"] = false,
["groupIcon"] = 136168,
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["names"] = {
},
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["unit"] = "player",
},
["untrigger"] = {
},
},
},
["internalVersion"] = 89,
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
["config"] = {
},
["tocversion"] = 11508,
["id"] = "LowHPVignette",
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
["frameStrata"] = 1,
["uid"] = "QyzWNdxMLlW",
["borderInset"] = 1,
["authorOptions"] = {
},
["conditions"] = {
},
["information"] = {
},
["yOffset"] = -113.7777709960938,
},
["Track Hidden"] = {
["iconSource"] = -1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["sound"] = " custom",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["do_custom"] = false,
["sound_path"] = "567461",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Track Hidden\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(19885) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["spellIds"] = {
},
["custom"] = "function(event, show)\n    return show\nend",
["events"] = "TOGGLE_HUNTER_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 19884,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["preset"] = "spiral",
["duration_type"] = "seconds",
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["translateType"] = "straightTranslate",
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["duration"] = ".1",
},
},
["texXOffset"] = 0,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["keepAspectRatio"] = false,
["parent"] = "HunterGroup",
["cooldown"] = false,
["displayIcon"] = 132320,
["config"] = {
},
["useCooldownModRate"] = true,
["cooldownTextDisabled"] = false,
["width"] = 30,
["alpha"] = 1,
["id"] = "Track Hidden",
["zoom"] = 0,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = 0,
["uid"] = "(vkw(7k25wF",
["inverse"] = false,
["icon"] = true,
["conditions"] = {
},
["information"] = {
},
["authorOptions"] = {
},
},
["New 2"] = {
["parent"] = "LowHPVignette",
["preferToUpdate"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["actions"] = {
["start"] = {
["do_loop"] = false,
["sound_repeat"] = 4,
["do_message"] = false,
["message"] = "",
["do_sound"] = true,
["sound_path"] = "Interface\\AddOns\\WACustomAssets\\LowHP2.ogg",
["sound"] = " custom",
["do_custom"] = false,
["sound_channel"] = "SFX",
},
["finish"] = {
["do_sound_fade"] = true,
["stop_sound"] = true,
["stop_sound_fade"] = 2,
["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\heartbeat.ogg",
["do_sound"] = false,
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"50",
},
["event"] = "Health",
["unit"] = "player",
["names"] = {
},
["spellIds"] = {
},
["use_unit"] = true,
["subeventPrefix"] = "SPELL",
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Action Usable",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 5384,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeIn",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["duration"] = ".25",
["colorA"] = 1,
["rotate"] = 0,
["easeStrength"] = 3,
["preset"] = "fade",
["scalex"] = 1,
},
["main"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "alphaPulse",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    local angle = (progress * 2 * math.pi) - (math.pi / 2)\n    return start + (((math.sin(angle) + 1)/2) * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["scaley"] = 1,
["alpha"] = 0.7000000000000001,
["y"] = 0,
["x"] = 0,
["colorA"] = 1,
["preset"] = "pulse",
["rotate"] = 0,
["easeStrength"] = 3,
["scalex"] = 1,
["duration"] = ".75",
},
["finish"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOut",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["rotate"] = 0,
["duration"] = "1",
["scalex"] = 1,
},
},
["desaturate"] = false,
["rotation"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 1200,
["rotate"] = false,
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["mirror"] = false,
["regionType"] = "texture",
["blendMode"] = "ADD",
["texture"] = "PhotosensitivityWarning-vignette",
["config"] = {
},
["color"] = {
1,
0,
0.007843137718737125,
1,
},
["tocversion"] = 11508,
["id"] = "New 2",
["width"] = 2000,
["frameStrata"] = 2,
["anchorFrameType"] = "UIPARENT",
["alpha"] = 1,
["uid"] = "6xgZAWJtVb6",
["authorOptions"] = {
},
["xOffset"] = 0,
["conditions"] = {
},
["information"] = {
},
["selfPoint"] = "CENTER",
},
["RangeCheck"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"WithinRange",
"WithinMelee",
"WithinRangeSound",
"WithinRangeNameplate",
},
["borderBackdrop"] = "Blizzard Tooltip",
["authorOptions"] = {
},
["yOffset"] = 0,
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 2,
["xOffset"] = 0,
["borderColor"] = {
0,
0,
0,
1,
},
["borderInset"] = 1,
["groupIcon"] = 133260,
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
["anchorPoint"] = "CENTER",
["borderOffset"] = 4,
["scale"] = 1,
["selfPoint"] = "CENTER",
["id"] = "RangeCheck",
["internalVersion"] = 89,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
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
["uid"] = "iuWT9f(NGR(",
["alpha"] = 1,
["subRegions"] = {
},
["config"] = {
},
["conditions"] = {
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
["information"] = {
},
},
["Feign Death"] = {
["iconSource"] = 1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["url"] = "Meow",
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
["do_sound"] = true,
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound_channel"] = "SFX",
},
},
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["spellName"] = 5384,
["subeventSuffix"] = "_CAST_START",
["names"] = {
},
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["unit"] = "player",
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["genericShowOn"] = "showOnCooldown",
["use_exact_spellName"] = false,
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["progressSource"] = {
-1,
"",
},
["xOffset"] = 0,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["cooldownEdge"] = false,
["useTooltip"] = true,
["cooldown"] = true,
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
["config"] = {
},
["authorOptions"] = {
},
["zoom"] = 0,
["width"] = 26,
["alpha"] = 1,
["id"] = "Feign Death",
["frameStrata"] = 1,
["useCooldownModRate"] = true,
["anchorFrameType"] = "SCREEN",
["cooldownTextDisabled"] = false,
["uid"] = "RBVenINciNR",
["inverse"] = false,
["parent"] = "CooldownGroup",
["conditions"] = {
},
["information"] = {
},
["icon"] = true,
},
["New 4"] = {
["parent"] = "LowHPVignette",
["preferToUpdate"] = false,
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["actions"] = {
["start"] = {
["do_loop"] = true,
["message"] = "",
["do_message"] = false,
["do_sound"] = false,
["sound_path"] = "Interface\\AddOns\\LowHPVignette\\Sounds\\LowHPVignette\\LowHP.mp3",
["do_custom"] = false,
["sound"] = " custom",
["sound_channel"] = "SFX",
},
["init"] = {
},
["finish"] = {
["stop_sound"] = true,
["do_sound"] = false,
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["percenthealth"] = {
"50",
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["unit"] = "player",
["spellIds"] = {
},
["names"] = {
},
["use_unit"] = true,
["use_percenthealth"] = true,
["percenthealth_operator"] = {
"<=",
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Action Usable",
["unit"] = "player",
["use_spellName"] = true,
["spellName"] = 5384,
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["rotation"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 1200,
["rotate"] = false,
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
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["mirror"] = false,
["regionType"] = "texture",
["blendMode"] = "BLEND",
["texture"] = "PhotosensitivityWarning-vignette",
["uid"] = "huRMofeyJai",
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeIn",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["duration"] = ".25",
["colorA"] = 1,
["rotate"] = 0,
["easeStrength"] = 3,
["preset"] = "fade",
["scalex"] = 1,
},
["main"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "alphaPulse",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    local angle = (progress * 2 * math.pi) - (math.pi / 2)\n    return start + (((math.sin(angle) + 1)/2) * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["scaley"] = 1,
["alpha"] = 0.7000000000000001,
["y"] = 0,
["x"] = 0,
["duration"] = ".75",
["scalex"] = 1,
["easeStrength"] = 3,
["rotate"] = 0,
["preset"] = "pulse",
["colorA"] = 1,
},
["finish"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOut",
["scaley"] = 1,
["alpha"] = 0,
["y"] = 0,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["rotate"] = 0,
["duration"] = "1",
["scalex"] = 1,
},
},
["tocversion"] = 11508,
["id"] = "New 4",
["width"] = 2000,
["alpha"] = 0.8,
["anchorFrameType"] = "UIPARENT",
["frameStrata"] = 2,
["config"] = {
},
["authorOptions"] = {
},
["color"] = {
1,
0,
0.062745101749897,
1,
},
["conditions"] = {
},
["information"] = {
},
["xOffset"] = 0,
},
["Cooking"] = {
["texXOffset"] = 0,
["parent"] = "ProfessionsGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["spellIds"] = {
},
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_PROF_MENU",
["custom"] = "function(event, show)\n    return show\nend",
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["debuffType"] = "HELPFUL",
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["spellName"] = 2550,
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
38,
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration"] = ".1",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["preset"] = "spiral",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["scalex"] = 1,
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["translateType"] = "straightTranslate",
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["duration"] = ".1",
},
},
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_YOffset"] = -1,
["glow_XOffset"] = -1,
["do_custom"] = false,
["sound_path"] = "567461",
["do_glow"] = false,
["glow_action"] = "show",
["glow_frame"] = "WeakAuras:ProfessionButton",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["glow_type"] = "ACShine",
["sound"] = " custom",
["sound_channel"] = "Master",
},
["finish"] = {
["hide_all_glows"] = false,
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567512",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- 1. Create the Secure Button\nlocal btn = CreateFrame(\"Button\", \"MyProfButton1\", aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Cooking\")\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(2550) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["authorOptions"] = {
},
["iconSource"] = -1,
["information"] = {
},
["conditions"] = {
},
["uid"] = "ejLCJB8TDIe",
["frameStrata"] = 1,
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["id"] = "Cooking",
["cooldownTextDisabled"] = false,
["useCooldownModRate"] = true,
["width"] = 30,
["keepAspectRatio"] = false,
["config"] = {
},
["inverse"] = false,
["xOffset"] = 0,
["displayIcon"] = 133971,
["cooldown"] = false,
["color"] = {
1,
1,
1,
1,
},
},
["Track Elementals"] = {
["iconSource"] = -1,
["parent"] = "HunterGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["custom"] = "function(event, show)\n    return show\nend",
["spellIds"] = {
},
["events"] = "TOGGLE_HUNTER_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["debuffType"] = "HELPFUL",
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["spellName"] = 19880,
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["duration_type"] = "seconds",
["y"] = -10,
["x"] = 0,
["translateType"] = "straightTranslate",
["rotate"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["preset"] = "spiral",
["scalex"] = 1,
},
["main"] = {
["type"] = "none",
["easeStrength"] = 3,
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["translateType"] = "straightTranslate",
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["colorR"] = 1,
["y"] = -10,
["x"] = 0,
["colorA"] = 1,
["easeStrength"] = 3,
["duration_type"] = "seconds",
["rotate"] = 0,
["scaley"] = 1,
["scalex"] = 1,
},
},
["actions"] = {
["start"] = {
["sound"] = " custom",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["do_custom"] = false,
["sound_path"] = "567461",
["sound_channel"] = "Master",
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Track Elementals\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(19880) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
["finish"] = {
["do_sound"] = false,
["sound"] = " custom",
["sound_path"] = "567482",
["sound_channel"] = "Master",
},
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["authorOptions"] = {
},
["progressSource"] = {
-1,
"",
},
["cooldown"] = false,
["displayIcon"] = 135861,
["config"] = {
},
["useCooldownModRate"] = true,
["cooldownTextDisabled"] = false,
["width"] = 30,
["alpha"] = 1,
["id"] = "Track Elementals",
["zoom"] = 0,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["color"] = {
1,
1,
1,
1,
},
["uid"] = "UTmigWRcfay",
["inverse"] = false,
["xOffset"] = 0,
["conditions"] = {
},
["information"] = {
},
["texXOffset"] = 0,
},
["EliteClassification"] = {
["outline"] = "None",
["displayText_format_1.classification_abbreviate_max"] = 8,
["displayText_format_1.classification_pad_mode"] = "left",
["displayText_format_1.classification_color"] = true,
["authorOptions"] = {
},
["displayText"] = "%1.classification",
["shadowYOffset"] = 0,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Unit Characteristics",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "target",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["internalVersion"] = 89,
["selfPoint"] = "BOTTOM",
["font"] = "2002 Bold",
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["url"] = "Meow",
["fontSize"] = 20,
["displayText_format_1.classification_abbreviate"] = false,
["information"] = {
},
["shadowXOffset"] = 0,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "classification",
["value"] = "normal",
["op"] = "==",
},
["linked"] = false,
["changes"] = {
{
["value"] = {
1,
1,
1,
0,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "classification",
["value"] = "elite",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = {
1,
0.9098039865493774,
0,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["op"] = "==",
["variable"] = "classification",
["value"] = "rare",
},
["linked"] = true,
["changes"] = {
{
["value"] = {
0.8078432083129883,
0.8078432083129883,
0.8078432083129883,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "classification",
["value"] = "rareelite",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = {
1,
0.3372549116611481,
0,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "classification",
["value"] = "normal",
["op"] = "~=",
},
["linked"] = true,
["changes"] = {
{
["value"] = {
0,
0.125490203499794,
1,
1,
},
["property"] = "color",
},
},
},
},
["displayText_format_p_time_legacy_floor"] = false,
["displayText_format_p_time_dynamic_threshold"] = 60,
["regionType"] = "text",
["xOffset"] = 258.5302644595857,
["config"] = {
},
["displayText_format_1.classification_pad_max"] = 8,
["displayText_format_1.classification_realm_name"] = "never",
["displayText_format_p_time_precision"] = 1,
["color"] = {
1,
1,
1,
1,
},
["displayText_format_1.classification_format"] = "string",
["displayText_format_1.classification_pad"] = false,
["justify"] = "CENTER",
["yOffset"] = 1.44,
["id"] = "EliteClassification",
["displayText_format_p_time_mod_rate"] = true,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["uid"] = "kJja7ti7Wx5",
["ignoreWagoUpdate"] = true,
["parent"] = "BDO Target Bar",
["shadowColor"] = {
0,
0,
0,
0,
},
["fixedWidth"] = 200,
["displayText_format_1.classification_big_number_format"] = "AbbreviateNumbers",
["wordWrap"] = "WordWrap",
},
["ProfessionButton"] = {
["iconSource"] = -1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Unit Characteristics",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "any",
["customTriggerLogic"] = "function()\n    return true\nend",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
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
["useAdjustededMin"] = false,
["regionType"] = "icon",
["displayIcon"] = 136241,
["xOffset"] = 0,
["parent"] = "ProfessionFolder",
["cooldown"] = true,
["keepAspectRatio"] = false,
["config"] = {
},
["cooldownTextDisabled"] = false,
["zoom"] = 0,
["width"] = 30,
["id"] = "ProfessionButton",
["useCooldownModRate"] = true,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["uid"] = "NFFwKKsqCD2",
["inverse"] = false,
["authorOptions"] = {
},
["conditions"] = {
},
["information"] = {
},
["actions"] = {
["start"] = {
["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AcousticGuitar.ogg",
["do_sound"] = false,
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- 1. Create the Secure Button\nlocal btn = CreateFrame(\"Button\", \"ProfAnchorBtn\", aura_env.region, \"SecureActionButtonTemplate\")\nbtn:SetAllPoints()\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Create the INVISIBLE \"Dummy\" window brain\nif not _G.MyWAProfMenuEscapeFrame then\n    local escFrame = CreateFrame(\"Frame\", \"MyWAProfMenuEscapeFrame\", UIParent)\n    escFrame:Hide()\n    tinsert(_G.UISpecialFrames, \"MyWAProfMenuEscapeFrame\")\n    \n    -- When this frame is SHOWN (via macro), tell icons to show\n    escFrame:SetScript(\"OnShow\", function()\n            -- Tell others to close\n            if MyWAHunterMenuEscapeFrame then MyWAHunterMenuEscapeFrame:Hide() end\n            if MyWAPetMenuEscapeFrame then MyWAPetMenuEscapeFrame:Hide() end\n            \n            _G.WA_PROF_OPEN = true\n            _G.WeakAuras.ScanEvents(\"TOGGLE_PROF_MENU\", true)\n    end)\n    \n    -- When this frame is HIDDEN (via Escape or macro), tell icons to hide\n    escFrame:SetScript(\"OnHide\", function()\n            _G.WA_PROF_OPEN = false\n            _G.WeakAuras.ScanEvents(\"TOGGLE_PROF_MENU\", false)\n    end)\n    \n    -- Close on combat\n    escFrame:RegisterEvent(\"PLAYER_REGEN_DISABLED\")\n    escFrame:SetScript(\"OnEvent\", function(self) self:Hide() end)\nend\n\n-- 3. The Toggle Macro (Now super simple)\n-- It just flips the dummy frame. The frame's own scripts handle the rest.\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", [[\n/run if MyWAProfMenuEscapeFrame:IsShown() then MyWAProfMenuEscapeFrame:Hide() else MyWAProfMenuEscapeFrame:Show() end\n]])\n\n-- 4. Sync initial state\n_G.WA_PROF_OPEN = false",
},
["finish"] = {
},
},
},
["ClassIcon2"] = {
["iconSource"] = -1,
["color"] = {
0.803921639919281,
0.803921639919281,
0.803921639919281,
0.7300000190734863,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["use_namerealm"] = false,
["classification"] = {
},
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["class"] = "HUNTER",
["event"] = "Unit Characteristics",
["unit"] = "party2",
["use_class"] = false,
["use_unitisunit"] = false,
["spellIds"] = {
},
["use_unit"] = true,
["subeventPrefix"] = "SPELL",
["names"] = {
},
["type"] = "unit",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["desaturate"] = true,
["subRegions"] = {
{
["border_offset"] = 2,
["border_size"] = 11,
["border_color"] = {
0.6549019813537598,
0.6274510025978088,
0,
0.5849355757236481,
},
["border_visible"] = true,
["border_edge"] = "Blizzard Tooltip",
["type"] = "subborder",
},
{
["type"] = "subbackground",
},
},
["height"] = 37,
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["selfPoint"] = "CENTER",
["authorOptions"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["useTooltip"] = false,
["parent"] = "Party2",
["cooldown"] = false,
["conditions"] = {
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "HUNTER",
["op"] = "==",
},
["changes"] = {
{
["value"] = "626000",
["property"] = "displayIcon",
},
{
["value"] = {
0.3725490272045136,
0.6666666865348816,
0.388235330581665,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["op"] = "==",
["variable"] = "class",
["value"] = "DRUID",
},
["linked"] = true,
["changes"] = {
{
["value"] = "625999",
["property"] = "displayIcon",
},
{
["value"] = {
0.615686297416687,
0.2862745225429535,
0.1098039299249649,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "PRIEST",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626004",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.5843137502670288,
0.5843137502670288,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "ROGUE",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626005",
["property"] = "displayIcon",
},
{
["value"] = {
0.6705882549285889,
0.5529412031173706,
0.294117659330368,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "WARLOCK",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626007",
["property"] = "displayIcon",
},
{
["value"] = {
0.4000000357627869,
0.3764706254005432,
0.6549019813537598,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "WARRIOR",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626008",
["property"] = "displayIcon",
},
{
["value"] = {
0.5607843399047852,
0.2784313857555389,
0.2549019753932953,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "MAGE",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626001",
["property"] = "displayIcon",
},
{
["value"] = {
0.3254902064800263,
0.7215686440467834,
1,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "PALADIN",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626003",
["property"] = "displayIcon",
},
{
["value"] = {
0.572549045085907,
0.3333333432674408,
0.501960813999176,
1,
},
["property"] = "color",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "class",
["value"] = "SHAMAN",
["op"] = "==",
},
["linked"] = true,
["changes"] = {
{
["value"] = "626006",
["property"] = "displayIcon",
},
{
["value"] = {
0.5843137502670288,
0.501960813999176,
0.5372549295425415,
1,
},
["property"] = "color",
},
},
},
},
["config"] = {
},
["keepAspectRatio"] = false,
["zoom"] = 0,
["width"] = 37,
["useCooldownModRate"] = true,
["id"] = "ClassIcon2",
["cooldownTextDisabled"] = false,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["alpha"] = 0.9,
["uid"] = "Ihg)W465lGZ",
["inverse"] = false,
["xOffset"] = -92,
["displayIcon"] = 136095,
["information"] = {
},
["actions"] = {
["start"] = {
},
["init"] = {
["do_custom"] = true,
["custom"] = "",
},
["finish"] = {
},
},
},
["PackWarning"] = {
["iconSource"] = -1,
["xOffset"] = 1.57940673828125,
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -135.1116638183594,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_incombat"] = true,
["subeventSuffix"] = "_CAST_START",
["event"] = "Conditions",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "player",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
{
["trigger"] = {
["useName"] = true,
["auranames"] = {
13159,
"13160",
},
["use_genericShowOn"] = true,
["event"] = "Unit Characteristics",
["unit"] = "player",
["type"] = "aura2",
["use_spellName"] = true,
["form"] = {
["single"] = 0,
},
["genericShowOn"] = "showOnCooldown",
["use_unit"] = true,
["use_form"] = true,
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["type"] = "preset",
["easeType"] = "none",
["duration_type"] = "seconds",
["easeStrength"] = 3,
["preset"] = "fade",
},
["main"] = {
["type"] = "preset",
["easeType"] = "none",
["duration_type"] = "seconds",
["easeStrength"] = 3,
["preset"] = "pulse",
},
["finish"] = {
["type"] = "preset",
["easeType"] = "none",
["duration_type"] = "seconds",
["easeStrength"] = 3,
["preset"] = "fade",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 100,
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["conditions"] = {
},
["information"] = {
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["selfPoint"] = "CENTER",
["authorOptions"] = {
},
["zoom"] = 0,
["cooldownTextDisabled"] = false,
["uid"] = "fhlWs0XzSSu",
["alpha"] = 1,
["id"] = "PackWarning",
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["width"] = 100,
["useCooldownModRate"] = true,
["config"] = {
},
["inverse"] = false,
["color"] = {
1,
0.05490196496248245,
0,
1,
},
["displayIcon"] = 132267,
["cooldown"] = false,
["progressSource"] = {
-1,
"",
},
},
["CombatFX"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"DarkenVignette",
"InCombatSFX",
"OutOfCombatSFXRandom",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = 0,
["yOffset"] = 0,
["border"] = false,
["borderEdge"] = "Square Full White",
["regionType"] = "group",
["borderSize"] = 2,
["authorOptions"] = {
},
["borderColor"] = {
0,
0,
0,
1,
},
["config"] = {
},
["groupIcon"] = 136235,
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
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["anchorPoint"] = "CENTER",
["borderOffset"] = 4,
["scale"] = 1,
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
["id"] = "CombatFX",
["internalVersion"] = 89,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["borderInset"] = 1,
["frameStrata"] = 1,
["subRegions"] = {
},
["uid"] = "i0k)QOwxrhh",
["conditions"] = {
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
["information"] = {
},
},
["Power4"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -12,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["use_power"] = false,
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_maxhealth"] = false,
["spellIds"] = {
},
["unit"] = "party4",
["use_unit"] = true,
["use_percenthealth"] = false,
["use_powertype"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["barColor"] = {
0.207843154668808,
0.658823549747467,
1,
1,
},
["desaturate"] = false,
["frameStrata"] = 3,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["border_offset"] = 0,
["type"] = "subborder",
["border_visible"] = false,
["border_color"] = {
1,
1,
1,
1,
},
["anchor_area"] = "bar",
["border_edge"] = "Square Full White",
["border_size"] = 2,
},
},
["height"] = 4,
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"5",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["iconSource"] = -1,
["barColor2"] = {
1,
1,
0,
1,
},
["xOffset"] = 20,
["sparkRotationMode"] = "AUTO",
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["sparkColor"] = {
1,
1,
1,
1,
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["config"] = {
},
["gradientOrientation"] = "HORIZONTAL",
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 30,
["texture"] = "Clean",
["parent"] = "Party4",
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["spark"] = false,
["sparkHidden"] = "NEVER",
["id"] = "Power4",
["zoom"] = 0,
["alpha"] = 1,
["width"] = 180,
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
["uid"] = ")YhqgY2GAqo",
["inverse"] = false,
["enableGradient"] = false,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = -1,
["variable"] = "customcheck",
["value"] = "function()\n    return not UnitIsConnected(\"party4\")\nend",
},
["changes"] = {
{
["value"] = {
0.4117647409439087,
0.4117647409439087,
0.4117647409439087,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["value"] = 1,
["op"] = "==",
},
["changes"] = {
{
["value"] = {
1,
0.5058823823928833,
0.07450980693101883,
1,
},
["property"] = "barColor",
},
},
},
},
["information"] = {
},
["icon"] = false,
},
["Disengage"] = {
["iconSource"] = 1,
["parent"] = "CooldownGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
["do_sound"] = true,
["sound"] = " custom",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound_channel"] = "SFX",
},
},
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["spellName"] = 781,
["subeventSuffix"] = "_CAST_START",
["names"] = {
},
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["unit"] = "player",
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["subeventPrefix"] = "SPELL",
["genericShowOn"] = "showOnCooldown",
["use_exact_spellName"] = false,
["use_track"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
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
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["useGlowColor"] = false,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["glowDuration"] = 1,
["glowXOffset"] = 0,
["glow"] = false,
["glowScale"] = 1,
["glowThickness"] = 1,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["keepAspectRatio"] = false,
["icon"] = true,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["url"] = "Meow",
["useTooltip"] = true,
["cooldown"] = true,
["authorOptions"] = {
},
["config"] = {
},
["cooldownTextDisabled"] = false,
["zoom"] = 0,
["width"] = 26,
["alpha"] = 1,
["id"] = "Disengage",
["useCooldownModRate"] = true,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["xOffset"] = 0,
["uid"] = "HzCUCPYvQJs",
["inverse"] = false,
["selfPoint"] = "CENTER",
["conditions"] = {
},
["information"] = {
},
["color"] = {
1,
1,
1,
1,
},
},
["Party4"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"BG4",
"SoundAlert4",
"ClickBox4",
"Power4",
"Health4",
"ClassIcon4",
},
["borderBackdrop"] = "Blizzard Tooltip",
["scale"] = 1,
["yOffset"] = -180,
["border"] = false,
["borderEdge"] = "Square Full White",
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
["authorOptions"] = {
},
["borderColor"] = {
0,
0,
0,
1,
},
["uid"] = "pOREWvMZDtB",
["regionType"] = "group",
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
["parent"] = "BDOPartyFrame",
["borderOffset"] = 4,
["xOffset"] = 0,
["selfPoint"] = "CENTER",
["id"] = "Party4",
["internalVersion"] = 89,
["alpha"] = 1,
["anchorFrameType"] = "SCREEN",
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
["borderInset"] = 1,
["frameStrata"] = 1,
["subRegions"] = {
},
["config"] = {
},
["conditions"] = {
},
["information"] = {
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
},
["TargetRace"] = {
["displayText_format_1.unit_color"] = "class",
["xOffset"] = 0,
["displayText_format_p_time_dynamic_threshold"] = 60,
["customText"] = "function()\n    local race = UnitRace(\"target\")\n    local type = UnitCreatureType(\"target\")\n    return race or type or \"\"\nend",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["displayText"] = "%c",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
["do_custom"] = false,
["custom"] = "local region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWATargetProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"target\")\n\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nRegisterUnitWatch(btn) \n\nbtn:SetFrameStrata(\"MEDIUM\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nlocal bg = btn:CreateTexture(nil, \"BACKGROUND\")\nbg:SetAllPoints(btn)\nbg:SetColorTexture(0, 0, 0, 0)\n\nif TargetFrame then\n    TargetFrame:Hide()\nend",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["names"] = {
},
["spellIds"] = {
},
["use_unit"] = true,
["subeventPrefix"] = "SPELL",
["unit"] = "target",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["displayText_format_p_format"] = "timed",
["internalVersion"] = 89,
["wordWrap"] = "WordWrap",
["selfPoint"] = "BOTTOM",
["displayText_format_1.unit_pad_max"] = 8,
["displayText_format_1.npcId_abbreviate"] = false,
["conditions"] = {
},
["outline"] = "None",
["font"] = "Friz Quadrata TT",
["displayText_format_1.unit_realm_name"] = "never",
["displayText_format_c_format"] = "none",
["shadowYOffset"] = -1,
["displayText_format_1.unit_pad"] = false,
["load"] = {
["use_hardcore"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_alive"] = true,
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["displayText_format_1.npcId_pad_mode"] = "left",
["ignoreWagoUpdate"] = true,
["fontSize"] = 19,
["config"] = {
},
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["shadowXOffset"] = 1,
["displayText_format_1.unit_pad_mode"] = "left",
["information"] = {
},
["displayText_format_p_time_legacy_floor"] = false,
["regionType"] = "text",
["displayText_format_1.npcId_pad_max"] = 8,
["displayText_format_p_time_mod_rate"] = true,
["displayText_format_1.npcId_pad"] = false,
["authorOptions"] = {
},
["displayText_format_p_time_precision"] = 1,
["parent"] = "RaceAndThreat",
["color"] = {
1,
1,
1,
1,
},
["displayText_format_1.unit_abbreviate"] = false,
["justify"] = "CENTER",
["displayText_format_1.unit_format"] = "Unit",
["id"] = "TargetRace",
["displayText_format_1.npcId_abbreviate_max"] = 8,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["displayText_format_1.npcId_format"] = "string",
["uid"] = "6uh4wf78tLK",
["url"] = "Meow",
["displayText_format_1.unit_abbreviate_max"] = 8,
["shadowColor"] = {
0,
0,
0,
1,
},
["fixedWidth"] = 200,
["displayText_format_1.class_format"] = "none",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
},
["ConcussiveShot"] = {
["iconSource"] = 1,
["color"] = {
1,
1,
1,
1,
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
},
["finish"] = {
["sound_channel"] = "SFX",
["sound_path"] = "Sound\\interface\\MagicClick.ogg",
["sound"] = " custom",
["do_sound"] = true,
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["track"] = "auto",
["type"] = "spell",
["debuffType"] = "HELPFUL",
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["use_genericShowOn"] = true,
["event"] = "Cooldown Progress (Spell)",
["names"] = {
},
["use_showgcd"] = true,
["use_spellName"] = true,
["spellIds"] = {
},
["use_exact_spellName"] = false,
["genericShowOn"] = "showOnCooldown",
["subeventPrefix"] = "SPELL",
["use_track"] = true,
["spellName"] = 5116,
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 26,
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["uid"] = "kaFSmchqGBs",
["keepAspectRatio"] = false,
["xOffset"] = 0,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["useTooltip"] = true,
["information"] = {
},
["conditions"] = {
},
["icon"] = true,
["zoom"] = 0,
["anchorFrameType"] = "SCREEN",
["cooldownTextDisabled"] = false,
["useCooldownModRate"] = true,
["url"] = "Meow",
["id"] = "ConcussiveShot",
["frameStrata"] = 1,
["alpha"] = 1,
["width"] = 26,
["parent"] = "CooldownGroup",
["config"] = {
},
["inverse"] = false,
["authorOptions"] = {
},
["displayIcon"] = "",
["cooldown"] = true,
["selfPoint"] = "CENTER",
},
["AudioAndFX"] = {
["authorOptions"] = {
},
["yOffset"] = -1,
["regionType"] = "empty",
["information"] = {
},
["parent"] = "HunterGroup",
["actions"] = {
["start"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["glow_YOffset"] = -1,
["glow_action"] = "show",
["do_glow"] = true,
["glow_XOffset"] = -1,
["do_sound"] = true,
["sound_path"] = "567461",
["glow_type"] = "ACShine",
["sound"] = " custom",
["glow_frame"] = "HunterAnchorBtn",
},
["init"] = {
},
["finish"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["hide_all_glows"] = true,
["glow_action"] = "show",
["glow_type"] = "ACShine",
["glow_frame"] = "HunterAnchorBtn",
["do_glow"] = false,
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["custom_hide"] = "custom",
["custom"] = "function(event, show)\n    return show\nend",
["spellIds"] = {
},
["events"] = "TOGGLE_HUNTER_MENU",
["custom_type"] = "event",
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["anchorPoint"] = "CENTER",
["internalVersion"] = 89,
["alpha"] = 1,
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
["id"] = "AudioAndFX",
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["width"] = 200,
["config"] = {
},
["uid"] = "CFApb9sLpWk",
["selfPoint"] = "CENTER",
["subRegions"] = {
},
["height"] = 200,
["conditions"] = {
},
["load"] = {
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["xOffset"] = 0,
},
["Tame Beast"] = {
["texXOffset"] = 0,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["sound"] = " custom",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["do_custom"] = false,
["sound_path"] = "567461",
["sound_channel"] = "Master",
},
["finish"] = {
["sound_channel"] = "Master",
["sound_path"] = "567482",
["sound"] = " custom",
["do_sound"] = false,
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Tame Beast\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(1515) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["spellIds"] = {
},
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_PET_MENU",
["custom"] = "function(event, show)\n    return show\nend",
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
["disjunctive"] = "any",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["preset"] = "spiral",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["scaley"] = 1,
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_class"] = true,
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["selfPoint"] = "CENTER",
["color"] = {
1,
1,
1,
1,
},
["useAdjustededMin"] = false,
["regionType"] = "icon",
["parent"] = "PetGroup",
["progressSource"] = {
-1,
"",
},
["information"] = {
},
["conditions"] = {
},
["uid"] = "mbSyHfa3us6",
["frameStrata"] = 1,
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["id"] = "Tame Beast",
["zoom"] = 0,
["useCooldownModRate"] = true,
["width"] = 30,
["icon"] = true,
["config"] = {
},
["inverse"] = false,
["iconSource"] = -1,
["displayIcon"] = 132164,
["cooldown"] = false,
["xOffset"] = 0,
},
["BDO Player Bars"] = {
["controlledChildren"] = {
"Combo Points",
"Buffs",
"Debuffs",
"PlayerBarClickbox",
"HP Bar",
"Mana Bar",
},
["borderBackdrop"] = "Blizzard Dialog Background",
["wagoID"] = "zuOgFOlAp",
["xOffset"] = -1.356755987920327,
["preferToUpdate"] = true,
["groupIcon"] = 132311,
["anchorPoint"] = "CENTER",
["sharedFrameLevel"] = false,
["borderColor"] = {
0,
0,
0,
1,
},
["url"] = "Meow",
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
["subeventPrefix"] = "SPELL",
["unit"] = "player",
["event"] = "Health",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
},
["internalVersion"] = 89,
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
["version"] = 1,
["subRegions"] = {
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["backdropColor"] = {
0.4823529720306397,
0.4823529720306397,
0.4823529720306397,
0.5,
},
["scale"] = 0.55,
["border"] = true,
["borderEdge"] = "Blizzard Chat Bubble",
["regionType"] = "group",
["borderSize"] = 12,
["uid"] = "GnTMtWQWu1B",
["selfPoint"] = "CENTER",
["borderOffset"] = 3,
["semver"] = "1.0.0",
["tocversion"] = 11502,
["id"] = "BDO Player Bars",
["yOffset"] = -489.9041848506278,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["alpha"] = 1,
["borderInset"] = 1,
["config"] = {
},
["authorOptions"] = {
},
["conditions"] = {
},
["information"] = {
["showNilIsFalse"] = true,
},
["parent"] = "BDO UI Overhaul",
},
["Power0"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["authorOptions"] = {
},
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -12,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["sparkRotationMode"] = "AUTO",
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_specific_unit"] = true,
["use_power"] = false,
["event"] = "Power",
["subeventPrefix"] = "SPELL",
["names"] = {
},
["use_maxhealth"] = false,
["spellIds"] = {
},
["unit"] = "player",
["use_unit"] = true,
["use_percenthealth"] = false,
["use_powertype"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["selfPoint"] = "CENTER",
["barColor"] = {
0.207843154668808,
0.658823549747467,
1,
1,
},
["desaturate"] = false,
["frameStrata"] = 3,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["type"] = "subborder",
["border_size"] = 2,
["border_visible"] = false,
["border_color"] = {
1,
1,
1,
1,
},
["anchor_area"] = "bar",
["border_edge"] = "Square Full White",
["border_offset"] = 0,
},
},
["height"] = 4,
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["iconSource"] = -1,
["barColor2"] = {
1,
1,
0,
1,
},
["xOffset"] = 20,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["actions"] = {
["start"] = {
},
["init"] = {
},
["finish"] = {
},
},
["config"] = {
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["uid"] = "SkAadek6(JU",
["gradientOrientation"] = "HORIZONTAL",
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 30,
["texture"] = "Clean",
["parent"] = "Party0",
["zoom"] = 0,
["spark"] = false,
["sparkHidden"] = "NEVER",
["id"] = "Power0",
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["alpha"] = 1,
["width"] = 180,
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
["sparkColor"] = {
1,
1,
1,
1,
},
["inverse"] = false,
["enableGradient"] = false,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = -1,
["variable"] = "customcheck",
["op"] = "",
["value"] = "function()\n    return not UnitIsConnected(\"player\")\nend",
},
["changes"] = {
{
["value"] = {
0.4117647409439087,
0.4117647409439087,
0.4117647409439087,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["value"] = 1,
["op"] = "==",
},
["changes"] = {
{
["value"] = {
1,
0.5058823823928833,
0.07450980693101883,
1,
},
["property"] = "barColor",
},
},
},
},
["information"] = {
},
["icon"] = false,
},
["PetButton"] = {
["iconSource"] = -1,
["parent"] = "PetFolder",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = true,
["cooldownEdge"] = false,
["icon"] = true,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Unit Characteristics",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "player",
["names"] = {
},
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "any",
["customTriggerLogic"] = "function()\n    return true\nend",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_class"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["single"] = "HUNTER",
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["keepAspectRatio"] = false,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["conditions"] = {
},
["selfPoint"] = "CENTER",
["actions"] = {
["start"] = {
["do_glow"] = false,
["do_sound"] = false,
["glow_action"] = "show",
["glow_frame_type"] = "FRAMESELECTOR",
["glow_type"] = "buttonOverlay",
["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AcousticGuitar.ogg",
["glow_frame"] = "WeakAuras:PetButton",
},
["finish"] = {
["glow_frame_type"] = "FRAMESELECTOR",
["hide_all_glows"] = false,
["glow_action"] = "hide",
["glow_frame"] = "WeakAuras:PetButton",
["do_glow"] = false,
},
["init"] = {
["do_custom"] = true,
["custom"] = "-- Only run creation if the button doesn't exist yet\nif not aura_env.btn then\n    -- 1. Create the Secure Button\n    local btn = CreateFrame(\"Button\", \"PetAnchorBtn\", aura_env.region, \"SecureActionButtonTemplate\")\n    btn:SetAllPoints()\n    btn:RegisterForClicks(\"AnyUp\")\n    aura_env.btn = btn\n\n    -- 2. Create the INVISIBLE \"Dummy\" window brain\n    if not _G.MyWAPetMenuEscapeFrame then\n        local escFrame = CreateFrame(\"Frame\", \"MyWAPetMenuEscapeFrame\", UIParent)\n        escFrame:Hide()\n        tinsert(_G.UISpecialFrames, \"MyWAPetMenuEscapeFrame\")\n        \n        escFrame:SetScript(\"OnShow\", function()\n                if MyWAHunterMenuEscapeFrame then MyWAHunterMenuEscapeFrame:Hide() end\n                if MyWAProfMenuEscapeFrame then MyWAProfMenuEscapeFrame:Hide() end\n                \n                _G.WA_PET_OPEN = true\n                _G.WeakAuras.ScanEvents(\"TOGGLE_PET_MENU\", true)\n        end)\n        \n        escFrame:SetScript(\"OnHide\", function()\n                _G.WA_PET_OPEN = false\n                _G.WeakAuras.ScanEvents(\"TOGGLE_PET_MENU\", false)\n        end)\n        \n        escFrame:RegisterEvent(\"PLAYER_REGEN_DISABLED\")\n        escFrame:SetScript(\"OnEvent\", function(self) self:Hide() end)\n    end\nend\n\n-- 3. Set Attributes ONLY if not in combat\nif not InCombatLockdown() then\n    aura_env.btn:SetAttribute(\"type\", \"macro\")\n    aura_env.btn:SetAttribute(\"macrotext\", [[\n/run if MyWAPetMenuEscapeFrame:IsShown() then MyWAPetMenuEscapeFrame:Hide() else MyWAPetMenuEscapeFrame:Show() end\n]])\nelse\n    -- Optional: Register an event to retry setting attributes once combat ends\n    aura_env.region:RegisterEvent(\"PLAYER_REGEN_ENABLED\")\nend\n\n-- 4. Sync initial state\n_G.WA_PET_OPEN = _G.WA_PET_OPEN or false",
},
},
["information"] = {
},
["zoom"] = 0,
["uid"] = "aJlCVByIc4e",
["cooldownTextDisabled"] = false,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["id"] = "PetButton",
["alpha"] = 1,
["useCooldownModRate"] = true,
["width"] = 30,
["authorOptions"] = {
},
["config"] = {
},
["inverse"] = false,
["xOffset"] = 0,
["displayIcon"] = 132311,
["cooldown"] = true,
["color"] = {
1,
1,
1,
1,
},
},
["KwaKillCounter"] = {
["backdropColor"] = {
1,
1,
1,
0.5,
},
["controlledChildren"] = {
"Display",
},
["borderBackdrop"] = "Blizzard Tooltip",
["authorOptions"] = {
},
["borderEdge"] = "Square Full White",
["border"] = false,
["yOffset"] = 359.9508666992188,
["anchorPoint"] = "CENTER",
["borderSize"] = 2,
["scale"] = 1,
["borderColor"] = {
0,
0,
0,
1,
},
["borderInset"] = 1,
["groupIcon"] = 236489,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["subeventPrefix"] = "SPELL",
["event"] = "Health",
["names"] = {
},
},
["untrigger"] = {
},
},
},
["regionType"] = "group",
["borderOffset"] = 4,
["xOffset"] = 232.2937622070313,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["id"] = "KwaKillCounter",
["internalVersion"] = 89,
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["uid"] = "GHDyFhoYg(5",
["alpha"] = 1,
["subRegions"] = {
},
["config"] = {
},
["conditions"] = {
},
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["information"] = {
},
},
["Health4"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["parent"] = "Party4",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -4,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 180,
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["icon"] = false,
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["use_raid_role"] = false,
["event"] = "Health",
["use_maxhealth"] = false,
["subeventPrefix"] = "SPELL",
["use_unit"] = true,
["unit"] = "party4",
["spellIds"] = {
},
["names"] = {
},
["use_ignoreDisconnected"] = false,
["use_percenthealth"] = false,
["use_specific_unit"] = true,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = 1,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["barColor"] = {
1,
0.207843154668808,
0,
1,
},
["desaturate"] = false,
["frameStrata"] = 3,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["text_text_format_n_format"] = "none",
["text_text"] = "%1.health",
["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_shadowXOffset"] = 1,
["type"] = "subtext",
["text_anchorYOffset"] = 10,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_text_format_1.health_pad_mode"] = "left",
["text_shadowYOffset"] = -1,
["text_fontType"] = "None",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_text_format_1.health_format"] = "BigNumber",
["text_text_format_1.health_pad"] = false,
["anchor_point"] = "SPARK",
["text_fontSize"] = 10,
["anchorXOffset"] = 0,
["text_text_format_1.health_pad_max"] = 8,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%n %1.raidMark",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_anchorYOffset"] = 14,
["text_text_format_1.raidMark_format"] = "none",
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_fontType"] = "None",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_LEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_shadowYOffset"] = -1,
},
{
["text_shadowXOffset"] = 1,
["text_text"] = "%2.level",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["text_text_format_2.level_format"] = "none",
["type"] = "subtext",
["text_anchorXOffset"] = -21,
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = -1,
["text_anchorYOffset"] = -13,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["text_text_format_1.level_format"] = "none",
["text_text_format_n_format"] = "none",
["anchor_point"] = "INNER_BOTTOMLEFT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "None",
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"5",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["iconSource"] = -1,
["information"] = {
},
["sparkRotationMode"] = "MANUAL",
["internalVersion"] = 89,
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["sparkColor"] = {
1,
1,
1,
1,
},
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["uid"] = "lZYC7WXJ8CU",
["height"] = 4,
["icon_side"] = "RIGHT",
["anchorFrameType"] = "SCREEN",
["sparkHeight"] = 10,
["texture"] = "Clean",
["xOffset"] = 20,
["sparkTexture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\targeting-mark.tga",
["spark"] = true,
["sparkHidden"] = "NEVER",
["id"] = "Health4",
["zoom"] = 0,
["alpha"] = 1,
["width"] = 180,
["selfPoint"] = "CENTER",
["config"] = {
},
["inverse"] = false,
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["value"] = "function()\n    return not UnitIsConnected(\"party4\")\nend",
["variable"] = "customcheck",
["trigger"] = -1,
},
["changes"] = {
{
["value"] = {
0.4549019932746887,
0.4549019932746887,
0.4549019932746887,
1,
},
["property"] = "barColor",
},
},
},
},
["barColor2"] = {
1,
1,
0,
1,
},
["authorOptions"] = {
},
},
["TargetBarClickbox"] = {
["xOffset"] = -0.000332919022064533,
["yOffset"] = 10.05626295348864,
["anchorPoint"] = "CENTER",
["url"] = "Meow",
["actions"] = {
["start"] = {
["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BikeHorn.ogg",
["do_sound"] = false,
},
["init"] = {
["do_custom"] = true,
["custom"] = "if _G[\"MyWATargetProxy\"] then return end\n\nif InCombatLockdown() then\n    local f = CreateFrame(\"Frame\")\n    f:RegisterEvent(\"PLAYER_REGEN_ENABLED\")\n    f:SetScript(\"OnEvent\", function(self)\n        if aura_env.region.OnInitialize then\n            aura_env.region:OnInitialize()\n        end\n        self:UnregisterAllEvents()\n    end)\n    return \nend\n\nlocal region = aura_env.region\nlocal btn = CreateFrame(\"Button\", \"MyWATargetProxy\", region, \"SecureUnitButtonTemplate\")\n\nbtn:SetAllPoints(region)\nbtn:SetAttribute(\"unit\", \"target\")\nbtn:SetAttribute(\"*type1\", \"target\")\nbtn:SetAttribute(\"*type2\", \"togglemenu\")\nRegisterUnitWatch(btn) \n\nbtn:SetFrameStrata(\"LOW\")\nbtn:SetFrameLevel(region:GetFrameLevel() + 20)\nbtn:RegisterForClicks(\"AnyUp\")\n\nlocal bg = btn:CreateTexture(nil, \"BACKGROUND\")\nbg:SetAllPoints(btn)\nbg:SetColorTexture(0, 0, 0, 0)\n\nTargetFrame:UnregisterAllEvents()\nTargetFrame:Hide()",
},
["finish"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["spellIds"] = {
},
["use_unit"] = true,
["names"] = {
},
["unit"] = "player",
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["rotation"] = 0,
["ignoreWagoUpdate"] = true,
["subRegions"] = {
{
["type"] = "subbackground",
},
},
["height"] = 168.3950042724609,
["rotate"] = false,
["load"] = {
["use_never"] = false,
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["textureWrapMode"] = "CLAMPTOBLACKADDITIVE",
["mirror"] = false,
["regionType"] = "texture",
["blendMode"] = "BLEND",
["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura3",
["alpha"] = 0,
["authorOptions"] = {
},
["id"] = "TargetBarClickbox",
["color"] = {
1,
1,
1,
1,
},
["frameStrata"] = 1,
["anchorFrameType"] = "SCREEN",
["width"] = 610,
["uid"] = "8CwTejYkjpS",
["config"] = {
},
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
["conditions"] = {
},
["information"] = {
},
["parent"] = "BDO Target Bar",
},
["Power1"] = {
["sparkWidth"] = 10,
["sparkOffsetX"] = 0,
["parent"] = "Party1",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -12,
["anchorPoint"] = "CENTER",
["sparkRotation"] = 0,
["sparkRotationMode"] = "AUTO",
["backgroundColor"] = {
0,
0,
0,
0.5,
},
["triggers"] = {
{
["trigger"] = {
["type"] = "unit",
["use_health"] = false,
["subeventSuffix"] = "_CAST_START",
["subeventPrefix"] = "SPELL",
["use_power"] = false,
["event"] = "Power",
["use_specific_unit"] = true,
["names"] = {
},
["use_maxhealth"] = false,
["spellIds"] = {
},
["use_unit"] = true,
["unit"] = "party1",
["use_percenthealth"] = false,
["use_powertype"] = false,
["debuffType"] = "HELPFUL",
},
["untrigger"] = {
},
},
["activeTriggerMode"] = -10,
},
["icon_color"] = {
1,
1,
1,
1,
},
["enableGradient"] = false,
["progressSource"] = {
-1,
"",
},
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["barColor"] = {
0.207843154668808,
0.658823549747467,
1,
1,
},
["desaturate"] = false,
["alpha"] = 1,
["sparkOffsetY"] = 0,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["type"] = "subforeground",
},
{
["border_offset"] = 0,
["type"] = "subborder",
["anchor_area"] = "bar",
["border_color"] = {
1,
1,
1,
1,
},
["border_visible"] = false,
["border_edge"] = "Square Full White",
["border_size"] = 2,
},
},
["gradientOrientation"] = "HORIZONTAL",
["textureSource"] = "Picker",
["load"] = {
["ingroup"] = {
["single"] = "group",
},
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["groupSize"] = {
"2",
},
["use_ingroup"] = true,
["use_groupSize"] = true,
["spec"] = {
["multi"] = {
},
},
["groupSize_operator"] = {
">=",
},
["size"] = {
["multi"] = {
},
},
},
["sparkBlendMode"] = "ADD",
["useAdjustededMax"] = false,
["iconSource"] = -1,
["information"] = {
},
["authorOptions"] = {
},
["textureInput"] = "Interface\\AddOns\\Plater\\images\\regular_white",
["icon"] = false,
["uid"] = "aMifQVFApfL",
["useAdjustededMin"] = false,
["regionType"] = "aurabar",
["sparkColor"] = {
1,
1,
1,
1,
},
["height"] = 4,
["icon_side"] = "RIGHT",
["width"] = 180,
["sparkHeight"] = 30,
["texture"] = "Clean",
["xOffset"] = 20,
["zoom"] = 0,
["spark"] = false,
["sparkHidden"] = "NEVER",
["id"] = "Power1",
["sparkTexture"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
["frameStrata"] = 3,
["anchorFrameType"] = "SCREEN",
["selfPoint"] = "CENTER",
["config"] = {
},
["inverse"] = false,
["internalVersion"] = 89,
["orientation"] = "HORIZONTAL",
["conditions"] = {
{
["check"] = {
["trigger"] = -1,
["variable"] = "customcheck",
["value"] = "function()\n    return not UnitIsConnected(\"party1\")\nend",
},
["changes"] = {
{
["value"] = {
0.4117647409439087,
0.4117647409439087,
0.4117647409439087,
1,
},
["property"] = "barColor",
},
},
},
{
["check"] = {
["trigger"] = 1,
["variable"] = "powertype",
["value"] = 1,
["op"] = "==",
},
["changes"] = {
{
["value"] = {
1,
0.5058823823928833,
0.07450980693101883,
1,
},
["property"] = "barColor",
},
},
},
},
["barColor2"] = {
1,
1,
0,
1,
},
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
},
["Track Undead"] = {
["texXOffset"] = 0,
["parent"] = "HunterGroup",
["adjustedMax"] = "",
["adjustedMin"] = "",
["yOffset"] = -1,
["anchorPoint"] = "CENTER",
["cooldownSwipe"] = false,
["cooldownEdge"] = false,
["actions"] = {
["start"] = {
["sound_path"] = "567461",
["do_sound"] = false,
["sound_kit_id"] = "567482",
["sound"] = " custom",
["do_custom"] = false,
["sound_channel"] = "Master",
},
["finish"] = {
["sound_channel"] = "Master",
["sound_path"] = "567482",
["sound"] = " custom",
["do_sound"] = false,
},
["init"] = {
["do_custom_unload"] = false,
["do_custom"] = true,
["custom"] = "-- Create the button parented to this specific icon\nlocal btn = CreateFrame(\"Button\", \"WA_ClickBtn_\" .. aura_env.id:gsub(\"%s+\", \"_\"), aura_env.region, \"SecureActionButtonTemplate\")\n\n-- This is the magic line: it stretches the button to match the icon's exact size/shape\nbtn:SetAllPoints(aura_env.region)\n\n-- Set the action: Equips the pole and then casts Fishing\nbtn:SetAttribute(\"type\", \"macro\")\nbtn:SetAttribute(\"macrotext\", \"/cast Track Undead\")\n\n-- Ensure it registers the click\nbtn:RegisterForClicks(\"AnyUp\")\n\n-- 2. Tooltip Logic\nbtn:SetScript(\"OnEnter\", function(self)\n        GameTooltip:SetOwner(self, \"ANCHOR_RIGHT\")\n        -- You can use the Spell ID or the Name\n        GameTooltip:SetSpellByID(19884) -- 2108 is the ID for Leatherworking\n        GameTooltip:Show()\nend)\n\nbtn:SetScript(\"OnLeave\", function()\n        GameTooltip:Hide()\nend)",
},
},
["triggers"] = {
{
["trigger"] = {
["type"] = "custom",
["subeventSuffix"] = "_CAST_START",
["event"] = "Health",
["subeventPrefix"] = "SPELL",
["debuffType"] = "HELPFUL",
["unit"] = "player",
["custom"] = "function(event, show)\n    return show\nend",
["names"] = {
},
["custom_type"] = "event",
["events"] = "TOGGLE_HUNTER_MENU",
["spellIds"] = {
},
["custom_hide"] = "custom",
},
["untrigger"] = {
["custom"] = "function(event, show)\n    return not show\nend",
},
},
{
["trigger"] = {
["type"] = "spell",
["use_genericShowOn"] = true,
["event"] = "Spell Known",
["unit"] = "player",
["use_spellName"] = true,
["debuffType"] = "HELPFUL",
["genericShowOn"] = "showOnCooldown",
["use_track"] = true,
["spellName"] = 19884,
},
["untrigger"] = {
},
},
["disjunctive"] = "all",
["activeTriggerMode"] = -10,
},
["internalVersion"] = 89,
["keepAspectRatio"] = false,
["selfPoint"] = "CENTER",
["desaturate"] = false,
["subRegions"] = {
{
["type"] = "subbackground",
},
{
["text_shadowXOffset"] = 0,
["text_text_format_s_format"] = "none",
["text_text"] = "%s",
["text_shadowColor"] = {
0,
0,
0,
1,
},
["text_selfPoint"] = "AUTO",
["text_automaticWidth"] = "Auto",
["text_fixedWidth"] = 64,
["anchorYOffset"] = 0,
["text_justify"] = "CENTER",
["rotateText"] = "NONE",
["type"] = "subtext",
["text_color"] = {
1,
1,
1,
1,
},
["text_font"] = "Friz Quadrata TT",
["text_shadowYOffset"] = 0,
["text_wordWrap"] = "WordWrap",
["text_visible"] = true,
["anchor_point"] = "INNER_BOTTOMRIGHT",
["text_fontSize"] = 12,
["anchorXOffset"] = 0,
["text_fontType"] = "OUTLINE",
},
{
["glowFrequency"] = 0.25,
["type"] = "subglow",
["glowDuration"] = 1,
["glowType"] = "buttonOverlay",
["glowLength"] = 10,
["glowYOffset"] = 0,
["glowColor"] = {
1,
1,
1,
1,
},
["useGlowColor"] = false,
["glowXOffset"] = 0,
["glowThickness"] = 1,
["glowScale"] = 1,
["glow"] = false,
["glowLines"] = 8,
["glowBorder"] = false,
},
},
["height"] = 30,
["load"] = {
["use_alive"] = true,
["use_never"] = false,
["talent"] = {
["multi"] = {
},
},
["use_combat"] = false,
["spec"] = {
["multi"] = {
},
},
["class"] = {
["multi"] = {
},
},
["size"] = {
["multi"] = {
},
},
},
["useAdjustededMax"] = false,
["icon"] = true,
["xOffset"] = 0,
["useAdjustededMin"] = false,
["regionType"] = "icon",
["animation"] = {
["start"] = {
["colorR"] = 1,
["duration_type"] = "seconds",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["scaley"] = 1,
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["preset"] = "spiral",
["easeStrength"] = 3,
["colorA"] = 1,
["rotate"] = 0,
["translateType"] = "straightTranslate",
["duration"] = ".1",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["colorR"] = 1,
["duration"] = ".1",
["alphaType"] = "straight",
["colorB"] = 1,
["colorG"] = 1,
["alphaFunc"] = "function(progress, start, delta)\n    return start + (progress * delta)\nend\n",
["use_translate"] = true,
["use_alpha"] = true,
["type"] = "custom",
["easeType"] = "easeOutIn",
["translateFunc"] = "function(progress, startX, startY, deltaX, deltaY)\n    return startX + (progress * deltaX), startY + (progress * deltaY)\nend\n",
["preset"] = "spiral",
["alpha"] = 0,
["scalex"] = 1,
["y"] = -10,
["x"] = 0,
["scaley"] = 1,
["rotate"] = 0,
["duration_type"] = "seconds",
["easeStrength"] = 3,
["colorA"] = 1,
["translateType"] = "straightTranslate",
},
},
["progressSource"] = {
-1,
"",
},
["information"] = {
},
["conditions"] = {
},
["uid"] = "imelWOeUyBH",
["color"] = {
1,
1,
1,
1,
},
["cooldownTextDisabled"] = false,
["anchorFrameType"] = "SCREEN",
["frameStrata"] = 1,
["id"] = "Track Undead",
["zoom"] = 0,
["alpha"] = 1,
["width"] = 30,
["useCooldownModRate"] = true,
["config"] = {
},
["inverse"] = false,
["authorOptions"] = {
},
["displayIcon"] = 136142,
["cooldown"] = false,
["iconSource"] = -1,
},
["Display"] = {
["outline"] = "None",
["parent"] = "KwaKillCounter",
["displayText"] = "%c",
["customText"] = "function()\n    -- [[ CONFIGURATION ]]\n    -- Set these to true or false to show/hide specific lines in the WeakAura\n    local SHOW_KILLS = true\n    local SHOW_AVG_VENDOR = true\n    local SHOW_AVG_AH = true\n    local SHOW_KILLS_TO_LEVEL = true\n    \n    if WeakAuras.IsOptionsOpen() then \n        return \"Kills: 666\\nAvg Vendor: 1s 20c\\nAvg AH: 2s 50c\\nTo Level: 42\" \n    end\n    \n    local guid = UnitGUID(\"target\")\n    if not guid then return \"\" end\n    \n    local unitType, _, _, _, _, npcID = strsplit(\"-\", guid)\n    if not (unitType == \"Creature\" or unitType == \"Vehicle\") or not npcID then return \"\" end\n    \n    local data = MyKillCountTable and MyKillCountTable[npcID]\n    if not data then return \"\" end\n    \n    local lines = {}\n    \n    -- 1. Kills Count\n    if SHOW_KILLS then\n        local count = data.count or 0\n        table.insert(lines, string.format(\"Kills: %d\", count))\n    end\n    \n    -- 2. Average Vendor Value\n    if SHOW_AVG_VENDOR and data.avgLootValue and data.avgLootValue > 0 then\n        table.insert(lines, \"Avg Vendor: \" .. GetCoinTextureString(math.floor(data.avgLootValue)))\n    end\n    \n    -- 3. Average Auction Value\n    if SHOW_AVG_AH and GetDynamicAuctionValue then\n        local val = GetDynamicAuctionValue(npcID)\n        if val and val > 0 then\n            table.insert(lines, \"Avg AH: \" .. GetCoinTextureString(math.floor(val)))\n        end\n    end\n    \n    -- 4. Kills to Level\n    if SHOW_KILLS_TO_LEVEL and data.xp and data.xp > 0 then\n        local currentXP = UnitXP(\"player\")\n        local maxXP = UnitXPMax(\"player\")\n        local xpNeeded = maxXP - currentXP\n        if xpNeeded > 0 then\n            local killsToLevel = math.ceil(xpNeeded / data.xp)\n            table.insert(lines, \"To Level: \" .. killsToLevel)\n        end\n    end\n    \n    return table.concat(lines, \"\\n\")\nend",
["yOffset"] = 0,
["anchorPoint"] = "CENTER",
["displayText_format_p_time_format"] = 0,
["customTextUpdate"] = "event",
["automaticWidth"] = "Auto",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
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
["internalVersion"] = 89,
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
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
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["fontSize"] = 11,
["shadowXOffset"] = 1,
["selfPoint"] = "BOTTOM",
["regionType"] = "text",
["displayText_format_c1_format"] = "none",
["displayText_format_p_time_legacy_floor"] = false,
["conditions"] = {
},
["shadowYOffset"] = -1,
["displayText_format_p_time_precision"] = 1,
["xOffset"] = 0,
["config"] = {
},
["displayText_format_p_time_mod_rate"] = true,
["justify"] = "LEFT",
["anchorFrameType"] = "SCREEN",
["id"] = "Display",
["wordWrap"] = "WordWrap",
["frameStrata"] = 1,
["displayText_format_c3_format"] = "none",
["displayText_format_p_time_dynamic_threshold"] = 60,
["uid"] = "0WKqWyl9JfD",
["authorOptions"] = {
},
["color"] = {
1,
1,
1,
1,
},
["shadowColor"] = {
0,
0,
0,
1,
},
["fixedWidth"] = 200,
["information"] = {
},
["displayText_format_c_format"] = "none",
},
["TargetDebuffs"] = {
["grow"] = "RIGHT",
["controlledChildren"] = {
"Icons",
},
["borderBackdrop"] = "Blizzard Tooltip",
["xOffset"] = -307.4305197892576,
["yOffset"] = -58.84332653813911,
["anchorPoint"] = "CENTER",
["borderColor"] = {
0.529411792755127,
0,
0.007843137718737125,
1,
},
["space"] = 2,
["url"] = "Meow",
["actions"] = {
["start"] = {
},
["finish"] = {
},
["init"] = {
},
},
["triggers"] = {
{
["trigger"] = {
["debuffType"] = "HELPFUL",
["type"] = "aura2",
["spellIds"] = {
},
["subeventSuffix"] = "_CAST_START",
["unit"] = "player",
["names"] = {
},
["event"] = "Health",
["subeventPrefix"] = "SPELL",
},
["untrigger"] = {
},
},
},
["columnSpace"] = 1,
["radius"] = 200,
["selfPoint"] = "LEFT",
["align"] = "CENTER",
["stagger"] = 0,
["ignoreWagoUpdate"] = true,
["regionType"] = "dynamicgroup",
["subRegions"] = {
},
["uid"] = "TSlFPyLQ(A4",
["rotation"] = 0,
["load"] = {
["talent"] = {
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
["size"] = {
["multi"] = {
},
},
},
["internalVersion"] = 89,
["backdropColor"] = {
1,
1,
1,
0.5,
},
["useLimit"] = false,
["animate"] = false,
["parent"] = "BDO Target Bar",
["scale"] = 1,
["centerType"] = "LR",
["border"] = false,
["borderEdge"] = "Square Full White",
["stepAngle"] = 15,
["borderSize"] = 2,
["sort"] = "none",
["config"] = {
},
["authorOptions"] = {
},
["constantFactor"] = "RADIUS",
["arcLength"] = 360,
["borderOffset"] = 4,
["alpha"] = 1,
["frameStrata"] = 1,
["id"] = "TargetDebuffs",
["rowSpace"] = 1,
["gridWidth"] = 5,
["anchorFrameType"] = "SCREEN",
["animation"] = {
["start"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["main"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
["finish"] = {
["easeStrength"] = 3,
["type"] = "none",
["duration_type"] = "seconds",
["easeType"] = "none",
},
},
["borderInset"] = 1,
["limit"] = 5,
["fullCircle"] = true,
["conditions"] = {
},
["information"] = {
},
["gridType"] = "RD",
},
},
["features"] = {
},
["RealTimeProfilingWindow"] = {
["xOffset"] = 243.037109375,
["yOffset"] = -365.9507751464844,
},
}
