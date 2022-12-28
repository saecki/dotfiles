local M = {}

local harpoon = require("harpoon")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
local util = require("util")
local wk = require("which-key")
local shared = require("shared")

function M.setup()
    harpoon.setup({
        menu = {
            borderchars = shared.window.plenary_border,
        },
    })

    wk.register({
        ["<c-h>"] = { util.wrap(harpoon_ui.nav_file, 1), "Harpoon file 1" },
        ["<c-j>"] = { util.wrap(harpoon_ui.nav_file, 2), "Harpoon file 2" },
        ["<c-k>"] = { util.wrap(harpoon_ui.nav_file, 3), "Harpoon file 3" },
        ["<leader>h"] = {
            name = "Harpoon",
            ["a"] = { harpoon_mark.add_file, "Add file" },
            ["e"] = { harpoon_ui.toggle_quick_menu, "Toggle UI" },
        },
    })
end

return M
