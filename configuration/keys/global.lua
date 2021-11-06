local awful = require("awful")
local beautiful = require("beautiful")

require("awful.autofocus")

local hotkeys_popup = require("awful.hotkeys_popup").widget

local super = require("configuration.keys.mod").mod_key
local alt = require("configuration.keys.mod").alt_key
local apps = require("configuration.apps")

local utils = require("configuration.keys.utils")
local spawn = utils.spawn
local info = utils.info

-- Key bindings
local global_keys = awful.util.table.join(

	awful.key({ super, "Shift" }, "w", spawn(apps.default.rofi_window, false), info("open window search", "launcher")),

	-- Hotkeys
	awful.key({ super }, "F1", hotkeys_popup.show_help, info("show help", "awesome")),
	awful.key({ super, "Control" }, "r", awesome.restart, info("reload awesome", "awesome")),

	awful.key({ super, "Control", "Shift" }, "q", awesome.quit, info("quit awesome", "awesome")),

	awful.key({ alt, "Shift" }, "l", function()
		awful.tag.incmwfact(0.05)
	end, info(
		"increase master width factor",
		"layout"
	)),
	awful.key({ alt, "Shift" }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, info(
		"decrease master width factor",
		"layout"
	)),
	awful.key({ super, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, info(
		"increase the number of master clients",
		"layout"
	)),
	awful.key({ super, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, info(
		"decrease the number of master clients",
		"layout"
	)),
	awful.key({ super, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, info(
		"increase the number of columns",
		"layout"
	)),
	awful.key({ super, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, info(
		"decrease the number of columns",
		"layout"
	)),
	awful.key({ super }, "space", function()
		awful.layout.inc(1)
	end, info("select next layout", "layout")),
	awful.key({ super, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, info(
		"select previous layout",
		"layout"
	)),
	awful.key({ super }, "o", function()
		awful.tag.incgap(1)
	end, info("increase gap", "layout")),
	awful.key({ super, "Shift" }, "o", function()
		awful.tag.incgap(-1)
	end, info("decrease gap", "layout")),
	awful.key({ super }, "w", awful.tag.viewprev, info("view previous tag", "tag")),
	awful.key({ super }, "s", awful.tag.viewnext, info("view next tag", "tag")),
	awful.key({ super }, "Escape", awful.tag.history.restore, info("alternate between current and previous tag", "tag")),
	awful.key({ super, "Control" }, "w", function()
		-- tag_view_nonempty(-1)
		local focused = awful.screen.focused()
		for i = 1, #focused.tags do
			awful.tag.viewidx(-1, focused)
			if #focused.clients > 0 then
				return
			end
		end
	end, info(
		"view previous non-empty tag",
		"tag"
	)),
	awful.key({ super, "Control" }, "s", function()
		-- tag_view_nonempty(1)
		local focused = awful.screen.focused()
		for i = 1, #focused.tags do
			awful.tag.viewidx(1, focused)
			if #focused.clients > 0 then
				return
			end
		end
	end, info(
		"view next non-empty tag",
		"tag"
	)),
	awful.key({ super, "Shift" }, "F1", function()
		awful.screen.focus_relative(-1)
	end, info(
		"focus the previous screen",
		"screen"
	)),
	awful.key({ super, "Shift" }, "F2", function()
		awful.screen.focus_relative(1)
	end, info(
		"focus the next screen",
		"screen"
	)),
	awful.key({ super, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate")
			c:raise()
		end
	end, info(
		"restore minimized",
		"screen"
	)),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn("light -A 10", false)
		awesome.emit_signal("widget::brightness")
		awesome.emit_signal("module::brightness_osd:show", true)
	end, info(
		"increase brightness by 10%",
		"hotkeys"
	)),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn("light -U 10", false)
		awesome.emit_signal("widget::brightness")
		awesome.emit_signal("module::brightness_osd:show", true)
	end, info(
		"decrease brightness by 10%",
		"hotkeys"
	)),
	-- ALSA volume control
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("amixer -D pulse sset Master 5%+", false)
		awesome.emit_signal("widget::volume")
		awesome.emit_signal("module::volume_osd:show", true)
	end, info(
		"increase volume up by 5%",
		"hotkeys"
	)),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("amixer -D pulse sset Master 5%-", false)
		awesome.emit_signal("widget::volume")
		awesome.emit_signal("module::volume_osd:show", true)
	end, info(
		"decrease volume up by 5%",
		"hotkeys"
	)),
	awful.key({}, "XF86AudioMute", spawn("amixer -D pulse set Master 1+ toggle", false), info("toggle mute", "hotkeys")),
	awful.key({}, "XF86AudioNext", spawn("mpc next", false), info("next music", "hotkeys")),
	awful.key({}, "XF86AudioPrev", spawn("mpc prev", false), info("previous music", "hotkeys")),
	awful.key({}, "XF86AudioPlay", spawn("mpc toggle", false), info("play/pause music", "hotkeys")),
	awful.key({}, "XF86AudioMicMute", spawn("amixer set Capture toggle", false), info("mute microphone", "hotkeys")),
	awful.key({}, "XF86PowerOff", function()
		awesome.emit_signal("module::exit_screen:show")
	end, info(
		"toggle exit screen",
		"hotkeys"
	)),
	awful.key({}, "XF86Display", function()
		awful.spawn.single_instance("arandr", false)
	end, info(
		"arandr",
		"hotkeys"
	)),
	awful.key({ super, "Ctrl" }, "q", function()
		awesome.emit_signal("module::exit_screen:show")
	end, info(
		"toggle exit screen",
		"hotkeys"
	)),
	awful.key({ super }, "`", function()
		local focused = awful.screen.focused()
		local tag = focused.tags[9]
		if tag then
			tag:view_only()
		end
	end, info(
		"dropdown application",
		"launcher"
	)),
	awful.key({}, "Print", function()
		awful.spawn.easy_async_with_shell(apps.utils.full_screenshot, function() end)
	end, info(
		"fullscreen screenshot",
		"Utility"
	)),
	awful.key({ super, "Shift" }, "s", function()
		awful.spawn.easy_async_with_shell(apps.utils.area_screenshot, function() end)
	end, info(
		"area/selected screenshot",
		"Utility"
	)),
	awful.key({ super }, "x", function()
		awesome.emit_signal("widget::blur:toggle")
	end, info(
		"toggle blur effects",
		"Utility"
	)),
	awful.key({ super }, "]", function()
		awesome.emit_signal("widget::blur:increase")
	end, info(
		"increase blur effect by 10%",
		"Utility"
	)),
	awful.key({ super }, "[", function()
		awesome.emit_signal("widget::blur:decrease")
	end, info(
		"decrease blur effect by 10%",
		"Utility"
	)),
	awful.key({ super }, "t", function()
		awesome.emit_signal("widget::blue_light:toggle")
	end, info(
		"toggle redshift filter",
		"Utility"
	)),
	awful.key({ "Control" }, "Escape", function()
		if screen.primary.systray then
			if not screen.primary.tray_toggler then
				local systray = screen.primary.systray
				systray.visible = not systray.visible
			else
				awesome.emit_signal("widget::systray:toggle")
			end
		end
	end, info(
		"toggle systray visibility",
		"Utility"
	)),
	-- awful.key(
	-- 	{modkey},
	-- 	'l',
	-- 	function()
	-- 		awful.spawn(apps.default.lock, false)
	-- 	end,
	-- 	{description = 'lock the screen', group = 'Utility'}
	-- ),
	awful.key(
		{ super },
		"Return",
		spawn(apps.default.terminal .. " -e tmux"),
		info("open default terminal", "launcher")
	),
	awful.key({ super, "Shift" }, "e", spawn(apps.default.file_manager), info("open default file manager", "launcher")),
	awful.key({ super, "Shift" }, "f", spawn(apps.default.web_browser), info("open default web browser", "launcher")),
	awful.key(
		{ "Control", "Shift" },
		"Escape",
		spawn(apps.default.terminal .. " " .. "htop"),
		info("open system monitor", "launcher")
	),
	awful.key({ super }, "e", function()
		local focused = awful.screen.focused()

		if focused.control_center then
			focused.control_center:hide_dashboard()
			focused.control_center.opened = false
		end
		if focused.info_center then
			focused.info_center:hide_dashboard()
			focused.info_center.opened = false
		end
		awful.spawn(apps.default.rofi_appmenu, false)
	end, info(
		"open application drawer",
		"launcher"
	)),
	awful.key({}, "XF86Launch1", function()
		local focused = awful.screen.focused()

		if focused.control_center then
			focused.control_center:hide_dashboard()
			focused.control_center.opened = false
		end
		if focused.info_center then
			focused.info_center:hide_dashboard()
			focused.info_center.opened = false
		end
		awful.spawn(apps.default.rofi_appmenu, false)
	end, info(
		"open application drawer",
		"launcher"
	)),
	awful.key({ super, "Shift" }, "x", spawn(apps.default.rofi_global, false), info("open global search", "launcher")),
	awful.key({ super }, "r", function()
		local focused = awful.screen.focused()
		if focused.info_center and focused.info_center.visible then
			focused.info_center:toggle()
		end
		focused.control_center:toggle()
	end, info(
		"open control center",
		"launcher"
	)),
	awful.key({ super, "Shift" }, "r", function()
		local focused = awful.screen.focused()
		if focused.control_center and focused.control_center.visible then
			focused.control_center:toggle()
		end
		focused.info_center:toggle()
	end, info(
		"open info center",
		"launcher"
	))
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	-- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
	local descr_view, descr_toggle, descr_move, descr_toggle_focus
	if i == 1 or i == 9 then
		descr_view = info("view tag #", "tag")
		descr_toggle = info("toggle tag #", "tag")
		descr_move = info("move focused client to tag #", "tag")
		descr_toggle_focus = info("toggle focused client on tag #", "tag")
	end
	global_keys = awful.util.table.join(
		global_keys,
		-- View tag only.
		awful.key({ super }, "#" .. i + 9, function()
			local focused = awful.screen.focused()
			local tag = focused.tags[i]
			if tag then
				tag:view_only()
			end
		end, descr_view),
		-- Toggle tag display.
		awful.key({ super, "Control" }, "#" .. i + 9, function()
			local focused = awful.screen.focused()
			local tag = focused.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, descr_toggle),
		-- Move client to tag.
		awful.key({ super, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, descr_move),
		-- Toggle tag on focused client.
		awful.key({ super, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, descr_toggle_focus)
	)
end

return global_keys
