local M = {}

local trouble = require("trouble")
local todo_comments = require("todo-comments")
local wk = require("which-key")
local util = require("util")

function M.setup()
    trouble.setup({
        position = "right",
        width = 60,
        icons = false,
        fold_open = "",
        fold_closed = "",
        auto_jump = { -- TODO: fix
            -- "lsp_definitions",
            -- "lsp_type_definitions",
        },
        signs = {
            other = "",
            error = "",
            warning = "",
            information = "",
            hint = "",
        },
    })
    todo_comments.setup({
        signs = false,
        keywords = {
            FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            STOPSHIP = { icon = " ", color = "error" },
            HACK = { icon = " ", color = "warning", alt = { "XXX" } },
            TODO = { icon = " ", color = "info", alt = { "todo!" } },
            PERF = { icon = " ", color = "info" },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
        merge_keywords = false,
        highlight = {
            before = "",
            keyword = "fg",
            after = "",
            pattern = [[.*<(KEYWORDS)]], -- pattern or table of patterns, used for highlightng (vim regex)
            comments_only = true, -- uses treesitter to match keywords in comments only
        },
        colors = {
            error = { "DiagnosticError" },
            warning = { "DiagnosticWarn" },
            info = { "Todo" },
            hint = { "DiagnosticHint" },
            default = { "PreProc" },
        },
        search = {
            pattern = [[\b(KEYWORDS)]], -- ripgrep regex
        },
    })

    wk.register({
        ["<A-LeftMouse>"] = { "<LeftMouse>:Trouble lsp_type_definitions<cr>", "LSP type definition" },

        ["g"] = {
            name = "Go",
            ["r"] = { util.wrap(trouble.open, "lsp_references"), "LSP references" },
            ["i"] = { util.wrap(trouble.open, "lsp_implementations"), "LSP implementations" },
            ["y"] = { util.wrap(trouble.open, "lsp_type_definitions"), "LSP type definitions" },
        },
        ["<leader>l"] = {
            name = "List",
            ["e"] = { ":TroubleToggle<cr>", "Toggle UI" },
            ["d"] = { util.wrap(trouble.open, "document_diagnostics"), "Document diagnostics" },
            ["D"] = { util.wrap(trouble.open, "workspace_diagnostics"), "Workspace diagnostics" },
            ["t"] = { util.wrap(trouble.open, "todo"), "TODO comments" },
        },
    })
end

return M
