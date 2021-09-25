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

    maps.nnoremap("<f7>",       trouble.toggle,                           { silent = true })
    maps.nnoremap("gr",         ":Trouble lsp_references<cr>",            { silent = true })
    maps.nnoremap("gi",         ":Trouble lsp_implementations<cr>",       { silent = true })
    maps.nnoremap("gy",         ":Trouble lsp_type_definitions<cr>",      { silent = true })
    maps.nnoremap("<leader>ld", ":Trouble lsp_document_diagnostics<cr>",  { silent = true })
    maps.nnoremap("<leader>lw", ":Trouble lsp_workspace_diagnostics<cr>", { silent = true })
end

return M
