-- Inject the_funny.lua
ModLuaFileAppend("data/scripts/streaming_integration/event_utilities.lua", "mods/Copis_Twitchy_Lua/the_funny.lua")

-- Save ModTextFile functions past initialization
Write = ModTextFileSetContent
Read = ModTextFileGetContent

-- Run every frame
function OnWorldPreUpdate()
	-- Check if connected to twitch
	if StreamingGetIsConnected() then
		if Write ~= nil then
			-- Only run when a new script is available
			if GlobalsGetValue("funny_this_frame", "0") == "1" then
				-- Get data from twitch lua context
				local funny = GlobalsGetValue("funny_lua", "")
				local user = GlobalsGetValue("funny_user", "")
				local times = GlobalsGetValue("funny_virtual_times", "0")
				local path = ("mods/Copis_Twitchy_Lua/virtual_files/funny_%s_.lua"):format(times)
				-- Attempt to execute code
				local s1 = pcall(Write, path, tostring(funny))
				local s2 = pcall(dofile, path)
				-- Check if succeeded
				if not (s1 and s2) then
					print(("[CopiTLua]: Executed script %s, by user %s"):format(path, user))
				else
					GamePrintImportant(user .. "'s script errored!", ("Write success: %s, dofile success: %s"):format(tostring(s1), tostring(s2)), "data/ui_gfx/decorations/conductive.png")
					print(("[CopiTLua]: Errored script %s, by user %s"):format(path, user))
				end
				-- End execution
				GlobalsSetValue("funny_this_frame", "0")
				GlobalsSetValue("funny_virtual_times", tostring(tonumber(times) + 1))
			end
		end
	else
		-- Warn user if twitch is disconnected
		Gui = Gui or GuiCreate()
		GuiStartFrame(Gui)
		local msg = "Twitch Disconnected!"
		local sw, sh = GuiGetScreenDimensions(Gui)
		local tw, th = GuiGetTextDimensions(Gui, msg)
		local gx, gy = (sw - tw) / 2, (sh - th) / 2
		GuiOptionsAddForNextWidget(Gui, 25)
		GuiColorSetForNextWidget(Gui, 0.8, 0.6, 0, 1)
		GuiText(Gui, gx, gy, msg)
	end
end
-- TODO: filter mod setting and persistent flag setting code, look for any vulnerabilities in code,