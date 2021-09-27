local M = {
    trailing_whitespace = false,
    whitespace_ids = {}
}

local maps = require('mappings')

function M.toggle_trailing_whitespace()
    M.trailing_whitespace = not M.trailing_whitespace
    M.highlight_trailing_whitespace()
end

function M.highlight_trailing_whitespace()
    local win = vim.api.nvim_get_current_win()
    local id = M.whitespace_ids[win]

    if id then
        vim.fn.matchdelete(id)
        M.whitespace_ids[win] = nil
    end

    if M.trailing_whitespace then
        M.whitespace_ids[win] = vim.fn.matchadd("Error", "\\s\\+$")
    end
end

function M.setup()
    -- Highlight yanked text
    vim.cmd("autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 150 }")

    -- Highlight trailing whitespace
    vim.cmd("autocmd WinEnter * silent! lua require('highlight').highlight_trailing_whitespace()")
    maps.nnoremap("<leader>hw", M.toggle_trailing_whitespace)
end

return M
