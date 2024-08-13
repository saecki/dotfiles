local wk = require("which-key.config")

local M = {}

function M.setup()
    wk.add({
        { "<leader>t",   group = "Tablemode" },
        { "<leader>te",  desc = "Toggle" },
        { "<leader>tt",  desc = "Tableize" },
        { "<leader>tr",  desc = "Realign" },
        { "<leader>ts",  desc = "Sort" },
        { "<leader>t?",  desc = "Echo cell" },

        { "<leader>ti",  group = "Insert" },
        { "<leader>tic", desc = "Column after" },
        { "<leader>tiC", desc = "Column Before" },

        { "<leader>td",  group = "Delete" },
        { "<leader>tdc", desc = "Column" },
        { "<leader>tdd", desc = "Row" },

        { "<leader>tf",  group = "Formula" },
        { "<leader>tfa", desc = "Add" },
        { "<leader>tfe", desc = "Eval" },

        { "<leader>tt",  desc = "Tableize",                mode = "v" },
        { "<leader>tT",  desc = "Tableize with delimiter", mode = "v" },
    })
end

return M
