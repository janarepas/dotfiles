local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local opacity = 0.500
local opacity_unfocus = 0.400

config.initial_cols = 100
config.initial_rows = 60
config.font_size = 18

wezterm.on('window-focus-changed', function(window, pane)
    local overrides = window:get_config_overrides() or {}

    if window:is_focused() then
        overrides.window_background_opacity = opacity
    else
        overrides.window_background_opacity = opacity_unfocus
    end

    window:set_config_overrides(overrides)
end)

config.window_background_opacity = opacity
config.window_background_opacity = opacity_unfocus
config.macos_window_background_blur = 45

return config
