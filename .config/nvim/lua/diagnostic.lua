local M = {}

---@param opts vim.diagnostic.JumpOpts
local function map_jump(opts)
    opts.float = true
    return function()
        vim.diagnostic.jump(opts)
    end
end

---Get the window id of the currently open quickfix window.
---@return integer?
local function get_quickfix_window()
    for _, wininfo in ipairs(vim.fn.getwininfo()) do
        if wininfo.quickfix == 1 then
            return wininfo.winid
        end
    end
end

---Get the the last quickfix list and context assoctiated with it.
---@return { id: integer, title: string?, vsplit: boolean }?
local function get_last_quickfix_list()
    local last_list = vim.fn.getqflist({ nr = "$", id = 0, title = 0, context = 0 })
    if not last_list then
        return nil
    end

    -- Store the preferred position of the quickfix window in the list context.
    local vsplit = type(last_list.context) == "table"
        and last_list.context.vsplit

    return {
        id = last_list.id,
        title = last_list.title,
        vsplit = vsplit,
    }
end

local function toggle_quickfix_position()
    local last_list = get_last_quickfix_list()
    if not last_list then return end

    local vsplit = not last_list.vsplit

    -- Update the context of the quickfix list.
    vim.fn.setqflist({}, "a", {
        id = last_list.id,
        context = { vsplit = vsplit },
        items = {}
    })

    local winid = get_quickfix_window()
    if not winid then
        vim.cmd.copen()
        winid = vim.api.nvim_get_current_win()
    end

    -- Update the window position.
    if vsplit then
        vim.api.nvim_set_current_win(winid)
        vim.cmd.wincmd("L")
        vim.api.nvim_win_set_width(0, 90)
    else
        vim.api.nvim_set_current_win(winid)
        vim.cmd.wincmd("J")
        vim.api.nvim_win_set_height(0, 10)
    end
end

local function open_quickfix()
    vim.cmd.copen()

    local last_list = get_last_quickfix_list()
    if last_list and last_list.vsplit then
        vim.cmd.wincmd("L")
        vim.api.nvim_win_set_width(0, 90)
    end
end

local function toggle_quickfix()
    if get_quickfix_window() then
        vim.cmd.cclose()
    else
        open_quickfix()
    end
end

---@param opts { buf: integer? }
local function show_diagnostics_in_qflist(opts)
    local diagnostics = vim.diagnostic.get(opts.buf, {
        severity = { min = vim.diagnostic.severity.INFO },
    })

    local title = opts.buf and "Buffer diagnostics" or "Workspace diagnostics"
    local diag_list = get_last_quickfix_list()
    if diag_list and diag_list.title ~= title then
        diag_list = nil
    end

    -- Update existing diagnostic quickfix list if it's the last one.
    local quickfix_id = diag_list and diag_list.id or nil

    -- Split diagnostic windows to the right by default.
    local vsplit = diag_list and diag_list.vsplit
    if vsplit == nil then
        vsplit = true
    end

    vim.fn.setqflist({}, quickfix_id and 'u' or ' ', {
        id = quickfix_id,
        title = title,
        context = { vsplit = vsplit },
        items = vim.diagnostic.toqflist(diagnostics),
    })

    open_quickfix()
end

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.INFO] = "",
                [vim.diagnostic.severity.HINT] = "",
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

    local function show_in_qflist(opts)
        return function()
            show_diagnostics_in_qflist(opts)
        end
    end
    vim.keymap.set("n", "<leader>ld", show_in_qflist({ buf = 0 }), { desc = "Buffer diagnostics" })
    vim.keymap.set("n", "<leader>lD", show_in_qflist({ buf = nil }), { desc = "Workspace diagnostics" })

    vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Toggle quickfix list" })
    vim.keymap.set("n", "<leader>Q", toggle_quickfix_position, { desc = "Toggle quickfix list position" })
end

return M
