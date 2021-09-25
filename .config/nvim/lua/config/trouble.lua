local M = {}

local trouble = require('trouble')
local maps = require('mappings')

function M.setup()
    trouble.setup {
        position = "right",
        width = 60,
        icons = false,
        fold_open = "",
        fold_closed = "",
        signs = {
            other = "",
            error = "",
            warn  = "",
            info  = "",
            hint  = "",
        }
    }

    maps.nnoremap("<f7>",       trouble.toggle,                    { silent = true })

    local providers = require('trouble.providers').providers
    maps.nnoremap("gr",         providers.lsp_references,            { silent = true })
    maps.nnoremap("gi",         providers.lsp_implementations,       { silent = true })
    maps.nnoremap("gy",         providers.lsp_type_definitions,      { silent = true })
    maps.nnoremap("<leader>ld", providers.lsp_document_diagnostics,  { silent = true })
    maps.nnoremap("<leader>lw", providers.lsp_workspace_diagnostics, { silent = true })
end

return M
