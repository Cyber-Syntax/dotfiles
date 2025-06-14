local awful = require("awful")
local gears = require("gears")
local client_keys = require("configuration.client.keys")
local client_buttons = require("configuration.client.buttons")

awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			keys = client_keys,
			buttons = client_buttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_offscreen,
			floating = false,
			maximized = false,
			above = false,
			below = false,
			ontop = false,
			sticky = false,
			maximized_horizontal = false,
			maximized_vertical = false,
		},
	},
	{
		rule_any = {
			class = {
				"firefox",
				"browser",
				"brave",
				"chromium",
			},
		},
		properties = { screen = 1, tag = "1" },
	},
	-- SuperProductivity: Assign to Tag 5 on Screen 1
	{
		rule = { class = "superProductivity" },
		properties = {
			screen = 1,
			tag = "5", -- Use tag index (assuming tag 5 exists)
			switch_to_tags = true,
			-- urgency = "critical",
		},
	},
	-- KeePassXC: Floating + Centered
	{
		rule = { class = "KeePassXC" },
		properties = {
			floating = true,
			placement = awful.placement.centered,
		},
	},
	-- {
	-- 	rule_any = {
	-- 		class = {
	-- 			"keepassxc",
	-- 			"KeePassXC",
	-- 		},
	-- 	},
	-- 	properties = {
	-- 		screen = 1,
	-- 		floating = true,
	-- 		focus = awful.client.focus.filter,
	-- 		raise = true,
	-- 		keys = client_keys,
	-- 		buttons = client_buttons,
	-- 		screen = awful.screen.preferred,
	-- 		placement = awful.placement.centered,
	-- 		titlebars_enabled = false,
	-- 		ontop = true,
	-- 		width = 640,
	-- 		height = 480,
	-- 	},
	-- },
}
