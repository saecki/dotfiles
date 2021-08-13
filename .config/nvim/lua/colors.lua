local function apply()
    package.loaded['colors.common'] = nil
    package.loaded['colors.mineauto'] = nil
    package.loaded['colors.minedark'] = nil
    package.loaded['colors.minelight'] = nil
    require('colors.mineauto').apply()
    require('config.lualine').setup()
end

return {
    apply = apply,
}
