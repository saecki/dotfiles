local M = {}

local crates = require("crates")
local wk = require("which-key")
local shared = require("shared")

function M.setup()
    crates.setup({
        popup = {
            border = shared.window.border,
            show_version_date = true,
        },
        src = {
            cmp = {
                enabled = true,
            }
        },
        null_ls = {
            enabled = true,
        },
    })

    wk.register({
        ["<leader>c"] = {
            name = "Crates",
            ["t"] = { crates.toggle, "Toggle" },
            ["r"] = { crates.reload, "Reload" },

            ["v"] = { crates.show_versions_popup, "Versions popup" },
            ["f"] = { crates.show_features_popup, "Features popup" },
            ["d"] = { crates.show_dependencies_popup, "Dependencies popup" },

            ["u"] = { crates.update_crate, "Update crate" },
            ["U"] = { crates.upgrade_crate, "Upgrade crate" },
            ["a"] = { crates.update_all_crates, "Update all crates" },
            ["A"] = { crates.upgrade_all_crates, "Upgrade all crates" },

            ["H"] = { crates.open_homepage, "Open homepage" },
            ["R"] = { crates.open_repository, "Open repository" },
            ["D"] = { crates.open_documentation, "Open documentation" },
            ["C"] = { crates.open_crates_io, "Open crates.io" },
        },
    })
    wk.register({
        ["<leader>c"] = {
            name = "Crates",
            ["u"] = { ":lua require('crates').update_crates()<cr>", "Update selected crates" },
            ["U"] = { ":lua require('crates').upgrade_crates()<cr>", "Upgrade selected crates" },
        },
    }, {
        mode = "v",
    })
end

return M
