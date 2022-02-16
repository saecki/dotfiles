local M = {}

local wk = require("which-key")
local luasnip = require("luasnip")

function M.setup()
    luasnip.config.setup({
        updateevents = "InsertLeave,TextChanged,TextChangedI",
    })

    wk.register({
        ["<tab>"] = {
            function()
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                end
            end,
            "Jump to next snippet input",
        },
        ["<s-tab>"] = {
            function()
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end,
            "Jump to previous snippet input",
        },
    }, {
        mode = "v",
    })

    luasnip.snippets = {
        lua = require("config.luasnip.lang.lua"),
        markdown = require("config.luasnip.lang.markdown"),
        rust = require("config.luasnip.lang.rust"),
    }
end

return M
