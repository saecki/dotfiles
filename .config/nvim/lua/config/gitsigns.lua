local gitsigns = require("gitsigns")
local gitsigns_actions = require("gitsigns.actions")
local wk = require("which-key")
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
        current_line_blame_formatter = "// <author>, <author_time:%R> - <summary>",
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
    wk.register({
        ["[g"] = { gitsigns_actions.prev_hunk, "Previous hunk" },
        ["]g"] = { gitsigns_actions.next_hunk, "Next hunk" },
        ["<leader>g"] = {
            name = "Git",
            ["u"] = { gitsigns.reset_hunk, "Undo hunk" },
            ["s"] = { gitsigns.preview_hunk, "Show hunk" },
            ["b"] = { gitsigns.toggle_current_line_blame, "Toggle inline blame" },
            ["B"] = { gitsigns.blame_line, "Blame line" },
            ["r"] = { gitsigns.refresh, "Refresh" },
        },
    })
end

return M
