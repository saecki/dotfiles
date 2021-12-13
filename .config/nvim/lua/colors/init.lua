local M = {}

function M.setup()
    require("colors.mineauto").setup()
end

function M.reload()
    package.loaded["colors.common"] = nil
    package.loaded["colors.mineauto"] = nil
    package.loaded["colors.minedark"] = nil
    package.loaded["colors.minelight"] = nil
    require("colors.mineauto").setup()
    require("config.lualine").setup()
end

return M
