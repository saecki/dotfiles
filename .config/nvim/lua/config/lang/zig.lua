local util = require("util")

local M = {}

function M.setup()
    vim.g.zig_fmt_autosave = 0
    vim.g.zig_fmt_parse_errors = 0

    -- make library files readonly
    local zig_env = vim.json.decode(util.bash_eval("zig env"))
    local lib_dir = zig_env.lib_dir.."/**.zig"
    local group = vim.api.nvim_create_augroup("user.config.lang.zig", {})
    vim.api.nvim_create_autocmd("BufReadPre", {
        group = group,
        pattern = { lib_dir },
        callback = function(ev)
            vim.bo[ev.buf].readonly = true
            vim.bo[ev.buf].modifiable = false
        end
    })
end

return M
