local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')

local volume_icon = wibox.widget.textbox()
volume_icon.font = beautiful.font
local volume_widget = wibox.widget.textbox()
volume_widget.align = 'center'
volume_widget.valign = 'center'
volume_widget.font = beautiful.font

local volume

local function update_volume()
    awful.spawn.easy_async_with_shell("bash -c 'amixer get Master'", function(stdout)
        volume = string.match(stdout, '(%d?%d?%d)%%')

        awful.spawn.easy_async_with_shell("bash -c 'amixer get Master'", function(muted)
            muted = string.match(muted, "%[%w%w?%w%]")

            if muted == '[on]' and (volume > '50' or volume == '100') then
                volume_icon.text = '墳'
            elseif muted == '[on]' and volume <= '50' and volume > '0' then
                volume_icon.text = '奔'
            elseif muted == '[off]' then
                volume_icon.text = '婢'
            elseif volume == '[on]' then
                volume_icon.text = '奄'
            end
            volume_widget.text = volume
        end)
        collectgarbage('collect')
    end)
end

watch('bash -c', 3, function(_, stdout)
    update_volume()
end)

return wibox.widget {
    wibox.widget{
        volume_icon,
        widget = wibox.container.background
    },
    volume_widget,
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal
}
