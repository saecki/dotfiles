local M = {}

local cmp = require("cmp")
local luasnip = require("luasnip")

function M.setup()
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end),
            ["<c-p>"] = cmp.mapping.select_prev_item(),
            ["<c-n>"] = cmp.mapping.select_next_item(),
            ["<c-u>"] = cmp.mapping.scroll_docs(-4),
            ["<c-d>"] = cmp.mapping.scroll_docs(4),
            ["<c-space>"] = cmp.mapping.complete(),
            ["<c-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<cr>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "crates" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer", keyword_length = 4 },
        },
        experimental = {
            native_menu = false,
            ghost_text = true,
        },
    })
end

return M
