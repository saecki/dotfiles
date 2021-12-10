local M = {}

local common = require('colors.common')

M.palette = {
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

    surface1     = '#d8d8d8',
    surface2     = '#e4e4e4',
    surface3     = '#f2f2f2',

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

M.highlights = common.get_highlights(M.palette)
local pal = M.palette
M.lualine = {
    normal = {
        a = { bg = pal.surface1, fg = pal.dyellow, gui = 'bold' },
        b = { bg = pal.surface2, fg = pal.text2,                },
        c = { bg = pal.surface3, fg = pal.text3,                },
    },
    insert = {
        a = { bg = pal.surface1, fg = pal.dgreen,  gui = 'bold' },
        b = { bg = pal.surface2, fg = pal.text2,                },
        c = { bg = pal.surface3, fg = pal.text3,                },
    },
    visual = {
        a = { bg = pal.surface1, fg = pal.dpurple, gui = 'bold' },
        b = { bg = pal.surface2, fg = pal.text2,                },
        c = { bg = pal.surface3, fg = pal.text3,                },
    },
    replace = {
        a = { bg = pal.surface1, fg = pal.dred,    gui = 'bold' },
        b = { bg = pal.surface2, fg = pal.text2,                },
        c = { bg = pal.surface3, fg = pal.text3,                },
    },
    command = {
        a = { bg = pal.surface1, fg = pal.dblue,   gui = 'bold' },
        b = { bg = pal.surface2, fg = pal.text2,                },
        c = { bg = pal.surface3, fg = pal.text3,                },
    },
    inactive = {
        a = { bg = pal.surface3, fg = pal.text3,                },
        b = { bg = pal.surface3, fg = pal.text3,                },
        c = { bg = pal.surface3, fg = pal.text3,                },
    }
}



function M.setup()
    vim.g.colors_name = 'minelight'

    common.apply_term_colors(M.palette)
    common.apply_highlights(M.highlights)
end

return M
