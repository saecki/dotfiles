local M = {}

local wk = require("which-key")

function M.setup()
    vim.opt.timeoutlen = 400
    wk.setup({
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 40,
            },
        },
        operators = {
            gc = "Comment",
            gb = "Block comment",
        },
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
        hidden = {
            "<silent>",
            "<cmd>",
            "<Cmd>",
            "<plug>",
            "<Plug>",
            "<CR>",
            "call",
            "lua",
            "^:",
            "^ ",
        },
        triggers_blacklist = {
            n = { "v", "<a-j>", "<a-s-j>", "<a-k>" },
            v = { "v", "<a-j>", "<a-s-j>", "<a-k>" },
        },
    })

    wk.register({
        ["<leader>k"] = { ":WhichKey<cr>", "Which key?" },
    })
end

return M
