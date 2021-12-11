local M = {}

function M.get_highlights(pal)
    return {
        -- editor
        Normal          = { fg=pal.fg,       bg=pal.bg,                       },
        SignColumn      = {                  bg='none',                       },
        LineNr          = { fg=pal.text3,                                     },
        CursorLineNr    = { fg=pal.text2,                       style='bold', },
        CursorColumn    = {                  bg=pal.texthl2,                  },
        Pmenu           = { fg=pal.text2,    bg=pal.surface3,                 },
        PmenuSel        = { fg=pal.surface3, bg=pal.text3,      style='bold', },
        PmenuSBar       = {                  bg=pal.scrollbg,                 },
        PmenuThumb      = {                  bg=pal.scrollfg,                 },
        Visual          = {                  bg=pal.texthl1,                  },
        VertSplit       = { fg=pal.text2,    bg='none',                       },
        StatusLineNC    = { fg='none',       bg='none',                       },

        -- syntax
        Title           = { fg=pal.title,                       style='bold', },
        Comment         = { fg=pal.text3,                                     },
        Constant        = { fg=pal.lpurple,                     style='none', },
        Identifier      = { fg=pal.lcyan,                       style='bold', },
        Statement       = { fg=pal.lyellow,                                   },
        PreProc         = { fg=pal.preproc,                                   },
        Type            = { fg=pal.type,                                      },
        Special         = { fg=pal.special,                                   },
        Error           = {                  bg=pal.lred,                     },
        Todo            = { fg=pal.todo,     bg='none',         style='bold', },
        Directory       = { fg=pal.lgreen,                                    },
        Search          = { fg=pal.invtext,  bg=pal.lyellow,                  },
        MatchParen      = {                  bg=pal.texthl2,                  },
        NonText         = { fg=pal.nontext,                     style='none', },
        Folded          = { fg=pal.folded,   bg=pal.texthl2,    style='none', },

        -- treesitter
        TSInclude       = { fg=pal.lyellow,                                   },
        TSNamespace     = { fg=pal.preproc,                                   },

        -- git
        diffAdded       = {                  bg=pal.diff_a_bg,                },
        diffRemoved     = {                  bg=pal.diff_d_bg,                },

        DiffAdd         = {                  bg=pal.diff_a_bg,                },
        DiffChange      = {                  bg=pal.diff_c_bg,                },
        DiffDelete      = {                  bg=pal.diff_d_bg,                },
        DiffText        = { fg=pal.text2,    bg=pal.diff_cd_bg, style='bold', },

        -- gitsigns
        GitSignsAdd     = { fg=pal.diff_a_fg  },
        GitSignsChange  = { fg=pal.diff_c_fg  },
        GitSignsDelete  = { fg=pal.diff_d_fg  },
        GitSignsChgDel  = { fg=pal.diff_cd_fg },

        GitSignsAddLn     = { bg=pal.diff_a_bg  },
        GitSignsChangeLn  = { bg=pal.diff_c_bg  },
        GitSignsDeleteLn  = { bg=pal.diff_d_bg  },
        GitSignsChgDelLn  = { bg=pal.diff_cd_bg },

        GitSignsAddNr     = { bg=pal.diff_a_bg  },
        GitSignsChangeNr  = { bg=pal.diff_c_bg  },
        GitSignsDeleteNr  = { bg=pal.diff_d_bg  },
        GitSignsChgDelNr  = { bg=pal.diff_cd_bg },

        -- nvim-tree
        NvimTreeGitDirty   = { fg = pal.lblue   },
        NvimTreeGitDeleted = { fg = pal.lblue   },
        NvimTreeGitStaged  = { fg = pal.lblue   },
        NvimTreeGitMerge   = { fg = pal.lorange },
        NvimTreeGitRenamed = { fg = pal.lpurple },
        NvimTreeGitNew     = { fg = pal.lgreen  },

        -- lsp diagnostics
        DiagnosticVirtualTextError = { fg=pal.dred,                       },
        DiagnosticVirtualTextWarn  = { fg=pal.dyellow,                    },
        DiagnosticVirtualTextHint  = { fg=pal.lblue,                      },
        DiagnosticVirtualTextInfo  = { fg=pal.lblue,                      },

        DiagnosticSignError        = { fg=pal.lred,    style='bold',      },
        DiagnosticSignWarn         = { fg=pal.lyellow, style='bold',      },
        DiagnosticSignHint         = { fg=pal.lblue,   style='bold',      },
        DiagnosticSignInfo         = { fg=pal.lblue,   style='bold',      },

        DiagnosticFloatingError    = { fg=pal.dred,                       },
        DiagnosticFloatingWarn     = { fg=pal.dyellow,                    },
        DiagnosticFloatingHint     = { fg=pal.lblue,                      },
        DiagnosticFloatingInfo     = { fg=pal.lblue,                      },

        DiagnosticUnderlineError   = { sp=pal.dred,    style='undercurl', },
        DiagnosticUnderlineWarn    = { sp=pal.dyellow, style='undercurl', },
        DiagnosticUnderlineHint    = { sp=pal.lblue,   style='undercurl', },
        DiagnosticUnderlineInfo    = { sp=pal.lblue,   style='undercurl', },

        -- lsp ocurrences
        LspReferenceText  = { bg=pal.texthl2 },
        LspReferenceRead  = { bg=pal.texthl2 },
        LspReferenceWrite = { bg=pal.texthl2 },

        -- dap
        DapBreakpoint = { fg=pal.lred    },
        DapLogPoint   = { fg=pal.lyellow },
        DapStopped    = { fg=pal.lgreen  },
    }
end

function M.get_lualine(pal)
    return {
        normal = {
            a = { bg = pal.surface1, fg = pal.lyellow, gui = 'bold' },
            b = { bg = pal.surface2, fg = pal.text2,                },
            c = { bg = pal.surface3, fg = pal.text3,                },
        },
        insert = {
            a = { bg = pal.surface1, fg = pal.lgreen,  gui = 'bold' },
            b = { bg = pal.surface2, fg = pal.text2,                },
            c = { bg = pal.surface3, fg = pal.text3,                },
        },
        visual = {
            a = { bg = pal.surface1, fg = pal.lpurple, gui = 'bold' },
            b = { bg = pal.surface2, fg = pal.text2,                },
            c = { bg = pal.surface3, fg = pal.text3,                },
        },
        replace = {
            a = { bg = pal.surface1, fg = pal.lred,    gui = 'bold' },
            b = { bg = pal.surface2, fg = pal.text2,                },
            c = { bg = pal.surface3, fg = pal.text3,                },
        },
        command = {
            a = { bg = pal.surface1, fg = pal.lblue,   gui = 'bold' },
            b = { bg = pal.surface2, fg = pal.text2,                },
            c = { bg = pal.surface3, fg = pal.text3,                },
        },
        inactive = {
            a = { bg = pal.surface3, fg = pal.text3,                },
            b = { bg = pal.surface3, fg = pal.text3,                },
            c = { bg = pal.surface3, fg = pal.text3,                },
        }
    }
end

function M.apply_term_colors(pal)
    vim.g.terminal_color_1  = pal.dred
    vim.g.terminal_color_2  = pal.dgreen
    vim.g.terminal_color_3  = pal.dyellow
    vim.g.terminal_color_4  = pal.dblue
    vim.g.terminal_color_5  = pal.dviolet
    vim.g.terminal_color_6  = pal.dcyan

    vim.g.terminal_color_9  = pal.lred
    vim.g.terminal_color_10 = pal.lgreen
    vim.g.terminal_color_11 = pal.lyellow
    vim.g.terminal_color_12 = pal.lblue
    vim.g.terminal_color_13 = pal.lviolet
    vim.g.terminal_color_14 = pal.lcyan
end

function M.apply_highlights(highlights)
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

return M
