-------------------------------------------------
-- mpris based Arc Widget for Awesome Window Manager
-- Modelled after Pavel Makhov's work
-- @author Mohammed Gaber
-- requires - playerctl
-- @copyright 2020
-------------------------------------------------
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local GET_MPD_CMD =
    "playerctl -f '{{status}};{{xesam:artist}};{{xesam:title}};{{mpris:artUrl}}' metadata"

local TOGGLE_MPD_CMD = "playerctl play-pause"
local NEXT_MPD_CMD = "playerctl next"

local PATH_TO_ICONS = gears.filesystem.get_configuration_dir() .. "icons/player/"
local PAUSE_ICON_NAME = PATH_TO_ICONS .. "player_playing.svg"
local PLAY_ICON_NAME = PATH_TO_ICONS .. "player_paused.svg"
local STOP_ICON_NAME = PATH_TO_ICONS .. "player_stopped.svg"
local NEXT_TRACK_NAME = PATH_TO_ICONS .. "next_track.svg"

local play_button = wibox.widget {
    image  = STOP_ICON_NAME,
    widget = wibox.widget.imagebox
}

local next_button = wibox.widget {
    image = NEXT_TRACK_NAME,
    widget = wibox.widget.imagebox
}

local player_widget = wibox.widget {
    play_button,
    next_button,
    spacing = dpi(5),
    layout = wibox.layout.fixed.horizontal
}

local player_tooltip = awful.tooltip {
    objects = { player_widget },
    mode = 'outside',
    text = " No player info"
}

local update_widget = function(player_status, artist, current_song)
    if player_status == "Playing" then
        play_button.image = PLAY_ICON_NAME
        player_tooltip.text = " " .. artist .. " - " .. current_song
    elseif player_status == "Paused" then
        play_button.image = PAUSE_ICON_NAME
        player_tooltip.text = " " .. artist .. " - " .. current_song
    elseif player_status == "Stopped" then
        play_button.image = STOP_ICON_NAME
        player_tooltip.text = " " .. artist .. " - " .. current_song
    else -- no player is running
        play_button.image = STOP_ICON_NAME
        player_tooltip.text = " No player info"
    end
end

local update_player_data = function()
    awful.spawn.easy_async(GET_MPD_CMD, function(stdout, _, _, _)
        local words = gears.string.split(stdout, ';')
        local player_status = words[1]
        local artist = words[2]
        local current_song = words[3]
    
        if current_song ~= nil then
            if string.len(current_song) > 18 then
                current_song = string.sub(current_song, 0, 9) .. ".."
            end
        end

        update_widget(player_status, artist, current_song)
    end)
end

play_button:buttons(
    awful.button({}, 1, function()
        awful.spawn(TOGGLE_MPD_CMD, false)
    end))

next_button:buttons(
    awful.button({}, 1, function()
        awful.spawn(NEXT_MPD_CMD, false)
    end))

local naughty = require("naughty")

local dbus_result = dbus.request_name("session", "org.mpris.MediaPlayer2.playerctl")
dbus.add_match("session", "interface='org.freedesktop.DBus.Properties', member='PropertiesChanged'")
dbus_result = dbus_result and dbus.connect_signal("org.freedesktop.DBus.Properties", update_player_data)

if dbus_result == false then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Player widget",
        text = tostring("Player session not found.")
    })
end

return player_widget
