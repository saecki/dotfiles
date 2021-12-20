local M = {}

local trouble = require("trouble")
local wk = require("which-key")

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
            warning  = "",
            information  = "",
            hint  = "",
        },
    })
    -- stylua: ignore end

    wk.register({
        ["<f7>"] = { ":TroubleToggle<cr>", "Toggle List UI" },
        ["g"] = {
            name = "Go",
            ["r"] = { ":Trouble lsp_references<cr>", "LSP references" },
            ["i"] = { ":Trouble lsp_implementations<cr>", "LSP implementations" },
            ["y"] = { ":Trouble lsp_type_definitions<cr>", "LSP type definitions" },
        },
        ["<leader>l"] = {
            name = "List",
            ["d"] = { ":Trouble document_diagnostics<cr>", "Document diagnostics" },
            ["D"] = { ":Trouble workspace_diagnostics<cr>", "Workspace diagnostics" },
        },
    })
end

return M
