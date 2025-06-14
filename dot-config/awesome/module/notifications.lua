local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

-- -- Temporary test notification (add to your config)
-- gears.timer({
-- 	timeout = 5,
-- 	call_now = true,
-- 	autostart = true,
-- 	callback = function()
-- 		naughty.notify({ title = "Visibility Test", text = "Can you see me?" })
-- 	end,
-- })
-- Add this at the TOP of your notifications config
naughty.config.defaults.layer = "top" -- Force notifications to topmost layer
naughty.config.defaults.ontop = true -- Ensure on-top (redundant but explicit)

-- Then modify your existing configuration:
naughty.config.defaults = {
	-- Your existing settings --
	timeout = 5,
	screen = 1,
	position = "top_right",
	margin = dpi(16),
	ontop = true, -- Already present, keep it
	layer = "top", -- Add this line (critical for fullscreen visibility)
	font = "Noto Sans 10",
	icon = nil,
	icon_size = dpi(32),
	shape = gears.shape.rounded_rect,
	border_width = 0,
	hover_timeout = nil,
}
-- Error handling
if _G.awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = _G.awesome.startup_errors,
	})
end

do
	local in_error = false
	_G.awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

function log_this(title, txt)
	naughty.notify({
		title = "log: " .. title,
		text = txt,
	})
end
