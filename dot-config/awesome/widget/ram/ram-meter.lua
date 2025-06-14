local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
-- Ram Widget
local ram_text = wibox.widget.textbox()

-- Update function
local update_ram = function()
	awful.spawn.easy_async_with_shell("free -h | awk '/Mem:/ {print $2, $3}'", function(stdout)
		local total, used = stdout:match("(%S+)%s+(%S+)")
		if total and used then
			ram_text:set_markup_silently("󰘚 " .. used .. "/" .. total .. " ")
		end
	end)
end

-- Update every second
gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_ram,
})

local ram_widget = wibox.widget({
	layout = wibox.layout.flex.horizontal,
	ram_text,
})

return ram_widget
