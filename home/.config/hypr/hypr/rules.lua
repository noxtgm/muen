-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Ignore maximize requests from all apps
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Floating and centered file picker, screen share picker, password prompt, and permission prompts
hl.window_rule({
    name  = "float-system-dialogs",
    match = { class = "^(xdg-desktop-portal-gtk|hyprland-share-picker|hyprpolkitagent|hyprland-dialog)$" },

    float  = true,
    center = true,
})

-- Hide the password prompt from screen sharing and keep focus on it until answered
hl.window_rule({
    name  = "protect-polkit-prompt",
    match = { class = "^hyprpolkitagent$" },

    no_screen_share = true,
    stay_focused    = true,
})


-- Keep browser picture in picture on all workspaces
hl.window_rule({
    name  = "librewolf-picture-in-picture",
    match = { class = "^librewolf$", title = "^Picture-in-Picture$" },

    float             = true,
    pin               = true,
    keep_aspect_ratio = true,
    border_size       = 0,
})

-- Floating and centered browser downloads, history, and bookmarks window
hl.window_rule({
    name  = "librewolf-library",
    match = { class = "^librewolf$", title = "^Library$" },

    float  = true,
    center = true,
})

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- No border when a window is alone on its workspace
hl.window_rule({
    name  = "no-border-single",
    match = { float = false, workspace = "w[tv1]" },

    border_size = 0,
})

-- Teal border on scratchpad windows
hl.window_rule({
    name  = "highlight-scratchpad",
    match = { workspace = "s[true]" },

    border_size  = 2,
    border_color = "rgb(2aa1b3)",
})

-- Highlighted border when a window is maximized
hl.window_rule({
    name  = "highlight-maximized",
    match = { fullscreen_state_internal = 1 },

    border_size  = 2,
    border_color = "rgb(e5a50a)",
})

-- Opening an empty scratchpad opens a terminal in it
hl.workspace_rule({
    workspace        = "special:scratchpad",
    gaps_out         = 10,
})

-- Hide the launcher from screen sharing and open it instantly
hl.layer_rule({
    name  = "hyprlauncher",
    match = { namespace = "^hyprlauncher$" },

    no_anim         = true,
    no_screen_share = true,
})
