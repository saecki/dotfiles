local wk = require("which-key")

local M = {}

function M.setup()
    vim.g.table_mode_tableize_d_map = "<leader>tT"
    wk.register({
        ["<leader>t"] = {
            name = "Tablemode",
            ["m"] = { nil, "Toggle" },
            ["t"] = { nil, "Tableize" },
            ["r"] = { nil, "Realign" },
            ["s"] = { nil, "Sort" },
            ["?"] = { nil, "Echo cell" },
            ["i"] = {
                name = "Insert",
                ["c"] = { nil, "Column after" },
                ["C"] = { nil, "Column Before" },
            },
            ["d"] = {
                name = "Delete",
                ["c"] = { nil, "Column" },
                ["d"] = { nil, "Row" },
            },
            ["f"] = {
                name = "Formula",
                ["a"] = { nil, "Add" },
                ["e"] = { nil, "Eval" },
            },
        },
    })
    wk.register({
        ["<leader>t"] = {
            name = "Tablemode",
            ["t"] = { nil, "Tableize" },
            ["T"] = { nil, "Tableize with delimiter" },
        },
    }, {
        mode = "v",
    })
end

return M
