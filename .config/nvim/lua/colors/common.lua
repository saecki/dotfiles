local function terminal_colors(palette)
    vim.g.terminal_color_1  = palette.dred
    vim.g.terminal_color_2  = palette.dgreen
    vim.g.terminal_color_3  = palette.dyellow
    vim.g.terminal_color_4  = palette.dblue
    vim.g.terminal_color_5  = palette.dviolet
    vim.g.terminal_color_6  = palette.dcyan
    
    vim.g.terminal_color_9  = palette.lred
    vim.g.terminal_color_10 = palette.lgreen
    vim.g.terminal_color_11 = palette.lyellow
    vim.g.terminal_color_12 = palette.lblue
    vim.g.terminal_color_13 = palette.lviolet
    vim.g.terminal_color_14 = palette.lcyan
end

local function highlights(highlights)
    vim.api.nvim_command('hi clear')
    vim.o.termguicolors = true

    for group, colors in pairs(highlights) do
        local style = colors.style and 'gui='   .. colors.style or 'gui=NONE'
        local fg    = colors.fg    and 'guifg=' .. colors.fg    or 'guifg=NONE'
        local bg    = colors.bg    and 'guibg=' .. colors.bg    or 'guibg=NONE'
        local sp    = colors.sp    and 'guisp=' .. colors.sp    or ''
        vim.api.nvim_command('highlight ' .. group .. ' ' .. style .. ' ' .. fg .. ' ' .. bg..' '..sp)
    end
end

return {
    terminal_colors = terminal_colors,
    highlights = highlights,
}
