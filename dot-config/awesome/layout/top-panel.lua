local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local TaskList = require("widget.task-list")
local TagList = require("widget.tag-list")
local gears = require("gears")
local clickable_container = require("widget.material.clickable-container")
local mat_icon_button = require("widget.material.icon-button")
local mat_icon = require("widget.material.icon")
local dpi = require("beautiful").xresources.apply_dpi
local icons = require("theme.icons")
local zen_cpu_temp = require("widget.temp.zen")
local gpu_temp = require("widget.temp.gpu")
local ram_meter = require("widget.ram.ram-meter")
local storage_widget = require("widget.storage.disk")
local player = require("widget.mediaplayer.player")
-- local mpris2 = require("awesome-wm-widgets.mpris-widget")
-- -- local spotify = require("widget.mediaplayer.spotify")
local volume_widget = require("widget.volume-widget.volume")

-- Titus - Horizontal Tray
local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(20)
systray.forced_height = 20

-- Clock / Calendar 24h format
-- local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 9">%d.%m.%Y\n     %H:%M</span>')
-- Clock / Calendar 12AM/PM fornat
local textclock = wibox.widget.textclock('<span font="Noto Sans 12">%I:%M %p</span>')
-- textclock.forced_height = 36

-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
	screen = s,
	start_sunday = false,
	week_numbers = true,
})
month_calendar:attach(textclock)

local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(9), dpi(8))

local add_button = mat_icon_button(mat_icon(icons.plus, dpi(24)))
add_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
	awful.spawn(awful.screen.focused().selected_tag.defaultApp, {
		tag = _G.mouse.screen.selected_tag,
		placement = awful.placement.bottom_right,
	})
end)))

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
	local layoutBox = clickable_container(awful.widget.layoutbox(s))
	layoutBox:buttons(awful.util.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	return layoutBox
end

local TopPanel = function(s)
	local panel = wibox({
		ontop = true,
		screen = s,
		height = dpi(32),
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.background.hue_800,
		fg = beautiful.fg_normal,
		struts = {
			top = dpi(32),
		},
	})

	panel:struts({
		top = dpi(32),
	})

	tbox_separator = wibox.widget.textbox(" | ")
	panel:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			-- Create a taglist widget
			TagList(s),
			TaskList(s),
			add_button,
		},
		nil,
		{
			storage_widget,
			tbox_separator,
			player,
			tbox_separator,
			ram_meter,
			tbox_separator,
			zen_cpu_temp,
			tbox_separator,
			gpu_temp,
			tbox_separator,
			layout = wibox.layout.fixed.horizontal,
			wibox.container.margin(systray, dpi(3), dpi(3), dpi(6), dpi(3)),
			LayoutBox(s),
			-- volume_widget,
			volume_widget({
				font = "Noto Sans 11",
				icon_dir = "/home/developer/.config/awesome/widget/volume-widget/icons/",
			}),
			clock_widget,
		},
	})

	return panel
end

return TopPanel

-- mpris2({
-- 	font = "Noto Sans 9",
-- 	path_to_icons = "/home/developer/Pictures/icons",
-- 	play_icon = "/home/developer/.config/awesome/widget/mediaplayer/icons/play.svg",
-- 	pause_icon = "/home/developer/.config/awesome/widget/mediaplayer/icons/play.svg",
-- 	stop_icon = "/home/developer/.config/awesome/widget/mediaplayer/icons/play.svg",
-- 	library_icon = "/home/developer/.config/awesome/widget/mediaplayer/icons/play.svg",
-- }),
--FIX: sp.sh: line 84: `sp-dbus': not a valid identifier
-- spotify({
-- 	font = "Noto Sans 9",
-- 	play_icon = "/home/developer/.config/awesome/widget/mediaplayer/icons/play.svg",
-- 	pause_icon = "/home/developer/.config/awesome/widget/mediaplayer/icons/pause.svg",
-- 	-- sp_bin = gears.filesystem.get_configuration_dir() .. "scripts/sp.sh",
-- 	sp_bin = "/home/developer/.config/awesome/scripts/sp.sh",
-- }),
