local M = {}

local harpoon = require("harpoon")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
local maps = require("util.maps")

function M.setup()
	harpoon.setup({})

	maps.nnoremap("<leader>ha", harpoon_mark.add_file)
	maps.nnoremap("<leader>hs", harpoon_ui.toggle_quick_menu)

	maps.nnoremap("<c-h>", function()
		harpoon_ui.nav_file(1)
	end)
	maps.nnoremap("<c-j>", function()
		harpoon_ui.nav_file(2)
	end)
	maps.nnoremap("<c-k>", function()
		harpoon_ui.nav_file(3)
	end)
	maps.nnoremap("<c-l>", function()
		harpoon_ui.nav_file(4)
	end)
end

return M
