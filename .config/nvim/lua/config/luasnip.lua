local M = {}

local luasnip = require('luasnip')
local s = luasnip.snippet
local f = luasnip.function_node

local function bash(_, _, command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

function M.setup()
    luasnip.snippets.all = {
		s("pwd", f(bash, {}, "pwd")),
		s("ls",  f(bash, {}, "ls")),
		s("lsa",  f(bash, {}, "ls -A")),
		s("date",  f(bash, {}, "date --iso-8601=date")),
    }
end

return M
