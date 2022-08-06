local M = {}

function M.highlights(pal)
    -- stylua: ignore start
    return {
        -- editor
        Normal          = { fg=pal.fg,       bg=pal.bg,                      },
        SignColumn      = {                  bg="none",                      },
        LineNr          = { fg=pal.text3,                                    },
        CursorLineNr    = { fg=pal.text2,                       style="bold" },
        CursorColumn    = {                  bg=pal.texthl2,                 },
        FloatBorder     = { fg=pal.surface3, bg=pal.bg,                      },
        Pmenu           = { fg=pal.text2,    bg=pal.surface3,                },
        PmenuSel        = {                  bg=pal.surface2,   style="bold" },
        PmenuSBar       = {                  bg=pal.scrollbg,                },
        PmenuThumb      = {                  bg=pal.scrollfg,                },
        Visual          = {                  bg=pal.texthl1,                 },
        VertSplit       = { fg=pal.text3,    bg="none",                      },
        StatusLineNC    = { fg="none",       bg="none",                      },

        -- syntax
        Title           = { fg=pal.title,                       style="bold" },
        Comment         = { fg=pal.text3,                                    },
        Constant        = { fg=pal.lpurple,                     style="none" },
        Identifier      = { fg=pal.lblue,                       style="bold" },
        Function        = { fg=pal.lcyan,                       style="bold" },
        Statement       = { fg=pal.lyellow,                                  },
        PreProc         = { fg=pal.preproc,                                  },
        Type            = { fg=pal.type,                                     },
        Special         = { fg=pal.special,                                  },
        Error           = {                  bg=pal.lred,                    },
        Todo            = { fg=pal.todo,     bg="none",         style="bold" },
        Directory       = { fg=pal.lgreen,                                   },
        Search          = { fg=pal.invtext,  bg=pal.lyellow,                 },
        MatchParen      = {                  bg=pal.texthl2,                 },
        NonText         = { fg=pal.nontext,                     style="none" },
        Whitespace      = { fg=pal.whitespace,                  style="none" },
        Folded          = { fg=pal.folded,   bg=pal.folded_bg,  style="none" },

        -- treesitter
        TSProperty      = { fg=pal.lcyan,                       style="bold" },
        TSInclude       = { fg=pal.lyellow,                                  },
        TSNamespace     = { fg=pal.preproc,                                  },

        -- cmp
        CmpItemMenuDefault      = { fg=pal.text3,   style="italic" },
        CmpItemKindDefault      = { fg=pal.special, style="bold"   },
        CmpItemKindModule       = { fg=pal.preproc, style="bold"   },
        CmpItemKindClass        = { fg=pal.type,    style="bold"   },
        CmpItemKindStruct       = { fg=pal.type,    style="bold"   },
        CmpItemKindInterface    = { fg=pal.type,    style="bold"   },
        CmpItemKindTypeParamter = { fg=pal.type,    style="bold"   },
        CmpItemKindEnum         = { fg=pal.type,    style="bold"   },
        CmpItemKindEnumMember   = { fg=pal.lpurple, style="bold"   },
        CmpItemKindConstant     = { fg=pal.lpurple, style="bold"   },
        CmpItemKindField        = { fg=pal.lblue,   style="bold"   },
        CmpItemKindProperty     = { fg=pal.lblue,   style="bold"   },
        CmpItemKindVariable     = { fg=pal.special, style="bold"   },
        CmpItemKindFunction     = { fg=pal.lcyan,   style="bold"   },
        CmpItemKindMethod       = { fg=pal.lcyan,   style="bold"   },
        CmpItemKindConstructor  = { fg=pal.lcyan,   style="bold"   },
        CmpItemKindKeyword      = { fg=pal.lyellow, style="bold"   },
        CmpItemKindOperator     = { fg=pal.lyellow, style="bold"   },

        -- git
        diffAdded       = {                   bg=pal.diff_a_bg,               },
        diffRemoved     = {                   bg=pal.diff_d_bg,               },

        DiffAdd         = {                   bg=pal.diff_a_bg,               },
        DiffChange      = {                   bg=pal.diff_c_bg,               },
        DiffDelete      = { fg=pal.diff_d_fg, bg=pal.diff_d_bg,               },
        DiffText        = { fg=pal.text2,     bg=pal.diff_cd_bg, style="bold" },

        -- gitsigns
        GitSignsAdd       = { fg=pal.diff_a_fg  },
        GitSignsChange    = { fg=pal.diff_c_fg  },
        GitSignsDelete    = { fg=pal.diff_d_fg  },
        GitSignsChgDel    = { fg=pal.diff_cd_fg },

        GitSignsAddLn     = { bg=pal.diff_a_bg  },
        GitSignsChangeLn  = { bg=pal.diff_c_bg  },
        GitSignsDeleteLn  = { bg=pal.diff_d_bg  },
        GitSignsChgDelLn  = { bg=pal.diff_cd_bg },

        GitSignsAddNr     = { bg=pal.diff_a_bg  },
        GitSignsChangeNr  = { bg=pal.diff_c_bg  },
        GitSignsDeleteNr  = { bg=pal.diff_d_bg  },
        GitSignsChgDelNr  = { bg=pal.diff_cd_bg },

        -- nvim-tree
        NvimTreeGitDirty   = { fg=pal.dblue   },
        NvimTreeGitDeleted = { fg=pal.dblue   },
        NvimTreeGitStaged  = { fg=pal.dblue   },
        NvimTreeGitMerge   = { fg=pal.dyellow },
        NvimTreeGitRenamed = { fg=pal.dpurple },
        NvimTreeGitNew     = { fg=pal.dgreen  },

        -- harpoon
        HarpoonWindow = { link = "Pmenu"       },
        HarpoonBorder = { link = "FloatBorder" },

        -- telescope
        FloatTitle             = { fg=pal.text3, bg=pal.surface3 },
        TelescopeResultsNormal = { link = "Pmenu"       },
        TelescopeResultsBorder = { link = "FloatBorder" },
        TelescopeResultsTitle  = { link = "FloatTitle"  },
        TelescopePromptNormal  = { link = "Pmenu"       },
        TelescopePromptBorder  = { link = "FloatBorder" },
        TelescopePromptTitle   = { link = "FloatTitle"  },
        TelescopePreviewNormal = { link = "Pmenu"       },
        TelescopePreviewBorder = { link = "FloatBorder" },
        TelescopePreviewTitle  = { link = "FloatTitle"  },

        -- which-key
        WhichKey = { fg = pal.special },

        -- indent-blankline
        IndentBlanklineChar      = { fg = pal.whitespace },
        IndentBlanklineSpaceChar = { fg = pal.whitespace },

        -- diagnostics
        InlineDiagnosticTextError  = { fg=pal.lred,    bg=pal.lred_bg    },
        InlineDiagnosticTextWarn   = { fg=pal.lyellow, bg=pal.lyellow_bg },
        InlineDiagnosticTextHint   = { fg=pal.lblue,   bg=pal.lblue_bg   },
        InlineDiagnosticTextInfo   = { fg=pal.lblue,   bg=pal.lblue_bg   },

        DiagnosticVirtualTextError = { fg=pal.lred,    bg=pal.lred_bg    },
        DiagnosticVirtualTextWarn  = { fg=pal.lyellow, bg=pal.lyellow_bg },
        DiagnosticVirtualTextHint  = { fg=pal.lblue,   bg=pal.lblue_bg   },
        DiagnosticVirtualTextInfo  = { fg=pal.lblue,   bg=pal.lblue_bg   },

        DiagnosticSignError        = { fg=pal.lred,    style="bold"      },
        DiagnosticSignWarn         = { fg=pal.lyellow, style="bold"      },
        DiagnosticSignHint         = { fg=pal.lblue,   style="bold"      },
        DiagnosticSignInfo         = { fg=pal.lblue,   style="bold"      },

        DiagnosticFloatingError    = { fg=pal.lred,                      },
        DiagnosticFloatingWarn     = { fg=pal.lyellow,                   },
        DiagnosticFloatingHint     = { fg=pal.lblue,                     },
        DiagnosticFloatingInfo     = { fg=pal.lblue,                     },

        DiagnosticUnderlineError   = { sp=pal.lred,    style="undercurl" },
        DiagnosticUnderlineWarn    = { sp=pal.lyellow, style="undercurl" },
        DiagnosticUnderlineHint    = { sp=pal.lblue,   style="undercurl" },
        DiagnosticUnderlineInfo    = { sp=pal.lblue,   style="undercurl" },

        -- lsp ocurrences
        LspReferenceText  = { bg=pal.texthl2 },
        LspReferenceRead  = { bg=pal.texthl2 },
        LspReferenceWrite = { bg=pal.texthl2 },

        -- dap
        DapBreakpoint = { fg=pal.lred    },
        DapLogPoint   = { fg=pal.lyellow },
        DapStopped    = { fg=pal.lgreen  },
    }
    -- stylua: ignore end
end

function M.lualine(pal)
    -- stylua: ignore start
    return {
        normal = {
            a = { bg=pal.surface1, fg=pal.lyellow, gui="bold" },
            b = { bg=pal.surface2, fg=pal.text2,              },
            c = { bg=pal.surface3, fg=pal.text3,              },
        },
        insert = {
            a = { bg=pal.surface1, fg=pal.lgreen,  gui="bold" },
            b = { bg=pal.surface2, fg=pal.text2,              },
            c = { bg=pal.surface3, fg=pal.text3,              },
        },
        visual = {
            a = { bg=pal.surface1, fg=pal.lpurple, gui="bold" },
            b = { bg=pal.surface2, fg=pal.text2,              },
            c = { bg=pal.surface3, fg=pal.text3,              },
        },
        replace = {
            a = { bg=pal.surface1, fg=pal.lred,    gui="bold" },
            b = { bg=pal.surface2, fg=pal.text2,              },
            c = { bg=pal.surface3, fg=pal.text3,              },
        },
        command = {
            a = { bg=pal.surface1, fg=pal.lblue,   gui="bold" },
            b = { bg=pal.surface2, fg=pal.text2,              },
            c = { bg=pal.surface3, fg=pal.text3,              },
        },
        inactive = {
            a = { bg=pal.surface3, fg=pal.text3,              },
            b = { bg=pal.surface3, fg=pal.text3,              },
            c = { bg=pal.surface3, fg=pal.text3,              },
        }
    }
    -- stylua: ignore end
end

function M.apply_term_colors(pal)
    vim.g.terminal_color_1 = pal.dred
    vim.g.terminal_color_2 = pal.dgreen
    vim.g.terminal_color_3 = pal.dyellow
    vim.g.terminal_color_4 = pal.dblue
    vim.g.terminal_color_5 = pal.dviolet
    vim.g.terminal_color_6 = pal.dcyan

    vim.g.terminal_color_9 = pal.lred
    vim.g.terminal_color_10 = pal.lgreen
    vim.g.terminal_color_11 = pal.lyellow
    vim.g.terminal_color_12 = pal.lblue
    vim.g.terminal_color_13 = pal.lviolet
    vim.g.terminal_color_14 = pal.lcyan
end

function M.apply_highlights(highlights)
    vim.o.termguicolors = true

    for group, colors in pairs(highlights) do
        if colors.link then
            vim.api.nvim_command(string.format("highlight link %s %s", group, colors.link))
        else
            -- stylua: ignore start
            local style = colors.style and "gui="   .. colors.style or "gui=NONE"
            local fg    = colors.fg    and "guifg=" .. colors.fg    or "guifg=NONE"
            local bg    = colors.bg    and "guibg=" .. colors.bg    or "guibg=NONE"
            local sp    = colors.sp    and "guisp=" .. colors.sp    or ""
            -- stylua: ignore end
            vim.api.nvim_command(string.format("highlight %s %s %s %s %s", group, style, fg, bg, sp))
        end
    end
end

return M
