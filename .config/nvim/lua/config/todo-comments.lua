local function setup()
    require('todo-comments').setup {
        signs = false,
        keywords = {
            FIX = {
                icon = " ",
                color = "error",
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = "🔨", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        },
        merge_keywords = true,
        highlight = {
            pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlightng (vim regex)
            comments_only = true, -- uses treesitter to match keywords in comments only
        },
        search = {
            pattern = [[\b(KEYWORDS)]], -- ripgrep regex
        },
    }
end

return {
    setup = setup,
}
