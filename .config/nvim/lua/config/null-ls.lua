local M = {}

local null_ls = require("null-ls")
local lsp_config = require("config.lsp")

function M.setup()
    null_ls.setup({
        on_attach = lsp_config.on_attach,
        sources = {
            null_ls.builtins.diagnostics.teal,
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.formatting.stylua,
        },
    })
end

return M
