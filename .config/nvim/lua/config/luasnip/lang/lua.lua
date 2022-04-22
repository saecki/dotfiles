local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

return {
    s("which-key", t('local wk = require("which-key")')),
    s("require", {
        t({ 'require("' }),
        i(0, { "mod" }),
        t({ '")' }),
    }),
    s("entry", {
        t({ '["' }),
        i(1, { "key" }),
        t({ '"] = ' }),
        i(0, { "val" }),
        t({ "," }),
    }),
    s("module", {
        t({ "local M = {}", "", "function M.setup()", "\t" }),
        i(0, { "" }),
        t({ "", "end", "", "return M" }),
    }),
    s("lspmodule", {
        t({ "local M = {}", "", "function M.setup(server, on_init, on_attach, capabilities)", "" }),
        t({
            "\tserver:setup ({",
            "\t\ton_init = on_init,",
            "\t\ton_attach = on_attach,",
            "\t\tcapabilities = capabilities,",
            "\t\t",
        }),
        i(0, { "" }),
        t({ "", "\t})", "end", "", "return M" }),
    }),
}
