hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "intl",

        repeat_rate  = 40,
        repeat_delay = 300,

        follow_mouse = 1,

        accel_profile = "flat",
        sensitivity   = 0.4,

        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            clickfinger_behavior = true,
            disable_while_typing = true,
        },

        touchdevice = {
            output = "eDP-1",
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.gesture({
    fingers        = 3,
    direction      = "vertical",
    action         = "special",
    workspace_name = "scratchpad",
})
