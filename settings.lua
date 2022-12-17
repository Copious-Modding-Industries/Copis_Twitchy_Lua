dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.
dofile("data/scripts/lib/utilities.lua")
local mod_id = "Copis_Twitchy_Lua"
mod_settings_version = 1

mod_settings =
{
    {
        id = "poweruser",
        ui_name = "Power User",
        ui_description = "This user can execute Lua Code!",
        value_default = "CopiHuman",
        text_max_length = 60,
        allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789",
        scope = MOD_SETTING_SCOPE_RUNTIME,
        change_fn = mod_setting_change_callback -- Called when the user interact with the settings widget.
    },
    {
        id = "pandemonium",
        ui_name = "Pandemonium",
        ui_description = "Ignore Power User, everyone can run code! use with caution.",
        value_default = false,
        scope = MOD_SETTING_SCOPE_RUNTIME,
    },
    {
        id = "chaos",
        ui_name = "Chaos",
        ui_description = "No banned functions. Users may corrupt saves or damage mod settings/progress!",
        value_default = false,
        scope = MOD_SETTING_SCOPE_RUNTIME,
    },
}

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end

function ModSettingsUpdate( init_scope )
    local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
    mod_settings_update( mod_id, mod_settings, init_scope )
end