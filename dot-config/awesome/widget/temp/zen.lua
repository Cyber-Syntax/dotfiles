local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- Zen CPU Temperature Widget
local zen_cpu_temp_text = wibox.widget.textbox()

-- Update function
local update_cpu_temp = function()
	awful.spawn.easy_async_with_shell("sensors | grep 'Tdie:' | awk '{print $2}'", function(stdout)
		local temp = stdout:match("(%d+)")
		if temp then
			zen_cpu_temp_text:set_markup_silently(" " .. temp .. "°C ")
		end
	end)
end

-- Update every second
gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_cpu_temp,
})

local zen_cpu_temp_widget = wibox.widget({
	layout = wibox.layout.flex.horizontal,
	zen_cpu_temp_text,
})

return zen_cpu_temp_widget
