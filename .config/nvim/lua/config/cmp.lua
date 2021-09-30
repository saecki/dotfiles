local maps = require('util.maps')

local function setup()
    local cmp = require('cmp')
    cmp.setup {
        snippet = {
            expand = function(args)
                vim.fn['vsnip#anonymous'](args.body)
            end
        },
        mapping = {
            ['<c-p>'] = cmp.mapping.select_prev_item(),
            ['<c-n>'] = cmp.mapping.select_next_item(),
            ['<c-u>'] = cmp.mapping.scroll_docs(-4), -- why doesn't this work
            ['<c-d>'] = cmp.mapping.scroll_docs(4), -- why doesn't this work
            ['<c-space>'] = cmp.mapping.complete(),
            ['<c-e>'] = cmp.mapping.close(),
            ['<cr>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
        },
    }

    -- Use <Tab> and <S-Tab> to navigate through popup menu
    maps.inoremap("<tab>",  'pumvisible() ? "\\<c-n>" : "\\<tab>"',   { expr = true })
    maps.inoremap("<s-tab>",'pumvisible() ? "\\<c-p>" : "\\<s-tab>"', { expr = true })

    vim.cmd("autocmd FileType lua lua require('cmp').setup.buffer { sources = { { name = 'nvim_lua' } } }")
end

return {
    setup = setup,
}
