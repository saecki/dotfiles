local palette = {
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
    lpurple      = '#e386bb',
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
}

local highlights = {
    -- editor
    SignColumn      = {                      bg='none',                         },
    LineNr          = { fg=palette.lyellow,                                     },
    CursorLineNr    = { fg=palette.lyellow,                       style='bold', },
    CursorColumn    = {                      bg=palette.texthl2,                },
    Pmenu           = { fg=palette.text2,    bg=palette.surface3,               },
    PmenuSel        = { fg=palette.surface3, bg=palette.text3,    style='bold', },
    PmenuSBar       = {                      bg=palette.scrollbg,               },
    PmenuThumb      = {                      bg=palette.scrollfg,               },
    Visual          = {                      bg=palette.texthl1,                },
    VertSplit       = {                      bg='none',                         },

    -- syntax
    Title           = { fg='#dd70dd',                                           },
    Comment         = { fg=palette.text3,                                       },
    Constant        = { fg=palette.lpurple,                       style='none', },
    Identifier      = { fg=palette.lcyan,                         style='bold', },
    Statement       = { fg=palette.lyellow,                                     },
    PreProc         = { fg='#0087ff',                                           },
    Type            = { fg='#00d7af',                                           },
    Special         = { fg='#875fd7',                                           },
    Error           = {                      bg=palette.lred,                   },
    Todo            = { fg='#875fd7',        bg='none',           style='bold', },
    Directory       = { fg=palette.lgreen,                                      },
    Normal          = {                                           style='none', },
    Search          = { fg=palette.invtext,  bg=palette.lyellow,                },
    MatchParen      = {                      bg=palette.texthl2,                },
    NonText         = { fg='#95b6ae',                             style='none', },

    -- git
    diffAdded       = { fg=palette.dgreen,                                      },
    diffRemoved     = { fg=palette.dred,                                        },
    GitGutterAdd    = { fg=palette.text2,    bg='#b7fb9d',                      },
    GitGutterChange = { fg=palette.text2,    bg='#b8d3ff',                      },
    GitGutterDelete = { fg=palette.text2,    bg='#ff8a8a',                      },

    -- lsp ocurrences
    LspReferenceText  = { bg=palette.texthl2 },
    LspReferenceRead  = { bg=palette.texthl2 },
    LspReferenceWrite = { bg=palette.texthl2 },

    -- lsp diagnostics
    LspDiagnosticsVirtualTextError   = { fg=palette.dred,                       },
    LspDiagnosticsVirtualTextWarning = { fg=palette.dyellow,                    },
    LspDiagnosticsVirtualTextHint    = { fg=palette.lblue,                      },
    LspDiagnosticsVirtualTextInfo    = { fg=palette.lblue,                      },

    LspDiagnosticsSignError          = { fg=palette.dred,    style='bold',      },
    LspDiagnosticsSignWarning        = { fg=palette.dyellow, style='bold',      },
    LspDiagnosticsSignHint           = { fg=palette.lblue,   style='bold',      },
    LspDiagnosticsSignInfo           = { fg=palette.lblue,   style='bold',      },

    LspDiagnosticsFloatingError      = { fg=palette.dred,                       },
    LspDiagnosticsFloatingWarning    = { fg=palette.dyellow,                    },
    LspDiagnosticsFloatingHint       = { fg=palette.lblue,                      },
    LspDiagnosticsFloatingInfo       = { fg=palette.lblue,                      },

    LspDiagnosticsUnderlineError     = { sp=palette.dred,    style='undercurl', },
    LspDiagnosticsUnderlineWarning   = { sp=palette.dyellow, style='undercurl', },
    LspDiagnosticsUnderlineHint      = { sp=palette.lblue,   style='undercurl', },
    LspDiagnosticsUnderlineInfo      = { sp=palette.lblue,   style='undercurl', },
}

local lualine = {
  normal = {
    a = { bg = palette.surface1, fg = palette.lyellow, gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2,                },
    c = { bg = palette.surface3, fg = palette.text3,                },
  },
  insert = {
    a = { bg = palette.surface1, fg = palette.lgreen,  gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2,                },
    c = { bg = palette.surface3, fg = palette.text3,                },
  },
  visual = {
    a = { bg = palette.surface1, fg = palette.lpurple, gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2,                },
    c = { bg = palette.surface3, fg = palette.text3,                },
  },
  replace = {
    a = { bg = palette.surface1, fg = palette.lred,    gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2,                },
    c = { bg = palette.surface3, fg = palette.text3,                },
  },
  command = {
    a = { bg = palette.surface1, fg = palette.lblue,   gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2,                },
    c = { bg = palette.surface3, fg = palette.text3,                },
  },
  inactive = {
    a = { bg = palette.surface3, fg = palette.text3,                },
    b = { bg = palette.surface3, fg = palette.text3,                },
    c = { bg = palette.surface3, fg = palette.text3,                },
  }
}

local function apply()
    vim.g.colors_name = 'minelight'

    local common = require('colors.common')
    common.terminal_colors(palette)
    common.highlights(highlights)
end

return {
    palette = palette,
    highlights = highlights,
    lualine = lualine,
    apply = apply,
}
