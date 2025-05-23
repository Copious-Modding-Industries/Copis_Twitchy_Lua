-- Use local functions/variables so they can't be changed by the chatter

local install_hooks = nil

-- monkey patch message recieved callback
local old_streaming_on_irc = _streaming_on_irc

function streaming_on_irc_hook( is_userstate, sender_username, message, raw )
	-- check if user has permissions to run Lua
	local valid = false
	---@diagnostic disable-next-line: param-type-mismatch
	for i in string.gmatch(ModSettingGet("Copis_Twitchy_Lua.poweruser"):lower(), "%S+") do
		if sender_username:lower() == i or "" then
			valid = true
			break
		end
	end
	-- if so, do stuff
	if (valid) or ModSettingGet("Copis_Twitchy_Lua.pandemonium") then
		-- Check if message is a Lua script
		if message:match("LUA: ") then
			message = message:gsub("LUA: ", "")
			local path = "mods/Copis_Twitchy_Lua-main/virtual_files/funny.lua"
			-- Attempt to execute code
			ModTextFileSetContent(path, message)
			local func = loadfile(path)
			if func ~= nil then
				-- Setup to save chars
				local Player = EntityGetWithTag("player_unit")[1]
				local Px, Py, Pr, Psx, Psy = EntityGetTransform(Player)
				local Mx, My = DEBUG_GetMouseWorld()
				local Cx, Cy = GameGetCameraPos()
				local Comp = EntityGetFirstComponentIncludingDisabled
				local function ploop(fn)
					local ps = EntityGetWithTag("player_unit")
					for i=1, #ps do
						fn(ps[i])
					end
				end

				pcall(func)
				-- Immediately reinstall hooks to make sure chatter can't override something important
				install_hooks()
				print(("[CopiTLua]: Executed script %s, by user %s"):format(path, sender_username))
			else
				GamePrintImportant(sender_username .. "'s script errored!", path, "data/ui_gfx/decorations_biome_modifier/conductive.png")
				print(("[CopiTLua]: Errored script %s, by user %s"):format(path, sender_username))
			end
		elseif message:match("GPI: ") then
			message = message:gsub("GPI: ", "")
			GamePrintImportant(message, sender_username, "mods/Copis_Twitchy_Lua/3piece_meta.png")
		end
	end

	-- run original code
	if (old_streaming_on_irc ~= nil) then
		old_streaming_on_irc(is_userstate, sender_username, message, raw)
	end
end

-- Protect mod setting get function
local ModSettingGet = ModSettingGet

-- Prevent player kills
local original_EntityKill = EntityKill
local function guarded_EntityKill(entity_id)
	-- Can't circumvent checks by using a string for the entity id
	entity_id = tonumber(entity_id)

	local player_entities = EntityGetWithTag("player_unit")
	for i = 1, #player_entities  do
		if entity_id == player_entities[i] then
			print("[CopiTLua]: Prevented player from getting killed")
			return
		end
	end

	return original_EntityKill(entity_id)
end

local function MakeAllOrNothingGuard(func_name)
	local original = _G[func_name]
	local function guarded(...)
		if ModSettingGet("Copis_Twitchy_Lua.chaos") then
			return original(...)
		else
			print("[CopiTLua]: Prevented " .. func_name .. " from being called")
		end
	end

	return guarded
end

local guarded_ModSettingSet = MakeAllOrNothingGuard("ModSettingSet")
local guarded_ModSettingSetNextValue = MakeAllOrNothingGuard("ModSettingSetNextValue")
local guarded_ModSettingRemove = MakeAllOrNothingGuard("ModSettingRemove")
local guarded_AddFlagPersistent = MakeAllOrNothingGuard("AddFlagPersistent")
local guarded_RemoveFlagPersistent = MakeAllOrNothingGuard("RemoveFlagPersistent")

install_hooks = function()
	_streaming_on_irc = streaming_on_irc_hook
	EntityKill = guarded_EntityKill
	ModSettingSet = guarded_ModSettingSet
	ModSettingSetNextValue = guarded_ModSettingSetNextValue
	ModSettingRemove = guarded_ModSettingRemove
	AddFlagPersistent = guarded_AddFlagPersistent
	RemoveFlagPersistent = guarded_RemoveFlagPersistent
end

-- Initial install
install_hooks()
