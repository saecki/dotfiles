local M = {}

function M.setup()
    vim.g.rustfmt_autosave = 1
    vim.g.rustfmt_emit_files = 1
    vim.g.rustfmt_fail_silently = 0
    vim.g.rust_recommended_style = 0
end

return M
