local M = {}

local wk_ok, wk = pcall(require, "which-key")
local map = vim.api.nvim_set_keymap

function M.setup()
    -- make kitty aware that nvim can differentiate <tab> and <c-i> etc.
    if vim.env.TERM == 'xterm-kitty' then
      vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
      vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
    end

    if not wk_ok then
        vim.notify("which-key isn't installed", vim.log.levels.ERROR)
        return
    end

    map("", "j", "gj", { noremap = true })
    map("", "gj", "j", { noremap = true })
    map("", "k", "gk", { noremap = true })
    map("", "gk", "k", { noremap = true })

    wk.register({
        ["<f1>"] = { "<esc>" },
        ["S"] = { ":nohlsearch<cr>", "Stop searching" },
        ["<c-left>"] = { ":vertical resize -5<cr>", "Decrease width" },
        ["<c-right>"] = { ":vertical resize +5<cr>", "Increase width" },
        ["<c-up>"] = { ":resize -5<cr>", "Decrease height" },
        ["<c-down>"] = { ":resize +5<cr>", "Increase height" },
        ["<leader>"] = {
            ["<leader>"] = { "<c-^>", "Goto previous buffer" },
            ["w"] = { ":w<cr>", "Write" },
            ["e"] = {
                name = "Toggle (enable)",
                ["l"] = { ":set list!<cr>", "Listchars" },
                ["s"] = { ":set spell!<cr>", "Spelling" },
            },
        },
    })

    wk.register({
        ["<f1>"] = { "<esc>" },
        ["<c-v>"] = { "<c-r>+", "Paste system clipboard" },
    }, {
        mode = "i",
    })

    wk.register({
        ["<c-c>"] = { '"+y', "Copy to system clipboard" },
    }, {
        mode = "v",
    })
end

return M
