local function setup()
    require('telescope').setup {
        defaults = {
            layout_config = {
                horizontal = {
                    width = 0.98,
                    height = 0.96,
                    preview_cutoff = 120,
                },
            },
        },
    }
end

return {
    setup = setup,
}
