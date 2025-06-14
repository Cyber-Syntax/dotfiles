local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

-- GPU Temperature Widget
local gpu_temp_text = wibox.widget.textbox()
local gpu_memory_text = wibox.widget.textbox()

-- Update function
local update_gpu_temp_and_memory = function()
	awful.spawn.easy_async_with_shell(
		"nvidia-smi --query-gpu=temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits",
		function(stdout)
			local temp, memory_used, memory_total = stdout:match("(%d+),%s*(%d+),%s*(%d+)")
			if temp and memory_used and memory_total then
				gpu_temp_text:set_markup_silently("  " .. temp .. "°C ")
				gpu_memory_text:set_markup_silently(memory_used .. "/" .. memory_total .. "MB")
			end
		end
	)
end

-- Update every second
gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_gpu_temp_and_memory,
})

local gpu_temp_widget = wibox.widget({
	layout = wibox.layout.align.horizontal,
	gpu_temp_text,
	wibox.container.margin(gpu_memory_text, dpi(5), 0, 0, 0), -- Adjust margin as needed
})

return gpu_temp_widget
