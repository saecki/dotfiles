local wk = require("which-key")

local M = {}

local function toggle_diff()
    if vim.o.diff then
        vim.cmd.diffoff()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_name(bufnr):match("fugitive://.*") then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end
    else
        vim.cmd.Gvdiffsplit({ bang = true })
    end
end

function M.setup()
    wk.add({
        { "<leader>g",  group = "Git" },
        { "<leader>gd", toggle_diff,        desc = "Toggle diff" },
        { "<leader>gh", ":diffget //2<cr>", desc = "Get left diff" },
        { "<leader>gl", ":diffget //3<cr>", desc = "Get right diff" },
    })
end

return M
