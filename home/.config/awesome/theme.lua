local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")

local theme = {}

-- Theme font
theme.font_name = "Awesome Nerd"

-- Theme color
local colors = require("colors")

local themes_path = gears.filesystem.get_themes_dir()
local config_path = gears.filesystem.get_configuration_dir()

theme.icons_path = config_path .. "icons/"

theme.wallpaper = config_path .. "images/wallpaper.jpg"

theme.font = theme.font_name .. " 11"

-- Background
theme.bg_normal = colors.background
theme.bg_dark = colors.background
theme.bg_focus = colors.background
theme.bg_urgent = colors.background
theme.bg_minimize = colors.background
theme.bg_systray = colors.background

-- Foreground
theme.fg_normal = colors.white
theme.fg_focus = colors.accent
theme.fg_urgent = colors.red
theme.fg_minimize = colors.blue

-- Borders/Gaps
theme.useless_gap = dpi(3)
theme.screen_margin = theme.useless_gap
theme.border_width = dpi(1)
theme.border_radius = dpi(5)
theme.border_focus = colors.accent
theme.border_marked = colors.red
theme.border_normal = colors.background

-- Tooltips
theme.tooltip_font = theme.font

-- Notification
theme.notification_width = dpi(350)
theme.notification_margin = dpi(15)
theme.notification_border_width = dpi(0)
theme.notification_icon_size = dpi(48)
theme.notification_fg = colors.white
theme.notification_bg = colors.grey
theme.notification_bg_critical = colors.red
theme.notification_font = theme.font
theme.notification_shape = gears.shape.rounded_rect

-- Hotkeys
theme.hotkeys_font = theme.font_name .. " Bold 10"
theme.hotkeys_bg = colors.background
theme.hotkeys_border_width = dpi(0)
theme.hotkeys_modifiers_fg = colors.yellow
theme.hotkeys_label_fg = colors.white
theme.hotkeys_label_bg = colors.blue
theme.hotkeys_group_margin = dpi(40)

-- Clickable container
theme.clickable_container_padding_x = dpi(10)
theme.clickable_container_padding_y = dpi(7)

-- Wibar
theme.wibar_height = dpi(34)

-- Taglist
theme.taglist_font = theme.font_name .. " 20"
theme.taglist_spacing = dpi(5)
theme.taglist_fg_focus = colors.accent
theme.taglist_fg_occupied = colors.white
theme.taglist_fg_empty = colors.white .. "33"
theme.taglist_shape = function (cr, w, h) 
        gears.shape.transform(gears.shape.rectangle) : 
        translate(0, theme.wibar_height * 0.6) :    
        scale(1, 0.2) (cr, w, h)
    end
theme.taglist_bg_focus = colors.grey

-- Tasklist
theme.tasklist_plain_task_name = true
theme.tasklist_font = theme.font
theme.tasklist_font_focus = theme.font_name .. " Bold 10"

-- Calendar
theme.calendar_spacing = dpi(10)
theme.calendar_shape = gears.shape.rounded_rect
theme.calendar_focus_fg_color = colors.accent

-- System tray
theme.bg_systray = colors.grey
theme.systray_icon_spacing = dpi(5)

-- Battery
theme.battery_fg_normal = theme.fg_normal
theme.battery_fg_urgent = theme.fg_urgent

-- Exit screen
theme.exit_screen_bg = colors.background .. "F0"
theme.exit_screen_caption_spacing = 10

-- Layout
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

return theme
