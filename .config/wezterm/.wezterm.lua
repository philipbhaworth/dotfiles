-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- Create a configuration builder
local config = wezterm.config_builder()

-- Choose your color scheme
-- Uncomment one of the following color schemes or add your own:
-- config.color_scheme = 'AdventureTime'
-- config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'Chalk'
config.color_scheme = 'Dracula (Official)'
-- config.color_scheme = 'Everforest Dark (Gogh)'
-- config.color_scheme = 'Everforest Dark Hard (Gogh)'
-- config.color_scheme = 'Google (dark) (terminal.sexy)'
-- config.color_scheme = 'Gruvbox (Gogh)'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'Gruvbox dark, medium (base16)'
-- config.color_scheme = 'GruvboxDark'
-- config.color_scheme = 'GruvboxDarkHard'
-- config.color_scheme = 'Material (base16)'
-- config.color_scheme = 'Monokai (dark) (terminal.sexy)'
-- config.color_scheme = 'Monokai Pro (Gogh)'
-- config.color_scheme = 'Monokai Pro Ristretto (Gogh)'
-- config.color_scheme = 'Ocean Dark (Gogh)'
-- config.color_scheme = 'Rosé Pine (Gogh)'
-- config.color_scheme = 'rose-pine-moon'
-- config.color_scheme = 'Rosé Pine Moon (base16)'
-- config.color_scheme = 'Rosé Pine Moon (Gogh)'
-- config.color_scheme = 'Tango (base16)'
-- config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'tokyonight'
-- config.color_scheme = 'Tokyo Night Moon'
-- config.color_scheme = 'Tokyo Night Storm'

-- Set the font and font size
config.font = wezterm.font_with_fallback({
  {family="Hack Nerd Font Mono", weight="Regular", stretch="Normal", style="Normal"},
  "JetBrains Mono", -- This is a fallback font
})
config.font_size = 13.0 -- Adjust the font size as needed

-- Optional: Set tab bar position
--config.tab_bar_at_bottom = false -- Set true to move the tab bar to the bottom of the window

-- Optional: Use fancy tab bar or not
--config.use_fancy_tab_bar = true -- Enable this to use a fancier tab bar with more visual elements

-- Optional: Set window decorations
-- config.window_decorations = "RESIZE" -- Set to "NONE" to disable, "RESIZE" to allow only resizing

-- Define a function to determine tab titles
function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

-- Setup the event handler for customizing tab titles
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)
  if tab.is_active then
    return {
        { Background = { Color = 'black' } },
        { Text = ' ' .. title .. ' ' },
        { Foreground = { Color = 'white' } }
    }
  end
  return title
end)

-- Return the configuration to WezTerm
return config

