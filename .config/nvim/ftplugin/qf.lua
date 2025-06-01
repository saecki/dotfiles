local buf = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "o", "<cr><cmd>cclose<cr>", { desc = "jump close", buffer = buf })
vim.keymap.set("n", "p", "<cr><c-w>p", { desc = "preview", buffer = buf })
