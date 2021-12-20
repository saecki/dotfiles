local M = {}

M.actions = {}

function M.setup()
    M.actions = {}
end

function M.action(num)
    local a = M.actions[num]
    a.func(unpack(a.args))
end

function M.rhs(rhs, ...)
    if type(rhs) == "function" then
        table.insert(M.actions, { func = rhs, args = {...} })
        local luaexpr = "lua require('util.maps').action(" .. #M.actions .. ")"
        return "<cmd>" .. luaexpr .. "<cr>"
    else
        return rhs
    end
end

return M
