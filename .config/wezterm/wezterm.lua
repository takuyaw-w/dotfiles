local wezterm = require('wezterm')
local mux = wezterm.mux

local config = {
    check_for_updates = false,
    use_ime = true,
    color_scheme = 'Monokai Pro (Gogh)',
    font = wezterm.font_with_fallback {
        {family="Source Han Code JP", weight="Light", stretch="Normal", style="Normal"},
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
    window_background_opacity = 0.9,
    warn_about_missing_glyphs = false,
    keys = {
      {
        key = 'P',
        mods = 'CTRL',
        action = wezterm.action.ActivateCommandPalette,
      },
    },
}

return config
