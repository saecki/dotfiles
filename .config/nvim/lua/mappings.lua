local M = {}

function M.setup()
    -- TODO: make tmux/kitty send different escape sequences for <tab> and <c-i> etc.
    -- vim.keymap.set("", "<tab>", "<c-i>", {})

    vim.keymap.set("", "j", "gj")
    vim.keymap.set("", "gj", "j")
    vim.keymap.set("", "k", "gk")
    vim.keymap.set("", "gk", "k")

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

    vim.keymap.set("v", "<c-c>", '"+y', { desc = "Copy to system clipboard" })
end

return M
