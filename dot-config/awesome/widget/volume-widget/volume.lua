-- volume-widget.lua
local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")

local volume = {}
local ICON_DIR = os.getenv("HOME") .. "/.config/awesome/widget/volume-widget/icons/"

-- Combined command to get both volume and mute status
local GET_STATUS_CMD = [[
    sh -c "
    vol_output=\"$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null)\" || true
    mute_output=\"$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null)\" || true
    awk -F '[/%]' '/Volume:/ {print \$2}' <<< \"$vol_output\" | head -n1 | tr -d ' '
    awk '{print \$2}' <<< \"$mute_output\"
"]]

local INC_VOLUME_CMD = "pactl set-sink-volume @DEFAULT_SINK@ +5%"
local DEC_VOLUME_CMD = "pactl set-sink-volume @DEFAULT_SINK@ -5%"
local TOG_VOLUME_CMD = "pactl set-sink-mute @DEFAULT_SINK@ toggle"

-- Widget Components
local function create_widget(args)
	args = args or {}
	local font = args.font or beautiful.font
	local icon_dir = args.icon_dir or ICON_DIR

	return wibox.widget({
		{
			{
				id = "icon",
				resize = true,
				forced_width = 24,
				forced_height = 24,
				widget = wibox.widget.imagebox,
			},
			valign = "center",
			layout = wibox.container.place,
		},
		{
			id = "txt",
			font = font,
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.horizontal,
		spacing = 8,
		set_volume_level = function(self, vol)
			-- Direct numeric conversion
			local volume_level = tonumber(vol) or 0
			self:get_children_by_id("txt")[1]:set_text(volume_level .. "%") -- Determine icon based on ACTUAL volume and mute state

			local icon_name = "audio-volume-high"
			if self.is_muted then
				icon_name = "audio-volume-muted"
			else
				if volume_level == 0 then
					icon_name = "audio-volume-muted"
				elseif volume_level < 33 then
					icon_name = "audio-volume-low"
				elseif volume_level < 66 then
					icon_name = "audio-volume-medium"
				end
			end

			-- Verify icon path and extension
			local icon_path = icon_dir .. icon_name .. ".svg"
			-- print("Setting icon:", icon_path)  -- DEBUG: Check icon path
			self:get_children_by_id("icon")[1]:set_image(icon_path)
		end,
		mute = function(self)
			self.is_muted = true
			self:set_volume_level(0) -- Force update
		end,
		unmute = function(self)
			self.is_muted = false
		end,
	})
end

-- Device Management
local function parse_devices(pactl_output)
	local devices = {}
	local current_device = {}

	for line in pactl_output:gmatch("[^\r\n]+") do
		if line:match("Sink #") then
			current_device = { properties = {} }
		elseif line:match("Name: ") then
			current_device.name = line:match("Name: (.+)")
		elseif line:match("Description: ") then
			current_device.description = line:match("Description: (.+)") or current_device.name
			table.insert(devices, current_device)
		end
	end
	return devices
end

-- Popup Menu
local popup = awful.popup({
	bg = beautiful.bg_normal,
	fg = beautiful.fg_normal,
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
	border_width = 1,
	border_color = beautiful.bg_focus,
	maximum_width = 300,
	offset = { y = 5 },
	widget = wibox.widget({
		layout = wibox.layout.fixed.vertical,
		spacing = 8,
	}),
})

local function build_device_row(device)
	local row = wibox.widget({
		{
			{
				text = device.description,
				widget = wibox.widget.textbox,
			},
			margins = 8,
			layout = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		widget = wibox.container.background,
	})

	row:connect_signal("button::press", function()
		spawn("pactl set-default-sink " .. device.name, false)
		popup.visible = false
	end)

	return row
end

local function rebuild_menu()
	spawn.easy_async("pactl list sinks", function(stdout)
		popup.widget:reset()
		popup.widget:add(wibox.widget({
			text = "Output Devices",
			align = "center",
			widget = wibox.widget.textbox,
		}))

		local sinks = parse_devices(stdout)
		for _, sink in ipairs(sinks) do
			popup.widget:add(build_device_row(sink))
		end
	end)
end

-- Optimized Volume Control
function volume:update()
	spawn.easy_async(GET_STATUS_CMD, function(stdout)
		local vol, mute = stdout:match("(.-)\n(.*)")
		vol = vol and vol:gsub("%s+", "") or "0"
		mute = mute and mute:gsub("%s+", "") or "no"

		self.widget:set_volume_level(vol)
		if mute == "yes" then
			self.widget:mute()
		else
			self.widget:unmute()
		end
	end)
end

function volume:inc()
	awful.spawn.easy_async_with_shell(INC_VOLUME_CMD, function(_, _, _, exit_code)
		if exit_code == 0 then
			self:update()
		end
	end)
end

function volume:dec()
	awful.spawn.easy_async_with_shell(DEC_VOLUME_CMD, function(_, _, _, exit_code)
		if exit_code == 0 then
			self:update()
		end
	end)
end
function volume:toggle()
	awful.spawn.easy_async_with_shell(TOG_VOLUME_CMD, function(_, _, _, exit_code)
		if exit_code == 0 then
			self:update()
		end
	end)
end

-- function volume:dec()
-- 	spawn(DEC_VOLUME_CMD, false)
-- 	self:update() -- Force immediate update
-- end
--
-- function volume:toggle()
-- 	spawn(TOG_VOLUME_CMD, false)
-- 	self:update() -- Force immediate update
-- end
--
-- Initialize Widget (optimized)
function volume.new(args)
	local instance = setmetatable({}, { __index = volume })
	instance.widget = create_widget(args)

	-- Button controls (keep your existing implementation)
	instance.widget:buttons(gears.table.join(
		awful.button({}, 1, function()
			instance:toggle()
		end),
		awful.button({}, 3, function()
			if popup.visible then
				popup.visible = false
			else
				rebuild_menu()
				popup:move_next_to(mouse.current_widget_geometry)
			end
		end),
		awful.button({}, 4, function()
			instance:inc()
		end),
		awful.button({}, 5, function()
			instance:dec()
		end)
	))

	-- Single optimized watch with increased interval
	watch(GET_STATUS_CMD, 2, function(_, stdout)
		local vol, mute = stdout:match("(.-)\n(.*)")
		vol = vol and vol:gsub("%s+", "") or "0"
		mute = mute and mute:gsub("%s+", "") or "no"

		instance.widget:set_volume_level(vol)
		if mute == "yes" then
			instance.widget:mute()
		else
			instance.widget:unmute()
		end
	end, instance.widget)

	return instance.widget
end

return setmetatable(volume, {
	__call = function(_, ...)
		return volume.new(...)
	end,
})
