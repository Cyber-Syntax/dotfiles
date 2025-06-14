local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local capi = { button = _G.button }
local clickable_container = require("widget.material.clickable-container")

-- Cache frequently used values
local dpi = beautiful.xresources.apply_dpi
local close_icon = os.getenv("HOME") .. "/.config/awesome/theme/icons/tag-list/tag/close.png"
local cached_widgets = setmetatable({}, { __mode = "k" }) -- Weak table for automatic cleanup

local function create_buttons(buttons, object)
	if not buttons then
		return
	end

	local btns = {}
	for _, b in ipairs(buttons) do
		local btn = capi.button({
			modifiers = b.modifiers,
			button = b.button,
		})
		btn:connect_signal("press", function()
			b:emit_signal("press", object)
		end)
		btn:connect_signal("release", function()
			b:emit_signal("release", object)
		end)
		btns[#btns + 1] = btn
	end
	return btns
end

local function list_update(w, buttons, label, data, objects)
	w:reset()

	-- Reuse existing widgets where possible
	for i, o in ipairs(objects) do
		local cache = data[o] or cached_widgets[o]
		local text, bg, bg_image, icon, args = label(o, cache and cache.tb or nil)

		if not cache then
			cache = {
				ib = wibox.widget.imagebox(),
				tb = wibox.widget.textbox(),
				bgb = wibox.container.background(),
				tt = awful.tooltip({
					mode = "outside",
					align = "bottom",
					delay_show = 1,
				}),
			}
			cached_widgets[o] = cache

			-- Close button setup
			local cb = clickable_container(wibox.container.margin(wibox.widget.imagebox(close_icon), 4, 4, 4, 4))
			cb.shape = gears.shape.circle
			cb:buttons(gears.table.join(awful.button({}, 1, nil, function()
				o:kill()
			end)))

			-- Layout construction
			local layout = wibox.layout.fixed.horizontal()
			layout:add(wibox.container.margin(cache.ib, dpi(4)))
			layout:add(wibox.container.margin(cache.tb, dpi(4)))
			cache.bgb:set_widget(wibox.widget({
				layout,
				wibox.container.margin(cb, dpi(4)),
				layout = wibox.layout.align.horizontal,
			}))
			cache.bgb:buttons(create_buttons(buttons, o))
		end

		-- Update content only if changed
		if text then
			local truncated = text:gsub(">(.-)<", function(t)
				return #t > 24 and ">" .. t:sub(1, 21) .. "...<" or ">" .. t .. "<"
			end)
			cache.tb:set_markup_silently(truncated)
			cache.tt:set_text(text:match(">(.-)<") or text)
		end

		cache.bgb:set_bg(bg)
		cache.ib.image = icon or nil
		w:add(cache.bgb)
	end

	-- Cleanup unused clients
	for o, _ in pairs(cached_widgets) do
		if not o.valid then
			cached_widgets[o] = nil
		end
	end
end

-- Simplified tasklist buttons
local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c.minimized = false
			if not c:isvisible() then
				c.first_tag:view_only()
			end
			client.focus = c
			c:raise()
		end
	end),
	awful.button({}, 2, function(c)
		c:kill()
	end)
)

local TaskList = function(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		update_function = list_update,
		layout = wibox.layout.fixed.horizontal(),
	})
end

return TaskList
