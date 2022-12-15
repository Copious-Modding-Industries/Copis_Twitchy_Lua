-- Counter for times run
Twitchy_Lua_Count = 0
-- monkey patch message recieved callback
local old_streaming_on_irc = _streaming_on_irc
function _streaming_on_irc( is_userstate, sender_username, message, raw )
	-- check if user has permissions to run Lua
	if (sender_username:lower() == ModSettingGet("Copis_Twitchy_Lua.poweruser"):lower() or "") or ModSettingGet("Copis_Twitchy_Lua.pandemonium") then
		-- Check if message is a Lua script
		if message:match("LUA: ") then
			message = message:gsub("LUA: ", "")
			local path = ("mods/Copis_Twitchy_Lua-main/virtual_files/funny_%s_.lua"):format(Twitchy_Lua_Count)
			-- Attempt to execute code
			local s1 = pcall(ModTextFileSetContent, path, tostring(message))
			local s2 = pcall(dofile, path)
			-- Check if succeeded
			if s1 and s2 then
				print(("[CopiTLua]: Executed script %s, by user %s"):format(path, sender_username))
			else
				GamePrintImportant(sender_username .. "'s script errored!", ("Write success: %s, dofile success: %s"):format(tostring(s1), tostring(s2)), "data/ui_gfx/decorations_biome_modifier/conductive.png")
				print(("[CopiTLua]: Errored script %s, by user %s"):format(path, sender_username))
			end
			Twitchy_Lua_Count = Twitchy_Lua_Count + 1
		end
	end
	-- run original code
	if(old_streaming_on_irc ~= nil)then
		old_streaming_on_irc( is_userstate, sender_username, message, raw )
	end
end