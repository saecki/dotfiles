local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

-- stylua: ignore start
return {
    s("stateful_atom", {
        t({ "let bounds = find_bounds(reader, size)?;", "" }),
        t({ "let mut " }),
        i(1, { "fourcc" }),
        t({ " = Self {", "" }),
        t({ "\tstate: State::Existing(bounds),", "" }),
        t({ "\t..Default::default()", "" }),
        t({ "};" }),
        i(0),
    }),
}
-- stylua: ignore end
