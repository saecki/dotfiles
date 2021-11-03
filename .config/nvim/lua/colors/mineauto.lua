local function file_exists(path)
    return io.open(path, "r") ~= nil
end

local dir = vim.env.HOME.."/.config/alacritty/colors/current"
if file_exists(dir.."/minedark.yml") then
    return require('colors.minedark')
elseif file_exists(dir.."/minelight.yml") then
    return require('colors.minelight')
else
    return require('colors.minedark')
end
