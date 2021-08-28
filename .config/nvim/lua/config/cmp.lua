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
            { name = "path" },
            { name = "buffer" },
            { name = "nvim_lsp" },
        },
    }

    -- Use <Tab> and <S-Tab> to navigate through popup menu
    vim.api.nvim_set_keymap('i', '<tab>',   'pumvisible() ? "\\<c-n>" : "\\<tab>"',   { noremap = true, expr = true })
    vim.api.nvim_set_keymap('i', '<s-tab>', 'pumvisible() ? "\\<c-p>" : "\\<s-tab>"', { noremap = true, expr = true })

    vim.cmd("autocmd FileType lua lua require('cmp').setup.buffer { sources = { { name = 'nvim_lua' } } }")
    vim.cmd("autocmd FileType toml lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }")
end

return {
    setup = setup,
}
