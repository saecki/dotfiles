local M = {}

function M.setup()
    function P(...)
        local args = table.pack(...)
        for i = 1, args.n, 1 do
            print(vim.inspect(args[i]))
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
