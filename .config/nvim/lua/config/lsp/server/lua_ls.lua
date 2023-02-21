local M = {}

function M.setup(server, on_init, on_attach, capabilities)
    server.setup({
        on_init = on_init,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { "vim", "P" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true)
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M
