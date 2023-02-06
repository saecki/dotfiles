local M = {}

local comment = require("Comment")
local comment_ft = require("Comment.ft")
local wk = require("which-key")

function M.setup()
    comment_ft.set("cods", { '//%s', '/*%s*/' })

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
end

return M
