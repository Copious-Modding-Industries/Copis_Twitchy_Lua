-- Inject the_funny.lua
ModLuaFileAppend("data/scripts/streaming_integration/event_utilities.lua", "mods/Copis_Twitchy_Lua/the_funny.lua")

-- Save ModTextFile functions past initialization
Write = ModTextFileSetContent
Read = ModTextFileGetContent

-- ???
dofile("data/scripts/streaming_integration/event_utilities.lua")

-- Run every frame
function OnWorldPreUpdate()
	-- Check if connected to twitch
	if not StreamingGetIsConnected() then
		-- Warn user if twitch is disconnected
		Gui = Gui or GuiCreate()
		GuiStartFrame(Gui)
		GuiIdPushString(Gui, "Copis_Twitchy_Lua")
			-- Popup
			GuiBeginAutoBox(Gui)
				local msg = "Twitch Disconnected!"
				local sw, sh = GuiGetScreenDimensions(Gui)
				local tw, th = GuiGetTextDimensions(Gui, msg)
				local iw, ih = GuiGetImageDimensions(Gui, "data/ui_gfx/inventory/icon_warning.png", 2)
				local tx, ty = (sw - tw) / 2, ((sh / 2) - th) / 2
				local ix, iy = (sw - iw) / 2, ((sh / 2) - ih) / 2
				GuiOptionsAddForNextWidget(Gui, 25)
				GuiColorSetForNextWidget(Gui, 0.8, 0.6, 0, 1)
				GuiText(Gui, tx, ty + 10, msg)
				GuiOptionsAddForNextWidget(Gui, 25)
				GuiImage(Gui, 1, ix, iy - 15, "data/ui_gfx/inventory/icon_warning.png", 1, 2, 2)
			GuiZSetForNextWidget(Gui, 5)
			GuiEndAutoBoxNinePiece(Gui, 5, 0, 0, false, 0, "data/ui_gfx/decorations/9piece0.png", "data/ui_gfx/decorations/9piece0.png")
		GuiIdPop(Gui)
	end
end
-- TODO: filter mod setting and persistent flag setting code, look for any vulnerabilities in code, message queue
