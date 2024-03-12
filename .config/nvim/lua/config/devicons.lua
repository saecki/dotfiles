local devicons = require("nvim-web-devicons")

local M = {}

function M.setup()
    devicons.set_default_icon("", "#6d8086")
    local git = {
        icon = "",
        color = "#f14c28",
        cterm_color = "202",
        name = "Git",
    }
    devicons.setup({
        override = {
            ["Dockerfile"] = {
                icon = "",
                color = "#497dc7",
                cterm_color = "59",
                name = "Dockerfile",
            },
            ["git"] = git,
            [".gitattributes"] = git,
            [".gitconfig"] = git,
            [".gitignore"] = git,
            [".gitmodules"] = git,
            ["COMMIT_EDITMSG"] = git,
        },
    })
end

return M
