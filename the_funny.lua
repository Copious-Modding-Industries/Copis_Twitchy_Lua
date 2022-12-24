-- Use local functions/variables so they can't be changed by the chatter

local install_hooks = nil

-- monkey patch message recieved callback
local old_streaming_on_irc = _streaming_on_irc

function streaming_on_irc_hook( is_userstate, sender_username, message, raw )
	-- check if user has permissions to run Lua
	if (sender_username:lower() == ModSettingGet("Copis_Twitchy_Lua.poweruser"):lower() or "") or ModSettingGet("Copis_Twitchy_Lua.pandemonium") then
		-- Check if message is a Lua script
		if message:match("LUA: ") then

			message = message:gsub("LUA: ", "")
			local path = "mods/Copis_Twitchy_Lua-main/virtual_files/funny.lua"
			-- Attempt to execute code
			ModTextFileSetContent(path, message)
			local func = loadfile(path)
			if func ~= nil then
				pcall(func)
				-- Immediately reinstall hooks to make sure chatter can't override something important
				install_hooks()
				print(("[CopiTLua]: Executed script %s, by user %s"):format(path, sender_username))

			else
				GamePrintImportant(sender_username .. "'s script errored!", path, "data/ui_gfx/decorations_biome_modifier/conductive.png")
				print(("[CopiTLua]: Errored script %s, by user %s"):format(path, sender_username))

			end
		end
	end

	-- run original code
	if (old_streaming_on_irc ~= nil) then
		old_streaming_on_irc(is_userstate, sender_username, message, raw)
	end
end

-- Prevent player kills
local original_EntityKill = EntityKill
local function guarded_EntityKill(entity_id)
	-- Can't circumvent checks by using a string for the entity id
	entity_id = tonumber(entity_id)

	local player_entities = EntityGetWithTag("player_unit")
	for _, player_entity in ipairs(player_entities) do
		if entity_id == player_entity then
			print("[CopiTLua]: Prevented player from getting killed")
			return
		end
	end

	return original_EntityKill(entity_id)
end

-- Prevent mod setting tampering
local original_ModSettingSet = ModSettingSet
local function guarded_ModSettingSet(id, value)
	if ModSettingGet("Copis_Twitchy_Lua.chaos") then
		return original_ModSettingSet(id, value)
	else
		print("[CopiTLua]: Prevented ModSettingSet from being called")
		return
	end
end

local original_ModSettingSetNextValue = ModSettingSetNextValue
local function guarded_ModSettingSetNextValue(id, value, is_default)
	if ModSettingGet("Copis_Twitchy_Lua.chaos") then
		return original_ModSettingSetNextValue(id, value, is_default)
	else
		print("[CopiTLua]: Prevented ModSettingSetNextValue from being called")
		return
	end
end

-- Prevent persistent flag tampering
local original_AddFlagPersistent = AddFlagPersistent
local function guarded_AddFlagPersistent(key)
	if ModSettingGet("Copis_Twitchy_Lua.chaos") then
		return original_AddFlagPersistent(key)
	else
		print("[CopiTLua]: Prevented AddFlagPersistent from being called")
		return
	end
end

local original_RemoveFlagPersistent = RemoveFlagPersistent
local function guarded_RemoveFlagPersistent(key)
	if ModSettingGet("Copis_Twitchy_Lua.chaos") then
		return original_RemoveFlagPersistent(key)
	else
		print("[CopiTLua]: Prevented RemoveFlagPersistent from being called")
		return
	end
end

install_hooks = function()
	_streaming_on_irc = streaming_on_irc_hook
	EntityKill = guarded_EntityKill
	ModSettingSet = guarded_ModSettingSet
	ModSettingSetNextValue = guarded_ModSettingSetNextValue
	AddFlagPersistent = guarded_AddFlagPersistent
	RemoveFlagPersistent = guarded_RemoveFlagPersistent
end

-- Initial install
install_hooks()