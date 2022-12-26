local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

local function bash(_, _, command)
    local file = io.popen(command, "r")
    local res = {}
    for line in file:lines() do
        table.insert(res, line)
    end
    return res
end

return {
    s("pwd", f(bash, {}, { user_args = { "pwd" } })),
    s("ls", f(bash, {}, { user_args = { "ls" } })),
    s("lsa", f(bash, {}, { user_args = { "ls -A" } })),
    s("date", f(bash, {}, { user_args = { "date '+%Y-%m-%d'" } })),
    s("datetime", f(bash, {}, { user_args = { "date '+%Y-%m-%d %H:%M:%S'" } })),
    s("time", f(bash, {}, { user_args = { "date '+%H:%M:%S'" } })),

    s("figlet", {
        i(1, { "input" }),
        t({ "", "" }),
        f(
            function(args) return bash(nil, nil, "figlet " .. args[1][1]) end,
            {1}
        )
    }),

    s("forall", t("∀")),
    s("exists", t("∃")),
    s("in", t("∈")),
    s("notin", t("∉")),
    s("subset", t("⊆")),
    s("subsetnoteq", t("⊂")),
    s("intersect", t("∩")),
    s("union", t("∪")),
    s("setmin", t("∖")),

    s("land", t("∧")),
    s("lor", t("∨")),
    s("xor", t("⊻")),
}
