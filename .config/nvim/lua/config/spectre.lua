local M = {}

local spectre = require("spectre")
local wk = require("which-key")
local maps = require("util.maps")

function M.setup()
    spectre.setup({
        live_update = true,
    })

    wk.register({
        ["<leader>"] = {
            ["s"] = {
                name = "Search/Replace",
                ["p"] = { spectre.open, "Project" },
                ["f"] = { spectre.open_file_search, "File" },
            },
        },
    })

    wk.register({
        ["<leader>"] = {
            ["s"] = {
                name = "Search/Replace",
                ["p"] = { spectre.open_visual, "Project" },
                ["f"] = { maps.rhs(spectre.open_visual, { path = vim.fn.expand("%") }), "File" },
            },
        },
    }, {
        mode = "v",
    })
end

return M
