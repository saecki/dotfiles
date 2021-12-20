local M = {}

local comment = require("Comment")
local wk = require("which-key")

function M.setup()
    comment.setup({
        toggler = {
            line = "gcc",
            block = "gbc",
        },
        opleader = {
            line = "gc",
            block = "gb",
        },
        extra = {
            above = "gcO",
            below = "gco",
            eol = "gcA",
        },
        mappings = {
            basic = true,
            extra = true,
            extended = false,
        },
    })

    wk.register({
        ["g"] = {
            name = "Go",
            ["c"] = {
                name = "Comment",
                ["c"] = { nil, "Toggle" },
                ["A"] = { nil, "Append" },
                ["O"] = { nil, "Insert above" },
                ["o"] = { nil, "Insert below" },
            },
            ["b"] = {
                name = "Block Comment",
                ["c"] = { nil, "Toggle" },
            },
        },
    })
end

return M
