local shared = require("shared")

local M = {}

---@param opts vim.diagnostic.JumpOpts
local function map_jump(opts)
    opts.float = true
    return function()
        vim.diagnostic.jump(opts)
    end
end

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
        map_jump({ count = -1, severity = vim.diagnostic.severity.ERROR }),
        { desc = "Previous error" }
    )
    vim.keymap.set(
        "n", "]e",
        map_jump({ count = 1, severity = vim.diagnostic.severity.ERROR }),
        { desc = "Next error" }
    )
    vim.keymap.set("n", "[d", map_jump({ count = -1 }), { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", map_jump({ count = 1 }), { desc = "Next diagnostic" })
end

return M
