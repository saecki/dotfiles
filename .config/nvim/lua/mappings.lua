local M = {}

function M.setup()
    -- TODO: make tmux/kitty send different escape sequences for <tab> and <c-i> etc.
    -- vim.keymap.set("", "<tab>", "<c-i>", {})

    vim.keymap.set("", "<c-RightMouse>", "<c-o>", { desc = "Jump back" })
    vim.keymap.set("", "<a-RightMouse>", "<c-o>", { desc = "Jump back" })

    vim.keymap.set("", "j", "gj", { silent = true })
    vim.keymap.set("", "gj", "j", { silent = true })
    vim.keymap.set("", "k", "gk", { silent = true })
    vim.keymap.set("", "gk", "k", { silent = true })

    vim.keymap.set({ "n", "i" }, "<f1>", "<esc>")
    vim.keymap.set("n", "<leader><leader>", "<c-^>", { desc = "Goto previous buffer" })
    vim.keymap.set("n", "<leader>w", ":w<cr>", { desc = "Write" })

    vim.keymap.set("n", "<c-left>", ":vertical resize -5<cr>", { desc = "Decrease width" })
    vim.keymap.set("n", "<c-right>", ":vertical resize +5<cr>", { desc = "Increase width" })
    vim.keymap.set("n", "<c-up>", ":resize -5<cr>", { desc = "Decrease height" })
    vim.keymap.set("n", "<c-down>", ":resize +5<cr>", { desc = "Increase height" })

    vim.keymap.set("n", "<leader>er", ":set rnu!<cr>", { desc = "Relative line numbers" })
    vim.keymap.set("n", "<leader>el", ":set list!<cr>", { desc = "Listchars" })
    vim.keymap.set("n", "<leader>es", ":set spell!<cr>", { desc = "Spellchecking" })

    vim.keymap.set("n", "[q", ":cprev<cr>", { desc = "Previous quickfix" } )
    vim.keymap.set("n", "]q", ":cnext<cr>", { desc = "Next quickfix" } )

    vim.keymap.set("v", "<c-c>", '"+y', { desc = "Copy to system clipboard" })
end

return M
