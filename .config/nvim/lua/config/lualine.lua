local modemap = {
    ['n']    = 'N ',
    ['no']   = 'O ',
    ['nov']  = 'O ',
    ['noV']  = 'O ',
    ['no'] = 'O ',
    ['niI']  = 'N ',
    ['niR']  = 'N ',
    ['niV']  = 'N ',
    ['v']    = 'V ',
    ['V']    = 'VL',
    ['']   = 'VB',
    ['s']    = 'S ',
    ['S']    = 'SL',
    ['']   = 'SB',
    ['i']    = 'I ',
    ['ic']   = 'I ',
    ['ix']   = 'I ',
    ['R']    = 'R ',
    ['Rc']   = 'R ',
    ['Rv']   = 'VR',
    ['Rx']   = 'R ',
    ['c']    = 'C ',
    ['cv']   = 'EX',
    ['ce']   = 'EX',
    ['r']    = 'R ',
    ['rm']   = 'MORE',
    ['r?']   = 'CONFIRM',
    ['!']    = 'SHELL',
    ['t']    = 'TERMINAL',
}
local function mode()
    local mode_code = vim.api.nvim_get_mode().mode
    if modemap[mode_code] == nil then return mode_code end
    return modemap[mode_code]
end

local function file_format()
    return vim.bo.fileformat
end

local function position()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local linecount = vim.api.nvim_buf_line_count(0)
    local linedigits = math.floor(math.log10(linecount)) + 1
    
    local template = "%" .. linedigits .. "d:%-2d"
    return string.format(template, cursor[1], cursor[2])
end

local function setup()
    local colors = require('colors.mineauto')
    local theme = colors.lualine
    local palette = colors.palette

    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = theme,
            section_separators = { '', '' },
            component_separators = { '│', '│' },
        },
        sections = {
            lualine_a = { mode },
            lualine_b = { require('lsp-status').status },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { file_format, 'encoding', 'filetype' },
            lualine_y = { 'branch' },
            lualine_z = {
                position,
                { 
                    'diagnostics',
                    sources = { 'nvim_lsp' },
                    sections = { 'error', 'warn', 'info', 'hint' },
                    symbols = { error = ' ', warn = ' ', info = 'I', hint = 'H' },
                    color_error = palette.lred,
                    color_warn  = palette.lyellow,
                    color_info  = palette.lcyan,
                    color_hint  = palette.lcyan,
                } 
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {}
    }
end

return {
    setup = setup,
}
