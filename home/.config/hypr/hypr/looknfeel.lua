-- See https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 2,

        col = {
            active_border   = "rgb(d0d0d0)",
            inactive_border = "rgb(303030)",
        },
    },

    decoration = {
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
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        focus_on_activate        = true,
        background_color         = "rgb(000000)",
    },

    cursor = {
        hide_on_key_press        = true,
        inactive_timeout         = 3,
        warp_on_change_workspace = 1,
        warp_on_toggle_special   = 1,
    },

    binds = {
        hide_special_on_workspace_change = true,
        workspace_back_and_forth         = true,
    },
})
