-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_THEME", "Adwaita", true)
hl.env("XCURSOR_SIZE", "24", true)
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_SCALE", "2") -- Scale GTK apps running through XWayland

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },

    ecosystem = {
        no_update_news      = true,
        no_donation_nag     = true,
        enforce_permissions = true,
    },
})
