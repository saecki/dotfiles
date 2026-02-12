local wk = require("which-key.config")

local M = {}

function M.setup()
    local group = vim.api.nvim_create_augroup("user.config.lang.rust", {})
    vim.api.nvim_create_autocmd("BufReadPre", {
        group = group,
        pattern = "*.typ",
        callback = function(ev)
            wk.add({
                buffer = ev.buf,
                { "<leader>it",  group = "Typst" },
                { "<leader>itw", "<cmd>TypstWatch<cr>", desc = "Watch" },
            })
        end
    })
end

return M
