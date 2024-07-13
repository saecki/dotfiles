local spectre = require("spectre")
local wk = require("which-key")

local M = {}

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

    wk.add({
        { "<leader>s",  group = "Search/Replace" },
        { "<leader>se", spectre.toggle,                                                               desc = "Toggle UI" },
        { "<leader>sp", spectre.open,                                                                 desc = "Project" },
        { "<leader>sf", spectre.open_file_search,                                                     desc = "File" },

        { "<leader>sp", "<cmd>lua require('spectre').open_visual()<cr>",                              desc = "Project",  mode = "v" },
        { "<leader>sf", "<cmd>lua require('spectre').open_visual({ path = vim.fn.expand('%') })<cr>", desc = "File",     mode = "v" },
    })
end

return M
