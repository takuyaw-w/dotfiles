local wezterm = require('wezterm')
local mux = wezterm.mux

-- 利用可能なカラースキームを取得
local available_schemes = wezterm.get_builtin_color_schemes()

-- 優先するカラースキームのリスト
local preferred_schemes = {
    "Monokai Pro (Gogh)", -- 第一候補
    "Gruvbox Dark",     -- 第二候補
    "Solarized Dark",   -- 第三候補
}

-- 利用可能なスキームから最適なものを選ぶ
local function select_color_scheme()
    for _, scheme in ipairs(preferred_schemes) do
        if available_schemes[scheme] then
            return scheme
        end
    end
    -- フォールバック：指定がすべて無効ならデフォルトを返す
    return "Builtin Solarized Dark"
end


local config = {
    check_for_updates = false,
    use_ime = true,
    color_scheme = select_color_scheme(),
    font = wezterm.font_with_fallback {
        { family = "Source Han Code JP", weight = "Light", stretch = "Normal", style = "Normal" },
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
    window_background_opacity = 1,
    warn_about_missing_glyphs = false,
    keys = {
        {
            key = 'P',
            mods = 'CTRL',
            action = wezterm.action.ActivateCommandPalette,
        },
        { key = 'T', mods = 'CTRL', action = wezterm.action.SpawnTab('DefaultDomain') },
        { key = 'W', mods = 'CTRL', action = wezterm.action.CloseCurrentTab { confirm = true } },
    },
    scrollback_lines = 10000,
    colors = {
        tab_bar = {
            -- アクティブタブの背景色
            active_tab = {
                bg_color = "#333333",
                fg_color = "#ffffff",
            },
            -- 非アクティブタブの背景色
            inactive_tab = {
                bg_color = "#222222",
                fg_color = "#888888",
            },
            -- 非アクティブタブのホーバー時の背景色
            inactive_tab_hover = {
                bg_color = "#444444",
                fg_color = "#dddddd",
            },
            -- 新しいタブボタンの背景色
            new_tab = {
                bg_color = "#1d1d1d",
                fg_color = "#ffffff",
            },
            -- 新しいタブボタンのホーバー時の背景色
            new_tab_hover = {
                bg_color = "#5f5f5f",
                fg_color = "#ffffff",
            },
        },
    },
    audible_bell = "Disabled",
}

return config
