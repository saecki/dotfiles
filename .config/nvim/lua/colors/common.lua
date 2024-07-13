local M = {}

function M.highlights(p)
    ---@format disable-next
    return {
        -- editor
        Normal          = { fg = p.fg,       bg = p.bg,                          },
        SignColumn      = {                  bg = "none",                        },
        LineNr          = { fg = p.text3,                                        },
        CursorLineNr    = { fg = p.text2,                       bold = true      },
        CursorLine      = {                  bg = p.ref_text,                    },
        CursorColumn    = {                  bg = p.ref_text,                    },
        Pmenu           = { fg = p.text2,    bg = p.surface3,                    },
        PmenuSel        = {                  bg = p.surface2,   bold = true      },
        PmenuSBar       = {                  bg = p.scrollbg,                    },
        PmenuThumb      = {                  bg = p.scrollfg,                    },
        NormalFloat     = { fg = p.text2,    bg = p.surface3,                    },
        FloatBorder     = { fg = p.surface3, bg = p.bg,                          },
        Visual          = {                  bg = p.texthl1,                     },
        VertSplit       = { fg = p.text3,    bg = "none",                        },
        StatusLine      = { fg = "none",     bg = "none",                        },
        StatusLineNC    = { fg = "none",     bg = "none",                        },
        Error           = {                  bg = p.lred,                        },
        Todo            = { fg = p.todo,     bg = "none",       bold = true      },
        Directory       = { fg = p.lgreen,                                       },
        Search          = { fg = p.invtext,  bg = p.lyellow,                     },
        CurSearch       = { fg = p.invtext,  bg = p.texthl2,                     },
        MatchParen      = {                  bg = p.ref_text,                    },
        NonText         = { fg = p.nontext,                                      },
        Whitespace      = { fg = p.whitespace,                                   },
        Folded          = { fg = p.folded,   bg = p.folded_bg,                   },

        -- syntax
        Title           = { fg = p.title,                       bold = true      },
        Comment         = { fg = p.text3,                                        },
        Constant        = { fg = p.lpurple,                                      },
        String          = { fg = p.lpurple,                                      },
        Identifier      = { fg = p.ident,                                        },
        Function        = { fg = p.lcyan,                       bold = true      },
        Statement       = { fg = p.lyellow,                                      },
        PreProc         = { fg = p.preproc,                                      },
        Type            = { fg = p.type,                        bold = true      },
        Special         = { fg = p.special,                                      },

        -- custom
        Link            = { fg = p.preproc,                     underline = true },
        Selection       = { fg = p.special,                     underline = true },

        -- treesitter
        ["@variable"]         = { link = "Identifier" },
        ["@variable.builtin"] = { link = "Special"    },
        ["@constant"]         = { link = "Constant"   },
        ["@number"]           = { link = "Constant"   },
        ["@boolean"]          = { link = "Constant"   },
        ["@string"]           = { link = "String"     },
        ["@character"]        = { link = "String"     },
        ["@punctuation"]      = { link = "Special"    },
        ["@operator"]         = { link = "Statement"  },
        ["@function"]         = { link = "Function"   },
        ["@type"]             = { link = "Type"       },
        ["@type.builtin"]     = { link = "Type"       },
        ["@module"]           = { link = "PreProc"    },

        ["@markup.link"]      = { link = "Link"       },
        ["@markup.raw"]       = { link = "Comment"    },

        -- lsp semantic tokens
        ["@lsp.mod.constant"]     = { link = "Constant"      },
        ["@lsp.type.string"]      = { link = "@string"       },
        ["@lsp.type.character"]   = { link = "@character"    },
        ["@lsp.type.number"]      = { link = "@boolean"      },
        ["@lsp.type.boolean"]     = { link = "@boolean"      },
        ["@lsp.type.keyword"]     = { link = "@keyword"      },
        ["@lsp.type.punctuation"] = { link = "@punctuation"  },
        ["@lsp.type.operator"]    = { link = "@operator"     },
        ["@lsp.type.struct"]      = { link = "@type"         },
        ["@lsp.type.enum"]        = { link = "@type"         },
        ["@lsp.type.macro"]       = { link = "@constant"     },

        ["@lsp.type.macro.rust"]  = { link = "@function" },

        ["@rust.attr.rustfmt_skip"] = { link = "NonText" },

        -- treesitter context
        TreesitterContextLineNumber = { link = "Pmenu" },

        -- cmp
        CmpItemMenuDefault      = { fg = p.text3,   italic = true },
        CmpItemKindDefault      = { fg = p.special, bold = true   },

        CmpItemKindModule       = { fg = p.preproc, bold = true   },
        CmpItemKindClass        = { fg = p.type,    bold = true   },
        CmpItemKindStruct       = { fg = p.type,    bold = true   },
        CmpItemKindInterface    = { fg = p.type,    bold = true   },
        CmpItemKindTypeParamter = { fg = p.type,    bold = true   },
        CmpItemKindEnum         = { fg = p.type,    bold = true   },
        CmpItemKindEnumMember   = { fg = p.lpurple, bold = true   },
        CmpItemKindConstant     = { fg = p.lpurple, bold = true   },
        CmpItemKindField        = { fg = p.ident,   bold = true   },
        CmpItemKindProperty     = { fg = p.ident,   bold = true   },
        CmpItemKindVariable     = { fg = p.special, bold = true   },
        CmpItemKindFunction     = { fg = p.lcyan,   bold = true   },
        CmpItemKindMethod       = { fg = p.lcyan,   bold = true   },
        CmpItemKindConstructor  = { fg = p.lcyan,   bold = true   },
        CmpItemKindKeyword      = { fg = p.lyellow, bold = true   },
        CmpItemKindOperator     = { fg = p.lyellow, bold = true   },
        CmpItemKindText         = { fg = p.special, bold = true   },
        CmpItemKindValue        = { fg = p.special, bold = true   },
        CmpItemKindUnit         = { fg = p.special, bold = true   },
        CmpItemKindSnippet      = { fg = p.special, bold = true   },
        CmpItemKindColor        = { fg = p.special, bold = true   },
        CmpItemKindFile         = { fg = p.special, bold = true   },
        CmpItemKindFolder       = { fg = p.special, bold = true   },
        CmpItemKindReference    = { fg = p.special, bold = true   },
        CmpItemKindEvent        = { fg = p.special, bold = true   },

        CmpItemKindVersion      = { fg = p.special, bold = true   },
        CmpItemKindFeature      = { fg = p.special, bold = true   },

        CmpItemAbbrDeprecated   = { fg = p.text3,   strikethrough = true },

        -- git
        diffAdded       = {               bg = p.diff_a_bg,              },
        diffRemoved     = {               bg = p.diff_d_bg,              },
        ["@diff.plus.diff"]  = {          bg = p.diff_a_bg,              },
        ["@diff.minus.diff"] = {          bg = p.diff_d_bg,              },
        DiffAdd         = {               bg = p.diff_a_bg,              },
        DiffChange      = {               bg = p.diff_c_bg,              },
        DiffDelete      = { fg = p.text2, bg = p.diff_d_bg,              },
        DiffText        = { fg = p.text2, bg = p.diff_cd_bg, bold = true },

        -- gitsigns
        GitSignsCurrentLineBlame = { link = "Comment" },

        GitSignsAdd            = { fg = p.diff_a_fg  },
        GitSignsChange         = { fg = p.diff_c_fg  },
        GitSignsDelete         = { fg = p.diff_d_fg  },
        GitSignsTopdelete      = { fg = p.diff_d_fg  },
        GitSignsChangeDelete   = { fg = p.diff_cd_fg },

        GitSignsAddLn          = { bg = p.diff_a_bg  },
        GitSignsChangeLn       = { bg = p.diff_c_bg  },
        GitSignsDeleteLn       = { bg = p.diff_d_bg  },
        GitSignsTopdeleteLn    = { bg = p.diff_d_bg  },
        GitSignsChangeDeleteLn = { bg = p.diff_cd_bg },

        GitSignsAddNr          = { bg = p.diff_a_bg  },
        GitSignsChangeNr       = { bg = p.diff_c_bg  },
        GitSignsDeleteNr       = { bg = p.diff_d_bg  },
        GitSignsTopdeleteNr    = { bg = p.diff_d_bg  },
        GitSignsChangeDeleteNr = { bg = p.diff_cd_bg },

        -- nvim-tree
        NvimTreeGitDirty   = { fg = p.dblue   },
        NvimTreeGitDeleted = { fg = p.dblue   },
        NvimTreeGitStaged  = { fg = p.dblue   },
        NvimTreeGitMerge   = { fg = p.dyellow },
        NvimTreeGitRenamed = { fg = p.dpurple },
        NvimTreeGitNew     = { fg = p.dgreen  },

        -- harpoon
        HarpoonWindow = { link = "Pmenu"       },
        HarpoonBorder = { link = "FloatBorder" },

        -- telescope
        FloatTitle             = { fg = p.text3, bg = p.surface3 },
        TelescopeResultsNormal = { link = "Pmenu"                },
        TelescopeResultsBorder = { link = "FloatBorder"          },
        TelescopeResultsTitle  = { link = "FloatTitle"           },
        TelescopePromptNormal  = { link = "Pmenu"                },
        TelescopePromptBorder  = { link = "FloatBorder"          },
        TelescopePromptTitle   = { link = "FloatTitle"           },
        TelescopePreviewNormal = { link = "Pmenu"                },
        TelescopePreviewBorder = { link = "FloatBorder"          },
        TelescopePreviewTitle  = { link = "FloatTitle"           },

        -- trouble
        TroubleNormal = { link = "Normal" },
        TroubleNormalNC = { link = "NormalNC" },

        -- which-key
        WhichKey = { fg = p.special },

        -- indent-blankline
        IblIndent     = { fg = p.whitespace },
        IblWhitespace = { fg = p.whitespace },
        IblScope      = { fg = p.whitespace },

        -- multicursors
        MultiCursor     = {                 bg = p.texthl1 },
        MultiCursorMain = { fg = p.invtext, bg = p.texthl2 },

        -- lualine
        LualineDiagnosticSignError = { fg = p.lred,    bg = p.surface2, bold = true },
        LualineDiagnosticSignWarn  = { fg = p.lyellow, bg = p.surface2, bold = true },
        LualineDiagnosticSignHint  = { fg = p.lblue,   bg = p.surface2, bold = true },
        LualineDiagnosticSignInfo  = { fg = p.lblue,   bg = p.surface2, bold = true },

        LualineNormalA   = { bg = p.surface1, fg = p.lyellow, bold = true },
        LualineInsertA   = { bg = p.surface1, fg = p.lgreen,  bold = true },
        LualineVisualA   = { bg = p.surface1, fg = p.lpurple, bold = true },
        LualineReplaceA  = { bg = p.surface1, fg = p.lred,    bold = true },
        LualineCommandA  = { bg = p.surface1, fg = p.lblue,   bold = true },
        LualineInactiveA = { bg = p.surface3, fg = p.text3,               },

        LualineB = { bg = p.surface2, fg = p.text2, },
        LualineC = { bg = p.surface3, fg = p.text3, },

        -- diagnostics
        InlineDiagnosticTextError  = { fg = p.lred,    bg = p.lred_bg    },
        InlineDiagnosticTextWarn   = { fg = p.lyellow, bg = p.lyellow_bg },
        InlineDiagnosticTextHint   = { fg = p.lblue,   bg = p.lblue_bg   },
        InlineDiagnosticTextInfo   = { fg = p.lblue,   bg = p.lblue_bg   },

        DiagnosticError            = { fg = p.lred,                      },
        DiagnosticWarn             = { fg = p.lyellow,                   },
        DiagnosticHint             = { fg = p.lblue,                     },
        DiagnosticInfo             = { fg = p.lblue,                     },

        DiagnosticVirtualTextError = { fg = p.lred,                      },
        DiagnosticVirtualTextWarn  = { fg = p.lyellow,                   },
        DiagnosticVirtualTextHint  = { fg = p.lblue,                     },
        DiagnosticVirtualTextInfo  = { fg = p.lblue,                     },

        DiagnosticSignError        = { fg = p.lred,    bold = true       },
        DiagnosticSignWarn         = { fg = p.lyellow, bold = true       },
        DiagnosticSignHint         = { fg = p.lblue,   bold = true       },
        DiagnosticSignInfo         = { fg = p.lblue,   bold = true       },

        DiagnosticFloatingError    = { fg = p.lred,                      },
        DiagnosticFloatingWarn     = { fg = p.lyellow,                   },
        DiagnosticFloatingHint     = { fg = p.lblue,                     },
        DiagnosticFloatingInfo     = { fg = p.lblue,                     },

        DiagnosticUnderlineError   = { sp = p.lred,    undercurl = true  },
        DiagnosticUnderlineWarn    = { sp = p.lyellow, undercurl = true  },
        DiagnosticUnderlineHint    = { sp = p.lblue,   undercurl = true  },
        DiagnosticUnderlineInfo    = { sp = p.lblue,   undercurl = true  },

        -- lsp ocurrences
        LspReferenceText  = { bg = p.ref_text  },
        LspReferenceRead  = { bg = p.ref_read  },
        LspReferenceWrite = { bg = p.ref_write },

        -- lsp config border
        LspInfoBorder = { fg = p.surface3 },

        -- dap
        DapBreakpoint = { fg = p.lred    },
        DapLogPoint   = { fg = p.lyellow },
        DapStopped    = { fg = p.lgreen  },

        -- crates
        CratesNvimPopupUrl = { link = "Link" },

        -- markview
        Markview_code_block         = { bg = p.surface3                  },
        Markview_inline_code        = { bg = p.surface3, fg = p.special  },
        Markview_inline_code_corner = { bg = p.bg,       fg = p.surface3 },
        Markview_link               = { link = "Link"                    },
    }
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
        vim.api.nvim_set_hl(0, group, colors)
    end
end

return M
