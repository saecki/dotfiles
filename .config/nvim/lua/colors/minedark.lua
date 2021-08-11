local palette = {
    dred         = '#cc241d',
    dgreen       = '#98971a',
    dyellow      = '#d79921',
    dblue        = '#458588',
    dpurple      = '#b16286',
    dcyan        = '#689d6a',

    lred         = '#fb4934',
    lgreen       = '#b8bb26',
    lyellow      = '#fabd2f',
    lblue        = '#83a598',
    lpurple      = '#d3869b',
    lcyan        = '#8ec07c',
    
    texthl1      = '#585858',
    texthl2      = '#5f5f87',
    
    invtext      = '#282828',
    text2        = '#ebdbb2',
    text3        = '#a89d8e',

    surface1     = '#4e4e4e',
    surface2     = '#3a3a3a',
    surface3     = '#282828',
    
    scrollbg     = '#444444',
    scrollfg     = '#a8a8a8',
}

local highlights = {
    -- editor
    SignColumn      = {                      bg='none',                         },
    LineNr          = { fg=palette.lyellow,                                     },
    CursorLineNr    = { fg=palette.lyellow,                                     },
    CursorColumn    = {                      bg=palette.texthl2,                },
    Pmenu           = { fg=palette.text2,    bg=palette.surface3,               },
    PmenuSel        = { fg=palette.surface3, bg=palette.text3,    style='bold', },
    PmenuSBar       = {                      bg=palette.scrollbg,               },
    PmenuThumb      = {                      bg=palette.scrollfg,               },
    Visual          = {                      bg=palette.texthl1,                },
    VertSplit       = {                      bg='none',                         },

    -- syntax
    Title           = { fg='#ffd7ff',                                           },
    Comment         = { fg=palette.text3,                                       },
    Constant        = { fg=palette.lpurple,                       style='none', },
    Identifier      = { fg=palette.lcyan,                         style='bold', },
    Statement       = { fg=palette.lyellow,                                     },
    PreProc         = { fg='#00afff',                                           },
    Type            = { fg='#5fd7af',                                           },
    Special         = { fg='#afafff',                                           },
    Error           = {                      bg=palette.lred,                   },
    Todo            = { fg='#afff00',        bg='none',           style='bold', },
    Directory       = { fg=palette.lgreen,                                      },
    Normal          = {                                           style='none', },
    Search          = { fg=palette.invtext,  bg=palette.lyellow,                },
    NonText         = { fg=palette.dblue,                         style='none', },

    -- git
    diffAdded       = { fg=palette.dgreen,                                      },
    diffRemoved     = { fg=palette.dred,                                        },
    GitGutterAdd    = { fg=palette.text2,    bg='#5f875f',                      },
    GitGutterChange = { fg=palette.text2,    bg='#5f5f87',                      },
    GitGutterDelete = { fg=palette.text2,    bg='#af5f5f',                      },

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
    b = { bg = palette.surface2, fg = palette.text2                 },
    c = { bg = palette.surface3, fg = palette.text3                 },
  },
  insert = {
    a = { bg = palette.surface1, fg = palette.lgreen,  gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2                 },
    c = { bg = palette.surface3, fg = palette.text3                 },
  },
  visual = {
    a = { bg = palette.surface1, fg = palette.lpurple, gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2                 },
    c = { bg = palette.surface3, fg = palette.text3                 },
  },
  replace = {
    a = { bg = palette.surface1, fg = palette.lred,    gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2                 },
    c = { bg = palette.surface3, fg = palette.text3                 },
  },
  command = {
    a = { bg = palette.surface1, fg = palette.lblue,   gui = 'bold' },
    b = { bg = palette.surface2, fg = palette.text2                 },
    c = { bg = palette.surface3, fg = palette.text3                 },
  },
  inactive = {
    a = { bg = palette.surface3, fg = palette.text3                 },
    b = { bg = palette.surface3, fg = palette.text3                 },
    c = { bg = palette.surface3, fg = palette.text3                 },
  }
}

local function apply()
    vim.g.colors_name = 'minedark'

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
