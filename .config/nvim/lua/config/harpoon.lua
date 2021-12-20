local M = {}

local harpoon = require("harpoon")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
local maps = require("util.maps")
local wk = require("which-key")

function M.setup()
    harpoon.setup({})

    wk.register({
        ["<c-h>"] = { maps.rhs(harpoon_ui.nav_file, 1), "Harpoon file 1" },
        ["<c-j>"] = { maps.rhs(harpoon_ui.nav_file, 2), "Harpoon file 1" },
        ["<c-k>"] = { maps.rhs(harpoon_ui.nav_file, 3), "Harpoon file 1" },
        ["<c-l>"] = { maps.rhs(harpoon_ui.nav_file, 4), "Harpoon file 1" },
        ["<leader>h"] = {
            name = "Harpoon",
            ["a"] = { harpoon_mark.add_file, "Add file" },
            ["s"] = { harpoon_ui.toggle_quick_menu, "Show" },
        },
    })
end

return M
