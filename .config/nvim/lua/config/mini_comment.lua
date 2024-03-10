local M = {}

local mini_comment = require("mini.comment")

function M.setup()
    -- comment_ft.set("cods", { '//%s', '/*%s*/' })
    mini_comment.setup({
        mappings = {
            comment = 'gc',
            comment_line = 'gcc',
            comment_visual = 'gc',
            textobject = 'gc',
        },
    })
end

return M
