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
        sources = {
            default = { "lsp", "snippets", "path", "buffer" },
            cmdline = {
                enabled = false,
            },
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
            },
        }
    })
end

return M
