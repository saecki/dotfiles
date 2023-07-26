local M = {}

local spectre = require("spectre")
local wk = require("which-key")

function M.setup()
    spectre.setup({
        live_update = true,
        mapping = {
            ["toggle_regex"] = {
                map = "tr",
                cmd = "<cmd>lua require('spectre').change_options('noregex')<CR>",
                desc = "toggle regex",
            },
        },
        find_engine = {
            ["rg"] = {
                cmd = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                options = {
                    ["ignore-case"] = {
                        value = "--ignore-case",
                        icon = "[I]",
                        desc = "ignore case",
                    },
                    ["hidden"] = {
                        value = "--hidden",
                        desc = "hidden file",
                        icon = "[H]",
                    },
                    ["noregex"] = {
                        value = "-F",
                        desc = "disable regex",
                        icon = "[R]",
                    },
                },
            },
        },
    })

    wk.register({
        ["<leader>"] = {
            ["s"] = {
                name = "Search/Replace",
                ["e"] = { spectre.toggle, "Toggle UI" },
                ["p"] = { spectre.open, "Project" },
                ["f"] = { spectre.open_file_search, "File" },
            },
        },
    })

    wk.register({
        ["<leader>"] = {
            ["s"] = {
                name = "Search/Replace",
                ["p"] = { "<cmd>lua require('spectre').open_visual()<cr>", "Project" },
                ["f"] = { "<cmd>lua require('spectre').open_visual({ path = vim.fn.expand('%') })<cr>", "File" },
            },
        },
    }, {
        mode = "v",
    })
end

return M
