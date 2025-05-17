local gitsigns = require("gitsigns")
local gitsigns_actions = require("gitsigns.actions")
local wk = require("which-key.config")
local shared = require("shared")

local M = {}

function M.setup()
    gitsigns.setup({
        signs = {
            add          = { text = "▌" },
            change       = { text = "▌" },
            delete       = { text = "🬏" },
            topdelete    = { text = "🬀" },
            changedelete = { text = "▌" },
        },
        signs_staged_enable = false,
        numhl = false,
        linehl = false,
        word_diff = false,
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 0,
        },
        current_line_blame_formatter = "// (<abbrev_sha>) <author>, <author_time:%R> - <summary>",
        sign_priority = 100,
        update_debounce = 100,
        diff_opts = {
            internal = true,
        },
        base = "HEAD",
        preview_config = {
            border = shared.window.border,
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
    })

    wk.add({
        { "[g",         function() gitsigns_actions.nav_hunk("prev") end, desc = "Previous hunk" },
        { "]g",         function() gitsigns_actions.nav_hunk("next") end, desc = "Next hunk" },
        { "<leader>g",  group = "Git" },
        { "<leader>gu", gitsigns.reset_hunk,                              desc = "Undo hunk" },
        { "<leader>gs", gitsigns.preview_hunk_inline,                     desc = "Show hunk inline" },
        { "<leader>gS", gitsigns.preview_hunk,                            desc = "Show hunk" },
        { "<leader>gb", gitsigns.toggle_current_line_blame,               desc = "Toggle inline blame" },
        { "<leader>gB", gitsigns.blame_line,                              desc = "Blame line" },
        { "<leader>gr", gitsigns.refresh,                                 desc = "Refresh" },
    })
end

return M
