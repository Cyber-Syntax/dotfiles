local filesystem = require("gears.filesystem")
local awful = require("awful")

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require("beautiful").xresources.apply_dpi
local get_dpi = require("beautiful").xresources.get_dpi
local rofi_command = "env /usr/bin/rofi -dpi "
	.. get_dpi()
	.. " -width "
	.. with_dpi(400)
	.. " -show drun -theme "
	.. filesystem.get_configuration_dir()
	--FIX: style works but not able to open any app..
	.. "/configuration/style-10.rasi -run-command \"/bin/bash -c -i 'shopt -s expand_aliases; {cmd}'\""

-- Run once apps
local naughty = require("naughty")

awful.spawn.easy_async_with_shell(
	"~/.config/awesome/scripts/autostart.sh",
	function(stdout, stderr, exitreason, exitcode)
		if exitcode ~= 0 then
			naughty.notify({
				preset = naughty.config.presets.critical,
				title = "Autostart Script Error",
				text = stderr or "Unknown error",
			})
		else
			-- Optionally process stdout if needed
			print("Autostart completed successfully:", stdout)
		end
	end
)
--
--NOTE: async more better then spawn with shell?
-- awful.spawn.with_shell("~/.config/awesome/scripts/autostart.sh")

--
return {
	-- List of apps to start by default on some actions
	default = {
		terminal = "kitty",
		files = "pcmanfm",
		music = "spotify",
		lock = "i3lock",
		browser = "firefox",
		rofi = rofi_command,
		screenshot = "flameshot screen -p ~/Pictures",
		region_screenshot = "flameshot gui -p ~/Pictures",
		delayed_screenshot = "flameshot screen -p ~/Pictures -d 5000",
		freetube = "freetube",
		note = "obsidian",
		game = rofi_command,
		-- music = rofi_command,
	},

	-- List of apps to start once on start-up
	run_on_start_up = {
		-- Add applications that need to be killed between reloads
		-- to avoid multipled instances, inside the awspawn script
		-- "~/.config/awesome/configuration/awspawn", -- Spawn "dirty" apps that can linger between sessions
	},
}
