-- See https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        layout = "dwindle",

        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 2,

        resize_on_border = true,

        col = {
            active_border   = "rgb(d0d0d0)",
            inactive_border = "rgb(303030)",
        },
    },

    decoration = {
        rounding    = 0,
        dim_special = 0.2,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = false,
        },
    },

    dwindle = {
        preserve_split = true,
        force_split    = 2, -- New windows open to the right or below
        precise_mouse_move = true,
    },

    misc = {
        allow_session_lock_restore = true, -- Allow restarting hyprlock if it crashes (session stays locked meanwhile)
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        focus_on_activate          = true,
        background_color           = "rgb(000000)",
        vrr                        = 0,
    },

    cursor = {
        sync_gsettings_theme     = true,
        hide_on_key_press        = true,
        inactive_timeout         = 5,
        warp_on_change_workspace = 1,
        warp_on_toggle_special   = 1,
    },

    binds = {
        hide_special_on_workspace_change = true,
        workspace_back_and_forth         = false,
    },

    animations = {
        enabled = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 },   { 0.32, 1 } } })
hl.curve("linear",       { type = "bezier", points = { { 0, 0 },      { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 },  { 0.75, 1 } } })
hl.curve("quick",        { type = "bezier", points = { { 0.15, 0 },   { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 3.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
