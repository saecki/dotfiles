local M = {}

local crates = require("crates")
local wk = require("which-key")
local shared = require("shared")
local lsp_config = require("config.lsp")

function M.setup()
    crates.setup({
        autoupdate_throttle = 50,
        max_parallel_requests = 32,
        popup = {
            border = shared.window.border,
            show_version_date = true,
        },
        src = {
            cmp = {
                use_custom_kind = true,
            },
        },
        lsp = {
            enabled = true,
            on_attach = lsp_config.on_attach,
            actions = true,
            completion = true,
            hover = true,
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

            ["x"] = { crates.expand_plain_crate_to_inline_table, "Expand to inline table" },
            ["X"] = { crates.extract_crate_into_table, "Extract into table" },

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
