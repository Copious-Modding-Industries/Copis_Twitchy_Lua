
local old_streaming_on_irc = _streaming_on_irc
function _streaming_on_irc( is_userstate, sender_username, message, raw )
	if (sender_username:lower() == ModSettingGet("Copis_Twitchy_Lua.poweruser"):lower() or "") or ModSettingGet("Copis_Twitchy_Lua.pandemonium") then
		if message:match("LUA: ") then
			message = message:gsub("LUA: ", "")
			GlobalsSetValue( "funny_this_frame", "1")
			GlobalsSetValue( "funny_lua", message)
			GlobalsSetValue( "funny_user", sender_username)
		end
	end
	if(old_streaming_on_irc ~= nil)then
		old_streaming_on_irc( is_userstate, sender_username, message, raw )
	end
end
--[[
local old_streaming_on_irc = _streaming_on_irc
function _streaming_on_irc( is_userstate, sender_username, message, raw )
	if (sender_username:lower() == ModSettingGet("Copis_Twitchy_Lua.poweruser"):lower() or "") or ModSettingGet("Copis_Twitchy_Lua.pandemonium") then
		if message:match("LUA: ") then
			dofile("mods/Copis_Twitchy_Lua/init.lua")
			message = message:gsub("LUA: ", "")
			local times = GlobalsGetValue("funny_virtual_times", "0")
			local path = ("mods/Copis_Twitchy_Lua/virtual_files/funny_%s_.lua"):format(times)
			Write( path, message )
			print("[CopiTLua]: Executed script " .. path)
			GlobalsSetValue("funny_virtual_times", tostring(tonumber(times) + 1))
		end
	end
	if(old_streaming_on_irc ~= nil)then
		old_streaming_on_irc( is_userstate, sender_username, message, raw )
	end
end
]]