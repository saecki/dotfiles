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
end

return {
    setup = setup,
}
