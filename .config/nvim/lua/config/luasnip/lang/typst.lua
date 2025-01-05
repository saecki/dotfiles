local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

return {
    s("code", {
        t({ "#code(", "" }),
        t({ "\t```", }),
        i(1, { "<lang>" }),
        t({ "", "\t" }),
        i(0, { "" }),
        t({ "", "\t```", "" }),
        t({ ")", }),
    }),
}
