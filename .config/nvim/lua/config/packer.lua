local M = {}

local wk = require("which-key")

function M.setup()
    wk.register({
        ["<leader>p"] = {
            name = "Packer",
            ["c"] = { ":PackerCompile<cr>", "Compile" },
            ["i"] = { ":PackerInstall<cr>", "Install" },
            ["s"] = { ":PackerSync<cr>", "Sync" },
            ["u"] = { ":PackerUpdate<cr>", "Update" },
        },
    })
end

return M
