-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local hotkeys_popup = require("awful.hotkeys_popup")
local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
local mouse_left = 1
local mouse_right = 3
local mouse_wheel = 2
local mouse_wheel_up = 4
local mouse_wheel_down = 5

-- Changing keyboard layout
awful.spawn("setxkbmap -layout us,ru -option 'grp:alt_shift_toggle'")

local hotkeys = { }

-- Mouse bindings
hotkeys.client_buttons = gears.table.join(
    awful.button({ }, 1, 
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),

    awful.button({modkey}, mouse_left, 
        function(c) 
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end), 
    
    awful.button({modkey}, mouse_right, 
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
)

hotkeys.client_keys = gears.table.join(
    awful.key({modkey, "Shift"}, "q",
        function(c) c:kill() end,
        { description = "close", group = "client" }),

    awful.key({modkey, "Control"}, "Return",
        function(c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}),

    awful.key({modkey}, "o",
        function(c) c:move_to_screen() end, 
        { description = "move to screen", group = "client" }),
    
    awful.key({modkey}, "t", 
        function(c) c.ontop = not c.ontop end, 
        {description = "toggle keep on top", group = "client"}),
                              
    awful.key({modkey}, "n",
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        function(c) c.minimized = true end,
        {description = "minimize", group = "client"}),
                              
    awful.key({modkey}, "m", 
        function(c) 
            c.maximized = not c.maximized 
            c:raise()
        end, 
        {description = "(un)maximize", group = "client"}),
        
    awful.key({modkey, "Control"}, "m", 
        function(c)
            if c then
                c.maximized_vertical = not c.maximized_vertical 
                c:raise()
            end
        end,
        {description = "(un)maximize vertically", group = "client"}),
                              
    awful.key({modkey, "Shift"}, "m", 
        function(c)
            if c then
                c.maximized_horizontal = not c.maximized_horizontal 
                c:raise()
            end
        end,
        {description = "(un)maximize horizontally", group = "client"})
)

hotkeys.global_buttons = gears.table.join (
    awful.button({}, mouse_wheel_up, awful.tag.viewnext),
    awful.button({}, mouse_wheel_down, awful.tag.viewprev)
)

hotkeys.global_keys = gears.table.join(hotkeys.global_keys,
    awful.key({modkey}, "s",
        hotkeys_popup.show_help, 
        { description = "show help",
        group = "awesome"}),

    -- Spawn programs
    awful.key({modkey}, "d", 
        function() awful.spawn("rofi -show combi") end,
        {description = "show the rofi drun", group = "launcher"}),

    awful.key({modkey}, "b", 
        function() awful.spawn("firefox") end,
        {description = "start the firefox", group = "launcher"}),

    awful.key({modkey}, "e", 
        function() awful.spawn("thunar") end,
        {description = "start the thunar", group = "launcher"}),

    awful.key({modkey}, "Return", 
        function() awful.spawn("alacritty") end,
        {description = "open a terminal", group = "launcher"}),

    awful.key({modkey, "Shift"}, "Tab", 
        function() awful.spawn("rofi -show window") end,
        {description = "show rofi window searcher", group = "launcher"}),

    -- Layout manipulation
    awful.key({modkey, "Shift"}, "j",
        function() awful.client.swap.byidx(1) end, 
        {description = "swap with next client by index", group = "client"}),

    awful.key({modkey, "Shift"}, "k",
        function() awful.client.swap.byidx(-1) end, 
        {description = "swap with previous client by index", group = "client"}),

    awful.key({modkey, "Control" }, "j", 
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    
    awful.key({modkey, "Control" }, "k", 
        awful.tag.viewnext, 
        {description = "view next", group = "tag"}), 

    awful.key({modkey}, "j",
        function() awful.client.focus.byidx(-1) end,
        {description = "focus the previous client", group = "screen"}),

    awful.key({modkey}, "k",
        function() awful.client.focus.byidx(1) end, 
        {description = "focus the next client", group = "screen"}),

    awful.key({modkey}, "u",
        awful.client.urgent.jumpto, 
        { description = "jump to urgent client", group = "client" }), 
        
    awful.key({modkey}, "Tab", 
        function() 
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end, 
        {description = "go back", group = "client"}), 

    awful.key({modkey, "Control"}, "r",
        awesome.restart, 
        { description = "reload awesome", group = "awesome" }), 

    awful.key({modkey}, "l", 
        function() awful.tag.incmwfact(0.05) end, 
        { description = "increase master width factor", group = "layout" }),

    awful.key({modkey}, "h", 
        function() awful.tag.incmwfact(-0.05) end, 
        {description = "decrease master width factor", group = "layout"}),
                                    
    awful.key({modkey, "Shift"}, "h",
        function() awful.tag.incnmaster(1, nil, true) end, 
        {description = "increase the number of master clients", group = "layout"}),
    
    awful.key({modkey, "Shift"}, "l",
        function() awful.tag.incnmaster(-1, nil, true) end, 
        {description = "decrease the number of master clients", group = "layout"}),
                                    
    awful.key({modkey, "Control"}, "h",
        function() awful.tag.incncol(1, nil, true) end, 
        {description = "increase the number of columns", group = "layout"}),

    awful.key({modkey, "Control"}, "l",
        function() awful.tag.incncol(-1, nil, true) end, 
        {description = "decrease the number of columns", group = "layout"}),

    awful.key({modkey}, "space",
        function() awful.layout.inc(1) end,
        {description = "select next", group = "layout"}),
                                    
    awful.key({modkey, "Shift"}, "space",
        function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }), 
        
    awful.key({modkey, "Control"}, "n", 
        function() 
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end, 
        {description = "restore minimized", group = "client"}),
        
    awful.key({modkey, "Control"}, "space", 
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),

    awful.key({ modkey }, "Escape",
        function () awesome.emit_signal("exit_screen::show") end,
        { description = "show exit screen", group = "awesome" }),
    
    -- Functional keys
    awful.key({}, "XF86PowerOff",
        function () awesome.emit_signal("exit_screen::show") end,
        { description = "show exit screen", group = "awesome" }),

    awful.key({}, "XF86MonBrightnessDown",
        function ()
            helpers.change_brightness(-5) 
            -- TODO
        end,
        { description = "monitor brightness down", group = "screen" }),

    awful.key({}, "XF86MonBrightnessUp",
        function () 
            helpers.change_brightness(5)
            -- TODO
        end,
        { description = "monitor brightness up", group = "screen" }),

    awful.key({}, "XF86MonBrightnessDown",
        function () 
            -- TODO
        end,
        { description = "monitor brightness down", group = "screen" }),

    awful.key({}, "XF86AudioMute",
        function ()
            helpers.toggle_volume_mute() 
            -- TODO
        end,
        { description = "audio mute", group = "audio" }),

    awful.key({}, "XF86AudioLowerVolume",
        function () 
            helpers.change_volume(-5)
            -- TODO
        end,
        { description = "audio lower volume", group = "audio" }),

    awful.key({}, "XF86AudioRaiseVolume",
        function () 
            helpers.change_volume(5)
            -- TODO
        end,
        { description = "audio raise volume", group = "audio" }),

    awful.key({}, "XF86AudioMicMute",
        function () 
            helpers.toggle_mic_mute()
            -- TODO
        end,
        { description = "audio mic mute", group = "audio" }),
    
    -- Screenshots
    awful.key({}, "Print", 
        function() awful.spawn.with_shell("maim | xclip -selection clipboard -t image/png") end,
        { description = "make screenshot of the screen", group = "screen" }),

    awful.key({ modkey, "Shift" }, "s", 
        function() awful.spawn.with_shell("maim -s | xclip -selection clipboard -t image/png") end,
        { description = "make screenshot of the screen", group = "screen" })
    )
            
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    hotkeys.global_keys = gears.table.join(hotkeys.global_keys, -- View tag only.
    awful.key({modkey}, "#" .. i + 9, 
        function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then tag:view_only() end
        end, 
        {description = "view tag #" .. i, group = "tag"}),
    -- Toggle tag display.

    awful.key({modkey, "Control"}, "#" .. i + 9,
        function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then awful.tag.viewtoggle(tag) end
        end, 
        {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({modkey, "Shift"}, "#" .. i + 9,
        function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:move_to_tag(tag) end
            end
        end, 
        {description = "move focused client to tag #" .. i, group = "tag"}),

    -- Toggle tag on focused client.
    awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, 
        function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:toggle_tag(tag) end
            end
        end, 
        {description = "toggle focused client on tag #" .. i, group = "tag"}))
end

return hotkeys