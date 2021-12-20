local M = {}

local wk = require("which-key")

function M.setup()
    vim.opt.timeoutlen = 200
    wk.setup({
        window = {
            border = "none",
            position = "bottom",
            margin = { 1, 1, 2, 1 },
            padding = { 2, 2, 2, 2 },
            winblend = 0,
        },
    })
end

return M
