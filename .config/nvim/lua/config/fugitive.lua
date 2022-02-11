local M = {}

local wk = require("which-key")

local function toggle_diff()
    if vim.o.diff then
        vim.cmd("diffoff")
        vim.cmd("bdelete //2")
        vim.cmd("bdelete //3")
    else
        vim.cmd("Gvdiffsplit!")
    end
end

function M.setup()
    wk.register({
        ["<leader>g"] = {
            name = "Git",
            ["d"] = { toggle_diff, "Toggle 3 way diff" },
            ["h"] = { ":diffget //2<cr>", "Get left diff" },
            ["l"] = { ":diffget //3<cr>", "Get right diff" },
        }
    })
end

return M
