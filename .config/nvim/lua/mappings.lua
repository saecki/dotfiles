local M = {}

local wk_ok, wk = pcall(require, "which-key")

function M.setup()
    if not wk_ok then
        vim.notify("which-key isn't installed")
        return
    end

    wk.register({
        ["<f1>"] = { "<esc>" },
        ["j"] = { "gj" },
        ["k"] = { "gk" },
        ["S"] = { ":nohlsearch<cr>", "Stop searching" },
        ["<c-left>"] = { ":vertical resize -5<cr>", "Decrease width" },
        ["<c-right>"] = { ":vertical resize +5<cr>", "Increase width" },
        ["<c-up>"] = { ":resize -5<cr>", "Decrease height" },
        ["<c-down>"] = { ":resize +5<cr>", "Increase height" },
        ["<leader>"] = {
            ["<leader>"] = { "<c-^>", "Goto previous buffer" },
            ["w"] = { ":w<cr>", "Write" },
            ["e"] = {
                name = "Toggle",
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
