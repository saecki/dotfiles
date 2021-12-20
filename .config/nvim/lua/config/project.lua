local M = {}

local project = require("project_nvim")
local telescope = require("telescope")
local maps = require("util.maps")
local wk = require("which-key")

function M.setup()
    project.setup({})

    telescope.load_extension("projects")

    wk.register({
        ["<leader>f"] = {
            name = "Find",
            ["p"] = { telescope.extensions.projects.projects, "Projects" },
        },
    })
end

return M
