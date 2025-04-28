local M = {}

function M.setup()
    -- make stdlib and registry files readonly
    local registry_path = vim.fn.expand("$HOME/.cargo/registry/**.rs")
    local stdlib_path = vim.fn.expand("$HOME/.rustup/toolchains/**.rs")
    local group = vim.api.nvim_create_augroup("user.config.lang.rust", {})
    vim.api.nvim_create_autocmd("BufReadPre", {
        group = group,
        pattern = { registry_path, stdlib_path },
        callback = function(ev)
            vim.bo[ev.buf].readonly = true
            vim.bo[ev.buf].modifiable = false
        end
    })
end

return M
