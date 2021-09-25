function P(...)
    for _,v in ipairs(table.pack(...)) do
        print(vim.inspect(v))
    end
end
