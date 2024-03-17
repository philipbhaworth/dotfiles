-- Define the configuration table
local config = {
    -- Choose your color scheme
    -- Uncomment one of the following color schemes or add your own:
    -- config.color_scheme = 'AdventureTime'
    -- config.color_scheme = 'Gruvbox (Gogh)'
    -- config.color_scheme = 'Gruvbox Dark (Gogh)'
    -- config.color_scheme = 'Gruvbox dark, medium (base16)'
    -- config.color_scheme = 'GruvboxDark'
    -- config.color_scheme = 'GruvboxDarkHard'
    -- config.color_scheme = 'Tokyo Night'
    -- config.color_scheme = 'tokyonight'
    -- config.color_scheme = 'Tokyo Night Storm'

    -- Set your chosen color scheme
    color_scheme = "Dracula (Official)",

    -- Set tab bar position
    tab_bar_at_bottom = false,

    -- Use fancy tab bar or not
    use_fancy_tab_bar = false,

    -- Set window decorations
    window_decorations = "RESIZE",
}

-- Return the configuration to Wezterm
return config
