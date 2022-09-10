local wezterm = require("wezterm")

local config = {
    check_for_updates = false,
    use_ime = true,
    color_scheme = "Afterglow (Gogh)",
    font = wezterm.font_with_fallback {
        'Source Han Code JP',
        'ricty diminished',
        'Cascadia Code', -- for windows
        'Cascadia Mono' -- for windows
    },
    font_size = 14.0,
    adjust_window_size_when_changing_font_size = false,
}

return config
