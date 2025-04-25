local ferris = require("ferris")
local wk = require("which-key.config")

local M = {}

local use_clippy = false

local function setup_server(opts)
    opts = opts or {}
    local check_command = opts.check_command or nil -- defaults to cargo check
    vim.lsp.config("rust_analyzer", {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = check_command,
                },
                assist = {
                    importEnforceGranularity = true,
                    importGranularity = "module",
                    importPrefix = "crate",
                },
                inlayHints = {
                    maxLength = 40,
                },
            },
        },
    })
end

local function toggle_check_command()
    use_clippy = not use_clippy
    local cmd = use_clippy and "clippy" or "check"
    setup_server({ check_command = cmd })
    vim.notify("cargo " .. cmd, vim.log.levels.INFO)
end

function M.setup()
    setup_server()

    ferris.setup({
        create_commands = true,
        url_handler = vim.ui.open,
    })

    local group = vim.api.nvim_create_augroup("user.config.lsp.server.rust-analyzer", {})
    vim.api.nvim_create_autocmd("BufRead", {
        group = group,
        pattern = "*.rs",
        callback = function(ev)
            wk.add({
                buffer = ev.buf,
                { "<leader>ic",  toggle_check_command,               desc = "Rust check command" },
                { "<leader>ie",  "<cmd>FerrisExpandMacro<cr>",       desc = "Rust expand" },

                { "<leader>ivh", "<cmd>FerrisViewHIR<cr>",           desc = "Rust view HIR" },
                { "<leader>ivm", "<cmd>FerrisViewMIR<cr>",           desc = "Rust view MIR" },
                { "<leader>ivl", "<cmd>FerrisViewMemoryLayout<cr>",  desc = "Rust view memory layout" },
                -- TODO: support new viewSyntaxTree extension method
                -- { "<leader>ivs", "<cmd>FerrisViewSyntaxTree<cr>",    desc = "Rust view syntax tree",  mode = { "n", "v" } },
                { "<leader>ivi", "<cmd>FerrisViewItemTree<cr>",      desc = "Rust view item tree" },

                { "<leader>iom", "<cmd>FerrisOpenCargoToml<cr>",     desc = "Rust open manifest" },
                { "<leader>iop", "<cmd>FerrisOpenParentModule<cr>",  desc = "Rust open parent module" },
                { "<leader>iod", "<cmd>FerrisOpenDocumentation<cr>", desc = "Rust open docs" },

                { "<leader>ir",  "<cmd>FerrisReloadWorkspace<cr>",   desc = "Rust reload workspace" },
                { "<leader>im",  "<cmd>FerrisRebuildMacros<cr>",     desc = "Rust rebuild macros" },
            })
        end
    })
end

return M
