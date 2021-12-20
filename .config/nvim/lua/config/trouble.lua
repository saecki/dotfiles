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
        ["<f7>"] = { ":TroubleToggle<cr>", "List UI toggle" },
        ["g"] = {
            name = "Goto",
            ["r"] = { ":Trouble lsp_references<cr>", "References" },
            ["i"] = { ":Trouble lsp_implementations<cr>", "Implementations" },
            ["y"] = { ":Trouble lsp_type_definitions<cr>", "Type definitions" },
        },
        ["<leader>l"] = {
            name = "List",
            ["d"] = { ":Trouble document_diagnostics<cr>", "Document diagnostics" },
            ["D"] = { ":Trouble workspace_diagnostics<cr>", "Workspace diagnostics" },
        },
    })
end

return M
