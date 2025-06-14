local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
require("awful.autofocus")
local beautiful = require("beautiful")

-- Theme
beautiful.init(require("theme"))

-- Layout
require("layout")

-- Init all modules
require("module.notifications")
require("module.auto-start")
require("module.decorate-client")

-- require("module.exit-screen")

-- Setup all configurations
require("configuration.client")
require("configuration.tags")
_G.root.keys(require("configuration.keys.global"))

-- {{{ Screen
-- Reset wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
	beautiful.wallpaper.maximized(beautiful.wallpaper, s, beautiful.wallpapers)
end)

-- Signal function to execute when a new client appears.
_G.client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not _G.awesome.startup then
		awful.client.setslave(c)
	end

	if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Garbage collection
collectgarbage("incremental", 150, 600, 0)

gears.timer.start_new(60, function()
	-- just let it do a full collection
	collectgarbage()
	-- or else set a step size
	-- collectgarbage("step", 30000)
	return true
end)

-- Focus when url opened in default browser firefox by link
client.connect_signal("property::urgent", function(c)
	if c.class == "firefox" then
		awful.client.urgent.jumpto(false)
	end
end)

-- Focus urgent windows
-- - e.g focus active windows when they send notification or change their window -
client.connect_signal("property::urgent", function(c)
	c:jump_to()
end)

-- Enable sloppy focus, so that focus follows mouse. (e.g force focus client under mouse)
-- NOTE: if you want to hide cursor when it is not used in the future
-- use `unclutter` package to hide it if you want
--
require("module.focus-mouse")

client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

-- Make the focused window have a glowing border
_G.client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
_G.client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
