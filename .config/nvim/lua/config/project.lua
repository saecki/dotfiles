local M = {}

local project = require("project_nvim")
local telescope = require("telescope")
local maps = require("util.maps")

function M.setup()
    project.setup({})

    telescope.load_extension("projects")

    maps.nnoremap("<leader>fp", telescope.extensions.projects.projects)
end

return M
