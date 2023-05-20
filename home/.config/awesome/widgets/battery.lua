-------------------------------------------------
-- Battery Widget for Awesome Window Manager
-- Shows the battery status using the ACPI tool
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget
-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------
local awful = require('awful')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears')

local icons_path = gears.filesystem.get_configuration_dir() .. 'icons/battery/'

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local percentage = wibox.widget.textbox()

local battery = wibox.widget {
    {
        id = 'imagebox',
        image = icons_path .. 'battery.svg',
        forced_width = dpi(16),
        forced_height = dpi(16),
        widget = wibox.widget.imagebox
    },
    valign = 'center',
    widget = wibox.container.place
}

local battery_popup = awful.tooltip({
    objects = {percentage, battery},
    mode = 'outside',
    align = 'left',
    preferred_positions = {'right', 'left', 'top', 'bottom'}
})

local update = function (_, stdout)
    local battery_info = {}
    local capacities = {}
    for s in stdout:gmatch('[^\r\n]+') do
        local status, charge_str = string.match(s, '.+: (.+), (%d?%d?%d)%%')

        if status ~= nil then
            table.insert(battery_info, {
                status = status,
                charge = tonumber(charge_str)
            })
        else
            local cap_str = string.match(s, '.+:.+last full capacity (%d+)')
            table.insert(capacities, tonumber(cap_str))
        end
    end
    
    local capacity = 0
    for _, cap in ipairs(capacities) do
        capacity = capacity + cap
    end

    local charge = 0
    local status
    for i, batt in ipairs(battery_info) do
        if batt.charge >= charge then
            status = batt.status -- use most charged battery status
           -- this is arbitrary, and maybe another metric should be used
        end

        charge = charge + batt.charge * capacities[i]
    end
    charge = charge / capacity

    battery_popup.text = string.gsub(stdout, '\n$', '')
    percentage.text = math.floor(charge) .. '%'

    if status == 'Charging' or status == 'Not charging' then
        battery.imagebox.image = icons_path .. 'charger_plugged.svg'
        if math.floor(charge) <= 20 then
            battery.imagebox.image = icons_path .. 'battery-charging-20.svg'
        elseif math.floor(charge) <= 30 then
            battery.imagebox.image = icons_path .. 'battery-charging-30.svg'
        elseif math.floor(charge) <= 40 then
            battery.imagebox.image = icons_path .. 'battery-charging-40.svg'
        elseif math.floor(charge) <= 60 then
            battery.imagebox.image = icons_path .. 'battery-charging-60.svg'
        elseif math.floor(charge) <= 80 then
            battery.imagebox.image = icons_path .. 'battery-charging-80.svg'
        elseif math.floor(charge) <= 90 then
            battery.imagebox.image = icons_path .. 'battery-charging-90.svg'
        elseif math.floor(charge) <= 100 then
            battery.imagebox.image = icons_path .. 'battery-charging-100.svg'
        end
    elseif status == 'Full' then
        battery.imagebox.image = icons_path .. 'battery.svg'
    else
        if math.floor(charge) <= 20 then
            battery.imagebox.image = icons_path .. 'battery-20.svg'
        elseif math.floor(charge) <= 30 then
            battery.imagebox.image = icons_path .. 'battery-30.svg'
        elseif math.floor(charge) <= 40 then
            battery.imagebox.image = icons_path .. 'battery-40.svg'
        elseif math.floor(charge) <= 60 then
            battery.imagebox.image = icons_path .. 'battery-60.svg'
        elseif math.floor(charge) <= 80 then
            battery.imagebox.image = icons_path .. 'battery-80.svg'
        elseif math.floor(charge) <= 90 then
            battery.imagebox.image = icons_path .. 'battery-90.svg'
        elseif math.floor(charge) <= 100 then
            battery.imagebox.image = icons_path .. 'battery.svg'
        end
    end
    collectgarbage('collect')
end

watch('acpi -i', 30, update)

return wibox.widget {
    battery,
    percentage,
    spacing = dpi(5),
    layout = wibox.layout.fixed.horizontal
}
