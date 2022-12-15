local old_streaming_on_irc = _streaming_on_irc
-- monkey patch message recieved callback
function _streaming_on_irc( is_userstate, sender_username, message, raw )
	-- check if user has permissions to run Lua
	if (sender_username:lower() == ModSettingGet("Copis_Twitchy_Lua.poweruser"):lower() or "") or ModSettingGet("Copis_Twitchy_Lua.pandemonium") then
		-- Check if message is a Lua script
		if message:match("LUA: ") then
			-- Feed data to init.lua
			message = message:gsub("LUA: ", "")
			GlobalsSetValue( "funny_this_frame", "1")
			GlobalsSetValue( "funny_lua", message)
			GlobalsSetValue( "funny_user", sender_username)
		end
	end
	-- run original code
	if(old_streaming_on_irc ~= nil)then
		old_streaming_on_irc( is_userstate, sender_username, message, raw )
	end
end