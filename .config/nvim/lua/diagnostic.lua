local quickfix = require("quickfix")

local M = {}

local signs = {
    E = { symbol = "", hl = "DiagnosticSignError" },
    W = { symbol = "", hl = "DiagnosticSignWarn" },
    I = { symbol = "", hl = "DiagnosticSignInfo" },
    H = { symbol = "", hl = "DiagnosticSignHint" },
}

---@param opts vim.diagnostic.JumpOpts
local function map_jump(opts)
    opts.float = true
    return function()
        vim.diagnostic.jump(opts)
    end
end

---@param opts { buf: integer? }
local function show_diagnostics_in_qflist(opts)
    local title = opts.buf and "Buffer diagnostics" or "Workspace diagnostics"
    local diagnostics = vim.diagnostic.get(opts.buf, {
        severity = { min = vim.diagnostic.severity.INFO },
    })
    local items = vim.diagnostic.toqflist(diagnostics)
    quickfix.show(title, true, items)
end

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = signs.E.symbol,
                [vim.diagnostic.severity.WARN] = signs.W.symbol,
                [vim.diagnostic.severity.INFO] = signs.I.symbol,
                [vim.diagnostic.severity.HINT] = signs.H.symbol,
            },
        },
        underline = true,
        update_in_insert = true,
        severity_sort = true,
    })

    vim.keymap.set(
        "n", "[e",
        map_jump({ count = -1, severity = vim.diagnostic.severity.ERROR }),
        { desc = "Previous error" }
    )
    vim.keymap.set(
        "n", "]e",
        map_jump({ count = 1, severity = vim.diagnostic.severity.ERROR }),
        { desc = "Next error" }
    )
    vim.keymap.set("n", "[d", map_jump({ count = -1 }), { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", map_jump({ count = 1 }), { desc = "Next diagnostic" })

    -- Quickfix list
    quickfix.add_type_signs(signs)

    local function show_in_qflist(opts)
        return function()
            show_diagnostics_in_qflist(opts)
        end
    end
    vim.keymap.set("n", "<leader>ld", show_in_qflist({ buf = 0 }), { desc = "Buffer diagnostics" })
    vim.keymap.set("n", "<leader>lD", show_in_qflist({ buf = nil }), { desc = "Workspace diagnostics" })
end

return M
