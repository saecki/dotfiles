local M = {}

local multicursors = require("multicursors")
local wk = require("which-key")
local shared = require("shared")

function M.setup()
    multicursors.setup({
        hint_config = {
            border = shared.window.border,
        },
    })

    vim.keymap.set("n", "<C-n>", multicursors.start)
    vim.keymap.set("v", "<C-n>", multicursors.search_visual)
end

return M
