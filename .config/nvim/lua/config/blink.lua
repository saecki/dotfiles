local blink = require("blink.cmp")
local shared = require("shared")

local M = {}

function M.setup()
    blink.setup({
        keymap = {
            ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<c-e>"] = { "hide", "fallback" },
            ["<c-y>"] = { "select_and_accept" },

            ["<c-p>"] = { "select_prev", "fallback" },
            ["<c-n>"] = { "select_next", "fallback" },

            ["<c-u>"] = { "scroll_documentation_up", "fallback" },
            ["<c-d>"] = { "scroll_documentation_down", "fallback" },

            ["<tab>"] = { "snippet_forward", "fallback" },
            ["<s-tab>"] = { "snippet_backward", "fallback" },
        },
        snippets = {
            preset = "luasnip",
        },
        cmdline = {
            enabled = false,
        },
        sources = {
            default = { "lsp", "snippets", "path", "buffer" },
            transform_items = function(ctx, items)
                local line = ctx.cursor[1] - 1
                local col = ctx.cursor[2]

                for _, item in ipairs(items) do
                    if item.textEdit then
                        if item.textEdit.range then
                            -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textEdit
                            -- trim edit range after cursor
                            local range_end = item.textEdit.range["end"]
                            if range_end.line == line and range_end.character > col then
                                range_end.character = col
                            end
                        elseif item.textEdit.insert then
                            -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#insertReplaceEdit
                            -- always use insert range
                            item.textEdit.range = item.textEdit.insert
                            item.textEdit.replace = nil
                        end
                    end
                end

                return items
            end,
        },
        completion = {
            menu = {
                draw = {
                    columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
                    components = {
                        kind_icon = {
                            ellipsis = false,
                        },
                        label = {
                            width = { max = 50 },
                        },
                        label_description = {
                            width = { max = 50 },
                        },
                    },
                },
            },
            documentation = {
                window = {
                    border = shared.window.border,
                    winhighlight = "Pmenu:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                },
            },
        },
        appearance = {
            kind_icons = {
                ["Class"]         = "🅒 ",
                ["Interface"]     = "🅘 ",
                ["TypeParameter"] = "🅣 ",
                ["Struct"]        = "🅢 ",
                ["Enum"]          = "🅔 ",
                ["Unit"]          = "🅤 ",
                ["EnumMember"]    = "🅔 ",
                ["Constant"]      = "🅒 ",
                ["Field"]         = "🅕 ",
                ["Property"]      = "🅟 ",
                ["Variable"]      = "🅥 ",
                ["Reference"]     = "🅡 ",
                ["Function"]      = "🅕 ",
                ["Method"]        = "🅜 ",
                ["Constructor"]   = "🅒 ",
                ["Module"]        = "🅜 ",
                ["File"]          = "🅕 ",
                ["Folder"]        = "🅕 ",
                ["Keyword"]       = "🅚 ",
                ["Operator"]      = "🅞 ",
                ["Snippet"]       = "🅢 ",
                ["Value"]         = "🅥 ",
                ["Color"]         = "🅒 ",
                ["Event"]         = "🅔 ",
                ["Text"]          = "🅣 ",
            },
        }
    })
end

return M
