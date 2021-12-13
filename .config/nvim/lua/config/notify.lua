local M = {}

local notify = require("notify")
local maps = require("util.maps")

function M.setup()
	maps.nnoremap("<leader>nd", notify.dismiss)
	maps.nnoremap("<leader>nh", notify._print_history)
end

return M
