local M = {}

local function toggle_diff()
    local tab = vim.api.nvim_get_current_tabpage()
    local wins = vim.iter(vim.api.nvim_list_wins())
        :filter(vim.api.nvim_win_is_valid)
        :filter(function(win) return vim.api.nvim_win_get_tabpage(win) == tab end)
        :totable()

    local enabled = false
    for _, win in ipairs(wins) do
        enabled = enabled or vim.wo[win].diff
    end

    local callback = enabled and vim.cmd.diffoff or vim.cmd.diffthis
    for _, win in ipairs(wins) do
        vim.api.nvim_win_call(win, callback)
    end
end

---@param name string
local function toggle_diffopt(name)
    return function()
        local diffopts = vim.opt.diffopt:get()
        if vim.list_contains(diffopts, name) then
            vim.opt.diffopt:remove(name)
            print(string.format("diffopt.%s: off", name))
        else
            vim.opt.diffopt:append(name)
            print(string.format("diffopt.%s: on", name))
        end
    end
end

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
    vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })

    vim.keymap.set("n", "<c-left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease width" })
    vim.keymap.set("n", "<c-right>", "<cmd>vertical resize +5<cr>", { desc = "Increase width" })
    vim.keymap.set("n", "<c-up>", "<cmd>resize -5<cr>", { desc = "Decrease height" })
    vim.keymap.set("n", "<c-down>", "<cmd>resize +5<cr>", { desc = "Increase height" })

    vim.keymap.set("n", "<leader>er", "<cmd>set rnu!<cr>", { desc = "Relative line numbers" })
    vim.keymap.set("n", "<leader>el", "<cmd>set list!<cr>", { desc = "Listchars" })
    vim.keymap.set("n", "<leader>es", "<cmd>set spell!<cr>", { desc = "Spellchecking" })
    vim.keymap.set("n", "<leader>edv", toggle_diff, { desc = "View" })
    vim.keymap.set("n", "<leader>edw", toggle_diffopt("iwhite"), { desc = "iwhite" })

    vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
    vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })

    vim.keymap.set("v", "<c-c>", '"+y', { desc = "Copy to system clipboard" })
end

return M
