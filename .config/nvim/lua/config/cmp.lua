local cmp = require("cmp")
local cmp_compare = require("cmp.config.compare")
local luasnip = require("luasnip")
local shared = require("shared")

local M = {}

local kind_icons = {
    ["Class"] = "🅒 ",
    ["Interface"] = "🅘 ",
    ["TypeParameter"] = "🅣 ",
    ["Struct"] = "🅢 ",
    ["Enum"] = "🅔 ",
    ["Unit"] = "🅤 ",
    ["EnumMember"] = "🅔 ",
    ["Constant"] = "🅒 ",
    ["Field"] = "🅕 ",
    ["Property"] = "🅟 ",
    ["Variable"] = "🅥 ",
    ["Reference"] = "🅡 ",
    ["Function"] = "🅕 ",
    ["Method"] = "🅜 ",
    ["Constructor"] = "🅒 ",
    ["Module"] = "🅜 ",
    ["File"] = "🅕 ",
    ["Folder"] = "🅕 ",
    ["Keyword"] = "🅚 ",
    ["Operator"] = "🅞 ",
    ["Snippet"] = "🅢 ",
    ["Value"] = "🅥 ",
    ["Color"] = "🅒 ",
    ["Event"] = "🅔 ",
    ["Text"] = "🅣 ",

    -- crates.nvim extensions
    ["Version"] = "🅥 ",
    ["Feature"] = "🅕 ",
}

function M.setup()
    cmp.setup({
        window = {
            completion = {
                col_offset = -3,
            },
            documentation = {
                border = shared.window.border,
                winhighlight = "Pmenu:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                zindex = 1001,
            },
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(_, vim_item)
                vim_item.menu = vim_item.kind
                vim_item.menu_hl_group = "CmpItemKind"..vim_item.kind
                vim_item.kind = kind_icons[vim_item.kind] or "  "
                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<c-p>"] = cmp.mapping.select_prev_item(),
            ["<c-n>"] = cmp.mapping.select_next_item(),
            ["<c-u>"] = cmp.mapping.scroll_docs(-4),
            ["<c-d>"] = cmp.mapping.scroll_docs(4),
            ["<c-space>"] = cmp.mapping.complete(),
            ["<c-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<c-y>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<a-y>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
        },
        sorting = {
            comparators = {
                -- cmp_compare.offset,
                cmp_compare.exact,
                cmp_compare.score,
                cmp_compare.recently_used,
                cmp_compare.locality,
                -- cmp_compare.kind,
                cmp_compare.sort_text,
                cmp_compare.length,
                cmp_compare.order,
            }
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer", keyword_length = 4, option = { keyword_pattern = [[\k\+]] } },
        },
        experimental = {
            native_menu = false,
            ghost_text = true,
        },
    })
end

return M
