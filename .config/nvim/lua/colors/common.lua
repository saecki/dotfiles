local function get_highlights(palette)
    return {
        -- editor
        Normal          = { fg=palette.fg,       bg=palette.bg,                     },
        SignColumn      = {                      bg='none',                         },
        LineNr          = { fg=palette.text3,                                       },
        CursorLineNr    = { fg=palette.text2,                         style='bold', },
        CursorColumn    = {                      bg=palette.texthl2,                },
        Pmenu           = { fg=palette.text2,    bg=palette.surface3,               },
        PmenuSel        = { fg=palette.surface3, bg=palette.text3,    style='bold', },
        PmenuSBar       = {                      bg=palette.scrollbg,               },
        PmenuThumb      = {                      bg=palette.scrollfg,               },
        Visual          = {                      bg=palette.texthl1,                },
        VertSplit       = {                      bg='none',                         },

        -- syntax
        Title           = { fg=palette.title,                         style='bold', },
        Comment         = { fg=palette.text3,                                       },
        Constant        = { fg=palette.lpurple,                       style='none', },
        Identifier      = { fg=palette.lcyan,                         style='bold', },
        Statement       = { fg=palette.lyellow,                                     },
        PreProc         = { fg=palette.preproc,                                     },
        Type            = { fg=palette.type,                                        },
        Special         = { fg=palette.special,                                     },
        Error           = {                      bg=palette.lred,                   },
        Todo            = { fg=palette.todo,     bg='none',           style='bold', },
        Directory       = { fg=palette.lgreen,                                      },
        Search          = { fg=palette.invtext,  bg=palette.lyellow,                },
        MatchParen      = {                      bg=palette.texthl2,                },
        NonText         = { fg=palette.nontext,                       style='none', },
        Folded          = { fg=palette.folded,   bg=palette.texthl2,  style='none', },

        -- treesitter
        TSInclude       = { fg=palette.lyellow,                                     },
        TSNamespace     = { fg=palette.preproc,                                     },

        -- git
        diffAdded       = {                   bg=palette.diff_a_bg,                },
        diffRemoved     = {                   bg=palette.diff_d_bg,                },

        DiffAdd         = {                   bg=palette.diff_a_bg,                },
        DiffChange      = {                   bg=palette.diff_c_bg,                },
        DiffDelete      = {                   bg=palette.diff_d_bg,                },
        DiffText        = { fg=palette.text2, bg=palette.diff_cd_bg, style='bold', },

        GitSignsAdd     = {                   bg=palette.diff_a_bg,                },
        GitSignsChange  = {                   bg=palette.diff_c_bg,                },
        GitSignsDelete  = { fg=palette.lred,                         style='bold', },
        GitSignsChgDel  = { fg=palette.lred,  bg=palette.diff_c_bg,  style='bold', },

        -- lsp ocurrences
        LspReferenceText  = { bg=palette.texthl2 },
        LspReferenceRead  = { bg=palette.texthl2 },
        LspReferenceWrite = { bg=palette.texthl2 },

        -- lsp diagnostics
        LspDiagnosticsVirtualTextError   = { fg=palette.dred,                       },
        LspDiagnosticsVirtualTextWarning = { fg=palette.dyellow,                    },
        LspDiagnosticsVirtualTextHint    = { fg=palette.lblue,                      },
        LspDiagnosticsVirtualTextInfo    = { fg=palette.lblue,                      },

        LspDiagnosticsSignError          = { fg=palette.lred,    style='bold',      },
        LspDiagnosticsSignWarning        = { fg=palette.lyellow, style='bold',      },
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
end

local function get_lualine(palette)
    return {
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
end

local function apply_term_colors(palette)
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

local function apply_highlights(highlights)
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
    get_highlights = get_highlights,
    get_lualine = get_lualine,
    apply_term_colors = apply_term_colors,
    apply_highlights = apply_highlights,
}
