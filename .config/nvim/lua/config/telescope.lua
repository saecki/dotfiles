local function setup()
    require('telescope').setup {
        defaults = {
            layout_config = {
                horizontal = {
                    width = 0.9,
                    height = 0.9,
                    preview_cutoff = 120,
                },
            },
        },
    }
end

return {
    setup = setup,
}
