local M = {}

function M.setup()
    function P(...)
        local args = table.pack(...)
        for i = 1, args.n, 1 do
            print(vim.inspect(args[i]))
        end
    end
end

return M
