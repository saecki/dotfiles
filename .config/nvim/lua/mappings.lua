local M = {}

local wk_ok, wk = pcall(require, "which-key")

function M.setup()
    -- TODO: make tmux/kitty send different escape sequences for <tab> and <c-i> etc.
    -- vim.keymap.set("", "<tab>", "<c-i>", {})

    if not wk_ok then
        vim.notify("which-key isn't installed", vim.log.levels.ERROR)
        return
    end

    vim.keymap.set("", "j", "gj")
    vim.keymap.set("", "gj", "j")
    vim.keymap.set("", "k", "gk")
    vim.keymap.set("", "gk", "k")

    wk.register({
        ["<f1>"] = { "<esc>" },
        ["<c-l>"] = { ":nohlsearch<cr>", "Stop searching" },
        ["<c-left>"] = { ":vertical resize -5<cr>", "Decrease width" },
        ["<c-right>"] = { ":vertical resize +5<cr>", "Increase width" },
        ["<c-up>"] = { ":resize -5<cr>", "Decrease height" },
        ["<c-down>"] = { ":resize +5<cr>", "Increase height" },
        ["<leader>"] = {
            ["<leader>"] = { "<c-^>", "Goto previous buffer" },
            ["w"] = { ":w<cr>", "Write" },
            ["e"] = {
                name = "Toggle (enable)",
                ["r"] = { ":set rnu!<cr>", "Relative line numbers" },
                ["l"] = { ":set list!<cr>", "Listchars" },
                ["s"] = { ":set spell!<cr>", "Spellchecking" },
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

    vim.keymap.set("x", "<leader>p", '"_dP')
end

return M
