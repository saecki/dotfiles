local wk = require("which-key.config")

local M = {}

local use_clippy = false
local split_win = nil

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

local macro_expansion_handler = function(_, result)
    if result == nil then
        vim.notify("No expansion")
        return
    end

    local lines = vim.split(result.expansion, "\n")
    table.insert(lines, 1, string.format("// expansion of `%s`", result.name))

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    -- vim.api.nvim_buf_set_name(buf, result.name)
    vim.bo[buf].filetype = "rust"

    if split_win and vim.api.nvim_win_is_valid(split_win) then
        vim.api.nvim_win_set_buf(split_win, buf)
    else
        split_win = vim.api.nvim_open_win(buf, false, {
            win = 0,
            split = "right",
        })
    end
end

local function expand_macro()
    local client = vim.lsp.get_clients({ name = "rust_analyzer" })[1]
    if not client then
        vim.notify("rust_analyzer is not attached")
        return
    end

    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:request("rust-analyzer/expandMacro", params, macro_expansion_handler)
end

function M.setup()
    setup_server()

    local group = vim.api.nvim_create_augroup("user.config.lsp.server.rust-analyzer", {})
    vim.api.nvim_create_autocmd("BufRead", {
        group = group,
        pattern = "*.rs",
        callback = function(ev)
            wk.add({
                { "<leader>ic", toggle_check_command, desc = "Rust check command", buffer = ev.buf },
                { "<leader>ie", expand_macro,         desc = "Rust expand",        buffer = ev.buf },
            })
        end
    })
end

return M
