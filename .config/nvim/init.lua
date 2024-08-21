local function load_and_setup(name)
    local ok, mod = pcall(require, name)
    if not ok then
        vim.notify(string.format("failed to load `%s`:\n%s", name, mod))
        return
    end

    local ok, res = pcall(mod.setup)
    if not ok then
        vim.notify(string.format("failed to run setup for `%s`:\n%s", name, res))
    end
end

vim.loader.enable()

load_and_setup("globals")
load_and_setup("util.select")
load_and_setup("options")
load_and_setup("colors")
load_and_setup("mappings")
load_and_setup("diagnostic")
load_and_setup("lang.zig")
load_and_setup("lang.rust")
load_and_setup("lang.lua")
load_and_setup("plugins")
