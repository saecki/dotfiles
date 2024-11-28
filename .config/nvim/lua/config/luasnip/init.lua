local luasnip = require("luasnip")

local M = {}

local function try_unlink_current()
    if luasnip.get_active_snip() ~= nil then
        luasnip.unlink_current()
    end
end

---@param key string
---@param expr string
---@param dir integer
local function map_try_jump(key, expr, dir)
    local escaped = vim.api.nvim_replace_termcodes(expr, true, false, true)
    local action = function()
        if luasnip.jumpable(dir) then
            local success = luasnip.jump(dir)
            if not success or not luasnip.jumpable(dir) then
                try_unlink_current()
            end
        else
            try_unlink_current()
            vim.api.nvim_feedkeys(escaped, "ni", false)
        end
    end
    vim.keymap.set({ "i", "s" }, key, action, { silent = true })
end

function M.setup()
    luasnip.setup({
        update_events = { "InsertLeave", "TextChanged", "TextChangedI", },
        region_check_events = { "CursorMoved" },
        delete_check_events = { "TextChanged" },
    })

    local group = vim.api.nvim_create_augroup("user.config.luasnip", {})
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = group,
        callback = function()
            -- unlink when explicitly leaving insert mode
            -- jumping to the next/prev node also leaves insert mode
            -- but then the `m` state flag is set
            local state = vim.fn.state()
            if not state:match("m") then
                try_unlink_current()
            end
        end,
    })

    map_try_jump("<tab>",   "<tab>", 1)
    map_try_jump("<s-tab>", "<backspace>", -1)

    local function add(lang)
        luasnip.add_snippets(lang, require("config.luasnip.lang." .. lang))
    end
    add("lua")
    add("markdown")
    add("rust")
    add("tex")
end

return M
