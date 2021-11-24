local awful = require("awful")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
require("awful.autofocus")
local modkey = require("configuration.keys.mod").mod_key
local altkey = require("configuration.keys.mod").alt_key

local xrandr = require("xrandr")

local client_keys = awful.util.table.join(
	-- move client to other screen
	awful.key(
		{modkey, "Shift"}, "p",
		function(c)
			-- screen[1]:swap(screen[2])
			-- xrandr.xrandr()
		end,
		{description = "swap screen", group = "screen"}
	),

	awful.key(
		{modkey, "Shift"}, "o",
		function(c)
			c:move_to_screen()
		end,
		{description = "move client to other screen", group = "client"}
	),

	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, {
		description = "toggle fullscreen",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),

	-- move by direction
	-- awful.key({ modkey }, "h", function()
	-- 	awful.client.focus.global_bydirection("left")
	-- end),
	-- awful.key({ modkey }, "j", function()
	-- 	awful.client.focus.global_bydirection("down")
	-- end),
	-- awful.key({ modkey }, "k", function()
	-- 	awful.client.focus.global_bydirection("up")
	-- end),
	-- awful.key({ modkey }, "l", function()
	-- 	awful.client.focus.global_bydirection("right")
	-- end),

	-- swap by direction
	awful.key({ modkey, "Shift" }, "h", function()
		awful.client.swap.global_bydirection("left")
	end),
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.global_bydirection("down")
	end),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.global_bydirection("up")
	end),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.client.swap.global_bydirection("right")
	end),

	-- move by index
	awful.key({ modkey }, "d", function()
		awful.client.focus.byidx(1)
	end, {
		description = "focus next by index",
		group = "client",
	}),

	awful.key({ modkey }, "a", function()
		awful.client.focus.byidx(-1)
	end, {
		description = "focus previous by index",
		group = "client",
	}),

	-- swap by index
	awful.key({ modkey, "Shift" }, "d", function()
		awful.client.swap.byidx(1)
	end, {
		description = "swap with next client by index",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "a", function()
		awful.client.swap.byidx(-1)
	end, {
		description = "swap with next client by index",
		group = "client",
	}),

	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

	awful.key({ modkey }, "n", function(c)
		c.minimized = true
	end, {
		description = "minimize client",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "c", function(c)
		local focused = awful.screen.focused()

		awful.placement.centered(c, {
			honor_workarea = true,
		})
	end, {
		description = "align a client to the center of the focused screen",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "c", function(c)
		c.ontop = not c.ontop
	end, {
		description = "toggle floating",
		group = "client",
	}),

	awful.key({ modkey }, "c", function(c)
		c.fullscreen = false
		c.maximized = false
		c.floating = not c.floating
		c:raise()
	end, {
		description = "toggle floating",
		group = "client",
	}),

	awful.key({ modkey }, "Up", function(c)
		c:relative_move(0, dpi(-10), 0, 0)
	end, {
		description = "move floating client up by 10 px",
		group = "client",
	}),

	awful.key({ modkey }, "Down", function(c)
		c:relative_move(0, dpi(10), 0, 0)
	end, {
		description = "move floating client down by 10 px",
		group = "client",
	}),

	awful.key({ modkey }, "Left", function(c)
		c:relative_move(dpi(-10), 0, 0, 0)
	end, {
		description = "move floating client to the left by 10 px",
		group = "client",
	}),

	awful.key({ modkey }, "Right", function(c)
		c:relative_move(dpi(10), 0, 0, 0)
	end, {
		description = "move floating client to the right by 10 px",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "Up", function(c)
		c:relative_move(0, dpi(-10), 0, dpi(10))
	end, {
		description = "increase floating client size vertically by 10 px up",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "Down", function(c)
		c:relative_move(0, 0, 0, dpi(10))
	end, {
		description = "increase floating client size vertically by 10 px down",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "Left", function(c)
		c:relative_move(dpi(-10), 0, dpi(10), 0)
	end, {
		description = "increase floating client size horizontally by 10 px left",
		group = "client",
	}),

	awful.key({ modkey, "Shift" }, "Right", function(c)
		c:relative_move(0, 0, dpi(10), 0)
	end, {
		description = "increase floating client size horizontally by 10 px right",
		group = "client",
	}),

	awful.key({ modkey, "Control" }, "Up", function(c)
		if c.height > 10 then
			c:relative_move(0, 0, 0, dpi(-10))
		end
	end, {
		description = "decrease floating client size vertically by 10 px up",
		group = "client",
	}),

	awful.key({ modkey, "Control" }, "Down", function(c)
		local c_height = c.height
		c:relative_move(0, 0, 0, dpi(-10))
		if c.height ~= c_height and c.height > 10 then
			c:relative_move(0, dpi(10), 0, 0)
		end
	end, {
		description = "decrease floating client size vertically by 10 px down",
		group = "client",
	}),

	awful.key({ modkey, "Control" }, "Left", function(c)
		if c.width > 10 then
			c:relative_move(0, 0, dpi(-10), 0)
		end
	end, {
		description = "decrease floating client size horizontally by 10 px left",
		group = "client",
	}),

	awful.key({ modkey, "Control" }, "Right", function(c)
		local c_width = c.width
		c:relative_move(0, 0, dpi(-10), 0)
		if c.width ~= c_width and c.width > 10 then
			c:relative_move(dpi(10), 0, 0, 0)
		end
	end, {
		description = "decrease floating client size horizontally by 10 px right",
		group = "client",
	})
)

return client_keys
