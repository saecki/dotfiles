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

    if enabled then
        vim.cmd.diffoff({ bang = true })
    else
        for _, win in ipairs(wins) do
            vim.api.nvim_win_call(win, vim.cmd.diffthis)
        end
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

local function toggle_quickfix()
    for _, wininfo in ipairs(vim.fn.getwininfo()) do
        if wininfo.quickfix == 1 then
            vim.cmd.cclose()
            return
        end
    end
    vim.cmd.copen()
end

function M.setup()
    -- TODO: make tmux/kitty send different escape sequences for <tab> and <c-i> etc.
    -- vim.keymap.set("", "<tab>", "<c-i>", {})

    -- wrapped lines
    vim.keymap.set("", "j", "gj", { silent = true })
    vim.keymap.set("", "gj", "j", { silent = true })
    vim.keymap.set("", "k", "gk", { silent = true })
    vim.keymap.set("", "gk", "k", { silent = true })

    -- jump back
    vim.keymap.set("", "<c-RightMouse>", "<c-o>", { desc = "Jump back" })
    vim.keymap.set("", "<a-RightMouse>", "<c-o>", { desc = "Jump back" })

    -- resize windows
    vim.keymap.set("n", "<c-left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease width" })
    vim.keymap.set("n", "<c-right>", "<cmd>vertical resize +5<cr>", { desc = "Increase width" })
    vim.keymap.set("n", "<c-up>", "<cmd>resize -5<cr>", { desc = "Decrease height" })
    vim.keymap.set("n", "<c-down>", "<cmd>resize +5<cr>", { desc = "Increase height" })

    -- toggle things
    vim.keymap.set("n", "<leader>er", "<cmd>set rnu!<cr>", { desc = "Relative line numbers" })
    vim.keymap.set("n", "<leader>el", "<cmd>set list!<cr>", { desc = "Listchars" })
    vim.keymap.set("n", "<leader>es", "<cmd>set spell!<cr>", { desc = "Spellchecking" })
    vim.keymap.set("n", "<leader>edv", toggle_diff, { desc = "View" })
    vim.keymap.set("n", "<leader>edw", toggle_diffopt("iwhite"), { desc = "iwhite" })

    -- command line navigation
    vim.keymap.set("c", "<c-p>", function() return vim.fn.wildmenumode() == 0 and "<up>" or "<c-p>" end, { expr = true })
    vim.keymap.set("c", "<c-n>", function() return vim.fn.wildmenumode() == 0 and "<down>" or "<c-n>" end, { expr = true })

    -- misc
    vim.keymap.set({ "n", "i" }, "<f1>", "<esc>")
    vim.keymap.set("n", "<leader><leader>", "<c-^>", { desc = "Goto previous buffer" })
    vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
    vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Toggle quickfix list" })
    vim.keymap.set("v", "<c-c>", '"+y', { desc = "Copy to system clipboard" })
end

return M
