local function setup()
    require'compe'.setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        resolve_timeout = 800,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = {
            border = { '', '' ,'', ' ', '', '', '', ' ' }, -- same as `|help nvim_open_win|`
            winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
            max_width = 120,
            min_width = 60,
            max_height = math.floor(vim.o.lines * 0.3),
            min_height = 1,
        },

        source = {
            path = true,
            buffer = true,
            calc = true,
            nvim_lsp = true,
            nvim_lua = true,
            vsnip = true,
            ultisnips = false,
            luasnip = false,
        },
    }

    vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()',        { noremap = true, silent = true, expr = true })
    vim.api.nvim_set_keymap('i', '<cr>',      "compe#confirm('<cr>')", { noremap = true, silent = true, expr = true })
    vim.api.nvim_set_keymap('i', '<c-e>',     "compe#close('<c-e>')",  { noremap = true, silent = true, expr = true })
    vim.api.nvim_set_keymap('i', '<c-u>',     "compe#scroll({ 'delta': -4 })",  { noremap = true, silent = true, expr = true })
    vim.api.nvim_set_keymap('i', '<c-d>',     "compe#scroll({ 'delta': +4 })",  { noremap = true, silent = true, expr = true })

    -- Use <Tab> and <S-Tab> to navigate through popup menu
    vim.api.nvim_set_keymap('i', '<tab>',   'pumvisible() ? "\\<c-n>" : "\\<tab>"',   { noremap = true, expr = true })
    vim.api.nvim_set_keymap('i', '<s-tab>', 'pumvisible() ? "\\<c-p>" : "\\<s-tab>"', { noremap = true, expr = true })
end

return {
    setup = setup,
}
