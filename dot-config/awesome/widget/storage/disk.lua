local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

-- Storage Widget
local storage_text = wibox.widget.textbox()
local cmd2 = [[sh /home/developer/.config/awesome/scripts/storage.sh]]
local storage_listener

awesome.connect_signal("exit", function()
	if storage_listener then
		awesome.kill(storage_listener, awesome.unix_signal.SIGTERM)
	end
end)

local update_storage = function()
	storage_listener = awful.spawn.with_line_callback(cmd2, {
		stdout = function(line)
			storage_text:set_markup(string.format("%s ", line))
		end,
		stderr = function(line)
			naughty.notify({ text = "ERR:" .. line })
		end,
	})
end

-- Update every 5 minutes
gears.timer.start_new(300, update_storage)

local storage_widget = {
	layout = wibox.layout.align.horizontal,
	storage_text,
}

return storage_widget
