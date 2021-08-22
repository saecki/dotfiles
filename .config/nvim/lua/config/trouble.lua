local function setup()
    require('trouble').setup {
        position = "right",
        width = 60,
        icons = false,
        fold_open = "▼",
        fold_closed = "▶",
        signs = { 
            other = "⬤",
            error = "",
            warn  = "",
            info  = "I",
            hint  = "H",
        }
    }

    vim.api.nvim_command('highlight! TroublePreview guibg=none')
end

return {
    setup = setup,
}
