local M = {}

local util = require('util')

function M.setup(lsp_config, on_attach, capabilities)
    local os
    if util.is_windows then
        os = "Windows"
    else
        os = "Linux"
    end

    local sumneko_root_path = util.join_paths(vim.fn.stdpath("data"), "lua-language-server")
    local sumneko_binary = util.join_paths(sumneko_root_path, "bin", os, "lua-language-server")
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, util.join_paths("lua", "?.lua"))
    table.insert(runtime_path, util.join_paths("lua", "?", "init.lua"))

    lsp_config.sumneko_lua.setup {
        cmd = { sumneko_binary, "-E", util.join_paths(sumneko_root_path, "main.lua") },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { 'vim', 'P' },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }
end

return M
