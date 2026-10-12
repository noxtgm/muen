-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local terminal = "ghostty"
local menu     = "hyprlauncher"

-- Applications
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal), { description = "Terminal" })
hl.bind("SUPER + SPACE",  hl.dsp.exec_cmd(menu),     { description = "App launcher" })

-- Window management
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close(),                     { description = "Close window" })
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }),        { description = "Toggle floating" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized" }),  { description = "Maximize" })
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"),                      { description = "Toggle split" })

-- Focus
hl.bind("SUPER + LEFT",  hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind("SUPER + UP",    hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + DOWN",  hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- Move windows
hl.bind("SUPER + SHIFT + LEFT",  hl.dsp.window.move({ direction = "l" }), { description = "Move left" })
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({ direction = "r" }), { description = "Move right" })
hl.bind("SUPER + SHIFT + UP",    hl.dsp.window.move({ direction = "u" }), { description = "Move up" })
hl.bind("SUPER + SHIFT + DOWN",  hl.dsp.window.move({ direction = "d" }), { description = "Move down" })

-- Workspaces bound by key code so the number row works with any layout
for workspace = 1, 10 do
    local key = "code:" .. tostring(workspace + 9)
    hl.bind("SUPER + " .. key,         hl.dsp.focus({ workspace = tostring(workspace) }),       { description = "Workspace " .. workspace })
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace) }), { description = "Move to workspace " .. workspace })
end

-- Tab switching
hl.bind("SUPER + TAB",         hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })

-- Scratchpad
hl.bind("SUPER + S",         hl.dsp.workspace.toggle_special("scratchpad"),                             { description = "Toggle scratchpad" })
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }),  { description = "Move to scratchpad" })

-- Window cycling
hl.bind("ALT + TAB",         hl.dsp.window.cycle_next(),                    { description = "Next window" })
hl.bind("ALT + TAB",         hl.dsp.window.bring_to_top(),                  { description = "Bring to top" })
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }),    { description = "Previous window" })
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.bring_to_top(),                  { description = "Bring to top" })

-- Mouse
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }),  { description = "Scroll workspace forward" })
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }),  { description = "Scroll workspace backward" })
hl.bind("SUPER + mouse:272",  hl.dsp.window.drag(),                 { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273",  hl.dsp.window.resize(),               { mouse = true, description = "Resize window" })

-- Volume
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Player controls
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })

-- Airplane mode
hl.bind("XF86RFKill", hl.dsp.exec_cmd("rfkill toggle all"), { locked = true })
