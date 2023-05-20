local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')

-- local clock = wibox.widget.textclock(' %d %b  %H:%M') -- with date
local clock = wibox.widget.textclock('%H:%M') -- only clock
clock.font = beautiful.font_name .. ' Bold 11'

local calendar = awful.widget.calendar_popup.month()
calendar.shape = beautiful.calendar_shape
calendar:attach( clock, 'tc' )

return clock