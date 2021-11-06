local M = {}
local awful = require("awful")

M.spawn = function(...)
	local args = {...}
	return function()
		awful.spawn(table.unpack(args))
	end
end

M.info = function(desc, group)
	return {
		description = desc,
		group = group,
	}
end

return M
