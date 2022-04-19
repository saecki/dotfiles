local function prequire(name, setup)
    local ok, mod = pcall(require, name)
    if not ok then
        vim.notify("Failed to load config module " .. name, vim.log.levels.ERROR)
        return
    end

    if setup ~= false then
        local ok = pcall(mod.setup)
        if not ok then
            vim.notify("Failed to setup config module " .. name, vim.log.levels.ERROR)
        end
    end

    return mod
end

pcall(require, "impatient")

prequire("globals", false)
prequire("util.select")
prequire("options")
prequire("mappings")
prequire("colors")
prequire("diagnostic")
prequire("plugins")
