local function error_handler(name)
    return function(err)
        local text = "Failed to load module '" .. name .. "':\n" .. (err or "")
        vim.notify(text, vim.log.levels.ERROR)
        return err
    end
end

local function prequire(name, setup)
    local ok, mod = xpcall(function()
        return require(name)
    end, error_handler(name))
    if not ok then
        return
    end

    if setup ~= false then
        xpcall(mod.setup, error_handler(name))
    end

    return mod
end

prequire("globals")
prequire("util.select")
prequire("options")
prequire("colors")
prequire("plugins")
prequire("diagnostic")
prequire("mappings")
