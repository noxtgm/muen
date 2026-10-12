-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "eDP-1",
    mode     = "2880x1920@120",
    position = "0x0",
    scale    = 1.875,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Closing the lid turns the internal display off while an external monitor is connected
hl.bind("switch:on:Lid switch", function ()
    if #hl.get_monitors() > 1 then
        hl.monitor({ output = "eDP-1", disabled = true })
    end
end, { locked = true, description = "Lid closed" })

hl.bind("switch:off:Lid switch", function ()
    hl.monitor({ output = "eDP-1", disabled = false })
end, { locked = true, description = "Lid opened" })

-- Toggle mirroring the internal display on external monitors
local mirrored = false
hl.bind("SUPER + P", function ()
    mirrored = not mirrored
    hl.monitor({ output = "", mirror = mirrored and "eDP-1" or "" })
end, { description = "Toggle mirroring" })
