function P(...)
    local args = {...}
    for _,a in pairs(args) do
        print(vim.inspect(a))
    end
end
