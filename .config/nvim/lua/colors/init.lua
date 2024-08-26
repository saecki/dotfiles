local M = {}

local function read_current_colorscheme(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    local current = nil

    while current == nil do
        local text = file:read("*l")
        if text == nil then
            break
        end
        current = text:match("^%s*current: (.*)$")
    end
    file:close()

    return current
end

function M.update_colorscheme()
    local dir = vim.fn.expand("~/.config/alco/alco.yml")
    local current = read_current_colorscheme(dir)
    if current == "dark" then
        vim.cmd.colorscheme("minedark")
    elseif current == "light" then
        vim.cmd.colorscheme("minelight")
    else
        vim.cmd.colorscheme("minedark")
    end
end

function M.setup()
    M.update_colorscheme()
end

function M.reload()
    package.loaded["colors.common"] = nil
    package.loaded["colors.minedark"] = nil
    package.loaded["colors.minelight"] = nil
    M.update_colorscheme()
end

return M
