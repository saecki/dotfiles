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
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
            rules = false,
        },
        win = {
            title = false,
            border = shared.window.border,
            padding = { 0, 0 },
            wo = {
                winblend = 0,
            }
        },
        keys = {
            scroll_down = "<down>", -- scroll down in popup
            scroll_up = "<up>",   -- scroll up in popup
        },
        show_help = false,
        show_keys = false,
    })

    wk.add({
        { "<leader>e", group = "Toggle (enable)" },
        { "<leader>k", ":WhichKey<cr>",          desc = "Which key?" },
    })
end

return M
