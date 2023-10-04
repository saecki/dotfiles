local M = {}

local ibl = require("ibl")

function M.setup()
    ibl.setup({
        indent = {
            char = "▏",
        },
        scope = {
            enabled = false,
        },
        exclude = {
            filetypes = {
                "man",
                "help",
                "NvimTree",
                "lsp-installer",
                "packer",
            },
        },
    })
end

return M
