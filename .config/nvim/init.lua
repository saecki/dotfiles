local function error_handler(err)
    return err
end

local function prequire(name, setup)
    local ok, mod = xpcall(function()
        return require(name)
    end, error_handler)
    if not ok then
        vim.notify("Failed to load config module " .. name, vim.log.levels.ERROR .. "\n" .. (mod or ""))
        return
    end

    if setup ~= false then
        local ok, res = xpcall(mod.setup, error_handler)

        if not ok then
            vim.notify("Failed to setup config module " .. name, vim.log.levels.ERROR .. "\n" .. res)
        end
    end

    return mod
end

prequire("impatient", false)

prequire("globals", false)
prequire("util.select")
prequire("options")
prequire("mappings")
prequire("colors")
prequire("diagnostic")
prequire("plugins")
