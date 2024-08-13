local multicursors = require("multicursors")
local wk = require("which-key.config")
local shared = require("shared")

local M = {}

function M.setup()
    multicursors.setup({
        updatetime = 5,
        hint_config = {
            border = shared.window.border,
        },
    })

    vim.keymap.set("n", "<C-n>", multicursors.start, { desc = "Start multicursors" })
    vim.keymap.set("v", "<C-n>", multicursors.search_visual, { desc = "Start multicursors" })
end

return M
