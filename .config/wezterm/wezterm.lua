local wezterm = require('wezterm')
local mux = wezterm.mux

local config = {
    check_for_updates = false,
    use_ime = true,
    color_scheme = 'Macintosh (base16)',
    font = wezterm.font_with_fallback {
        'Source Han Code JP',
        'ricty diminished',
        'Cascadia Code',
        'Cascadia Mono'
    },
    font_size = 12.0,
    adjust_window_size_when_changing_font_size = false,
    tab_bar_at_bottom = true,
    inactive_pane_hsb = {
      saturation = 0.5,
      brightness = 0.6,
    },
    window_background_opacity = 0.8,
}

return config
