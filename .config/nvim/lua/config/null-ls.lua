local M = {}

local null_ls = require("null-ls")

function M.setup()
    null_ls.setup({
        sources = {
            null_ls.builtins.diagnostics.teal,
            null_ls.builtins.formatting.stylua,
        },
    })
end

return M
