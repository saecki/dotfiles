local M = {}

function M.setup()
    vim.g.zig_fmt_autosave = 0
    vim.g.zig_fmt_parse_errors = 0
end

return M
