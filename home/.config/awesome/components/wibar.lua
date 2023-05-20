local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local colors = require("colors")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local wibar = {}
local bar_position = "top"

local get_widget_container = function (mywidget, bg_color)
    local container = {
        {
            mywidget,
            left = dpi(20),
            right = dpi(25),
            widget = wibox.container.margin
        },
        shape = function (cr, w, h)
                gears.shape.rectangular_tag(cr, w, h, h / 2)
            end,
        bg = bg_color,
        widget = wibox.container.background
    }

    return container
end

-- Creating topbar
wibar.init = function(target_screen)

    -- Create a wibox for screen
    local taglist_buttons = gears.table.join(
                                awful.button({}, 1,
                                             function(t) t:view_only() end),
                                awful.button({"Mod4"}, 1, function(t)
            if client.focus then client.focus:move_to_tag(t) end
        end), awful.button({}, 3, awful.tag.viewtoggle),
                                awful.button({"Mod4"}, 3, function(t)
            if client.focus then client.focus:toggle_tag(t) end
        end), awful.button({}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end), awful.button({}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end))

    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end), awful.button({}, 3, function()
            awful.menu.client_list({theme = {width = 250}})
        end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                                 awful.button({}, 5, function()
            awful.client.focus.byidx(-1)
        end))

    -- Each screen has its own tag table.
    awful.tag({"", "", "", "", "", "", "", ""},
              target_screen, awful.layout.layouts[1])

    -- Create the wibar
    target_screen.mywibar = awful.wibar({
        position = bar_position,
        screen = target_screen,
    })

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    target_screen.mylayoutbox = awful.widget.layoutbox(target_screen)
    target_screen.mylayoutbox:buttons(gears.table.join(
                                          awful.button({}, 1, function()
            awful.layout.inc(1)
        end), awful.button({}, 3, function() awful.layout.inc(-1) end),
                                          awful.button({}, 4, function()
            awful.layout.inc(1)
        end), awful.button({}, 5, function() awful.layout.inc(-1) end)))

    -- Create a taglist widget
    target_screen.mytaglist = awful.widget.taglist {
        screen = target_screen,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    -- Tasklist
    -- target_screen.mytasklist = awful.widget.tasklist {
    --     screen   = target_screen,
    --     filter   = awful.widget.tasklist.filter.currenttags,
    --     buttons  = tasklist_buttons,
    --     widget_template = {
    --             {
    --                 {
    --                     id     = 'icon_role',
    --                     forced_width = dpi(18),
    --                     forced_height = dpi(18),
    --                     widget = wibox.widget.imagebox,
    --                 },
    --                 {
    --                     left = dpi(4),
    --                     right = dpi(4),
    --                     widget = wibox.container.margin,
    --                 },
    --                 {
    --                     id     = 'text_role',
    --                     widget = wibox.widget.textbox,
    --                 },
    --                 layout = wibox.layout.fixed.horizontal,
    --             },
    --             widget = wibox.container.place,
    --     },
    -- }

    -- Add widgets to the wibar
    target_screen.mywibar:setup{
        layout = wibox.layout.align.horizontal,
        expand = "none",
        
        -- Left widgets
        {
            margins = dpi(5),
            widget = wibox.container.margin,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(8),
                target_screen.mylayoutbox,
                {
                    shape = gears.shape.rounded_rect,
                    bg = beautiful.bg_systray,
                    widget = wibox.container.background,
                    {
                        left = dpi(15),
                        right = dpi(15),
                        widget = wibox.container.margin,
                        {   
                            target_screen.mytaglist,
                            layout = wibox.layout.fixed.horizontal,
                        }
                    },
                },
            }
        },
        
        -- Center widgets
        require("widgets.clock"),

        -- Right widgets
        {
            margins = dpi(5),
            widget = wibox.container.margin,
            {
                shape_clip = true,
                shape = function (cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, dpi(10))
                end,
                bg = beautiful.bg_systray,
                widget = wibox.container.background,
                {
                    get_widget_container(wibox.widget.systray(), beautiful.systray_bg),
                    get_widget_container(require("widgets.music"), colors.bg4),
                    get_widget_container(awful.widget.keyboardlayout(), colors.bg3),
                    --get_widget_container(require("widgets.volume"), colors.grey),
                    get_widget_container(require("widgets.memory"), colors.bg2),
                    --get_widget_container(require("widgets.storage"), colors.grey),
                    --get_widget_container(require("widgets.cpu"), colors.grey),
                    get_widget_container(require("widgets.battery"), colors.bg1),
                    -- get_widget_container(target_screen.mylayoutbox, colors.bg1),

                    spacing = dpi(-15),
                    layout = wibox.layout.fixed.horizontal
                },
            },
        }
    }
end

return wibar

