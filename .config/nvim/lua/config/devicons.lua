local M = {}

local devicons = require("nvim-web-devicons")

function M.setup()
    devicons.set_default_icon("", "#6d8086")
end

return M
