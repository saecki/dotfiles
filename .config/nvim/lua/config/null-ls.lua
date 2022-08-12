local M = {}

local null_ls = require("null-ls")
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local lsp_config = require("config.lsp")

local function parse_diagnostic(diagnostic, span, severity)
    return {
        message = diagnostic.desc,
        row = span.start.line + 1,
        end_row = span["end"].line + 1,
        col = span.start.col + 1,
        end_col = span["end"].col + 1,
        source = "cods",
        severity = severity,
    }
end

function M.setup()
    null_ls.setup({
        on_attach = lsp_config.on_attach,
        sources = {
            null_ls.builtins.diagnostics.teal,
            null_ls.builtins.formatting.stylua,
        },
    })

    local DIAGNOSTICS = methods.internal.DIAGNOSTICS

    local source = h.make_builtin({
        name = "cods",
        method = DIAGNOSTICS,
        filetypes = { "cods" },
        generator_opts = {
            command = "cods",
            args = { "check", "--format", "json", "$FILENAME" },
            format = "raw",
            check_exit_code = function()
                return true
            end,
            from_stderr = false,
            to_temp_file = true,
            on_output = function(params, done)
                local diagnostics = {}
                local ok, decoded = pcall(vim.json.decode, params.output)

                if not ok then
                    return done(diagnostics)
                end

                for _, d in ipairs(decoded.errors or {}) do
                    for _, s in ipairs(d.spans) do
                        table.insert(diagnostics, parse_diagnostic(d, s, h.diagnostics.severities.error))
                    end
                end
                for _, d in ipairs(decoded.warnings or {}) do
                    for _, s in ipairs(d.spans) do
                        table.insert(diagnostics, parse_diagnostic(d, s, h.diagnostics.severities.warning))
                    end
                end

                done(diagnostics)
            end,
        },

        factory = h.generator_factory,
    })

    null_ls.register(source)
end

return M
