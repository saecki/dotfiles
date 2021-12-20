local M = {}

local comment = require("Comment")
local comment_ft = require("Comment.ft")

function M.setup()
    comment.setup()
    comment_ft.set("teal", { "--%s", "--[[%s]]" })
end

return M
