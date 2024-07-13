local harpoon = require("harpoon")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
local wk = require("which-key")
local shared = require("shared")

local M = {}

local function nav_file(n)
    return function()
        harpoon_ui.nav_file(n)
    end
end

function M.setup()
    harpoon.setup({
        menu = {
            borderchars = shared.window.plenary_border,
        },
    })

    wk.add({
        { "<c-h>",      nav_file(1),                  desc = "Harpoon file 1" },
        { "<c-j>",      nav_file(2),                  desc = "Harpoon file 2" },
        { "<c-k>",      nav_file(3),                  desc = "Harpoon file 3" },
        { "<leader>h",  group = "Harpoon" },
        { "<leader>ha", harpoon_mark.add_file,        desc = "Add file" },
        { "<leader>he", harpoon_ui.toggle_quick_menu, desc = "Toggle UI" },
    })
end

return M
