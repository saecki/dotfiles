local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

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
    s("accessor", {
        t({ "pub fn " }),
        i(1, { "ident" }),
        t({ "(&self) -> " }),
        i(2, { "type" }),
        t({ " {", "" }),
        t({ "\tself." }),
        f(function(args)
            return args[1][1]
        end, { 1 }),
        t({ " as " }),
        f(function(args)
            return args[1][1]
        end, { 2 }),
        t({ "", "}" }),
        i(0),
    }),
    s("test_fn", {
        t({ "#[test]", "" }),
        t({ "fn " }),
        i(1, { "name" }),
        t({ "() {", "" }),
        t({ "\t" }),
        i(0),
        t({ "", "}" }),
    }),
    s("rfs", {
        t({ "#[rustfmt::skip]" }),
    }),
}
