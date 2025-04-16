local M = {}

function M.highlights(p)
    ---@format disable-next
    return {
        -- editor
        Normal          = { fg = p.fg,       bg = p.bg,                          },
        SignColumn      = {                  bg = "none",                        },
        LineNr          = { fg = p.text3,                                        },
        CursorLineNr    = { fg = p.text2,                       bold = true      },
        CursorLine      = {                                                      },
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

        -- custom status line
        StatusLineDiagnosticError = { fg = p.lred,    bg = p.surface2, bold = true },
        StatusLineDiagnosticWarn  = { fg = p.lyellow, bg = p.surface2, bold = true },
        StatusLineDiagnosticHint  = { fg = p.lcyan,   bg = p.surface2, bold = true },
        StatusLineDiagnosticInfo  = { fg = p.lblue,   bg = p.surface2, bold = true },
        StatusLineGitRev          = { fg = p.lcyan,   bg = p.surface2              },

        StatusLineBorderA  = { fg = p.surface1                  },
        StatusLineBorderAB = { fg = p.surface1, bg = p.surface2 },
        StatusLineBorderAC = { fg = p.surface1, bg = p.surface3 },
        StatusLineBorderBC = { fg = p.surface2, bg = p.surface3 },

        StatusLineNormalA   = { fg = p.lyellow, bg = p.surface1, bold = true },
        StatusLineOperatorA = { fg = p.lcyan,   bg = p.surface1, bold = true },
        StatusLineInsertA   = { fg = p.lgreen,  bg = p.surface1, bold = true },
        StatusLineVisualA   = { fg = p.lpurple, bg = p.surface1, bold = true },
        StatusLineReplaceA  = { fg = p.lred,    bg = p.surface1, bold = true },
        StatusLineCommandA  = { fg = p.lblue,   bg = p.surface1, bold = true },
        StatusLineB         = { fg = p.text2,   bg = p.surface2              },
        StatusLineC         = { fg = p.text3,   bg = p.surface3              },

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
        ["@constructor"]      = { link = "Type"       },
        ["@module"]           = { link = "PreProc"    },

        ["@markup.link"]      = { link = "Link"       },
        ["@markup.raw"]       = { link = "Comment"    },

        -- lsp semantic tokens
        ["@lsp.mod.constant"]     = { link = "Constant"      },
        ["@lsp.mod.mutable"]      = { underline = true },

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

        ["@lsp.type.escapeSequence"] = { link = "Special" },

        -- rust specific things
        ["@lsp.type.macro.rust"]            = { link = "@function" },
        ["@lsp.type.formatSpecifier.rust"]  = { link = "Special" },

        ["@attr.rustfmt_skip.rust"] = { link = "NonText" },

        -- lua specific things
        ["@constructor.lua"] = { link = "Special" },

        -- treesitter context
        TreesitterContextLineNumber = { link = "Pmenu" },

        -- blink.cmp
        BlinkCmpMenu             = { link = "Pmenu"       },
        BlinkCmpMenuBorder       = { link = "FloatBorder" },
        BlinkCmpMenuSelection    = { link = "PmenuSel"    },

        BlinkCmpLabelDetail      = { fg = p.text3                         },
        BlinkCmpLabelDescription = { fg = p.text3                         },
        BlinkCmpLabelDeprecated  = { fg = p.text3,   strikethrough = true },

        BlinkCmpKindModule       = { fg = p.preproc, bold = true   },
        BlinkCmpKindClass        = { fg = p.type,    bold = true   },
        BlinkCmpKindStruct       = { fg = p.type,    bold = true   },
        BlinkCmpKindInterface    = { fg = p.type,    bold = true   },
        BlinkCmpKindTypeParamter = { fg = p.type,    bold = true   },
        BlinkCmpKindEnum         = { fg = p.type,    bold = true   },
        BlinkCmpKindEnumMember   = { fg = p.lpurple, bold = true   },
        BlinkCmpKindConstant     = { fg = p.lpurple, bold = true   },
        BlinkCmpKindField        = { fg = p.ident,   bold = true   },
        BlinkCmpKindProperty     = { fg = p.ident,   bold = true   },
        BlinkCmpKindVariable     = { fg = p.special, bold = true   },
        BlinkCmpKindFunction     = { fg = p.lcyan,   bold = true   },
        BlinkCmpKindMethod       = { fg = p.lcyan,   bold = true   },
        BlinkCmpKindConstructor  = { fg = p.lcyan,   bold = true   },
        BlinkCmpKindKeyword      = { fg = p.lyellow, bold = true   },
        BlinkCmpKindOperator     = { fg = p.lyellow, bold = true   },
        BlinkCmpKindText         = { fg = p.special, bold = true   },
        BlinkCmpKindValue        = { fg = p.special, bold = true   },
        BlinkCmpKindUnit         = { fg = p.special, bold = true   },
        BlinkCmpKindSnippet      = { fg = p.special, bold = true   },
        BlinkCmpKindColor        = { fg = p.special, bold = true   },
        BlinkCmpKindFile         = { fg = p.special, bold = true   },
        BlinkCmpKindFolder       = { fg = p.special, bold = true   },
        BlinkCmpKindReference    = { fg = p.special, bold = true   },
        BlinkCmpKindEvent        = { fg = p.special, bold = true   },

        -- TODO: does blink.cmp need something like this?
        --CmpItemMenuDefault      = { fg = p.text3,   italic = true },
        --CmpItemKindDefault      = { fg = p.special, bold = true   },

        -- TODO: can this also be done with blink.cmp?
        --CmpItemKindVersion      = { fg = p.special, bold = true   },
        --CmpItemKindFeature      = { fg = p.special, bold = true   },

        -- diff
        Added           = {               bg = p.diff_a_bg,              },
        Changed         = {               bg = p.diff_c_bg,              },
        Removed         = {               bg = p.diff_d_bg,              },

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

        TelescopeLspSymbolKindFile          = { fg = p.special },
        TelescopeLspSymbolKindModule        = { fg = p.special },
        TelescopeLspSymbolKindNamespace     = { fg = p.preproc },
        TelescopeLspSymbolKindPackage       = { fg = p.preproc },
        TelescopeLspSymbolKindClass         = { fg = p.type    },
        TelescopeLspSymbolKindMethod        = { fg = p.lcyan   },
        TelescopeLspSymbolKindProperty      = { fg = p.ident   },
        TelescopeLspSymbolKindField         = { fg = p.ident   },
        TelescopeLspSymbolKindConstructor   = { fg = p.lcyan   },
        TelescopeLspSymbolKindEnum          = { fg = p.type    },
        TelescopeLspSymbolKindInterface     = { fg = p.type    },
        TelescopeLspSymbolKindFunction      = { fg = p.lcyan   },
        TelescopeLspSymbolKindVariable      = { fg = p.special },
        TelescopeLspSymbolKindConstant      = { fg = p.lpurple },
        TelescopeLspSymbolKindString        = { fg = p.lpurple },
        TelescopeLspSymbolKindNumber        = { fg = p.lpurple },
        TelescopeLspSymbolKindBoolean       = { fg = p.lpurple },
        TelescopeLspSymbolKindArray         = { fg = p.special },
        TelescopeLspSymbolKindObject        = { fg = p.special },
        TelescopeLspSymbolKindKey           = { fg = p.special },
        TelescopeLspSymbolKindNull          = { fg = p.special },
        TelescopeLspSymbolKindEnumMember    = { fg = p.lpurple },
        TelescopeLspSymbolKindStruct        = { fg = p.type    },
        TelescopeLspSymbolKindEvent         = { fg = p.special },
        TelescopeLspSymbolKindOperator      = { fg = p.lyellow },
        TelescopeLspSymbolKindTypeParameter = { fg = p.special },

        -- trouble
        TroubleNormal = { link = "Normal" },
        TroubleNormalNC = { link = "NormalNC" },

        -- which-key
        WhichKey = { fg = p.special },

        -- indent-blankline
        IblIndent     = { fg = p.indent     },
        IblWhitespace = { fg = p.whitespace },
        IblScope      = { fg = p.whitespace },

        -- diagnostics
        InlineDiagnosticTextError  = { fg = p.lred,    bg = p.lred_bg    },
        InlineDiagnosticTextWarn   = { fg = p.lyellow, bg = p.lyellow_bg },
        InlineDiagnosticTextInfo   = { fg = p.lblue,   bg = p.lblue_bg   },
        InlineDiagnosticTextHint   = { fg = p.lcyan,   bg = p.lblue_bg   },

        DiagnosticError            = { fg = p.lred,                      },
        DiagnosticWarn             = { fg = p.lyellow,                   },
        DiagnosticInfo             = { fg = p.lblue,                     },
        DiagnosticHint             = { fg = p.lcyan,                     },

        DiagnosticVirtualTextError = { fg = p.lred,                      },
        DiagnosticVirtualTextWarn  = { fg = p.lyellow,                   },
        DiagnosticVirtualTextInfo  = { fg = p.lblue,                     },
        DiagnosticVirtualTextHint  = { fg = p.lcyan,                     },

        DiagnosticSignError        = { fg = p.lred,    bold = true       },
        DiagnosticSignWarn         = { fg = p.lyellow, bold = true       },
        DiagnosticSignInfo         = { fg = p.lblue,   bold = true       },
        DiagnosticSignHint         = { fg = p.lcyan,   bold = true       },

        DiagnosticFloatingError    = { fg = p.lred,                      },
        DiagnosticFloatingWarn     = { fg = p.lyellow,                   },
        DiagnosticFloatingInfo     = { fg = p.lblue,                     },
        DiagnosticFloatingHint     = { fg = p.lcyan,                     },

        DiagnosticUnderlineError   = { sp = p.lred,    undercurl = true  },
        DiagnosticUnderlineWarn    = { sp = p.lyellow, undercurl = true  },
        DiagnosticUnderlineInfo    = { sp = p.lblue,   undercurl = true  },
        DiagnosticUnderlineHint    = { sp = p.lcyan,   undercurl = true  },

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
