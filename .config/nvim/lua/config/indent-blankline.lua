local M = {}

local indent_blankline = require("indent_blankline")

function M.setup()
    indent_blankline.setup({
        char = "⎸",
        show_trailing_blankline_indent = false,
        use_treesitter = true,
        filetype_exclude = { "man", "help", "NvimTree" },
    })
end

return M
