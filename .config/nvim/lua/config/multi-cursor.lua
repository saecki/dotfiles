local M = {}

function M.setup()
    vim.g.multi_cursor_use_default_mapping = 0

    vim.g.multi_cursor_start_word_key = "<a-j>"
    vim.g.multi_cursor_next_key = "<a-j>"
    vim.g.multi_cursor_skip_key = "<a-s-j>"
    vim.g.multi_cursor_prev_key = "<a-k>"
    vim.g.multi_cursor_quit_key = "<esc>"
end

return M
