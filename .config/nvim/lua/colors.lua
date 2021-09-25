local M = {}

function M.setup()
    package.loaded['colors.common'] = nil
    package.loaded['colors.mineauto'] = nil
    package.loaded['colors.minedark'] = nil
    package.loaded['colors.minelight'] = nil
    require('colors.mineauto').setup()
    require('config.lualine').setup()
end

return M
