local util = require("util")

local M = {}

function M.setup()
    -- make library files readonly
    local registry_path = vim.fn.expand("$HOME/.cargo/registry/src/**.rs")
    local rustc_sysroot = vim.trim(util.bash_eval("rustc --print sysroot"))
    local stdlib_path = rustc_sysroot.."/lib/rustlib/src/**.rs"
    local group = vim.api.nvim_create_augroup("user.config.lang.rust", {})
    vim.api.nvim_create_autocmd("BufReadPre", {
        group = group,
        pattern = { registry_path, stdlib_path },
        callback = function(ev)
            vim.api.nvim_buf_set_option(ev.buf, "readonly", true)
            vim.api.nvim_buf_set_option(ev.buf, "modifiable", false)
        end
    })
end

return M
