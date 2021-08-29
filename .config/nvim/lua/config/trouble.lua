local function setup()
    require('trouble').setup {
        position = "right",
        width = 60,
        icons = false,
        fold_open = "",
        fold_closed = "",
        signs = {
            other = "",
            error = "",
            warn  = "",
            info  = "",
            hint  = "",
        }
    }
end

return {
    setup = setup,
}
