local M = {}

local wk = require("which-key")

function M.setup()
    wk.register({
        ["<leader>g"] = {
            name = "Git",
            ["d"] = { ":Gvdiffsplit!<cr>", "Open 3 way diff" },
            ["h"] = { ":diffget //2<cr>", "Get left diff" },
            ["l"] = { ":diffget //3<cr>", "Get right diff" },
        }
    })
end

return M
