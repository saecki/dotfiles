local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

return {
    s("sec", {
        t({ "\\section*{" }),
        i(1, { "" }),
        t({ "}" }),
        i(0, { "" }),
    }),
    s("subsec", {
        t({ "\\subsection*{" }),
        i(1, { "" }),
        t({ ")}" }),
        i(0, { "" }),
    }),
}
