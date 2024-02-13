local M = {}

local wk = require("which-key")

local use_clippy = false
local function toggle_check_command()
    use_clippy = not use_clippy
    M.setup(M.server, M.on_attach, M.capabilities, { use_clippy = use_clippy })
    if use_clippy then
        vim.notify("cargo clippy", vim.log.levels.INFO)
    else
        vim.notify("cargo check", vim.log.levels.INFO)
    end
end

local function wrap_on_attach(client, buf)
    M.on_attach(client, buf)

    wk.register({
        ["<leader>i"] = {
            name = "Lsp",
            ["c"] = { toggle_check_command, "Rust check command" },
        },
    }, {
        buffer = buf,
    })
end


function M.setup(server, on_attach, capabilities, opts)
    M.server = server
    M.on_attach = on_attach
    M.capabilities = capabilities

    opts = opts or {}

    server.setup({
        on_attach = wrap_on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = opts.use_clippy and "clippy" or "check",
                },
                assist = {
                    importEnforceGranularity = true,
                    importGranularity = "module",
                    importPrefix = "crate",
                },
                inlayHints = {
                    maxLength = 40,
                },
            },
        },
    })
end

return M
