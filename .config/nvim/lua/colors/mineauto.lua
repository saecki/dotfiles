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

local dir = vim.env.HOME .. "/.config/alco/alco.yml"
local current = read_current_colorscheme(dir)
if current == "minedark" then
    return require("colors.minedark")
elseif current == "minelight" then
    return require("colors.minelight")
else
    return require("colors.minedark")
end
