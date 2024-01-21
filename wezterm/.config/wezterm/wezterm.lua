-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration
local config = {}

-- Use the config_builder (newer version of Wezterm)
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you apply your config choices
-- Set the color scheme
config.color_scheme = 'Catppuccin Macchiato'

-- Set the font
config.font = wezterm.font 'CaskaydiaCove Nerd Font'

-- Finally return the configuration to Wezterm
return config
