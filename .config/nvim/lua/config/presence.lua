local presence = require("presence")

local M = {}

function M.setup()
    local ok = pcall(presence.setup)
    if not ok then
        print("failed to setup presence.nvim")
    end
end

return M
