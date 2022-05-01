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

    local function add(lang)
        luasnip.add_snippets(lang, require("config.luasnip.lang."..lang))
    end
    add("lua")
    add("markdown")
    add("rust")
    add("tex")
end

return M
