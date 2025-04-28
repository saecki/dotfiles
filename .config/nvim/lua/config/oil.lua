local oil = require("oil")
local shared = require("shared")

local M = {}

function M.setup()
    oil.setup({
        float = {
            border = shared.window.border,
        },
        confirmation = {
            border = shared.window.border,
        },
        progress = {
            border = shared.window.border,
        },
        keymaps_help = {
            border = shared.window.border,
        },
    })
end

return M
