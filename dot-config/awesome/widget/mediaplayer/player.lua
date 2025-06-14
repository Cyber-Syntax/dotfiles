local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local spotify_text = wibox.widget.textbox()
local last_meta = ""
local update_cooldown = false

-- Optimized metadata fetch with single command
local function get_spotify_info()
	if update_cooldown then
		return
	end
	update_cooldown = true

	awful.spawn.easy_async_with_shell(
		[[
        playerctl metadata -a --format '{{status}}||{{artist}} - {{title}}' 2>/dev/null || echo "No player"
    ]],
		function(out)
			local status, meta = out:match("^(%a+)||(.+)$")
			meta = meta and meta:gsub("^%s*(.-)%s*$", "%1") or "No media playing"

			if status == "Paused" then
				meta = " " .. meta
			end

			if meta ~= last_meta then
				spotify_text:set_markup(meta)
				last_meta = meta
			end
			update_cooldown = false
		end
	)
end

-- Throttled update mechanism
gears.timer({
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = function()
		if not update_cooldown then
			get_spotify_info()
		end
	end,
})

-- Debounced button actions
local function safe_action(cmd)
	if not update_cooldown then
		awful.spawn.easy_async_with_shell(cmd, function()
			gears.timer.delayed_call(get_spotify_info)
		end)
		update_cooldown = true
		gears.timer.start_new(0.5, function()
			update_cooldown = false
		end)
	end
end

spotify_text:buttons(gears.table.join(
	awful.button({}, 1, function()
		safe_action("playerctl play-pause")
	end),
	awful.button({}, 3, function()
		safe_action("playerctl next")
	end)
))

return wibox.widget({ spotify_text, layout = wibox.layout.align.horizontal })
