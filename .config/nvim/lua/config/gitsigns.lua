local function current_line_blame_formatter(name, blame_info, opts)
    if blame_info.author == name then
        blame_info.author = 'You'
    end

    local text
    if blame_info.author == 'Not Committed Yet' then
        text = blame_info.author
    else
        local date_time

        if opts.relative_time then
            date_time = require('gitsigns.util').get_relative_time(tonumber(blame_info['author_time']))
        else
            date_time = os.date('%Y-%m-%d', tonumber(blame_info['author_time']))
        end

        text = string.format(' // %s, %s - %s', blame_info.author, date_time, blame_info.summary)
      end

      return {{' '..text, 'GitSignsCurrentLineBlame'}}
end

local function setup()
    local gitsigns = require('gitsigns')

    gitsigns.setup {
        signs = {
            add          = { hl='GitSignsAdd'   , text=' ', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
            change       = { hl='GitSignsChange', text=' ', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
            delete       = { hl='GitSignsDelete', text='__', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
            topdelete    = { hl='GitSignsDelete', text=' ', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
            changedelete = { hl='GitSignsChgDel', text='__', numhl='GitSignsChgDelNr', linehl='GitSignsChgDelLn' },
        },
        numhl = false,
        linehl = false,
        keymaps = {
            noremap = true,
            ['n g}'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
            ['n g{'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
            ['n <leader>gu'] = '<cmd>lua require("gitsigns").reset_hunk()<CR>',
            ['n <leader>gs'] = '<cmd>lua require("gitsigns").preview_hunk()<CR>',
            ['n <leader>gb'] = '<cmd>lua require("gitsigns").toggle_current_line_blame()<CR>',
        },
        watch_index = {
            interval = 1000,
            follow_files = true
        },
        current_line_blame = false,
        current_line_blame_formatter = current_line_blame_formatter,
        current_line_blame_formatter_opts = {
            relative_time = true,
        },
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol',
            delay = 0,
        },
        sign_priority = 10,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        diff_opts = {
            internal = true,
        },
        preview_config = {
            border   = 'none',
            style    = 'minimal',
            relative = 'cursor',
            row      = 0,
            col      = 1
        }
    }
end

return {
    setup = setup,
}
