local M = {}

local trouble = require("trouble")
local maps = require("util.maps")

function M.setup()
    -- stylua: ignore start
    trouble.setup({
        position = "right",
        width = 60,
        icons = false,
        fold_open = "",
        fold_closed = "",
        auto_jump = {
            "lsp_definitions",
            "lsp_type_definitions",
        },
        signs = {
            other = "",
            error = "",
            warn  = "",
            info  = "",
            hint  = "",
        },
    })
    -- stylua: ignore end

    maps.nnoremap("<f7>", trouble.toggle)
    maps.nnoremap("gr", ":Trouble lsp_references<cr>")
    maps.nnoremap("gi", ":Trouble lsp_implementations<cr>")
    maps.nnoremap("gy", ":Trouble lsp_type_definitions<cr>")
    maps.nnoremap("<leader>ld", ":Trouble document_diagnostics<cr>")
    maps.nnoremap("<leader>lw", ":Trouble workspace_diagnostics<cr>")
end

return M
