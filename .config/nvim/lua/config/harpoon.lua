local harpoon = require("harpoon")
local wk = require("which-key.config")
local shared = require("shared")

local M = {}

---@param num integer
local function select_file(num)
    return function()
        harpoon:list():select(num)
    end
end

local function toggle_menu()
    local opts = {
        title = "",
        border = shared.window.border,
    }
    harpoon.ui:toggle_quick_menu(harpoon:list(), opts)
end

function M.setup()
    harpoon:setup()

    wk.add({
        { "<c-h>",      select_file(1),                                              desc = "harpoon file 1" },
        { "<c-j>",      select_file(2),                                              desc = "harpoon file 2" },
        { "<c-k>",      select_file(3),                                              desc = "harpoon file 3" },

        { "<leader>h",  group = "Harpoon" },
        { "<leader>he", toggle_menu, desc = "Toggle UI" },
        { "<leader>ha", function() harpoon:list():add() end,                         desc = "Add file" },
    })
end

return M
