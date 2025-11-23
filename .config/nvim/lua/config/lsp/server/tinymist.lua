local wk = require("which-key.config")

local M = {}

local html_export = false

local function setup_server(opts)
    opts = opts or {}
    local target = opts.export_target or nil -- defaults to paged export
    vim.lsp.config("tinymist", {
        settings = {
            formatterMode = "typstyle",
            exportTarget = target,
        },
    })

    for _, client in ipairs(vim.lsp.get_clients({ name = "tinymist" })) do
        -- Update the settings on the active client.
        client.settings = vim.lsp.config.tinymist.settings
        -- Send a notification with anything other than a table as settings,
        -- so tinymist pulls the configuration using a `workspace/configuration` request.
        client:notify("workspace/didChangeConfiguration", { settings = false })
    end
end

local function toggle_export_target()
    html_export = not html_export
    local target = html_export and "html" or "paged"
    setup_server({ export_target = target })
    vim.notify("tinymist target: " .. target, vim.log.levels.INFO)
end

function M.setup()
    setup_server()

    local group = vim.api.nvim_create_augroup("user.config.lsp.server.tinymist", {})
    vim.api.nvim_create_autocmd("BufRead", {
        group = group,
        pattern = "*.typ",
        callback = function(ev)
            wk.add({
                buffer = ev.buf,
                { "<leader>ie", toggle_export_target, desc = "Tinymist html export" },
            })
        end
    })
end

return M
