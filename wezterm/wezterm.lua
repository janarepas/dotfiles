local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Átlátszóság
config.window_background_opacity = 0.5
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 0.4,
}

-- Alapbeállítások
config.initial_cols = 100
config.initial_rows = 60
config.font_size = 18
config.color_scheme = "Tokyo Night"

return config
