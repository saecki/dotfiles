local M = {}

local hl_ns = vim.api.nvim_create_namespace("user.config.lsp.server.dartls.hl")
local signs = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.INFO] = "",
    [vim.diagnostic.severity.HINT] = "",
}
local qf_sign_hls = {
    [vim.diagnostic.severity.ERROR] = "qfError",
    [vim.diagnostic.severity.WARN] = "qfWarning",
    [vim.diagnostic.severity.INFO] = "qfInfo",
    [vim.diagnostic.severity.HINT] = "qfHint",
}

-- Inspiration taken from `pqf.nvim`.
local function apply_highlights(buf, highlights)
    assert(buf ~= nil)
    for _,hl in ipairs(highlights) do
        vim.api.nvim_buf_set_extmark(buf, hl_ns, hl.line, hl.start_col, {
            end_col = hl.end_col,
            hl_group = hl.group,
        })
    end
end

-- `syntax/qf.vim` clears the default highlighting
function QUICKFIXTEXTFUNC(info)
    local list = vim.fn.getqflist({ id = info.id, qfbufnr = 0, items = 0 })

    local has_signs = false
    for _, item in ipairs(list.items) do
        has_signs = item.type ~= ""
    end

    local lines = {}
    local highlights = {}

    for idx = info.start_idx, info.end_idx do
        local line = ""
        local function push(text, group)
            local start_col = line:len()
            line = line .. text

            if group then
                local end_col = line:len()
                table.insert(highlights, {
                    line = idx - 1,
                    start_col = start_col,
                    end_col = end_col,
                    group = group,
                })
            end
        end

        local item = list.items[idx]
        if has_signs then
            local severity = vim.diagnostic.severity[item.type]
            local sign = (item.type ~= "") and item.type or " "
            local hl = "qfSign"
            if severity then
                sign = signs[severity]
                hl = qf_sign_hls[severity]
            end
            push(sign .. " ", hl)
        end

        local path = vim.fn.fnamemodify(vim.fn.bufname(item.bufnr), ":p:.")
        local text = vim.split(item.text, "\n")[1]

        push(path, "qfFileName")
        push(":", "qfSeparator")
        push(item.lnum, "qfLineNr")
        push(" ")
        push(text, "qfText")

        table.insert(lines, line)
    end

    vim.schedule(function()
        apply_highlights(list.qfbufnr, highlights)
    end)

    return lines
end

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

-- Update the quickfix window position.
---@param vsplit boolean
local function update_quickfix_position(winid, vsplit)
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

    update_quickfix_position(winid, vsplit)
end

function M.open_quickfix()
    vim.cmd.copen()

    local last_list = get_last_quickfix_list()
    update_quickfix_position(0, last_list and last_list.vsplit or false)
end

local function toggle_quickfix()
    if get_quickfix_window() then
        vim.cmd.cclose()
    else
        M.open_quickfix()
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

    M.open_quickfix()
end

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            text = signs,
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
    vim.opt.quickfixtextfunc = "v:lua.QUICKFIXTEXTFUNC"

    vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Toggle quickfix list" })
    vim.keymap.set("n", "<leader>Q", toggle_quickfix_position, { desc = "Toggle quickfix list position" })

    local function show_in_qflist(opts)
        return function()
            show_diagnostics_in_qflist(opts)
        end
    end
    vim.keymap.set("n", "<leader>ld", show_in_qflist({ buf = 0 }), { desc = "Buffer diagnostics" })
    vim.keymap.set("n", "<leader>lD", show_in_qflist({ buf = nil }), { desc = "Workspace diagnostics" })
end

return M
