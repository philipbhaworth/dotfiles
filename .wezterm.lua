-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
-- config.color_scheme = 'Gruvbox (Gogh)'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
config.color_scheme = 'Gruvbox dark, medium (base16)'
-- config.color_scheme = 'GruvboxDark'
-- config.color_scheme = 'GruvboxDarkHard'
-- config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'tokyonight'
-- config.color_scheme = 'Tokyo Night Storm'

-- and finally, return the configuration to wezterm
return config

