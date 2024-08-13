local shared = require("shared")

local M = {}

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.INFO] = "",
                [vim.diagnostic.severity.HINT] = "",
            },
        },
        underline = true,
        update_in_insert = true,
        severity_sort = true,
        float = {
            border = shared.window.border,
        },
    })

    vim.keymap.set(
        "n", "[e",
        function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
        { desc = "Previous error" }
    )
    vim.keymap.set(
        "n", "]e",
        function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
        { desc = "Next error" }
    )
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
end

return M
