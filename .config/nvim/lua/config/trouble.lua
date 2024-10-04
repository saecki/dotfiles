local trouble = require("trouble")
local todo_comments = require("todo-comments")
local wk = require("which-key.config")

local M = {}

function M.setup()
    trouble.setup({
        focus = true,
        follow = true,
        auto_jump = false,
        win = {
            type = "split",
            position = "right",
            size = { width = 0.35 },
        },
        modes = {
            lsp_references = {
                params = {
                    include_current = true,
                },
            },
            lsp_implementations = {
                params = {
                    include_current = true,
                },
            },
        },
        -- TODO: use the same lsp-kind icons as with nvim-cmp
        icons = {},
    })
    todo_comments.setup({
        signs = false,
        keywords = {
            FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            STOPSHIP = { icon = " ", color = "error" },
            HACK = { icon = " ", color = "warning", alt = { "XXX" } },
            SAFETY = { icon = " ", color = "warning" },
            TODO = { icon = " ", color = "info" },
            TODO_IMPL = { icon = " ", color = "info", alt = { "todo!" } },
            PERF = { icon = "󰅒 ", color = "info" },
            IMPORTANT = { icon = " ", color = "info" },
            VOLATILE = { icon = " ", color = "hint" },
            NOTE = { icon = "󰎚 ", color = "hint", alt = { "INFO" } },
        },
        merge_keywords = false,
        highlight = {
            before = "",
            keyword = "fg",
            after = "",
            pattern = [[.*<(KEYWORDS)]], -- pattern or table of patterns, used for highlightng (vim regex)
            comments_only = true,        -- uses treesitter to match keywords in comments only
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

    wk.add({
        { "<leader>l",  group = "List" },
        { "<leader>le", function() trouble.close() end,                                              desc = "Toggle UI" },
        { "<leader>lt", function() trouble.open({ mode = "todo" }) end,                              desc = "TODO comments" },
        { "<leader>ld", function() trouble.open({ mode = "diagnostics", filter = { buf = 0 } }) end, desc = "Document diagnostics" },
        { "<leader>lD", function() trouble.open({ mode = "diagnostics" }) end,                       desc = "Workspace diagnostics" },
        { "]t",         function() trouble.next({ mode = "todo", focus = false, jump = true }) end,  desc = "Next todo" },
        { "[t",         function() trouble.prev({ mode = "todo", focus = false, jump = true }) end,  desc = "Previous todo" },
    })
end

return M
