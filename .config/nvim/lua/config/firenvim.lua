local M = {}

function M.setup()
    vim.g.firenvim_config = {
        globalSettings = {
            alt = "all",
        },
        localSettings = {
            [".*"] = {
                cmdline = "neovim",
                content = "text",
                priority = 0,
                selector = "textarea",
                takeover = "never",
            },
        },
    }

    if vim.g.started_by_firenvimi ~= nil then
        vim.opt.guifont = "Monospace:h8"
    end
end

return M
