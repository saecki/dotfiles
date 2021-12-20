local M = {}

local wk = require("which-key")

function M.setup()
    vim.opt.timeoutlen = 400
    wk.setup({
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
        },
        window = {
            border = "none",
            position = "bottom",
            margin = { 1, 1, 2, 1 },
            padding = { 1, 1, 1, 1 },
            winblend = 0,
        },
    })
end

return M
