local function setup()
    local gitsigns = require('gitsigns')

    gitsigns.setup {
        signs = {
            add          = { hl='GitSignsAdd'   , text=' ', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
            change       = { hl='GitSignsChange', text=' ', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
            delete       = { hl='GitSignsDelete', text=' ', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
            topdelete    = { hl='GitSignsDelete', text=' ', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
            changedelete = { hl='GitSignsChgDel', text=' ', numhl='GitSignsChgDelNr', linehl='GitSignsChgDelLn' },
        },
        numhl = false,
        linehl = false,
        keymaps = {
            noremap = true,
            ['n g}'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
            ['n g{'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
            ['n gu'] = '<cmd>lua require("gitsigns").reset_hunk()<CR>',
            ['n gs'] = '<cmd>lua require("gitsigns").preview_hunk()<CR>',
        },
        watch_index = {
            interval = 1000,
            follow_files = true
        },
        current_line_blame = false,
        current_line_blame_delay = 1000,
        current_line_blame_position = 'eol',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        use_internal_diff = true,  -- If luajit is present
        preview_config = {
            border   = 'none',
            style    = 'minimal',
            relative = 'cursor',
            row      = 0,
            col      = 1
        }
    }
    
    gitsigns.change_base('HEAD')
end

return {
    setup = setup,
}
