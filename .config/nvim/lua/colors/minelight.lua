local common = require('colors.common')

local palette = {
    bg           = '#ffffff',
    fg           = '#31313a',

    dred         = '#dd241d',
    dgreen       = '#98ae0f',
    dyellow      = '#f09300',
    dblue        = '#46a5a9',
    dpurple      = '#c15296',
    dcyan        = '#689d6a',

    lred         = '#fb4934',
    lgreen       = '#b8cb1c',
    lyellow      = '#fca829',
    lblue        = '#83b5aa',
    lpurple      = '#d75f87',
    lcyan        = '#7aba63',

    texthl1      = '#e8e8e8',
    texthl2      = '#d7d7ff',

    invtext      = '#dedede',
    text2        = '#585858',
    text3        = '#808080',

    surface1     = '#d0d0d0',
    surface2     = '#dadada',
    surface3     = '#eeeeee',

    scrollbg     = '#dadada',
    scrollfg     = '#a8a8a8',

    title        = '#b059b0',
    preproc      = '#0087ff',
    type         = '#00b997',
    special      = '#875fd7',
    todo         = '#00d700',
    nontext      = '#b1c9c8',
    folded       = '#3e70bc',

    diff_a_bg    = '#ccfbba',
    diff_c_bg    = '#c7dcff',
    diff_d_bg    = '#ffbdbd',
    diff_cd_bg   = '#d0b6ff',
}

local highlights = common.get_highlights(palette)
local lualine    = common.get_lualine(palette)

local function apply()
    vim.g.colors_name = 'minelight'

    common.apply_term_colors(palette)
    common.apply_highlights(highlights)
end

return {
    palette = palette,
    highlights = highlights,
    lualine = lualine,
    apply = apply,
}
