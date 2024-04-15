local substitute = require("substitute")

local M = {}

function M.setup()
    substitute.setup({
        yank_substituted_text = false,
        preserve_cursor_position = false,
        highlight_substituted_text = {
            enabled = true,
            timer = 150,
        },
    })

    local opts = { noremap = true }
    vim.keymap.set("n", "S", substitute.operator, opts)
    vim.keymap.set("n", "SS", substitute.line, opts)
    -- vim.keymap.set("n", "S", substitute.eol, opts)
    vim.keymap.set("x", "S", substitute.visual, opts)
end

return M
