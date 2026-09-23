local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.enable_wayland = false

config.font = wezterm.font_with_fallback({
    'Source Code Pro',
    'DejaVu Sans Mono',
    'Noto Sans Mono',
})
config.font_size = 18.0
config.line_height = 1.15

config.color_scheme = 'Catppuccin Mocha'
config.colors = {
    background = '#1e1e2e',
    cursor_bg = '#cba6f7',
    cursor_border = '#cba6f7',
    cursor_fg = '#1e1e2e',
    selection_bg = '#585b70',
    selection_fg = '#cdd6f4',
    split = '#cba6f7',
}

config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

config.window_decorations = 'NONE'
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.window_padding = {
    left = 12,
    right = 12,
    top = 10,
    bottom = 10,
}

config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false

config.default_prog = {
    wezterm.home_dir .. '/.local/bin/tmux',
    'new-session',
    '-A',
    '-s',
    'main',
}

local act = wezterm.action

local smart_paste = wezterm.action_callback(function(window, pane)
    local success, stdout, stderr = wezterm.run_child_process({
        wezterm.home_dir .. '/.local/bin/wezterm-paste-handler.sh'
    })
    if success and stdout and stdout ~= '' then
        pane:send_text(stdout)
    else
        window:perform_action(act.PasteFrom 'Clipboard', pane)
    end
end)

config.keys = {
    {
        key = 'c',
        mods = 'CTRL|SHIFT',
        action = act.CopyTo 'Clipboard',
    },
    {
        key = 'v',
        mods = 'CTRL|SHIFT',
        action = smart_paste,
    },
    {
        key = 'Insert',
        mods = 'SHIFT',
        action = smart_paste,
    },
    {
        key = 'c',
        mods = 'CTRL',
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ''
            if has_selection then
                window:perform_action(act.CopyTo 'Clipboard', pane)
            else
                window:perform_action(act.SendKey{ key = 'c', mods = 'CTRL' }, pane)
            end
        end),
    },
    {
        key = 'v',
        mods = 'CTRL',
        action = smart_paste,
    },
}

config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        mouse_reporting = true,
        action = smart_paste,
    },
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        mouse_reporting = true,
        action = act.SelectTextAtMouseCursor 'Cell',
    },
    {
        event = { Drag = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        mouse_reporting = true,
        action = act.ExtendSelectionToMouseCursor 'Cell',
    },
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        mouse_reporting = true,
        action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection',
    },
    {
        event = { Down = { streak = 2, button = 'Left' } },
        mods = 'NONE',
        mouse_reporting = true,
        action = act.SelectTextAtMouseCursor 'Word',
    },
    {
        event = { Down = { streak = 3, button = 'Left' } },
        mods = 'NONE',
        mouse_reporting = true,
        action = act.SelectTextAtMouseCursor 'Line',
    },
}

return config

