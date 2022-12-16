-- Inject the_funny.lua
ModLuaFileAppend("data/scripts/streaming_integration/event_utilities.lua", "mods/Copis_Twitchy_Lua/the_funny.lua")

-- Save ModTextFile functions past initialization
Write = ModTextFileSetContent
Read = ModTextFileGetContent

-- Somehow, this works.
dofile("data/scripts/streaming_integration/event_utilities.lua")
-- TODO: filter mod setting and persistent flag setting code, look for any vulnerabilities in code