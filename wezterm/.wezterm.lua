-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Create a configuration builder
local config = wezterm.config_builder()

-- Choose your color scheme
-- config.color_scheme = 'Dracula (Official)'
-- config.color_scheme = 'catppuccin-frappe'
-- config.color_scheme = 'Everforest Dark Medium (Gogh)'
-- config.color_scheme = 'Everforest Dark Hard (Gogh)'
-- config.color_scheme = "OneHalfDark"
config.color_scheme = "Nord (base16)"
-- config.color_scheme = 'PaperColor Dark (base16)'
-- config.color_scheme = 'Papercolor Dark (Gogh)'
-- config.color_scheme = 'Tokyo Night Storm'

-- Set the font and font size
config.font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font Mono", weight = "Regular", stretch = "Normal", style = "Normal" },
	"JetBrains Mono", -- This is a fallback font
})
config.font_size = 13.0

-- Define keyboard shortcuts
config.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
}

-- Define a function to determine tab titles
function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

-- Setup the event handler for customizing tab titles
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	if tab.is_active then
		return {
			{ Background = { Color = "black" } },
			{ Text = " " .. title .. " " },
			{ Foreground = { Color = "white" } },
		}
	end
	return title
end)

-- Return the configuration to WezTerm
return config
