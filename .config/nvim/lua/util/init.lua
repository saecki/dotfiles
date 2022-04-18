local M = {}

if jit ~= nil then
    M.is_windows = jit.os == "Windows"
else
    M.is_windows = package.config:sub(1, 1) == "\\"
end

function M.path_separator()
    if M.is_windows then
        return "\\"
    end
    return "/"
end

function M.join_paths(...)
    local separator = M.path_separator()
    return table.concat({ ... }, separator)
end

function M.wrap(fun, ...)
    local args = { ... }
    return function()
        return fun(unpack(args))
    end
end

return M
