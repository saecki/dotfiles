local M = {}

local colorizer = require("colorizer")
local wk = require("which-key")

function M.setup()
    colorizer.setup()

    wk.register({
        ["<leader>e"] = {
            name = "Toggle (enable/disable)",
            ["c"] = { ":ColorizerToggle<cr>", "Colorizer" },
        },
    })
end

return M
