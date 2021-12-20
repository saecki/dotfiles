local M = {}

local crates = require("crates")
local wk = require("which-key")
local maps = require("util.maps")

function M.setup()
    crates.setup({
        popup = {
            version_date = true,
        },
    })

    wk.register({
        ["<leader>c"] = {
            name = "Crates",
            ["t"] = { crates.toggle, "Toggle" },
            ["r"] = { crates.reload, "Reload" },

            ["v"] = { crates.show_versions_popup, "Versions popup" },
            ["f"] = { crates.show_features_popup, "Features popup" },

            ["u"] = { crates.update_crate, "Update crate" },
            ["U"] = { crates.upgrade_crate, "Upgrade crates" },
            ["a"] = { crates.update_all_crates, "Update all crate" },
            ["A"] = { crates.upgrade_all_crates, "Upgrade all crates" },
        },
    })
    wk.register({
        ["<leader>c"] = {
            name = "Crates",
            ["u"] = { crates.update_crates, "Update crates" },
            ["U"] = { crates.upgrade_crates, "Upgrade crates" },
        },
    }, {
        mode = "v",
    })
end

return M
