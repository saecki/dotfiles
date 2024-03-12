local wk = require("which-key")
local shared = require("shared")

local M = {}

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
            border = shared.window.border,
            position = "bottom",
            margin = { 2, 2, 2, 4 },
            padding = { 0, 0, 0, 0 },
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
        ["<leader>"] = {
            ["k"] = { ":WhichKey<cr>", "Which key?" },
            ["e"] = {
                name = "Toggle (enable)",
            },
        },
    })
end

return M
