local M = {}

function M.setup()
    function P(...)
        local args = { ... }
        local keys = {}
        for key, _ in pairs(args) do
            table.insert(keys, key)
        end
        table.sort(keys)
        for _, key in ipairs(keys) do
            print(vim.inspect(args[key]))
        end
    end

    function TRACE(title)
        local now = vim.uv.hrtime()
        if title then
            local diff = math.floor((now - M.start) / 1000)
            print(string.format("%10dus %s", diff, title))
        end
        M.start = now
    end
end

return M
