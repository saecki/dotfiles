local M = {}

local indent_blankline = require("indent_blankline")

function M.setup()
    indent_blankline.setup({
        filetype_exclude = { "man", "help", "NvimTree" },
    })
end

return M
