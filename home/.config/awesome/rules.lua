local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys = require("hotkeys")

local rules = {

    -- All clients will match this rule
    {
        rule = { }, 
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            keys = hotkeys.client_keys,
            buttons = hotkeys.client_buttons,
            fullscreen = false,
            maximized = false,
        },
    },
    
    -- Dilogs rules
    {
        rule_any = {
            type = {"dialog"},
            class = {"Telegram"},
        },
        properties = {
            floating = true,
            raise = true,
            placement = awful.placement.centered
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry"
            },
            class = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin", -- kalarm.
                "Sxiv", "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui", "veromix", "xtightvncviewer",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    }
}

return rules


